package com.lockerz.meatshop.service.shop.dao;

import com.google.common.collect.Iterables;
import com.lockerz.meatshop.service.shop.model.User;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;

/**
 * @author Brian Gebala
 * @version 1/15/13 1:37 PM
 */
@Transactional("service.shopTransactionManager")
public class UserDaoImpl implements UserDao {
    @PersistenceContext(unitName = "meatshop")
    private EntityManager _em;

    @Override
    public User findUserById(final int id) {
        return _em.find(User.class, id);
    }

    @Override
    public User findUserByEmail(final String email) {
        TypedQuery<User> query = _em.createQuery("SELECT u FROM User u WHERE u._email = :email", User.class);
        query.setParameter("email", email);
        return Iterables.getFirst(query.getResultList(), null);
    }

    @Override
    public User findUserForLogin(final String email,
                                 final String password) {
        User userByEmail = findUserByEmail(email);
        User userForLogin = null;

        if (userByEmail != null && userByEmail.getPassword().equals(password)) {
            userForLogin = userByEmail;
        }

        return userForLogin;

    }

    @Override
    public void persistUser(final User user) {
        _em.persist(user);
    }

    @Override
    public void removeUser(final User user) {
        _em.remove(user);
    }
}
