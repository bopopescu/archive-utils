package com.lockerz.common.spring.app;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.util.concurrent.CountDownLatch;

/**
 * @author Brian Gebala
 * @version 1/22/13 2:28 PM
 */
public class SpringAppRunner {
    private final static Logger LOGGER = LoggerFactory.getLogger(SpringAppRunner.class);

    private CountDownLatch _latch = new CountDownLatch(1);
    private String[] _contextFiles;

    public SpringAppRunner(final String contextFile) {
        this (new String[] { contextFile} );
    }

    public SpringAppRunner(final String[] contextFiles) {
        _contextFiles = contextFiles;
    }

    public void waitForShutdown() {
        try {
            _latch.await();
        }
        catch (Exception ex) {
            throw new RuntimeException(ex);
        }
    }

    public ClassPathXmlApplicationContext start() {
        long beforeSpring = System.currentTimeMillis();

        LOGGER.info("app.env={}, app.ip={}, app.home={}, app.name={}",
                new Object[] { SpringAppConfig.getAppEnv(), SpringAppConfig.getAppIp(), SpringAppConfig.getAppHome(), SpringAppConfig.getAppName() });

        final ClassPathXmlApplicationContext ctx = new ClassPathXmlApplicationContext();

        ctx.setConfigLocations(_contextFiles);
        ctx.refresh();

        long afterRefresh = System.currentTimeMillis();
        ctx.start();
        long afterStart = System.currentTimeMillis();

        LOGGER.info("STARTUP TIMING Spring time to refresh: " + (afterRefresh - beforeSpring));
        LOGGER.info("STARTUP TIMING Spring time to start: " + (afterStart - afterRefresh));
        LOGGER.info("STARTUP TIMING Spring total: " + (afterStart - beforeSpring));

        ThreadGroup tg = new ThreadGroup("SpringAppRunner");
        tg.setDaemon(true);


        Runtime.getRuntime().addShutdownHook(new Thread("Shutdown") {
            @Override
            public void run() {
                ctx.close();
                _latch.countDown();
            }
        });

        return ctx;
    }
}
