
use [Pizza DB];

select *
from [dbo].[pizza_sales];

--1)Total_Revenue
select sum(total_price) as Total_Revenue
from [dbo].[pizza_sales];

--2)AVerage order value
select sum(Total_Price)/COUNT(distinct order_id) as Avg_Order_Value
from [dbo].[pizza_sales]

--3)Total Pizza sold
select sum(quantity) as Total_Pizza_sold
from [dbo].[pizza_sales]

--4)Total Pizza order
select count(distinct order_id) as Total_order
from pizza_sales

--5)Average Pizza per order
select cast(cast(sum(quantity) as decimal(10,2)) / cast(count(distinct order_id) as decimal(10,2)) as decimal(10,2)) as AVg_pizza_per_pizza
from pizza_sales

--6)Daily Trend for Total_orders
--Thia will help us idetify any patterns or fluctuations in order volumes on a daily basis
select DATENAME(DW,order_date) as Day, count(Distinct order_id) as Total_order
from [dbo].[pizza_sales]
group by DATENAME(DW,order_date)

--7)MONTH Trend for Total_orders
select DATENAME(MONTH,order_date) as Day, count(Distinct order_id) as Total_order
from [dbo].[pizza_sales]
group by DATENAME(MONTH,order_date)

--8) % of Sales by pizza category

select pizza_category,cast(sum(total_price) as decimal(10,2)) as Total_Revenue,
       cast(sum(total_price) * 100 / (select sum(Total_price) from [dbo].[pizza_sales]) as decimal(10,2)) as Percent_sales
from [dbo].[pizza_sales]
group by pizza_category
order by Percent_sales desc

--9) % of sales by pizza size
select pizza_size,CAST(sum(total_price) as decimal(10,2)) as Total_Revenue,
	   CAST(sum(total_price) * 100 / (select SUM(total_price) from pizza_sales) as decimal(10,2)) as Percent_sales
from pizza_sales
group by pizza_size
order by Percent_sales desc

--10)Total pizzas sold by pizza category
select pizza_category,SUM(quantity) as Total_pizza_sold
from [dbo].[pizza_sales]
group by pizza_category
order by Total_pizza_sold desc


select pizza_category,SUM(quantity) as Total_pizza_sold
from [dbo].[pizza_sales]
where MONTH(order_date) = 2
group by pizza_category
order by Total_pizza_sold desc

--11)Top 5 pizzas by Revenue
select top(5) pizza_name,sum(total_price) as Total_revenue
from pizza_sales
group by pizza_name
order by Total_revenue desc

--12)Bottom 5 pizzas by revenue
select top(5) pizza_name,sum(total_price) as Total_revenue
from pizza_sales
group by pizza_name
order by Total_revenue asc


--13)Top 5 pizzas by quantity
select top(5) pizza_name,sum(quantity) as Total_quantity
from pizza_sales
group by pizza_name
order by Total_quantity desc


--14)Bottom 5 pizzas by quantity
select top(5) pizza_name,sum(quantity) as Total_qunatity
from pizza_sales
group by pizza_name
order by Total_qunatity asc

--15)Top 5 pizzas by Total_orders
select top(5) pizza_name,count(distinct order_id) as Total_orders
from pizza_sales
group by pizza_name
order by Total_orders desc

--16)Bottom 5 pizzas by Total_orders
select top(5) pizza_name,count(distinct order_id) as Total_orders
from pizza_sales
group by pizza_name
order by Total_orders asc