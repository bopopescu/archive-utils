package com.lockerz.common.spring.config;

import org.springframework.beans.factory.config.PropertyPlaceholderConfigurer;

/**
 * @author Brian Gebala
 * @version 1/23/13 2:58 PM
 */
public class ValidatingPropertyPlaceholderConfigurer extends PropertyPlaceholderConfigurer {
    private final static int ORDER = 10000;

    public ValidatingPropertyPlaceholderConfigurer() {
        super.setIgnoreUnresolvablePlaceholders(false);
        super.setOrder(ORDER);
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
