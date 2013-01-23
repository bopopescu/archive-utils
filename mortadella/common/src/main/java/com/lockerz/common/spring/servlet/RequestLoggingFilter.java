package com.lockerz.common.spring.servlet;

/**
 * @author Brian Gebala
 * @version 1/23/13 8:36 AM
 */

import com.google.common.base.Function;
import com.google.common.base.Predicate;
import com.google.common.base.Splitter;
import com.google.common.collect.Iterables;
import com.google.common.collect.Sets;
import com.lockerz.common.log.LoggerService;
import com.lockerz.common.servlet.BufferedRequestWrapper;
import com.lockerz.common.servlet.BufferedResponseWrapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.filter.GenericFilterBean;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

public class RequestLoggingFilter extends GenericFilterBean {
    private final static Logger LOGGER = LoggerFactory.getLogger("http-log");

    private boolean _logRequest;
    private boolean _logResponse;
    private LoggerService _loggerService;
    private Set<String> _ignorePathPrefixes;
    private Set<String> _debugPathSuffixes;

    public void setLoggerService(final LoggerService loggerService) {
        _loggerService = loggerService;
    }

    public void setLogRequest(final boolean logRequest) {
        _logRequest = logRequest;
    }

    public void setLogResponse(final boolean logResponse) {
        _logResponse = logResponse;
    }

    @Override
    public void doFilter(final ServletRequest req,
                         final ServletResponse resp,
                         final FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = _logRequest ? new BufferedRequestWrapper((HttpServletRequest) req) : (HttpServletRequest) req;
        HttpServletResponse response = _logResponse ? new BufferedResponseWrapper((HttpServletResponse) resp) : (HttpServletResponse) resp;

        if (_ignorePathPrefixes != null
                && Iterables.find(_ignorePathPrefixes, new StringPrefixPredicate(request.getServletPath()), null)
                != null) {
            LOGGER.trace("Ignoring request {}", request.getRequestURL());
            chain.doFilter(request, response);
            return;
        }

        StringBuilder logBuf = new StringBuilder();

        logBuf.append("ip=");
        logBuf.append(request.getRemoteAddr());
        logBuf.append(" | sid=");
        logBuf.append(request.getSession().getId());
        logBuf.append(" | method=");
        logBuf.append(request.getMethod());
        logBuf.append(" | url=");
        logBuf.append(request.getRequestURL());
        logBuf.append(" | params=");
        logBuf.append(_loggerService.sanitize(request.getParameterMap()));

        Map<String, String> headersMap = new HashMap<String, String>();
        Enumeration headersEnum = request.getHeaderNames();

        while (headersEnum.hasMoreElements()) {
            String header = (String) headersEnum.nextElement();
            headersMap.put(header, request.getHeader(header));
        }

        logBuf.append(" | headers=");
        logBuf.append(headersMap);

        boolean isDebug = _debugPathSuffixes != null
                && Iterables.find(
                _debugPathSuffixes,
                new StringSuffixPredicate(request.getServletPath().toLowerCase()),
                null) != null;

        if (isDebug) {
            LOGGER.debug(logBuf.toString());
        }
        else {
            LOGGER.info(logBuf.toString());
        }

        long startTime = System.currentTimeMillis();

        chain.doFilter(request, response);

        long time = System.currentTimeMillis() - startTime;

        logBuf = new StringBuilder();
        logBuf.append(request.getRequestURI());
        logBuf.append(" took ");
        logBuf.append(time);
        logBuf.append(" ms.");

        if (isDebug) {
            LOGGER.debug(logBuf.toString());
        }
        else {
            LOGGER.info(logBuf.toString());
        }

        if (_logResponse) {
            BufferedResponseWrapper responseWrapper = (BufferedResponseWrapper)response;
            byte[] content = responseWrapper.getBufferedServletOutputStream().getByteArray();

            if (content.length > 0) {
                response.getOutputStream().write(content, 0, content.length);
            }

            LOGGER.info(responseWrapper.getBufferedServletOutputStream().getContent());
        }
    }

    public void setIgnorePathPrefixStrings(String ignorePathPrefixStrings) {
        _ignorePathPrefixes = Sets.newHashSet(Splitter.on(',').trimResults().split(ignorePathPrefixStrings));
    }

    public void setDebugPathSuffixStrings(String debugPathSuffixStrings) {
        _debugPathSuffixes = Sets.newHashSet(Iterables.transform(
                Splitter.on(',').trimResults().split(debugPathSuffixStrings), new ToLowerCase()));
    }

    private static class StringPrefixPredicate implements Predicate<String> {
        private String _value;

        public StringPrefixPredicate(String value) {
            _value = value;
        }

        public boolean apply(String p) {
            return _value.startsWith(p);
        }

        public boolean equals(Object o) {
            return this == o;
        }
    }

    private static class StringSuffixPredicate implements Predicate<String> {
        private String _value;

        public StringSuffixPredicate(String value) {
            _value = value;
        }

        public boolean apply(String p) {
            return _value.endsWith(p);
        }

        public boolean equals(Object o) {
            return this == o;
        }
    }

    private static class ToLowerCase implements Function<String, String> {
        public String apply(String v) {
            return v.toLowerCase();
        }

        public boolean equals(Object o) {
            return this == o;
        }
    }
}
