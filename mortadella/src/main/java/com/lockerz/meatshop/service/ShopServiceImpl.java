package com.lockerz.meatshop.service;

import com.google.inject.Inject;
import com.lockerz.meatshop.dao.ShopDao;
import com.lockerz.meatshop.dao.UserDao;

/**
 * @author Brian Gebala
 * @version 1/16/13 9:34 AM
 */
public class ShopServiceImpl implements ShopService {
    private ShopDao _shopDao;
    private UserDao _userDao;

    @Inject
    public ShopServiceImpl(final ShopDao shopDao,
                           final UserDao userDao) {
        _shopDao = shopDao;
        _userDao = userDao;
    }
}
