package com.lockerz.meatshop.service.shop.dao;

import com.google.inject.Provider;

/**
 * @author Brian Gebala
 * @version 1/16/13 3:23 PM
 */
public class UserDaoProvider implements Provider<UserDao> {
    @Override
    public UserDao get() {
        return new UserDaoImpl();
    }
}
