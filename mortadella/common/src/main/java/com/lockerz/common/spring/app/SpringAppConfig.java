package com.lockerz.common.spring.app;

import com.google.common.base.Preconditions;
import com.google.common.base.Strings;

/**
 * @author Brian Gebala
 * @version 1/28/13 3:45 PM
 */
public class SpringAppConfig {
    private final static String DEFAULT_APP_ENV = "dev";
    private final static String DEFAULT_APP_IP = "127.0.0.1";

    private final static String SYSTEM_PROP_APP_ENV = "app.env";
    private final static String SYSTEM_PROP_APP_HOME = "app.home";
    private final static String SYSTEM_PROP_APP_IP = "app.ip";
    private final static String SYSTEM_PROP_APP_NAME = "app.name";

    public static String getAppEnv() {
        String env = System.getProperty(SYSTEM_PROP_APP_ENV);

        if (Strings.isNullOrEmpty(env)) {
            env = DEFAULT_APP_ENV;
            // Need to set this property default so it can be resolved by Spring.
            System.setProperty(SYSTEM_PROP_APP_ENV, env);
        }

        return env;
    }

    public static String getAppHome() {
        String appHome = System.getProperty(SYSTEM_PROP_APP_HOME);
        Preconditions.checkState(!Strings.isNullOrEmpty(appHome), "The app.home system property is not set!");
        return appHome;
    }

    public static String getAppIp() {
        String ip = System.getProperty(SYSTEM_PROP_APP_IP);

        if (Strings.isNullOrEmpty(ip)) {
            ip = DEFAULT_APP_IP;
        }

        return ip;
    }

    public static String getAppName() {
        String appName = System.getProperty(SYSTEM_PROP_APP_NAME);
        Preconditions.checkState(!Strings.isNullOrEmpty(appName), "The app.name system property is not set!");
        return appName;
    }
}
