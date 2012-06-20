#!/usr/bin/env python
import sys
import cmd                                                        # Need this for interactive console
import os.path
import boto                                                       # https://github.com/boto/boto
import argparse

from   pprint         import pprint
from   chef           import autoconfigure, Node, ChefAPI, Search # https://github.com/coderanger/pychef
from   boto.exception import BotoServerError

pemFile = ''
if os.path.exists('platzScript0.pem'):
    pemFile = 'platzScript0.pem'
elif os.path.exists('chefPlatz.pem'):
    pemFile = 'chefPlatz.pem'
else:
    print ''
    print '*** ERROR ***'
    print 'No certificate file could be found!'
    print ''
    exit()

elbs = boto.connect_elb(aws_access_key_id='AKIAIO6ZJBIIOKEYEGVQ', 
                                 aws_secret_access_key='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')
chef = ChefAPI('https://chef-server.lockerz.us:8080', pemFile, 'platzScript0')

def get_elbs():
    return elbs.get_all_load_balancers()


def getNodesByRole(role):
    return Search("node", "roles:%s" % (role))

def getAppServerNodes():
    return  getNodesByRole("platz_apps")

def printAppServerNodes():
    for node in getAppServerNodes():
        pprint(node['automatic']['fqdn'])

def get_instances_in_elb(loadBalancerName):
    return [l.instances for l in get_elbs() if l.name == loadBalancerName][0]

def remove_instance_from_elb(elbName, instance_id):
    elbs.deregister_instances(elbName, ["%s" % instance_id])

def add_instance_to_elb(elbName, instance_id):
    elbs.register_instances(elbName, ["%s" % instance_id])

def instance_id_for_fqdn(fqdn):
    query = "fqdn:%s" % fqdn
    nodes = Search("node", query)
    return nodes[0]["automatic"]["ec2"]["instance_id"]

def fqdn_for_instance_id(instance_id):
    query = "ec2_instance_id:%s" % instance_id
    return Search("node", query)[0]['automatic']['fqdn']
