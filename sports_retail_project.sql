USE sports_retail;

SHOW TABLES;

SELECT COUNT(*) FROM brands_v2;
SELECT COUNT(*) FROM finance;
SELECT COUNT(*) FROM info_v2;
SELECT COUNT(*) FROM reviews_v2;
SELECT COUNT(*) FROM traffic_v3;

# Number of products per brand
SELECT brand, COUNT(*) AS total_products
FROM brands_v2
GROUP BY brand
ORDER BY total_products DESC;

# Average listing price and discount per brand
SELECT b.brand,
       ROUND(AVG(f.listing_price),2) AS avg_price,
       ROUND(AVG(f.discount),2) AS avg_discount
FROM brands_v2 b
JOIN finance f ON b.product_id = f.product_id
GROUP BY b.brand
ORDER BY avg_price DESC;

# Top 10 most expensive products
SELECT i.product_name, b.brand, f.listing_price
FROM info_v2 i
JOIN brands_v2 b ON i.product_id = b.product_id
JOIN finance f ON i.product_id = f.product_id
ORDER BY f.listing_price DESC
LIMIT 10;

# Revenue contribution by brand
SELECT b.brand,
       ROUND(SUM(f.revenue),2) AS total_revenue,
       ROUND(AVG(f.discount),2) AS avg_discount
FROM brands_v2 b
JOIN finance f ON b.product_id = f.product_id
GROUP BY b.brand
ORDER BY total_revenue DESC;

#Find high-performing products (high rating + high revenue)
SELECT i.product_name, b.brand, f.revenue, r.rating
FROM info_v2 i
JOIN brands_v2 b ON i.product_id = b.product_id
JOIN finance f ON i.product_id = f.product_id
JOIN reviews_v2 r ON i.product_id = r.product_id
WHERE r.rating >= 4.5
ORDER BY f.revenue DESC
LIMIT 10;

# Identify top brands by customer engagement
SELECT b.brand,
       COUNT(r.reviews) AS total_reviews,
       ROUND(AVG(r.rating),2) AS avg_rating
FROM brands_v2 b
JOIN reviews_v2 r ON b.product_id = r.product_id
GROUP BY b.brand
ORDER BY total_reviews DESC, avg_rating DESC;

# Average revenue per website visit (conversion proxy)
SELECT b.brand,
       ROUND(SUM(f.revenue)/COUNT(t.product_id),2) AS revenue_per_visit
FROM brands_v2 b
JOIN finance f ON b.product_id = f.product_id
JOIN traffic_v3 t ON b.product_id = t.product_id
GROUP BY b.brand
ORDER BY revenue_per_visit DESC;

# Time-based Trend (using traffic_v3)
SELECT DATE_FORMAT(last_visited, '%Y-%m') AS month,
       COUNT(*) AS total_visits
FROM traffic_v3
GROUP BY month
ORDER BY month;









