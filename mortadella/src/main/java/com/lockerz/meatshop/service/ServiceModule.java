package com.lockerz.meatshop.service;

import com.google.inject.AbstractModule;

/**
 * @author Brian Gebala
 * @version 1/16/13 9:35 AM
 */
public class ServiceModule extends AbstractModule {
    @Override
    protected void configure() {
        bind(ShopService.class).to(ShopServiceImpl.class);
    }
}
