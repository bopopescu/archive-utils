package com.lockerz.common.template.handlebars;

import com.github.jknack.handlebars.Handlebars;
import com.github.jknack.handlebars.StringHelpers;
import com.github.jknack.handlebars.Template;
import com.github.jknack.handlebars.TemplateLoader;
import com.github.jknack.handlebars.springmvc.SpringTemplateLoader;
import com.google.common.base.Strings;
import org.springframework.web.servlet.view.AbstractTemplateViewResolver;
import org.springframework.web.servlet.view.AbstractUrlBasedView;

import java.io.IOException;
import java.net.URI;

/**
 * Created by James Baird
 * Date: 1/24/13
 * Time: 2:02 PM
 */
public class HandlebarsLayoutViewResolver extends AbstractTemplateViewResolver {

    private Template _layoutTemplate;
    private Handlebars _handlebars;

    private String _layoutTemplatePath;
    private TemplateData _templateData;
    private Helpers _helpers;

    public HandlebarsLayoutViewResolver() {
        setViewClass(HandlebarsLayoutView.class);
    }

    public void setLayoutTemplatePath(final String layoutTemplatePath) {
        _layoutTemplatePath = layoutTemplatePath;
    }

    public void setTemplateData(TemplateData templateData) {
        _templateData = templateData;
    }

    public void setHelpers(final Helpers helpers) {
        _helpers = helpers;
    }

    public void init() throws IOException {
        if (Strings.isNullOrEmpty(getSuffix())) {
            setSuffix(TemplateLoader.DEFAULT_SUFFIX);
        }

        TemplateLoader loader = new SpringTemplateLoader(getApplicationContext());
        loader.setPrefix(getPrefix());
        loader.setSuffix(getSuffix());

        _handlebars = new Handlebars(loader);
        StringHelpers.register(_handlebars);
        _handlebars.registerHelpers(_helpers);

        if (isCache()) {
            _layoutTemplate = _handlebars.compile(URI.create(_layoutTemplatePath));
        }
    }

    @Override
    protected Class requiredViewClass() {
        return HandlebarsLayoutView.class;
    }

    @Override
    protected HandlebarsLayoutView buildView(String viewName) throws Exception {
        HandlebarsLayoutView view = (HandlebarsLayoutView)super.buildView(viewName);

        view.setTemplateData(_templateData);
        if (isCache()) {
            view.setLayoutTemplate(_layoutTemplate);
        } else {
            view.setLayoutTemplate(_handlebars.compile(URI.create(_layoutTemplatePath)));
        }

        String url = view.getUrl();
        url = url.substring(getPrefix().length(), url.length() - getSuffix().length());
        view.setTemplate(_handlebars.compile(URI.create(url)));

        return view;
    }
}
