-- -- -- -- -- -- - READ-ONLY BEGIN -- -- -- -- --  

GRANT SELECT, Execute, References on bits.* TO 'lockerzreport'@'%' IDENTIFIED BY 'njurodf2dvjwpn';
GRANT SELECT, Execute, References on locator.* TO 'lockerzreport'@'%' IDENTIFIED BY 'njurodf2dvjwpn';
GRANT SELECT, Execute, References on pod1.* TO 'lockerzreport'@'%' IDENTIFIED BY 'njurodf2dvjwpn';
GRANT SELECT, Execute, References on pod2.* TO 'lockerzreport'@'%' IDENTIFIED BY 'njurodf2dvjwpn';
GRANT SELECT, Execute, References on pod3.* TO 'lockerzreport'@'%' IDENTIFIED BY 'njurodf2dvjwpn';
GRANT SELECT, Execute, References on pod4.* TO 'lockerzreport'@'%' IDENTIFIED BY 'njurodf2dvjwpn';
GRANT SELECT, Execute, References on pod5.* TO 'lockerzreport'@'%' IDENTIFIED BY 'njurodf2dvjwpn';
GRANT SELECT, Execute, References on pod6.* TO 'lockerzreport'@'%' IDENTIFIED BY 'njurodf2dvjwpn';
GRANT SELECT, Execute, References on pod7.* TO 'lockerzreport'@'%' IDENTIFIED BY 'njurodf2dvjwpn';
GRANT SELECT, Execute, References on pod8.* TO 'lockerzreport'@'%' IDENTIFIED BY 'njurodf2dvjwpn';
GRANT SELECT, Execute, References on pod9.* TO 'lockerzreport'@'%' IDENTIFIED BY 'njurodf2dvjwpn';
GRANT SELECT, Execute, References on social.* TO 'lockerzreport'@'%' IDENTIFIED BY 'njurodf2dvjwpn';
GRANT SELECT, Execute, References on socialgraph.* TO 'lockerzreport'@'%' IDENTIFIED BY 'njurodf2dvjwpn';
GRANT SELECT, Execute, References on forum.* TO 'lockerzreport'@'%' IDENTIFIED BY 'njurodf2dvjwpn';
GRANT SELECT, Execute, References on media.* TO 'lockerzreport'@'%' IDENTIFIED BY 'njurodf2dvjwpn';
GRANT SELECT, Execute, References on jms.* TO 'lockerzreport'@'%' IDENTIFIED BY 'njurodf2dvjwpn';
flush privileges;

GRANT ALL on reporting.* TO 'lockerzreport'@'%' IDENTIFIED BY 'njurodf2dvjwpn';
GRANT ALL on reporting.* TO 'lockerzreport'@'localhost' IDENTIFIED BY 'njurodf2dvjwpn';
GRANT ALL on reporting.* TO 'lockerzreport'@'127.0.0.1' IDENTIFIED BY 'njurodf2dvjwpn';
flush privileges;


GRANT SELECT, Execute, References on bits.* TO 'readuser'@'%' IDENTIFIED BY 'defaultpw';
GRANT SELECT, Execute, References on locator.* TO 'readuser'@'%' IDENTIFIED BY 'defaultpw';
GRANT SELECT, Execute, References on pod1.* TO 'readuser'@'%' IDENTIFIED BY 'defaultpw';
GRANT SELECT, Execute, References on pod2.* TO 'readuser'@'%' IDENTIFIED BY 'defaultpw';
GRANT SELECT, Execute, References on pod3.* TO 'readuser'@'%' IDENTIFIED BY 'defaultpw';
GRANT SELECT, Execute, References on pod4.* TO 'readuser'@'%' IDENTIFIED BY 'defaultpw';
GRANT SELECT, Execute, References on pod5.* TO 'readuser'@'%' IDENTIFIED BY 'defaultpw';
GRANT SELECT, Execute, References on pod6.* TO 'readuser'@'%' IDENTIFIED BY 'defaultpw';
GRANT SELECT, Execute, References on pod7.* TO 'readuser'@'%' IDENTIFIED BY 'defaultpw';
GRANT SELECT, Execute, References on pod8.* TO 'readuser'@'%' IDENTIFIED BY 'defaultpw';
GRANT SELECT, Execute, References on pod9.* TO 'readuser'@'%' IDENTIFIED BY 'defaultpw';
GRANT SELECT, Execute, References on jms.* TO 'readuser'@'%' IDENTIFIED BY 'defaultpw';
flush privileges;

GRANT SELECT, Execute, References on bits.* TO 'readuser'@'localhost' IDENTIFIED BY 'defaultpw';
GRANT SELECT, Execute, References on locator.* TO 'readuser'@'localhost' IDENTIFIED BY 'defaultpw';
GRANT SELECT, Execute, References on pod1.* TO 'readuser'@'localhost' IDENTIFIED BY 'defaultpw';
GRANT SELECT, Execute, References on pod2.* TO 'readuser'@'localhost' IDENTIFIED BY 'defaultpw';
GRANT SELECT, Execute, References on pod3.* TO 'readuser'@'localhost' IDENTIFIED BY 'defaultpw';
GRANT SELECT, Execute, References on pod4.* TO 'readuser'@'localhost' IDENTIFIED BY 'defaultpw';
GRANT SELECT, Execute, References on pod5.* TO 'readuser'@'localhost' IDENTIFIED BY 'defaultpw';
GRANT SELECT, Execute, References on pod6.* TO 'readuser'@'localhost' IDENTIFIED BY 'defaultpw';
GRANT SELECT, Execute, References on pod7.* TO 'readuser'@'localhost' IDENTIFIED BY 'defaultpw';
GRANT SELECT, Execute, References on pod8.* TO 'readuser'@'localhost' IDENTIFIED BY 'defaultpw';
GRANT SELECT, Execute, References on pod9.* TO 'readuser'@'localhost' IDENTIFIED BY 'defaultpw';
GRANT SELECT, Execute, References on jms.* TO 'readuser'@'localhost' IDENTIFIED BY 'defaultpw';
flush privileges;

-- -- -- -- -- -- - READ-ONLY END -- -- -- -- --  


-- -- -- -- -- -- - APP BEGIN -- -- -- -- --  

GRANT ALL PRIVILEGES ON bits.* TO 'phoenix'@'127.0.0.1' IDENTIFIED BY 'Dixie6scam';
GRANT ALL PRIVILEGES ON locator.* TO 'locator'@'%' IDENTIFIED BY 'taw49huzzas';
GRANT ALL PRIVILEGES ON pod1.* TO 'phoenix'@'127.0.0.1' IDENTIFIED BY 'Dixie6scam';
GRANT ALL PRIVILEGES ON pod2.* TO 'phoenix'@'127.0.0.1' IDENTIFIED BY 'Dixie6scam';
GRANT ALL PRIVILEGES ON pod3.* TO 'phoenix'@'127.0.0.1' IDENTIFIED BY 'Dixie6scam';
GRANT ALL PRIVILEGES ON pod4.* TO 'phoenix'@'127.0.0.1' IDENTIFIED BY 'Dixie6scam';
GRANT ALL PRIVILEGES ON pod5.* TO 'phoenix'@'127.0.0.1' IDENTIFIED BY 'Dixie6scam';
GRANT ALL PRIVILEGES ON pod6.* TO 'phoenix'@'127.0.0.1' IDENTIFIED BY 'Dixie6scam';
GRANT ALL PRIVILEGES ON pod7.* TO 'phoenix'@'127.0.0.1' IDENTIFIED BY 'Dixie6scam';
GRANT ALL PRIVILEGES ON pod8.* TO 'phoenix'@'127.0.0.1' IDENTIFIED BY 'Dixie6scam';
GRANT ALL PRIVILEGES ON pod9.* TO 'phoenix'@'127.0.0.1' IDENTIFIED BY 'Dixie6scam';

GRANT ALL PRIVILEGES ON bits.* TO 'bits'@'localhost' IDENTIFIED BY 'idle912giro';
GRANT ALL PRIVILEGES ON locator.* TO 'locator'@'localhost' IDENTIFIED BY 'taw49huzzas';
GRANT ALL PRIVILEGES ON pod1.* TO 'phoenix'@'localhost' IDENTIFIED BY 'Dixie6scam';
GRANT ALL PRIVILEGES ON pod2.* TO 'phoenix'@'localhost' IDENTIFIED BY 'Dixie6scam';
GRANT ALL PRIVILEGES ON pod3.* TO 'phoenix'@'localhost' IDENTIFIED BY 'Dixie6scam';
GRANT ALL PRIVILEGES ON pod4.* TO 'phoenix'@'localhost' IDENTIFIED BY 'Dixie6scam';
GRANT ALL PRIVILEGES ON pod5.* TO 'phoenix'@'localhost' IDENTIFIED BY 'Dixie6scam';
GRANT ALL PRIVILEGES ON pod6.* TO 'phoenix'@'localhost' IDENTIFIED BY 'Dixie6scam';
GRANT ALL PRIVILEGES ON pod7.* TO 'phoenix'@'localhost' IDENTIFIED BY 'Dixie6scam';
GRANT ALL PRIVILEGES ON pod8.* TO 'phoenix'@'localhost' IDENTIFIED BY 'Dixie6scam';
GRANT ALL PRIVILEGES ON pod9.* TO 'phoenix'@'localhost' IDENTIFIED BY 'Dixie6scam';

GRANT ALL PRIVILEGES ON bits.* TO 'bits' IDENTIFIED BY 'idle912giro';
GRANT ALL PRIVILEGES ON locator.* TO 'locator' IDENTIFIED BY 'taw49huzzas';
GRANT ALL PRIVILEGES ON pod1.* TO 'phoenix' IDENTIFIED BY 'Dixie6scam';
GRANT ALL PRIVILEGES ON pod2.* TO 'phoenix' IDENTIFIED BY 'Dixie6scam';
GRANT ALL PRIVILEGES ON pod3.* TO 'phoenix' IDENTIFIED BY 'Dixie6scam';
GRANT ALL PRIVILEGES ON pod4.* TO 'phoenix' IDENTIFIED BY 'Dixie6scam';
GRANT ALL PRIVILEGES ON pod5.* TO 'phoenix' IDENTIFIED BY 'Dixie6scam';
GRANT ALL PRIVILEGES ON pod6.* TO 'phoenix' IDENTIFIED BY 'Dixie6scam';
GRANT ALL PRIVILEGES ON pod7.* TO 'phoenix' IDENTIFIED BY 'Dixie6scam';
GRANT ALL PRIVILEGES ON pod8.* TO 'phoenix' IDENTIFIED BY 'Dixie6scam';
GRANT ALL PRIVILEGES ON pod9.* TO 'phoenix' IDENTIFIED BY 'Dixie6scam';

flush privileges;

GRANT ALL PRIVILEGES ON forum.* TO 'forum'@'localhost' IDENTIFIED BY 'rdxljydmr';
GRANT ALL PRIVILEGES ON forum.* TO 'forum'@'%' IDENTIFIED BY 'rdxljydmr';
GRANT ALL PRIVILEGES ON forum.* TO 'forum' IDENTIFIED BY 'rdxljydmr';
flush privileges;

GRANT SELECT, Execute, UPDATE, DELETE, References on ptsplace.* TO 'ptsplace'@'localhost' IDENTIFIED BY 'ptsplace';
GRANT SELECT, Execute, UPDATE, DELETE, References on ptsplace.* TO 'ptsplace'@'%' IDENTIFIED BY 'ptsplace';
flush privileges;

GRANT SELECT, Execute, UPDATE, DELETE, References on social.* TO 'socialap'@'localhost' IDENTIFIED BY 'dllfsjwsjn';
GRANT SELECT, Execute, UPDATE, DELETE, References on social.* TO 'socialap'@'%' IDENTIFIED BY 'dllfsjwsjn';

GRANT SELECT, Execute, UPDATE, DELETE, References on socialgraph.* TO 'socialap'@'localhost' IDENTIFIED BY 'dllfsjwsjn';
GRANT SELECT, Execute, UPDATE, DELETE, References on socialgraph.* TO 'socialap'@'%' IDENTIFIED BY 'dllfsjwsjn';

flush privileges;


-- -- -- -- -- -- - APP END -- -- -- -- --  


-- -- -- -- -- -- - ROOT BEGIN -- -- -- -- --  

GRANT ALL on *.* TO 'ulockerz'@'%' IDENTIFIED BY 'u10ckerz' with grant option;
GRANT ALL on *.* TO 'ulockerz'@'localhost' IDENTIFIED BY 'u10ckerz' with grant option;
GRANT ALL on *.* TO 'ulockerz'@'127.0.0.1' IDENTIFIED BY 'u10ckerz' with grant option;

GRANT ALL on *.* TO 'blockerz'@'%' IDENTIFIED BY 'b10ckerz' with grant option;
GRANT ALL on *.* TO 'blockerz'@'localhost' IDENTIFIED BY 'b10ckerz' with grant option;
GRANT ALL on *.* TO 'blockerz'@'127.0.0.1' IDENTIFIED BY 'b10ckerz' with grant option;

GRANT ALL on *.* TO 'mlockerz'@'%' IDENTIFIED BY 'm10ckerz' with grant option;
GRANT ALL on *.* TO 'mlockerz'@'localhost' IDENTIFIED BY 'm10ckerz' with grant option;
GRANT ALL on *.* TO 'mlockerz'@'127.0.0.1' IDENTIFIED BY 'm10ckerz' with grant option;

GRANT ALL on *.* TO 'nlockerz'@'%' IDENTIFIED BY 'n10ckerz' with grant option;
GRANT ALL on *.* TO 'nlockerz'@'localhost' IDENTIFIED BY 'n10ckerz' with grant option;
GRANT ALL on *.* TO 'nlockerz'@'127.0.0.1' IDENTIFIED BY 'n10ckerz' with grant option;

GRANT ALL on *.* TO 'olockerz'@'%' IDENTIFIED BY 'o10ckerz' with grant option;
GRANT ALL on *.* TO 'olockerz'@'localhost' IDENTIFIED BY 'o10ckerz' with grant option;
GRANT ALL on *.* TO 'olockerz'@'127.0.0.1' IDENTIFIED BY 'o10ckerz' with grant option;

GRANT ALL on *.* TO 'dlockerz'@'%' IDENTIFIED BY 'd10ckerz' with grant option;
GRANT ALL on *.* TO 'dlockerz'@'localhost' IDENTIFIED BY 'd10ckerz' with grant option;
GRANT ALL on *.* TO 'dlockerz'@'127.0.0.1' IDENTIFIED BY 'd10ckerz' with grant option;

GRANT ALL on *.* TO 'larry'@'%' IDENTIFIED BY '1arry' with grant option;
GRANT ALL on *.* TO 'larry'@'localhost' IDENTIFIED BY '1arry' with grant option;
GRANT ALL on *.* TO 'larry'@'127.0.0.1' IDENTIFIED BY '1arry' with grant option;

GRANT ALL on *.* TO 'murali'@'%' IDENTIFIED BY 'mural1' with grant option;
GRANT ALL on *.* TO 'murali'@'localhost' IDENTIFIED BY 'mural1' with grant option;
GRANT ALL on *.* TO 'murali'@'127.0.0.1' IDENTIFIED BY 'mural1' with grant option;

GRANT ALL on *.* TO 'yatrik'@'%' IDENTIFIED BY 'yatrlk' with grant option;
GRANT ALL on *.* TO 'yatrik'@'localhost' IDENTIFIED BY 'yatrlk' with grant option;
GRANT ALL on *.* TO 'yatrik'@'127.0.0.1' IDENTIFIED BY 'yatrlk' with grant option;

flush privileges;


-- -- -- -- -- -- - Replication  -- -- -- -- --  

GRANT REPLICATION SLAVE ON *.* TO 'repl_slave'@'%' IDENTIFIED BY 'oobaecathaireiwaipheexohj';
flush privileges;

-- -- -- -- -- -- - Monitor  -- -- -- -- --  

GRANT REPLICATION CLIENT ON *.* TO 'nagios'@'%' IDENTIFIED BY 'L8d0vbY5uzKpug1ahgFxB0XAU';
GRANT PROCESS, SUPER, PROCESS on *.* to 'lockerzCACTIro' identified by 'GjKVs62F8Kbv29Vf';
flush privileges;

# privs on all hosts
CREATE USER 'lockerz-jms'@'%' IDENTIFIED BY 'password';
GRANT SUPER ON *.* TO 'lockerz-jms'@'%';
GRANT ALL PRIVILEGES ON jms.* TO 'lockerz-jms'@'%';

# privs on localhost
CREATE USER 'lockerz-jms'@'localhost' IDENTIFIED BY 'password';
GRANT SUPER ON *.* TO 'lockerz-jms'@'localhost';
GRANT ALL PRIVILEGES ON jms.* TO 'lockerz-jms'@'localhost';

GRANT ALL  ON jms.* TO 'jmsuser'@'localhost' IDENTIFIED BY 'jhxhgkwh';
GRANT ALL  ON jms.* TO 'jmsuser'@'%' IDENTIFIED BY 'jhxhgkwh';
flush privileges;

-- -- -- -- -- -- - END ALL  -- -- -- -- -- - 

GRANT SELECT, Execute, References on *.* TO 'lockerzreport'@'%' IDENTIFIED BY 'njurodf2dvjwpn';
GRANT SELECT, Execute, References on *.* TO 'lockerzreport'@'localhost' IDENTIFIED BY 'njurodf2dvjwpn';
GRANT ALL on reporting.* TO 'lockerzreport'@'%' IDENTIFIED BY 'njurodf2dvjwpn';
GRANT ALL on reporting.* TO 'lockerzreport'@'localhost' IDENTIFIED BY 'njurodf2dvjwpn';

GRANT SELECT, Execute, References on *.* TO 'readuser'@'%' IDENTIFIED BY 'defaultpw';
GRANT SELECT, Execute, References on *.* TO 'readuser'@'localhost' IDENTIFIED BY 'defaultpw';

GRANT SELECT, Execute, References, File on *.* TO 'lockerzextract'@'%' IDENTIFIED BY '10ckerzextract';
GRANT SELECT, Execute, References, File on *.* TO 'lockerzextract'@'localhost' IDENTIFIED BY '10ckerzextract';
GRANT ALL on etractdb.* TO 'lockerzextract'@'%' IDENTIFIED BY '10ckerzextract';
GRANT ALL on etractdb.* TO 'lockerzextract'@'localhost' IDENTIFIED BY '10ckerzextract';

flush privileges;

GRANT USAGE ON *.* TO 'aproxy'@'%' IDENTIFIED BY 'hdlghdjel' ; 
GRANT USAGE ON *.* TO 'aproxy'@'localhost' IDENTIFIED BY 'hdlghdjel' ; 
GRANT ALL on auction_proxy.* TO 'aproxy'@'%' IDENTIFIED BY 'hdlghdjel';
GRANT ALL on auction_proxy.* TO 'aproxy'@'localhost' IDENTIFIED BY 'hdlghdjel';

GRANT USAGE ON *.* TO 'uauction'@'%' IDENTIFIED BY 'hjkltrew' ; 
GRANT USAGE ON *.* TO 'uauction'@'localhost' IDENTIFIED BY 'hjkltrew' ; 
GRANT ALL on user_auction.* TO 'uauction'@'%' IDENTIFIED BY 'hjkltrew';
GRANT ALL on user_auction.* TO 'uauction'@'localhost' IDENTIFIED BY 'hjkltrew'; 

flush privileges;

GRANT USAGE ON *.* TO 'auction'@'%' IDENTIFIED BY 'hVbUWwHdp30m5LUHlBPw' ; 
GRANT USAGE ON *.* TO 'auction'@'localhost' IDENTIFIED BY 'hVbUWwHdp30m5LUHlBPw' ; 
GRANT SELECT, INSERT, UPDATE, DELETE ON `auction`.* TO 'auction'@'%' ;                                  
GRANT SELECT, INSERT, UPDATE, DELETE ON `auction`.* TO 'auction'@'localhost' ;                                  


flush privileges;

GRANT ALL on magento_intl.* TO 'smagento'@'%' IDENTIFIED BY 'uatmtest';
GRANT ALL on magento_intl.* TO 'smagento'@'localhost' IDENTIFIED BY 'uatmtest';
GRANT ALL on magento_20100922.* TO 'smagento'@'%' IDENTIFIED BY 'uatmtest';
GRANT ALL on magento_20100922.* TO 'smagento'@'localhost' IDENTIFIED BY 'uatmtest';

flush privileges;

GRANT ALL on auction_proxy.* TO 'redemp'@'%' IDENTIFIED BY 'redemp';

---- Example of setting Slave ------------

CHANGE MASTER to MASTER_HOST='10.218.15.211',MASTER_PORT=3306,MASTER_USER='repl_slave',MASTER_PASSWORD='oobaecathaireiwaipheexohj',MASTER_LOG_FILE='mysql-bin.000003',MASTER_LOG_POS=3531;
