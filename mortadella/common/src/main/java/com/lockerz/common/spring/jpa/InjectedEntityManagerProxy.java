package com.lockerz.common.spring.jpa;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;

/**
 * @author Brian J. Gebala
 * @version 2/6/12 8:08 AM
 */
public class InjectedEntityManagerProxy implements InvocationHandler {
    //-------------------------------------------------------------
    // Variables - Private
    //-------------------------------------------------------------

    private JpaContextImpl _context;
    private EntityManagerFactory _emf;


    //-------------------------------------------------------------
    // Constructors
    //-------------------------------------------------------------

    private InjectedEntityManagerProxy(final JpaContextImpl context,
                                       final EntityManagerFactory emf) {
        _context = context;
        _emf = emf;
    }


    //-------------------------------------------------------------
    // Implementation - InvocationHandler
    //-------------------------------------------------------------

    @Override
    public Object invoke(final Object proxy, final Method method, final Object[] args) throws Throwable {
        EntityManager em = _context.getEm(_emf);
        return method.invoke(em, args);
    }


    //-------------------------------------------------------------
    // Methods - Public - Static
    //-------------------------------------------------------------

    public static EntityManager newInstance(final JpaContextImpl context,
                                            final EntityManagerFactory emf) {
        InjectedEntityManagerProxy injected = new InjectedEntityManagerProxy(context, emf);
        return (EntityManager)Proxy.newProxyInstance(
                context.getClass().getClassLoader(),
                new Class[] {EntityManager.class},
                injected);
    }
}
