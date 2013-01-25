package com.lockerz.common.clojure;

import clojure.lang.RT;

import java.io.IOException;
import java.util.List;

/**
 * Created by James Baird
 * Date: 1/25/13
 * Time: 10:21 AM
 */
public class ClojureScriptLoader {

    private List<String> _scripts;

    public void setScripts(final List<String> scripts) {
        _scripts = scripts;
    }

    public void init() throws IOException {
        for (String script : _scripts) {
            RT.loadResourceScript(script);
        }
    }

}
