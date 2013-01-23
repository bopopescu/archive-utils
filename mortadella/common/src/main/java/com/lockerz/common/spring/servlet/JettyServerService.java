package com.lockerz.common.spring.servlet;

import org.eclipse.jetty.jmx.MBeanContainer;
import org.eclipse.jetty.server.Handler;
import org.eclipse.jetty.server.NCSARequestLog;
import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.server.handler.ContextHandlerCollection;
import org.eclipse.jetty.server.handler.HandlerCollection;
import org.eclipse.jetty.server.handler.RequestLogHandler;
import org.eclipse.jetty.server.ssl.SslSelectChannelConnector;
import org.eclipse.jetty.util.ssl.SslContextFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.BeanFactoryUtils;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.context.Lifecycle;
import org.springframework.context.Phased;

import javax.management.MBeanServer;
import java.lang.management.ManagementFactory;
import java.util.Map;

/**
 * @author Brian Gebala
 * @version 1/23/13 8:50 AM
 */
public class JettyServerService implements ApplicationContextAware, Lifecycle, Phased {
    private final static Logger log = LoggerFactory.getLogger(JettyServerService.class);
    private final static Logger console = LoggerFactory.getLogger("CONSOLE");

    private int _port;
    private int _sslPort;
    private String _keyStoreFile;
    private String _keyStorePassword;
    private Server _server;
    private ApplicationContext _ctx;
    private NCSARequestLog _requestLog;

    public void setRequestLog(NCSARequestLog log) {
        _requestLog = log;
    }

    public void setPort(final int port) {
        _port = port;
    }

    public void setSslPort(final int sslPort) {
        _sslPort = sslPort;
    }

    public void setKeyStoreFile(final String keyStoreFile) {
        _keyStoreFile = keyStoreFile;
    }

    public void setKeyStorePassword(final String keyStorePassword) {
        _keyStorePassword = keyStorePassword;
    }

    public void init() {
        _server = new Server(_port);
    }

    @Override
    public synchronized void start() {
        log.debug("Starting the Jetty server on port: " + _port);

        try {
            Map<String, Handler> handlers =
                    BeanFactoryUtils.beansOfTypeIncludingAncestors(_ctx, Handler.class);

            ContextHandlerCollection contexts = new ContextHandlerCollection();
            HandlerCollection handlerConnection = new HandlerCollection();

            for (Handler h : handlers.values()) {
                contexts.addHandler(h);
            }

            RequestLogHandler requestLogHandler = new RequestLogHandler();
            requestLogHandler.setRequestLog(_requestLog);

            handlerConnection.setHandlers(new Handler[] {contexts, requestLogHandler});

            MBeanServer mBeanServer = ManagementFactory.getPlatformMBeanServer();
            MBeanContainer mBeanContainer = new MBeanContainer(mBeanServer);
            _server.getContainer().addEventListener(mBeanContainer);

            try {
                mBeanContainer.start();
            }
            catch (Throwable thr) {
                log.error("Error starting Jetty JMX.", thr);
            }

            if (_sslPort > 0) {
                SslSelectChannelConnector sslConnector = new SslSelectChannelConnector();
                sslConnector.setPort(_sslPort);
                SslContextFactory cf = sslConnector.getSslContextFactory();
                cf.setKeyStorePath(_keyStoreFile);
                cf.setKeyStorePassword(_keyStorePassword);
                cf.setKeyManagerPassword(_keyStorePassword);

                _server.addConnector(sslConnector);
            }

            _server.setHandler(handlerConnection);
            _server.start();

            log.debug(_server.dump());
            console.info("Jetty listening on port " + _port);
        }
        catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public boolean isRunning() {
        if (_server == null) { return false; }
        return _server.isRunning();
    }

    @Override
    public void stop() {
        try {
            _server.stop();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public int getPhase() {
        return Integer.MAX_VALUE;
    }

    @Override
    public void setApplicationContext(ApplicationContext ctx) {
        _ctx = ctx;
    }
}
