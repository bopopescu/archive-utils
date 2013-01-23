package com.lockerz.common.spring.jpa;

import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * @author Brian Gebala
 * @version 11/29/12 11:14 AM
 */
public class JpaConfigUtil {
    public static void generate2ndLevelCacheConfigs(final List<String> hosts,
                                                    final int numOfThreads) {
        Set<String> uniqueHosts = new HashSet<String>();

        for (String host : hosts) {
            if (uniqueHosts.contains(host)) {
                System.out.println("ERROR - duplicate host found: " + host);
                return;
            }

            uniqueHosts.add(host);

            StringBuilder buf = new StringBuilder();
            buf.append("openjpa.remoteCommitProvider=tcp(Addresses=");

            for (String otherHost : hosts) {
                if (!otherHost.equals(host)) {
                    buf.append(otherHost);
                    buf.append(';');
                }
            }

            buf.append(", NumBroadcastThreads=");
            buf.append(numOfThreads);
            buf.append(")");

            System.out.println("Config for host: " + host);
            System.out.println(buf.toString());
            System.out.println();
        }
    }

    public static void main(final String[] args) {
        int numOfThreads = Integer.parseInt(args[0]);
        List<String> hosts = Arrays.asList(Arrays.copyOfRange(args, 1, args.length));
        generate2ndLevelCacheConfigs(hosts, numOfThreads);
    }
}
