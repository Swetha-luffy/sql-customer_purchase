# SQL-Based Analysis of Customer Purchases and Membership Trends in a Restaurant

# Project Overview

This project explores customer purchase patterns, menu pricing, and membership trends using SQL. The dataset includes customer orders, menu items, and membership details for a restaurant. The analysis provides insights into customer behavior, order frequencies, and the impact of memberships on purchases.

# Dataset Structure

Sales Table: Tracks each customer's order, including the product purchased and the date of purchase.

Menu Table: Contains details of the restaurant’s menu items and their prices.

Members Table: Tracks the customers who have joined the restaurant's membership program along with their join dates.


## Setup Instructions
1. Create the database and switch to it:
   ```sql
   CREATE DATABASE restaurant;
   USE restaurant;
   ```
   
2. Run the provided SQL scripts to create tables and insert sample data.

# Analytical Queries
The project includes several analytical queries that answer specific business questions:

1. Total amount spent by each customer

2 Number of days each customer visited the restaurant
 
3. First item purchased by each customer
  
4. Most purchased item on the menu
  
5. Most popular item for each customer
   
6. First item purchased by customers after becoming members
 
7. Item purchased just before customers became members
 
8. Total items and amount spent by each member before joining
 
9. Customer points calculation (with special rules for sushi)
 
10. Points calculation for the first week of membership (with bonus points)
    

#  How to Use

1. Set up the database and tables using the provided SQL scripts.
   
2. Run each analytical query separately to get insights into different aspects of the restaurant's sales and customer behavior.

# Notes
- Ensure you have MySQL installed and running on your system.
- Adjust date ranges in queries if analyzing data beyond January 2021.
- Some queries use advanced SQL features like window functions and CTEs.

# Future Improvements
- Add more data for a broader analysis
- Create visualizations based on the query results
- Implement a scheduling system to run these analyses periodically
