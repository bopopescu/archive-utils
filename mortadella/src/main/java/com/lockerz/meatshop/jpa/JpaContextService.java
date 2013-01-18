package com.lockerz.meatshop.jpa;

import com.google.inject.Singleton;
import org.apache.openjpa.persistence.OpenJPAEntityManagerFactory;
import org.apache.openjpa.persistence.OpenJPAPersistence;
import org.apache.openjpa.persistence.QueryResultCache;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import java.util.IdentityHashMap;
import java.util.Map;
import java.util.TreeMap;

/**
 * @author Brian Gebala
 * @version 1/17/13 3:51 PM
 */
@Singleton
public class JpaContextService {
    //-------------------------------------------------------------
    // Constants
    //-------------------------------------------------------------

    private final static Logger LOGGER = LoggerFactory.getLogger(JpaContextService.class);


    //-------------------------------------------------------------
    // Variables - Private
    //-------------------------------------------------------------

    private ThreadLocal<ThreadLocalContext> _threadLocalContexts = new ThreadLocal<ThreadLocalContext>();
    private Map<String, EntityManagerFactory> _emfs = new TreeMap<String, EntityManagerFactory>();


    //-------------------------------------------------------------
    // Methods - Public
    //-------------------------------------------------------------

    public EntityManager getEm(final EntityManagerFactory emf) {
        Map<EntityManagerFactory, EntityManager> threadLocals = _threadLocalContexts.get().getEntityManagerFactories();
        EntityManager em = threadLocals.get(emf);

        if (em == null) {
            em = emf.createEntityManager();
            threadLocals.put(emf, em);

            if (LOGGER.isTraceEnabled()) {
                LOGGER.trace("getEm() created new EntityManager: emf={}, em={}, thread={}", new Object[] { emf, em, Thread.currentThread() });
            }
        }
        else {
            if (LOGGER.isTraceEnabled()) {
                LOGGER.trace("getEm() found cached EntityManager: emf={}, em={}, thread={}", new Object[] { emf, em, Thread.currentThread() });
            }
        }

        return em;
    }

    public void flushDataCaches() {
        flushCache(CacheType.DATA);
    }

    public void flushQueryCaches() {
        flushCache(CacheType.QUERY);
    }

    public void registerEmf(final String name,
                            final EntityManagerFactory emf) {
        _emfs.put(name, emf);
        LOGGER.debug("Configured JpaContext management for EntityManagerFactory: {}", name);
    }


    public void enterContext(final Object boundary) {
        ThreadLocalContext threadLocalContext = _threadLocalContexts.get();

        if (threadLocalContext == null) {
            threadLocalContext = new ThreadLocalContext();
        }

        int refCount = threadLocalContext.incRefCount();
        _threadLocalContexts.set(threadLocalContext);

        if (LOGGER.isDebugEnabled()) {
            LOGGER.debug("enterContext: refCount={}, boundary={}", refCount, boundary);
        }
    }

    public void exitContext(final Object boundary) {
        ThreadLocalContext threadLocalContext = _threadLocalContexts.get();
        int refCount = threadLocalContext.decRefCount();

        if (LOGGER.isDebugEnabled()) {
            LOGGER.debug("exitContext(): refCount={}, boundary={}", refCount, boundary);
        }

        if (refCount == 0) {
            Map<EntityManagerFactory, EntityManager> threadLocals = threadLocalContext.getEntityManagerFactories();

            if (threadLocals != null) {
                for (Map.Entry<EntityManagerFactory, EntityManager> entry : threadLocals.entrySet()) {
                    EntityManager em = entry.getValue();

                    try {
                        if (em.isOpen()) {
                            em.close();
                        }
                    }
                    catch (Throwable thr) {
                        LOGGER.error("exitContext() error", thr);
                    }

                    if (LOGGER.isDebugEnabled()) {
                        LOGGER.debug("exitContext() closed context: boundary={}, em={}",
                                new Object[]{boundary, em});
                    }
                }

                _threadLocalContexts.remove();
            }
        }
        else {
            _threadLocalContexts.set(threadLocalContext);
        }
    }


    //-------------------------------------------------------------
    // Methods - Protected
    //-------------------------------------------------------------

    protected void flushCache(final CacheType type) {
        // If EntityManagerFactories for all known LocalContainerEntityManagerFactoryBeans have been registered
        // via Lifecycle.start(), then this bean was loaded in a lifecycle-aware container. This allows us to
        // flush all Spring-managed EntityManagerFactory caches.
        if (_emfs.size() > 0) {
            for (Map.Entry<String, EntityManagerFactory> entry : _emfs.entrySet()) {
                String beanName = entry.getKey();
                EntityManagerFactory emf = entry.getValue();

                flushEntityManagerCache(emf, type, beanName);
            }
        }
        // EntityManagerFactories were not registered in a lifecycle-aware container (most likely tests).
        // As a fallback, flush all ThreadLocal EntityManagerFactory caches.
        else if (_threadLocalContexts.get() != null) {
            Map<EntityManagerFactory, EntityManager> threadLocals =
                    _threadLocalContexts.get().getEntityManagerFactories();

            if (threadLocals != null) {
                for (Map.Entry<EntityManagerFactory, EntityManager> entry : threadLocals.entrySet()) {
                    EntityManagerFactory emf = entry.getKey();
                    flushEntityManagerCache(emf, type, null);
                }
            }
        }
    }


    //-------------------------------------------------------------
    // Methods - Private
    //-------------------------------------------------------------

    private void flushEntityManagerCache(final EntityManagerFactory emf,
                                         final CacheType type,
                                         final String beanName) {
        try {
            switch (type) {
                case DATA:
                    emf.getCache().evictAll();

                    if (beanName != null) {
                        LOGGER.info("Flushed registered EntityManagerFactory data cache: {}", beanName);
                    }
                    else {
                        LOGGER.info("Flushed ThreadLocal EntityManagerFactory data cache: {}", emf);
                    }
                    break;
                case QUERY:
                    OpenJPAEntityManagerFactory openJpaEmf = OpenJPAPersistence.cast(emf);
                    QueryResultCache queryCache = openJpaEmf.getQueryResultCache();
                    queryCache.evictAll();

                    if (beanName != null) {
                        LOGGER.info("Flushed registered EntityManagerFactory query cache: {}", beanName);
                    }
                    else {
                        LOGGER.info("Flushed ThreadLocal EntityManagerFactory query cache: {}", emf);
                    }
                    break;
            }
        }
        catch (Exception ex) {
            LOGGER.error("Error flushing registered EntityManagerFactory {} cache: {}",
                    new Object[] {type, beanName == null ? emf : beanName}, ex);
        }
    }


    //-------------------------------------------------------------
    // Inner Class
    //-------------------------------------------------------------

    private static class ThreadLocalContext {
        private int _refCount;
        private Map<EntityManagerFactory, EntityManager> _entityManagerFactoryMap =
                new IdentityHashMap<EntityManagerFactory, EntityManager>();

        private Map<EntityManagerFactory, EntityManager> getEntityManagerFactories() {
            return _entityManagerFactoryMap;
        }

        private int incRefCount() {
            return ++_refCount;
        }

        private int decRefCount() {
            return --_refCount;
        }
    }

    public static enum CacheType { DATA, QUERY }
}
