Create or replace table `mldata-8nkm.tw_geo.ec_pickup_delivery_all_dashbaord` AS 

Select address_type, delivery_method, address_city_district, store_name, store_add, count(transaction_id) as ticket
from `mldata-8nkm.tw_geo.ec_pickup_delivery_all`
Where address_type in ('Pickup', 'Delivery') and address_city_district is not null
group by address_type, delivery_method, address_city_district, store_name, store_add
order by address_type, ticket desc;

INSERT `mldata-8nkm.tw_geo.ec_pickup_delivery_all_dashbaord` (delivery_method, address_city_district, ticket)
Values ('新店店', '新北市新店區中興路三段1號', 9999),
 ('內湖店', '台北市內湖區新湖一路128巷38號', 9999),
 ('桂林店', '台北市萬華區桂林路1號', 9999),
('中和店', '新北市中和區中山路二段 228號', 9999),
('八德店', '桃園市八德區介壽路一段728號', 9999),
('中壢店', '桃園市中壢區中華路一段450號', 9999),
('新竹店', '新竹市東區慈雲路126號', 9999),
('北屯店', '台中市北屯區中清路二段1075號', 9999),
('南屯店', '台中市南屯區大墩南路379號', 9999),
('雲林店', '雲林縣斗六市雲林路二段297號', 9999),
('嘉義店', '嘉義市西區博愛路二段461號', 9999),
('仁德店', '台南市仁德區中山路 799號', 9999),
('楠梓店', '高雄市楠梓區土庫一路60號', 9999),
('鳳山店', '高雄市鳳山區文化路59號', 9999),
('屏東店', '屏東市自由路550號', 9999)


