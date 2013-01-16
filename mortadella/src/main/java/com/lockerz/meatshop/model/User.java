package com.lockerz.meatshop.model;

/**
 * @author Brian Gebala
 * @version 1/15/13 1:09 PM
 */
public class User {
    private int _id;
    private String _email;
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
