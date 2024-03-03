-- Resource: https://www.w3resource.com/sql-exercises/challenges-1/index.php

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

# Solution
USE 'temp';
DROP function IF EXISTS 'getNthHighestSaleAmt';
DELIMITER $$
USE 'temp'$$
# -------------------------------
CREATE FUNCTION 'getNthHighestSaleAmt' (N INT) RETURNS int(11)
BEGIN
  SET N = N-1;
  RETURN (
        SELECT DISTINCT sale_amt FROM salemast
        ORDER BY sale_amt DESC
        LIMIT 1 OFFSET N
    );
END$$
DELIMITER ;
# To Execute the function:
SELECT getNthHighestSaleAmt(3);

-- Output:
-- Couldn't test due to errors

-- 4. From the following table, write a SQL query to find the marks, 
-- which appear at least thrice one after another without interruption. Return the number.

-- Input:

-- table: logs

-- student_id|marks|
-- ----------|-----|
--        101|   83|
--        102|   79|
--        103|   83|
--        104|   83|
--        105|   83|
--        106|   79|
--        107|   79|
--        108|   83|
-- Output:

-- ConsecutiveNums|
-- ---------------|
--              83|

-- Reference: https://www.w3resource.com/sql-exercises/challenges-1/sql-challenges-1-exercise-4.php

-- Solution 1:

SELECT  DISTINCT L1.marks AS ConsecutiveNums
FROM
(logs L1
	JOIN logs L2
	ON L1.marks = L2.marks AND L1.student_id = L2.student_id-1
)
JOIN logs L3
ON L1.marks = L3.marks AND L2.student_id = L3.student_id-1;

-- Solution 2:

SELECT  DISTINCT L1.marks AS ConsecutiveMarks
FROM logs AS L1, logs AS L2, logs AS L3
WHERE L1.student_id = L2.student_id +1
AND L1.student_id = L3.student_id +2
AND L1.marks = L2.marks
AND L1.marks = L3.marks;

-- 5. From the following table, write a SQL query to find all the duplicate emails (no upper case letters) of the employees. Return email id.
-- Input:

-- table: employees

-- employee_id|employee_name|email_id     |
-- -----------|-------------|-------------|
--         101|Liam Alton   |li.al@abc.com|
--         102|Josh Day     |jo.da@abc.com|
--         103|Sean Mann    |se.ma@abc.com|
--         104|Evan Blake   |ev.bl@abc.com|
--         105|Toby Scott   |jo.da@abc.com|
-- Output:

-- email_id     |
-- -------------|
-- jo.da@abc.com|

SELECT  email_id
FROM
(
	SELECT  email_id
	       ,COUNT(email_id) AS nuOfAppearence
	FROM employees
	GROUP BY  email_id
) AS countEmail
WHERE nuOfAppearence > 1;

-- 6. From the following tables, write a SQL query to find those customers who never ordered anything. 
-- Return customer name.

-- Input:

-- table: customers

-- customer_id|customer_name|
-- -----------|-------------|
--         101|Liam         |
--         102|Josh         |
--         103|Sean         |
--         104|Evan         |
--         105|Toby         |

-- table: orders

-- order_id|customer_id|order_date|order_amount|
-- --------|-----------|----------|------------|
--      401|        103|2012-03-08|        4500|
--      402|        101|2012-09-15|        3650|
--      403|        102|2012-06-27|        4800|

-- Output:

-- Customers|
-- ---------|
-- Evan     |
-- Toby     |

-- Solution 1

SELECT cust.customer_name
FROM customers cust
LEFT JOIN orders
ON cust.customer_id = orders.customer_id
WHERE orders.order_id IS NULL

-- Solution 2

SELECT  customer_name AS customers
FROM customers
WHERE customer_id NOT IN ( SELECT customer_id FROM orders );

-- Solution 3

SELECT  customer_name AS Customers
FROM customers
WHERE 0 = (
SELECT  COUNT(*)
FROM orders
WHERE customers.customer_id = orders.customer_id );

-- 7. From the following table, write a SQL query to remove all the duplicate emails of 
-- employees keeping the unique email with the lowest employee id. 
-- Return employee id and unique emails.

-- Input:

-- table: employees

-- employee_id|employee_name|email_id     |
-- -----------|-------------|-------------|
--         101|Liam Alton   |li.al@abc.com|
--         102|Josh Day     |jo.da@abc.com|
--         103|Sean Mann    |se.ma@abc.com|
--         104|Evan Blake   |ev.bl@abc.com|
--         105|Toby Scott   |jo.da@abc.com|

-- Output:

-- employee_id|employee_name|email_id     |
-- -----------|-------------|-------------|
--         101|Liam Alton   |li.al@abc.com|
--         102|Josh Day     |jo.da@abc.com|
--         103|Sean Mann    |se.ma@abc.com|
--         104|Evan Blake   |ev.bl@abc.com|

DELETE e1
FROM employees e1, employees e2
WHERE e1.email_id = e2.email_id
AND e1.employee_id > e2.employee_id;

-- Changing comparison would change the outcome

DELETE e1
FROM employees e1, employees e2
WHERE e1.email_id = e2.email_id
AND e1.employee_id < e2.employee_id;

-- Output:

-- +-------------+---------------+---------------+
-- | employee_id | employee_name | email_id      |
-- +-------------+---------------+---------------+
-- |         101 | Liam Alton    | li.al@abc.com |
-- |         103 | Sean Mann     | se.ma@abc.com |
-- |         104 | Evan Blake    | ev.bl@abc.com |
-- |         105 | Toby Scott    | jo.da@abc.com |
-- +-------------+---------------+---------------+

-- 8. From the following table, write a SQL query to find all dates' city ID with 
-- higher pollution compared to its previous dates (yesterday). Return city ID, date and pollution.

-- Input:

-- table: so2_pollution

-- city_id|date      |so2_amt|
-- -------|----------|-------|
--     701|2015-10-15|      5|
--     702|2015-10-16|      7|
--     703|2015-10-17|      9|
--     704|2018-10-18|     15|
--     705|2015-10-19|     14|

-- Output:

-- City ID|
-- -------|
--     702|
--     703|

-- Solution 1

SELECT  sp1.city_id
FROM so2_pollution sp1, so2_pollution sp2
WHERE sp1.date = sp2.date+1
AND sp1.so2_amt > sp2.so2_amt

-- Solution 2

SELECT so2_pollution.city_id AS 'City ID'
FROM so2_pollution
        JOIN
so2_pollution p ON DATEDIFF(so2_pollution.date, p.date) = 1
        AND so2_pollution.so2_amt > p.so2_amt;
        
-- Solution 3

SELECT p2.city_id FROM so2_pollution p1, so2_pollution p2
WHERE p2.date = adddate(p1.date,1)
AND p1.so2_amt < p2.so2_amt

-- 9. A salesperson is a person whose job is to sell products or services.
-- From the following tables, write a SQL query to find the top 10 salesperson that have made highest sale. Return their names and total sale amount.
-- Input:

-- Table: sales

-- TRANSACTION_ID|SALESMAN_ID|SALE_AMOUNT|
-- --------------|-----------|-----------|
--            501|         18|    5200.00|
--            502|         50|    5566.00|
--            503|         38|    8400.00|
-- ...
--            599|         24|   16745.00|
--            600|         12|   14900.00|

-- Table: salesman

-- SALESMAN_ID|SALESMAN_NAME        |
-- -----------|---------------------|
--          11|Jonathan Goodwin     |
--          12|Adam Hughes          |
--          13|Mark Davenport       |
-- ....
--          59|Cleveland Hart       |
--          60|Marion Gregory       |
-- Output:

-- salesman_name        |total_sale|
-- ---------------------|----------|
-- Dan McKee            |  70530.00|
-- Cleveland Klein      |  61020.00|
-- Elliot Clapham       |  60519.00|
-- Evan Blake           |  53108.00|
-- Ollie Wheatley       |  52640.00|
-- Frederick Kelsey     |  52270.00|
-- Sean Mann            |  52053.00|
-- Callum Bing          |  48645.00|
-- Kian Wordsworth      |  45250.00|
-- Bradley Wright       |  41961.00|

SELECT  salesman_name, sum(SALE_AMOUNT)
FROM sales
INNER JOIN salesman sm
WHERE sales.SALESMAN_ID = sm.SALESMAN_ID
group by 
order by sales.SALE_AMOUNT desc
limit 10

-- Output:

-- +----------------+-------------+-------------+-------------+-----------------------+
-- | TRANSACTION_ID | SALESMAN_ID | SALE_AMOUNT | SALESMAN_ID | SALESMAN_NAME         |
-- +----------------+-------------+-------------+-------------+-----------------------+
-- |            547 |          36 |    20000.00 |          36 | Lewis Moss            |
-- |            544 |          36 |    19998.00 |          36 | Lewis Moss            |
-- |            585 |          53 |    19990.00 |          53 | Dan McKee             |
-- |            594 |          35 |    19990.00 |          35 | Elliot Clapham        |
-- |            538 |          25 |    19900.00 |          25 | Harri Wilberforce     |
-- |            548 |          20 |    19800.00 |          20 | Rhys Emsworth         |
-- |            595 |          42 |    19741.00 |          42 | Finlay Dalton         |
-- |            597 |          57 |    19625.00 |          57 | Cleveland Klein       |
-- |            554 |          19 |    19600.00 |          19 | Evan Blake            |
-- |            567 |          44 |    19550.00 |          44 | Ollie Wheatley        |
-- +----------------+-------------+-------------+-------------+-----------------------+

-- Doesn't work as after join the data gets denormalized

SELECT salesman_name, SUM(sale_amount) as total_sale
FROM salesman a JOIN sales b ON a.salesman_id = b.salesman_id
GROUP BY salesman_name 
ORDER BY total_sale DESC
LIMIT 10;

-- Output:

-- +-----------------------+------------+
-- | salesman_name         | total_sale |
-- +-----------------------+------------+
-- | Dan McKee             |   70530.00 |
-- | Cleveland Klein       |   61020.00 |
-- | Elliot Clapham        |   60519.00 |
-- | Evan Blake            |   53108.00 |
-- | Ollie Wheatley        |   52640.00 |
-- | Frederick Kelsey      |   52270.00 |
-- | Sean Mann             |   52053.00 |
-- | Callum Bing           |   48645.00 |
-- | Kian Wordsworth       |   45250.00 |
-- | Bradley Wright        |   41961.00 |
-- +-----------------------+------------+

SELECT  name
       ,total_sale
FROM
(
	SELECT  u.salesman_id                                           AS id
	       ,u.salesman_name                                         AS name
	       ,coalesce(SUM(sale_amount),0)                            AS total_sale
	       ,rank() over(order by coalesce(SUM(sale_amount),0) DESC) AS sale_rank
	FROM salesman u
	LEFT JOIN sales r
	ON u.salesman_id = r.salesman_id
	GROUP BY  u.salesman_id
	         ,u.salesman_name
) x
WHERE sale_rank <= 10;

-- 10. An active customer is simply someone who has bought company's product once 
-- before and has returned to make another purchase within 10 days.
-- From the following table, write a SQL query to identify the active customers. 
-- Show the list of customer IDs of active customers.

-- Input:

-- Table: orders

-- ORDER_ID|CUSTOMER_ID|ITEM_DESC|ORDER_DATE|
-- --------|-----------|---------|----------|
--      101|       2109|juice    |2020-03-03|
--      102|       2139|chocolate|2019-03-18|
--      103|       2120|juice    |2019-03-18|
-- ...
--      199|       2130|juice    |2019-03-16|
--      200|       2117|cake     |2021-03-10|

-- Output:

-- customer_id|
-- -----------|
--        2103|
--        2110|
--        2111|
--        2112|
--        2129|
--        2130|

-- Solution 1

SELECT  DISTINCT a.customer_id
FROM orders a, orders b
WHERE (a.customer_id = b.customer_id)
AND (a.order_id != b.order_id)
AND (b.order_date - a.order_date) BETWEEN 0 AND 10
ORDER BY customer_id;

-- Solution 2

select distinct(a.customer_id) from orders a  inner join orders b on
a.customer_id = b.customer_id and 
a.order_id <> b.order_id and  
b.order_date between a.order_date and a.order_date+10

