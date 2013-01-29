package com.lockerz.common.clojure;

import clojure.lang.Namespace;
import clojure.lang.RT;
import clojure.lang.Symbol;
import clojure.lang.Var;
import com.google.common.base.Stopwatch;
import com.google.common.collect.Sets;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

import java.nio.file.*;
import java.util.List;
import java.util.Set;

/**
 * Created by James Baird
 * Date: 1/25/13
 * Time: 10:21 AM
 */
public class ClojureScriptLoader implements ApplicationContextAware {

    private static final Logger LOGGER = LoggerFactory.getLogger(ClojureScriptLoader.class);

    private ApplicationContext _ctx;
    private List<String> _scripts;

    public void setScripts(final List<String> scripts) {
        _scripts = scripts;
    }

    public void init() throws Exception {
        Var.intern(Namespace.findOrCreate(Symbol.intern("com.lockerz")), Symbol.intern("application-context"), _ctx);

        Stopwatch watch = new Stopwatch();
        long totalTime = 0;
        for (String script : _scripts) {
            watch.reset().start();
            RT.loadResourceScript(script);
            long elapsedTime = watch.elapsedMillis();
            LOGGER.info("Loaded {} in {}ms.", script, elapsedTime);
            totalTime += elapsedTime;
        }
        LOGGER.info("Loaded {} scripts in {}ms.", _scripts.size(), totalTime);

        if ("dev".equals(System.getProperty("app.env"))) {
            monitorForScriptChanges();
        }
    }

    @Override
    public void setApplicationContext(final ApplicationContext applicationContext) {
        _ctx = applicationContext;
    }

    private void monitorForScriptChanges() throws Exception {
        LOGGER.info("Monitoring scripts for changes...");

        final WatchService watchService = FileSystems.getDefault().newWatchService();

        Set<Path> paths = Sets.newHashSet();
        for (String script : _scripts) {
            Path path = Paths.get(getClass().getClassLoader().getResource(script).toURI()).getParent();
            paths.add(path);
        }

        for (Path path : paths) {
            path.register(watchService, StandardWatchEventKinds.ENTRY_MODIFY);
        }

        new Thread(new Runnable() {
            @Override
            public void run() {
                while (true) {
                    try {
                        WatchKey key = watchService.take();
                        for (WatchEvent<?> event : key.pollEvents()) {
                            LOGGER.info("Got event {} for script file {}. Reloading...", event.kind(), event.context());

                            for (String script : _scripts) {
                                if (script.endsWith(event.context().toString())) {
                                    Stopwatch watch = new Stopwatch().start();
                                    RT.loadResourceScript(script);
                                    LOGGER.info("Loaded {} in {}ms.", script, watch.elapsedMillis());
                                }
                            }
                        }

                        key.reset();
                    } catch (Exception ex) {
                        LOGGER.error("Error watching scripts for changes.", ex);
                    }
                }
            }
        }, "ClojureScriptLoader FileWatcher").start();
    }
}
