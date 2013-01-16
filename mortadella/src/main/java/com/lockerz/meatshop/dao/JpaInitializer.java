package com.lockerz.meatshop.dao;

import com.google.inject.Inject;
import com.google.inject.persist.PersistService;

/**
 * See:
 *
 * http://aurelavramescu.blogspot.com/2011/04/jpa-with-google-guice.html
 *
 * @author Brian Gebala
 * @version 1/15/13 2:07 PM
 */
public class JpaInitializer {
    @Inject
    JpaInitializer(final PersistService service) {
        // This bootstrap's JPA.
        service.start();
    }
}
