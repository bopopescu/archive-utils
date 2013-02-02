package com.lockerz.meatshop.service.shop.dao;

import com.lockerz.meatshop.service.shop.model.Meat;
import com.lockerz.meatshop.service.shop.model.Shop;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;
import java.util.List;

/**
 * @author Brian Gebala
 * @version 1/15/13 3:30 PM
 */
@Transactional("service.shopTransactionManager")
public class ShopDaoImpl implements ShopDao {
    @PersistenceContext(unitName = "meatshop")
    private EntityManager _em;

    @Override
    public Meat findMeatById(final int id) {
        return _em.find(Meat.class, id);
    }

    @Override
    public List<Shop> findAllShops() {
        TypedQuery<Shop> query = _em.createQuery("SELECT s FROM Shop s", Shop.class);
        return query.getResultList();
    }

    @Override
    public Shop findShopById(final int id) {
        return _em.find(Shop.class, id);
    }

    @Override
    public void updateShop(final Shop shop, final String name) {
        shop.setName(name);
        _em.merge(shop);
    }

    @Override
    public Meat newMeat(final String name,
                        final int priceDollars,
                        final Shop shop) {
        Meat meat = new Meat();
        meat.setName(name);
        meat.setPriceDollars(priceDollars);
        meat.setShop(shop);
        shop.getMeats().add(meat);

        _em.persist(meat);

        return meat;
    }

    @Override
    public Shop newShop(final String name) {
        Shop shop = new Shop();
        shop.setName(name);

        _em.persist(shop);

        return shop;
    }
}
