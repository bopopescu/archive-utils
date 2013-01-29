package com.lockerz.common.spring.jedis;

import com.google.common.base.Function;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.exceptions.JedisConnectionException;

/**
 * @author Brian Gebala
 * @version 1/29/13 12:27 PM
 */
public class JedisClientImpl implements JedisClient {
    private static final Logger log = LoggerFactory.getLogger(JedisClientImpl.class);

    private JedisPool jedisPool;

    /*
     * Handle timed out connections. Also must handle redis being down.
     * If redis is down, an exponential backoff will be employed.
     *
     * TODO Should at the very least give some option (e.g. method
     * argument) to not use Thread.sleep.
     */
    @Override
    public <T> T work(Function<Jedis, T> f) {
        boolean first = true;
        long sleepTime = 10l;
        while (true) {
            try {
                return doWork(f);
            } catch (JedisConnectionException e) {
                log.debug(e.getMessage(), e);
                if (!first) {
                    if (sleepTime > 200l) {
                        throw e;
                    }
                    try {
                        Thread.sleep(sleepTime);
                    } catch (InterruptedException e2) {
                        throw new RuntimeException(e2);
                    }
                    sleepTime *= 2;
                }
            }
            first = false;
        }
    }

    private <T> T doWork(Function<Jedis, T> f) {
        Jedis jedis = jedisPool.getResource();
        boolean isBroken = false;
        try {
            return f.apply(jedis);
        } catch (JedisConnectionException e) {
            isBroken = true;
            throw e;
        } finally {
            if (jedis != null) {
                if (isBroken) {
                    jedisPool.returnBrokenResource(jedis);
                } else {
                    jedisPool.returnResource(jedis);
                }
            }
        }
    }

    public void setJedisPool(JedisPool jedisPool) {
        this.jedisPool = jedisPool;
    }
}
