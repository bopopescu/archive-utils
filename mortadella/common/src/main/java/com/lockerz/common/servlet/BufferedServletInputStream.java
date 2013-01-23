package com.lockerz.common.servlet;

import javax.servlet.ServletInputStream;
import java.io.ByteArrayInputStream;
import java.io.IOException;

/**
 * @author Brian Gebala
 * @version 1/23/13 8:39 AM
 */
public class BufferedServletInputStream extends ServletInputStream {
    private ByteArrayInputStream _bin;

    public BufferedServletInputStream(final ByteArrayInputStream bin) {
        _bin = bin;
    }

    @Override
    public int read() throws IOException {
        return _bin.read();
    }

    @Override
    public int read(final byte[] bytes) throws IOException {
        return _bin.read(bytes);
    }

    @Override
    public int read(final byte[] bytes, final int i, final int i1) throws IOException {
        return _bin.read(bytes, i, i1);
    }

    @Override
    public int readLine(final byte[] b, final int off, final int len) throws IOException {
        return super.readLine(b, off, len);    //To change body of overridden methods use File | Settings | File Templates.
    }

    @Override
    public int available() throws IOException {
        return _bin.available();
    }
}
