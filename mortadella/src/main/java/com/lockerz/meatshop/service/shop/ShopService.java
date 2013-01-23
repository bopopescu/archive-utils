package com.lockerz.meatshop.service.shop;

import com.google.common.util.concurrent.ListenableFuture;
import com.lockerz.meatshop.service.shop.model.Shop;
import com.lockerz.meatshop.service.shop.model.User;

import java.util.List;

/**
 * @author Brian Gebala
 * @version 1/16/13 9:34 AM
 */
public interface ShopService {
    public User findUserByEmail(final String email);

    public User login(final String email,
                      final String password);

    public User register(final String email,
                         final String password);

    public Shop newShop(final String name);

    public ListenableFuture<Shop> newShopLF(final String name);

    public List<Shop> findAllShops();
}
