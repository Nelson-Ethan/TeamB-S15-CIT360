-- ----------------------------------------------------------------------
-- Instructions:
-- ----------------------------------------------------------------------
-- The two scripts contain spooling commands, which is why there
-- isn't a spooling command in this script. When you run this file
-- you first connect to the Oracle database with this syntax:
--
--   sqlplus student/student@xe
--
-- Then, you call this script with the following syntax:
--
--   sql> @apply_oracle_lab6.sql
--
-- ----------------------------------------------------------------------

-- Run the prior lab script.
@/home/student/Data/cit225/oracle/lab5/apply_oracle_lab5.sql
--@/home/student/Data/cit225/oracle/lab5/o5.sql

-- -------
-- step 1
-- -------

ALTER TABLE rental_item
   ADD (rental_item_price NUMBER)
   ADD (rental_item_type NUMBER);

-- save the following alter statement for later in the lab, when the rows have data THEN we can add constraints that have not null
-- ALTER TABLE rental
--    ADD (CONSTRAINT fk_rental_item_5 FOREIGN KEY (rental_item_type) REFERENCES common_lookup(common_lookup_id));
--    

SET NULL ''
COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'RENTAL_ITEM'
ORDER BY 2;

-- ------------
-- Step 2
-- -------------
-- Conditionally drop table and sequence.
BEGIN
  FOR i IN (SELECT null FROM user_tables WHERE table_name = 'PRICE') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE price CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null FROM user_sequences WHERE sequence_name = 'PRICE_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE price_s1';
  END LOOP;
END;
/

-- create table price
CREATE TABLE price
(price_id               NUMBER
,item_id                NUMBER      CONSTRAINT nn_price_1 NOT NULL
,price_type             NUMBER      
,active_flag            VARCHAR2(1) CONSTRAINT nn_price_2  NOT NULL
,start_date             DATE        CONSTRAINT nn_price_3 NOT NULL
,end_date               DATE
,amount                 NUMBER      CONSTRAINT nn_price_4 NOT NULL
,created_by             NUMBER      CONSTRAINT nn_price_5 NOT NULL
,creation_date          DATE        CONSTRAINT nn_price_6 NOT NULL
,last_updated_by        NUMBER      CONSTRAINT nn_price_7 NOT NULL
,last_update_date       DATE        CONSTRAINT nn_price_8 NOT NULL
,CONSTRAINT YN_PRICE CHECK (active_flag IN ('Y','N'))
,CONSTRAINT pk_price_1 PRIMARY KEY (price_id)
,CONSTRAINT fk_price_1 FOREIGN KEY (item_id) REFERENCES item(item_id)
,CONSTRAINT fk_price_2 FOREIGN KEY (price_type) REFERENCES common_lookup(common_lookup_id)
,CONSTRAINT fk_price_3 FOREIGN KEY (created_by) REFERENCES system_user(system_user_id) 
,CONSTRAINT fk_price_4 FOREIGN KEY (last_updated_by) REFERENCES system_user(system_user_id));


CREATE SEQUENCE price_s1 START WITH 1001;

SET NULL ''
COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'PRICE'
ORDER BY 2;

COLUMN constraint_name   FORMAT A16
COLUMN search_condition  FORMAT A30
SELECT   uc.constraint_name
,        uc.search_condition
FROM     user_constraints uc INNER JOIN user_cons_columns ucc
ON       uc.table_name = ucc.table_name
AND      uc.constraint_name = ucc.constraint_name
WHERE    uc.table_name = UPPER('price')
AND      ucc.column_name = UPPER('active_flag')
AND      uc.constraint_name = UPPER('yn_price')
AND      uc.constraint_type = 'C';

-- -------------
-- Step 3
-- -------------

-- a 
ALTER TABLE ITEM 
   RENAME COLUMN item_release_date TO release_date;



SET NULL ''
COLUMN TABLE_NAME   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   TABLE_NAME
,        column_id
,        column_name
,        CASE
           WHEN NULLABLE = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS NULLABLE
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    TABLE_NAME = 'ITEM'
ORDER BY 2;

-- b
-- DVD 1
INSERT 
INTO ITEM
(item_id
,item_barcode
,item_type
,item_title
,item_subtitle
,item_rating
,release_date
,created_by
,creation_date
,last_updated_by
,last_update_date)
VALUES
(item_s1.nextval
,'123456789qwert'
,(SELECT common_lookup_id
  FROM common_lookup
  WHERE common_lookup_type = 'DVD_WIDE_SCREEN')
,'Shooting Cranes'
,'Story of Devin Lindsay'
,'R'
,SYSDATE - 7
,1
,SYSDATE
,1
,SYSDATE);

-- DVD 2
INSERT 
INTO ITEM
(item_id
,item_barcode
,item_type
,item_title
,item_subtitle
,item_rating
,release_date
,created_by
,creation_date
,last_updated_by
,last_update_date)
VALUES
(item_s1.nextval
,'123456789qwert'
,(SELECT common_lookup_id
  FROM common_lookup
  WHERE common_lookup_type = 'DVD_WIDE_SCREEN')
,'Fell on His Face'
,'Story of Chad Hill'
,'G'
,SYSDATE - 7
,1
,SYSDATE
,1
,SYSDATE);

-- DVD 3
INSERT 
INTO ITEM
(item_id
,item_barcode
,item_type
,item_title
,item_subtitle
,item_rating
,release_date
,created_by
,creation_date
,last_updated_by
,last_update_date)
VALUES
(item_s1.nextval
,'123456789qwert'
,(SELECT common_lookup_id
  FROM common_lookup
  WHERE common_lookup_type = 'DVD_WIDE_SCREEN'
  AND common_lookup_context = 'ITEM')
,'What What...'
,'Story of Christian Shaw'
,'PG-13'
,SYSDATE - 7
,1
,SYSDATE
,1
,SYSDATE);


SELECT   i.item_title
,        SYSDATE AS today
,        i.release_date
FROM     item i
WHERE   (SYSDATE - i.release_date) < 31;

-- c
-- instert 3 new members, Harry, Lilly, and Luna
-- insert into member table
INSERT
INTO MEMBER
(member_id
,member_type
,account_number
,credit_card_number
,credit_card_type
,created_by
,creation_date
,last_updated_by
,last_update_date)
VALUES
(member_s1.nextval
,(SELECT common_lookup_id
  FROM common_lookup
  WHERE common_lookup_context = 'MEMBER'
  AND common_lookup_type = 'GROUP')
,'1234567890'
,'1234567890123456'
,(SELECT common_lookup_id
  FROM common_lookup
  WHERE common_lookup_type = 'MASTER_CARD'
  AND common_lookup_meaning = 'Master Card')
,1
,SYSDATE
,1
,SYSDATE);


-- i could just do a sub query 
CREATE OR REPLACE FUNCTION get_member_id
( pv_account_number VARCHAR2
, pv_card_number    VARCHAR2) RETURN NUMBER
IS 
  lv_return NUMBER;
BEGIN
   SELECT m.member_id
   INTO   lv_return
   FROM   member m
   WHERE  m.account_number = pv_account_number
   AND   m.credit_card_number = pv_card_number;

   RETURN lv_return; 

END;
/

SELECT get_member_id('1234567890','1234567890123456') 
from dual; 
SHOW ERRORS



-- for Harry Potter ---------------------------------------------------
-- contact table

INSERT
INTO CONTACT
(contact_id
,member_id
,contact_type
,first_name
,middle_name
,last_name
,created_by
,creation_date
,last_updated_by
,last_update_date)
VALUES
(contact_s1.nextval
,get_member_id('1234567890','1234567890123456') 
,(SELECT common_lookup_id
  FROM common_lookup 
  WHERE common_lookup_context = 'CONTACT'
  AND common_lookup_type = 'CUSTOMER')
,'Harry'
,''
,'Potter'
,1
,SYSDATE
,1
,SYSDATE);

-- address table
INSERT
INTO ADDRESS
(address_id
,contact_id
,address_type
,city
,state_province
,postal_code
,created_by
,creation_date
,last_updated_by
,last_update_date)
VALUES
(address_s1.nextval
,contact_s1.currval
,(SELECT common_lookup_id
  FROM common_lookup
  WHERE common_lookup_type = 'HOME')
,'Provo'
,'Utah'
,'83440'
,1
,SYSDATE
,1
,SYSDATE);

-- street address tables
INSERT
INTO STREET_ADDRESS
(street_address_id
,address_id
,street_address
,created_by
,creation_date
,last_updated_by
,last_update_date)
VALUES
(street_address_s1.nextval
,address_s1.currval
,'111 West 7 South'
,1
,SYSDATE
,1
,SYSDATE);

-- telephone tables
INSERT
INTO TELEPHONE
(telephone_id
,contact_id
,address_id
,telephone_type
,country_code
,area_code
,telephone_number
,created_by
,creation_date
,last_updated_by
,last_update_date)
VALUES
(telephone_s1.nextval
,contact_s1.currval
,address_s1.currval
,(SELECT common_lookup_id
  FROM common_lookup
  WHERE common_lookup_type = 'HOME')
,'USA'
,'208'
,'709-9462'
,1
,SYSDATE
,1
,SYSDATE);

-- for Ginny Potter ---------------------------------------------------------
-- contact table
INSERT
INTO CONTACT
(contact_id
,member_id
,contact_type
,first_name
,middle_name
,last_name
,created_by
,creation_date
,last_updated_by
,last_update_date)
VALUES
(contact_s1.nextval
,member_s1.currval
,(SELECT common_lookup_id
  FROM common_lookup 
  WHERE common_lookup_context = 'CONTACT'
  AND common_lookup_type = 'CUSTOMER')
,'Ginny'
,''
,'Potter'
,1
,SYSDATE
,1
,SYSDATE);

-- address table
INSERT
INTO ADDRESS
(address_id
,contact_id
,address_type
,city
,state_province
,postal_code
,created_by
,creation_date
,last_updated_by
,last_update_date)
VALUES
(address_s1.nextval
,contact_s1.currval
,(SELECT common_lookup_id
  FROM common_lookup
  WHERE common_lookup_type = 'HOME')
,'Provo'
,'Utah'
,'83440'
,1
,SYSDATE
,1
,SYSDATE);

-- street address tables
INSERT
INTO STREET_ADDRESS
(street_address_id
,address_id
,street_address
,created_by
,creation_date
,last_updated_by
,last_update_date)
VALUES
(street_address_s1.nextval
,address_s1.currval
,'111 West 7 South'
,1
,SYSDATE
,1
,SYSDATE);

-- telephone tables
INSERT
INTO TELEPHONE
(telephone_id
,contact_id
,address_id
,telephone_type
,country_code
,area_code
,telephone_number
,created_by
,creation_date
,last_updated_by
,last_update_date)
VALUES
(telephone_s1.nextval
,contact_s1.currval
,address_s1.currval
,(SELECT common_lookup_id
  FROM common_lookup
  WHERE common_lookup_type = 'HOME')
,'USA'
,'208'
,'709-0297'
,1
,SYSDATE
,1
,SYSDATE);

-- for Lily Luna Potter ------------------------------------------------------
-- contact table
INSERT
INTO CONTACT
(contact_id
,member_id
,contact_type
,first_name
,middle_name
,last_name
,created_by
,creation_date
,last_updated_by
,last_update_date)
VALUES
(contact_s1.nextval
,member_s1.currval
,(SELECT common_lookup_id
  FROM common_lookup 
  WHERE common_lookup_context = 'CONTACT'
  AND common_lookup_type = 'CUSTOMER')
,'Lily'
,'Luna'
,'Potter'
,1
,SYSDATE
,1
,SYSDATE);

-- address table
INSERT
INTO ADDRESS
(address_id
,contact_id
,address_type
,city
,state_province
,postal_code
,created_by
,creation_date
,last_updated_by
,last_update_date)
VALUES
(address_s1.nextval
,contact_s1.currval
,(SELECT common_lookup_id
  FROM common_lookup
  WHERE common_lookup_type = 'HOME')
,'Provo'
,'Utah'
,'83440'
,1
,SYSDATE
,1
,SYSDATE);

-- street address tables
INSERT
INTO STREET_ADDRESS
(street_address_id
,address_id
,street_address
,created_by
,creation_date
,last_updated_by
,last_update_date)
VALUES
(street_address_s1.nextval
,address_s1.currval
,'111 West 7 South'
,1
,SYSDATE
,1
,SYSDATE);

-- telephone tables
INSERT
INTO TELEPHONE
(telephone_id
,contact_id
,address_id
,telephone_type
,country_code
,area_code
,telephone_number
,created_by
,creation_date
,last_updated_by
,last_update_date)
VALUES
(telephone_s1.nextval
,contact_s1.currval
,address_s1.currval
,(SELECT common_lookup_id
  FROM common_lookup
  WHERE common_lookup_type = 'HOME')
,'USA'
,'208'
,'709-0097'
,1
,SYSDATE
,1
,SYSDATE);

COLUMN full_name FORMAT A20
COLUMN city      FORMAT A10
COLUMN state     FORMAT A10
SELECT   c.last_name || ', ' || c.first_name AS full_name
,        a.city
,        a.state_province AS state
FROM     member m INNER JOIN contact c
ON       m.member_id = c.member_id INNER JOIN address a
ON       c.contact_id = a.contact_id INNER JOIN street_address sa
ON       a.address_id = sa.address_id INNER JOIN telephone t
ON       c.contact_id = t.contact_id
WHERE    c.last_name = 'Potter';

-- d -- three new rows need to be inserted into the RENTAL and four new rows into the RENTAL_ITEM tables 
-- Harry Potter Rents
-- rent today, renturn 3 days after rental date
-- customer ID needs to be from Harry since that is who I am selecting
-- ietm_id is not currval, instead, select item_id from item table looking for the item name
INSERT
INTO RENTAL
(rental_id
,customer_id
,check_out_date
,return_date
,created_by
,creation_date
,last_updated_by
,last_update_date)
VALUES
(rental_s1.nextval
,(SELECT contact_id
  FROM contact 
  WHERE first_name = 'Harry'
  AND last_name = 'Potter')
,SYSDATE
,SYSDATE + 1
,1
,SYSDATE
,1
,SYSDATE);

-- Harry's First DVD
INSERT
INTO rental_item
(rental_item_id
,rental_id
,item_id
,created_by
,creation_date
,last_updated_by
,last_update_date
,rental_item_price
,rental_item_type)
VALUES
(rental_item_s1.nextval
,rental_s1.currval
,(SELECT item_id
  FROM item
  WHERE item_title = 'What What...'
  AND item_subtitle = 'Story of Christian Shaw')
,1
,SYSDATE
,1
,SYSDATE
,5
,(SELECT common_lookup_id
  FROM common_lookup
  WHERE common_lookup_context = 'ITEM'
  AND common_lookup_type = 'DVD_WIDE_SCREEN'));

-- Harry's Second DVD
INSERT
INTO rental_item
(rental_item_id
,rental_id
,item_id
,created_by
,creation_date
,last_updated_by
,last_update_date
,rental_item_price
,rental_item_type)
VALUES
(rental_item_s1.nextval
,rental_s1.currval
,(SELECT item_id
  FROM item
  WHERE item_title = 'Shooting Cranes'
  AND item_subtitle = 'Story of Devin Lindsay')
,1
,SYSDATE
,1
,SYSDATE
,5
,(SELECT common_lookup_id
  FROM common_lookup
  WHERE common_lookup_context = 'ITEM'
  AND common_lookup_type = 'DVD_WIDE_SCREEN'));

-- Ginny Potter's DVD rental
INSERT
INTO RENTAL
(rental_id
,customer_id
,check_out_date
,return_date
,created_by
,creation_date
,last_updated_by
,last_update_date)
VALUES
(rental_s1.nextval
,(SELECT contact_id
  FROM contact 
  WHERE first_name = 'Ginny'
  AND last_name = 'Potter')
,SYSDATE
,SYSDATE + 3
,1
,SYSDATE
,1
,SYSDATE);

INSERT
INTO rental_item
(rental_item_id
,rental_id
,item_id
,created_by
,creation_date
,last_updated_by
,last_update_date
,rental_item_price
,rental_item_type)
VALUES
(rental_item_s1.nextval
,rental_s1.currval
,(SELECT item_id
  FROM item
  WHERE item_title = 'Fell on His Face'
  AND item_subtitle = 'Story of Chad Hill')
,1
,SYSDATE
,1
,SYSDATE
,5
,(SELECT common_lookup_id
  FROM common_lookup
  WHERE common_lookup_context = 'ITEM'
  AND common_lookup_type = 'DVD_WIDE_SCREEN'));

-- Lily's 

INSERT
INTO RENTAL
(rental_id
,customer_id
,check_out_date
,return_date
,created_by
,creation_date
,last_updated_by
,last_update_date)
VALUES
(rental_s1.nextval
,(SELECT contact_id
  FROM contact 
  WHERE first_name = 'Lily'
  AND middle_name = 'Luna'
  AND last_name = 'Potter')
,SYSDATE
,SYSDATE + 5
,1
,SYSDATE
,1
,SYSDATE);

INSERT
INTO rental_item
(rental_item_id
,rental_id
,item_id
,created_by
,creation_date
,last_updated_by
,last_update_date
,rental_item_price
,rental_item_type)
VALUES
(rental_item_s1.nextval
,rental_s1.currval
,(SELECT item_id
  FROM item
  WHERE item_title = 'What What...'
  AND item_subtitle = 'Story of Christian Shaw')
,1
,SYSDATE
,1
,SYSDATE
,5
,(SELECT common_lookup_id
  FROM common_lookup
  WHERE common_lookup_context = 'ITEM'
  AND common_lookup_type = 'DVD_WIDE_SCREEN'));


COLUMN full_name   FORMAT A18
COLUMN rental_id   FORMAT 9999
COLUMN rental_days FORMAT A14
COLUMN rentals     FORMAT 9999
COLUMN items       FORMAT 9999
SELECT   c.last_name||', '||c.first_name||' '||c.middle_name AS full_name
,        r.rental_id
,       (r.return_date - r.check_out_date) || '-DAY RENTAL' AS rental_days
,        COUNT(DISTINCT r.rental_id) AS rentals
,        COUNT(ri.rental_item_id) AS items
FROM     rental r INNER JOIN rental_item ri
ON       r.rental_id = ri.rental_id INNER JOIN contact c
ON       r.customer_id = c.contact_id
WHERE   (SYSDATE - r.check_out_date) < 15
AND      c.last_name = 'Potter'
GROUP BY c.last_name||', '||c.first_name||' '||c.middle_name
,        r.rental_id
,       (r.return_date - r.check_out_date) || '-DAY RENTAL'
ORDER BY 2;

-- -------------
-- Step 4
-- -------------
-- shift the contents of one column to another column in the same row.

-- a
DROP INDEX common_lookup_n1;  
DROP INDEX common_lookup_u2;

COLUMN table_name FORMAT A14
COLUMN index_name FORMAT A20
SELECT   table_name
,        index_name
FROM     user_indexes
WHERE    table_name = 'COMMON_LOOKUP';


-- b 
ALTER TABLE common_lookup
   ADD (common_lookup_table    VARCHAR2(30))
   ADD (common_lookup_column   VARCHAR2(30))
   ADD (common_lookup_code     VARCHAR2(30));


SET NULL ''
COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'COMMON_LOOKUP'
ORDER BY 2;

-- c 
-- case statments are more like if then statements
-- if the data for a particular row in the common lookup context column is 
-- equal to MULTIPLE, then change it to address; otherwise, everything else 
-- the data in the context column can just be moved directly to the table column 
UPDATE   common_lookup
SET      common_lookup_table = 
   CASE
      WHEN common_lookup_context = 'MULTIPLE' 
         THEN 'ADDRESS'
      ELSE common_lookup_context
   END; 

-- notice that I put the concatnations there, that is because the directions, even with last one, was the _type 
-- string appended the strings in the common_lookup_columns as they come from the common_lookup_context
UPDATE common_lookup
SET    common_lookup_column =
   CASE
      WHEN (common_lookup_table = 'MEMBER' AND common_lookup_type IN ('INDIVIDUAL','GROUP'))
         THEN common_lookup_context || '_TYPE'
      WHEN (common_lookup_type IN ('VISA_CARD', 'MASTER_CARD', 'DISCOVER_CARD'))
         THEN 'CREDIT_CARD_TYPE'
      WHEN (common_lookup_context = 'MULTIPLE')
         THEN 'ADDRESS_TYPE'
      WHEN (common_lookup_context IN ('MEMBER', 'MULTIPLE'))
         THEN common_lookup_context || '_TYPE'
      ELSE common_lookup_context || '_TYPE'
   END;

SET NULL ''
COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        case
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'COMMON_LOOKUP'
ORDER BY 2;

-- leaving code out of this insert

ALTER TABLE common_lookup
   DROP COLUMN common_lookup_context;

-- common_lookup_code is left out here because it is going to be null anyways 
INSERT
INTO COMMON_LOOKUP
(common_lookup_id
,common_lookup_type 
,common_lookup_meaning
,created_by
,creation_date
,last_updated_by
,last_update_date
,common_lookup_table
,common_lookup_column)
VALUES
(common_lookup_s1.nextval
,'HOME'
,'Home'
,1
,SYSDATE
,1
,SYSDATE
,'TELEPHONE'
,'TELEPHONE_TYPE');


INSERT
INTO COMMON_LOOKUP
(common_lookup_id
,common_lookup_type 
,common_lookup_meaning
,created_by
,creation_date
,last_updated_by
,last_update_date
,common_lookup_table
,common_lookup_column)
VALUES
(common_lookup_s1.nextval
,'WORK'
,'Work'
,1
,SYSDATE
,1
,SYSDATE
,'TELEPHONE'
,'TELEPHONE_TYPE');

ALTER TABLE telephone
   DROP CONSTRAINT fk_telephone_2;

ALTER TABLE telephone 
   ADD CONSTRAINT fk_telephone_2 FOREIGN KEY (telephone_type) REFERENCES common_lookup(common_lookup_id);



-- can the following update statment be done this way?  can they also be done with a case statment?
-- UPDATE t telephone
-- SET t.telephone_type = c.common_lookup_meaning
-- INNER JOIN common_lookup c ON(t.telephone_id = c.common_lookup_id)
-- WHERE common_lookup_column = 'TELEPHONE_TYPE'
-- AND common_lookup_type = 'HOME';


UPDATE telephone
SET telephone_type = 
   (SELECT common_lookup_id
    FROM common_lookup
    WHERE common_lookup_column = 'TELEPHONE_TYPE'
    AND common_lookup_meaning = 'Work');

UPDATE telephone
SET telephone_type = 
   (SELECT common_lookup_id
    FROM common_lookup
    WHERE common_lookup_column = 'TELEPHONE_TYPE'
    AND common_lookup_meaning = 'Home');

-- statement that checks below aready works without the following script
-- UPDATE address
-- SET address_type =
--    (SELECT common_lookup_id
--     FROM common_lookup
--     WHERE common_lookup_column = 'ADDRESS_TYPE'
--     AND common_lookup_meaning = 'Home');


COLUMN common_lookup_table  FORMAT A20
COLUMN common_lookup_column FORMAT A20
COLUMN common_lookup_type   FORMAT A20
SELECT   common_lookup_table
,        common_lookup_column
,        common_lookup_type
FROM     common_lookup
ORDER BY 1, 2, 3;


COLUMN common_lookup_table  FORMAT A14 HEADING "Common|Lookup Table"
COLUMN common_lookup_column FORMAT A14 HEADING "Common|Lookup Column"
COLUMN common_lookup_type   FORMAT A8  HEADING "Common|Lookup|Type"
COLUMN count_dependent      FORMAT 999 HEADING "Count of|Foreign|Keys"
COLUMN count_lookup         FORMAT 999 HEADING "Count of|Primary|Keys"
SELECT   cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type
,        COUNT(a.address_id) AS count_dependent
,        COUNT(cl.common_lookup_table) AS count_lookup
FROM     address a RIGHT JOIN common_lookup cl
ON       a.address_type = cl.common_lookup_id
WHERE    cl.common_lookup_table = 'ADDRESS'
AND      cl.common_lookup_column = 'ADDRESS_TYPE'
AND      cl.common_lookup_type IN ('HOME','WORK')
GROUP BY cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type
UNION
SELECT   cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type
,        COUNT(t.telephone_id) AS count_dependent
,        COUNT(cl.common_lookup_table) AS count_lookup
FROM     telephone t RIGHT JOIN common_lookup cl
ON       t.telephone_type = cl.common_lookup_id
WHERE    cl.common_lookup_table = 'TELEPHONE'
AND      cl.common_lookup_column = 'TELEPHONE_TYPE'
AND      cl.common_lookup_type IN ('HOME','WORK')
GROUP BY cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type;

-- d
-- already dropped the common_lookup_context column before I inserted into the common_lookup table in the step above
-- otherwise I would have has a constraint violation as I tried to add nothing into that row, we didnt need it for the 
-- subsequent later steps.  

ALTER TABLE common_lookup
  MODIFY common_lookup_table CONSTRAINT nn_common_lookup_8 NOT NULL;

ALTER TABLE common_lookup  
  MODIFY common_lookup_column CONSTRAINT nn_common_lookup_9 NOT NULL;

SET NULL ''
COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'COMMON_LOOKUP'
ORDER BY 2;

-- DROP INDEX common_lookup_n1;

-- ALTER TABLE common_lookup
--    DROP UNIQUE INDEX common_lookup_u2;

CREATE UNIQUE INDEX common_lookup_U2
   ON common_lookup(common_lookup_table, common_lookup_column, common_lookup_type);

COLUMN table_name FORMAT A14
COLUMN index_name FORMAT A20
SELECT   table_name
,        index_name
FROM     user_indexes
WHERE    table_name = 'COMMON_LOOKUP';