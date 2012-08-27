# Copyright (c) 2006 Vertica Systems, Inc. of Billerica, Massachusetts USA
# 
# Description: python script to install vertica software on a cluster
# The script does the following jobs on each node:
#   1. create unix account(vertica dba user) to run vertica software 
#   2. install ssh keys to provide passwordless access for vertica dba user
#   3. check and modify system parameters required to run vertica
#   4. install vertica rpm
#   5. Create data directory for vertica database
#  
# Paramaters:
#   Comma separated list of hosts
#   Vertica rpm file name
#   Unix user name to run vertica software on a cluster 
#   Unix user password (optional)
#   Unix user home directory (optional)
#   Data directory for vertica database (optional)

import sys
import time
import re
from vertica.network import SSH, adapterpool
import socket, os, os.path
from optparse import OptionParser
from vertica.config import DBinclude
from vertica.network import netverify
from vertica.tools import DBfunctions
import DBname
from vertica.engine import adminExec
from vertica.ui import commandLineCtrl
import traceback
from vertica.spread import spreadAdmin

from vertica.config.Configurator import Configurator
from vertica.network import SystemProfileFactory
from vertica.tools import ErrorMonitor 
import types
import getpass
from vertica.log.InstallLogger import InstallLogger
import math
from vertica.network.adapters import adapter


STDOUT = None
STDERR = None
REDIRECT = False


def record_options( options, parser ):
    ''' use the file supplied by options.record_to to write out a
        properties file to be used by -z'''

    f = open( options.record_to, 'w' )
    members = dir( options )

    for member in members:
        if type(getattr(options, member)) == types.MethodType:
           continue
        if member.startswith( '__' ):
           continue
    
        v = getattr( options, member )
        if v != None:
           f.write( "%s = %s\n"  % (member,v ))
    
    f.close()
    sys.exit(0) 
    
    

def process_config_file( file, options, parser ):
    ''' use the supplied filename to fill in options structures '''

    f = open( file, 'r' )
    lines = f.readlines()
    f.close()

    for line in lines:

        if len(line) == 0: continue
        line = line.split('#')[0]

        if len(line.strip()) == 0: continue
        try:
            keyval_pr = line.split('=')
            key = keyval_pr[0].strip() 
            val = keyval_pr[1].strip() 

            if key == "dba_user_dir":
               key = "vertica_dba_user_dir"

            if val == None or len(val) == 0:
               continue;

            if key == 'redirect_output':
               ptr = open( val, 'w' )
               STDOUT = sys.stdout
               STDERR = sys.stderr
               sys.stdout = ptr
               sys.stderr = ptr
               REDIRECT = True
               continue

            # find the option definition to figure
            # out later if this is a 'store_true'
            # value for boolean values.
            action = 'None'
            for opt in parser.option_list:
                if ( opt.dest == key ):
                   action = opt.action

            # use introspection to find a member
            # and set it if its not already set.
            x = getattr( options, key )
            if type(x) == types.NoneType or key == 'vertica_dba_group' or key == 'vertica_dba_user':
                
               # handle boolean true/false possibilities.
               if action == 'store_true': 
                  if val in ['Yes', 'yes','y','Y','t','T','True','true']:
                     val = True
                  else:
                     val = False

               setattr( options, key, val )
        except Exception, e:
           print 'Error parsing configuration key \"%s\". Skipping..' % key


def are_hosts_the_same( a, b ):
    same = False
    #compare a to b
    if (a[0] in [b[0]] + b[1] + b[2]): 
        same = True

    for v in a[1]:
       if (v in [b[0]] + b[1] + b[2]): 
          same = True

    for v in a[2]:
       if (v in [b[0]] + b[1] + b[2]): 
          same = True

    if not same:
        #compare b to a
        if (b[0] in [a[0]] + a[1] + a[2]): 
            same = True

        for v in b[1]:
           if (v in [a[0]] + a[1] + a[2]): 
              same = True

        for v in b[2]:
           if (v in [a[0]] + a[1] + a[2]): 
              same = True
    return same



if __name__ == "__main__":

    installPrefix = "/opt/vertica"
    captured_args = sys.argv[1:]
    l = InstallLogger()
    
    try:

        print "Vertica Analytic Database %s Installation Tool" % (DBname.PRODUCT_VERSION) 
        parser = OptionParser()
        
        parser.add_option("-s", "--nodes", dest="hosts",
                          help="Comma separated list of hosts")
        
        parser.add_option("-A", "--add", dest="add_hosts",
                          help="Comma separated list of hosts to add to the cluster")
        
        parser.add_option("-R", "--remove", dest="remove_hosts",
                          help="Comma separated list of hosts to remove from the cluster")
        
        parser.add_option("-r", "--rpm", dest="rpm_file_name",
                          help="RPM file name")
        
        parser.add_option("-u", "--dba_user", dest="vertica_dba_user",
                          help="vertica_dba_user", default="dbadmin")
        
        parser.add_option("-g", "--dba_unix_group", dest="vertica_dba_group",
                          help="vertica_dba_group", default="verticadba" )
        
        parser.add_option("-p", "--dba_user_pwd", dest="vertica_dba_user_password",
                          help="vertica_dba_user_password" )

        parser.add_option("-P", "--root_pwd", dest="root_password",
                          help="root_password")
        
        parser.add_option("-l", "--dba_user_dir", dest="vertica_dba_user_dir",
                          help="vertica_dba_user_dir")
        
        parser.add_option("-d", "--data_dir", dest="data_dir",
                          help="data_dir")
        
        parser.add_option("-D", "--debug", action="store_true", dest="debug",
                          help="debug")
        
        parser.add_option("-C", "--clean", action="store_true", dest="clean",
                          help="cleans previously stored config files if database is not defined. Should use this option only when no database is already defined.")

        parser.add_option("-N", "--ignore-netmask", action="store_true", dest="ignore_netmask",
                          help="ignores netmask portion of netverify check (EXPERIMENTAL)")
		
        parser.add_option("-U", "--allow_UDP", action="store_true", dest="allowUDP",
                          help="allows spread to use UDP (broadcast)")
		
        parser.add_option("-T", "--direct_send", action="store_true", dest="direct_only",
                          help="disallow spread from using UDP (broadcast)")
		
        parser.add_option("-S", "--spread_reconfig", dest="forceSpreadReconfiguration",
                          help="force a reconfiguration of spread on all cluster hosts using the specified broadcast address.['default'| broadcast address (eg 192.168.10.255)]")

        parser.add_option("--spread_logging", action="store_true",  dest="spread_logging_on", 
                          help="turn on spread logging to /tmp/spread_<host>.log [off by default]")
 		
        parser.add_option("-E", "--replace_host", action="store_true", dest="replaceHost",
                          help="enables host replacement via -A and -R together")

        parser.add_option("--skip-network-test", action="store_true", dest="skip_network_test",
                          help="skips entire netverify check")

        parser.add_option("--silent", action="store", dest="silent_config",
                          help="use the supplied properties file for a 'silent' install")

        parser.add_option("-L", "--license-key", dest="license_file",
                          help="install the supplied licence key")

        parser.add_option("-Y", "--accept-eula", action="store_true", dest="accept_eula",
                          help="Automatically accept the EULA")

        parser.add_option("--record", action="store", dest="record_to",
                          help="create a properties file, but don't install")

        parser.add_option("-2", "--two-tier", action="store", dest="large_cluster",
                          help="use large cluster spread arrangement, if 'default' use sqrt(N) nodes, otherwise use '<number>'")

        #parser.add_option("-t", "--unit_test", dest="unit_test",
        #                  help="unit_test")
        
        # process the cmd line options
        (options, sys.argv) = parser.parse_args()

        if len( sys.argv ) > 0:
           print "Command line contains unknown options %s" % sys.argv
           print "Please verify your command line syntax and try again."
           ErrorMonitor.err()
           sys.exit(1)
           
        # VER-15404 - catch invalid values for -S
        # must be either 'default' or an ipaddress
        if options.forceSpreadReconfiguration != None:
            if options.forceSpreadReconfiguration != "default":
                pieces = options.forceSpreadReconfiguration.split('.')
                if len(pieces) != 4:
                    print "\nERROR: Invalid value %s for -S" % options.forceSpreadReconfiguration
                    sys.exit(1)
                    
                for piece in pieces:
                    try:
                        t = int(piece)
                    except:
                        print "ERROR: Invalid value %s for -S " % options.forceSpreadReconfiguration
                        sys.exit(1)
                        
            
                

        if ( options.record_to != None ):
           record_options( options, parser )


        if ( options.silent_config != None ):
           process_config_file( options.silent_config, options, parser )

        #
        # Post-process options
        #

        # try to figure out the abspath for the rpm name in case someone supplied a relative path
        # don't need to test if it exists, as this was done by install_vertica
        if ( options.rpm_file_name == None or len(options.rpm_file_name) == 0 ):
            options.rpm_file_name == None
        else:
            options.rpm_file_name = os.path.abspath(os.path.expanduser(options.rpm_file_name))
            if not os.path.exists( options.rpm_file_name ):
              print "Invalid path for rpm file: %s" % options.rpm_file_name
              ErrorMonitor.err()
              sys.exit(1)




        # reuse the functionality of adminExec (running as the requested dba user)
        executor = adminExec.adminExec(makeUniquePorts = False, showNodes = False, user = options.vertica_dba_user)


        # post-process the host names to make them more useful: split
        # the strings into arrays and canonicalize the names
        #
        # The node lists we'll keep are:
        #
        # addhost_list: the nodes to install the RPM on, install and configure
        #   spread from scratch, and add to the AT site metadata
        #
        # removehost_list: the nodes to remove from the cluster's
        #   spread and AT metadata
        #
        # updatehost_list: the nodes to update; spread is reconfigured
        #   and reloaded, and the RPM is checked, but the RPM is not
        #   installed nor are these nodes added to AT metadata.  These
        #   nodes are not set by the user, but are extracted from the
        #   existing AT metadata.
        #
        # The items in these arrays are lists returned by gethostbyname_ex:
        #   [0]: the canonical hostname (full domain name)
        #   [1]: an array of aliases (may be empty)
        #   [2]: an array of IP addresses
        #
        # fullhostname_list: the update and add host lists.  This is a
        #   simple list of canonicalized hostnames
        # addhostname_list: simple canonicalized add hostname list
        # removehostname_list: simple canonicalized remove hostname list
        # updatehostname_list: simple canonicalized update hostname list

        # complain if the user specified both initial installation
        # (-s) and add or remove (-A or -R): this is checked in the install_vertica script too
        if((options.add_hosts or options.remove_hosts) and options.hosts):
            print "Can't both install (-s) and update the cluster (-A or -R)\n"
            ErrorMonitor.err()
            sys.exit(1)
            
        
        # resolve all the host names and ip addresses.
        # if we can't find them this way, just give up!

        # force them into lower case.. we'll try and keep everyone
        # lower'd from now on.
        lookup_host_list = []
        if options.hosts and len(options.hosts) > 0:
            lookup_host_list += options.hosts.lower().split(',')
            
        if options.add_hosts and len(options.add_hosts) > 0:
            lookup_host_list += options.add_hosts.lower().split(',')
            
        if options.remove_hosts and len(options.remove_hosts) > 0:
            lookup_host_list += options.remove_hosts.lower().split(',')
            
        unknown_hosts = []
        for host in lookup_host_list:
            try:    
                socket.gethostbyname_ex( host )
                #socket.gethostbyaddr(host)
            except:
                unknown_hosts.append(host)
        
        if len(unknown_hosts) > 0:
            print "Hostname lookup failed on the following host(s): %s" % ",".join( unknown_hosts)
            ErrorMonitor.err()
            sys.exit(1)
            
            
        
        # otherwise, the initial installation hosts become the hosts to add (degenerate case)
        addhost_list = []
        if(options.add_hosts and len(options.add_hosts) > 0 ):
            addhost_list = DBfunctions.hostname_fixup( options.add_hosts.lower().split(','))
        removehost_list = []
        if(options.remove_hosts and len(options.remove_hosts) > 0 ):
            removehost_list = DBfunctions.hostname_fixup(options.remove_hosts.lower().split(','))

        # if any nodes are defined in the catalog, these are the ones we're updating
        updatehost_list = []
        orig_spread_hosts = []
        siteDict = executor.getNodeInfo()

        # logic check on host removal... we have to specify a host 
        # existing in the meta data already to succeed.
        if(options.remove_hosts and len(options.remove_hosts) > 0 ):
            existing_hosts = []
            for n in siteDict.values():
                if not n[1] in existing_hosts:
                   existing_hosts.append( n[1] )
             
            for h in options.remove_hosts.lower().split(','):

                x = DBfunctions.hostname_fixup([h])[0]
                in_cluster = False
                for eh in existing_hosts:
                    y = DBfunctions.hostname_fixup([eh])[0]

                    if are_hosts_the_same( x, y ):
                       in_cluster = True

                if not in_cluster:
                   ErrorMonitor.err()
                   print "Unable to remove host %s: not part of the cluster " % h
                   print "for user %s. " % options.vertica_dba_user
                   print "Valid hosts are %s" % ', '.join(existing_hosts )
                   sys.exit(1)

        if not options.clean:
            orig_spread_hosts = executor.get_spread_hosts()
            if siteDict != {} and len(siteDict.keys()) > 0:
                # get a unique set of hostnames, since there can be multiple nodes
                # defined using the same host
                updatehost_dict = {}
                try:
                    for hostinfo in [DBfunctions.hostname_fixup([node[1].lower()])[0] for node in siteDict.values()]:
                        updatehost_dict[hostinfo[0]] = hostinfo
                except socket.gaierror, e:
                    print "An error occurred while verifying lookup of previous hosts."
                    print "The reported error was: %s" % e[1]
                    
                # uniquify with list(set(...)) would be nicer, but set is only in python 2.4
                # also, remove the hosts to be removed from the update list

                for n in updatehost_dict.values():
                    in_list = False
                    for v in removehost_list:
                       if are_hosts_the_same( n, v ):
                          in_list = True
                    if not in_list:
                       updatehost_list.append( n )

        # walk through the -s hosts and add those that are not already defined to
        # the list of nodes to be added.  This allows -s to work like -A for initial
        # installation and upgrading the RPM of an existing cluster.
        try:
            if(options.hosts and len(options.hosts) > 0 ):
                hosts_list = DBfunctions.hostname_fixup( options.hosts.lower().split(','))
                for host in hosts_list:
                    in_list = False
                    for v in updatehost_list:
                       if are_hosts_the_same( host, v ):
                          in_list = True
                    if not in_list:
                       addhost_list.append( host )
                # If the user missed cluster hosts that we're adding, let them know about it
                # skip this totally if the -C option is present
                autoaddedhostnames = []
                if not options.clean:
                    for x in updatehost_list:
                        in_list = False
                        for v in hosts_list:
                           if are_hosts_the_same( x, v ):
                              in_list = True
                        if not in_list:
                           autoaddedhostnames.append( x[0] )
                if(len(autoaddedhostnames) > 0):
                    print "NOTICE: Adding previously-defined cluster host(s) to update check: %s" % " ".join(autoaddedhostnames)
        except socket.herror, e:
            print "ERROR: An error occured while processing the  host list (-s)"
            print "       The reported error was: %s" %e[1]
            ErrorMonitor.err()
            sys.exit(1)

        
        # using the lists of hosts to be added or updated, scroll through the set of
        # previously defined hosts and see if there is overlap in name/alias/ip addresses.
        # if we find a match, but is offset (eg, not in position 0, replace the tuple.
        if  siteDict != {} and len(siteDict.keys()) > 0:
            for site in siteDict.values():
                
                idx = 0
                for info in addhost_list:
                    mashup = [info[0]] + info[1] + info[2] 
                    # look for the predefined site in the lists...
                    # but not in the first position.
                    if site[1].lower() in mashup and site[1] != mashup[0] :
                        # Warning... modifying a list value!
                        DBfunctions.record( "Warning:  Hostname resolution of %s is %s. Vertica will continue to use %s" % (site[1],mashup[0],site[1]) )
                        aliases = info[1]
                        if not info[0] in aliases:
                           aliases.append( info[0] )
                        if site[1].lower() in aliases:
                           aliases.remove( site[1].lower() )
                        addhost_list[idx] = [site[1].lower(), aliases, info[2]]
                    idx += 1
                    
                # do it again for updatehost_list 
                idx= 0
                for info in updatehost_list:
                    mashup = [info[0]] + info[1] + info[2] 
                    # look for the predefined site in the lists...
                    # but not in the first position.
                    if site[1].lower() in mashup and site[1] != mashup[0] :
                        # Warning... modifying a list value!
                        DBfunctions.record( "Warning:  Hostname resolution of %s is %s. Vertica will continue to use %s" % (site[1],mashup[0],site[1]) )
                        aliases = info[1]
                        if not info[0] in aliases:
                           aliases.append( info[0] )
                        if site[1] in aliases:
                           aliases.remove( site[1].lower() )
                        updatehost_list[idx] = [site[1].lower(), aliases, info[2]]
                    idx += 1

        # after mashups, see if we've accidently made duplicate entries.
        try:
           for host in updatehost_list:
               in_list = False
               for v in addhost_list:
                  if are_hosts_the_same( host, v ):
                       addhost_list.remove(v)
        except:
            pass 
                        
        #  remove dupes from both list if they are there.
        t = []
        for e in addhost_list:
           if e not in t:
              t.append(e)
        addhost_list = t[:]

        t = []
        for e in updatehost_list:
           if e not in t:
              t.append(e)
        updatehost_list = t[:]


        # the lists of canonical hostnames
        fullhostname_list = [n[0] for n in addhost_list + updatehost_list + removehost_list]
        addhostname_list = [n[0] for n in addhost_list]
        removehostname_list = [n[0] for n in removehost_list]
        updatehostname_list = [n[0] for n in updatehost_list]

        t = []
        for e in updatehostname_list:
           if e not in t:
              t.append(e)
        updatehostname_list = t[:]





        if len( fullhostname_list) == 0 :
           print "WARNING: No hostname list provided.  Installing to localhost"
           fullhostname_list.append( "localhost" )
           addhostname_list.append( "localhost" )
        

        # sanity-check the replace flag
        if(options.replaceHost):

            if not options.add_hosts:
                print "Error: when replacing hosts, the -A option must also be used."
                ErrorMonitor.err()
                sys.exit(1)

            if len(addhostname_list) == 0:
                print "ERROR: the host(s) used in -A is already part of this cluster."
                ErrorMonitor.err()
                sys.exit(1)

            if(len(addhostname_list) != len(removehost_list)):
                print "ERROR: when replacing hosts, number of added hosts must equal number of removed hosts"
                print "       and added hosts cannot already be part of the cluster"
                ErrorMonitor.err()
                sys.exit(1)

        if not (options.remove_hosts and not options.add_hosts):
            if len(fullhostname_list) > 1 and options.rpm_file_name == None:
                print "You must supply a valid rpm filename to continue."
                ErrorMonitor.err()
                sys.exit(1)

           

        # prevent uninstall from using a 'redefined' name for a host
        # eg an alias or ip address if it wasn't used previously.
        undefined_rm_hosts =[]
        if  siteDict != {} and len(siteDict.keys()) > 0:
          for n in removehostname_list: 
           x = DBfunctions.hostname_fixup([n])[0]
           found = False
           in_list = False
           for s in siteDict.values():
                y = DBfunctions.hostname_fixup([s[1]])[0]
                if are_hosts_the_same( x, y ):
                    found = True
                    break
           if not found:
              undefined_rm_hosts.append( n )

        if len( undefined_rm_hosts ) > 0:
            print "ERROR: hosts given in -R option are not defined as hosts in meta data."
            print "       Verify that the hostnames given match previous entries."
            print "       %s" % ", ".join( undefined_rm_hosts ) 
            ErrorMonitor.err()
            sys.exit(1)

        # prevent installation to "localhost" [VER-5081]
        if len([n for n in fullhostname_list if n.startswith("localhost") or n.startswith("127.0.0.1")]) > 0:
            if(len(fullhostname_list) > 1):
                print "ERROR: localhost not permitted in clusters, use full hostname or IP address"
                ErrorMonitor.err()
                sys.exit(1)

        # verify that the user didn't ask to add a host that was already defined
        duplicatehostname_list = [n for n in addhostname_list if n in updatehostname_list and not n in removehostname_list]
        if len(duplicatehostname_list):
            print "ERROR: Adding already-defined host(s): %s" % " ".join(duplicatehostname_list)
            ErrorMonitor.err()
            sys.exit(1)

        # if cluster originally installed with large cluster, remember that
        if not options.large_cluster and orig_spread_hosts:
            options.large_cluster = len(orig_spread_hosts)

        # automatically enable large cluster if size is over 128.  warn if size is > 100
        if len(fullhostname_list) > 128 and not options.large_cluster:
            print "WARNING: Enabling large cluster support due to cluster size over 128 nodes"
            options.large_cluster = "default"
        # warn 
        if len(fullhostname_list) > 100 and not options.large_cluster:
            print "NOTICE: Large cluster, consider enabling large cluster support (-2)"
        if len(fullhostname_list) < 20 and options.large_cluster:
            print "NOTICE: Large cluster configuration enabled -- despite small cluster (only %d nodes)" % len(fullhostname_list)
        # convert to appropriate integer
        if options.large_cluster == "default":
            options.large_cluster = int(math.ceil(math.sqrt(len(fullhostname_list))))
        elif options.large_cluster: # convert to number
            try:
                nspread = int(options.large_cluster)
            except ValueError:
                nspread = -1
            # sanity check
            if (nspread < 0 or nspread > len(fullhostname_list)):
                print "ERROR: Invalid large cluster parameter specified '%s', use 'default' or a number between 0-%d" % (options.large_cluster, len(fullhostname_list))
                ErrorMonitor.err()
                sys.exit(1)
            options.large_cluster = nspread

        if options.large_cluster:
            print "NOTICE: Using large cluster configuration, %d/%d nodes running spread" % (options.large_cluster,len(fullhostname_list))
            if options.large_cluster <= 3:
                print "WARNING: Too few nodes running spread(%d) -- recommend at least 4" % options.large_cluster
            if orig_spread_hosts and len(orig_spread_hosts) != options.large_cluster and options.replaceHost:
                print "ERROR: Cannot replace host and change large cluster spread count at the same time."
                ErrorMonitor.err()
                sys.exit(1)
        elif orig_spread_hosts:
            print "NOTICE: Turning off large cluster"
            options.forceSpreadReconfiguration = "default"

        # set local hostname, default to gethostname()
        localhost = socket.gethostname()
        local_in_cluster = False
        for host in fullhostname_list:
            if DBfunctions.IsLocalHost( host ):
                local_in_cluster = True
                localhost = host

        if not local_in_cluster:
           print "It appears that %s is not already a member of the cluster or does not appear in the " % localhost
           print "host list provided.  Exiting..."
           ErrorMonitor.err()
           sys.exit(1)


        # don't try to remove the local host from cluster.. do that via another host in the cluster.
        if localhost in removehostname_list:
           print "You cannot remove %s from the cluster from this host." % localhost
           print "To remove,you must run this command from another host in the cluster." 
           print "If this is a single node cluster, use rpm --erase to uninstall vertica on this host."
           ErrorMonitor.err()
           sys.exit(1)



        # Use dba_user home directory for datafile if -d option was not set 
        if options.data_dir==None:
            options.data_dir="~%s/"%options.vertica_dba_user


        running_as = "root"
        running_uid = 0
        using_sudo  = False
        if os.environ.get("SUDO_UID") is not None:
           running_uid =  int(os.environ['SUDO_UID'])
           running_as  =  os.environ.get("SUDO_USER")
           using_sudo  = True
                    
        # determine the root password to use
        # if we are using sudo - then the password is that of
        # the user we are using...
        rootPassword = options.root_password
        #if rootPassword!=None:
        #    SSH.SSHConnectionPool.Instance().setHostUserPasswd(fullhostname_list[0], running_as, rootPassword)

        print "Starting installation tasks... "
        cfgr = Configurator.Instance()
        cfgr.set_options( captured_args )
        cfgr.save()
        l.record( "Running installer with options: %s " % ' '.join( captured_args ) )
 
        # collect profiles of the systems we are working with.
        # interesting point of note.. the ibm thinkfinger pam module could screw us up!
        #pool = nSSH.SSHConnectionPool.Instance()
        factory = SystemProfileFactory.SystemProfileFactory()
        profiles = {}
        conns = {}
        unavailable_hosts = []
        ptyerrs = False
        print "Getting system information for cluster (this may take a while)...."
        for h in fullhostname_list:
                c = adapterpool.DefaultAdapter(h)
                connecting = True
                while connecting:
                   try:
                      c.connect( h, running_as, rootPassword) # throwOnError=True, useSudo=using_sudo)
                      conns[h] = c
                      connecting = False
                   except adapter.AuthenticationException, authex:
                       if not rootPassword:
                         rootPassword = getpass.getpass("password for %s@%s: " % (running_as, h))
                         connecting = True
                       else:
                         raise authex
                   except Exception, e:
                      ErrorMonitor.warn()
                      err = "%s" % sys.exc_info()[1]
                      print "\t%s" % err
                      unavailable_hosts.append( h )
                      connecting = False
                      if re.search( ".*out of pty devices.*", err):
                         ptyerrs = True
                         print "HINT: check to see whether the /dev/pts device is mounted on %s. Refer to Troubleshooting section of the documentation." % h 
                     
        if ptyerrs:
           ErrorMonitor.err()
           sys.exit(1)

        if len( unavailable_hosts ) > 0:
            print "Removing %s from hosts list" % ",".join(unavailable_hosts)

        for h in unavailable_hosts:
            fullhostname_list.remove(h)

        try:
           profiles = factory.getProfile( conns )
        except Exception, jee:
                print "\tError: failed to get profiles"
                ErrorMonitor.warn()
                print "\t%s" % sys.exc_info()[1]
        
        # check to make sure we got all the profiles
        # they are important to spread configuration later!

        c_missing_profile = len(fullhostname_list)-len(profiles)
        downremovehosts = []
        
        if not len(profiles) == len(fullhostname_list):
            # maybe some dupes in the fullhostname list somehow.
            # if so, then we should still be ok.
            ok_to_miss = 0
            cloned_list = fullhostname_list[:]
            for h in cloned_list:
                dupes = False
                if fullhostname_list.count(h) > 1:
                    ok_to_miss = ok_to_miss + 1
                    dupes = True
                    fullhostname_list.remove(h);
                    ErrorMonitor.warn()
                    print "Warning: Hostname %s appeared more than once in the hostname list. Duplicate removed." % ( h )
                    DBfunctions.record( "Warning: Hostname %s appeared more than once in the hostname list. Duplicate removed." % ( h ))

                # VER-7570
                if not h in profiles.keys() and h in removehostname_list:
                   ok_to_miss = ok_to_miss + 1
                   print "Warning: Host %s does not appear to be accessible. Since it will be removed, the installation" % h
                   print "will continue but you will need to clean up the Vertica installation manually on this system."
                   removehostname_list.remove(h)
                   if not dupes:
                    # dont' remove the host twice.. we won't have any left!
                    fullhostname_list.remove(h)
                   downremovehosts.append(h)
               

            if ok_to_miss != c_missing_profile:    
                print "Unable to obtain a system profile for one or more hosts."
                print "Check your adminTools-root.log file for more details."
                ErrorMonitor.err()
                sys.exit(1)

        # cleanup the profiles so that removed hosts don't appear in 
        # spread config files later.
        for key in profiles.keys():
             if key in removehostname_list:
                 del profiles[key]


        clone_list = profiles.keys()
        for key in clone_list:
            for key2 in profiles.keys():
                if key == key2: continue
                try:
                    # it was deleted earlier!
                    if not key2 in profiles.keys() or not key in profiles.keys():
                       continue

                    if profiles[key] == profiles[key2]: 
                        key_to_remove = key2
                        if key_to_remove == localhost:
                           localhost = key
                           #key_to_remove = key
                        print "It looks like %s and %s are the same host. Removing %s from the list to update." %( key, key2, key_to_remove )
                        ErrorMonitor.warn()
                        del profiles[key_to_remove]
                        if key_to_remove in fullhostname_list:
                           fullhostname_list.remove(key_to_remove)
                        if key_to_remove in updatehostname_list:
                           updatehostname_list.remove(key_to_remove)
                        if key_to_remove in addhostname_list:
                           addhostname_list.remove(key_to_remove)
                        if key_to_remove in removehostname_list:
                           removehostname_list.remove(key_to_remove)
                except:
                   pass


        for key in removehostname_list: 
           if key in fullhostname_list:
             fullhostname_list.remove( key )


        #
        # Begin installation
        #
        installerSSH = adapterpool.AdapterConnectionPool_3.Instance()
        installerSSH.connect2(fullhostname_list + removehostname_list, running_as, rootPassword, using_sudo) #throwOnError=True, use_sudo=using_sudo )

        l = InstallLogger()
        LOG = l.logit
        LOG_BEGIN = l.logit_start
        LOG_END = l.logit_end
        LOG_RECORD = l.record

        #LOG = installerSSH.logger.logit
        #LOG_BEGIN= installerSSH.logger.logit_start
        #LOG_END = installerSSH.logger.logit_end
        #LOG_RECORD = installerSSH.logger.record

        # Log the hosts we're operating on
        LOG_RECORD("Hosts to add: %s" % addhostname_list)
        LOG_RECORD("Hosts to remove: %s" % removehostname_list)
        LOG_RECORD("Hosts to update: %s" % updatehostname_list)
        LOG_RECORD("Resulting cluster: %s" % fullhostname_list)



        #if len(addhostname_list) > 0:
        #    existing_installs = []
        #    for host in addhostname_list:
        #        if profiles[host].vertica.isInstalled() and not DBfunctions.IsLocalHost( host ):
        #            # this host to be added already has vertica installed.
        #            # this could be a bad thing - clusters might be entangled.
        #            existing_installs.append(host)
        #    if len( existing_installs ) > 0 :
        #        LOG( "\nAn existing Vertica installation was found on the following hosts:")
        #        LOG( "%s" % "\n".join( existing_installs ) )
        #        LOG( "\nYou must uninstall Vertica from these hosts before attempting to" )
        #        LOG( "add them to this cluster.\n" )
        #        ErrorMonitor.err()
        #        sys.exit(1)
                

        # Admin tools cannot be running anywhere
        try:       
            Status, res = installerSSH.execute( "ps -A | grep \" python.*admin[tT]ools\$\"", hide=True )
            hostsRunning=[]
            for host in res.keys():
                if res[host][0]!="1":
                   hostsRunning.append(host)
            if len(hostsRunning) > 0 :
               LOG( "There are Vertica adminTool processes running on %s. They must be stopped before installation can continue\n" % hostsRunning )   
               ErrorMonitor.err()
               sys.exit(1)
        except Exception, e:
            LOG( "%s" % e  )
            ErrorMonitor.err()
            sys.exit(1)
           
        # now make sure there are not any errant permissions out there that could mess up
        # the install.
        Status, res = installerSSH.execute("echo `if [ -e \""+ installPrefix +"\" ]; then find "+ installPrefix +" -perm -755 -type d | grep \""+ installPrefix +"\$\"; else echo " + installPrefix + "; fi`", hide=True)   
        hostsRunning=[]
        for host in res.keys():
            if res[host][1][0].strip() != installPrefix:
                hostsRunning.append(host)
        if len(hostsRunning) > 0 :
            LOG( "Detected invalid permissions on "+ installPrefix +" directories on the following hosts: %s" % hostsRunning )
            LOG( "Permissions must be set to 755 or higher for install_vertica to work correctly.")   
            ErrorMonitor.err()
            sys.exit(1)
           

        # Very first check on all nodes. Looking for:
        # 1. Check if RPM is OK, or OK to Install
        # 2. NTP server should be running
        # 3. vm.min_free_kbytes parameter in /etc/sysctl.conf  
        # 4. open filehandle parameter in /etc/security/limits.conf 
        # 5. dbaAdmin user
        # 6. dbaAdmin user .ssh directory
        hostsToUpgradeRPM = []    # which hosts need to have RPM upgraded
        (ok, rpmBrand, rpmVersion, rpmRelease, rpmArch) = (False, None, None, None,None)
        v = profiles[localhost].vertica
        (ok, rpmBrand, rpmVersion, rpmRelease, rpmArch) = ( v.isInstalled(), v.brand, v.version, v.release,v.arch)

        if rpmBrand == None or rpmVersion == None or rpmRelease == None:
            if options.rpm_file_name == None:
                LOG( "No rpm file supplied and none found installed locally." )
            else:
                LOG("RPM file %s not recognized" % options.rpm_file_name)
            ErrorMonitor.err()
            sys.exit(1)

        # Check if RPM is OK to Install
        rpm_check_fails = False
        for host in fullhostname_list:
            current = profiles[host].vertica

            isupgradable = False
            if current.isInstalled():
                (isupgradable, iscurrentrev, msg) = current.canbeupgraded( rpmBrand, rpmVersion, rpmRelease, rpmArch )
                if not isupgradable and not iscurrentrev:
                    LOG( "(%s) %s" % (host,msg) )
                    ErrorMonitor.err()
                    sys.exit(1)

            if isupgradable or not current.isInstalled():
                hostsToUpgradeRPM.append(host)


        # for all hosts where we need to upgrade the RPM, be sure the
        # vertica process is not running.  The check is to provide an
        # early warning: the RPM install will fail if vertica is running.
        if len( hostsToUpgradeRPM ) > 0:
            installerSSH.setHosts(hostsToUpgradeRPM)
            LOG_RECORD("RPM upgrade required on %s; checking for running vertica process" % hostsToUpgradeRPM)
            try:
                # XXX: need to handle zombie processes (reported as "[vertica]")
                # Added the regex in grep to find the zombies process during install 
                Status, res = installerSSH.execute( "ps -A | grep ' \[\?vertica\]\?\( <defunct>\)\?$'", hide=True )
                hostsRunningIllegally=[]
                for host in res.keys():
                    if res[host][0][0]!="1":
                       hostsRunningIllegally.append(host)
                if len(hostsRunningIllegally) > 0 :
                   LOG( "There are Vertica processes running on %s. They must be stopped before installation can continue because an RPM upgrade is required.\n" % hostsRunningIllegally )
                   ErrorMonitor.err()
                   sys.exit(1)
            except Exception, e:
                LOG( "%s" % e  )
                ErrorMonitor.err()
                sys.exit(1)

        installerSSH.resetHosts()

        
        ### XXX This is a temporary workaround for a spread ---------------------------
        ### reconfiguration bug, it can be removed later.

        # Check for the case of upgrading a 1 node cluster -- in this
        # case, spread and vertica must be shut down before
        # installation will work, because reconfiguring a 1-node
        # spread cluster to add nodes does not work properly
        if(len(addhostname_list) > 0 and len(updatehostname_list) == 1):
            # Verify that spread is not running
            installerSSH.setHosts(updatehostname_list)
            (rc, nodeList) = SSH.spreadCheck(installerSSH)
        
            if (rc != 0):
                LOG("\tError while checking spread on all hosts (%d)" % (rc))
                LOG("\tCouldn't check where spread needs to be started, exiting.")
                ErrorMonitor.err()
                sys.exit(1)
        
            if len(nodeList) == 0 :
                LOG( "Spread is running on %s. Vertica and spread must be stopped before adding nodes to a 1 node cluster.\nUse the admin tools to stop the database, if running, then use the following command to stop spread:\n\t/etc/init.d/spreadd stop  (as root or with sudo)\n" % (updatehostname_list,) )
                ErrorMonitor.err()
                sys.exit(1)
            installerSSH.resetHosts()

        ### XXX End this part of the workaround, see below for one more ---------------------

        # Using the clean option if there are no database defined then
        # we would delete the config files.  Now user can change the
        # hostname if there is no database defined.
        if (options.clean):  
            if os.path.isfile(executor.dbinfopath()):
                dbDict = executor.getDBInfo()
                if dbDict["defined"] != {}:
                    LOG("Cannot perform installation with clean option as database is already defined.")
                    ErrorMonitor.err()
                    sys.exit(1)
            if os.path.isfile(executor.dbinfopath()):
                dbfileName = executor.dbinfopath()
                os.system("rm -rf " + dbfileName)
            if os.path.isfile(executor.siteinfopath()):
                sitefileName = executor.siteinfopath()
                os.system("rm -rf " + sitefileName)
        else:
            siteDict = executor.getNodeInfo()
            definedHosts = {}
            if siteDict!={}:
                for node in siteDict.keys():
                    definedHosts[siteDict[node][1]]=siteDict[node][1]
 
            for host in definedHosts.keys():

                # If we defined the host be IP, find it
                try:
                    hostinfo = DBfunctions.hostname_fixup([host])[0]
                    ipaddress = hostinfo[2]

                    found = False
                    for ip in ipaddress:
                        # we're either updating it or removing it
                        for cmdLineHost in updatehost_list + removehost_list:
                            if ip in cmdLineHost[2]:
                                found = True;
                                break;
                except Exception, e:
                    found = False
                
                
                if not found:

                    # TODO: now check to see whether the user has
                    # requested that the node be removed from the
                    # cluster.
                    
                    s = "Host %s, previously defined in your cluster, is missing in -s parameter: %s"%(host, options.hosts)
                    LOG(s)
                    answer = "no" #ask_question(s, "yes|no", "yes")
                    if answer!="yes":
                        ErrorMonitor.err()
                        sys.exit(1)



        # There are a bunch of scripts we need in the rpm to help configure the kernel, users, etc.
        # so really the first thing that needs to be done is to _get_ the software over to the correct
        # system.
        # now, on each host, install the rpm
        if len( hostsToUpgradeRPM ) > 0:
            if DBinclude.OSNAME == "DEBIAN":
                print "Installing deb package on %s hosts...." %  len( hostsToUpgradeRPM )
            else:
                print "Installing rpm on %s hosts...." %  len( hostsToUpgradeRPM )
            for host in hostsToUpgradeRPM:
                # try to do the actual install on this node if not already there
                code, result = SSH.installNode( installerSSH, host, rootPassword, options.rpm_file_name, localhost, running_as )
                if not code:
                    LOG("Install failed on %s\n%s" % (host ,result["reason"] ))
                    ErrorMonitor.err()
                    sys.exit(1)




        # Just do these checks on the new nodes, they should already be set on the old
        installerSSH.setHosts(addhostname_list)


        # NTP check
        if not SSH.do_ntp_check(installerSSH): # don't abort if ntp check fails (I don't care what JR says)
           ErrorMonitor.warn()

        # Support tool recommendations
        status = SSH.checkRecommendations( [ {'*':'pstack','solaris':'SUNWesu'}, { '*':'sysstat', 'solaris':'SUNWaccu'}] )
        if not status:
           ErrorMonitor.warn()

            
        # check OS parameters
        print "Checking/fixing OS parameters.....\n"
        if not os.path.isfile( '/etc/release' ):
            if not SSH.do_readahead_check(installerSSH):
               ErrorMonitor.warn()
        
            if not SSH.check_min_free_kbytes(installerSSH, fix=True):
                ErrorMonitor.err()
                sys.exit(1)
            if not SSH.check_open_file_limit(installerSSH, fix=True):
                ErrorMonitor.err()
                sys.exit(1)
            if not SSH.check_su_pam_limits(installerSSH, fix=True):
                ErrorMonitor.err()
                sys.exit(1)

            # fix these if possible, but don't die if we can't fix them
            if not SSH.check_file_max(installerSSH, fix=True):
                ErrorMonitor.warn()
            if not SSH.check_file_size_limit(installerSSH, fix=True):
                ErrorMonitor.warn()
            if not SSH.check_max_map_count(installerSSH, fix=True):
                ErrorMonitor.warn()

            # system settings that we just warn about - we don't want to touch these.
            if SSH.is_cpu_scaling_enabled(installerSSH):
               LOG( "CPU frequency scaling is enabled.  This may adversely affect the performance of your database.")
               LOG( "Vertica recommends that cpu frequency scaling be turned off or set to 'performance'\n\n")
               ErrorMonitor.warn()


        installerSSH.setHosts( fullhostname_list )  #addhostname_list + updatehostname_list )

        
        # DBA user & Group (group first)
        print "Creating/Checking Vertica DBA group\n"
        try:
           if not SSH.createDbaGroup(installerSSH, options.vertica_dba_group):
               ErrorMonitor.err()
               sys.exit(1);
        except adapter.SSHException, sshe:
           print "%s" % sshe
           ErrorMonitor.err()
           sys.exit(1)
         

        print "Creating/Checking Vertica DBA user\n"
        try:
            ok, options.vertica_dba_user_password =  SSH.createDbaUser(installerSSH, options.vertica_dba_user, options.vertica_dba_group, options.vertica_dba_user_dir, options.vertica_dba_user_password)
            if not ok:
                ErrorMonitor.err() 
                sys.exit(1)
        except adapter.SSHException, sshe:
            print "%s" % sshe
            ErrorMonitor.err()
            sys.exit(1)
            

        if not SSH.check_max_user_procs(installerSSH, fix=True, user=options.vertica_dba_user):
            ErrorMonitor.warn()
        
        single_node_skip_network_test = False
            
        # SSH keys
        if len(fullhostname_list) > 1:
            print "Installing/Repairing SSH keys for %s\n" % options.vertica_dba_user
            SSH.installOrRepairSSHKeys(installerSSH, options.vertica_dba_user)
        else:
            single_node_skip_network_test = True



        # Fix multiple users on existing hosts by addign them to the new dba group
        # installerSSH.setHosts(updatehostname_list)

        if os.path.exists( DBinclude.CONFIG_USER_DIR ):
            print "Modifying existing Vertica DBA user\n"
            for existing_user in os.listdir( DBinclude.CONFIG_USER_DIR ):
                Status,res = installerSSH.execute( "/usr/sbin/usermod -a -G %s %s" % (options.vertica_dba_group, existing_user ), hide=True)
                if not Status:
                    for host in res.keys():
                        if res[host][0] == "6":
                          # ok, probably a NIS/LDAP user. Modify /etc/group directly.
                          # we'll do this on each host directly, as maybe some worked (?)
                          if not SSH.manuallyAddUserToGroup( installerSSH.getConnection(host), existing_user, options.vertica_dba_group ):
                             ErrorMonitor.warn()
                             LOG("Failed to add previous users to dba group.\n You will need to add the users to the %s group manually" % options.vertica_dba_group)

        

        installerSSH.setHosts(addhostname_list)

        # Check admin tools metadata
        adminToolMetaFiles = [
                              DBinclude.CONFIG_USER_DIR + "/" + options.vertica_dba_user + "/siteinfo.dat",
                              DBinclude.CONFIG_USER_DIR + "/" + options.vertica_dba_user +"/dbinfo.dat",
                              DBinclude.CONFIG_USER_DIR + "/" + options.vertica_dba_user + "/installed.dat",
                              DBinclude.CONFIG_SHARE_DIR + "/portinfo.dat",
                              DBinclude.CONFIG_SHARE_DIR + "/license.key"
                              ]
        
        print "Creating Vertica Data Directory...\n"
        SSH.createDataDir(installerSSH, options.vertica_dba_user, options.data_dir)
        for item in adminToolMetaFiles:
            Status, res = installerSSH.execute("sh -c \"[ -e %s ]\""%item, hide=True)
            for host in res.keys():
                if res[host][0] == "0":
                    LOG_RECORD("%s: Info: Admin tool config file %s already exists."%(host,item))
                      
        # Done with new node checking
        installerSSH.resetHosts()

        # Run network test for initial installation or when adding nodes (not when only removing)
        networkTest = (options.add_hosts or options.hosts) and not options.skip_network_test and not single_node_skip_network_test
        if options.skip_network_test:
            LOG("Skipping N-way network test (not recommended)")
        if networkTest:                    
            print "Testing N-way network test.  (this may take a while)"
            # Verify that all the hosts are configured correctly to run vertica
            netverify_test = netverify.MultiSiteTest(fullhostname_list, running_as, host=fullhostname_list[0], password=rootPassword, ssh=installerSSH, debug=options.debug, ignore_netmask=options.ignore_netmask, use_sudo=using_sudo)
            netverify_test.setAsUser(options.vertica_dba_user)
            r = netverify_test.run()
        
            # Write the detail output from the verification script
            
            if len(netverify_test.output) > 0:
                print
                for l in netverify_test.output: LOG(l)
        
            # Write the log
            
            try:
                log_file="%s/netverify-%s.log"% (DBinclude.LOG_DIR, options.vertica_dba_user)
                log_out = open(os.path.expanduser(log_file), "w")
                
                for l in netverify_test.log:
                    log_out.write(l)
                    log_out.write("\n")
                
                log_out.close()
                
            except Exception, e:
                LOG("Error: could not write log to " + log_file + ": " + str(e))
        
               
            if not r:
                LOG("Verification failed. Correct the above issues to proceed")
                ErrorMonitor.err()
                sys.exit(1)
    

        # Before reconfiguring spread, remove nodes from the admin
        # tools siteDict.  drop_node will refuse to remove the node if
        # it's being used in a database, and this must happen before
        # we yank the node from spread
        #
        for nodeName in [node[0] for node in siteDict.values() if node[1] in removehostname_list or node[1] in downremovehosts ]:
            LOG_BEGIN("Removing node %s definition" % (nodeName))

            if(options.replaceHost):
                ErrorMonitor.warn()
                LOG("-- not removed, this node must be replaced via admintools in each database instead!")
            else:
                if not executor.drop_node( nodeName, force_if_last=True ):
                    LOG("-- couldn't remove node, it's in-use by a database!")
                    ErrorMonitor.err()
                    sys.exit(1)
            LOG_END(True)

        # Generate node names for the new hosts
        #
        # must do this now so large cluster config picks the same
        # nodes on which to run spread that adminTools will expect
        # spread to be running on

        nodeInfo = executor.getNodeInfo()
        currentnode_list = [n for n in nodeInfo.keys()]
        newNames = {}
        
        nodeCount = 1
        nodeName = "node%04d" % (nodeCount)
        for host in addhostname_list:
            # find an unused name
            while nodeName in currentnode_list:
                nodeCount += 1
                nodeName = "node%04d" % (nodeCount)
            newNames[nodeName] = host
            currentnode_list.append(nodeName)

        currentnode_list.sort()

        print "Updating spread configuration..."

        # construct in-order list of hosts based on node-name
        spread_hosts = []
        for node in currentnode_list:
            host = None
            if node in nodeInfo:
                host = nodeInfo[node][1]
            else:
                host = newNames[node]
            if host not in spread_hosts:
                spread_hosts.append(host)

        non_spread_hosts = []

        if options.large_cluster:
            if len(orig_spread_hosts) != options.large_cluster:
                # prune spread hosts to include only the nodes that should run spread
                non_spread_hosts = spread_hosts[options.large_cluster:]
                del spread_hosts[options.large_cluster:]
                options.forceSpreadReconfiguration = "default"
            else:
                newsh = []
                for host in spread_hosts:
                    if host in orig_spread_hosts:
                        newsh.append(host)
                    else:
                        non_spread_hosts.append(host)
                spread_hosts = newsh
                
            # are we replacing spread nodes?
            if options.replaceHost:
                for i in range(len(addhostname_list)):
                    if removehostname_list[i] in spread_hosts:
                        # put new node in old nodes spot in spread list
                        spread_hosts[spread_hosts.index(removehostname_list[i])] = addhostname_list[i]
                        non_spread_hosts.remove(addhostname_list[i])
                        non_spread_hosts.append(removehostname_list[i])

            # pull spread from machines that should not be running it
            installerSSH.resetHosts()
            installerSSH.setHosts(non_spread_hosts)
            print "\tStopping spread on %s" % non_spread_hosts
            # stop spread if it's running
            Status, res = installerSSH.execute("%s/vertica_service_setup.sh stop %s %s" % (DBinclude.sbinDir, DBinclude.DB_DIR, DBinclude.OSNAME), hide=True);
            print "\tUninstalling spread on %s" % non_spread_hosts
            # remove spreadd links in /etc
            Status, res = installerSSH.execute("%s/vertica_service_setup.sh remove %s %s" % (DBinclude.sbinDir, DBinclude.DB_DIR, DBinclude.OSNAME), hide=True)
            # done with spread teardown

        if len(non_spread_hosts):
            print "NOTICE: Large cluster config, running spread on %s -- not running spread on %s" % (",".join(spread_hosts),",".join(non_spread_hosts))

        # Do spread daemon teardown on removed hosts and hosts that
        # had an RPM install/upgrade; for the latter we should rerun
        # setup in case the spread installation script changed
        if ( len( removehostname_list + hostsToUpgradeRPM ) > 0 ):
            installerSSH.resetHosts()
            installerSSH.setHosts(removehostname_list + hostsToUpgradeRPM + [ host for host in addhostname_list if host not in hostsToUpgradeRPM ])
            # stop spread if it's running
            Status, res = installerSSH.execute("%s/vertica_service_setup.sh stop %s %s" % (DBinclude.sbinDir, DBinclude.DB_DIR, DBinclude.OSNAME), hide=True);
            # remove spreadd links in /etc
            Status, res = installerSSH.execute("%s/vertica_service_setup.sh remove %s %s" % (DBinclude.sbinDir, DBinclude.DB_DIR, DBinclude.OSNAME), hide=True)
            # done with spread teardown

        installerSSH.resetHosts()

        # Generate new spread config file contents
        uniqueBroadcastAddrs = {}


        if(not options.direct_only):  # if(options.allowUDP) to change default
            uniqueBroadcastAddrs = DBfunctions.uniqueBroadCastAddresses( profiles, options.forceSpreadReconfiguration, ignoreHosts = non_spread_hosts )
        else:
            # each node has its own IP as bcast, which will cause the
            # spread config file to put each host in its own segment,
            # which will cause spread to use TCP for cluster communications
            # if -T and -S are used together, this gets a bit more complicated.
            #
            uba = DBfunctions.uniqueBroadCastAddresses( profiles, options.forceSpreadReconfiguration, ignoreHosts = non_spread_hosts )
            for host in spread_hosts:
                if options.forceSpreadReconfiguration != None and options.forceSpreadReconfiguration != 'default':
                  for bc in uba.keys():
                     found = False
                     if host in uba[bc]:
                        for nic in profiles[host].network.nic.keys():
                            interface = profiles[host].network.nic[nic]
                            if interface[2] == bc:
                               found = True
                               uniqueBroadcastAddrs[ interface[0] ] = [ host ]
                               break
                        if found:
                           break
                else: 
                   uniqueBroadcastAddrs[DBfunctions.IPAddress(host)] = [ host ]

	# Configure spread logging: off by default, user must explicitly enable each time
        spread_logging = False
        if ( options.spread_logging_on ):
	   spread_logging = True

        # cool spread workaround loop... blech.
        sigSpreadReconfig = True
        sigStop = options.replaceHost

        while sigSpreadReconfig:

            sigSpreadReconfig = False
            if sigStop:
                sigSpreadReconfig = True
                sigStop = False
                spreadConfContents = SSH.createSpreadConfFile( uniqueBroadcastAddrs, profiles, directSend=options.direct_only, logging=spread_logging, daemonGroup=options.vertica_dba_group, ignore_hosts=removehostname_list+addhostname_list )
            else:
                spreadConfContents = SSH.createSpreadConfFile( uniqueBroadcastAddrs, profiles, directSend=options.direct_only, logging=spread_logging, daemonGroup=options.vertica_dba_group )


            # if we need to reconfigure spread on any existing hosts (if
            # not forcing a cluster-wide reconfiguration and we're adding
            # or removing hosts with an existing cluster), do that first
            ### XXX  the >1 here is part of the spread workaround, should be >0 later.
            if (options.forceSpreadReconfiguration == None)  and (len(updatehostname_list) > 1 and len(addhostname_list + removehostname_list) > 0 ):
                # don't try to reconfigure spread on hosts that had the
                # RPM upgraded, spread isn't running yet
                spreadReloadHosts = [h for h in updatehostname_list if h in spread_hosts and h not in hostsToUpgradeRPM]
                
                installerSSH.setHosts(spreadReloadHosts)

                #
                # update and reload spread configuration file
                #
                LOG("Verifying spread is running on old cluster")
                (rc, nodeList) = SSH.spreadCheck(installerSSH)
        
                if (rc != 0) or (len(nodeList) > 0):
                    LOG("\tError (%d) while verifying spread running where expected" % (rc))
                    LOG("\tNodes with errors: %s" % (nodeList,))
                    LOG("\tCannot update spread node list when it is not running")

                    #
                    # give spread a chance... try and restart it.
                    #
                    installerSSH.setHosts( nodeList )
                    installerSSH.execute( "/etc/init.d/spreadd start", info_msg="Attempting to restart spread.")
                    (rc, nodeList) = SSH.spreadCheck(installerSSH)
                    if (rc != 0) or (len(nodeList) > 0):
                            LOG("\tSpread failed to start on: %s" % nodeList )
                            LOG("\tCannot update spread node list when it is not running")
                            LOG("\tExiting....")
                            ErrorMonitor.err()
                            sys.exit(1)


                # replace the old spread config file with the new one
                installerSSH.setHosts(spreadReloadHosts)
                Status, res = installerSSH.execute("cp -u " + DBinclude.SPREAD_CONF + " " + DBinclude.SPREAD_CONF + ".bak.%f" % time.time(),
                                                   info_msg="Saving old spread configuration file")
                if not Status:
                    for host in res.keys():
                        if res[host][0] == "0":
                            LOG("Could not backup old spread configuration file on host %s" % (host))
                    LOG("Aborting.")
                    ErrorMonitor.err()
                    sys.exit(1)

                # write out the vspread.conf file and then copy it around the cluster 
                FILE = open(DBinclude.SPREAD_CONF,"w")
                FILE.writelines("\n".join(spreadConfContents))
                FILE.close()
                installerSSH.execute("chown %s:%s  %s" % ( running_as, options.vertica_dba_group, DBinclude.SPREAD_CONF ) )
                installerSSH.execute("chmod 777 %s" % DBinclude.SPREAD_CONF )
                SSH.sendClusterConfiguration(installerSSH, spreadReloadHosts, DBinclude.SPREAD_CONF , DBinclude.CONFIG_DIR, options.vertica_dba_user   )
 

 

                #Status, res = installerSSH.execute("sh -c \"(" + netverify.to_echo(spreadConfContents) + ") > " + DBinclude.SPREAD_CONF + "\"", 
                #                                    info_msg="Creating new spread configuration file")
                #if not Status:
                #    for host in res.keys():
                #        if res[host][0][0] == "0":
                #            LOG("Could not backup old spread configuration file on host %s" % (host))
                #    LOG("Aborting.")
                #    ErrorMonitor.err()
                #    sys.exit(1)

                # Be sure we can read the config file
                Status, res = installerSSH.execute("cat " + DBinclude.SPREAD_CONF)
                if not Status:
                    LOG("Could not read back spread configuration file.")
                    ErrorMonitor.err()
                    sys.exit(1)

                # new spread configuration is created on all old nodes, now signal a spread reload
                LOG("Signaling spread to reload configuration")
                (status, msg) = SSH.spreadReload(installerSSH)
                if status:
                    LOG("\tError %d while signaling spread reload: %s" % (status, msg))
                    LOG("\tManual intervention may be required.")
                    ErrorMonitor.err()
                    sys.exit(1)

                installerSSH.setHosts(spreadReloadHosts) 
                LOG("Verifying new spread configuration on the existing cluster")
                (rc, nodeList) = SSH.spreadCheck(installerSSH)

                if (rc != 0) or (len(nodeList) > 0):
                    LOG("\tError while verifying spread on all hosts (%d)" % (rc))
                    LOG("\tNodes with errors: %s" % (nodeList,))
                    ErrorMonitor.err()
                    sys.exit(1)


        # we need to create a spread configuration and start spread on
        # any hosts where spread isn't running (newly added or
        # upgraded hosts).  This typically also includes the host
        # we're running the install on, even though doesn't need an
        # RPM upgrade

        installerSSH.setHosts(spread_hosts)  # omit nodes that don't run spread

        if(options.forceSpreadReconfiguration != None ):
            # stop spread if it's running so we can reload it
            Status, res = installerSSH.execute("%s/vertica_service_setup.sh stop %s %s" % (DBinclude.sbinDir, DBinclude.DB_DIR, DBinclude.OSNAME), hide=True);
            if not Status:
                LOG("\tError while stopping spread everywhere (%s)" % (res))
                ErrorMonitor.err()
                sys.exit(1)

        (rc, hostsNeedingStartSpread) = SSH.spreadCheck(installerSSH)
        if (rc != 0):
            LOG("\tError while checking spread on all hosts (%d)" % (rc))
            LOG("\tCouldn't check where spread needs to be started, exiting.")
            ErrorMonitor.err()
            sys.exit(1)

        for h in removehostname_list:
            if h in hostsNeedingStartSpread:
                hostsNeedingStartSpread.remove( h ) 
        
        LOG_RECORD("Hosts needing spread restart: %s" % (hostsNeedingStartSpread))

        if(len(hostsNeedingStartSpread) > 0):
            installerSSH.setHosts(hostsNeedingStartSpread)

            # Config dirs get created as part of the RPM install, set permissions to DBA group
            SSH.makeDir(installerSSH, DBinclude.CONFIG_DIR, "775", options.vertica_dba_group)
            #SSH.makeDir(installerSSH, DBinclude.CONFIG_INFO_DIR, "775", options.vertica_dba_group)
            SSH.makeDir(installerSSH, DBinclude.CONFIG_SHARE_DIR, "775", options.vertica_dba_group)
            SSH.makeDir(installerSSH, DBinclude.CONFIG_USER_DIR, "775", options.vertica_dba_group)
            SSH.makeDir(installerSSH, DBinclude.LOG_DIR, "775", options.vertica_dba_group)
            SSH.makeDir(installerSSH, DBinclude.SCRIPT_DIR, "775", options.vertica_dba_group, recursive="-R")

            # remove old setup spreadd links in /etc, if any
            Status, res = installerSSH.execute("%s/vertica_service_setup.sh remove %s %s" % (DBinclude.sbinDir, DBinclude.DB_DIR, DBinclude.OSNAME),
                                               hide=True, info_msg="Removing old spread daemon links")

            # setup spreadd links in /etc
            Status, res = installerSSH.execute("%s/vertica_service_setup.sh install %s %s" % (DBinclude.sbinDir, DBinclude.DB_DIR, DBinclude.OSNAME),
                                               hide=True, info_msg="Setting up spread daemon")

            # stop spread if it's running
            Status, res = installerSSH.execute("%s/vertica_service_setup.sh stop %s %s" % (DBinclude.sbinDir, DBinclude.DB_DIR, DBinclude.OSNAME), hide=True);

            # create the spread configuration file on all the nodes
            # write out the vspread.conf file and then copy it around the cluster 
            FILE = open(DBinclude.SPREAD_CONF,"w")
            FILE.writelines("\n".join(spreadConfContents))
            FILE.close()
            installerSSH.execute("chown %s:%s  %s" % ( running_as, options.vertica_dba_group, DBinclude.SPREAD_CONF ) )
            installerSSH.execute("chmod 777 %s" % DBinclude.SPREAD_CONF )
            SSH.sendClusterConfiguration(installerSSH, hostsNeedingStartSpread, DBinclude.SPREAD_CONF , DBinclude.CONFIG_DIR, options.vertica_dba_user   )
            #Status, res = installerSSH.execute("sh -c \"(" + netverify.to_echo(spreadConfContents) + ") > " + DBinclude.SPREAD_CONF + "\"", 
            #                                   info_msg="Creating spread configuration file")
            #if not Status:
            #    LOG("Could not create spread configuration file.")
            #    ErrorMonitor.err()
            #    sys.exit(1)

            # Be sure we can read the config file
            Status, res = installerSSH.execute("cat " + DBinclude.SPREAD_CONF)
            if not Status:
                LOG("Could not read back spread configuration file.")
                ErrorMonitor.err()
                sys.exit(1)

            spread_admin = spreadAdmin.spreadAdmin()
            
            profiles_needing_restart = {}
            for h in hostsNeedingStartSpread:
                profiles_needing_restart[h] = profiles[h]
            
            spreadNames = spread_admin.getSpreadNames( hostsNeedingStartSpread, profiles_needing_restart, options.forceSpreadReconfiguration )
            for host in hostsNeedingStartSpread:
                spreadname = spreadNames[host]
                installerSSH.setHosts(host)
                if DBinclude.OSNAME == "DEBIAN" or DBinclude.OSNAME == "SUNOS": # for the day we support debian.. one less thing to do!
                    installerSSH.execute("chmod 777 /etc/spreadd" )
                    Status, res = installerSSH.execute("echo 'SPREADARGS=\"-n %s ${SPREADARGS}\"' >> /etc/spreadd" % (spreadname),  hide=True)
                else:
                    installerSSH.execute("chmod 777 /etc/sysconfig/spreadd" )
                    Status, res = installerSSH.execute("echo 'SPREADARGS=\"-n %s ${SPREADARGS}\"' >> /etc/sysconfig/spreadd" % (spreadname), hide=True)

                if not Status:
                    ErrorMonitor.warn()
                    LOG( "Error configuring /etc/sysconfig/spreadd file on %s - you may need to configure spread manually." % (host))
                    LOG( '%s' % res )

            installerSSH.setHosts(hostsNeedingStartSpread)

            # start the spread daemon
            Status, res = installerSSH.execute("%s/vertica_service_setup.sh restart %s %s" % (DBinclude.sbinDir, DBinclude.DB_DIR, DBinclude.OSNAME),
                                        hide=True,
                                        info_msg="Starting spread daemon");

            if not Status:
                LOG( "Error starting spread on all hosts.")
                ErrorMonitor.err()
                sys.exit(1);

        # Fixing permissions on older installs.
        installerSSH.setHosts(updatehostname_list)
        SSH.makeDir(installerSSH, DBinclude.CONFIG_DIR, "775", options.vertica_dba_group)
        #SSH.makeDir(installerSSH, DBinclude.CONFIG_INFO_DIR, "775", options.vertica_dba_group)
        SSH.makeDir(installerSSH, DBinclude.CONFIG_SHARE_DIR, "775", options.vertica_dba_group)
        SSH.makeDir(installerSSH, DBinclude.CONFIG_USER_DIR, "775", options.vertica_dba_group)
        SSH.makeDir(installerSSH, DBinclude.LOG_DIR, "775", options.vertica_dba_group)
        SSH.makeDir(installerSSH, DBinclude.SCRIPT_DIR, "775", options.vertica_dba_group, recursive="-R")


        # done with reconfiguration, perform final verification on whole cluster
        LOG("Verifying spread configuration on whole cluster")
        installerSSH.setHosts(fullhostname_list)
        (rc, nodeList) = SSH.spreadCheck(installerSSH)

        errors = list(nodeList)
        # if non_spread_hosts is set, spread should not be running on them
        if len(non_spread_hosts) > 0:
            errors = []
            nsh = list(non_spread_hosts)
            for n in nodeList:
                if n in nsh:
                    nsh.remove(n)
                else:
                    print "\t%s should be running spread but is not" % n
                    errors.append(n)
            # count removed hosts as not running spread (they shouldn't be)
            for n in removehostname_list:
                if n in nsh:
                    nsh.remove(n)
            for n in nsh:
                print "\t%s should not be running spread, but is" % n
                errors.append(n)

        if (rc != 0) or (len(errors) > 0):
            LOG("\tError while verifying spread on all hosts (%d)" % (rc))
            LOG("\tNodes with errors: %s" % (errors,))
            ErrorMonitor.err()
            sys.exit(1)

        # create the dba user directory.
        # we do this here on all hosts in case we are adding additional dba users
        SSH.makeDir(installerSSH, "%s/%s"%(DBinclude.CONFIG_USER_DIR,options.vertica_dba_user), "go-w", owner=options.vertica_dba_user)

        # add new nodes to admintools structures
        for nodeName in newNames:
            host = newNames[nodeName]
            LOG_BEGIN("Creating node %s definition for host %s" % (nodeName, host))
            executor.do_create_node( [ nodeName, host, options.data_dir, options.data_dir ],
                                     True,   # True == Force Create
                                     False ) # False == Hold off on sending to cluster 
            LOG_END(True)

        # ok - grab the updated node dictionary and distribute to the cluster
        # this is an optimization for large cluster sizes.
        nodedict = executor.getNodeInfo()

        from vertica.config.Configurator import Configurator
        c = Configurator.Instance()
        if options.large_cluster:
            c.set_spread_hosts(spread_hosts)
        elif orig_spread_hosts:
            c.set_spread_hosts([])
        c.save()

        executor.__ssh = installerSSH
        executor.sendSiteInfo( nodedict, ignore_hosts=downremovehosts )

        # refresh node list from executor just to be sure, log it, and replicate throughout cluster
        currentnode_list = [n for n in executor.getNodeInfo().keys()]
        LOG_RECORD("Updating admin tools node list: %s" % currentnode_list)
        executor.updateInstalledDict(options.rpm_file_name, user = options.vertica_dba_user, nodeHostList = fullhostname_list)
        installerSSH.execute("chown %s:%s  %s" % ( running_as, options.vertica_dba_group, DBinclude.CONFIG_DIR + "/admintools.conf" ) )
        installerSSH.execute("chmod 0660 %s" % DBinclude.CONFIG_DIR + "/admintools.conf" )

        # TODO: shutdown spread (which should have already exited
        # after being reconfigured) and clean up removed nodes (e.g.,
        # remove RPM?)

        if options.accept_eula:
            fp = open(DBinclude.CONFIG_DIR +"/d5415f948449e9d4c421b568f2411140.dat","w")
            fp.write("S:a\n")
            fp.write("T:"+ str(time.time())+"\n")
            fp.write("U:"+ str( os.geteuid() ) +"\n")
            fp.close()
            SSH.sendClusterConfiguration(installerSSH, fullhostname_list, DBinclude.CONFIG_DIR + "/d5415f948449e9d4c421b568f2411140.dat" , DBinclude.CONFIG_DIR, options.vertica_dba_user   )

        
        try:
           # always try to set the permissions on this file during install. they may have been set wrong by the -Y option
           installerSSH.execute("chown %s:%s  %s" % ( running_as, options.vertica_dba_group, DBinclude.CONFIG_DIR + "/d5415f948449e9d4c421b568f2411140.dat" ) )
           installerSSH.execute("chmod 777 %s" % DBinclude.CONFIG_DIR + "/d5415f948449e9d4c421b568f2411140.dat" )
        except:
           print "Warning - permissions on %s" % DBinclude.CONFIG_DIR + "/d5415f948449e9d4c421b568f2411140.dat may not be set correctly."
           ErrorMonitor.warn()


        if options.license_file != None:
           xcc = commandLineCtrl.commandLineCtrl(False,False) 
           stat = xcc.isValidLicenseKey( options.license_file )
           if stat != 0:
              ErrorMonitor.warn()
           else:
              installerSSH.execute("chown %s:%s  %s" % ( options.vertica_dba_user, options.vertica_dba_group, DBinclude.CONFIG_DIR + "/share/license.key" ) )


        # fix some old outstanding permission issues
        if os.path.exists( DBinclude.CONFIG_DIR + "/share/license.key" ):
              installerSSH.execute("chown %s:%s  %s" % ( options.vertica_dba_user, options.vertica_dba_group, DBinclude.CONFIG_DIR + "/share/license.key" ) )
      
        if os.path.exists( DBinclude.CONFIG_DIR + "/share/portinfo.dat" ):
              installerSSH.execute("chown %s:%s  %s" % ( options.vertica_dba_user, options.vertica_dba_group, DBinclude.CONFIG_DIR + "/share/portinfo.dat" ) )



        installerSSH.close()



        print "Error Monitor  %s errors  %s warnings" % ( ErrorMonitor.ErrorMonitor.Instance().getErrorCount(), ErrorMonitor.ErrorMonitor.Instance().getWarningCount())

    except SystemExit:
        pool = adapterpool.AdapterConnectionPool_3.Instance()
        pool.close()
        code = 0
        if ErrorMonitor.ErrorMonitor.Instance().hasWarnings():
           print "Installation completed with warnings.  "
           code = 1
       
        if ErrorMonitor.ErrorMonitor.Instance().hasErrors():
           print "Installation completed with errors.  "
           code = 1
       
        if REDIRECT:
           sys.stdout.close()
           sys.stdout = STDOUT
           sys.stderr = STDERR

        sys.exit(code)
    except (SSH.error, adapter.SSHException, adapter.AuthenticationException), e:
        pool = adapterpool.AdapterConnectionPool_3.Instance()
        pool.close()
        print "Error: "+str(e)
        DBfunctions.record("Error: "+str(e))
        if REDIRECT:
           sys.stdout.close()
           sys.stdout = STDOUT
           sys.stderr = STDERR

        sys.exit(1)

    except KeyboardInterrupt, e:
        pool = adapterpool.AdapterConnectionPool_3.Instance()
        pool.close()
        print "Installation canceled by user."
        DBfunctions.record("Canceled: "+str(e))
        if REDIRECT:
           sys.stdout.close()
           sys.stdout = STDOUT
           sys.stderr = STDERR
        sys.exit(1)

    except Exception, e:
        pool = adapterpool.AdapterConnectionPool_3.Instance()
        pool.close()
        print "Error: "+str(e)
        DBfunctions.record("Error: "+str(e))
        traceback.print_exc(file=sys.stdout)
        if REDIRECT:
           sys.stdout.close()
           sys.stdout = STDOUT
           sys.stderr = STDERR

        sys.exit(1)
    
    pool = adapterpool.AdapterConnectionPool_3.Instance()
    pool.close()

    if ErrorMonitor.ErrorMonitor.Instance().hasWarnings():
       print "Installation completed with warnings.  "
       
    if ErrorMonitor.ErrorMonitor.Instance().hasErrors():
       print "Installation completed with errors.  "
       
    
    if REDIRECT:
       sys.stdout.close()
       sys.stdout = STDOUT
       sys.stderr = STDERR

