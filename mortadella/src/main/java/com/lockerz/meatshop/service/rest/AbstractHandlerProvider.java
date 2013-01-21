package com.lockerz.meatshop.service.rest;

import com.google.inject.Provider;
import org.eclipse.jetty.server.Handler;
import org.eclipse.jetty.servlet.ServletContextHandler;
import org.eclipse.jetty.servlet.ServletHolder;

import javax.servlet.http.HttpServlet;

/**
 * @author Brian Gebala
 * @version 1/21/13 12:04 PM
 */
public class AbstractHandlerProvider implements Provider<Handler> {
    private ServletContextHandler _context = new ServletContextHandler(ServletContextHandler.SESSIONS);
    private String _servletContextPath;

    public AbstractHandlerProvider(final String servletContextPath) {
        _servletContextPath = servletContextPath;
    }

    @Override
    public Handler get() {
        HttpServlet servlet = new StaticRoutingServlet();
        ServletHolder holder = new ServletHolder(servlet);

        _context.setAttribute("name", _servletContextPath);
        _context.setContextPath(_servletContextPath);
        _context.addServlet(holder, "/*");

        return _context;
    }
}
