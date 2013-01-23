package com.lockerz.meatshop.service.shop.model;

import com.google.common.collect.Lists;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Version;
import java.util.List;

/**
 * @author Brian Gebala
 * @version 1/15/13 1:10 PM
 */
@Entity
@Table(name = "shop")
public class Shop {
    @Id
    @Column(name = "id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int _id;
    @Version
    @Column(name = "version")
    private int _version;
    @Basic
    @Column(name = "name")
    private String _name;
    @OneToMany(mappedBy = "_shop", fetch = FetchType.EAGER)
    private List<Meat> _meats = Lists.newLinkedList();

    public int getId() {
        return _id;
    }

    public String getName() {
        return _name;
    }

    public void setName(final String name) {
        _name = name;
    }

    public List<Meat> getMeats() {
        return _meats;
    }
}
