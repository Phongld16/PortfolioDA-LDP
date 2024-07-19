use PizzaDB
select * from pizza_sales;

--total revenue
select sum(total_price) as total_revenue from pizza_sales;

--average order value
select sum(total_price)/count(distinct order_id) as avg_order_value from pizza_sales;

--total pizza sold
select sum(quantity) as total_pizza_sold from pizza_sales;

--total orders
select count(distinct order_id) as total_order from pizza_sales;

--average pizzas per order
select	cast(sum(quantity) as decimal(10,2))
		/cast(count(distinct order_id) as decimal(10,2)) as avg_pizza_per_order 
from pizza_sales;

--daily trend for total orders
select	datename(dw, order_date) as daily,
		count(distinct order_id) as total_order
from pizza_sales
group by datename(dw, order_date);

--month trend for total orders 
select	month(order_date) as month,
		count(distinct order_id) as total_order
from pizza_sales
group by month(order_date)
order by month(order_date);

--Percentage of sales by pizza category
select	pizza_category,
		cast(sum(total_price)/(select sum(total_price) from pizza_sales)*100 as decimal(10,2)) as percentage_sales
from pizza_sales
group by pizza_category;

--Percentage of sales by pizza size
select	pizza_size,
		cast(sum(total_price)/(select sum(total_price) from pizza_sales)*100 as decimal(10,2)) as percentage_sales
from pizza_sales
group by pizza_size
order by percentage_sales;

--total pizza sold by pizza category
select	pizza_category,
		sum(quantity) as total_pizza_sold
from pizza_sales
group by pizza_category

--top 5 best sellers by revenue, total quantity and total orders
select	TOP 5 pizza_name,
		sum(total_price) as revenue
from pizza_sales
group by pizza_name
order by revenue desc;

select	TOP 5 pizza_name,
		sum(quantity) as total_quantity
from pizza_sales
group by pizza_name
order by total_quantity desc;

select	TOP 5 pizza_name,
		count(distinct order_id) as total_order
		from pizza_sales
group by pizza_name
order by total_order desc;
--bottom 5 best sellers by revenue, total quantity and total orders
select	TOP 5 pizza_name,
		sum(total_price) as revenue
from pizza_sales
group by pizza_name
order by revenue;
select	TOP 5 pizza_name,
		sum(quantity) as total_quantity
from pizza_sales
group by pizza_name
order by total_quantity;

select	TOP 5 pizza_name,
		count(distinct order_id) as total_order
		from pizza_sales
group by pizza_name
order by total_order;