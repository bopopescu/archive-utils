package com.lockerz.common.template.handlebars;

import com.github.jknack.handlebars.Context;
import com.github.jknack.handlebars.Template;
import com.github.jknack.handlebars.ValueResolver;
import org.springframework.web.servlet.view.AbstractTemplateView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.StringWriter;
import java.util.Map;

/**
 * Created by James Baird
 * Date: 1/24/13
 * Time: 1:46 PM
 */
public class HandlebarsLayoutView extends AbstractTemplateView {

    private TemplateData _templateData;
    private Template _layoutTemplate;
    private Template _template;

    public void setTemplateData(final TemplateData templateData) {
        _templateData = templateData;
    }

    public void setLayoutTemplate(final Template layoutTemplate) {
        _layoutTemplate = layoutTemplate;
    }

    public void setTemplate(final Template template) {
        _template = template;
    }

    @Override
    protected void renderMergedTemplateModel(final Map<String, Object> model,
                                             final HttpServletRequest request,
                                             final HttpServletResponse response)
            throws Exception
    {
        Context context = Context.newBuilder(model)
                .resolver(ValueResolver.VALUE_RESOLVERS)
                .build();
        String content;
        try {
            content = _template.apply(context);

            Context layoutContext = Context.newBuilder(context, _templateData.getModelForLayout(content))
                    .resolver(ValueResolver.VALUE_RESOLVERS)
                    .build();
            try {
                _layoutTemplate.apply(layoutContext, response.getWriter());
            } finally {
                layoutContext.destroy();
            }
        } finally {
            context.destroy();
        }


    }

}
