package com.lockerz.meatshop.service.shop.model;

/**
 * @author Brian Gebala
 * @version 1/15/13 1:10 PM
 */
public class Meat {
    private int _id;
    private String _name;
    private Shop _shop;
    private int _priceDollars;

    public int getId() {
        return _id;
    }

    public String getName() {
        return _name;
    }

    public void setName(final String name) {
        _name = name;
    }

    public Shop getShop() {
        return _shop;
    }

    public void setShop(final Shop shop) {
        _shop = shop;
    }

    public int getPriceDollars() {
        return _priceDollars;
    }

    public void setPriceDollars(final int priceDollars) {
        _priceDollars = priceDollars;
    }
}
