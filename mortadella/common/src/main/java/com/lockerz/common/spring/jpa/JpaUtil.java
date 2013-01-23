package com.lockerz.common.spring.jpa;

import org.apache.openjpa.kernel.DataCacheRetrieveMode;
import org.apache.openjpa.persistence.EntityExistsException;
import org.apache.openjpa.persistence.OpenJPAPersistence;
import org.apache.openjpa.persistence.OpenJPAQuery;
import org.springframework.dao.DataIntegrityViolationException;

import javax.persistence.Query;
import java.util.Arrays;
import java.util.List;

/**
 * @author Brian Gebala
 * @version 8/27/12 9:54 AM
 */
public class JpaUtil {
    public static boolean isUniqueIndexViolation(final Exception ex) {
        boolean result = false;

        if (ex instanceof DataIntegrityViolationException) {
            if (ex.getCause() instanceof EntityExistsException) {
                EntityExistsException entityExistsException = (EntityExistsException)ex.getCause();
                Throwable[] nestedThrowables = entityExistsException.getNestedThrowables();

                if (nestedThrowables != null && nestedThrowables.length > 0) {
                    for (Throwable throwable : nestedThrowables) {
                        if (throwable instanceof EntityExistsException && throwable.getMessage().startsWith("Duplicate entry")) {
                            result = true;
                        }
                    }
                }
            }
        }

        return result;
    }

    public static void disableCache(final Query query) {
        OpenJPAQuery jpaQuery = OpenJPAPersistence.cast(query);
        jpaQuery.getFetchPlan().setCacheRetrieveMode(DataCacheRetrieveMode.BYPASS);
        jpaQuery.getFetchPlan().setQueryResultCacheEnabled(false);
    }
}
