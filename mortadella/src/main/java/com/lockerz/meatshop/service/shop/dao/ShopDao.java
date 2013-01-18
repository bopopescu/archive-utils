package com.lockerz.meatshop.service.shop.dao;

import com.lockerz.meatshop.service.shop.model.Meat;
import com.lockerz.meatshop.service.shop.model.Shop;

import java.util.List;

/**
 * @author Brian Gebala
 * @version 1/15/13 3:29 PM
 */
public interface ShopDao {
    public Meat findMeatById(final int id);

    public Shop findShopById(final int id);

    public List<Shop> findAllShops();

    public Meat newMeat(final String name,
                        final int priceDollars,
                        final Shop shop);

    public Shop newShop(final String name);
}
