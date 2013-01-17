package com.lockerz.meatshop;

import com.google.common.collect.Lists;
import com.google.common.util.concurrent.ListenableFuture;
import com.google.common.util.concurrent.Service;
import com.google.inject.Binding;
import com.google.inject.Guice;
import com.google.inject.Injector;
import com.google.inject.TypeLiteral;
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

import java.util.List;

/**
 * @author Brian Gebala
 * @version 1/15/13 1:08 PM
 */
public class App {
    public static void main(final String[] args) {
        Injector injector = Guice.createInjector(new ConfigModule(), new DaoModule(), new Model2Module(), new ServiceModule());
        final List<Service> services = Lists.newLinkedList();

        Runtime.getRuntime().addShutdownHook(new Thread() {
            @Override
            public void run() {
                System.out.println("App is shutting down.");

                for (Service service : services) {
                    try {
                        service.stop();
                    }
                    catch (Exception ex) {
                        System.out.println("Error stopping service: " + service.getClass());
                        ex.printStackTrace();
                    }
                }
            }
        });

        for (Binding<?> binding : injector.getAllBindings().values()) {
            if (Service.class.isAssignableFrom(binding.getKey().getTypeLiteral().getRawType())) {
                Service service = (Service)injector.getInstance(binding.getKey());
                service.startAndWait();
                services.add(service);
            }
        }

        ShopService shopService = injector.getInstance(ShopService.class);
        AddressDao addrDao = injector.getInstance(AddressDao.class);

        User user = shopService.register("guacimo@eataly.com", "iLuvMeaT");
        Address addr = addrDao.newAddress("100 S. King St..", "Seattle");
        ListenableFuture<Shop> shopLF = shopService.newShopLF("Long Duck Dong Meats");

        try {
            Shop shop = shopLF.get();
            int x = 1;
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }

        int x = 1;
    }
}
