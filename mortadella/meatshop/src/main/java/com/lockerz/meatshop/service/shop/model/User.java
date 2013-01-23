package com.lockerz.meatshop.service.shop.model;

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
 * @version 1/15/13 1:09 PM
 */
@Entity
@Table(name = "shop_user")
public class User {
    @Id
    @Column(name = "id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int _id;
    @Version
    @Column(name = "version")
    private int _version;
    @Basic
    @Column(name = "email")
    private String _email;
    @Basic
    @Column(name = "password")
    private String _password;

    public int getId() {
        return _id;
    }

    public String getEmail() {
        return _email;
    }

    public void setEmail(final String email) {
        _email = email;
    }

    public String getPassword() {
        return _password;
    }

    public void setPassword(final String password) {
        _password = password;
    }
}
