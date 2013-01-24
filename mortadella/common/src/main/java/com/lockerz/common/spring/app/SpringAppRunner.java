package com.lockerz.common.spring.app;

import com.google.common.base.Strings;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.util.concurrent.CountDownLatch;

/**
 * @author Brian Gebala
 * @version 1/22/13 2:28 PM
 */
public class SpringAppRunner {
    private final static Logger log = LoggerFactory.getLogger(SpringAppRunner.class);
    private final static String APP_ENV_SYS_PROPERTY = "app.env";

    private CountDownLatch _latch = new CountDownLatch(1);
    private String[] _contextFiles;

    public SpringAppRunner(final String[] contextFiles) {
        _contextFiles = contextFiles;

        String appEnv = System.getProperty(APP_ENV_SYS_PROPERTY);

        if (Strings.isNullOrEmpty(appEnv)) {
            System.setProperty(APP_ENV_SYS_PROPERTY, "dev");
        }
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
        final ClassPathXmlApplicationContext ctx = new ClassPathXmlApplicationContext();

        ctx.setConfigLocations(_contextFiles);
        ctx.refresh();

        long afterRefresh = System.currentTimeMillis();
        ctx.start();
        long afterStart = System.currentTimeMillis();

        log.info("STARTUP TIMING Spring time to refresh: " + (afterRefresh - beforeSpring));
        log.info("STARTUP TIMING Spring time to start: " + (afterStart - afterRefresh));
        log.info("STARTUP TIMING Spring total: " + (afterStart - beforeSpring));

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
