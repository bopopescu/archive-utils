package com.lockerz.meatshop.service.shop.dao;

import com.google.inject.PrivateModule;
import com.lockerz.meatshop.jpa.JpaProviderServiceModule;

import java.util.Properties;

/**
 * @author Brian Gebala
 * @version 1/15/13 1:38 PM
 */
public class ShopDaoModule extends PrivateModule {
    private Properties _properties;

    public ShopDaoModule(final Properties properties) {
        _properties = properties;
    }

    @Override
    protected void configure() {
        Properties jpaProps = new Properties();
        jpaProps.put("openjpa.ConnectionDriverName", "com.mysql.jdbc.Driver");
        jpaProps.put("openjpa.ConnectionURL", _properties.get("user.dao.dbUrl"));
        jpaProps.put("openjpa.ConnectionUserName", _properties.get("user.dao.username"));
        jpaProps.put("openjpa.ConnectionPassword", _properties.get("user.dao.password"));
        jpaProps.put("openjpa.jdbc.DBDictionary", "mysql");
        jpaProps.put("openjpa.Log", "slf4j");
        jpaProps.put("openjpa.ConnectionFactoryProperties", "PrintParameters=true");
        jpaProps.put("openjpa.ConnectionProperties", _properties.get("user.dao.connectionProps"));
        jpaProps.put("openjpa.DataCache", "true");
        jpaProps.put("openjpa.QueryCache", "true");
        jpaProps.put("openjpa.RemoteCommitProvider", "sjvm");

        JpaProviderServiceModule jpa = new JpaProviderServiceModule("meatshop", jpaProps);
        install(jpa);

        bind(JpaInitializer.class).asEagerSingleton();

        bind(UserDao.class).to(UserDaoImpl.class).asEagerSingleton();
        expose(UserDao.class);

        bind(ShopDao.class).to(ShopDaoImpl.class).asEagerSingleton();
        expose(ShopDao.class);

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
