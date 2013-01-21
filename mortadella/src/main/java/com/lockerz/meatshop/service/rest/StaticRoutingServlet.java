package com.lockerz.meatshop.service.rest;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * @author Brian Gebala
 * @version 1/21/13 12:44 PM
 */
public class StaticRoutingServlet extends HttpServlet {
    @Override
    protected void doGet(final HttpServletRequest req,
                         final HttpServletResponse resp)
            throws ServletException, IOException {
        resp.getWriter().println("StaticRoutingServlet - " + this);
        resp.getWriter().println("name = " + req.getServletContext().getAttribute("name"));
    }
}
