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
       ,[state]
FROM salespersons sp
INNER JOIN [address] ad
ON sp.salesperson_id = ad.salesperson_id

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

