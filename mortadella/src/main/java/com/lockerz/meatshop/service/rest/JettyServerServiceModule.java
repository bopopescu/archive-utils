package com.lockerz.meatshop.service.rest;

import com.google.inject.AbstractModule;
import org.eclipse.jetty.server.Handler;

/**
 * @author Brian Gebala
 * @version 1/21/13 11:28 AM
 */
public class JettyServerServiceModule extends AbstractModule {

    @Override
    protected void configure() {
        //bind(AdminHandlerProvider.class).asEagerSingleton();
        bind(Handler.class).annotatedWith(AdminHandler.class).toProvider(AdminHandlerProvider.class);
        bind(RestHandlerProvider.class).asEagerSingleton();
        bind(Handler.class).annotatedWith(RestHandler.class).toProvider(RestHandlerProvider.class);
        bind(JettyServerService.class).asEagerSingleton();
    }
}
