CREATE SEQUENCE shop_id_seq;

CREATE TABLE shop (
  id bigint NOT NULL PRIMARY KEY DEFAULT nextval('shop_id_seq'),
  version int not null,
  name varchar(100) not null
);

CREATE SEQUENCE meat_id_seq;

CREATE TABLE meat (
  id bigint NOT NULL PRIMARY KEY DEFAULT nextval('meat_id_seq'),
  version int not null,
  shop_id bigint not null,
  name varchar(100) not null,
  price_dollars int not null  
);

CREATE SEQUENCE shop_user_id_seq;

CREATE TABLE shop_user (
  id bigint NOT NULL PRIMARY KEY DEFAULT nextval('shop_user_id_seq'),
  version int not null,
  email varchar(100) not null,
  password varchar(100) not null
);
