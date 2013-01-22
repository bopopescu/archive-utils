package com.lockerz.meatshop.service.rest;

import com.google.inject.BindingAnnotation;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

/**
 * @author Brian Gebala
 * @version 1/21/13 1:05 PM
 */
@Retention(RetentionPolicy.RUNTIME)
@BindingAnnotation
public @interface AdminHandler {
}
