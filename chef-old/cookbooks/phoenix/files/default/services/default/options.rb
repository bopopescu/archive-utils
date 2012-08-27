
serviceJavaOps = "-Xmx256m -XX:+PrintTenuringDistribution -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -Xloggc:%s/%s/gc_%s.log -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=%s/%s/dump" % [
	FSLogPath,
	serviceName,
	Options[:strLogDate],
	FSLogPath,
	serviceName
]

serviceMain = " -Dlog.filename=%s/%s/service com.lockerz.phoenix.accesscontrol.AccessControlServiceMain" % [
	FSLogPath,
	serviceName,
]


