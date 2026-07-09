# 📚 Data Dictionary

# InsightX - Business Intelligence Platform

---

# Overview

This document describes all datasets used in the InsightX Business Intelligence Platform.

The project uses the Brazilian E-Commerce Public Dataset by Olist, which contains transactional data collected from an e-commerce marketplace between 2016 and 2018.

The datasets are relational and connected through primary and foreign keys.

---

# Dataset Summary

| Dataset | Description | Approx. Records |
|----------|-------------|----------------:|
| Customers | Customer information | 99,441 |
| Orders | Order lifecycle details | 99,441 |
| Order Items | Products purchased in each order | 112,650 |
| Products | Product information | 32,951 |
| Sellers | Seller information | 3,095 |
| Payments | Payment transactions | 103,886 |
| Reviews | Customer reviews | 99,224 |
| Geolocation | Customer & seller locations | 1M+ |
| Category Translation | Product category translation | 71 |

---

# Dataset Details

## 1. Customers Dataset

**File**

```
olist_customers_dataset.csv
```

### Description

Contains customer identification and location information.

### Important Columns

| Column | Description |
|---------|-------------|
| customer_id | Unique customer identifier |
| customer_unique_id | Unique customer across multiple purchases |
| customer_zip_code_prefix | ZIP code prefix |
| customer_city | Customer city |
| customer_state | Customer state |

### Business Usage

- Customer Segmentation
- Geographic Analysis
- Repeat Customer Analysis

---

## 2. Orders Dataset

**File**

```
olist_orders_dataset.csv
```

### Description

Contains complete order lifecycle information.

### Important Columns

| Column | Description |
|---------|-------------|
| order_id | Order identifier |
| customer_id | Customer reference |
| order_status | Order status |
| order_purchase_timestamp | Purchase date |
| order_delivered_customer_date | Delivery date |
| order_estimated_delivery_date | Estimated delivery |

### Business Usage

- Order Analytics
- Delivery Performance
- Sales Trend Analysis

---

## 3. Order Items Dataset

**File**

```
olist_order_items_dataset.csv
```

### Description

Contains product-level order details.

### Important Columns

| Column | Description |
|---------|-------------|
| order_id | Order reference |
| product_id | Purchased product |
| seller_id | Seller identifier |
| price | Product price |
| freight_value | Shipping cost |

### Business Usage

- Revenue Analysis
- Product Performance
- Seller Performance

---

## 4. Products Dataset

**File**

```
olist_products_dataset.csv
```

### Description

Contains product information.

### Important Columns

| Column | Description |
|---------|-------------|
| product_id | Product identifier |
| product_category_name | Product category |
| product_weight_g | Product weight |
| product_length_cm | Length |
| product_height_cm | Height |
| product_width_cm | Width |

### Business Usage

- Product Analytics
- Category Analysis
- Inventory Insights

---

## 5. Sellers Dataset

**File**

```
olist_sellers_dataset.csv
```

### Description

Contains seller information.

### Important Columns

| Column | Description |
|---------|-------------|
| seller_id | Seller identifier |
| seller_city | Seller city |
| seller_state | Seller state |

### Business Usage

- Seller Performance
- Geographic Seller Analysis

---

## 6. Payments Dataset

**File**

```
olist_order_payments_dataset.csv
```

### Description

Contains payment transaction details.

### Important Columns

| Column | Description |
|---------|-------------|
| order_id | Order reference |
| payment_type | Payment method |
| payment_installments | Installments |
| payment_value | Payment amount |

### Business Usage

- Revenue Analytics
- Payment Preference Analysis

---

## 7. Reviews Dataset

**File**

```
olist_order_reviews_dataset.csv
```

### Description

Contains customer ratings and review information.

### Important Columns

| Column | Description |
|---------|-------------|
| review_id | Review identifier |
| order_id | Order reference |
| review_score | Customer rating |
| review_creation_date | Review date |

### Business Usage

- Customer Satisfaction
- Sentiment Analysis
- Product Quality Analysis

---

## 8. Geolocation Dataset

**File**

```
olist_geolocation_dataset.csv
```

### Description

Contains geographic coordinates.

### Important Columns

| Column | Description |
|---------|-------------|
| geolocation_zip_code_prefix | ZIP code |
| geolocation_city | City |
| geolocation_state | State |
| geolocation_lat | Latitude |
| geolocation_lng | Longitude |

### Business Usage

- Geographic Dashboard
- Regional Sales Analysis

---

## 9. Product Category Translation Dataset

**File**

```
product_category_name_translation.csv
```

### Description

Maps Portuguese category names to English.

### Important Columns

| Column | Description |
|---------|-------------|
| product_category_name | Portuguese category |
| product_category_name_english | English category |

### Business Usage

- Dashboard Standardization
- Reporting

---

# Primary Keys

| Dataset | Primary Key |
|----------|-------------|
| Customers | customer_id |
| Orders | order_id |
| Products | product_id |
| Sellers | seller_id |
| Reviews | review_id |

---

# Foreign Key Relationships

| Parent Table | Child Table | Key |
|--------------|------------|-----|
| Customers | Orders | customer_id |
| Orders | Order Items | order_id |
| Orders | Payments | order_id |
| Orders | Reviews | order_id |
| Products | Order Items | product_id |
| Sellers | Order Items | seller_id |

---

# Analytics Modules

The datasets will be used to build:

- Sales Analytics
- Customer Analytics
- Product Analytics
- Seller Analytics
- Marketing Analytics
- Geographic Analytics
- Growth Analytics
- Executive KPI Dashboard

---

# Conclusion

The Olist dataset provides a complete relational data model for building an end-to-end Business Intelligence Platform. It enables advanced SQL analysis, Python-based analytics, customer segmentation, and interactive dashboards while closely resembling real-world business data.