package com.lockerz.common.servlet;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletResponseWrapper;
import java.io.IOException;

/**
 * @author Brian Gebala
 * @version 1/23/13 8:38 AM
 */
public class BufferedResponseWrapper extends HttpServletResponseWrapper {
    private BufferedServletOutputStream _bufferedServletOutputStream = new BufferedServletOutputStream();

    public BufferedResponseWrapper(final HttpServletResponse response) {
        super(response);
    }

    @Override
    public ServletOutputStream getOutputStream() throws IOException {
        return _bufferedServletOutputStream;
    }

    public BufferedServletOutputStream getBufferedServletOutputStream() throws IOException {
        return _bufferedServletOutputStream;
    }
}
