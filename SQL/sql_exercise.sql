-- 1. From the following tables, write a SQL query to find the information on each salesperson of ABC Company. Return name, city, country and state of each salesperson.
-- Input:

-- table: salespersons

-- salesperson_id|first_name|last_name|
-- --------------|----------|---------|
--              1|Green     |Wright   |
--              2|Jones     |Collins  |
--              3|Bryant    |Davis    |
-- table: address

-- address_id|salesperson_id|city       |state     |country|
-- ----------|--------------|-----------|----------|-------|
--          1|             2|Los Angeles|California|USA    |
--          2|             3|Denver     |Colorado  |USA    |
--          3|             4|Atlanta    |Georgia   |USA    |

-- Output:

-- first_name|last_name|city       |state     |
-- ----------|---------|-----------|----------|
-- Jones     |Collins  |Los Angeles|California|
-- Bryant    |Davis    |Denver     |Colorado  |
-- Green     |Wright   |           |          |

SELECT  first_name
       ,last_name
       ,city
       ,state
FROM salespersons sp
INNER JOIN address ad
ON sp.salesperson_id = ad.salesperson_id

-- Output:

-- +------------+-----------+-------------+------------+
-- | first_name | last_name | city        | state      |
-- +------------+-----------+-------------+------------+
-- | Jones      | Collins   | Los Angeles | California |
-- | Bryant     | Davis     | Denver      | Colorado   |
-- +------------+-----------+-------------+------------+

-- The above doesn't work as the inner join removes the 
-- salesperson which does not have the salesperson_id
-- in the address table

SELECT  first_name
       ,last_name
       ,city
       ,state
FROM salespersons
LEFT JOIN address
ON salespersons.salesperson_id = address.salesperson_id;

-- Output:

-- +------------+-----------+-------------+------------+
-- | first_name | last_name | city        | state      |
-- +------------+-----------+-------------+------------+
-- | Green      | Wright    | NULL        | NULL       |
-- | Jones      | Collins   | Los Angeles | California |
-- | Bryant     | Davis     | Denver      | Colorado   |
-- +------------+-----------+-------------+------------+


-- 2. From the following table, write a SQL query to find the third highest sale. Return sale amount.
-- Input:

-- table: salemast

-- sale_id|employee_id|sale_date |sale_amt|
-- -------|-----------|----------|--------|
--       1|       1000|2012-03-08|    4500|
--       2|       1001|2012-03-09|    5500|
--       3|       1003|2012-04-10|    3500|
--       3|       1003|2012-04-10|    2500|
-- Output:

-- SecondHighestSale|
-- -----------------|
--              4500|

SELECT MIN(sale_amt) as ThirdHighestSale
FROM salemast
GROUP BY sale_amt
ORDER BY sale_amt DESC
LIMIT 3

-- Output:

-- +------------------+
-- | ThirdHighestSale |
-- +------------------+
-- |             5500 |
-- |             4500 |
-- |             3500 |
-- +------------------+

-- The above doesn't work as I am applying aggregate on 
-- a column that already has a group by

SELECT  DISTINCT sale_amt AS ThirdHighestSale
FROM salemast
ORDER BY sale_amt DESC
LIMIT 1 OFFSET 2;

-- Output:

-- +------------------+
-- | ThirdHighestSale |
-- +------------------+
-- |             3500 |
-- +------------------+

-- 3. From the following table, write a SQL query to find the Nth highest sale. Return sale amount.
-- Input:

-- table: salemast

-- sale_id|employee_id|sale_date |sale_amt|
-- -------|-----------|----------|--------|
--       1|       1000|2012-03-08|    4500|
--       2|       1001|2012-03-09|    5500|
--       3|       1003|2012-04-10|    3500|
-- Output:

-- getNthHighestSaleAmt(3)|
-- -----------------------|
--                    3500|

