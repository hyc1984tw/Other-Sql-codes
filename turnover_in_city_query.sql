With T1 AS (
SELECT the_transaction_id, tdt_num_line, ctm_customer_id, tdt_date_event, but_num_business_unit, but_name_business_unit, the_to_type, f_qty_item, f_to_tax_in
FROM `mldata-8nkm.cdp2.taiwan_cdp_transaction_detail_2019`
WHERE tdt_date_event > "2019-09-30"
UNION ALL
SELECT the_transaction_id, tdt_num_line, ctm_customer_id, tdt_date_event, but_num_business_unit, but_name_business_unit, the_to_type, f_qty_item, f_to_tax_in
FROM `mldata-8nkm.cdp2.taiwan_cdp_transaction_detail_current`
WHERE tdt_date_event < "2020-10-01" and the_to_type = 'offline'
),
T2 AS (
SELECT loyalty_card_num, member_city_all, member_district_all
FROM `mldata-8nkm.zipcode_ken.tw_member_ml_zipcode`
WHERE loyalty_card_num is not null ),
T3 AS (
SELECT the_transaction_id, tdt_num_line, ctm_customer_id, tdt_date_event, but_num_business_unit, but_name_business_unit, the_to_type, f_qty_item, f_to_tax_in, member_city_all as zipcode_city,
CASE
WHEN but_num_business_unit = 871 THEN '屏東縣'
WHEN but_num_business_unit = 928 THEN '新北市'
WHEN but_num_business_unit = 666 THEN '台中市'
WHEN but_num_business_unit = 1681 THEN '新竹縣'
WHEN but_num_business_unit = 926 THEN '高雄市'
WHEN but_num_business_unit = 988 THEN '台北市'
WHEN but_num_business_unit = 1222 THEN '桃園市'
WHEN but_num_business_unit = 1292 THEN '台中市'
WHEN but_num_business_unit = 1633 THEN '嘉義市'
WHEN but_num_business_unit = 1766 THEN '雲林市'
WHEN but_num_business_unit = 1223 THEN '台南市'
WHEN but_num_business_unit = 1229 THEN '桃園市'
WHEN but_num_business_unit = 1639 THEN '台北市'
WHEN but_num_business_unit = 1762 THEN '高雄市'
WHEN but_num_business_unit = 1722 THEN '新北市'
ELSE null 
END AS store_city
From T1
LEFT JOIN T2
ON T1.ctm_customer_id = T2.loyalty_card_num),
T4 AS (
SELECT ctm_customer_id, ec_city_prediction as ec_city
from `mldata-8nkm.tw_geo.ec_pickup_customer_geocity`),
T5 AS (SELECT the_transaction_id, tdt_num_line, T3.ctm_customer_id, tdt_date_event, but_num_business_unit, but_name_business_unit, the_to_type, f_qty_item, f_to_tax_in, zipcode_city, store_city, ec_city
From T3
LEFT JOIN T4
ON T3.ctm_customer_id = T4.ctm_customer_id),
T6 AS (
SELECT the_transaction_id,  ctm_customer_id, tdt_date_event,  but_name_business_unit as store, the_to_type, f_to_tax_in, zipcode_city, store_city, ec_city,
CASE 
WHEN the_to_type = 'offline' THEN store_city
WHEN the_to_type = 'online' and ec_city is not null THEN ec_city
WHEN the_to_type = 'online' and ec_city is null THEN zipcode_city
ELSE null
END AS TO_city
FROM T5)
SELECT TO_city, SUM(f_to_tax_in)
FROM T6
GROUP BY TO_city


