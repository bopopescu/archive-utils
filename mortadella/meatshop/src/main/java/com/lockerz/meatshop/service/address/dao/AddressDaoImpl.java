package com.lockerz.meatshop.service.address.dao;

import com.lockerz.meatshop.service.address.model.Address;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

/**
 * @author Brian Gebala
 * @version 1/17/13 9:06 AM
 */
@Transactional("service.addressTransactionManager")

public class AddressDaoImpl implements AddressDao {
    @PersistenceContext(unitName = "address")
    private EntityManager _em;

    @Override
    public Address newAddress(final String street, final String city) {
        Address address = new Address();
        address.setStreet(street);
        address.setCity(city);

        _em.persist(address);

        return address;
    }
}
