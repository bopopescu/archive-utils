package com.lockerz.meatshop.service.rest;

import com.google.common.util.concurrent.AbstractIdleService;
import com.google.inject.Inject;
import com.google.inject.Singleton;
import com.google.inject.name.Named;
import org.eclipse.jetty.server.Handler;
import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.server.handler.ContextHandlerCollection;
import org.eclipse.jetty.server.handler.HandlerCollection;

/**
 * @author Brian Gebala
 * @version 1/21/13 11:25 AM
 */
@Singleton
public class JettyServerService extends AbstractIdleService {
    private int _port;
    private Server _server;
    private ContextHandlerCollection _contexts = new ContextHandlerCollection();

    @Inject
    public JettyServerService(@Named("jetty.server.port") final int port,
                              @AdminHandler final Handler adminHandler,
                              @RestHandler final Handler restHandler) {
        _port = port;
        _contexts.addHandler(adminHandler);
        _contexts.addHandler(restHandler);
    }

    @Override
    protected void startUp() throws Exception {
        HandlerCollection handlerConnection = new HandlerCollection();
        handlerConnection.setHandlers(new Handler[] { _contexts });

        _server = new Server(_port);
        _server.setHandler(handlerConnection);
        _server.start();
    }

    @Override
    protected void shutDown() throws Exception {
        _server.stop();
    }
}
