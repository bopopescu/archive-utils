package com.lockerz.common.spring.jedis;

import com.google.common.base.Function;
import redis.clients.jedis.Jedis;

/**
 * @author Brian Gebala
 * @version 1/29/13 12:26 PM
 */
public interface JedisClient {
    public <T> T work(Function<Jedis, T> f);
}
