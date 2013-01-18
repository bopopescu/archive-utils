package com.lockerz.meatshop.service.shop.model;

import com.google.common.collect.Lists;

import java.util.List;

/**
 * @author Brian Gebala
 * @version 1/15/13 1:10 PM
 */
public class Shop {
    private int _id;
    private String _name;
    private List<Meat> _meats = Lists.newLinkedList();

    public int getId() {
        return _id;
    }

    public String getName() {
        return _name;
    }

    public void setName(final String name) {
        _name = name;
    }

    public List<Meat> getMeats() {
        return _meats;
    }
}
