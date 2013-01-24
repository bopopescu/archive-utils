package com.lockerz.common.flyway;

import com.google.common.base.Strings;
import com.googlecode.flyway.core.metadatatable.MetaDataTableRow;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * @author Brian Gebala
 * @version 7/26/12 2:29 PM
 */
public class FlywayMigrationService {
    private final static String HR = Strings.repeat("=", 50);
    private Map<String, FlywayMigration> _migrationMap = new LinkedHashMap<String, FlywayMigration>();

    public void setMigrations(final List<FlywayMigration> migrations) {
        for (FlywayMigration migration : migrations) {
            _migrationMap.put(migration.getName(), migration);
        }
    }

    public void clean() {
        for (Map.Entry<String, FlywayMigration> entry : _migrationMap.entrySet()) {
            String name = entry.getKey();
            FlywayMigration migration = entry.getValue();

            System.out.println("Clean: " + name);
            migration.getFlyway().clean();
            System.out.println();
        }
    }

    public void init() {
        for (Map.Entry<String, FlywayMigration> entry : _migrationMap.entrySet()) {
            String name = entry.getKey();
            FlywayMigration migration = entry.getValue();

            System.out.println("Init: " + name);
            System.out.println(HR);

            try {
                migration.getFlyway().init();
            }
            catch (Exception ex) {
                System.out.println(ex.toString());
            }

            System.out.println();
        }
    }

    public void migrate() {
        for (Map.Entry<String, FlywayMigration> entry : _migrationMap.entrySet()) {
            String name = entry.getKey();
            FlywayMigration migration = entry.getValue();

            System.out.println("Migrate: " + name);
            System.out.println(HR);
            migration.getFlyway().migrate();
            System.out.println();
        }
    }

    public void getStatus() {
        for (Map.Entry<String, FlywayMigration> entry : _migrationMap.entrySet()) {
            System.out.println("Status: " + entry.getKey());
            System.out.println(HR);

            FlywayMigration migration = entry.getValue();
            MetaDataTableRow status = migration.getFlyway().status();

            if (status == null) {
                System.out.println("< not found >");
            }
            else {
                System.out.println(status.getVersion().toString());
            }

            System.out.println();
        }
    }
}
