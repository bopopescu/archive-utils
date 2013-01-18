package com.lockerz.meatshop.service.shop;

import com.google.inject.AbstractModule;

/**
 * @author Brian Gebala
 * @version 1/16/13 9:35 AM
 */
public class ShopServiceModule extends AbstractModule {
    @Override
    protected void configure() {
        bind(ShopService.class).to(ShopServiceImpl.class).asEagerSingleton();
    }

    /*
    @Provides
    public ShopService provideShopService(@Named("shop.service.maxPrice") final int maxPrice,
                                          final ShopDao shopDao,
                                          final UserDao userDao) {
        ShopServiceImpl shopService = new ShopServiceImpl(shopDao, userDao);
        shopService.setMaxPrice(maxPrice);
        return shopService;
    }
    */
}
