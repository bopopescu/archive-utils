package com.lockerz.common.flyway;

import com.googlecode.flyway.core.Flyway;
import com.googlecode.flyway.core.metadatatable.MetaDataTableRow;

import java.util.Properties;

/**
 * @author Brian Gebala
 * @version 7/26/12 2:51 PM
 */
public class FlywayMigration {
    private Flyway _flyway;
    private String _name;
    private Properties _properties;

    public void init() {
        _flyway = new Flyway();
        _flyway.configure(_properties);
    }

    public Flyway getFlyway() {
        return _flyway;
    }

    public String getName() {
        return _name;
    }

    public void setName(final String name) {
        _name = name;
    }

    public void setProperties(final Properties properties) {
        _properties = properties;
    }
}
