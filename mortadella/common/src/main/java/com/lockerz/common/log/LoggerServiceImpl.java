package com.lockerz.common.log;

import org.springframework.util.StringUtils;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

/**
 * @author Brian Gebala
 * @version 1/23/13 8:40 AM
 */
public class LoggerServiceImpl implements LoggerService{
    private final static String MASK = "********";
    private Set<String> _maskedNames;

    public String sanitize(String name, String value) {
        if (_maskedNames.contains(name)) {
            return MASK;
        } else {
            return value;
        }
    }

    public String sanitize(String name, String[] values) {
        if (values == null || values.length == 0) { return ""; }
        if (values.length == 1) { return sanitize(name, values[0]); }

        String[] sanitizedValues = new String[values.length];

        for (int i = 0; i < values.length; i++) {
            sanitizedValues[i] = sanitize(name, values[i]);
        }

        return StringUtils.arrayToDelimitedString(sanitizedValues, ", ");
    }

    public void setMaskedNames(Set<String> maskedNames) {
        _maskedNames = maskedNames;
    }

    public Map<String, String> sanitize(final Map<String, String[]> params) {
        Map<String, String> sanitized = new HashMap<String, String>();

        for (Map.Entry<String, String[]> entry : params.entrySet()) {
            sanitized.put(entry.getKey(), sanitize(entry.getKey(), entry.getValue()));
        }

        return sanitized;
    }
}
