package com.lockerz.meatshop.model2;

/**
 * @author Brian Gebala
 * @version 1/17/13 9:04 AM
 */
public class Address {
    private int _id;
    private String _street;
    private String _city;

    public int getId() {
        return _id;
    }

    public String getStreet() {
        return _street;
    }

    public void setStreet(final String street) {
        _street = street;
    }

    public String getCity() {
        return _city;
    }

    public void setCity(final String city) {
        _city = city;
    }
}
