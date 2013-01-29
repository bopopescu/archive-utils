package com.lockerz.common.spring.jpa;

import com.google.common.base.Function;
import com.google.common.base.Joiner;
import com.google.common.base.Strings;
import com.google.common.collect.Maps;
import com.google.common.collect.Sets;
import com.lockerz.common.spring.app.SpringAppConfig;
import com.lockerz.common.spring.jedis.DefaultJedisPubSub;
import com.lockerz.common.spring.jedis.JedisClient;
import org.apache.openjpa.event.TCPRemoteCommitProvider;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPubSub;

import java.util.Map;
import java.util.Set;

/**
 * @author Brian Gebala
 * @version 1/29/13 11:14 AM
 */
public class JpaRemoteCacheService {
    private enum Message {
        RELOAD
    }

    private final static Logger LOGGER = LoggerFactory.getLogger(JpaRemoteCacheService.class);

    private Map<String, TCPRemoteCommitProvider> _commitProviderMap = Maps.newHashMap();
    private JedisClient _jedis;
    private String _pubSubChannel;
    private String _appIp;
    private volatile boolean _running;

    public void init() {
        _appIp = SpringAppConfig.getAppIp();
        _pubSubChannel = SpringAppConfig.getAppName() + "-jpa-remote-cache-channel";

        final JedisPubSub pubSub = new DefaultJedisPubSub() {
            @Override
            public void onMessage(final String channel, final String message) {
                if (!_running) {
                    LOGGER.info("onMessage() service no longer running, ignoring message");
                    return;
                }

                if (message.startsWith(Message.RELOAD.name())) {
                    String persistenceUnit = getPersistenceUnitFromReloadMessage(message);
                    LOGGER.info("onMessage(): channel={}, message={}", channel, message);
                    reload(persistenceUnit);
                }
                else {
                    LOGGER.error("onMessage() unknown message: channel={}, message={}", channel, message);
                }
            }
        };

        Thread pubSubSubscribeThread = new Thread(new Runnable() {
            @Override
            public void run() {
                _jedis.work(new Function<Jedis, Void>() {
                    @Override
                    public Void apply(final Jedis jedis) {
                        jedis.subscribe(pubSub, _pubSubChannel);
                        return null;
                    }
                });
            }
        });

        _running = true;
        pubSubSubscribeThread.start();

        LOGGER.info("init() successful");
    }

    public void shutdown() {
        _running = false;

        for (Map.Entry<String, TCPRemoteCommitProvider> entry : _commitProviderMap.entrySet()) {
            String persistenceUnit = entry.getKey();
            TCPRemoteCommitProvider provider = entry.getValue();
            final String setKey = getAddressesSetKey(persistenceUnit);
            final String myAddress = getMyAddress(provider);

            _jedis.work(new Function<Jedis, Object>() {
                @Override
                public Object apply(final Jedis jedis) {
                    jedis.srem(setKey, myAddress);
                    return null;
                }
            });

            publishReloadMessage(persistenceUnit);
        }

        LOGGER.info("shutdown() successful");
    }

    public void setJedis(final JedisClient jedis) {
        _jedis = jedis;
    }

    public synchronized void register(final String persistenceUnit,
                                      final TCPRemoteCommitProvider provider) {
        final String myAddress = getMyAddress(provider);

        _jedis.work(new Function<Jedis, Object>() {
            @Override
            public Object apply(final Jedis jedis) {
                String setKey = getAddressesSetKey(persistenceUnit);
                jedis.sadd(setKey, myAddress);
                return null;
            }
        });

        _commitProviderMap.put(persistenceUnit, provider);

        try {
            provider.setAddresses("");
        }
        catch (Exception ex) {
            LOGGER.error("register() error clearing provider addresses: persistenceUnit=" + persistenceUnit, ex);
        }

        publishReloadMessage(persistenceUnit);
        LOGGER.info("register() successful: persistenceUnit={}", persistenceUnit);
    }

    public synchronized void publishReloadMessage(final String persistenceUnit) {
        _jedis.work(new Function<Jedis, Object>() {
            @Override
            public Object apply(final Jedis jedis) {
                jedis.publish(_pubSubChannel, getReloadMessage(persistenceUnit));
                LOGGER.info("publishReloadMessage() successful: channel={}", _pubSubChannel);
                return null;
            }
        });
    }

    private synchronized void reload(final String persistenceUnit) {
        _jedis.work(new Function<Jedis, Void>() {
            @Override
            public Void apply(final Jedis jedis) {
                String setKey = getAddressesSetKey(persistenceUnit);
                Set<String> addressesFromRedis = jedis.smembers(setKey);
                String myAddress = getMyAddress(_commitProviderMap.get(persistenceUnit));

                addressesFromRedis.remove(myAddress);

                String addressesFromRedisConfigVal = getAddressesConfigVal(addressesFromRedis);

                try {
                    TCPRemoteCommitProvider provider = _commitProviderMap.get(persistenceUnit);
                    provider.setAddresses(addressesFromRedisConfigVal);
                    LOGGER.info("reload() successful: persistenceUnit={}, addresses={}",
                            persistenceUnit, getAddressesConfigValOrNone(addressesFromRedisConfigVal));
                }
                catch (Exception ex) {
                    LOGGER.error("reload() error: persistenceUnit=" + persistenceUnit + ", addresses="
                            + getAddressesConfigValOrNone(addressesFromRedisConfigVal), ex);
                }

                return null;
            }
        });
    }

    private String getAddressesSetKey(final String persistenceUnit) {
        return SpringAppConfig.getAppName() + "-jpa-remote-cache-addresses-" + persistenceUnit;
    }

    private String getAddressesConfigVal(final Set<String> addresses) {
        Set<String> addressesOrdered = Sets.newTreeSet();
        addressesOrdered.addAll((addresses));
        return Joiner.on(';').join(addressesOrdered);
    }

    private String getMyAddress(final TCPRemoteCommitProvider provider) {
        return _appIp + ":" + provider.getPort();
    }

    private String getReloadMessage(final String persistenceUnit) {
        return Message.RELOAD.name() + ":" + persistenceUnit;
    }

    private String getPersistenceUnitFromReloadMessage(final String message) {
        return message.replace(Message.RELOAD.name() + ":", "");
    }

    private String getAddressesConfigValOrNone(final String val) {
        if (Strings.isNullOrEmpty(val)) {
            return "<none>";
        }

        return val;
    }
}
