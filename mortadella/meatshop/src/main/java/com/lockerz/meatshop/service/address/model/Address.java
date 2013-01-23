package com.lockerz.meatshop.service.address.model;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Version;

/**
 * @author Brian Gebala
 * @version 1/17/13 9:04 AM
 */
@Entity
@Table(name = "address")
public class Address {
    @Id
    @Column(name = "id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int _id;
    @Version
    @Column(name = "version")
    private int _version;
    @Basic
    @Column(name = "street")
    private String _street;
    @Basic
    @Column(name = "city")
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
