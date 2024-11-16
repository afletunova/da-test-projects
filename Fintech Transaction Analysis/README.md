## Overview
This project is a simplified database schema designed for a fintech startup that issues debit cards and processes transactions. The goal is to analyze customer insights, transaction patterns, and card usage to enhance business decision-making and improve customer experience.

The database consists of three main tables:

- **Customers**: Stores information about customers, including their unique IDs, country, name, email, and signup date.
- **Cards**: Contains details of debit cards issued to customers, including card IDs, customer IDs, card numbers, activation and expiry dates, and card status (Active or Inactive).
- **Transactions**: Records all transactions made with the debit cards, capturing transaction IDs, card IDs, transaction dates, amounts, merchant names, transaction types (Purchase, Withdrawal, Refund), and transaction countries.

## Tasks
The project includes several SQL queries to solve various business problems. The queries are designed to extract insights from the database.

### Customer Insights
- Retrieve a list of customers who signed up in the last 30 days.
- Count the total number of active cards per customer.

### Transaction Analysis
- Calculate total and average transaction amounts per card for the last month.
- Identify the top 5 merchants by the number of transactions processed in the last month.

### Card Usage
- Determine the number of cards that have not been used for transactions in the last 60 day.
- List customers who made international transactions in the last month.

### Bonus Challenge
Calculate month-over-month percentage change in spending for each customer over the last three months.

## SQL Scripts
The SQL scripts included in this project are well-commented and optimized for performance, ensuring data privacy and security. The queries are structured to provide clear insights while maintaining efficient database operations.