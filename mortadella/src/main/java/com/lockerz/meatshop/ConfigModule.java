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
public class ConfigModule extends AbstractModule {
    @Override
    protected void configure() {
        try {
            Properties properties = new Properties();
            properties.load(new FileReader("app.properties"));
            Names.bindProperties(binder(), properties);
        } catch (IOException ex) {
            System.out.println(ex);
        }
    }
}
