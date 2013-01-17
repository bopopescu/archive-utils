package com.lockerz.meatshop.model2;

import com.google.inject.PrivateModule;
import com.google.inject.persist.jpa.JpaPersistModule;

/**
 * @author Brian Gebala
 * @version 1/17/13 9:08 AM
 */
public class Model2Module extends PrivateModule {
    @Override
    protected void configure() {
        install(new JpaPersistModule("model2"));

        bind(JpaInitializer.class).asEagerSingleton();

        bind(AddressDao.class).to(AddressDaoImpl.class).asEagerSingleton();
        expose(AddressDao.class);
    }
}
