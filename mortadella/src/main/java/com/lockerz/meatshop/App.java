package com.lockerz.meatshop;

import com.google.common.collect.Lists;
import com.google.common.util.concurrent.Service;
import com.google.inject.Binding;
import com.google.inject.Guice;
import com.google.inject.Injector;
import com.lockerz.meatshop.jpa.JpaContextService;
import com.lockerz.meatshop.service.address.AddressService;
import com.lockerz.meatshop.service.address.AddressServiceModule;
import com.lockerz.meatshop.service.address.dao.AddressDao;
import com.lockerz.meatshop.service.address.dao.AddressDaoModule;
import com.lockerz.meatshop.service.address.model.Address;
import com.lockerz.meatshop.service.rest.JettyServerServiceModule;
import com.lockerz.meatshop.service.shop.ShopServiceModule;
import com.lockerz.meatshop.service.shop.dao.ShopDaoModule;
import com.lockerz.meatshop.service.shop.model.Meat;
import com.lockerz.meatshop.service.shop.model.Shop;
import com.lockerz.meatshop.service.shop.model.User;
import com.lockerz.meatshop.service.shop.ShopService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.FileReader;
import java.util.List;
import java.util.Properties;

/**
 * @author Brian Gebala
 * @version 1/15/13 1:08 PM
 */
public class App {
    private final static Logger LOGGER = LoggerFactory.getLogger(App.class);

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
                new JettyServerServiceModule(),
                new ShopDaoModule(properties),
                new ShopServiceModule());

        final List<Service> services = Lists.newLinkedList();

        Runtime.getRuntime().addShutdownHook(new Thread() {
            @Override
            public void run() {
                LOGGER.info("App is shutting down.");

                for (Service service : services) {
                    try {
                        service.stop();
                    }
                    catch (Exception ex) {
                        LOGGER.error("Error stopping service: " + service, ex);
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

        Object boundary = new Object();
        JpaContextService jpaContextService = injector.getInstance(JpaContextService.class);
        jpaContextService.enterContext(boundary);

        try {
            ShopService shopService = injector.getInstance(ShopService.class);

            for (Shop shop : shopService.findAllShops()) {
                System.out.println(shop.getName());
                for (Meat meat : shop.getMeats()) {
                    System.out.println(" " + meat.getName());
                }
            }

            User user = shopService.login("guacimo@eataly.com", "iLuvMeaT");
            user = shopService.login("guacimo@eataly.com", "iLuvMeaT");

            jpaContextService.flushDataCaches();

            user = shopService.login("guacimo@eataly.com", "iLuvMeaT");

            AddressService addressService = injector.getInstance(AddressService.class);
            Address addr = addressService.newAddress("100 S. King St..", "Seattle");
        }
        finally {
            jpaContextService.exitContext(boundary);
        }

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

        //System.exit(1);
    }
}
