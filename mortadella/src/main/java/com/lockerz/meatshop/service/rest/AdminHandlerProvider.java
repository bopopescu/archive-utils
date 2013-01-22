package com.lockerz.meatshop.service.rest;

import com.google.inject.Inject;
import com.google.inject.Singleton;
import com.google.inject.name.Named;

/**
 * @author Brian Gebala
 * @version 1/21/13 12:53 PM
 */
@Singleton
public class AdminHandlerProvider extends AbstractHandlerProvider {
    @Inject
    public AdminHandlerProvider(@Named("admin.handler.servletContextPath") final String servletContextPath) {
        super(servletContextPath);
    }
}

