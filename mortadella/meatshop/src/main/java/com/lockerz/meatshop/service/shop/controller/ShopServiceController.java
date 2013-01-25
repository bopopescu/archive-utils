package com.lockerz.meatshop.service.shop.controller;

import com.lockerz.meatshop.service.shop.ShopService;
import com.lockerz.meatshop.service.shop.form.LoginForm;
import com.lockerz.meatshop.service.shop.model.User;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.Map;

/**
 * @author Brian Gebala
 * @version 1/23/13 10:44 AM
 */
@Controller
@RequestMapping("/shop")
public class ShopServiceController {

    private ShopService _shopService;

    @RequestMapping
    @ResponseBody
    public String index() {
        return "Shops";
    }

    @RequestMapping(value = "/login", method = RequestMethod.GET)
    public String login()
    {
        return "user/login";
    }

    @RequestMapping(value = "/login", method = RequestMethod.POST)
    public String login(@RequestBody final LoginForm loginForm,
                        final HttpSession session)
    {
        User user = _shopService.login(loginForm.getEmail(), loginForm.getPassword());
        session.setAttribute("uid", user.getId());

        return "redirect:shop/shops";
    }

    @RequestMapping(value = "/register", method = RequestMethod.GET)
    public String register() {
        return "user/register";
    }

    @RequestMapping(value = "/register", method = RequestMethod.POST)
    public String register(@RequestBody final LoginForm loginForm,
                           final HttpSession session)
    {
        User user = _shopService.register(loginForm.getEmail(), loginForm.getPassword());
        session.setAttribute("uid", user.getId());

        return "redirect:shop/shops";
    }

    @RequestMapping(value = "/shops", method = RequestMethod.GET)
    public String shops(final Map<String, Object> model) {
        return "shop/shops";
    }

}
