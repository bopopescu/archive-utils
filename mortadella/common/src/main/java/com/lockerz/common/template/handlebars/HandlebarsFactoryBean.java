package com.lockerz.common.template.handlebars;

import com.github.jknack.handlebars.Handlebars;
import com.github.jknack.handlebars.StringHelpers;
import com.github.jknack.handlebars.TemplateLoader;
import com.github.jknack.handlebars.springmvc.SpringTemplateLoader;
import com.google.common.base.Strings;
import org.springframework.beans.factory.FactoryBean;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

/**
 * Created by James Baird
 * Date: 1/25/13
 * Time: 1:12 PM
 */
public class HandlebarsFactoryBean implements FactoryBean<Handlebars>, ApplicationContextAware {

    private String _prefix;
    private String _suffix;
    private Helpers _helpers;
    private ApplicationContext _ctx;

    public void setPrefix(final String prefix) {
        _prefix = prefix;
    }

    public void setSuffix(final String suffix) {
        _suffix = suffix;
    }

    public void setHelpers(final Helpers helpers) {
        _helpers = helpers;
    }

    @Override
    public Handlebars getObject() throws Exception {
        TemplateLoader loader = new SpringTemplateLoader(_ctx);
        loader.setPrefix(_prefix);
        loader.setSuffix(Strings.isNullOrEmpty(_suffix) ? TemplateLoader.DEFAULT_SUFFIX : _suffix);

        Handlebars handlebars = new Handlebars(loader);
        StringHelpers.register(handlebars);
        handlebars.registerHelper("json", new JsonHelper());
        handlebars.registerHelpers(_helpers);

        return handlebars;
    }

    @Override
    public Class<Handlebars> getObjectType() {
        return Handlebars.class;
    }

    @Override
    public boolean isSingleton() {
        return true;
    }

    @Override
    public void setApplicationContext(final ApplicationContext applicationContext) {
        _ctx = applicationContext;
    }
}
