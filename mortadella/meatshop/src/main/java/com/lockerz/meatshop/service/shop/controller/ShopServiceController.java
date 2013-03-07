package com.lockerz.meatshop.service.shop.controller;

import com.lockerz.meatshop.service.shop.ShopService;
import com.lockerz.meatshop.service.shop.form.LoginForm;
import com.lockerz.meatshop.service.shop.model.Shop;
import com.lockerz.meatshop.service.shop.model.User;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.FlashMap;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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

    public void setShopService(final ShopService shopService) {
        _shopService = shopService;
    }

    @RequestMapping
    @ResponseBody
    public String index() {
        return "Shops: " + _shopService.findAllShops();
    }

    @RequestMapping(value = "/login", method = RequestMethod.GET)
    public String login()
    {
        return "user/login";
    }

    @RequestMapping(value = "/login", method = RequestMethod.POST)
    public String login(@ModelAttribute final LoginForm loginForm,
                        final RedirectAttributes redirect,
                        final HttpSession session)
    {
        User user = _shopService.login(loginForm.getEmail(), loginForm.getPassword());

        if (user != null) {
            session.setAttribute("uid", user.getId());
            return "redirect:shops";
        } else {
            redirect.addFlashAttribute("errors", "Bad email or password!");
            return "redirect:login";
        }
    }

    @RequestMapping(value = "/register", method = RequestMethod.GET)
    public String register() {
        return "user/register";
    }

    @RequestMapping(value = "/register", method = RequestMethod.POST)
    public String register(@ModelAttribute final LoginForm loginForm,
                           final HttpSession session)
    {
        User user = _shopService.register(loginForm.getEmail(), loginForm.getPassword());
        session.setAttribute("uid", user.getId());

        return "redirect:shops";
    }

    @RequestMapping(value = "/new", method = RequestMethod.POST)
    public String newShop(@ModelAttribute final Shop shop) {
        _shopService.newShop(shop.getName());

        return "redirect:shops";
    }

    @RequestMapping(value = "/{id}", method = RequestMethod.POST)
    public @ResponseBody Shop editShop(@PathVariable final int id,
                                       @RequestBody final Map<String, String> body)
    {
        Shop shop = _shopService.findShopById(id);
        _shopService.updateShop(shop, body.get("name"));
        return shop;
    }

    @RequestMapping(value = "/shops", method = RequestMethod.GET)
    public String shops(final Map<String, Object> model) {
        model.put("shops", _shopService.findAllShops());

        return "shop/shops";
    }

}
