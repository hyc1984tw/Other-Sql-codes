/* Help water team retrive SUP customer, transaction, sport product data in Store 666 in 2019 & 2020.
Process flow
Step 1: Join transaction table with customer table 
Step 2: Join transaction+cstomer table with product table
Step 3: Update zipcode info into the transaction+customer+product table
*/

------T1_transaction_table-----------------

With T1 AS (          
SELECT the_transaction_id, ctm_customer_id -- loyalty_card_num
, tdt_date_event, tdt_year, but_num_business_unit as store_number , CAST(sku_idr_sku as NUMERIC) as sku_idr_sku
FROM `mldata-8nkm.cdp2.taiwan_cdp_transaction_detail_current`
WHERE but_num_business_unit = 666 and 
tdt_year in ("2019", "2020") and 
ctm_customer_id != ''),

------T2_product_table-----------------

T2 AS (
SELECT dpt_num_department , sdp_num_sub_department, sku_idr_sku , web_label
FROM `mldata-8nkm.cdp2.taiwan_cdp_sport_product`
WHERE dpt_num_department = 417),

------T3_product_table-----------------

T3 AS (
SELECT loyalty_card_num , code_postal as zip_code ,
IF ((gender_id = 1), 'M', 'F') as gender, -- if clause to calculate gender
IF((EXTRACT(DAYOFYEAR FROM CURRENT_DATE()) < EXTRACT(DAYOFYEAR FROM birthdate)), -- if clause to calculate age
DATE_DIFF(current_date(), date(birthdate), year) -1, 
DATE_DIFF(current_date(), date(birthdate), year)) as age
FROM `mldata-8nkm.cdp2.taiwan_cdp_all_customer`),

-------Join T1 & T3 to T4 ---------

T4 AS (
SELECT *
FROM T3
JOIN T1
ON T1.ctm_customer_id = T3.loyalty_card_num),

-------Join T4 & T2 to T5---------
T5 AS (
SELECT the_transaction_id, tdt_date_event, store_number, loyalty_card_num, gender, zip_code, age, T2.dpt_num_department as dpt_num_department, T2.sdp_num_sub_department as sdp_num_sub_department
FROM T4
JOIN T2
ON T4.sku_idr_sku = T2.sku_idr_sku),

------T6 Zipcode_district Info ---------
T6 AS(
SELECT CAST(zip_code as STRING) as zip_code, zip_code_CN_name as district
FROM `mldata-8nkm.cdp3.taiwan_zipcode_all`),

--SELECT count(zip_code)
--FROM T6

-------Join T5 & T6 to T7 ----------
T7 AS (
--SELECT count(distinct the_transaction_id)
SELECT the_transaction_id as ticket_id, tdt_date_event as ticket_date, store_number as store, loyalty_card_num as card_number, gender, age, district, dpt_num_department as departement_number, sdp_num_sub_department as sub_department_number
FROM T5
LEFT JOIN T6
ON T5.zip_code = T6.zip_code)

select distinct *
FROM T7
