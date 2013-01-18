package com.lockerz.meatshop.jpa;

import org.aopalliance.intercept.MethodInterceptor;
import org.aopalliance.intercept.MethodInvocation;

import javax.inject.Inject;
import javax.persistence.EntityManager;

/**
 * @author Brian Gebala
 * @version 1/18/13 10:01 AM
 */
public class JpaTransactionalInterceptor implements MethodInterceptor {
    // A bean of this type is manually created in JpaProviderServiceModule, but is not bound in the Injector. Since the
    // JpaProviderService and JpaContextService dependencies are beans bound in the Injector, this bean needs to have
    // these dependencies injected. These dependencies are not yet available in JpaProviderServiceModule when creating
    // this bean, hence the need for field injection.

    @Inject
    private JpaProviderService _jpaProviderService;
    @Inject
    private JpaContextService _jpaContext;
    private ThreadLocal<Integer> _threadLocalRefCount = new ThreadLocal<Integer>();

    @Override
    public Object invoke(final MethodInvocation methodInvocation) throws Throwable {
        EntityManager em = _jpaContext.getEm(_jpaProviderService.getEmf());
        Integer refCount = _threadLocalRefCount.get();
        boolean boundary = false;

        if (refCount == null) {
            refCount = 1;
            _threadLocalRefCount.set(refCount);
            boundary = true;
        }
        else {
            refCount++;
            _threadLocalRefCount.set(refCount);
        }

        if (boundary) {
            em.getTransaction().begin();
        }

        Object result;

        try {
            result = methodInvocation.proceed();
        }
        catch (Throwable thr) {
            if (boundary) {
                em.getTransaction().rollback();
            }
            throw thr;
        }
        finally {
            refCount--;

            if (refCount == 0) {
                _threadLocalRefCount.remove();
            }
            else {
                _threadLocalRefCount.set(refCount);
            }
        }

        if (boundary) {
            em.getTransaction().commit();
        }

        return result;
    }
}
