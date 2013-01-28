package com.lockerz.common.clojure;

import clojure.lang.Namespace;
import clojure.lang.RT;
import clojure.lang.Symbol;
import clojure.lang.Var;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

import java.io.IOException;
import java.util.List;

/**
 * Created by James Baird
 * Date: 1/25/13
 * Time: 10:21 AM
 */
public class ClojureScriptLoader implements ApplicationContextAware {

    private ApplicationContext _ctx;
    private List<String> _scripts;

    public void setScripts(final List<String> scripts) {
        _scripts = scripts;
    }

    public void init() throws IOException {
        Var.intern(Namespace.findOrCreate(Symbol.intern("com.lockerz")), Symbol.intern("application-context"), _ctx);

        for (String script : _scripts) {
            RT.loadResourceScript(script);
        }
    }

    @Override
    public void setApplicationContext(final ApplicationContext applicationContext) {
        _ctx = applicationContext;
    }
}
