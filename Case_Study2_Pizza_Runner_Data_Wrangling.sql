-- null values
-- customer_orders
UPDATE customer_orders
SET exclusions = null
WHERE exclusions = "";

UPDATE customer_orders
SET exclusions = null
WHERE exclusions = "null";

UPDATE customer_orders
SET extras = null
WHERE extras = "";

UPDATE customer_orders
SET extras = null
WHERE extras = "null";

-- runner_orders

UPDATE runner_orders
SET pickup_time = null
WHERE pickup_time = "null";

UPDATE runner_orders
SET distance = null
WHERE distance = "null";

UPDATE runner_orders
SET duration = null
WHERE duration = "null";

UPDATE runner_orders
SET cancellation = null
WHERE cancellation = "null";

UPDATE runner_orders
SET cancellation = null
WHERE cancellation = "";

UPDATE runner_orders
SET distance = REPLACE(distance, 'km','');

UPDATE runner_orders
SET distance = REPLACE(distance, ' ','');

UPDATE runner_orders
SET duration = REPLACE(duration, 'minutes','');

UPDATE runner_orders
SET duration = REPLACE(duration, 'minute','');

UPDATE runner_orders
SET duration = REPLACE(duration, 'mins','');

UPDATE runner_orders
SET duration = REPLACE(duration, ' ','');

-- distance(km) and duration(min)
ALTER TABLE runner_orders
MODIFY distance float,
MODIFY duration integer;

SELECT *
FROM runner_orders;