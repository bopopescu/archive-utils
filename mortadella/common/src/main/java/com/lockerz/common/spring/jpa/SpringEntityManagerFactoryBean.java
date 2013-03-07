package com.lockerz.common.spring.jpa;

import org.apache.commons.dbcp.BasicDataSource;
import org.apache.openjpa.conf.OpenJPAConfiguration;
import org.apache.openjpa.event.TCPRemoteCommitProvider;
import org.apache.openjpa.lib.conf.Configurations;
import org.apache.openjpa.lib.util.Options;
import org.apache.openjpa.persistence.OpenJPAEntityManager;
import org.apache.openjpa.persistence.OpenJPAEntityManagerFactory;
import org.apache.openjpa.persistence.OpenJPAEntityManagerFactorySPI;
import org.apache.openjpa.persistence.OpenJPAPersistence;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.Lifecycle;
import org.springframework.context.Phased;
import org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.spi.PersistenceUnitInfo;
import java.sql.Connection;
import java.sql.Statement;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * @author Brian J. Gebala
 * @version 2/2/12 1:23 PM
 */
public class SpringEntityManagerFactoryBean
        extends LocalContainerEntityManagerFactoryBean
        implements Lifecycle, Phased {
    //-------------------------------------------------------------
    // Constants
    //-------------------------------------------------------------

    private final static Logger LOGGER = LoggerFactory.getLogger(SpringEntityManagerFactoryBean.class);


    //-------------------------------------------------------------
    // Variables - Private
    //-------------------------------------------------------------

    private JpaRemoteCacheService _jpaRemoteCacheService;
    private boolean _eagerConnectionInit = true;
    private volatile boolean _running = false;


    //-------------------------------------------------------------
    // Methods - Getter/Setter
    //-------------------------------------------------------------

    public void setEagerConnectionInit(final boolean eagerConnectionInit) {
        _eagerConnectionInit = eagerConnectionInit;
    }

    public void setJpaRemoteCacheService(final JpaRemoteCacheService jpaRemoteCacheService) {
        _jpaRemoteCacheService = jpaRemoteCacheService;
    }


    //-------------------------------------------------------------
    // Implementation - Lifecycle
    //-------------------------------------------------------------

    @Override
    public int getPhase() {
        return Integer.MIN_VALUE;
    }

    @Override
    public void start() {
        _running = true;
    }

    @Override
    public void stop() {
        // No-op.
    }

    @Override
    public boolean isRunning() {
        return _running;
    }


    //-------------------------------------------------------------
    // Methods - Protected
    //-------------------------------------------------------------

    @Override
    protected void postProcessEntityManagerFactory(final EntityManagerFactory emf,
                                                   final PersistenceUnitInfo pui) {
        OpenJPAEntityManagerFactorySPI openJpaEmf = (OpenJPAEntityManagerFactorySPI)emf;
        Object remoteCommitProvider = openJpaEmf.getConfiguration().getRemoteCommitEventManager().getRemoteCommitProvider();

        if (_jpaRemoteCacheService != null && remoteCommitProvider instanceof TCPRemoteCommitProvider) {
            _jpaRemoteCacheService.register(pui.getPersistenceUnitName(), (TCPRemoteCommitProvider)remoteCommitProvider);
        }

        initAndTestDbConnections(emf, pui);
        loadPersistentClassMetaData(emf);
    }


    //-------------------------------------------------------------
    // Methods - Private
    //-------------------------------------------------------------

    private void loadPersistentClassMetaData(final EntityManagerFactory emf) {
        OpenJPAEntityManagerFactorySPI spi = (OpenJPAEntityManagerFactorySPI)emf;
        OpenJPAConfiguration config = spi.getConfiguration();

        config.getMetaDataRepositoryInstance().getPersistentTypeNames(true, getClass().getClassLoader());
        config.getMetaDataRepositoryInstance().loadPersistentTypes(true, getClass().getClassLoader());
    }

    private void initAndTestDbConnections(final EntityManagerFactory emf,
                                          final PersistenceUnitInfo pui) {
        if (_eagerConnectionInit) {
            BasicDataSource dataSource = (BasicDataSource)pui.getNonJtaDataSource();
            int maxActive = dataSource.getMaxActive();

            if (maxActive > 0) {
                Set<EntityManager> ems = new HashSet<EntityManager>();
                Set<Connection> connections = new HashSet<Connection>();

                try {
                    for (int i = 0; i < maxActive; i++) {
                        EntityManager em = emf.createEntityManager();
                        OpenJPAEntityManager kem = OpenJPAPersistence.cast(em);
                        Connection conn = (Connection) kem.getConnection();
                        ems.add(em);
                        connections.add(conn);

                        try {
                            Statement stmt = conn.createStatement();
                            stmt.executeQuery("SELECT 1");
                            stmt.close();
                        }
                        catch (Exception ex) {
                            LOGGER.error("Error during eager connection init.", ex);
                        }
                    }
                }
                finally {
                    for (Connection conn : connections) {
                        try {
                            conn.close();
                        } catch (Exception ex) {
                            LOGGER.error(ex.toString(), ex);
                        }
                    }

                    for (EntityManager em : ems) {
                        em.close();
                    }
                }
            }
        }
    }
}
