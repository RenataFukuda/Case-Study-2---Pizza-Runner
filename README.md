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
### 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

````SQL
SELECT
	WEEK(registration_date,1)+1 AS week,
    COUNT(*) as signs
FROM runners
GROUP BY week;
````

#### Answer:
| week | signs |
|------|-------|
| 1    | 2     |
| 2    | 1     |
| 3    | 1     |

### 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

````SQL
SELECT DISTINCT
    runner_id,
	ROUND(AVG(TIME_TO_SEC(TIMEDIFF(pickup_time, order_time)))/60) AS avg_time
FROM runner_orders
JOIN customer_orders ON customer_orders.order_id = runner_orders.order_id
GROUP BY runner_id;
````

#### Answer:
| runner_id | avg_time |
|-----------|----------|
| 1         | 16       |
| 2         | 24       |
| 3         | 10       |

### 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?

````SQL
SELECT
	customer_orders.order_id,
    COUNT(customer_orders.order_id) AS n_pizzas,
    ROUND(TIME_TO_SEC(TIMEDIFF(pickup_time, order_time))/60) AS prep_time,
    ROUND(TIME_TO_SEC(TIMEDIFF(pickup_time, order_time))/60)/COUNT(customer_orders.order_id) AS time_per_pizza
FROM runner_orders
JOIN customer_orders ON customer_orders.order_id = runner_orders.order_id
GROUP BY customer_orders.order_id;
````

#### Answer:
Yes, since it is possible to notice that the relation between the preparation time and the number of pizzas in the order is constant. In other words, the preparation time increases in the same proportion as the number of pizzas in the order

| order_id | n_pizzas | prep_time | time_per_pizza |
|----------|----------|-----------|----------------|
| 1        | 1        | 11        | 11             |
| 2        | 1        | 10        | 10             |
| 3        | 2        | 21        | 10,5           |
| 4        | 3        | 29        | 10             |
| 5        | 1        | 10        | 10             |
| 6        | 1        | null      | null           |
| 7        | 1        | 10        | 10             |
| 8        | 1        | 20        | 20             |
| 9        | 1        | null      | null           |
| 10       | 2        | 16        | 8              |

### 4. What was the average distance travelled for each customer?

````SQL
WITH order_distance AS
(SELECT DISTINCT
	customer_orders.order_id,
    customer_id,
    distance
FROM runner_orders
LEFT JOIN customer_orders ON customer_orders.order_id = runner_orders.order_id)

SELECT
	customer_id,
    AVG(distance)
FROM order_distance
GROUP BY customer_id;
````

#### Answer:
| customer_id | AVG(distance) |
|-------------|---------------|
| 101         | 20            |
| 102         | 18.4          |
| 103         | 23.4          |
| 104         | 10            |
| 105         | 25            |

### 5. What was the difference between the longest and shortest delivery times for all orders?

````SQL
SELECT
	MAX(duration) AS longest,
    MIN(duration) AS shortest,
    MAX(duration)-MIN(duration) AS difference
FROM runner_orders;
````

#### Answer:
| longest | shortest | difference | 
| ------- | -------- | ---------- | 
| 40      | 10       | 30         |

### 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?

````SQL
WITH tbspeed AS
(SELECT
	order_id,
    runner_id,
	distance,
    duration,
	(distance/duration)*60 AS speed
FROM runner_orders)
SELECT
	runner_id,
    order_id,
    ROUND(speed) AS speed_km_min,
    ROUND(AVG(speed) OVER(PARTITION BY runner_id)) as runner_speed_avg,
    ROUND(AVG(speed) OVER()) as speed_avg
FROM tbspeed
WHERE speed IS NOT NULL;
````

#### Answer:
Runner 2 is the fastest and the only one with an average speed greater than the total average.

| runner_id | order_id | speed_km_min | runner_speed_avg | speed_avg |
|-----------|----------|--------------|------------------|-----------|
| 1         |  1       |  38          | 46               | 51        |
| 1         |  2       |  44          | 46               | 51        |
| 1         |  3       |  40          | 46               | 51        |
| 1         |  10      |  60          | 46               | 51        |
| 2         |  4       |  35          | 63               | 51        |
| 2         |  7       |  60          | 63               | 51        |
| 2         |  8       |  94          | 63               | 51        |
| 3         |  5       |  40          | 40               | 51        |

### 7. What is the successful delivery percentage for each runner?

````SQL
WITH delivery AS
(SELECT
	runner_id,
	SUM(cancellation IS NULL) OVER(PARTITION BY runner_id) AS completed_delivery,
	COUNT(order_id) OVER(PARTITION BY runner_id) AS total_delivery
FROM runner_orders)
SELECT
	runner_id,
    CONCAT(ROUND(completed_delivery/total_delivery * 100), '%') AS success_rate
FROM delivery
GROUP BY runner_id;
````

#### Answer:
| runner_id | success_rate |
|-----------|--------------|
| 1         | 100%         |
| 2         | 75%          |
| 3         | 50%          |
