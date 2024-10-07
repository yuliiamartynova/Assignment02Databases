USE opt_db;

SELECT 
    CONCAT(c.name, ' ', c.surname) AS customer_name,
    COUNT(o.order_id) AS order_count,
    (SELECT COUNT(*) FROM opt_orders WHERE client_id = c.id) AS specific_order_count
FROM 
    opt_clients c
LEFT JOIN 
    opt_orders o ON c.id = o.client_id
GROUP BY 
    c.id
HAVING 
    COUNT(o.order_id) = (SELECT MAX(order_count) FROM 
                         (SELECT COUNT(order_id) AS order_count 
                          FROM opt_orders 
                          GROUP BY client_id) AS max_orders)
OR 
    COUNT(o.order_id) = (SELECT MIN(order_count) FROM 
                         (SELECT COUNT(order_id) AS order_count 
                          FROM opt_orders 
                          GROUP BY client_id) AS min_orders)
AND (SELECT COUNT(*) FROM opt_orders) > 
    (SELECT COUNT(*) FROM opt_orders WHERE client_id = c.id);
