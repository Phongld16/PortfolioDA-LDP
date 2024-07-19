USE BikeStores
--tong doanh thu
Select sum(list_price * quantity) as revenue
from sales.order_items;
--so luong san pham ban ra
select sum(quantity) as total_unit
from sales.order_items;
--do luong don dat hang
select count(distinct order_id) as total_order
from sales.order_items;
--so ngay co don dat hang
Select count(distinct order_date) as total_orderdate
from sales.orders;
--doanh thu theo nam
select	year(so.order_date) as year_num,
		sum(soi.list_price * soi.quantity) as revenue
from sales.orders so
join sales.order_items soi On so.order_id = soi.order_id
group by year(so.order_date)
order by year_num;
--doanh thu theo thang
select	month(so.order_date) as month_num,
		sum(soi.list_price * soi.quantity) as revenue
from sales.orders so
join sales.order_items soi On so.order_id = soi.order_id
group by month(so.order_date)
order by month_num;
--doanh thu theo cua hang
select	se.store_name,
		sum(soi.list_price * soi.quantity) as revenue
from sales.order_items soi
Join sales.orders so On so.order_id = soi.order_id
Join sales.stores se On se.store_id = so.store_id
group by se.store_name
order by se.store_name;
--doanh thu theo thuong hieu
select	pb.brand_name,
		sum(soi.list_price * soi.quantity) as revenue
from sales.order_items soi
Join production.products pp On pp.product_id = soi.product_id
Join production.brands pb On pb.brand_id = pp.brand_id
group by pb.brand_name
order by pb.brand_name;
--doanh thu theo danh muc san pham
select	pc.category_name,
		sum(soi.list_price * soi.quantity) as revenue
from sales.order_items soi
Join production.products pp On pp.product_id = soi.product_id
Join production.categories pc On pc.category_id = pp.category_id
group by pc.category_name
order by pc.category_name;
--doanh thu theo bang
select	sc.state,
		sum(soi.list_price * soi.quantity) as revenue
from sales.order_items soi
Join sales.orders so On so.order_id = soi.order_id
Join sales.customers sc On sc.customer_id = so.customer_id
group by sc.state
order by sc.state;
--top 10 khach hang than thiet
select	Top 10 
		concat(sc.first_name,' ',sc.last_name) as customer_name,
		sum(soi.list_price * soi.quantity) as revenue
from sales.order_items soi
Join sales.orders so On so.order_id = soi.order_id
Join sales.customers sc On sc.customer_id = so.customer_id
group by concat(sc.first_name,' ',sc.last_name)
order by revenue desc;
--top 5 nhan vien suat xac
select	Top 5 
		concat(ss.first_name,' ',ss.last_name) as employee_name,
		sum(soi.list_price * soi.quantity) as revenue
from sales.order_items soi
Join sales.orders so On so.order_id = soi.order_id
Join sales.staffs ss On ss.staff_id = so.staff_id
group by concat(ss.first_name,' ',ss.last_name)
order by revenue desc;