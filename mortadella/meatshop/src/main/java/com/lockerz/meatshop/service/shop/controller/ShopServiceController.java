package com.lockerz.meatshop.service.shop.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Map;

/**
 * @author Brian Gebala
 * @version 1/23/13 10:44 AM
 */
@Controller
@RequestMapping("/shop")
public class ShopServiceController {
    @RequestMapping
    @ResponseBody
    public String index() {
        return "Shops";
    }

    @RequestMapping(value = "/test", method = RequestMethod.GET)
    public String test(final Map<String, Object> model,
                       @RequestParam("name") final String name)
    {
        model.put("name", name);
        return "shop/test";
    }
}
