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
import com.lockerz.meatshop.service.ServiceModule;

/**
 * @author Brian Gebala
 * @version 1/15/13 1:08 PM
 */
public class App {
    public static void main(final String[] args) {
        Injector injector = Guice.createInjector(new DaoModule(), new ServiceModule());
        ShopDao shopDao = injector.getInstance(ShopDaoImpl.class);
        UserDao userDao = injector.getInstance(UserDaoImpl.class);

        //Shop shop = shopDao.newShop("Big Mario's Meats");
        //Meat guanciale = shopDao.newMeat("Guanciale", 10, shop);

        userDao.findUserByEmail("gebala@lockerz.com");
        userDao.findUserForLogin("gebala@lockerz.com", "il2wwqs");

        shopDao.findAllShops();

        //User brian = new User();
        //brian.setEmail("gebala@lockerz.com");
        //brian.setPassword("il2wwqs");
        //userDao.persistUser(brian);
        //userDao.persistUser(brian);

        //User user1 = userDao.findUserById(8);
        //User user2 = userDao.findUserById(1);

        int x = 1;
    }
}
