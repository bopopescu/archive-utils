package com.lockerz.common.template.handlebars;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.introspect.AnnotatedClass;
import com.fasterxml.jackson.databind.introspect.JacksonAnnotationIntrospector;
import com.fasterxml.jackson.databind.ser.BeanPropertyFilter;
import com.fasterxml.jackson.databind.ser.FilterProvider;
import com.fasterxml.jackson.databind.ser.impl.SimpleBeanPropertyFilter;
import com.github.jknack.handlebars.Handlebars;
import com.github.jknack.handlebars.Helper;
import com.github.jknack.handlebars.Options;

import java.io.IOException;

/**
 * Created by James Baird
 * Date: 2/1/13
 * Time: 1:22 PM
 */
public class JsonHelper implements Helper<Object> {

    private static class DefaultFilterProvider extends FilterProvider {
        private BeanPropertyFilter _filter;

        private DefaultFilterProvider(final BeanPropertyFilter filter) {
            _filter = filter;
        }

        @Override
        public BeanPropertyFilter findFilter(final Object filterId) {
            return _filter;
        }
    }

    private ObjectMapper _objectMapper;

    public JsonHelper() {
        _objectMapper = new ObjectMapper();
        _objectMapper.setAnnotationIntrospector(new JacksonAnnotationIntrospector() {
            @Override
            public Object findFilterId(final AnnotatedClass ac) {
                Object id = super.findFilterId(ac);
                if (id == null) {
                    id = ac.getName();
                }

                return id;
            }
        });
    }

    @Override
    public CharSequence apply(final Object object, final Options options) throws IOException {
        String[] propertyNames = new String[options.params.length];

        int i = 0;
        for (Object param : options.params) {
            propertyNames[i++] = (String)param;
        }

        BeanPropertyFilter filter = SimpleBeanPropertyFilter.filterOutAllExcept(propertyNames);
        String json = _objectMapper.writer(new DefaultFilterProvider(filter)).writeValueAsString(object);
        return new Handlebars.SafeString(json);
    }
}
