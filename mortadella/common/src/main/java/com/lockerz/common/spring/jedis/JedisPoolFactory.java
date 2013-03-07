package com.lockerz.common.spring.jedis;

import org.apache.commons.pool.impl.GenericObjectPool;
import org.springframework.beans.factory.FactoryBean;
import redis.clients.jedis.JedisPool;

/**
 * @author Brian Gebala
 * @version 1/29/13 12:27 PM
 */
public class JedisPoolFactory implements FactoryBean<JedisPool> {
    private String _host;
    private int _port;
    private int _maxActive;

    public void setHost(final String host) {
        _host = host;
    }

    public void setPort(final int port) {
        _port = port;
    }

    public void setMaxActive(final int maxActive) {
        _maxActive = maxActive;
    }

    @Override
    public JedisPool getObject() throws Exception {
        GenericObjectPool.Config config = new GenericObjectPool.Config();
        config.maxActive = _maxActive;

        return new JedisPool(config, _host, _port);
    }

    @Override
    public Class<?> getObjectType() {
        return JedisPool.class;
    }

    @Override
    public boolean isSingleton() {
        return false;
    }
}
