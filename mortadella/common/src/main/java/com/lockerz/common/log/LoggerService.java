package com.lockerz.common.log;

import java.util.Map;

/**
 * @author Brian Gebala
 * @version 1/23/13 8:41 AM
 */
public interface LoggerService {
    public Map<String, String> sanitize(final Map<String, String[]> params);
}
