package com.lockerz.meatshop;

import com.google.common.collect.Lists;
import com.google.common.util.concurrent.Service;
import com.google.inject.Binding;
import com.google.inject.Guice;
import com.google.inject.Injector;
import com.lockerz.meatshop.jpa.JpaContextService;
import com.lockerz.meatshop.service.address.AddressService;
import com.lockerz.meatshop.service.address.AddressServiceModule;
import com.lockerz.meatshop.service.address.dao.AddressDaoModule;
import com.lockerz.meatshop.service.address.model.Address;
import com.lockerz.meatshop.service.rest.JettyServerServiceModule;
import com.lockerz.meatshop.service.shop.ShopService;
import com.lockerz.meatshop.service.shop.ShopServiceModule;
import com.lockerz.meatshop.service.shop.dao.ShopDaoModule;
import com.lockerz.meatshop.service.shop.model.Meat;
import com.lockerz.meatshop.service.shop.model.Shop;
import com.lockerz.meatshop.service.shop.model.User;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.FileReader;
import java.util.List;
import java.util.Properties;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;




/**
 * @author Brian Gebala
 * @version 1/15/13 1:08 PM
 */
public class App {
    private final static Logger LOGGER = LoggerFactory.getLogger(App.class);
    public static class Services implements Service.Listener {
        public static class ShutdownThread extends Thread {
            private Services _services;
            public ShutdownThread(final Services services) {
                super("Service Shutdown Thread");
                _services = services;
            }
            @Override
            public void run() {
                _services.shutdown();
            }
        }
        private ExecutorService _executor;
        private CountDownLatch _shutdownLatch;
        private List<Service>_services;
        public Services(List<Service> services) {
            _shutdownLatch = new CountDownLatch(services.size());
            _services = services;
            _executor = Executors.newSingleThreadExecutor();
            for(Service s : _services) {
                s.addListener(this, _executor);
            }
        }

        @Override
        public void starting() {}

        @Override
        public void running() {}

        @Override
        public void stopping(Service.State state) {}

        @Override
        public void terminated(Service.State state) {
            _shutdownLatch.countDown();
        }
        @Override
        public void failed(Service.State state, Throwable throwable) {
            _shutdownLatch.countDown();
        }
        public void start() {
            for(Service s : _services) {
                s.startAndWait();
            }
        }
        public void shutdown() {
            for(Service s : _services) {
                s.stop();
            }
        }

        public ShutdownThread shutdownThread() {
            return new ShutdownThread(this);
        }

        public CountDownLatch getShutdownLatch() {
            return _shutdownLatch;
        }




    }
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

        final List<Service> s = Lists.newLinkedList();

        for (Binding<?> binding : injector.getAllBindings().values()) {
            if (Service.class.isAssignableFrom(binding.getKey().getTypeLiteral().getRawType())) {
                Service service = (Service)injector.getInstance(binding.getKey());
                s.add(service);

            }
        }
        Services services = new Services(s);
        services.start();
        Runtime.getRuntime().addShutdownHook(services.shutdownThread());

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



        try {
            services.getShutdownLatch().await();
            System.exit(1);
        } catch (Throwable squashed) {
            LOGGER.error("Shutdown was interrupted");
            System.exit(2);
        }

    }
}
