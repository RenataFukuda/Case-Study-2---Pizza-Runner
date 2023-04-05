# Case Study #2 - Pizza Runner
## 8 Week SQL Challenge
If you want to try it yourself, you can find the case [here](https://8weeksqlchallenge.com/case-study-2/).

<img src="https://8weeksqlchallenge.com/images/case-study-designs/2.png" alt="Image" width="200" height="208">

## Pizza Metrics

````SQL
USE pizza_runner;
````

### 1. How many pizzas were ordered?

````SQL
SELECT
	COUNT(*) as total_pizzas
FROM customer_orders;
````

#### Answer:
| total_pizzas |
| ------------ |
| 14           | 

### 2. How many unique customer orders were made?

````SQL
SELECT
	customer_id,
	COUNT(DISTINCT pizza_id, COALESCE(exclusions, '0'), COALESCE(extras, '0')) as unique_order
FROM customer_orders
GROUP BY customer_id;
````

#### Answer:
| customer_id | unique_order | 
| ----------- | ------------ | 
| 101         | 2            |
| 102         | 2            |
| 103         | 3            |
| 104         | 3            |
| 105         | 1            | 

### 3. How many successful orders were delivered by each runner?

````SQL
SELECT
	runner_id,
    COUNT(order_id) as succesful_delivery
FROM runner_orders
WHERE cancellation is null
GROUP BY runner_id;
````

#### Answer:
| runner_id | succesful_delivery | 
| --------- | ------------------ | 
| 1         | 4                  |
| 2         | 3                  |
| 3         | 1                  |

### 4. How many of each type of pizza was delivered?

````SQL
SELECT
	pizza_id,
    COUNT(pizza_id) as qty
FROM customer_orders
JOIN runner_orders ON customer_orders.order_id = runner_orders.order_id
WHERE cancellation is null
GROUP BY pizza_id;
````

#### Answer:
| pizza_id | qty | 
| -------- | --- | 
| 1        | 9   |
| 2        | 3   |

### 5. How many Vegetarian and Meatlovers were ordered by each customer?

````SQL
SELECT
	customer_id,
    pizza_name,
	COUNT(customer_orders.pizza_id) as qty
FROM customer_orders
JOIN pizza_names ON customer_orders.pizza_id = pizza_names.pizza_id
GROUP BY customer_id, customer_orders.pizza_id
ORDER BY customer_id;
````

#### Answer:
| customer_id | pizza_name | qty | 
| ----------- | ---------- | --- | 
| 101         | Meatlovers | 2   |
| 101         | Vegetarian | 1   |
| 102         | Meatlovers | 2   |
| 102         | Vegetarian | 1   |
| 103         | Meatlovers | 3   |
| 103         | Vegetarian | 1   |
| 104         | Meatlovers | 3   |
| 105         | Vegetarian | 1   |

### 6. What was the maximum number of pizzas delivered in a single order?

````SQL
SELECT
	COUNT(*) AS pizza_qty
FROM customer_orders
JOIN runner_orders ON customer_orders.order_id = runner_orders.order_id
WHERE cancellation is null
GROUP BY customer_orders.order_id
ORDER BY pizza_qty DESC
LIMIT 1;
````

#### Answer:
| pizza_qty | 
| --------- |
| 3         |

### 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

````SQL
SELECT
	customer_id,
    IF(exclusions IS null AND extras IS null, 'N', 'Y') AS changes,
    COUNT(*) AS qty
FROM customer_orders
JOIN runner_orders ON customer_orders.order_id = runner_orders.order_id
WHERE cancellation is null
GROUP BY customer_id, changes
ORDER BY customer_id;
````

#### Answer:
| customer_id | changes | qty | 
| ----------- | ------- | --- | 
| 101         | N       | 2   |
| 102         | N       | 3   |
| 103         | Y       | 3   |
| 104         | N       | 1   |
| 104         | Y       | 2   |
| 105         | Y       | 1   |

### 8. How many pizzas were delivered that had both exclusions and extras?

````SQL
SELECT
    COUNT(*)
FROM customer_orders
JOIN runner_orders ON customer_orders.order_id = runner_orders.order_id
WHERE exclusions IS NOT null AND extras IS NOT null AND cancellation IS null;
````

#### Answer:
| COUNT(*) |
| -------- |
| 1        |

### 9. What was the total volume of pizzas ordered for each hour of the day?

````SQL
SELECT
	HOUR(order_time) as h,
	COUNT(*) AS pizza_qty
FROM customer_orders
GROUP BY h
ORDER BY h;
````

#### Answer:
| h | pizza_qty |
| - | --------- |
|11 | 1         |
|13 | 3         |
|18 | 3         |
|19 | 1         |
|21 | 3         |
|23 | 3         |

### 10. What was the volume of orders for each day of the week?

````SQL
SELECT
	DATE_FORMAT(order_time, '%W') as wd,
	COUNT(*) AS pizza_qty
FROM customer_orders
GROUP BY wd;
````

#### Answer:
| wd        | pizza_qty |
| --------- | --------- |
| Wednesday | 5         |
| Thursday  | 3         |
| Saturday  | 5         |
| Friday    | 1         |

## Runner and Customer Experience
````sql
USE pizza_runner;
````
### 1.

````SQL

````

#### Answer:

### 2.

````SQL

````

#### Answer:

### 3.

````SQL

````

#### Answer:

### 4.

````SQL

````

#### Answer:

### 5.

````SQL

````

#### Answer:

### 6.

````SQL

````

#### Answer:

### 7.

````SQL

````

#### Answer:
