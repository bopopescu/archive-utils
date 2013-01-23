package com.lockerz.common.spring.servlet;

import org.eclipse.jetty.server.Handler;
import org.eclipse.jetty.servlet.FilterHolder;
import org.eclipse.jetty.servlet.ServletContextHandler;
import org.eclipse.jetty.servlet.ServletHolder;
import org.eclipse.jetty.servlets.GzipFilter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.FactoryBean;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.web.context.support.XmlWebApplicationContext;
import org.springframework.web.servlet.DispatcherServlet;

import javax.servlet.DispatcherType;
import java.util.EnumSet;

/**
 * @author Brian Gebala
 * @version 1/23/13 8:35 AM
 */
public class DispatcherServletJettyHandlerFactoryBean implements ApplicationContextAware, FactoryBean<Handler> {

    private final static String GZIP_MIME_TYPES = "text/html,text/plain,text/xml,application/xhtml+xml,text/css," +
            "application/javascript,application/x-javascript,image/svg+xml";

    private final static int DEFAULT_MAX_INACTIVE_SESSION_INTERVAL_SECONDS = 60 * 30;

    private ApplicationContext _parentApplicationContext;
    private String _location;
    private String _servletContextPath;
    private Handler _instance;
    private RequestLoggingFilter _requestLoggingFilter;
    private boolean _useGzipFilter;
    private int _maxInactiveSessionIntervalSeconds = DEFAULT_MAX_INACTIVE_SESSION_INTERVAL_SECONDS;

    public void setMaxInactiveSessionIntervalSeconds(final int maxInactiveSessionIntervalSeconds) {
        _maxInactiveSessionIntervalSeconds = maxInactiveSessionIntervalSeconds;
    }

    public final void init() {
        ServletContextHandler context = new ServletContextHandler(ServletContextHandler.SESSIONS);
        context.setContextPath(_servletContextPath);
        context.getSessionHandler().getSessionManager().setMaxInactiveInterval(_maxInactiveSessionIntervalSeconds);

        XmlWebApplicationContext appCtx = new XmlWebApplicationContext();
        appCtx.setConfigLocation(_location);
        appCtx.setParent(_parentApplicationContext);

        DispatcherServlet dispatcherServlet = new DispatcherServlet(appCtx);
        ServletHolder holder = new ServletHolder(dispatcherServlet);

        // For now we map all requests for _servletContextPath to the servlet.
        context.addServlet(holder, "/*");

        if (_useGzipFilter) {
            FilterHolder gZipFilter = new FilterHolder(new GzipFilter());
            gZipFilter.setInitParameter("mimeTypes", GZIP_MIME_TYPES);
            context.addFilter(gZipFilter, "/*", EnumSet.of(DispatcherType.REQUEST));
        }

        if (_requestLoggingFilter == null) {
            getLogger().debug("RequestLoggingFilter not configured.");
        }
        else {
            FilterHolder loggingFilter = new FilterHolder(_requestLoggingFilter);
            loggingFilter.setServletHandler(context.getServletHandler());
            context.addFilter(loggingFilter, "/*", EnumSet.of(DispatcherType.REQUEST));

            getLogger().debug("RequestLoggingFilter configured.");
        }

        getLogger().debug("Initialized: location={}, servletContextPath={}", _location, _servletContextPath);

        _instance = context;

        doInit(context, holder);
    }

    /**
     * Allows sub-classes to perform additional initialization.
     *
     * @param contextHandler Useful for additional configuration (filters, for example).
     * @param servletHolder  Useful for additional configuration (filters, for example).
     */
    protected void doInit(final ServletContextHandler contextHandler,
                          final ServletHolder servletHolder) {
    }

    protected Logger getLogger() {
        return LoggerFactory.getLogger(getClass());
    }

    @Override
    public boolean isSingleton() {
        return true;
    }

    @Override
    public Class<Handler> getObjectType() {
        return Handler.class;
    }

    @Override
    public Handler getObject() {
        return _instance;
    }

    @Override
    public void setApplicationContext(ApplicationContext ctx) {
        _parentApplicationContext = ctx;
    }

    public void setLocation(final String location) {
        _location = location;
    }

    public void setRequestLoggingFilter(final RequestLoggingFilter requestLoggingFilter) {
        _requestLoggingFilter = requestLoggingFilter;
    }

    public void setServletContextPath(String servletContextPath) {
        _servletContextPath = servletContextPath;
    }

    public void setUseGzipFilter(final boolean useGzipFilter) {
        _useGzipFilter = useGzipFilter;
    }
}
