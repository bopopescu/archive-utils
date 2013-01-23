package com.lockerz.meatshop.service.address;

import com.lockerz.meatshop.service.address.model.Address;

/**
 * @author Brian Gebala
 * @version 1/18/13 1:01 PM
 */
public interface AddressService {
    public Address newAddress(final String street,
                              final String city);
}
