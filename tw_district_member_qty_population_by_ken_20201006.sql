create or replace table `mldata-8nkm.tw_geo.tw_district_member_qty_population` AS

With T1 AS (
Select city, district, city_district, zip_code, total as male_population 
from `mldata-8nkm.tw_geo.108_tw_zipcode_population`
where gender = 'M'),

T2 AS (
Select city, district, city_district, zip_code, total as female_population 
from `mldata-8nkm.tw_geo.108_tw_zipcode_population`
where gender = 'F'),

T3 AS (
Select t1.city as city, t1.district as district, t1.city_district as city_district, t1.zip_code as zipcode, male_population, female_population, (male_population + female_population) as total_population
from T1
JOIN T2
on t1.city_district = t2.city_district),

T4 AS (
select count(distinct loyalty_card_num) as member_qty, concat(member_city_all, member_district_all) as city_district
from `mldata-8nkm.zipcode_ken.tw_member_ml_zipcode`
group by city_district)

select t4.city_district, city, district, zipcode, male_population, female_population, total_population, member_qty, member_qty/total_population as pc_member_over_population
from T4
LEFT JOIN T3
ON T4.city_district = T3.city_district
where male_population is not null;



INSERT INTO `mldata-8nkm.tw_geo.tw_district_member_qty_population` (city_district, district, total_population, member_qty)
VALUES 
('新北市新店區中興路三段1號1樓', '新店店', 200, 19999),
('台北市內湖區新湖一路128巷38號', '內湖店', 200, 19999),
('台北市萬華區桂林路1號', '桂林店', 200, 19999),
('新北市中和區中山路二段228號', '中和店', 200, 19999),
('桃園市八德區介壽路一段728號', '八德店', 200, 19999),
('桃園市中壢區中華路一段450號', '中壢店', 200, 19999),
('新竹市東區慈雲路126號', '新竹店', 200, 19999),
('台中市北屯區中清路二段1075號', '北屯店', 200, 19999),
('雲林縣斗六市雲林路二段297號', '雲林店', 200, 19999),
('嘉義市西區博愛路二段461號', '嘉義店', 200, 19999),
('台南市仁德區中山路799號', '仁德店', 200, 19999),
('高雄市楠梓區土庫一路60號', '楠梓店', 200, 19999),
('高雄市鳳山區文化路59號', '鳳山店', 200, 19999),
('屏東市自由路550號', '屏東店', 200, 19999),
('台中市南屯區大墩南路379號', '南屯店', 200, 19999);
