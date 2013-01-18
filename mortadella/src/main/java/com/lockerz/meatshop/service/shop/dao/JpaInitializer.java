package com.lockerz.meatshop.service.shop.dao;

import com.google.inject.Inject;
import com.lockerz.meatshop.jpa.JpaProviderService;

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
    JpaInitializer(final JpaProviderService jpaProviderService) {
        // This bootstrap's JPA.
        try {
            jpaProviderService.start().get();
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
    }
}
