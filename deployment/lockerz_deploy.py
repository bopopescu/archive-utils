#!/usr/bin/env python
import os
import sys
import argparse
import aws
import subprocess
import pprint
import time
"""
Chef needs a pem key to authenticate with the API, check for some under common names
If we can't find a pem key bail out as none of this will work without one
"""
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


def admin_hosts():
    return ["admin01.platz.lockerz.int"]

def load_balancers():
    #return ["deploy-test"]
    return ["lockerz-com", "api-lockerz-com"]

def wait_for_traffic_to_die(host):
    code = subprocess.call(["scripts/check-for-traffic", "-le", "0", host])

def wait_for_traffic(host):
    code = subprocess.call(["scripts/check-for-traffic", "-ge", "3", host])

def notify_newrelic(version, email):
    code = subprocess.call(["scripts/notify-newrelic", version, email])
    if code != 0:
        return False
    else:
        return True

def checkout(version):
    code = subprocess.call(["scripts/checkout", version])
    if code != 0:
        return False
    else: 
        return True

def tag(version):
    code = subprocess.call(["scripts/tag", version])
    if code != 0:
        return False
    else:
        return True

def build_platz(version):
    code = subprocess.call(["scripts/build-platz", version])
    if code != 0:
        return False
    else:
        return True

def build_pegasus(version):
    code = subprocess.call(["scripts/build-pegasus", version])
    if code != 0:
        return False
    else:
        return True

def deploy_platz(version,host):
    code = subprocess.call(["scripts/deploy-platz", version, host])
    if code != 0:
        return False
    else:
        return True

def deploy_pegasus(version, host):
    code = subprocess.call(["scripts/deploy-pegasus", version, host])
    if code != 0:
        return False
    else:
        return True
 
def get_app_host_info():
    print "Using load balancer names: %s" % (load_balancers())
    balancers_to_instance_ids = {}
    ids_to_instances = {}
    ids_to_balancers = {}
    fqdns_to_ids = {}
    

    for lb in load_balancers():
        balancers_to_instance_ids[lb] = set()
        found = aws.get_instances_in_elb(lb)
        for instance in found:
            balancers_to_instance_ids[lb].add(instance.id)
            ids_to_instances[instance.id] = instance
            
        
    for instance_id in ids_to_instances.keys():
        fqdn = aws.fqdn_for_instance_id(instance_id)
        fqdns_to_ids[fqdn] = instance_id
        ids_to_balancers[instance_id] = [b for b in balancers_to_instance_ids.keys() if instance_id in balancers_to_instance_ids[b]]
        


    fqdns = fqdns_to_ids.keys()
    fqdns.sort()
    
    
    return {"hosts" : fqdns,
            "ids_to_instances" : ids_to_instances,
            "ids_to_balancers" : ids_to_balancers,
            "balancers_to_ids" : balancers_to_instance_ids,
            "hosts_to_ids"     : fqdns_to_ids}
        


def remove_from_elbs(host, host_info):
    host_id = host_info["hosts_to_ids"][host]
    elbs = host_info["ids_to_balancers"][host_id]
    print "Removing %s [%s] from elbs:" % (host, host_id)
    for elb in elbs:
        sys.stdout.write("\t%s... " % elb)
        sys.stdout.flush()
        aws.remove_instance_from_elb(elb, host_id)
        sys.stdout.write("Done!\n")
        sys.stdout.flush()


def add_to_elbs(host, host_info):
    host_id = host_info["hosts_to_ids"][host]
    elbs = host_info["ids_to_balancers"][host_id]
    print "Re-adding %s [%s] to elbs:" % (host, host_id)
    for elb in elbs:
        sys.stdout.write("\t%s... " % elb)
        sys.stdout.flush()
        aws.add_instance_to_elb(elb, host_id)
        sys.stdout.write("Done!\n")
        sys.stdout.flush()


    
    
  
        
if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Platz deployment script')
    parser.add_argument("version", type=str, nargs=1, help="the version to give this build")
    parser.add_argument("email", type=str, nargs=1, help="the email of the person running this deployment")

    args = parser.parse_args()
    version = args.version[0]
    email = args.email[0]

    host_info = get_app_host_info()
    print "Will deploy platz *only* to hosts:\n\t%s" % ("\n\t".join(admin_hosts()))
    print "\n"
                                                        
    print "Will deploy to hosts:\n\t%s" % ("\n\t".join(host_info["hosts"]))       
    raw_input ("Hit <Enter> to continue")

    print "Updating source"
    checkout_ok = checkout(version)
    if checkout_ok == False:
        print "Checkout failed. Stopping deployment."
        exit(1)

    print "Building Pegasus"
    pegasus_ok = build_pegasus(version)
    if pegasus_ok  == False:
        print "Pegasus build failed. Stopping deployment."
        exit(1)
        
    print "Building Platz"
    platz_ok = build_platz(version)
    if platz_ok == False:
        print "Platz build failed. Stopping deployment."
        exit(1)

    print "Tagging Build"
    tag_ok = tag(version)
    if tag_ok == False:
        print "Tag failed. stopping deployment."
        exit(1)

    show_prompt = True

    for host in admin_hosts():
        deploy_platz(version, host)

    val = raw_input("Admin deploy done, print <Enter> to continue")

    for host in host_info["hosts"]:
        remove_from_elbs(host, host_info)
        print "Waiting for traffic to die off"
        wait_for_traffic_to_die(host)
        
        deploy_platz(version, host)
        deploy_pegasus(version, host)

        add_to_elbs(host, host_info)
        print "Waiting for host to start getting traffic"
        wait_for_traffic(host)

        print "Done with %s" % host
        if show_prompt == True:
            val = raw_input("Hit <Enter> to continue to the next host, or type all and hit <Enter> to do the remainder or the boxes without prompting again.")
            if val == "all":
                print "Prompt will be skipped for the remaining boxes."
                time.sleep(2)
                show_prompt = False

    print "Notifying new relic of deployment"
    notify_newrelic(version, email)
            

        

        

            
        

        

        
        
                
            
