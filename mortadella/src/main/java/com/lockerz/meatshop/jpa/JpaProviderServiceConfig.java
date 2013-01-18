package com.lockerz.meatshop.jpa;

import com.google.inject.BindingAnnotation;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

/**
 * @author Brian Gebala
 * @version 1/18/13 10:28 AM
 */
@Retention(RetentionPolicy.RUNTIME)
@BindingAnnotation
public @interface JpaProviderServiceConfig {
}
