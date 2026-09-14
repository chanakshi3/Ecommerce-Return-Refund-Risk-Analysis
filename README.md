# Ecommerce-Return-Refund-Risk-Analysis
SQL-based analysis of ecommerce returns, refunds, customers, products and return risk using MySQL.
## Project Objective
This project analyzes ecommerce orders, returns and refunds using MySQL to identify products, categories and customers associated with high return and refund risk.
## Business Problem
E-commerce companies can lose revenue through product returns, refunds, reverse logistics and repeated operational handling. Looking only at total sales does not 
explain where these losses are coming from. The business therefore needs an analytical approach to identify which products and categories have high return rates,
which return reasons occur most frequently, where refund exposure is concentrated and whether particular customers or regions show unusual return behavior.

## Dataset
The dataset contains approximately 20,000 ecommerce records covering:
- Customers
- Orders
- Products
- Returns
- Refunds

## Tools Used
- MySQL
- MySQL Workbench

## SQL Techniques Used
- SELECT
- WHERE
- GROUP BY
- HAVING
- JOIN
- LEFT JOIN
- CASE WHEN
- Aggregate Functions
- Subqueries
- Window Functions
- RANK()
- Data Cleaning
- Data Validation

## Data Cleaning
The dataset contained issues such as:
- Duplicate records
- Missing values
- Invalid values
- Inconsistent data
- Duplicate customer IDs
- Data validation issues
These issues were identified and cleaned before performing the business analysis.

## Analysis Performed
- Analyzed overall orders, returns and total refund amounts.
- Analyzed return reasons to identify the most common causes of product returns.
- Calculated return rates by product category and subcategory.
- Identified products with higher return rates and products generating the highest refund amounts.
- Analyzed customer return behavior and identified high-return customers.
- Analyzed the relationship between discount levels and product return rates.
- Analyzed return patterns by payment method, shipping method and customer city.
- Analyzed monthly return and refund trends to identify changes over time.
- Ranked customers based on their return rates using SQL window functions.
- Classified customers and products into Low, Medium and High return-risk levels.

  ## Key Insights
1. Overall Return Performance
The project analyzed 19,143 usable orders, of which 6,153 were returned, resulting in an overall return rate of 32.14%.
This indicates that returns are a significant operational issue and should be tracked as an important business KPI.
2. Return Reasons
Size Issue (1,117 returns) was the most common reason, followed closely by Damaged (1,101 returns).
This suggests opportunities to improve product sizing information and packaging/handling processes to reduce avoidable returns.
3. Category Return Risk
Home & Kitchen had the highest return rate at 33.34%, followed by Toys at 32.62%; Electronics had a 31.66% return rate.
The business should drill down into individual SKUs within high-return categories to identify the specific products driving the problem.
4. Product Return Risk
Several products showed return rates above 50%, with the highest reaching 59.52% among products having at least 10 orders.
These high-risk SKUs should be investigated for product quality, inaccurate descriptions, sizing issues, packaging or customer-experience problems.
5. Customer Return Behaviour
Most customers were classified as Low Risk, while a smaller group was classified as Medium Risk based on return frequency and return rate.
This indicates that return behavior is concentrated among a relatively small set of customers who can be monitored more closely.
6. Discount vs Return Behaviour 
Orders without discounts had a 30.89% return rate, while discounted orders ranged from about 31.78% to 32.72%.
The differences are relatively small, so the analysis does not show a strong relationship between discount level and return rate.
7. Refund Impact
The project recorded approximately ₹5.29 crore in total refunds, with an average refund of about ₹8,595 per returned order.
Electronics had the highest category refund exposure, showing that financial impact should be analyzed alongside return frequency.
8. Customer Risk Classification
Customers were classified using SQL business rules based on minimum return count and return-rate thresholds, helping prioritize customers for investigation.
The classification is a rule-based prioritization method, not a machine-learning or fraud-detection model.
9. Monthly Return & Refund Trends
Monthly returns fluctuated over the analysis period, with May 2024 recording the highest number of returns at 287, while refund values varied considerably by month. This shows the importance of monitoring both return volume and refund value over time to identify periods requiring further investigation.

## Business Recommendations
1. Reduce Size-Related Returns: Improve size charts, product measurements, fit information and product descriptions to reduce returns caused by Size Issues.
2. Reduce Damaged-Product Returns: Review packaging, warehouse handling and shipping processes to identify and reduce the causes of damaged-product returns.
3. Investigate High-Risk Products: Focus on SKUs with unusually high return rates and investigate product quality, descriptions, sizing and customer complaints.
4. Monitor High-Refund Categories: Give additional attention to Electronics and other categories with high refund exposure to control financial impact from expensive returns.
5. Monitor High-Risk Customers: Use return frequency and return-rate rules to identify customers with repeated returns and prioritize them for further review.
6. Track Refund Exceptions: Review unusually high refund amounts as exception cases to identify expensive returns, processing issues or possible data-quality problems.
7. Monitor Geographic Trends: Investigate cities with higher return rates to understand whether product mix, logistics, shipping performance or customer behavior is contributing to the difference.
8. Continuous Monitoring: Connect the cleaned SQL data to Power BI and create a dashboard to monitor return rate, refund value, return reasons, product risk and monthly trends regularly.

## Conclusion
This project used MySQL to transform unclean e-commerce transactional data into a structured analysis of returns and refunds. The analysis identified important patterns across return reasons, categories, products, customers, discounts, refunds and monthly trends.
The project found a 32.14% overall return rate, with Size Issue and Damaged as major return reasons, Home & Kitchen showing the highest category return rate and Electronics contributing the highest refund exposure. These findings were converted into practical recommendations to reduce avoidable returns, control refund costs and prioritize high-risk areas for business investigation.
