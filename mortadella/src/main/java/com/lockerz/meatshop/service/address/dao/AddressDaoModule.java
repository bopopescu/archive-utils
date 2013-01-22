package com.lockerz.meatshop.service.address.dao;

import com.google.inject.PrivateModule;
import com.google.inject.persist.jpa.JpaPersistModule;
import com.lockerz.meatshop.jpa.JpaProviderServiceModule;

import java.util.Properties;

/**
 * @author Brian Gebala
 * @version 1/17/13 9:08 AM
 */
public class AddressDaoModule extends PrivateModule {
    private Properties _properties;

    public AddressDaoModule(final Properties properties) {
        _properties = properties;
    }

    @Override
    protected void configure() {
        Properties jpaProps = new Properties();
        jpaProps.put("openjpa.ConnectionDriverName", "org.postgresql.Driver");
        jpaProps.put("openjpa.ConnectionURL", _properties.get("address.dao.dbUrl"));
        jpaProps.put("openjpa.ConnectionUserName", _properties.get("address.dao.username"));
        jpaProps.put("openjpa.ConnectionPassword", _properties.get("address.dao.password"));
        jpaProps.put("openjpa.jdbc.DBDictionary", "postgres");
        jpaProps.put("openjpa.Log", "slf4j");
        jpaProps.put("openjpa.ConnectionFactoryProperties", "PrintParameters=true");
        jpaProps.put("openjpa.ConnectionProperties", _properties.get("address.dao.connectionProps"));
        jpaProps.put("openjpa.DataCache", "true");
        jpaProps.put("openjpa.QueryCache", "true");
        jpaProps.put("openjpa.RemoteCommitProvider", "sjvm");

        JpaProviderServiceModule jpa = new JpaProviderServiceModule("address", jpaProps);
        install(jpa);

        bind(JpaInitializer.class).asEagerSingleton();

        bind(AddressDao.class).to(AddressDaoImpl.class).asEagerSingleton();
        expose(AddressDao.class);
    }
}
