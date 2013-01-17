package com.lockerz.meatshop.service;

import com.google.inject.Inject;
import com.lockerz.meatshop.dao.ShopDao;
import com.lockerz.meatshop.dao.UserDao;
import com.lockerz.meatshop.model.Shop;
import com.lockerz.meatshop.model.User;

/**
 * @author Brian Gebala
 * @version 1/16/13 9:34 AM
 */
public class ShopServiceImpl implements ShopService {
    private int _maxPrice;
    private ShopDao _shopDao;
    private UserDao _userDao;

    @Inject
    public ShopServiceImpl(final ShopDao shopDao,
                           final UserDao userDao) {
        _shopDao = shopDao;
        _userDao = userDao;
    }

    public int getMaxPrice() {
        return _maxPrice;
    }

    public void setMaxPrice(final int maxPrice) {
        _maxPrice = maxPrice;
    }

    @Override
    public User register(final String email,
                         final String password) {
        User user = new User();
        user.setEmail(email);
        user.setPassword(password);

        _userDao.persistUser(user);

        return user;
    }

    @Override
    public Shop newShop(final String name) {
        return _shopDao.newShop(name);
    }
}
