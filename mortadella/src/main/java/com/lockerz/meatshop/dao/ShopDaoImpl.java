package com.lockerz.meatshop.dao;

import com.google.inject.Inject;
import com.google.inject.Provider;
import com.google.inject.Singleton;
import com.google.inject.persist.Transactional;
import com.lockerz.meatshop.model.Meat;
import com.lockerz.meatshop.model.Shop;

import javax.persistence.EntityManager;
import javax.persistence.TypedQuery;
import java.util.List;

/**
 * @author Brian Gebala
 * @version 1/15/13 3:30 PM
 */
@Singleton
public class ShopDaoImpl implements ShopDao {
    @Inject
    private Provider<EntityManager> _em;

    @Override
    @Transactional
    public Meat findMeatById(final int id) {
        EntityManager em = _em.get();
        return em.find(Meat.class, id);
    }

    @Override
    @Transactional
    public List<Shop> findAllShops() {
        EntityManager em = _em.get();
        TypedQuery<Shop> query = em.createQuery("SELECT s FROM Shop s", Shop.class);
        return query.getResultList();
    }

    @Override
    @Transactional
    public Shop findShopById(final int id) {
        EntityManager em = _em.get();
        return em.find(Shop.class, id);
    }

    @Override
    @Transactional
    public Meat newMeat(final String name,
                        final int priceDollars,
                        final Shop shop) {
        Meat meat = new Meat();
        meat.setName(name);
        meat.setPriceDollars(priceDollars);
        meat.setShop(shop);
        shop.getMeats().add(meat);

        EntityManager em = _em.get();
        em.persist(meat);

        return meat;
    }

    @Override
    @Transactional
    public Shop newShop(final String name) {
        Shop shop = new Shop();
        shop.setName(name);

        EntityManager em = _em.get();
        em.persist(shop);

        return shop;
    }
}
