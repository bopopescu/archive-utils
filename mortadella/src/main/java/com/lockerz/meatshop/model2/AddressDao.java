package com.lockerz.meatshop.model2;

/**
 * @author Brian Gebala
 * @version 1/17/13 9:06 AM
 */
public interface AddressDao {
    public Address newAddress(final String street,
                              final String city);
}
