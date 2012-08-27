drop table if exists video_catalog cascade;
CREATE TABLE video_catalog (
id integer ,
source_id integer ,
source_video2_id integer ,
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

grant all privileges on video_catalog to dw_dev;
grant select on video_catalog to dw_readonly;

