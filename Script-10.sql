USE opt_db;


select * from opt_clients limit 10;
select * from opt_products limit 10;
select * from opt_orders limit 10;

CREATE INDEX idx_client_id ON opt_orders(client_id);
CREATE INDEX idx_order_id ON opt_orders(order_id);

WITH OrderCounts AS (
    SELECT 
        c.id AS client_id,
        CONCAT(c.name, ' ', c.surname) AS customer_name,
        COUNT(o.order_id) AS order_count
    FROM 
        opt_clients c
    JOIN 
        opt_orders o ON c.id = o.client_id
    GROUP BY 
        c.id
)
SELECT 
    customer_name, order_count
FROM 
    OrderCounts
WHERE 
    order_count = (SELECT MAX(order_count) FROM OrderCounts)
OR 
    order_count = (SELECT MIN(order_count) FROM OrderCounts);