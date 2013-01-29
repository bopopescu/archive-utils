package com.lockerz.common.spring.jedis;

import redis.clients.jedis.JedisPubSub;

/**
 * @author Brian Gebala
 * @version 1/29/13 12:36 PM
 */
public class DefaultJedisPubSub extends JedisPubSub {
    @Override
    public void onMessage(final String channel, final String message) {
        // Empty.
    }

    @Override
    public void onPMessage(final String pattern, final String channel, final String message) {
        // Empty.
    }

    @Override
    public void onSubscribe(final String channel, final int subscribedChannels) {
        // Empty.
    }

    @Override
    public void onUnsubscribe(final String pattern, final int subscribedChannels) {
        // Empty.
    }

    @Override
    public void onPUnsubscribe(final String pattern, final int subscribedChannels) {
        // Empty.
    }

    @Override
    public void onPSubscribe(final String pattern, final int subscribedChannels) {
        // Empty.
    }
}
