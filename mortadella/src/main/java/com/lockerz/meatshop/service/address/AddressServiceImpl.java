package com.lockerz.meatshop.service.address;

import com.google.inject.Inject;
import com.google.inject.Singleton;
import com.lockerz.meatshop.jpa.JpaContextAware;
import com.lockerz.meatshop.service.address.dao.AddressDao;
import com.lockerz.meatshop.service.address.model.Address;

/**
 * @author Brian Gebala
 * @version 1/18/13 1:01 PM
 */
@Singleton
@JpaContextAware
public class AddressServiceImpl implements AddressService {
    private AddressDao _addressDao;

    @Inject
    public AddressServiceImpl(final AddressDao addressDao) {
        _addressDao = addressDao;
    }

    @Override
    public Address newAddress(final String street,
                              final String city) {
        return _addressDao.newAddress(street, city);
    }
}
