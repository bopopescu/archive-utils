package com.lockerz.meatshop;

import com.google.inject.AbstractModule;
import com.google.inject.name.Names;
import com.lockerz.meatshop.jpa.JpaContextAware;
import com.lockerz.meatshop.jpa.JpaContextAwareInterceptor;
import com.lockerz.meatshop.jpa.JpaContextService;

import java.util.Properties;

import static com.google.inject.matcher.Matchers.annotatedWith;
import static com.google.inject.matcher.Matchers.any;

/**
 * @author Brian Gebala
 * @version 1/16/13 3:27 PM
 */
public class AppModule extends AbstractModule {
    private Properties _properties;

    public AppModule(final Properties properties) {
        _properties = properties;
    }

    @Override
    protected void configure() {
        Names.bindProperties(binder(), _properties);
        bind(JpaContextService.class).asEagerSingleton();

        JpaContextAwareInterceptor contextInterceptor = new JpaContextAwareInterceptor();
        requestInjection(contextInterceptor);
        bindInterceptor(annotatedWith(JpaContextAware.class), any(), contextInterceptor);
    }
}
