package com.lockerz.meatshop;

import com.lockerz.common.spring.app.SpringAppRunner;
import com.lockerz.meatshop.service.address.AddressService;
import com.lockerz.meatshop.service.shop.ShopService;
import org.apache.openjpa.enhance.PCEnhancer;
import org.apache.openjpa.lib.util.Options;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * @author Brian Gebala
 * @version 1/15/13 1:08 PM
 */
public class App {
    public static void main(final String[] args) {
        PCEnhancer.run(new String[]{}, new Options());
        SpringAppRunner appRunner = new SpringAppRunner(new String[] {"classpath:app-context.xml", "classpath:jpa-context.xml"});
        ClassPathXmlApplicationContext context = appRunner.start();

        AddressService addressServce = context.getBean(AddressService.class);
        ShopService shopService = context.getBean(ShopService.class);

        addressServce.newAddress("100 S. King St.", "Seattle");
        //shopService.register("test006@lockerz.com", "fasdfasd");
        shopService.newShop("Meat 101");

        appRunner.waitForShutdown();
    }
}
