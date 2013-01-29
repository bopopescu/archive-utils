package com.lockerz.common.template.handlebars;

import com.github.jknack.handlebars.Handlebars;

/**
 * Created by James Baird
 * Date: 1/24/13
 * Time: 11:30 AM
 */
public class Helpers {

    private TemplateData _templateData;

    public void setTemplateData(final TemplateData templateData) {
        _templateData = templateData;
    }

    public CharSequence require_css(final String css) {
        _templateData.getCss().add(css);
        return "";
    }

    public CharSequence require_javascript(final String js) {
        _templateData.getJs().add(js);
        return "";
    }

}
