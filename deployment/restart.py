#!/usr/bin/python
import os
import sys
import argparse
import aws
import subprocess
import pprint
import time
import lockerz_deploy

def restart_platz(host):
    code = subprocess.call(["scripts/restart-platz", host])
    if code != 0:
        return False
    else:
        return True

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Platz restart script")
    parser.add_argument("hosts", type=str, nargs ='*')
    args = parser.parse_args()
    
    host_info = lockerz_deploy.get_app_host_info()
    for fqdn in args.hosts:
        lockerz_deploy.remove_from_elbs(fqdn, host_info)
        lockerz_deploy.wait_for_traffic_to_die(fqdn)
        restart_platz(fqdn)
        lockerz_deploy.add_to_elbs(fqdn, host_info)
        lockerz_deploy.wait_for_traffic(fqdn)
        


