package com.lockerz.common.spring.config;

import org.springframework.beans.factory.config.PropertyPlaceholderConfigurer;

/**
 * @author Brian Gebala
 * @version 1/22/13 1:56 PM
 */
public class NonValidatingPropertyPlaceholderConfigurer extends PropertyPlaceholderConfigurer {
    private final static int ORDER = 1000;

    public NonValidatingPropertyPlaceholderConfigurer() {
        super.setIgnoreUnresolvablePlaceholders(true);
        super.setOrder(ORDER);
        super.setSystemPropertiesMode(SYSTEM_PROPERTIES_MODE_OVERRIDE);
    }

    @Override
    public final void setIgnoreUnresolvablePlaceholders(final boolean ignoreUnresolvablePlaceholders) {
        throw new UnsupportedOperationException("Cannot set ignoreUnresolvablePlaceholders on a "
                + getClass().getSimpleName());
    }

    @Override
    public final void setOrder(final int order) {
        throw new UnsupportedOperationException("Cannot set ignoreUnresolvablePlaceholders on a "
                + getClass().getSimpleName());
    }
}
