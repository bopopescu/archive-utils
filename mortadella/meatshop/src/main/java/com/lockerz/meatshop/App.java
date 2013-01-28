package com.lockerz.meatshop;

import com.lockerz.common.spring.app.SpringAppRunner;
import org.apache.openjpa.enhance.PCEnhancer;
import org.apache.openjpa.lib.util.Options;

/**
 * @author Brian Gebala
 * @version 1/15/13 1:08 PM
 */
public class App {
    public static void main(final String[] args) {
        PCEnhancer.run(new String[]{}, new Options());
        SpringAppRunner appRunner = new SpringAppRunner(new String[] {"classpath:app-context.xml", "classpath:jpa-context.xml", "classpath:web-context.xml"});
        appRunner.start();
        appRunner.waitForShutdown();
    }
}
