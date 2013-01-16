package com.lockerz.meatshop.dao;

import com.google.inject.AbstractModule;
import com.google.inject.persist.jpa.JpaPersistModule;

/**
 * @author Brian Gebala
 * @version 1/15/13 1:38 PM
 */
public class DaoModule extends AbstractModule {
    @Override
    protected void configure() {
        install(new JpaPersistModule("default"));
        bind(JpaInitializer.class).asEagerSingleton();
        bind(ShopDao.class).to(ShopDaoImpl.class).asEagerSingleton();
        bind(UserDao.class).to(UserDaoImpl.class).asEagerSingleton();
    }
}
