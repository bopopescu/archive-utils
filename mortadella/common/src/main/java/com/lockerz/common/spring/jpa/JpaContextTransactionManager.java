package com.lockerz.common.spring.jpa;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.jdbc.datasource.JdbcTransactionObjectSupport;
import org.springframework.orm.jpa.EntityManagerHolder;
import org.springframework.orm.jpa.JpaTransactionManager;
import org.springframework.transaction.CannotCreateTransactionException;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionException;
import org.springframework.transaction.support.TransactionSynchronizationManager;

import javax.persistence.EntityManager;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * @author Brian J. Gebala
 * @version 2/6/12 11:43 AM
 */
public class JpaContextTransactionManager extends JpaTransactionManager {
    //-------------------------------------------------------------
    // Constants
    //-------------------------------------------------------------

    private final static Logger LOGGER = LoggerFactory.getLogger(JpaContextTransactionManager.class);


    //-------------------------------------------------------------
    // Variables - Private
    //-------------------------------------------------------------

    private JpaContext _jpaContext;
    private Map<JdbcTransactionObjectSupport, EntityManager> _newTransactionObjects = 
            new ConcurrentHashMap<JdbcTransactionObjectSupport, EntityManager>();


    //-------------------------------------------------------------
    // Methods - Getter/Setter
    //-------------------------------------------------------------

    public void setJpaContext(final JpaContext jpaContext) {
        _jpaContext = jpaContext;
    }


    //-------------------------------------------------------------
    // Methods - Protected
    //-------------------------------------------------------------

    @Override
    protected Object doGetTransaction() {
        EntityManagerHolder holder = 
                (EntityManagerHolder)TransactionSynchronizationManager.getResource(getEntityManagerFactory());
        
        boolean isNew = false;
        
        if (holder == null) {
            EntityManager em = _jpaContext.getEm(getEntityManagerFactory());
            holder = new EntityManagerHolder(em);
            TransactionSynchronizationManager.bindResource(getEntityManagerFactory(), holder);
            isNew = true;
        }

        JdbcTransactionObjectSupport transactionObj = (JdbcTransactionObjectSupport)super.doGetTransaction();
        
        if (isNew) {
            _newTransactionObjects.put(transactionObj, holder.getEntityManager());
            LOGGER.debug("doGetTransaction() bound EntityManagerHolder [{}] and saved transactionObj [{}]",
                    holder, transactionObj);
        }
        else {
            LOGGER.debug("doGetTransaction() existing EntityManagerHolder, ignoring transactionObj: {}",
                    holder, transactionObj);
        }
        
        return transactionObj;
    }

    @Override
    protected void doBegin(final Object transaction,
                           final TransactionDefinition definition) {
        JdbcTransactionObjectSupport txObject = (JdbcTransactionObjectSupport)transaction;

        try {
            super.doBegin(transaction, definition);
        }
        catch (TransactionException ex) {
            rollbackAfterFailedBegin(txObject);
            throw ex;
        }
        catch (Exception ex) {
            rollbackAfterFailedBegin(txObject);
            throw new CannotCreateTransactionException("Could not open JPA EntityManager for transaction", ex);
        }
    }

    protected void rollbackAfterFailedBegin(final JdbcTransactionObjectSupport txObject) {
        EntityManager em = _newTransactionObjects.get(txObject);
        
        if (em != null) {            
            try {
                if (em.getTransaction().isActive()) {
                    em.getTransaction().rollback();
                }
            }
            catch (Throwable ex) {
                LOGGER.debug("Could not rollback EntityManager after failed transaction begin", ex);
            }
        }
    }    
    
    @Override
    protected EntityManager createEntityManagerForTransaction() {
        throw new UnsupportedOperationException(
                "An EntityManager should already be available in an EntityManagerHolder.");
    }

    @Override
    protected void doCleanupAfterCompletion(final Object transaction) {
        try {
            super.doCleanupAfterCompletion(transaction);
        }
        finally {
            JdbcTransactionObjectSupport transactionObj = (JdbcTransactionObjectSupport)transaction;
            EntityManager em = _newTransactionObjects.remove(transactionObj);

            if (em != null) {
                EntityManagerHolder holder =
                        (EntityManagerHolder)TransactionSynchronizationManager.unbindResource(
                                getEntityManagerFactory());
                LOGGER.debug("doCleanupAfterCompletion() unbound holder [{}] and removed transactionObj [{}]",
                        holder, transactionObj);
            }
        }
    }
}
