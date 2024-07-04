# Basic SQL Questions

# 1.Retrieve all columns from the table
select * 
from employee_data ;

select * 
from insurance_data;

select * 
from vendor_data;

# 2.Get all records from the INSURANCE table where the CLAIM_AMOUNT is greater than $80000.

select * 
from insurance_data 
where CLAIM_AMOUNT >= 80000;

# 3.List all AGENTS ordered by DATE_OF_JOINING in descending order.

select AGENT_NAME,DATE_OF_JOINING 
from employee_data 
order by DATE_OF_JOINING desc;

select AGENT_NAME,
extract(year from DATE_OF_JOINING) as years  ,
extract(month from DATE_OF_JOINING) as Months
from employee_data 
order by DATE_OF_JOINING desc;

# 4.Find the total PREMIUM_AMOUNT collected from all transactions.

select sum(PREMIUM_AMOUNT) as total_premimum
from insurance_data 
group by PREMIUM_AMOUNT ;

# 5.Count the number of customers in each CITY order them in descending .

select city, count(city) as count
from insurance_data 
group by CITY 
order by count desc ;

# Intermediate SQL Questions

# 1.Find the names of agents along with the number of transactions they handle

select E.AGENT_NAME , count(*) as number_of_transaction 
from   employee_data as E  
join   insurance_data as I on E.AGENT_ID = I.AGENT_ID
group  by E.AGENT_NAME 
order by number_of_transaction desc;

# 2.List the CUSTOMER_NAME and CLAIM_AMOUNT of customers who have made the highest claim in each state.

select CUSTOMER_NAME,CLAIM_AMOUNT
from insurance_data
where claim_amount= (SELECT MAX(CLAIM_AMOUNT) 
                      FROM insurance_data AS T2 
                      WHERE T2.STATE =STATE);

# 3. Retrieve all VENDORS who have an address in CITY 'Union City' and STATE 'CA'

select * 
from vendor_data 
where STATE= "CA"  and CITY = 'Union City';

# 4.Get a list of CUSTOMER_NAME where the names start with the letter 'A'.

select CUSTOMER_NAME
from insurance_data 
where CUSTOMER_NAME like "A%";

# 5.Find all TRANSACTIONS that occurred in the last 30 days

select * 
FROM insurance_data 
WHERE TXN_DATE_TIME >= ("2021-06-30" - INTERVAL 30 DAY);

# Advanced SQL Questions

# 1.For each CITY, calculate the average CLAIM_AMOUNT and rank the cities based on this average.

select CITY ,
avg(CLAIM_AMOUNT) AS Avg_CLAIM_AMOUNT,
rank() over (order by avg(CLAIM_AMOUNT) desc ) as Rank_
FROM insurance_data
group by CITY ;

# 2.Using a CTE, find the CUSTOMER_NAME who has been with the company for more than 10 years.

with long_term_customer as (
select CUSTOMER_NAME,TENURE,CUSTOMER_EDUCATION_LEVEL
from insurance_data 
where TENURE >10
)
select CUSTOMER_NAME,TENURE
from long_term_customer;

# 3.Retrieve the VENDOR_NAME and POLICY_NUMBER for all transactions handled by vendors, including the vendors' address details.

select v.VENDOR_NAME,i.POLICY_NUMBER,v.ADDRESS_LINE1, V.CITY, V.STATE
from vendor_data as v 
inner join insurance_data as i
on v.VENDOR_ID = i.VENDOR_ID ;

# 4.List CUSTOMER_NAME and their CLAIM_AMOUNT where the claim amount is greater than the average claim amount for all customers.

select CUSTOMER_NAME,CLAIM_AMOUNT
from insurance_data
where CLAIM_AMOUNT >
(select avg(CLAIM_AMOUNT) as avg_claim_amount
from insurance_data );

# 5.Transform the TRANSACTIONS data to show the total CLAIM_AMOUNT by INSURANCE_TYPE for each STATE.

SELECT STATE,
SUM(CASE WHEN INSURANCE_TYPE = 'Life' THEN CLAIM_AMOUNT ELSE 0 END) AS Life,
SUM(CASE WHEN INSURANCE_TYPE = 'Health' THEN CLAIM_AMOUNT ELSE 0 END) AS Health,
SUM(CASE WHEN INSURANCE_TYPE = 'Property' THEN CLAIM_AMOUNT ELSE 0 END) AS Property,
SUM(CASE WHEN INSURANCE_TYPE = 'Travel' THEN CLAIM_AMOUNT ELSE 0 END) AS Travel,
sum(CASE WHEN INSURANCE_TYPE ='Life' THEN CLAIM_AMOUNT ELSE 0 END ) AS Life
FROM 
insurance_data
GROUP BY 
STATE;
