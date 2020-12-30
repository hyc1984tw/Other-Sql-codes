CREATE or Replace table `mldata-8nkm.cdp3.taiwan_cdp_member_district_population1` AS

/* Create view for member district location and district population informaiton.
Step 1: Join customer table and update zipcode info.
*/

------T1_customer_table-----------------

With T1 AS (          
SELECT code_postal as zip_code, count(distinct loyalty_card_num) as member_qty
FROM `mldata-8nkm.cdp2.taiwan_cdp_all_customer`
WHERE loyalty_card_num != '' 
GROUP BY zip_code),


------T2 Zipcode_district_Info ---------
T2 AS(
SELECT CAST(zip_code as STRING) as zip_code, zip_code_CN_name as district, population_201809 as district_population
FROM `mldata-8nkm.cdp3.taiwan_zipcode_all`),


--Join T1 & T2 to update zipcode info in customer table ---------------------------

T3 AS(
SELECT T1.zip_code, T2.district, T1.member_qty, T2.district_population
FROM T1
LEFT JOIN T2
ON T1.zip_code = T2.zip_code
)

-----Join T3 & T2 to update district population info in table
Select *
FROM T3



