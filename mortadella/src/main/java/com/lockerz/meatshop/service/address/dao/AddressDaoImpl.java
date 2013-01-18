package com.lockerz.meatshop.service.address.dao;

import com.google.inject.Inject;
import com.google.inject.Provider;
import com.google.inject.Singleton;
import com.google.inject.persist.Transactional;
import com.lockerz.meatshop.jpa.JpaTransactional;
import com.lockerz.meatshop.service.address.model.Address;

import javax.persistence.EntityManager;

/**
 * @author Brian Gebala
 * @version 1/17/13 9:06 AM
 */
@Singleton
@JpaTransactional
public class AddressDaoImpl implements AddressDao {
    @Inject
    private Provider<EntityManager> _em;

    @Override
    @Transactional
    public Address newAddress(final String street, final String city) {
        Address address = new Address();
        address.setStreet(street);
        address.setCity(city);

        EntityManager em = _em.get();
        em.persist(address);

        return address;
    }
}
