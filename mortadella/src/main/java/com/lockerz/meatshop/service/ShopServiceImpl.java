package com.lockerz.meatshop.service;

import com.google.common.util.concurrent.AbstractIdleService;
import com.google.common.util.concurrent.ListenableFuture;
import com.google.common.util.concurrent.ListeningExecutorService;
import com.google.common.util.concurrent.MoreExecutors;
import com.google.common.util.concurrent.ThreadFactoryBuilder;
import com.google.inject.Inject;
import com.google.inject.Singleton;
import com.google.inject.name.Named;
import com.lockerz.meatshop.dao.ShopDao;
import com.lockerz.meatshop.dao.UserDao;
import com.lockerz.meatshop.model.Shop;
import com.lockerz.meatshop.model.User;

import java.util.concurrent.Callable;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

/**
 * @author Brian Gebala
 * @version 1/16/13 9:34 AM
 */
@Singleton
public class ShopServiceImpl extends AbstractIdleService implements ShopService {
    private ListeningExecutorService _executorService;
    private int _executorMaxThreads;
    private int _executorShutdownSeconds;
    private int _maxPrice;
    private ShopDao _shopDao;
    private UserDao _userDao;

    @Inject
    public ShopServiceImpl(@Named("shop.service.executorMaxThreads") final int executorMaxThreads,
                           @Named("shop.service.executorShutdownSeconds") final int executorShutdownSeconds,
                           @Named("shop.service.maxPrice") final int maxPrice,
                           final ShopDao shopDao,
                           final UserDao userDao) {
        _executorMaxThreads = executorMaxThreads;
        _executorShutdownSeconds = executorShutdownSeconds;
        _maxPrice = maxPrice;
        _shopDao = shopDao;
        _userDao = userDao;
    }

    public int getMaxPrice() {
        return _maxPrice;
    }

    @Override
    public User register(final String email,
                         final String password) {
        User user = new User();
        user.setEmail(email);
        user.setPassword(password);

        _userDao.persistUser(user);

        return user;
    }

    @Override
    public Shop newShop(final String name) {
        return _shopDao.newShop(name);
    }

    @Override
    public ListenableFuture<Shop> newShopLF(final String name) {
        return _executorService.submit(new Callable<Shop>() {
            @Override
            public Shop call() throws Exception {
                return newShop(name);
            }
        });
    }

    @Override
    protected void startUp() throws Exception {
        _executorService = MoreExecutors.listeningDecorator(
                Executors.newFixedThreadPool(_executorMaxThreads,
                        new ThreadFactoryBuilder().setDaemon(false).setNameFormat("ShopService-%s").build()));
    }

    @Override
    protected void shutDown() throws Exception {
        _executorService.shutdown();
        _executorService.awaitTermination(_executorShutdownSeconds, TimeUnit.SECONDS);
    }
}
