package com.lockerz.meatshop.service.shop;

import com.google.common.util.concurrent.ListenableFuture;
import com.google.common.util.concurrent.ListeningExecutorService;
import com.google.common.util.concurrent.MoreExecutors;
import com.google.common.util.concurrent.ThreadFactoryBuilder;
import com.lockerz.common.spring.jpa.JpaContextAware;
import com.lockerz.meatshop.service.shop.dao.ShopDao;
import com.lockerz.meatshop.service.shop.dao.UserDao;
import com.lockerz.meatshop.service.shop.model.Shop;
import com.lockerz.meatshop.service.shop.model.User;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;
import java.util.concurrent.Callable;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

/**
 * @author Brian Gebala
 * @version 1/16/13 9:34 AM
 */
@JpaContextAware
public class ShopServiceImpl implements ShopService {
    private final static Logger LOGGER = LoggerFactory.getLogger(ShopServiceImpl.class);

    private ListeningExecutorService _executorService;
    private int _executorMaxThreads;
    private int _executorShutdownSeconds;
    private ShopDao _shopDao;
    private UserDao _userDao;

    public void setExecutorMaxThreads(final int executorMaxThreads) {
        _executorMaxThreads = executorMaxThreads;
    }

    public void setExecutorShutdownSeconds(final int executorShutdownSeconds) {
        _executorShutdownSeconds = executorShutdownSeconds;
    }

    public void setShopDao(final ShopDao shopDao) {
        _shopDao = shopDao;
    }

    public void setUserDao(final UserDao userDao) {
        _userDao = userDao;
    }

    @Override
    public User findUserByEmail(final String email) {
        return _userDao.findUserByEmail(email);
    }

    @Override
    public User login(final String email,
                      final String password) {
        User user = _userDao.findUserForLogin(email, password);

        LOGGER.debug("login() successful: email={}", email);

        return user;
    }

    @Override
    public User register(final String email,
                         final String password) {
        User tmpUser = findUserByEmail(email);

        if (tmpUser != null) {
            throw new RuntimeException("User already registered: "  + email);
        }

        User user = new User();
        user.setEmail(email);
        user.setPassword(password);

        _userDao.persistUser(user);

        LOGGER.debug("register() successful: email={}", email);

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
    public List<Shop> findAllShops() {
        return _shopDao.findAllShops();
    }

    @Override
    public Shop findShopById(final int id) {
        return _shopDao.findShopById(id);
    }

    @Override
    public void updateShop(final Shop shop, final String name) {
        _shopDao.updateShop(shop, name);
    }

    public void startUp() throws Exception {
        _executorService = MoreExecutors.listeningDecorator(
                Executors.newFixedThreadPool(_executorMaxThreads,
                        new ThreadFactoryBuilder().setDaemon(false).setNameFormat("ShopService-%s").build()));
    }

    public void shutDown() throws Exception {
        _executorService.shutdown();
        _executorService.awaitTermination(_executorShutdownSeconds, TimeUnit.SECONDS);
        LOGGER.info("shutDown() successful");
    }
}
