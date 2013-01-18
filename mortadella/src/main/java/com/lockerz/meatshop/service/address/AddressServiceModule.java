package com.lockerz.meatshop.service.address;

import com.google.inject.AbstractModule;

/**
 * @author Brian Gebala
 * @version 1/18/13 1:02 PM
 */
public class AddressServiceModule extends AbstractModule {
    @Override
    protected void configure() {
        bind(AddressService.class).to(AddressServiceImpl.class).asEagerSingleton();
    }
}
