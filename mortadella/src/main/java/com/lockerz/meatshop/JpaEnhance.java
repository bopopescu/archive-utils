package com.lockerz.meatshop;

import org.apache.openjpa.enhance.PCEnhancer;
import org.apache.openjpa.lib.util.Options;

/**
 * @author Brian Gebala
 * @version 1/22/13 9:23 AM
 */
public class JpaEnhance {
    public static void main(final String[] args) {
        PCEnhancer.run(new String[] {}, new Options());
    }
}
