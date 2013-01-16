package com.lockerz.meatshop.dao;

import com.google.common.collect.Iterables;
import com.google.inject.Inject;
import com.google.inject.Provider;
import com.google.inject.Singleton;
import com.google.inject.persist.Transactional;
import com.lockerz.meatshop.model.User;

import javax.persistence.EntityManager;
import javax.persistence.TypedQuery;

/**
 * @author Brian Gebala
 * @version 1/15/13 1:37 PM
 */
@Singleton
public class UserDaoImpl implements UserDao {
    @Inject
    private Provider<EntityManager> _em;

    @Override
    @Transactional
    public User findUserById(final int id) {
        EntityManager em = _em.get();
        return em.find(User.class, id);
    }

    @Override
    @Transactional
    public User findUserByEmail(final String email) {
        EntityManager em = _em.get();
        TypedQuery<User> query = em.createQuery("SELECT u FROM User u WHERE u._email = :email", User.class);
        query.setParameter("email", email);
        return Iterables.getFirst(query.getResultList(), null);
    }

    @Override
    @Transactional
    public User findUserForLogin(final String email,
                                 final String password) {
        EntityManager em = _em.get();
        TypedQuery<User> query = em.createQuery("SELECT u FROM User u WHERE u._email = :email AND u._password = :password", User.class);
        query.setParameter("email", email);
        query.setParameter("password", password);
        return Iterables.getFirst(query.getResultList(), null);
    }

    @Override
    @Transactional
    public void persistUser(final User user) {
        EntityManager em = _em.get();
        em.persist(user);
    }

    @Override
    @Transactional
    public void removeUser(final User user) {
        EntityManager em = _em.get();
        em.remove(user);
    }
}
