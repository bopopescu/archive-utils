package com.lockerz.meatshop.service.address.dao;

import com.lockerz.meatshop.service.address.model.Address;

/**
 * @author Brian Gebala
 * @version 1/17/13 9:06 AM
 */
public interface AddressDao {
    public Address newAddress(final String street,
                              final String city);
}
