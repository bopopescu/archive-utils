DROP TABLE IF EXISTS about_statement_prefix cascade;
CREATE TABLE about_statement_prefix (
id integer ,
source_id integer default null,
prefix varchar(50) default null,
is_active integer default 1,
rec_created_on datetime default null,
rec_updated_on datetime 
);

DROP TABLE IF EXISTS activity_type cascade;
CREATE TABLE activity_type (
id integer ,
name varchar(31) ,
is_active integer default 1,
ref_ptz_type_id integer default null,
ref_ptz_title varchar(63) default null,
category_name varchar(63) default null,
ptz_book_type varchar(15) default null,
rec_created_on datetime default null,
rec_updated_on datetime
);

DROP TABLE IF EXISTS auction cascade;
CREATE TABLE auction (
id integer ,
source_db_num integer ,
source_auction_id integer ,
creation_date datetime ,
start_timestamp datetime ,
end_timestamp datetime ,
title varchar(100) ,
sku varchar(256) ,
opening_price integer default 0,
reserve_price integer default null,
minimum_bid_increment integer default 1,
status integer default 0,
source_winner_uid integer default null,
winning_bid integer default null,
source_ship_address_id integer default null,
ip_address varchar(15) default null,
bid_increment integer  default 1,
tier integer default 0,
dollar_value double precision default null,
buy_now_price integer default null,
type integer default null,
rec_created_on datetime default null,
rec_updated_on datetime
);

DROP TABLE IF EXISTS auction_status cascade;
CREATE TABLE auction_status (
id integer ,
src_enum_sequence integer ,
name varchar(63) default null,
rec_created_on datetime default null,
rec_updated_on datetime
);

DROP TABLE IF EXISTS connection_type cascade;
CREATE TABLE connection_type (
id integer ,
name varchar(31) ,
is_active int default 1,
rec_created_on datetime default null,
rec_updated_on datetime
);

DROP TABLE IF EXISTS country cascade;
CREATE TABLE country (
id integer ,
source_id int default null,
code char(2) ,
abbrv varchar(15) default null,
full_name varchar(63) default null,
tld varchar(7) default null,
is_active integer default 1,
region varchar(127) default null,
rec_created_on datetime default null,
rec_updated_on datetime
);

DROP TABLE IF EXISTS date cascade;
CREATE TABLE date (
id integer ,
date_value date ,
quarter_of_year integer default null,
month_of_year integer default null,
week_of_year integer default null,
day_of_year integer default null,
day_of_month integer default null,
day_of_week integer default null,
fmt_month_full varchar(10) default null,
fmt_month_abrv char(3) default null,
fmt_weekday_full varchar(10) default null,
fmt_weekday_abrv char(3) default null,
fmt_date_yyyy_mm_dd_dash char(12) default null,
us_holiday varchar(63) default null,
is_active integer default 1,
rec_created_on datetime default null,
rec_updated_on datetime
);

DROP TABLE IF EXISTS decalz cascade;
CREATE TABLE decalz (
id integer ,
source_id int default null,
type varchar(15) ,
category varchar(63) ,
name varchar(100) default null,
status integer default 1,
is_active integer default 1,
shop_sku varchar(255) default null,
rec_created_on datetime default null,
rec_updated_on datetime
);


DROP TABLE IF EXISTS gender cascade;
CREATE TABLE gender (
id integer ,
gender char(1) ,
is_active integer default 1,
rec_created_on datetime default null,
rec_updated_on datetime
);

DROP TABLE IF EXISTS geo cascade;
CREATE TABLE geo (
id integer ,
country_id int default null,
country_code char(2),
city_name varchar(63) default null,
sub_country_code varchar(15) default null,
sub_country_desc varchar(63) default null,
postal_code varchar(15) default null,
county_name varchar(31) default null,
metro_area_code varchar(15) default null,
metro_area_desc varchar(31) default null,
center_gps_lng float default null,
center_gps_lat float default null,
is_active integer default 1,
rec_created_on datetime default null,
rec_updated_on datetime
);

DROP TABLE IF EXISTS giftcard cascade;
CREATE TABLE giftcard (
id integer ,
source_id int default null,
source_id_key char(43) ,
event varchar(128) default null,
ref_ptz integer default null,
ref_source_uid integer ,
ref_redeemed_on datetime default null,
creator varchar(64) default null,
created_on datetime default null,
begins_on datetime default null,
ends_on datetime default null,
is_active integer default 1,
rec_created_on datetime default null,
rec_updated_on datetime
);

DROP TABLE IF EXISTS language cascade;
CREATE TABLE language(
id integer ,
code char(2) ,
name varchar(100) ,
is_active integer default 1,
rec_created_on datetime default null,
rec_updated_on datetime
);

DROP TABLE IF EXISTS lockerz_events cascade;
CREATE TABLE lockerz_events (
id integer ,
start_time datetime ,
end_time datetime ,
description varchar(65000) default null,
summary varchar(255) default null,
type varchar(15) ,
rec_created_on datetime default null,
rec_updated_on datetime
);

DROP TABLE IF EXISTS payment_vendor cascade;
CREATE TABLE payment_vendor (
id integer ,
source_id integer default null,
name varchar(63) ,
is_active integer default 1,
rec_created_on datetime default null,
rec_updated_on datetime
);

DROP TABLE IF EXISTS ptz_type cascade;
CREATE TABLE ptz_type (
id integer ,
source_id integer default null,
title varchar(100) ,
category varchar(15) default null,
is_active integer default 1,
rec_created_on datetime default null,
rec_updated_on datetime
);

DROP TABLE IF EXISTS timezone cascade;
CREATE TABLE timezone (
id integer ,
offset_hour float ,
code varchar(7) ,
description varchar(100) ,
is_active integer default 1,
rec_created_on datetime default null,
rec_updated_on datetime 
);

DROP TABLE IF EXISTS us_state cascade;
CREATE TABLE us_state (
id integer ,
code char(2) ,
full_name varchar(63) default null,
rec_created_on datetime default null,
rec_updated_on datetime 
);

DROP TABLE IF EXISTS us_state_zip cascade;
CREATE TABLE us_state_zip (
id integer ,
state_code char(2) ,
zipcode varchar(15) ,
rec_created_on datetime default null,
rec_updated_on datetime 
);

DROP TABLE IF EXISTS "user" cascade;
CREATE TABLE "user" (
id integer ,
source_id integer default null,
email varchar(127) default null,
date_of_birth date default null,
gender char(1) default null,
tshirt_size char(3) default null,
geo_id integer default null,
language_code char(2) default null,
language_name varchar(63) default null,
timezone_offset float default null,
country_id integer,
country_code char(2),
country_full_name varchar(63),
invited_by_user integer default null,
external_referral varchar(63) default null,
member_since date ,
has_about_self integer default 0,
has_profile_img integer default 0,
is_zlister integer default 0,
is_active integer default 1,
cellphone varchar(31) default null,
first_name varchar(63) default null,
last_name varchar(63) default null,
rec_created_on datetime default null,
rec_updated_on datetime
);

DROP TABLE IF EXISTS "user_history" cascade;
CREATE TABLE "user_history" (
id integer ,
source_id integer default null,
email varchar(127) default null,
date_of_birth date default null,
gender char(1) default null,
tshirt_size char(3) default null,
geo_id integer default null,
language_code char(2) default null,
language_name varchar(63) default null,
timezone_offset float default null, 
country_id integer,
country_code char(2),
country_full_name varchar(63),
invited_by_user integer default null,
external_referral varchar(63) default null,
member_since date ,
has_about_self integer default 0,
has_profile_img integer default 0,
is_zlister integer default 0,
is_active integer default 1,
cellphone varchar(31) default null,
first_name varchar(63) default null,
last_name varchar(63) default null,
rec_created_on datetime default null,
rec_updated_on datetime
); 

DROP TABLE IF EXISTS user_address cascade;
CREATE TABLE user_address (
id integer ,
source_db_num integer ,
source_addresss_id integer default null,
user_id integer default null,
address_label varchar(31) default null,
address_line_1 varchar(127) default null,
address_line_2 varchar(127) default null,
city varchar(63) default null,
state varchar(63) default null,
country_code char(2),
ref_postal_code varchar(15) default null,
normalized_zip varchar(15) default null,
is_default_billing integer default null,
is_default_shipping integer default null,
ref_last_updated datetime default null,
rec_created_on datetime default null,
rec_updated_on datetime
);

DROP TABLE IF EXISTS user_role cascade;
CREATE TABLE user_role (
id integer ,
source_id integer default null,
TITLE varchar(63) ,
UW_name varchar(31) default null,
is_active integer default 1,
rec_created_on datetime default null,
rec_updated_on datetime 
);

DROP TABLE IF EXISTS video_catalog cascade;
CREATE TABLE video_catalog (
id integer ,
source_id integer ,
title varchar(127) default null,
description varchar(65000) default null,
duration_seconds integer default null,
url varchar(255) ,
src_provider_id integer default null,
release_key varchar(63) default null,
ptz_value integer default 0,
approved integer  default 0,
date_effective datetime ,
date_expire datetime default null,
is_active integer default 1,
artist varchar(255) default null,
provider_genre_category varchar(1023) default null,
geo_approved_countries varchar(1023) default null,
is_geo_exclude_filter_applied integer default null,
p_notice varchar(1023) default null,
need_parental_advisory integer default null,
comma_tags varchar(1023),
provider_publish_date datetime default null,
provider_name varchar(255) default null,
pipe_categories varchar(1023) ,
rec_created_on datetime default null,
rec_updated_on datetime
);

DROP TABLE IF EXISTS activity cascade;
CREATE TABLE activity (
id integer 
,activity_type_id integer 
,ptz_value integer default '0'
,ref_ptz_type_id integer default null
,user_id integer default null
,timestamp datetime 
,timestamp_est datetime 
,date_value  date 
,date_value_est  date not null
,uw_status varchar(63)
,user_role_id integer
,source_ptz_trans_id integer default null
,source_db_num varchar(127) default null
,activity_type_name varchar(31)
,activity_type_category varchar(63)
)
partition by extract (year from date_value_est);

DROP TABLE IF EXISTS activity_bid cascade;
CREATE TABLE activity_bid (
id integer ,
activity_id integer ,
auction_id integer ,
bid_amount integer ,
current_bid_amount integer ,
is_winning_bid integer default '0'
);

DROP TABLE IF EXISTS activity_bonusansw cascade;
CREATE TABLE activity_bonusansw (
id integer ,
activity_id integer ,
event_ref_id integer default null,
bonus_id integer default null
);

DROP TABLE IF EXISTS activity_dailies cascade;
CREATE TABLE activity_dailies (
id integer ,
activity_id integer ,
event_ref_id integer default null,
dailies_id integer default null
);

DROP TABLE IF EXISTS activity_decalz cascade;
CREATE TABLE activity_decalz (
id integer ,
activity_id integer ,
decalz_id integer default null,
clicker_id integer default null
);

DROP TABLE IF EXISTS activity_giftcard cascade;
CREATE TABLE activity_giftcard (
id integer ,
activity_id integer ,
giftcard_id integer ,
redeemed_on datetime default null,
redeemed_on_est datetime default null
);

DROP TABLE IF EXISTS activity_photo cascade;
CREATE TABLE activity_photo (
id integer ,
activity_id integer ,
ref_photo_id integer default null,
activity_type_name varchar(31)
);

DROP TABLE IF EXISTS activity_shop cascade;
CREATE TABLE activity_shop (
id integer ,
activity_id integer ,
src_invoice_id varchar(63) default null,
src_record_found integer default '1'
);

DROP TABLE IF EXISTS activity_thirdparty cascade;
CREATE TABLE activity_thirdparty (
id integer ,
activity_id integer ,
ref_3rd_party_evt_id varchar(255) 
);

DROP TABLE IF EXISTS activity_uw_purchase cascade;
CREATE TABLE activity_uw_purchase (
id integer ,
activity_id integer ,
price_paid float default '0.00',
payment_vendor_id integer default null,
payment_vendor_name varchar(63)
);

DROP TABLE IF EXISTS activity_videoviewed cascade;
CREATE TABLE activity_videoviewed (
id integer ,
activity_id integer ,
event_ref_id integer default null,
video_id integer default null
);

DROP TABLE IF EXISTS activity_vshop cascade;
CREATE TABLE activity_vshop (
id integer ,
activity_id integer ,
vshop_order_id integer ,
num_order_items integer default '1',
order_total float default '0'
);

DROP TABLE IF EXISTS connection cascade;
CREATE TABLE connection (
id integer ,
user1_id integer ,
user2_id integer ,
invite_sent_by integer default null,
invite_accepted_on datetime default null,
fwb_sent_by integer default null,
fwb_accepted_on datetime default null,
num_user_1_decal_clicked integer default '0',
num_user_2_decal_clicked integer default '0',
num_user_1_decal_salethru integer default '0',
num_user_2_decal_salethru integer default '0'
);

DROP TABLE IF EXISTS content_feedback cascade;
CREATE TABLE content_feedback (
id integer ,
content_type varchar(15) ,
content_id integer ,
source_uid integer ,
user_id integer default null,
event_type varchar(15) ,
event_time datetime ,
event_ref_key varchar(31) default null
);


DROP TABLE IF EXISTS invitation cascade;
CREATE TABLE invitation (
id integer ,
source_db_num integer ,
source_invitation_id integer default null,
source_invitation_type_id integer default null,
source_sender_uid integer default null,
source_recipient_uid integer default null,
recipient varchar(200) default null,
date_sent datetime default null,
date_clicked datetime default null,
date_accepted datetime default null,
connection_type varchar(31),
is_sent integer default null,
sender_ip_address varchar(20) default null,
recipient_ip_address varchar(20) default null
);

DROP TABLE IF EXISTS vshop_order cascade;
CREATE TABLE vshop_order (
id integer ,
source_id_key varchar(127) ,
order_created_on datetime ,
user_id integer ,
token varchar(63) default null,
payer_id_key varchar(63) default null,
transaction_id_key varchar(63) default null,
status varchar(15) default null,
rec_created_on datetime default null,
rec_updated_on datetime 
);

DROP TABLE IF EXISTS vshop_order_items cascade;
CREATE TABLE vshop_order_items (
id integer ,
vshop_order_id integer ,
decalz_id integer ,
price_paid float default '0.00',
rec_created_on datetime default null,
rec_updated_on datetime 
);

DROP TABLE IF EXISTS interaction cascade;
CREATE TABLE interaction (
  init_user_id integer,
  rcpt_user_id integer,
  type varchar(63),
  timestamp_est datetime
);

DROP TABLE IF EXISTS ref_user_ptz_balance cascade;
CREATE TABLE ref_user_ptz_balance (
  source_uid integer,
  ptz_balance integer
);

DROP TABLE IF EXISTS user_friends cascade;
CREATE TABLE user_friends (
  user_id integer,
  num_friends integer
);

DROP TABLE IF EXISTS user_last_visit cascade;
CREATE TABLE user_last_visit (
  user_id integer,
  last_visit date 
);

DROP TABLE IF EXISTS user_decalz cascade;
CREATE TABLE user_decalz (
  user_id integer,
  decalz_id integer,
  created datetime,
  last_modified datetime,
  rec_created_on datetime,
  rec_updated_on datetime
);
