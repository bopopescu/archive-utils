package com.lockerz.common.spring.jpa;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;

/**
 * @author Brian J. Gebala
 * @version 2/3/12 10:44 AM
 */
public interface JpaContext {
    //-------------------------------------------------------------
    // Methods - Public
    //-------------------------------------------------------------

    public EntityManager getEm(final EntityManagerFactory emf);
    public void flushDataCaches();
    public void flushQueryCaches();
    public void enterContext(final Object boundary);
    public void exitContext(final Object boundary);
}
