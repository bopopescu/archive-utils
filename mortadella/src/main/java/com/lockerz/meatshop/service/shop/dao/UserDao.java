package com.lockerz.meatshop.service.shop.dao;

import com.lockerz.meatshop.service.shop.model.User;

/**
 * @author Brian Gebala
 * @version 1/15/13 1:42 PM
 */
public interface UserDao {
    public User findUserById(final int id);

    public User findUserByEmail(final String email);

    public User findUserForLogin(final String email,
                                 final String password);

    public void persistUser(final User user);

    public void removeUser(final User user);
}
