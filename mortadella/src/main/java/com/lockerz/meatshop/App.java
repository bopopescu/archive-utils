package com.lockerz.meatshop;

import com.google.common.collect.Lists;
import com.google.common.util.concurrent.Service;
import com.google.inject.Binding;
import com.google.inject.Guice;
import com.google.inject.Injector;
import com.lockerz.meatshop.service.address.AddressService;
import com.lockerz.meatshop.service.address.AddressServiceModule;
import com.lockerz.meatshop.service.address.dao.AddressDao;
import com.lockerz.meatshop.service.address.dao.AddressDaoModule;
import com.lockerz.meatshop.service.address.model.Address;
import com.lockerz.meatshop.service.shop.ShopServiceModule;
import com.lockerz.meatshop.service.shop.dao.ShopDaoModule;
import com.lockerz.meatshop.service.shop.model.User;
import com.lockerz.meatshop.service.shop.ShopService;

import java.io.FileReader;
import java.util.List;
import java.util.Properties;

/**
 * @author Brian Gebala
 * @version 1/15/13 1:08 PM
 */
public class App {
    public static void main(final String[] args) {
        Properties properties = new Properties();

        try {
            properties.load(new FileReader("app.properties"));
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }

        Injector injector = Guice.createInjector(
                new AppModule(properties),
                new AddressDaoModule(properties),
                new AddressServiceModule(),
                new ShopDaoModule(properties),
                new ShopServiceModule());

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
        User user = shopService.login("guacimo@eataly.com", "iLuvMeaT");

        AddressService addressService = injector.getInstance(AddressService.class);
        Address addr = addressService.newAddress("100 S. King St..", "Seattle");

        int x = 1;

        //User user = shopService.register("guacimo@eataly.com", "iLuvMeaT");
        //ListenableFuture<Shop> shopLF = shopService.newShopLF("Long Duck Dong Meats");

        /*
        try {
            Shop shop = shopLF.get();
            int x = 1;
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
        */

        System.exit(1);
    }
}
