package com.lockerz.meatshop;

import com.google.inject.AbstractModule;
import com.google.inject.name.Names;

import java.io.FileReader;
import java.io.IOException;
import java.util.Properties;

/**
 * @author Brian Gebala
 * @version 1/16/13 3:27 PM
 */
public class PropertiesModule extends AbstractModule {
    private Properties _properties;

    public PropertiesModule(final Properties properties) {
        _properties = properties;
    }

    @Override
    protected void configure() {
        Names.bindProperties(binder(), _properties);
    }
}
