package com.lockerz.meatshop.jpa;

import com.google.inject.AbstractModule;

import javax.persistence.EntityManager;
import java.util.Properties;

import static com.google.inject.matcher.Matchers.annotatedWith;
import static com.google.inject.matcher.Matchers.any;

/**
 * @author Brian Gebala
 * @version 1/18/13 10:09 AM
 */
public class JpaProviderServiceModule extends AbstractModule {
    private String _persistenceUnitName;
    private Properties _properties;

    public JpaProviderServiceModule(final String persistenceUnitName, final Properties properties) {
        _persistenceUnitName = persistenceUnitName;
        _properties = properties;
    }

    @Override
    protected void configure() {
        bindConstant().annotatedWith(JpaProviderServiceConfig.class).to(_persistenceUnitName);
        bind(Properties.class).annotatedWith(JpaProviderServiceConfig.class).toInstance(_properties);
        bind(JpaProviderService.class).asEagerSingleton();
        bind(EntityManager.class).toProvider(JpaProviderService.class);

        JpaTransactionalInterceptor transactionalInterceptor = new JpaTransactionalInterceptor();
        requestInjection(transactionalInterceptor);
        bindInterceptor(annotatedWith(JpaTransactional.class), any(), transactionalInterceptor);
    }
}
