package com.lockerz.common.spring.jpa;

import org.springframework.beans.BeanUtils;
import org.springframework.beans.BeansException;
import org.springframework.beans.PropertyValues;
import org.springframework.beans.factory.BeanCreationException;
import org.springframework.beans.factory.BeanFactory;
import org.springframework.beans.factory.BeanFactoryAware;
import org.springframework.beans.factory.ListableBeanFactory;
import org.springframework.beans.factory.annotation.InjectionMetadata;
import org.springframework.beans.factory.config.InstantiationAwareBeanPostProcessor;
import org.springframework.beans.factory.support.MergedBeanDefinitionPostProcessor;
import org.springframework.beans.factory.support.RootBeanDefinition;
import org.springframework.core.Ordered;
import org.springframework.core.PriorityOrdered;
import org.springframework.orm.jpa.EntityManagerFactoryUtils;
import org.springframework.util.ClassUtils;

import javax.persistence.*;
import java.beans.PropertyDescriptor;
import java.io.Serializable;
import java.lang.reflect.*;
import java.util.LinkedList;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * @author Brian J. Gebala
 * @version 2/6/12 7:32 AM
 */
public class JpaContextPersistenceAnnotationBeanPostProcessor 
        implements InstantiationAwareBeanPostProcessor,
        MergedBeanDefinitionPostProcessor, PriorityOrdered, BeanFactoryAware, Serializable {
    //-------------------------------------------------------------
    // Constants
    //-------------------------------------------------------------

    private transient final Map<Class<?>, InjectionMetadata> _injectionMetadataCache =
            new ConcurrentHashMap<Class<?>, InjectionMetadata>();


    //-------------------------------------------------------------
    // Variables - Private
    //-------------------------------------------------------------

    private int _order = Ordered.LOWEST_PRECEDENCE - 4;
    private transient JpaContextImpl _context;
    private transient ListableBeanFactory _beanFactory;


    //-------------------------------------------------------------
    // Implementation - BeanFactoryAware
    //-------------------------------------------------------------
    
    @Override
    public void setBeanFactory(BeanFactory beanFactory) {
        if (beanFactory instanceof ListableBeanFactory) {
            _beanFactory = (ListableBeanFactory) beanFactory;
        }
    }


    //-------------------------------------------------------------
    // Implementation - BeanPostProcessor
    //-------------------------------------------------------------

    @Override
    public Object postProcessBeforeInitialization(final Object bean,
                                                  final String beanName)
            throws BeansException {
        return bean;
    }

    @Override
    public Object postProcessAfterInitialization(final Object bean,
                                                 final String beanName)
            throws BeansException {
        return bean;
    }


    //-------------------------------------------------------------
    // Implementation - InstantiationAwareBeanPostProcessor
    //-------------------------------------------------------------

    @Override
    public Object postProcessBeforeInstantiation(final Class<?> beanClass,
                                                 final String beanName)
            throws BeansException {
        return null;
    }

    @Override
    public boolean postProcessAfterInstantiation(final Object bean,
                                                 final String beanName)
            throws BeansException {
        return true;
    }

    @Override
    public PropertyValues postProcessPropertyValues(final PropertyValues pvs, 
                                                    final PropertyDescriptor[] pds, 
                                                    final Object bean, 
                                                    final String beanName) throws BeansException {
        InjectionMetadata metadata = findPersistenceMetadata(bean.getClass());
        
        try {
            metadata.inject(bean, beanName, pvs);
        }
        catch (Throwable ex) {
            throw new BeanCreationException(beanName, "Injection of persistence dependencies failed", ex);
        }
        
        return pvs;
    }


    //-------------------------------------------------------------
    // Implementation - MergedBeanDefinitionPostProcessor
    //-------------------------------------------------------------

    @Override
    public void postProcessMergedBeanDefinition(final RootBeanDefinition beanDefinition,
                                                final Class<?> beanType,
                                                final String beanName) {
        if (beanType != null) {
            InjectionMetadata metadata = findPersistenceMetadata(beanType);
            metadata.checkConfigMembers(beanDefinition);
        }
    }


    //-------------------------------------------------------------
    // Implementation - Ordered
    //-------------------------------------------------------------

    @Override
    public int getOrder() {
        return _order;
    }


    //-------------------------------------------------------------
    // Methods - Getter/Setter
    //-------------------------------------------------------------

    public void setJpaContext(final JpaContextImpl context) {
        _context = context;
    }

    public void setOrder(final int order) {
        _order = order;
    }


    //-------------------------------------------------------------
    // Methods - Private
    //-------------------------------------------------------------

    private InjectionMetadata findPersistenceMetadata(final Class<?> clazz) {
        // Quick check on the concurrent map first, with minimal locking.
        InjectionMetadata metadata = _injectionMetadataCache.get(clazz);
        if (metadata == null) {
            synchronized (_injectionMetadataCache) {
                metadata = _injectionMetadataCache.get(clazz);
                if (metadata == null) {
                    LinkedList<InjectionMetadata.InjectedElement> elements = new LinkedList<InjectionMetadata.InjectedElement>();
                    Class<?> targetClass = clazz;

                    do {
                        
                        
                        LinkedList<InjectionMetadata.InjectedElement> currElements = new LinkedList<InjectionMetadata.InjectedElement>();
                        
                        
                        for (Field field : targetClass.getDeclaredFields()) {
                            PersistenceContext pc = field.getAnnotation(PersistenceContext.class);
                            PersistenceUnit pu = field.getAnnotation(PersistenceUnit.class);
                            
                            if (pc != null || pu != null) {
                                if (Modifier.isStatic(field.getModifiers())) {
                                    throw new IllegalStateException("Persistence annotations are not supported on static fields");
                                }
                                currElements.add(new PersistenceElement(field, null));
                            }
                        }
                        
                        for (Method method : targetClass.getDeclaredMethods()) {
                            PersistenceContext pc = method.getAnnotation(PersistenceContext.class);
                            PersistenceUnit pu = method.getAnnotation(PersistenceUnit.class);
                            
                            if ((pc != null || pu != null) &&
                                    method.equals(ClassUtils.getMostSpecificMethod(method, clazz))) {
                                if (Modifier.isStatic(method.getModifiers())) {
                                    throw new IllegalStateException("Persistence annotations are not supported on static methods");
                                }
                                if (method.getParameterTypes().length != 1) {
                                    throw new IllegalStateException("Persistence annotation requires a single-arg method: " + method);
                                }
                                PropertyDescriptor pd = BeanUtils.findPropertyForMethod(method);
                                currElements.add(new PersistenceElement(method, pd));
                            }
                        }
                        
                        elements.addAll(0, currElements);
                        targetClass = targetClass.getSuperclass();
                    }
                    while (targetClass != null && targetClass != Object.class);

                    metadata = new InjectionMetadata(clazz, elements);
                    _injectionMetadataCache.put(clazz, metadata);
                }
            }
        }
        return metadata;
    }


    //-------------------------------------------------------------
    // Inner Class
    //-------------------------------------------------------------

    /**
     * Class representing injection information about an annotated field
     * or setter method.
     */
    private class PersistenceElement extends InjectionMetadata.InjectedElement {
        private final String _unitName;
        private PersistenceContextType _type;

        public PersistenceElement(Member member, PropertyDescriptor pd) {
            super(member, pd);
            AnnotatedElement ae = (AnnotatedElement) member;
            PersistenceContext pc = ae.getAnnotation(PersistenceContext.class);
            PersistenceUnit pu = ae.getAnnotation(PersistenceUnit.class);
            Class<?> resourceType = EntityManager.class;

            if (pc != null) {
                if (pu != null) {
                    throw new IllegalStateException("Member may only be annotated with either " +
                            "@PersistenceContext or @PersistenceUnit, not both: " + member);
                }
                _unitName = pc.unitName();
                _type = pc.type();
            }
            else {
                resourceType = EntityManagerFactory.class;
                _unitName = pu.unitName();
            }

            checkResourceType(resourceType);            
        }

        @Override
        protected Object getResourceToInject(final Object target, 
                                             final String requestingBeanName) {
            EntityManagerFactory emf = EntityManagerFactoryUtils.findEntityManagerFactory(_beanFactory, _unitName);
            
            if (_type != null) {
                return InjectedEntityManagerProxy.newInstance(_context, emf);
            }
            else {
                return emf;
            }
        }
    }
}
