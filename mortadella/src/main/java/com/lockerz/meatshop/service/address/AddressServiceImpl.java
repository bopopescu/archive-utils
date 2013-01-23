package com.lockerz.meatshop.service.address;

import com.lockerz.common.spring.jpa.JpaContextAware;
import com.lockerz.meatshop.service.address.dao.AddressDao;
import com.lockerz.meatshop.service.address.model.Address;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Brian Gebala
 * @version 1/18/13 1:01 PM
 */
@JpaContextAware
public class AddressServiceImpl implements AddressService {
    private final static Logger LOGGER = LoggerFactory.getLogger(AddressServiceImpl.class);

    private AddressDao _addressDao;

    public void setAddressDao(final AddressDao addressDao) {
        _addressDao = addressDao;
    }

    @Override
    public Address newAddress(final String street,
                              final String city) {
        return _addressDao.newAddress(street, city);
    }

    public void shutdown() {
        LOGGER.info("shutdown() successful");
    }
}
