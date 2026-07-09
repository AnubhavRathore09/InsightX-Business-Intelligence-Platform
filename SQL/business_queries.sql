-- =====================================================
-- InsightX - Business Intelligence Platform
-- Business SQL Queries
-- =====================================================

-- Dataset:
-- Brazilian E-Commerce Public Dataset (Olist)

-- =====================================================
-- MODULE 1 : EXECUTIVE KPI ANALYSIS
-- =====================================================

----------------------------------------------------------
-- 1. Total Revenue
----------------------------------------------------------

SELECT
    ROUND(SUM(payment_value),2) AS total_revenue
FROM order_payments;


----------------------------------------------------------
-- 2. Total Orders
----------------------------------------------------------

SELECT
    COUNT(*) AS total_orders
FROM orders;


----------------------------------------------------------
-- 3. Total Customers
----------------------------------------------------------

SELECT
    COUNT(DISTINCT customer_unique_id) AS total_customers
FROM customers;


----------------------------------------------------------
-- 4. Total Sellers
----------------------------------------------------------

SELECT
    COUNT(*) AS total_sellers
FROM sellers;


----------------------------------------------------------
-- 5. Total Products
----------------------------------------------------------

SELECT
    COUNT(*) AS total_products
FROM products;


----------------------------------------------------------
-- 6. Average Order Value (AOV)
----------------------------------------------------------

SELECT
    ROUND(AVG(payment_value),2) AS average_order_value
FROM order_payments;


----------------------------------------------------------
-- 7. Average Customer Rating
----------------------------------------------------------

SELECT
    ROUND(AVG(review_score),2) AS average_review_score
FROM order_reviews;


----------------------------------------------------------
-- 8. Delivered Orders
----------------------------------------------------------

SELECT
    COUNT(*) AS delivered_orders
FROM orders
WHERE order_status='delivered';


----------------------------------------------------------
-- 9. Cancelled Orders
----------------------------------------------------------

SELECT
    COUNT(*) AS cancelled_orders
FROM orders
WHERE order_status='canceled';


----------------------------------------------------------
-- 10. Order Status Distribution
----------------------------------------------------------

SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;


----------------------------------------------------------
-- 11. Total Freight Cost
----------------------------------------------------------

SELECT
    ROUND(SUM(freight_value),2) AS total_freight_cost
FROM order_items;


----------------------------------------------------------
-- 12. Average Freight Cost
----------------------------------------------------------

SELECT
    ROUND(AVG(freight_value),2) AS average_freight_cost
FROM order_items;


----------------------------------------------------------
-- 13. Average Payment Installments
----------------------------------------------------------

SELECT
    ROUND(AVG(payment_installments),2) AS average_installments
FROM order_payments;


----------------------------------------------------------
-- 14. Highest Order Value
----------------------------------------------------------

SELECT
    MAX(payment_value) AS highest_order_value
FROM order_payments;


----------------------------------------------------------
-- 15. Lowest Order Value
----------------------------------------------------------

SELECT
    MIN(payment_value) AS lowest_order_value
FROM order_payments;

-- =====================================================
-- MODULE 2 : SALES ANALYTICS
-- =====================================================

----------------------------------------------------------
-- 16. Monthly Revenue
----------------------------------------------------------

SELECT
    YEAR(o.order_purchase_timestamp) AS year,
    MONTH(o.order_purchase_timestamp) AS month,
    ROUND(SUM(op.payment_value),2) AS revenue
FROM orders o
JOIN order_payments op
ON o.order_id = op.order_id
GROUP BY YEAR(o.order_purchase_timestamp),
         MONTH(o.order_purchase_timestamp)
ORDER BY year, month;

----------------------------------------------------------
-- 17. Monthly Orders
----------------------------------------------------------

SELECT
    YEAR(order_purchase_timestamp) AS year,
    MONTH(order_purchase_timestamp) AS month,
    COUNT(*) AS total_orders
FROM orders
GROUP BY YEAR(order_purchase_timestamp),
         MONTH(order_purchase_timestamp)
ORDER BY year, month;

----------------------------------------------------------
-- 18. Revenue by Product Category
----------------------------------------------------------

SELECT
    p.product_category_name,
    ROUND(SUM(oi.price),2) AS revenue
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY revenue DESC;

----------------------------------------------------------
-- 19. Top 10 Best Selling Products
----------------------------------------------------------

SELECT
    product_id,
    COUNT(*) AS total_sales
FROM order_items
GROUP BY product_id
ORDER BY total_sales DESC
LIMIT 10;

----------------------------------------------------------
-- 20. Top 10 Revenue Generating Products
----------------------------------------------------------

SELECT
    product_id,
    ROUND(SUM(price),2) AS revenue
FROM order_items
GROUP BY product_id
ORDER BY revenue DESC
LIMIT 10;

----------------------------------------------------------
-- 21. Top 10 Product Categories
----------------------------------------------------------

SELECT
    p.product_category_name,
    COUNT(*) AS total_orders
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_orders DESC
LIMIT 10;

----------------------------------------------------------
-- 22. Average Product Price
----------------------------------------------------------

SELECT
    ROUND(AVG(price),2) AS average_product_price
FROM order_items;

----------------------------------------------------------
-- 23. Highest Product Price
----------------------------------------------------------

SELECT
    MAX(price) AS highest_price
FROM order_items;

----------------------------------------------------------
-- 24. Lowest Product Price
----------------------------------------------------------

SELECT
    MIN(price) AS lowest_price
FROM order_items;

----------------------------------------------------------
-- 25. Revenue by Seller
----------------------------------------------------------

SELECT
    seller_id,
    ROUND(SUM(price),2) AS revenue
FROM order_items
GROUP BY seller_id
ORDER BY revenue DESC
LIMIT 20;

----------------------------------------------------------
-- 26. Average Revenue per Seller
----------------------------------------------------------

SELECT
    ROUND(AVG(revenue),2) AS average_seller_revenue
FROM (
    SELECT
        seller_id,
        SUM(price) AS revenue
    FROM order_items
    GROUP BY seller_id
) t;

----------------------------------------------------------
-- 27. Total Revenue by State
----------------------------------------------------------

SELECT
    c.customer_state,
    ROUND(SUM(op.payment_value),2) AS revenue
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_payments op
ON o.order_id = op.order_id
GROUP BY c.customer_state
ORDER BY revenue DESC;

----------------------------------------------------------
-- 28. Revenue by Payment Type
----------------------------------------------------------

SELECT
    payment_type,
    ROUND(SUM(payment_value),2) AS revenue
FROM order_payments
GROUP BY payment_type
ORDER BY revenue DESC;

----------------------------------------------------------
-- 29. Orders by Payment Type
----------------------------------------------------------

SELECT
    payment_type,
    COUNT(*) AS total_orders
FROM order_payments
GROUP BY payment_type
ORDER BY total_orders DESC;

----------------------------------------------------------
-- 30. Average Revenue per Order
----------------------------------------------------------

SELECT
    ROUND(SUM(payment_value)/COUNT(DISTINCT order_id),2)
    AS revenue_per_order
FROM order_payments;

----------------------------------------------------------
-- 31. Revenue by Order Status
----------------------------------------------------------

SELECT
    o.order_status,
    ROUND(SUM(op.payment_value),2) AS revenue
FROM orders o
JOIN order_payments op
ON o.order_id = op.order_id
GROUP BY o.order_status
ORDER BY revenue DESC;

----------------------------------------------------------
-- 32. Orders by Weekday
----------------------------------------------------------

SELECT
    DAYNAME(order_purchase_timestamp) AS weekday,
    COUNT(*) AS total_orders
FROM orders
GROUP BY weekday
ORDER BY total_orders DESC;

----------------------------------------------------------
-- 33. Orders by Hour
----------------------------------------------------------

SELECT
    HOUR(order_purchase_timestamp) AS hour_of_day,
    COUNT(*) AS total_orders
FROM orders
GROUP BY hour_of_day
ORDER BY hour_of_day;

----------------------------------------------------------
-- 34. Average Daily Revenue
----------------------------------------------------------

SELECT
    ROUND(AVG(daily_revenue),2) AS average_daily_revenue
FROM
(
SELECT
DATE(o.order_purchase_timestamp) AS purchase_date,
SUM(op.payment_value) AS daily_revenue
FROM orders o
JOIN order_payments op
ON o.order_id = op.order_id
GROUP BY DATE(o.order_purchase_timestamp)
)t;

----------------------------------------------------------
-- 35. Top 20 Highest Revenue Orders
----------------------------------------------------------

SELECT
    order_id,
    ROUND(SUM(payment_value),2) AS revenue
FROM order_payments
GROUP BY order_id
ORDER BY revenue DESC
LIMIT 20;

-- =====================================================
-- MODULE 3 : CUSTOMER ANALYTICS
-- =====================================================

----------------------------------------------------------
-- 36. Top 10 Customers by Revenue
----------------------------------------------------------

SELECT
    c.customer_unique_id,
    ROUND(SUM(op.payment_value),2) AS total_revenue
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_payments op
ON o.order_id = op.order_id
GROUP BY c.customer_unique_id
ORDER BY total_revenue DESC
LIMIT 10;

----------------------------------------------------------
-- 37. Top 10 Customers by Number of Orders
----------------------------------------------------------

SELECT
    c.customer_unique_id,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id
ORDER BY total_orders DESC
LIMIT 10;

----------------------------------------------------------
-- 38. Average Revenue Per Customer
----------------------------------------------------------

SELECT
ROUND(SUM(payment_value)/
COUNT(DISTINCT o.customer_id),2)
AS average_customer_revenue
FROM orders o
JOIN order_payments op
ON o.order_id=op.order_id;

----------------------------------------------------------
-- 39. Customers by State
----------------------------------------------------------

SELECT
customer_state,
COUNT(*) AS total_customers
FROM customers
GROUP BY customer_state
ORDER BY total_customers DESC;

----------------------------------------------------------
-- 40. Top Cities by Customers
----------------------------------------------------------

SELECT
customer_city,
COUNT(*) AS total_customers
FROM customers
GROUP BY customer_city
ORDER BY total_customers DESC
LIMIT 20;

----------------------------------------------------------
-- 41. Customers with More Than One Order
----------------------------------------------------------

SELECT
c.customer_unique_id,
COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
GROUP BY c.customer_unique_id
HAVING COUNT(o.order_id)>1
ORDER BY total_orders DESC;

----------------------------------------------------------
-- 42. One-Time Customers
----------------------------------------------------------

SELECT
COUNT(*) AS one_time_customers
FROM
(
SELECT
customer_id,
COUNT(order_id) AS total_orders
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id)=1
)t;

----------------------------------------------------------
-- 43. Repeat Customers
----------------------------------------------------------

SELECT
COUNT(*) AS repeat_customers
FROM
(
SELECT
customer_id,
COUNT(order_id)
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id)>1
)t;

----------------------------------------------------------
-- 44. Customer Revenue by State
----------------------------------------------------------

SELECT
c.customer_state,
ROUND(SUM(op.payment_value),2) revenue
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
JOIN order_payments op
ON o.order_id=op.order_id
GROUP BY customer_state
ORDER BY revenue DESC;

----------------------------------------------------------
-- 45. Highest Spending Customer
----------------------------------------------------------

SELECT
c.customer_unique_id,
ROUND(SUM(op.payment_value),2) revenue
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
JOIN order_payments op
ON o.order_id=op.order_id
GROUP BY c.customer_unique_id
ORDER BY revenue DESC
LIMIT 1;

----------------------------------------------------------
-- 46. Customer Purchase Frequency
----------------------------------------------------------

SELECT
customer_id,
COUNT(order_id) AS purchase_frequency
FROM orders
GROUP BY customer_id
ORDER BY purchase_frequency DESC;

----------------------------------------------------------
-- 47. Monthly New Customers
----------------------------------------------------------

SELECT
YEAR(order_purchase_timestamp) AS year,
MONTH(order_purchase_timestamp) AS month,
COUNT(DISTINCT customer_id) AS new_customers
FROM orders
GROUP BY year,month
ORDER BY year,month;

----------------------------------------------------------
-- 48. Average Orders Per Customer
----------------------------------------------------------

SELECT
ROUND(
COUNT(order_id)/
COUNT(DISTINCT customer_id),2)
AS avg_orders_per_customer
FROM orders;

----------------------------------------------------------
-- 49. Top Customer Cities by Revenue
----------------------------------------------------------

SELECT
c.customer_city,
ROUND(SUM(op.payment_value),2) revenue
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
JOIN order_payments op
ON o.order_id=op.order_id
GROUP BY customer_city
ORDER BY revenue DESC
LIMIT 20;

----------------------------------------------------------
-- 50. Revenue Contribution by State
----------------------------------------------------------

SELECT
customer_state,
ROUND(SUM(payment_value),2) revenue
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
JOIN order_payments op
ON o.order_id=op.order_id
GROUP BY customer_state
ORDER BY revenue DESC;

----------------------------------------------------------
-- 51. Top 20 High Value Customers
----------------------------------------------------------

SELECT
c.customer_unique_id,
ROUND(SUM(op.payment_value),2) revenue
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
JOIN order_payments op
ON o.order_id=op.order_id
GROUP BY c.customer_unique_id
ORDER BY revenue DESC
LIMIT 20;

----------------------------------------------------------
-- 52. Average Customer Rating by State
----------------------------------------------------------

SELECT
c.customer_state,
ROUND(AVG(r.review_score),2) average_rating
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
JOIN order_reviews r
ON o.order_id=r.order_id
GROUP BY customer_state
ORDER BY average_rating DESC;

----------------------------------------------------------
-- 53. Customers by Order Status
----------------------------------------------------------

SELECT
order_status,
COUNT(DISTINCT customer_id) total_customers
FROM orders
GROUP BY order_status
ORDER BY total_customers DESC;

----------------------------------------------------------
-- 54. Revenue Generated by Top 10 Customers
----------------------------------------------------------

SELECT
c.customer_unique_id,
ROUND(SUM(op.payment_value),2) revenue
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
JOIN order_payments op
ON o.order_id=op.order_id
GROUP BY c.customer_unique_id
ORDER BY revenue DESC
LIMIT 10;

----------------------------------------------------------
-- 55. Customer Ranking by Revenue
----------------------------------------------------------

SELECT
c.customer_unique_id,
ROUND(SUM(op.payment_value),2) revenue,
DENSE_RANK() OVER(
ORDER BY SUM(op.payment_value) DESC
) customer_rank
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
JOIN order_payments op
ON o.order_id=op.order_id
GROUP BY c.customer_unique_id;

-- =====================================================
-- MODULE 4 : PRODUCT ANALYTICS
-- =====================================================

----------------------------------------------------------
-- 56. Total Products by Category
----------------------------------------------------------

SELECT
    product_category_name,
    COUNT(*) AS total_products
FROM products
GROUP BY product_category_name
ORDER BY total_products DESC;

----------------------------------------------------------
-- 57. Top 10 Best Selling Products
----------------------------------------------------------

SELECT
    oi.product_id,
    COUNT(*) AS total_sales
FROM order_items oi
GROUP BY oi.product_id
ORDER BY total_sales DESC
LIMIT 10;

----------------------------------------------------------
-- 58. Bottom 10 Least Selling Products
----------------------------------------------------------

SELECT
    oi.product_id,
    COUNT(*) AS total_sales
FROM order_items oi
GROUP BY oi.product_id
ORDER BY total_sales ASC
LIMIT 10;

----------------------------------------------------------
-- 59. Top Revenue Generating Products
----------------------------------------------------------

SELECT
    oi.product_id,
    ROUND(SUM(oi.price),2) AS revenue
FROM order_items oi
GROUP BY oi.product_id
ORDER BY revenue DESC
LIMIT 20;

----------------------------------------------------------
-- 60. Revenue by Product Category
----------------------------------------------------------

SELECT
    p.product_category_name,
    ROUND(SUM(oi.price),2) AS revenue
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY revenue DESC;

----------------------------------------------------------
-- 61. Average Product Price by Category
----------------------------------------------------------

SELECT
    p.product_category_name,
    ROUND(AVG(oi.price),2) AS average_price
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY average_price DESC;

----------------------------------------------------------
-- 62. Average Freight Cost by Category
----------------------------------------------------------

SELECT
    p.product_category_name,
    ROUND(AVG(oi.freight_value),2) AS average_freight
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY average_freight DESC;

----------------------------------------------------------
-- 63. Top Categories by Quantity Sold
----------------------------------------------------------

SELECT
    p.product_category_name,
    COUNT(*) AS total_items_sold
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_items_sold DESC;

----------------------------------------------------------
-- 64. Highest Priced Products
----------------------------------------------------------

SELECT
    product_id,
    MAX(price) AS highest_price
FROM order_items
GROUP BY product_id
ORDER BY highest_price DESC
LIMIT 20;

----------------------------------------------------------
-- 65. Lowest Priced Products
----------------------------------------------------------

SELECT
    product_id,
    MIN(price) AS lowest_price
FROM order_items
GROUP BY product_id
ORDER BY lowest_price ASC
LIMIT 20;

----------------------------------------------------------
-- 66. Product Revenue Ranking
----------------------------------------------------------

SELECT
    product_id,
    ROUND(SUM(price),2) AS revenue,
    DENSE_RANK() OVER(
        ORDER BY SUM(price) DESC
    ) AS revenue_rank
FROM order_items
GROUP BY product_id;

----------------------------------------------------------
-- 67. Top Categories by Average Rating
----------------------------------------------------------

SELECT
    p.product_category_name,
    ROUND(AVG(r.review_score),2) AS average_rating
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
JOIN order_reviews r
ON oi.order_id = r.order_id
GROUP BY p.product_category_name
ORDER BY average_rating DESC;

----------------------------------------------------------
-- 68. Product Sales by Seller Count
----------------------------------------------------------

SELECT
    product_id,
    COUNT(DISTINCT seller_id) AS seller_count
FROM order_items
GROUP BY product_id
ORDER BY seller_count DESC;

----------------------------------------------------------
-- 69. Products with Highest Freight Cost
----------------------------------------------------------

SELECT
    product_id,
    ROUND(AVG(freight_value),2) AS average_freight
FROM order_items
GROUP BY product_id
ORDER BY average_freight DESC
LIMIT 20;

----------------------------------------------------------
-- 70. Product Revenue Contribution (%)
----------------------------------------------------------

SELECT
    product_id,
    ROUND(
        SUM(price) * 100 /
        (SELECT SUM(price) FROM order_items),
        2
    ) AS revenue_percentage
FROM order_items
GROUP BY product_id
ORDER BY revenue_percentage DESC;

----------------------------------------------------------
-- 71. Product Revenue Running Total
----------------------------------------------------------

SELECT
    product_id,
    ROUND(SUM(price),2) AS revenue,
    ROUND(
        SUM(SUM(price)) OVER(
            ORDER BY SUM(price) DESC
        ),
        2
    ) AS running_revenue
FROM order_items
GROUP BY product_id;

----------------------------------------------------------
-- 72. Top 10 Categories by Revenue
----------------------------------------------------------

SELECT
    p.product_category_name,
    ROUND(SUM(oi.price),2) AS revenue
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY revenue DESC
LIMIT 10;

----------------------------------------------------------
-- 73. Product Count by Seller
----------------------------------------------------------

SELECT
    seller_id,
    COUNT(DISTINCT product_id) AS total_products
FROM order_items
GROUP BY seller_id
ORDER BY total_products DESC;

----------------------------------------------------------
-- 74. Average Product Dimensions
----------------------------------------------------------

SELECT
    ROUND(AVG(product_length_cm),2) AS avg_length,
    ROUND(AVG(product_height_cm),2) AS avg_height,
    ROUND(AVG(product_width_cm),2) AS avg_width
FROM products;

----------------------------------------------------------
-- 75. Average Product Weight
----------------------------------------------------------

SELECT
    ROUND(AVG(product_weight_g),2) AS average_weight
FROM products;

-- =====================================================
-- MODULE 5 : SELLER ANALYTICS
-- =====================================================

----------------------------------------------------------
-- 76. Total Sellers
----------------------------------------------------------

SELECT
    COUNT(*) AS total_sellers
FROM sellers;

----------------------------------------------------------
-- 77. Top 20 Sellers by Revenue
----------------------------------------------------------

SELECT
    oi.seller_id,
    ROUND(SUM(oi.price),2) AS revenue
FROM order_items oi
GROUP BY oi.seller_id
ORDER BY revenue DESC
LIMIT 20;

----------------------------------------------------------
-- 78. Top 20 Sellers by Orders
----------------------------------------------------------

SELECT
    seller_id,
    COUNT(DISTINCT order_id) AS total_orders
FROM order_items
GROUP BY seller_id
ORDER BY total_orders DESC
LIMIT 20;

----------------------------------------------------------
-- 79. Average Revenue Per Seller
----------------------------------------------------------

SELECT
    ROUND(AVG(revenue),2) AS average_revenue
FROM
(
SELECT
seller_id,
SUM(price) revenue
FROM order_items
GROUP BY seller_id
)t;

----------------------------------------------------------
-- 80. Seller Revenue Ranking
----------------------------------------------------------

SELECT
seller_id,
ROUND(SUM(price),2) revenue,
DENSE_RANK() OVER(
ORDER BY SUM(price) DESC
) seller_rank
FROM order_items
GROUP BY seller_id;

----------------------------------------------------------
-- 81. Seller Performance by State
----------------------------------------------------------

SELECT
s.seller_state,
ROUND(SUM(oi.price),2) revenue
FROM sellers s
JOIN order_items oi
ON s.seller_id=oi.seller_id
GROUP BY s.seller_state
ORDER BY revenue DESC;

----------------------------------------------------------
-- 82. Sellers by State
----------------------------------------------------------

SELECT
seller_state,
COUNT(*) total_sellers
FROM sellers
GROUP BY seller_state
ORDER BY total_sellers DESC;

----------------------------------------------------------
-- 83. Average Orders Per Seller
----------------------------------------------------------

SELECT
ROUND(
COUNT(DISTINCT order_id)/
COUNT(DISTINCT seller_id),2
) avg_orders_per_seller
FROM order_items;

----------------------------------------------------------
-- 84. Average Products Per Seller
----------------------------------------------------------

SELECT
ROUND(
COUNT(DISTINCT product_id)/
COUNT(DISTINCT seller_id),2
) avg_products_per_seller
FROM order_items;

----------------------------------------------------------
-- 85. Sellers Selling Maximum Products
----------------------------------------------------------

SELECT
seller_id,
COUNT(DISTINCT product_id) total_products
FROM order_items
GROUP BY seller_id
ORDER BY total_products DESC
LIMIT 20;

----------------------------------------------------------
-- 86. Seller Average Product Price
----------------------------------------------------------

SELECT
seller_id,
ROUND(AVG(price),2) average_price
FROM order_items
GROUP BY seller_id
ORDER BY average_price DESC;

----------------------------------------------------------
-- 87. Seller Average Freight Cost
----------------------------------------------------------

SELECT
seller_id,
ROUND(AVG(freight_value),2) avg_freight
FROM order_items
GROUP BY seller_id
ORDER BY avg_freight DESC;

----------------------------------------------------------
-- 88. Seller Revenue Contribution (%)
----------------------------------------------------------

SELECT
seller_id,
ROUND(
SUM(price)*100/
(SELECT SUM(price) FROM order_items),
2
) revenue_percentage
FROM order_items
GROUP BY seller_id
ORDER BY revenue_percentage DESC;

----------------------------------------------------------
-- 89. Top Rated Sellers
----------------------------------------------------------

SELECT
oi.seller_id,
ROUND(AVG(r.review_score),2) average_rating
FROM order_items oi
JOIN order_reviews r
ON oi.order_id=r.order_id
GROUP BY oi.seller_id
ORDER BY average_rating DESC
LIMIT 20;

----------------------------------------------------------
-- 90. Sellers with Highest Average Order Value
----------------------------------------------------------

SELECT
seller_id,
ROUND(AVG(price),2) average_order_value
FROM order_items
GROUP BY seller_id
ORDER BY average_order_value DESC
LIMIT 20;

----------------------------------------------------------
-- 91. Seller Running Revenue
----------------------------------------------------------

SELECT
seller_id,
ROUND(SUM(price),2) revenue,
ROUND(
SUM(SUM(price)) OVER(
ORDER BY SUM(price) DESC
),2
) running_revenue
FROM order_items
GROUP BY seller_id;

----------------------------------------------------------
-- 92. Seller Revenue by Product Category
----------------------------------------------------------

SELECT
s.seller_state,
p.product_category_name,
ROUND(SUM(oi.price),2) revenue
FROM order_items oi
JOIN sellers s
ON oi.seller_id=s.seller_id
JOIN products p
ON oi.product_id=p.product_id
GROUP BY
s.seller_state,
p.product_category_name
ORDER BY revenue DESC;

----------------------------------------------------------
-- 93. Seller Revenue by Month
----------------------------------------------------------

SELECT
oi.seller_id,
YEAR(o.order_purchase_timestamp) year,
MONTH(o.order_purchase_timestamp) month,
ROUND(SUM(oi.price),2) revenue
FROM order_items oi
JOIN orders o
ON oi.order_id=o.order_id
GROUP BY
oi.seller_id,
year,
month
ORDER BY
year,
month;

----------------------------------------------------------
-- 94. Top Seller City by Revenue
----------------------------------------------------------

SELECT
s.seller_city,
ROUND(SUM(oi.price),2) revenue
FROM sellers s
JOIN order_items oi
ON s.seller_id=oi.seller_id
GROUP BY s.seller_city
ORDER BY revenue DESC
LIMIT 20;

----------------------------------------------------------
-- 95. Seller Revenue Distribution
----------------------------------------------------------

SELECT
seller_state,
COUNT(DISTINCT seller_id) total_sellers,
ROUND(SUM(price),2) total_revenue
FROM sellers s
JOIN order_items oi
ON s.seller_id=oi.seller_id
GROUP BY seller_state
ORDER BY total_revenue DESC;

-- =====================================================
-- MODULE 6 : PAYMENT & DELIVERY ANALYTICS
-- =====================================================

----------------------------------------------------------
-- 96. Revenue by Payment Type
----------------------------------------------------------

SELECT
    payment_type,
    ROUND(SUM(payment_value),2) AS total_revenue
FROM order_payments
GROUP BY payment_type
ORDER BY total_revenue DESC;

----------------------------------------------------------
-- 97. Orders by Payment Type
----------------------------------------------------------

SELECT
    payment_type,
    COUNT(DISTINCT order_id) AS total_orders
FROM order_payments
GROUP BY payment_type
ORDER BY total_orders DESC;

----------------------------------------------------------
-- 98. Average Payment Value by Payment Type
----------------------------------------------------------

SELECT
    payment_type,
    ROUND(AVG(payment_value),2) AS average_payment
FROM order_payments
GROUP BY payment_type
ORDER BY average_payment DESC;

----------------------------------------------------------
-- 99. Average Installments by Payment Type
----------------------------------------------------------

SELECT
    payment_type,
    ROUND(AVG(payment_installments),2) AS avg_installments
FROM order_payments
GROUP BY payment_type
ORDER BY avg_installments DESC;

----------------------------------------------------------
-- 100. Maximum Installments Used
----------------------------------------------------------

SELECT
    MAX(payment_installments) AS max_installments
FROM order_payments;

----------------------------------------------------------
-- 101. Installment Distribution
----------------------------------------------------------

SELECT
    payment_installments,
    COUNT(*) AS total_orders
FROM order_payments
GROUP BY payment_installments
ORDER BY payment_installments;

----------------------------------------------------------
-- 102. Total Freight Revenue
----------------------------------------------------------

SELECT
    ROUND(SUM(freight_value),2) AS total_freight
FROM order_items;

----------------------------------------------------------
-- 103. Average Freight Cost
----------------------------------------------------------

SELECT
    ROUND(AVG(freight_value),2) AS average_freight
FROM order_items;

----------------------------------------------------------
-- 104. Highest Freight Cost
----------------------------------------------------------

SELECT
    MAX(freight_value) AS highest_freight
FROM order_items;

----------------------------------------------------------
-- 105. Lowest Freight Cost
----------------------------------------------------------

SELECT
    MIN(freight_value) AS lowest_freight
FROM order_items;

----------------------------------------------------------
-- 106. Average Delivery Time (Days)
----------------------------------------------------------

SELECT
ROUND(
AVG(
DATEDIFF(order_delivered_customer_date,
order_purchase_timestamp)
),2) AS average_delivery_days
FROM orders
WHERE order_status='delivered';

----------------------------------------------------------
-- 107. Fastest Delivered Orders
----------------------------------------------------------

SELECT
order_id,
DATEDIFF(
order_delivered_customer_date,
order_purchase_timestamp
) AS delivery_days
FROM orders
WHERE order_status='delivered'
ORDER BY delivery_days ASC
LIMIT 20;

----------------------------------------------------------
-- 108. Slowest Delivered Orders
----------------------------------------------------------

SELECT
order_id,
DATEDIFF(
order_delivered_customer_date,
order_purchase_timestamp
) AS delivery_days
FROM orders
WHERE order_status='delivered'
ORDER BY delivery_days DESC
LIMIT 20;

----------------------------------------------------------
-- 109. Orders Delivered Before Estimated Date
----------------------------------------------------------

SELECT
COUNT(*) AS early_deliveries
FROM orders
WHERE order_delivered_customer_date <
order_estimated_delivery_date;

----------------------------------------------------------
-- 110. Orders Delivered After Estimated Date
----------------------------------------------------------

SELECT
COUNT(*) AS late_deliveries
FROM orders
WHERE order_delivered_customer_date >
order_estimated_delivery_date;

----------------------------------------------------------
-- 111. Average Delivery Time by State
----------------------------------------------------------

SELECT
c.customer_state,
ROUND(
AVG(
DATEDIFF(
o.order_delivered_customer_date,
o.order_purchase_timestamp
)
),2) AS avg_delivery_days
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
WHERE o.order_status='delivered'
GROUP BY c.customer_state
ORDER BY avg_delivery_days;

----------------------------------------------------------
-- 112. Average Freight Cost by State
----------------------------------------------------------

SELECT
c.customer_state,
ROUND(AVG(oi.freight_value),2) avg_freight
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
JOIN order_items oi
ON o.order_id=oi.order_id
GROUP BY c.customer_state
ORDER BY avg_freight DESC;

----------------------------------------------------------
-- 113. Payment Revenue by Month
----------------------------------------------------------

SELECT
YEAR(o.order_purchase_timestamp) year,
MONTH(o.order_purchase_timestamp) month,
ROUND(SUM(op.payment_value),2) revenue
FROM orders o
JOIN order_payments op
ON o.order_id=op.order_id
GROUP BY year,month
ORDER BY year,month;

----------------------------------------------------------
-- 114. Delivery Status Distribution
----------------------------------------------------------

SELECT
order_status,
COUNT(*) total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

----------------------------------------------------------
-- 115. Average Payment Per Installment
----------------------------------------------------------

SELECT
payment_installments,
ROUND(AVG(payment_value),2) average_payment
FROM order_payments
GROUP BY payment_installments
ORDER BY payment_installments;

-- =====================================================
-- MODULE 7 : GROWTH ANALYTICS
-- =====================================================

----------------------------------------------------------
-- 116. Monthly Active Customers (MAU)
----------------------------------------------------------

SELECT
YEAR(o.order_purchase_timestamp) AS year,
MONTH(o.order_purchase_timestamp) AS month,
COUNT(DISTINCT c.customer_unique_id) AS active_customers
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY year, month
ORDER BY year, month;

----------------------------------------------------------
-- 117. Monthly Revenue Growth
----------------------------------------------------------

WITH monthly_revenue AS
(
SELECT
YEAR(o.order_purchase_timestamp) year,
MONTH(o.order_purchase_timestamp) month,
SUM(op.payment_value) revenue
FROM orders o
JOIN order_payments op
ON o.order_id = op.order_id
GROUP BY year, month
)

SELECT
*,
ROUND(
(revenue-LAG(revenue) OVER(ORDER BY year,month))
/
LAG(revenue) OVER(ORDER BY year,month)
*100,
2
) AS growth_percentage
FROM monthly_revenue;

----------------------------------------------------------
-- 118. Customer Lifetime Value (CLV)
----------------------------------------------------------

SELECT
c.customer_unique_id,
ROUND(SUM(op.payment_value),2) lifetime_value
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
JOIN order_payments op
ON o.order_id=op.order_id
GROUP BY c.customer_unique_id
ORDER BY lifetime_value DESC;

----------------------------------------------------------
-- 119. Average Customer Lifetime Value
----------------------------------------------------------

SELECT
ROUND(AVG(clv),2) average_clv
FROM
(
SELECT
customer_id,
SUM(payment_value) clv
FROM orders o
JOIN order_payments op
ON o.order_id=op.order_id
GROUP BY customer_id
)t;

----------------------------------------------------------
-- 120. Purchase Frequency
----------------------------------------------------------

SELECT
customer_id,
COUNT(order_id) purchase_frequency
FROM orders
GROUP BY customer_id
ORDER BY purchase_frequency DESC;

----------------------------------------------------------
-- 121. Repeat Purchase Rate
----------------------------------------------------------

SELECT
ROUND(
COUNT(DISTINCT CASE
WHEN total_orders>1 THEN customer_id END)
/
COUNT(DISTINCT customer_id)
*100,2
) repeat_purchase_rate
FROM
(
SELECT
customer_id,
COUNT(order_id) total_orders
FROM orders
GROUP BY customer_id
)t;

----------------------------------------------------------
-- 122. Customer Recency
----------------------------------------------------------

SELECT
customer_id,
MAX(order_purchase_timestamp) last_purchase
FROM orders
GROUP BY customer_id;

----------------------------------------------------------
-- 123. Customer Monetary Value
----------------------------------------------------------

SELECT
o.customer_id,
ROUND(SUM(op.payment_value),2) monetary_value
FROM orders o
JOIN order_payments op
ON o.order_id=op.order_id
GROUP BY o.customer_id
ORDER BY monetary_value DESC;

----------------------------------------------------------
-- 124. Top 20 High CLV Customers
----------------------------------------------------------

SELECT
c.customer_unique_id,
ROUND(SUM(op.payment_value),2) clv
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
JOIN order_payments op
ON o.order_id=op.order_id
GROUP BY c.customer_unique_id
ORDER BY clv DESC
LIMIT 20;

----------------------------------------------------------
-- 125. Revenue by Customer Segment
----------------------------------------------------------

SELECT
CASE

WHEN payment_value<50 THEN 'Low Value'

WHEN payment_value BETWEEN 50 AND 150
THEN 'Medium Value'

ELSE 'High Value'

END customer_segment,

COUNT(*) customers,

ROUND(SUM(payment_value),2) revenue

FROM order_payments

GROUP BY customer_segment

ORDER BY revenue DESC;

----------------------------------------------------------
-- 126. Monthly New Customers
----------------------------------------------------------

SELECT
YEAR(order_purchase_timestamp) year,
MONTH(order_purchase_timestamp) month,
COUNT(DISTINCT customer_id) customers
FROM orders
GROUP BY year,month
ORDER BY year,month;

----------------------------------------------------------
-- 127. Average Revenue Per Active Customer
----------------------------------------------------------

SELECT
ROUND(
SUM(op.payment_value)/
COUNT(DISTINCT o.customer_id),2)
average_revenue_per_customer
FROM orders o
JOIN order_payments op
ON o.order_id=op.order_id;

----------------------------------------------------------
-- 128. Customer Ranking by CLV
----------------------------------------------------------

SELECT
customer_unique_id,

ROUND(SUM(payment_value),2) clv,

DENSE_RANK() OVER(
ORDER BY SUM(payment_value) DESC
) customer_rank

FROM customers c

JOIN orders o
ON c.customer_id=o.customer_id

JOIN order_payments op
ON o.order_id=op.order_id

GROUP BY customer_unique_id;

----------------------------------------------------------
-- 129. Top Revenue Month
----------------------------------------------------------

SELECT
YEAR(o.order_purchase_timestamp) year,
MONTH(o.order_purchase_timestamp) month,
ROUND(SUM(op.payment_value),2) revenue
FROM orders o
JOIN order_payments op
ON o.order_id=op.order_id
GROUP BY year,month
ORDER BY revenue DESC
LIMIT 1;

----------------------------------------------------------
-- 130. Running Customer Count
----------------------------------------------------------

SELECT
YEAR(order_purchase_timestamp) year,
MONTH(order_purchase_timestamp) month,

COUNT(DISTINCT customer_id) customers,

SUM(
COUNT(DISTINCT customer_id)
)
OVER(
ORDER BY YEAR(order_purchase_timestamp),
MONTH(order_purchase_timestamp)
) cumulative_customers

FROM orders

GROUP BY year,month;

----------------------------------------------------------
-- 131. Revenue Running Total
----------------------------------------------------------

SELECT
YEAR(o.order_purchase_timestamp) year,
MONTH(o.order_purchase_timestamp) month,

SUM(op.payment_value) revenue,

SUM(
SUM(op.payment_value)
)
OVER(
ORDER BY YEAR(o.order_purchase_timestamp),
MONTH(o.order_purchase_timestamp)
) cumulative_revenue

FROM orders o

JOIN order_payments op

ON o.order_id=op.order_id

GROUP BY year,month;

----------------------------------------------------------
-- 132. Top Revenue Customers (% Contribution)
----------------------------------------------------------

SELECT
customer_unique_id,

ROUND(SUM(payment_value),2) revenue,

ROUND(
SUM(payment_value)*100/
(SELECT SUM(payment_value)
FROM order_payments),
2
) revenue_percentage

FROM customers c

JOIN orders o
ON c.customer_id=o.customer_id

JOIN order_payments op
ON o.order_id=op.order_id

GROUP BY customer_unique_id

ORDER BY revenue DESC

LIMIT 20;

----------------------------------------------------------
-- 133. Customer Revenue Quartiles
----------------------------------------------------------

SELECT
customer_unique_id,

ROUND(SUM(payment_value),2) revenue,

NTILE(4)
OVER(
ORDER BY SUM(payment_value) DESC
) revenue_quartile

FROM customers c

JOIN orders o
ON c.customer_id=o.customer_id

JOIN order_payments op
ON o.order_id=op.order_id

GROUP BY customer_unique_id;

----------------------------------------------------------
-- 134. Top 10 Revenue Growth Months
----------------------------------------------------------

WITH monthly AS
(
SELECT
YEAR(o.order_purchase_timestamp) year,
MONTH(o.order_purchase_timestamp) month,
SUM(op.payment_value) revenue
FROM orders o
JOIN order_payments op
ON o.order_id=op.order_id
GROUP BY year,month
)

SELECT
*,

LAG(revenue)
OVER(
ORDER BY year,month
) previous_month_revenue

FROM monthly;