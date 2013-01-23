package com.lockerz.common.servlet;

import javax.servlet.ServletOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * @author Brian Gebala
 * @version 1/23/13 8:39 AM
 */
public class BufferedServletOutputStream extends ServletOutputStream {
    private ByteArrayOutputStream _bout = new ByteArrayOutputStream();
    private PrintWriter _pw = new PrintWriter(_bout);

    @Override
    public void print(final String s) throws IOException {
        _pw.print(s);
    }

    @Override
    public void print(final boolean b) throws IOException {
        _pw.print(b);
    }

    @Override
    public void print(final char c) throws IOException {
        _pw.print(c);
    }

    @Override
    public void print(final int i) throws IOException {
        _pw.print(i);
    }

    @Override
    public void print(final long l) throws IOException {
        _pw.print(l);
    }

    @Override
    public void print(final float f) throws IOException {
        _pw.print(f);
    }

    @Override
    public void print(final double d) throws IOException {
        _pw.print(d);
    }

    @Override
    public void println() throws IOException {
        _pw.println();
    }

    @Override
    public void println(final String s) throws IOException {
        _pw.println(s);
    }

    @Override
    public void println(final boolean b) throws IOException {
        _pw.println(b);
    }

    @Override
    public void println(final char c) throws IOException {
        _pw.println(c);
    }

    @Override
    public void println(final int i) throws IOException {
        _pw.println(i);
        super.println(i);
    }

    @Override
    public void println(final long l) throws IOException {
        _pw.println(l);
    }

    @Override
    public void println(final float f) throws IOException {
        _pw.println(f);
    }

    @Override
    public void println(final double d) throws IOException {
        _pw.println(d);
    }

    @Override
    public void write(final int i) throws IOException {
        _bout.write(i);
    }

    @Override
    public void write(final byte[] bytes) throws IOException {
        _bout.write(bytes);
    }

    @Override
    public void write(final byte[] bytes, final int i, final int i1) throws IOException {
        _bout.write(bytes, i, i1);
    }

    @Override
    public void flush() throws IOException {
        _pw.flush();
        _bout.flush();
    }

    @Override
    public void close() throws IOException {
        _pw.close();
        _bout.close();
    }

    public byte[] getByteArray() {
        _pw.flush();
        return _bout.toByteArray();
    }

    public String getContent() {
        _pw.flush();
        return _bout.toString();
    }
}
