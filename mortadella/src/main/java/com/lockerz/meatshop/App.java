package com.lockerz.meatshop;

import com.google.inject.Guice;
import com.google.inject.Injector;
import com.lockerz.meatshop.dao.DaoModule;
import com.lockerz.meatshop.dao.ShopDao;
import com.lockerz.meatshop.dao.ShopDaoImpl;
import com.lockerz.meatshop.dao.UserDao;
import com.lockerz.meatshop.dao.UserDaoImpl;
import com.lockerz.meatshop.model.Meat;
import com.lockerz.meatshop.model.Shop;
import com.lockerz.meatshop.model.User;
import com.lockerz.meatshop.model2.Address;
import com.lockerz.meatshop.model2.AddressDao;
import com.lockerz.meatshop.model2.Model2Module;
import com.lockerz.meatshop.service.ServiceModule;
import com.lockerz.meatshop.service.ShopService;

/**
 * @author Brian Gebala
 * @version 1/15/13 1:08 PM
 */
public class App {
    public static void main(final String[] args) {
        Injector injector = Guice.createInjector(new ConfigModule(), new DaoModule(), new Model2Module(), new ServiceModule());
        ShopService shopService = injector.getInstance(ShopService.class);
        AddressDao addrDao = injector.getInstance(AddressDao.class);

        User user = shopService.register("guacimo@eataly.com", "iLuvMeaT");
        Shop shop = shopService.newShop("Long Duck Dong Meats");
        Address addr = addrDao.newAddress("100 S. King St..", "Seattle");

        int x = 1;
    }
}
