
TRUNCATE `pod`;
INSERT INTO `pod` ( `id`,`location`,`status`,`signup`,`created` ) VALUES (
	NULL,
	"PodService: tcp -h service0.phoenix.ENV_NAME.lockerz.int -p 10300 -t 5000 : tcp -h service1.phoenix.ENV_NAME.lockerz.int -p 10300 -t 5000",
	1,
	1,
	NOW()
);

