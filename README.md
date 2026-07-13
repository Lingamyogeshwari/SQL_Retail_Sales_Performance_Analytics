# Retail Sales Performance Analytics using MySQL

## Project Overview

**Project Title**:  Retail Sales Performance Analytics using MySQL
**Level**: Beginner to Intermediate
**Database**: `sql_project1`

This project analyses retail sales transaction data using MySQL to find out valuable business insights. It demonstrates the complete SQL workflow, including data cleaning, data exploration, and business analysis through real-world SQL queries. The objective of this project is to transform raw sales data into meaningful insights that support business decision-making.

## Objectives

1. **Database Setup**: Design the database schema, create table and import the retail sales transaction data into MySQL for analysis.
2. **Data Cleaning**: Identify and remove any records with missing or null values to ensure data quality.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use MySQL queries to answer specific business questions and generate insights from the retail sales data.


## Dataset Information

The dataset contains the following columns: 

- Transaction ID 
- Sale Date 
- Sale Time 
- Customer ID 
- Gender 
-  Age 
- Category 
- Quantity 
- Price Per Unit 
- COGS 
- Total Sale 


## Project Structure


### 1. Database Setup

- Created a “sql_project1” database to import retail sales transaction data into MySQL.
- Created the `retail_sales`  table with appropriate data types.
- Imported the retail sales dataset into MySQL.
- Verified that all records were successfully imported before starting the analysis.
```sql
create database sql_project1;
use sql_project1;

create table retail_sales( 
   transactions_id	INT ,
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
```

### 2️. Data Cleaning

Performed data quality checks to ensure reliable analysis.


- Checked total number of records after importing data.
- Identified invalid records containing 0 values. 
- Removed invalid records before performing analysis.
```sql
-- Total no of records
select count(*) from retail_sales;

--  checked for invalid records 
select * from retail_sales 
where quantity=0 
or price_per_unit =0 
or cogs =0 
or total_sale= 0;

-- Removed invalid records
delete from retail_sales
where quantity=0 
or price_per_unit =0
or cogs =0 
or total_sale= 0;
```


### 3. Data Exploration
Before starting the business analysis, I explored the dataset to understand its overall structure.

- Calculated the total number of transactions.
- Counted the number of unique customers.
- Identified the different product categories available.
- Counted the distribution of customers by gender.
```sql
 How many total transactions were recorded?
select count(*) as total_transactions from retail_sales;

-- How many unique customers made purchases?
select count(distinct customer_id) as total_no_of_customers from retail_sales;

-- How many unique categories are available?
select count(distinct category)  from retail_sales;

-- what is the count of gender distribution?
select gender, count(*) from retail_sales
group by gender;
```


### 4. Data Analysis & Business questions

The following SQL queries were developed to answer specific business questions:

-- Q1) Retrieve all columns for transactions made on 2022-12-12.
```sql
select * from retail_sales 
where sale_date = '2022-12-12';
```

-- Q2) Identify all clothing category transactions where customers purchased more than once during November 2022.

```sql
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
```

-- Q3) Calculate the total revenue for each category.

```sql
select category, 
sum(total_sale) as total_revenue 
from retail_sales
group by category
order by total_revenue DESC;
```

-- Q4) Calculate the average age of customers who purchased items from the "Beauty" category.

```sql
select round(avg(age),2) as avg_age
from retail_sales
where category= 'Beauty';
```

-- Q5) Find all transactions where total_sale is greater than 1000.

```sql
select * from retail_sales
where total_sale > 1000;
```

-- Q6) Which day of the week generated the highest revenue.

```sql
select dayname(sale_date) as day_of_week,
sum(total_sale) as Highest_revenue
from retail_sales
group by dayname(sale_date)
order by highest_revenue desc
limit 1;
```

-- Q7) Which customers made purchases in multiple product categories.

```sql
Select customer_id,
count(distinct category)  as categories_purchased
from retail_sales
group by customer_id
having count(distinct category) >1
order by categories_purchased desc;
```


-- Q8) Find the total number of transactions made by each gender in each category.

```sql
select category,
gender, count(transactions_id) as Transactions
from retail_sales 
group by category, gender 
ORDER by category;
```

-- Q9) Calculate the average sale for each month. Find out best-selling month in each year.

```sql
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
```

 
-- Q10) Find the top 5 customers based on highest total sales.

```sql
select customer_id, sum(total_sale) as Highest_sales
from retail_sales
group by customer_id
order by highest_sales desc
limit 5;
```



-- Q11) Create each shift and number of orders ( Example Morning <=12, Afternoon between 12 & 17, Evening >17).


```sql
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
```



## Key Insights

- Revenue performance was analysed across different product categories to evaluate revenue contribution.
- Customer purchasing behaviour was explored based on age, gender, and product categories.
- Sales trends were analysed to identify the highest revenue-generating day of the week and the best-performing month in each year.
- High-value transactions and top customers were identified based on total sales.
- Order distribution across Morning, Afternoon, and Evening shifts provided insights into customer shopping behaviour.

## Conclusion

This project demonstrates how SQL can be used to clean, explore, and analyse retail sales data to answer business questions and support data-driven decision-making. It reflects practical SQL skills commonly required for Data Analyst and Business Analyst roles.

## How to Use

1. Clone or download this repository to your local machine. 
2. Open MySQL Workbench and create the database using the SQL script.
 3. Import the retail sales dataset into the `retail_sales` table. 
4. Run the SQL queries to explore the data and generate business insights. 
5. Modify the queries to perform additional analysis or answer your own business questions.



## About Me

I created this project as part of my Data Analytics learning journey to strengthen my SQL skills through hands-on business case studies. I am continuously building projects in SQL, Excel, Power BI, Tableau, and Python to develop practical analytical skills and create a strong data analytics portfolio.


Thank you for taking the time to explore this project.

