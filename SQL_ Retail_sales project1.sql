-- Retail Sales Performance Analytics Using MySQL
create database sql_project1;
use sql_project1;

create table retail_sales( 
   transactions_id	INT,
   sale_date DATE,
   sale_time TIME,
   customer_id	INT,
   gender VARCHAR(10),
   age	INT,
   category VARCHAR(25),	
   quantity INT,
   price_per_unit	FLOAT,
   cogs FLOAT,
   total_sale FLOAT);

Select * from retail_sales;
select count(*) from retail_sales;

-- Data cleaning 
-- total rows
Select * from retail_sales;
select count(*) from retail_sales;

-- check for missing rows
select * from retail_sales 
where quantity=0 
or price_per_unit =0 
or cogs =0 
or total_sale= 0;

-- delete rows with zero
set sql_safe_updates=0;

delete from retail_sales
where quantity=0 
or price_per_unit =0
or cogs =0 
or total_sale= 0;
 
SET SQL_SAFE_UPDATES = 1;

-- Data Exploration
-- How many total transactions were recorded?
select count(*) as total_transactions from retail_sales;

-- How many unique customers made purchases?
select count(distinct customer_id) as total_no_of_customers from retail_sales;

-- How many unique categories are available?
select count(distinct category)  from retail_sales;

-- what is the count of gender distribution?
select gender,count(*) from retail_sales
group by gender;

-- Data Analysis & Business questions
-- Q1) Retrive all columns for transactions made on 2022-12-12.

select * from retail_sales 
where sale_date = '2022-12-12';

-- Q2) Identify all clothing category transactions where customers purchased more than 1 times during nov 2022.

select * from retail_sales
where  category= 'clothing'
and sale_date >= '2022-11-01'
and sale_date <  '2022-12-01'
AND customer_id in(	
select customer_id from retail_sales
where  category= 'clothing'
and sale_date >= '2022-11-01'
and sale_date <  '2022-12-01'
group by 1
having count(*)>=2);

-- Q3) Calculate the total revenue for each category

select category, 
sum(total_sale) as total_revenue 
from retail_sales
group by category
order by total_revenue DESC;

-- Q4) Calculate avg age of customers who purchased items from the "Beauty" category.

select round(avg(age),2) as avg_age
from retail_sales
where category= 'Beauty';

-- Q5) Find all transactions where total_sale is greater than 1000.

select * from retail_sales
where total_sale > 1000;

-- Q6) Which day of the week generated the highest revenue

select dayname(sale_date) as day_of_week,
sum(total_sale) as Highest_revenue
from retail_sales
group by dayname(sale_date)
order by highest_revenue desc
limit 1;

-- Q7) Which customers made purchases in multiple product categories.

Select customer_id,
count(distinct category)  as categories_purchased
from retail_sales
group by customer_id
having count(distinct category) >1
order by categories_purchased desc;


-- Q8) Find the total number of transactions made by each gender in each category.

select category,
gender, count(transactions_id) as Transactions
from retail_sales 
group by category, gender 
ORDER by category;

-- Q9) Calculate the average sale for each month. Find out best selling month in each year.
select * from retail_sales;

select Year,Month,Avg_sale from (
select 
year(sale_date) as Year,
month(sale_date) as Month,
round(avg(total_sale),2) as avg_sale,
rank()
over(partition by year(sale_date) 
order by avg(total_sale) desc) as sales_rank
from retail_sales
group by 1,2) as T1
where sales_rank= 1;

 
-- Q10) Find the top 5 customers based on highest total sales

select customer_id, sum(total_sale) as Highest_sales
from retail_sales
group by customer_id
order by highest_sales desc
limit 5;


-- Q11) Create each shift and number of orders ( Example Morning <=12, Afternoon between 12 & 17, Evening >17)


select shift, count(transactions_id) as number_of_orders from
(select *,
CASE 
    When hour(sale_time) <12  then 'Morning'
    When hour(sale_time) between 12 and 17 then 'Afternoon'
    Else 'Evening'
End as Shift
from retail_sales) as T1
group by shift
order by number_of_orders desc ;