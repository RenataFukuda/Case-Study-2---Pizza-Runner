USE pizza_runner;

-- 1. How many pizzas were ordered?
SELECT
	COUNT(*) as total_pizzas
FROM customer_orders;

-- 2. How many unique customer orders were made?
SELECT
	customer_id,
	COUNT(DISTINCT pizza_id, COALESCE(exclusions, '0'), COALESCE(extras, '0')) as unique_order
FROM customer_orders
GROUP BY customer_id;

-- 3. How many successful orders were delivered by each runner?
SELECT
	runner_id,
    COUNT(order_id) as succesful_delivery
FROM runner_orders
WHERE cancellation is null
GROUP BY runner_id;

-- 4. How many of each type of pizza was delivered?
SELECT
	pizza_id,
    COUNT(pizza_id) as qty
FROM customer_orders
JOIN runner_orders ON customer_orders.order_id = runner_orders.order_id
WHERE cancellation is null
GROUP BY pizza_id;

-- 5. How many Vegetarian and Meatlovers were ordered by each customer?
SELECT
	customer_id,
    pizza_name,
	COUNT(customer_orders.pizza_id) as qty
FROM customer_orders
JOIN pizza_names ON customer_orders.pizza_id = pizza_names.pizza_id
GROUP BY customer_id, customer_orders.pizza_id
ORDER BY customer_id;

-- 6. What was the maximum number of pizzas delivered in a single order?
SELECT
	COUNT(*) AS pizza_qty
FROM customer_orders
JOIN runner_orders ON customer_orders.order_id = runner_orders.order_id
WHERE cancellation is null
GROUP BY customer_orders.order_id
ORDER BY pizza_qty DESC
LIMIT 1;

-- 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SELECT
	customer_id,
    IF(exclusions IS null AND extras IS null, 'N', 'Y') AS changes,
    COUNT(*) AS qty
FROM customer_orders
JOIN runner_orders ON customer_orders.order_id = runner_orders.order_id
WHERE cancellation is null
GROUP BY customer_id, changes
ORDER BY customer_id;

-- 8. How many pizzas were delivered that had both exclusions and extras?
SELECT
    COUNT(*)
FROM customer_orders
JOIN runner_orders ON customer_orders.order_id = runner_orders.order_id
WHERE exclusions IS NOT null AND extras IS NOT null AND cancellation IS null;

-- 9. What was the total volume of pizzas ordered for each hour of the day?
SELECT
	HOUR(order_time) as h,
	COUNT(*) AS pizza_qty
FROM customer_orders
GROUP BY h
ORDER BY h;

-- 10. What was the volume of orders for each day of the week?
SELECT
	DATE_FORMAT(order_time, '%W') as wd,
	COUNT(*) AS pizza_qty
FROM customer_orders
GROUP BY wd;











