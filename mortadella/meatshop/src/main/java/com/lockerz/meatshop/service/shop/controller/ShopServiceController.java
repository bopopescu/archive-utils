package com.lockerz.meatshop.service.shop.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

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
}
