package com.lockerz.meatshop.service;

import com.google.inject.AbstractModule;
import com.google.inject.Provides;
import com.google.inject.name.Named;
import com.lockerz.meatshop.dao.ShopDao;
import com.lockerz.meatshop.dao.UserDao;

/**
 * @author Brian Gebala
 * @version 1/16/13 9:35 AM
 */
public class ServiceModule extends AbstractModule {
    @Override
    protected void configure() {
        // No-op.
    }

    @Provides
    public ShopService provideShopService(@Named("shop.service.maxPrice") final int maxPrice,
                                          final ShopDao shopDao,
                                          final UserDao userDao) {
        ShopServiceImpl shopService = new ShopServiceImpl(shopDao, userDao);
        shopService.setMaxPrice(maxPrice);
        return shopService;
    }
}
