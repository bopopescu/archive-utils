package com.lockerz.common.template.handlebars;

import com.github.jknack.handlebars.Options;
import com.github.jknack.handlebars.Template;

import java.io.IOException;
import java.io.StringWriter;
import java.util.Collection;

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
        _templateData.addCss(css);
        return "";
    }

    public CharSequence require_javascript(final String js) {
        _templateData.addJs(js);
        return "";
    }

    public CharSequence javascripts(final Options options) throws IOException {
        return applyCollection(_templateData.getJs(), options.fn);
    }

    public CharSequence stylesheets(final Options options) throws IOException {
        return applyCollection(_templateData.getCss(), options.fn);
    }

    private CharSequence applyCollection(final Collection<?> list, final Template template) throws IOException {
        StringWriter writer = new StringWriter();
        for (Object context : list) {
            template.apply(context, writer);
        }

        return writer.toString();
    }

}
