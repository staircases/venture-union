DROP TYPE risk_levels CASCADE;
DROP TABLE customer, risk, item, pawn_ticket, inventory_tag, receipt CASCADE;
DROP DATABASE Homestuck;

CREATE DATABASE Homestuck;

CREATE TYPE risk_levels AS ENUM('Low', 'Medium', 'High', 'Very High');

CREATE TABLE customer(
  customer_id     INT NOT NULL UNIQUE PRIMARY KEY,
  last_name       VARCHAR(25) NOT NULL,
  given_name      VARCHAR(25) NOT NULL,
  middle_initial  CHAR,
  address         VARCHAR(255) NOT NULL,
  city            VARCHAR(25) NOT NULL,
  mobile          VARCHAR(25),
  landline        VARCHAR(25),
  postal_code     INT NOT NULL,
  birth_date      DATE NOT NULL
  -- age             INT GENERATED ALWAYS AS (CAST((
  --   CAST(TO_CHAR(CURRENT_DATE, 'YYYYMMDD') AS INT) - CAST(TO_CHAR(birth_date, 'YYYYMMDD') AS INT)
  -- ) AS INT)/10000) STORED
);
CREATE TABLE risk(
  risk_level    risk_levels NOT NULL UNIQUE PRIMARY KEY,
  interest_rate FLOAT NOT NULL
);
CREATE TABLE item(
  item_no     INT NOT NULL UNIQUE PRIMARY KEY,
  category    VARCHAR(25) NOT NULL,
  description VARCHAR(255),
  risk_level  risk_levels NOT NULL,
  amount      FLOAT NOT NULL,
  FOREIGN KEY (risk_level) REFERENCES risk(risk_level) ON DELETE RESTRICT
);
CREATE TABLE pawn_ticket(
  ticket_no     INT NOT NULL UNIQUE PRIMARY KEY,
  pawn_date     DATE NOT NULL DEFAULT CURRENT_DATE,
  due_date      DATE GENERATED ALWAYS AS (pawn_date + interval '1 month') STORED,
  payment_date  DATE
);

CREATE TABLE inventory_tag(
  item_no       INT NOT NULL,
  customer_id   INT NOT NULL,
  description   VARCHAR(255),
  category      VARCHAR(25) NOT NULL,
  pawn_date     DATE NOT NULL,
  amount        FLOAT NOT NULL,
  PRIMARY KEY (item_no, customer_id),
  FOREIGN KEY (item_no) REFERENCES item(item_no) ON DELETE RESTRICT,
  FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE RESTRICT
);
CREATE TABLE receipt(
  payment_date  DATE
);

INSERT INTO item VALUES (111, 'Jewelry', 'Gold ring, 24k', 'Medium', 10000.00);
INSERT INTO item VALUES (154, 'Jewelry', 'Gold ring with 1 carat diamond', 'Medium', 30000.00);
INSERT INTO item VALUES (167, 'Jewelry', 'Gold earrings, 1 pair', 'Very High', 500.00);
INSERT INTO customer VALUES (3572, 'Francisco', 'Carlito', 'P', 'Blk 9, Lot 3 Tubos Street, Sanglaan Homes', 'Mandaluyong', '0999-7774433', '4448899', 1555, '1960-01-01');
INSERT INTO risk VALUES ('Low', 0.015);
INSERT INTO risk VALUES ('Medium', 0.035);
INSERT INTO risk VALUES ('High', 0.0575);
INSERT INTO risk VALUES ('Very High', 0.0875);
INSERT INTO pawn_ticket VALUES (456, '2021-11-11');
INSERT INTO item VALUES (999, 'Electronics', 'Nokia 3.1, black, with battery', 'Low', 1500.00);
INSERT INTO inventory_tag VALUES (111, 456, 'Gold ring, 24k', 'Jewelry', '2021-11-11', 10000.00);
