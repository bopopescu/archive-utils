package com.lockerz.common.template.handlebars;

import com.google.common.collect.ImmutableMap;
import com.google.common.collect.Sets;

import java.util.Map;
import java.util.Set;

/**
 * Created by James Baird
 * Date: 1/24/13
 * Time: 11:44 AM
 */
public class TemplateData {

    private String _title;
    private Set<String> _css = Sets.newLinkedHashSet();
    private Set<String> _js = Sets.newLinkedHashSet();

    public String getTitle() {
        return _title;
    }

    public void setTitle(final String title) {
        _title = title;
    }

    public Set<String> getCss() {
        return _css;
    }

    public Set<String> getJs() {
        return _js;
    }

    public Map<String, Object> getModelForLayout(final String content) {
        return ImmutableMap.<String, Object>builder()
                .put("content", content)
                .put("title", _title)
                .put("javascripts", _js)
                .put("stylesheets", _css)
                .build();
    }

}
