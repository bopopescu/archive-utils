CREATE SEQUENCE address_id_seq;

CREATE TABLE address (
  id bigint NOT NULL PRIMARY KEY DEFAULT nextval('address_id_seq'),
  version int not null,
  street varchar(100) not null,
  city varchar(64) not null
);
