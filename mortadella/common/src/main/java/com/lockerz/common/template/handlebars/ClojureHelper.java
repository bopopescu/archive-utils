package com.lockerz.common.template.handlebars;

import clojure.lang.IFn;
import clojure.lang.IteratorSeq;
import clojure.lang.PersistentHashMap;
import com.github.jknack.handlebars.Handlebars;
import com.github.jknack.handlebars.Helper;
import com.github.jknack.handlebars.Options;
import com.google.common.collect.Lists;

import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * Created by James Baird
 * Date: 1/25/13
 * Time: 3:32 PM
 */
public class ClojureHelper implements Helper<Object> {

    private IFn _fn;

    public ClojureHelper(final IFn fn) {
        _fn = fn;
    }

    @Override
    public CharSequence apply(final Object arg, final Options options) throws IOException {
        List<Object> args = Lists.newLinkedList();

        int index = 0;
        Object nextArg = arg;
        while (nextArg != null) {
            args.add(nextArg);
            nextArg = options.param(index, null);
            ++index;
        }

        if (options.hash.size() > 0) {
            args.add(PersistentHashMap.create(options.hash));
        }

        return (CharSequence)_fn.applyTo(IteratorSeq.create(args.iterator()));
    }
}
