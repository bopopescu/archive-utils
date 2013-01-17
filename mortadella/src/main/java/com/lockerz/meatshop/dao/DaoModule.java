package com.lockerz.meatshop.dao;

import com.google.inject.PrivateModule;
import com.google.inject.persist.jpa.JpaPersistModule;

/**
 * @author Brian Gebala
 * @version 1/15/13 1:38 PM
 */
public class DaoModule extends PrivateModule {
    @Override
    protected void configure() {
        install(new JpaPersistModule("meatshop"));

        bind(JpaInitializer.class).asEagerSingleton();

        bind(ShopDao.class).to(ShopDaoImpl.class).asEagerSingleton();
        expose(ShopDao.class);

        bind(UserDao.class).to(UserDaoImpl.class).asEagerSingleton();
        expose(UserDao.class);

        // Binding via a Provider will produce a non-AOP-wrapped UserDao bean.
        //bind(UserDao.class).toProvider(UserDaoProvider.class).asEagerSingleton();
        //expose(UserDao.class);
    }

    /*
    // Binding via @Provides will produce a non-AOP-wrapped UserDao bean.
    @Provides
    public UserDao provideUserDao() {
        return new UserDaoImpl();
    }
    */
}
