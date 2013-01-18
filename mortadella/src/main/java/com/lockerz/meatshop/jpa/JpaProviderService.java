package com.lockerz.meatshop.jpa;

import com.google.common.util.concurrent.AbstractIdleService;
import com.google.inject.Inject;
import com.google.inject.Provider;
import com.google.inject.Singleton;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import java.util.Properties;

/**
 * @author Brian Gebala
 * @version 1/17/13 3:55 PM
 */
@Singleton
public class JpaProviderService extends AbstractIdleService implements Provider<EntityManager> {
    private String _persistenceUnitName;
    private Properties _properties;
    private EntityManagerFactory _emf;
    private JpaContextService _jpaContext;

    @Inject
    public JpaProviderService(@JpaProviderServiceConfig final String persistenceUnitName,
                              @JpaProviderServiceConfig final Properties properties,
                              final JpaContextService jpaContext) {
        _persistenceUnitName = persistenceUnitName;
        _properties = properties;
        _jpaContext = jpaContext;
    }

    @Override
    protected void startUp() throws Exception {
        _emf = Persistence.createEntityManagerFactory(_persistenceUnitName, _properties);
        _jpaContext.registerEmf(_persistenceUnitName, _emf);
    }

    @Override
    protected void shutDown() throws Exception {
        _emf.close();
    }

    @Override
    public EntityManager get() {
        return _jpaContext.getEm(_emf);
    }

    public EntityManagerFactory getEmf() {
        return _emf;
    }
}
