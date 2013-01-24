package com.lockerz.common.flyway;

import ch.qos.logback.classic.Level;
import com.google.common.base.Strings;
import com.lockerz.common.spring.app.SpringAppRunner;
import org.slf4j.LoggerFactory;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * @author Brian Gebala
 * @version 7/26/12 3:07 PM
 */
public class FlywayMigrator {
    private static enum Command {
        CLEAN, INIT, MIGRATE, STATUS
    }

    public static void main(final String[] args) {
        String logbackLevel = "INFO";
        Command command = Command.MIGRATE;

        for (String arg : args) {
            if (arg.equals("--status")) {
                command = Command.STATUS;
            }
            else if (arg.equals("--init")) {
                command = Command.INIT;
            }
            else if (arg.equals("--clean")) {
                command = Command.CLEAN;
            }
            else if (arg.equals("-v")) {
                logbackLevel = "DEBUG";
            }
            else if (arg.equals("-h") || arg.equals("-help") || arg.equals("--help")) {
                System.out.println("Usage: FlywayMigrator [<option>...] [<command>]");
                System.out.println();
                System.out.println("       Runs Flyway migrate unless a <command> is specified.");
                System.out.println();
                System.out.println("       <option> : -v        (verbose logging)");
                System.out.println("      <command> : --clean   (Flyway clean)");
                System.out.println("                : --init    (Flyway init)");
                System.out.println("                : --status  (Flyway status)");
                System.out.println();
                System.exit(0);
            }
        }

        String homeEnvVarName = "APP_HOME";
        String appHome = System.getenv(homeEnvVarName);

        System.out.println("=====================");
        System.out.println("Lockerz DB Migrations");
        System.out.println("=====================");
        System.out.println();
        System.out.format("%-25s = %s\n", homeEnvVarName, appHome == null ? "<undefined>" : appHome);
        System.out.println();

        if (Strings.isNullOrEmpty(appHome)) {
            System.out.println("ERROR: Environment variable configuration.");
            System.out.println();
            System.exit(0);
        }

        System.setProperty("app.home", appHome);
        System.setProperty("app.name", "migrator");
        System.setProperty("logback.configurationFile", "migrator-logback.xml");

        ch.qos.logback.classic.Logger logger = (ch.qos.logback.classic.Logger) LoggerFactory.getLogger("STDOUT");
        logger.setLevel(Level.toLevel(logbackLevel));

        SpringAppRunner appRunner = new SpringAppRunner("migrator-context.xml");
        ClassPathXmlApplicationContext context = appRunner.start();
        FlywayMigrationService migrationService = (FlywayMigrationService) context.getBean("migrationService");

        try {
            switch (command) {
                case CLEAN:
                    migrationService.clean();
                    break;
                case INIT:
                    migrationService.init();
                    break;
                case MIGRATE:
                    migrationService.migrate();
                    break;
                case STATUS:
                    migrationService.getStatus();
                    break;
                default:
                    System.out.println("ERROR: Unknown command.");
            }
        }
        finally {
            context.stop();
        }
    }
}
