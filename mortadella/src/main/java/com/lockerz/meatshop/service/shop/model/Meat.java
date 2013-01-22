package com.lockerz.meatshop.service.shop.model;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Version;

/**
 * @author Brian Gebala
 * @version 1/15/13 1:10 PM
 */
@Entity
@Table(name = "meat")
public class Meat {
    @Id
    @Column(name = "id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int _id;
    @Version
    @Column(name = "version")
    private int _version;
    @Basic
    @Column(name = "name")
    private String _name;
    @ManyToOne(optional = false)
    @Column(name = "shop_id")
    private Shop _shop;
    @Basic
    @Column(name = "price_dollars")
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
