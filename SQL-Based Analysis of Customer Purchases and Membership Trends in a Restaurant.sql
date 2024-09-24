create database restuarant;
use restuarant;
CREATE TABLE sales (customer_id VARCHAR(25),order_date DATE,product_id INT);

INSERT INTO sales VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 

CREATE TABLE menu (
  product_id INTEGER,
  product_name VARCHAR(25),
  price INTEGER
);

INSERT INTO menu VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  

CREATE TABLE members (
  customer_id VARCHAR(1),
  join_date DATE
);

INSERT INTO members VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');
  
----------------------------------------------------------------------------------------------------------------------------------------------
  -- 1. What is the total amount each customer spent at the restaurant?
 select s.customer_id,sum(m.price) as total_sales
 from sales s inner join menu m
 on s.product_id=m.product_id
 group by s.customer_id;
 
 -------------------------------------------------------------------------------------------------------------------------------------------
-- 2. How many days has each customer visited the restaurant?
select customer_id,count(distinct order_date) as days_customer_visited
from sales
group by customer_id;

---------------------------------------------------------------------------------------------------------------------------------------------
-- 3. What was the first item from the menu purchased by each customer?
with first_item as (
select *,
dense_rank()over(partition by customer_id order by order_date) as rnk
from sales )
select c.customer_id,m.product_name
from first_item c inner join menu m
on c.product_id=m.product_id
where rnk=1;

---------------------------------------------------------------------------------------------------------------------------------------------
-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
select m.product_name, count(s.product_id) as time_purchased
from menu m inner join sales s
on m.product_id=s.product_id
group by m.product_name
order by time_purchased desc
limit 1;

--------------------------------------------------------------------------------------------------------------------------------------------
-- 5. Which item was the most popular for each customer?
with popular_item as(
select customer_id,product_id,count(product_id) as count,
dense_rank() over( partition by customer_id order by count(product_id) desc ) as rnk
from sales
group by customer_id,product_id)
select s.customer_id,m.product_name,s.count
from popular_item s inner join menu m
on s.product_id=m.product_id
where rnk=1
order by s.customer_id asc,s.count desc
;


------------------------------------------------------------------------------------------------------------------------------------------
-- 6. Which item was purchased first by the customer after they became a member?
with first_purchased as(
select s.customer_id,s.order_date,m.product_name,
dense_rank() over(partition by s.customer_id order by s.order_date ) as rnk
from sales s inner join menu m
on s.product_id=m.product_id
 inner join members mem
on s.customer_id=mem.customer_id
where s.order_date>=mem.join_date )
select customer_id,product_name,order_date
from first_purchased
where rnk=1;


--------------------------------------------------------------------------------------------------------------------------------------------
-- 7. Which item was purchased just before the customer became a member?
with first_purchased as(
select s.customer_id,s.order_date,m.product_name,
dense_rank() over(partition by s.customer_id order by s.order_date ) as rnk
from sales s inner join menu m
on s.product_id=m.product_id
 inner join members mem
on s.customer_id=mem.customer_id
where s.order_date>=mem.join_date )
select customer_id,product_name,order_date
from first_purchased
where rnk=1;


---------------------------------------------------------------------------------------------------------------------------------------------
-- 8. What is the total items and amount spent for each member before they became a member?
with first_purchased as(
select s.customer_id,s.order_date,m.product_name,
dense_rank() over(partition by s.customer_id order by s.order_date ) as rnk
from sales s inner join menu m
on s.product_id=m.product_id
 inner join members mem
on s.customer_id=mem.customer_id
where s.order_date<mem.join_date )
select customer_id,product_name,order_date
from first_purchased
where rnk=1;

-------------------------------------------------------------------------------------------------------------------------------------------
-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
with points as(
select *,
case when product_id=1 then price*20 else price*10 end as points 
from menu)
select s.customer_id,sum(p.points) as points 
from sales s join points p
on s.product_id=p.product_id
group by s.customer_id;


-------------------------------------------------------------------------------------------------------------------------------------------
-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi 
-- how many points do customer A and B have at the end of January?
WITH dates AS (SELECT *, 
DATE_ADD(join_date, INTERVAL 6 DAY) AS valid_date,
LAST_DAY('2021-01-31') AS last_date
FROM members
) 
SELECT 
S.customer_id, 
SUM(CASE 
WHEN M.product_ID = 1 THEN M.price * 20  
WHEN S.order_date BETWEEN D.join_date AND D.valid_date THEN M.price * 20 
ELSE M.price * 10 
END
    ) AS Points 
FROM dates D INNER JOIN Sales S ON D.customer_id = S.customer_id 
INNER JOIN Menu M ON M.product_id = S.product_id
WHERE S.order_date < D.last_date 
GROUP BY S.customer_id
order by customer_id asc;
