Create or replace table `mldata-8nkm.tw_geo.ec_pickup_delivery_all` as

with x as (
select transaction_id, date_time_transaction, address_type, address_city, address_postal_code, address_country, delivery_method, delivery_courier, con_store_name, t2.store_name, t2.store_add, t3.store_name as store_name_1, t3.store_address as store_add_1
from `mldata-8nkm.cdp3.taiwan_cdp_convenient_store` as t1
left join `mldata-8nkm.tw_geo.all_711_store` as t2
on t1.delivery_courier = t2.store_num
left join `mldata-8nkm.tw_geo.all_fami_hilife_store_by_20201014` as t3
on t1.delivery_courier = t3.store_number),
Y as(
Select transaction_id, date_time_transaction, address_type, address_city, address_postal_code, address_country, delivery_method, delivery_courier, 
case
When address_city = '7-11' then '7-11'
When address_city = 'cvs' then con_store_name
else null END AS con_store_name,
case 
when store_name is not null then store_name
when store_name_1 is not null then store_name_1 
else null END AS store_name,
case 
when store_add is not null then store_add
when store_add_1 is not null then store_add_1 
else null END AS store_add
from x),
Z as (
Select distinct city_district, zip_code
from `mldata-8nkm.tw_geo.108_tw_zipcode_population`),
XX as(
select transaction_id, date_time_transaction, address_type, address_city, address_postal_code, city_district, address_country, delivery_method, delivery_courier, con_store_name, store_name, store_add, substr(store_add, 1, 6) as store_city_dist
from y
left join z
on y.address_postal_code = z.zip_code)

SELECT transaction_id, date_time_transaction, address_type, 
CASE
WHEN store_city_dist like '台中市東區_' THEN '台中市東區'
WHEN store_city_dist like '台中市南區_' THEN '台中市南區'
WHEN store_city_dist like '台中市西區_' THEN '台中市西區'
WHEN store_city_dist like '台中市北區_' THEN '台中市北區'
WHEN store_city_dist like '台中市中區_' THEN '台中市中區'
WHEN store_city_dist like '台南市東區_' THEN '台南市東區'
WHEN store_city_dist like '台南市南區_' THEN '台南市南區'
WHEN store_city_dist like '台南市北區_' THEN '台南市北區'
WHEN store_city_dist like '新竹市東區_' THEN '新竹市東區'
WHEN store_city_dist like '新竹市北區_' THEN '新竹市北區'
WHEN store_city_dist like '嘉義市東區_' THEN '嘉義市東區'
WHEN store_city_dist like '嘉義市西區_' THEN '嘉義市西區'
WHEN store_city_dist = '高雄市那瑪夏' THEN '高雄市那瑪夏區'
WHEN store_city_dist = '嘉義縣阿里山' THEN '嘉義縣阿里山鄉'
WHEN store_city_dist = '屏東縣三地門' THEN '屏東縣三地門鄉'
WHEN store_city_dist = '臺東縣太麻里' THEN '臺東縣太麻里鄉'
WHEN store_city_dist is null THEN city_district
else store_city_dist END AS address_city_district,
address_postal_code, delivery_method, con_store_name, delivery_courier as store_number, store_name, store_add
FROM XX
