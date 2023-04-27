USE pizza_runner;

-- 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
SELECT
	WEEK(registration_date,1)+1 AS week,
    COUNT(*) as signs
FROM runners
GROUP BY week;

-- 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
SELECT DISTINCT
    runner_id,
	ROUND(AVG(TIME_TO_SEC(TIMEDIFF(pickup_time, order_time)))/60) AS avg_time
FROM runner_orders
JOIN customer_orders ON customer_orders.order_id = runner_orders.order_id
GROUP BY runner_id;

SELECT DISTINCT
	customer_orders.order_id,
	runner_id,
	TIMEDIFF(Pickup_time, order_time)
FROM runner_orders
JOIN customer_orders ON customer_orders.order_id = runner_orders.order_id;

-- 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
SELECT
	customer_orders.order_id,
    COUNT(customer_orders.order_id) AS n_pizzas,
    ROUND(TIME_TO_SEC(TIMEDIFF(pickup_time, order_time))/60) AS prep_time,
    ROUND(TIME_TO_SEC(TIMEDIFF(pickup_time, order_time))/60)/COUNT(customer_orders.order_id) AS time_per_pizza
FROM runner_orders
JOIN customer_orders ON customer_orders.order_id = runner_orders.order_id
GROUP BY customer_orders.order_id;

-- 4. What was the average distance travelled for each customer?
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

-- 5. What was the difference between the longest and shortest delivery times for all orders?
SELECT
	MAX(duration) AS longest,
    MIN(duration) AS shortest,
    MAX(duration)-MIN(duration) AS difference
FROM runner_orders;

-- 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
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

-- 7. What is the successful delivery percentage for each runner?
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
