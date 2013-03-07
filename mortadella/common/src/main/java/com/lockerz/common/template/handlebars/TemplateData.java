package com.lockerz.common.template.handlebars;

import com.google.common.base.Strings;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.Iterables;
import com.google.common.collect.Sets;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.servlet.support.RequestContextUtils;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;
import java.util.Set;

/**
 * Created by James Baird
 * Date: 1/24/13
 * Time: 11:44 AM
 */
public class TemplateData {

    private boolean _inLayout;

    private Set<String> _css = Sets.newLinkedHashSet();
    private Set<String> _js = Sets.newLinkedHashSet();
    private Set<String> _layoutCss = Sets.newLinkedHashSet();
    private Set<String> _layoutJs = Sets.newLinkedHashSet();

    public void setInLayout(final boolean inLayout) {
        _inLayout = inLayout;
    }

    public void addCss(final String css) {
        (_inLayout ? _layoutCss : _css ).add(css);
    }

    public void addJs(final String js) {
        (_inLayout ? _layoutJs : _js).add(js);
    }

    public Set<String> getJs() {
        return Sets.newLinkedHashSet(Iterables.concat(_layoutJs, _js));
    }

    public Set<String> getCss() {
        return Sets.newLinkedHashSet(Iterables.concat(_layoutCss, _css));
    }

    public Map<String, Object> getModelForLayout(final String content) {
        HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
        Map<String, ?> flashMap = RequestContextUtils.getInputFlashMap(request);
        String errors = flashMap != null ? (String)flashMap.get("errors") : null;

        return ImmutableMap.<String, Object>builder()
                .put("content", content)
                .put("stylesheets", Sets.newLinkedHashSet(Iterables.concat(_layoutCss, _css)))
                .put("errors", Strings.nullToEmpty(errors))
                .build();
    }

}
