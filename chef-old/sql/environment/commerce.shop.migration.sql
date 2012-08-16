--
-- This is a script to change the magento config to use /shop instead of shop.ENV_NAME.lockerz.us
--

UPDATE core_config_data SET value = "http://ENV_NAME.lockerz.us/shop/" WHERE path = "web/unsecure/base_url" AND scope = 'default';
UPDATE core_config_data SET value = "https://ENV_NAME.lockerz.us/shop/" WHERE path = "web/secure/base_url" AND scope = 'default';

UPDATE core_config_data SET value = "https://ENV_NAME.lockerz.us/shop/staging/lockerz_1" WHERE path = "web/unsecure/base_url" AND scope='websites';
UPDATE core_config_data SET value = "https://ENV_NAME.lockerz.us/shop/staging/lockerz_1" WHERE path = "web/unsecure/base_web_url" AND scope='websites';
UPDATE core_config_data SET value = "https://ENV_NAME.lockerz.us/shop/staging/lockerz_1" WHERE path = "web/unsecure/base_link_url" AND scope='websites';
UPDATE core_config_data SET value = "https://ENV_NAME.lockerz.us/shop/staging/js/" WHERE path = "web/unsecure/base_js_url" AND scope='websites';
UPDATE core_config_data SET value = "https://ENV_NAME.lockerz.us/shop/staging/skin/" WHERE path = "web/unsecure/base_skin_url" AND scope='websites';
UPDATE core_config_data SET value = "https://ENV_NAME.lockerz.us/shop/staging/media/" WHERE path = "web/unsecure/base_media_url" AND scope='websites';

UPDATE core_config_data SET value = "https://ENV_NAME.lockerz.us/shop/staging/lockerz_1" WHERE path = "web/secure/base_url" AND scope='websites';
UPDATE core_config_data SET value = "https://ENV_NAME.lockerz.us/shop/staging/lockerz_1" WHERE path = "web/secure/base_web_url" AND scope='websites';
UPDATE core_config_data SET value = "https://ENV_NAME.lockerz.us/shop/staging/lockerz_1" WHERE path = "web/secure/base_link_url" AND scope='websites';
UPDATE core_config_data SET value = "https://ENV_NAME.lockerz.us/shop/staging/js/" WHERE path = "web/secure/base_js_url" AND scope='websites';
UPDATE core_config_data SET value = "https://ENV_NAME.lockerz.us/shop/staging/skin/" WHERE path = "web/secure/base_skin_url" AND scope='websites';
UPDATE core_config_data SET value = "https://ENV_NAME.lockerz.us/shop/staging/media/" WHERE path = "web/secure/base_media_url" AND scope='websites';


