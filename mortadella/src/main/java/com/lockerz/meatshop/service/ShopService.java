package com.lockerz.meatshop.service;

import com.lockerz.meatshop.model.Shop;
import com.lockerz.meatshop.model.User;

/**
 * @author Brian Gebala
 * @version 1/16/13 9:34 AM
 */
public interface ShopService {
    public int getMaxPrice();

    public User register(final String email,
                         final String password);

    public Shop newShop(final String name);
}
