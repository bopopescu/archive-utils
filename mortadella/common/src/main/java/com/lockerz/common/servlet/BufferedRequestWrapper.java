package com.lockerz.common.servlet;

import org.slf4j.LoggerFactory;

import javax.servlet.ServletInputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;

/**
 * @author Brian Gebala
 * @version 1/23/13 8:38 AM
 */
public class BufferedRequestWrapper extends HttpServletRequestWrapper {
    private ServletInputStream _servletInputStream = null;

    public BufferedRequestWrapper(final HttpServletRequest request) throws IOException {
        super(request);

        if (request.getContentType() != null && request.getContentType().equals("application/json")) {
            InputStream ins = request.getInputStream();
            ByteArrayOutputStream bout = new ByteArrayOutputStream();

            byte[] buf = new byte[1024];
            int bytesRead;

            while ((bytesRead = ins.read(buf, 0, 1024)) > 0) {
                bout.write(buf, 0, bytesRead);
            }

            bout.flush();
            byte[] bytes = bout.toByteArray();

            if (bytes.length > 0) {
                String content = new String(bytes);
                LoggerFactory.getLogger(getClass()).info(content);
            }

            ByteArrayInputStream bin = new ByteArrayInputStream(bytes);
            _servletInputStream = new BufferedServletInputStream(bin);
        }
    }

    @Override
    public ServletInputStream getInputStream() throws IOException {
        if (_servletInputStream == null) {
            return super.getInputStream();
        }

        return _servletInputStream;
    }
}
