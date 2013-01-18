package com.lockerz.meatshop.jpa;

import com.google.inject.Inject;
import org.aopalliance.intercept.MethodInterceptor;
import org.aopalliance.intercept.MethodInvocation;

/**
 * @author Brian Gebala
 * @version 1/18/13 10:39 AM
 */
public class JpaContextAwareInterceptor implements MethodInterceptor {
    @Inject JpaContextService _jpaContext;

    @Override
    public Object invoke(final MethodInvocation methodInvocation) throws Throwable {
        // Ideally the enter/exit boundary would be methodInvocation.getThis(), but
        // that AOP Alliance object has some bizarre toString() behavior.

        _jpaContext.enterContext(methodInvocation.getMethod().getDeclaringClass());

        try {
            return methodInvocation.proceed();
        }
        finally {
            _jpaContext.exitContext(methodInvocation.getMethod().getDeclaringClass());
        }
    }
}
