-- Task
/*
Background:
You are provided with a simplified database schema related to a fintech startup that issues debit cards and processes transactions. The database contains the following tables:

1. Customers
    - customer_id (Primary Key)
    - country
    - name
    - email
    - signup_date
2. Cards
    - card_id (Primary Key)
    - customer_id (Foreign Key)
    - card_number
    - activation_date
    - expiry_date
    - status (Active, Inactive)
3. Transactions
    - transaction_id (Primary Key)
    - card_id (Foreign Key)
    - transaction_date
    - amount
    - merchant_name
    - transaction_type (Purchase, Withdrawal, Refund)
    - country
*/

-- Assumptions
/*
- Card can be inactive before expiration date
- Refunds count as negative value to total amount
*/

-- Create Tables 
CREATE TABLE IF NOT EXISTS Customers (
    customer_id INT PRIMARY KEY,
    country VARCHAR,
    name VARCHAR,
    email VARCHAR,
    signup_date DATE
);

TRUNCATE TABLE Customers CASCADE;

CREATE TABLE IF NOT EXISTS Cards (
    card_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES Customers(customer_id),
    card_number VARCHAR,
    activation_date DATE,
    expiry_date DATE,
    status VARCHAR CHECK (status IN ('Active', 'Inactive'))
);

TRUNCATE TABLE Cards CASCADE;

CREATE TABLE IF NOT EXISTS Transactions (
    transaction_id SERIAL PRIMARY KEY,
    card_id INT REFERENCES Cards(card_id),
    transaction_date DATE,
    amount NUMERIC,
    merchant_name VARCHAR,
    transaction_type VARCHAR CHECK (transaction_type IN ('Purchase', 'Withdrawal', 'Refund')),
    country VARCHAR
);

TRUNCATE TABLE Transactions CASCADE;

-- Add sample data
INSERT INTO Customers (customer_id, country, name, email, signup_date)
VALUES 
    (134541, 'USA', 'Bob Doe', 'bob@example.com', '2023-01-15'),
    (129342, 'UK', 'Alice Brown', 'alice@example.com', '2023-02-20'),
    (148583, 'France', 'Jean Green', 'jean@example.com', '2023-03-10')
ON CONFLICT (customer_id) DO NOTHING;

-- If it is possible, cards numbers can be represented as **nn to be more secured
INSERT INTO Cards (card_id, customer_id, card_number, activation_date, expiry_date, status)
VALUES 
    (1856451, 134541, '4539156775826547', '2023-01-20', '2025-01-20', 'Active'),
    (1353752, 129342, '5297543019876543', '2023-02-25', '2024-02-25', 'Active'),
    (1947463, 148583, '4916398223459876', '2023-03-15', '2027-03-15', 'Active'),
    (1454684, 134541, '5432167890123456', '2022-04-01', '2024-04-01', 'Inactive'),
    (1947575, 129342, '4028371456897321', '2021-05-05', '2025-05-05', 'Active'),
    (1464756, 148583, '5123987654321098', '2022-06-10', '2024-06-10', 'Inactive')
ON CONFLICT (card_id) DO NOTHING;

INSERT INTO Transactions (transaction_id, card_id, transaction_date, amount, merchant_name, transaction_type, country)
VALUES 
    (1464758571, 1856451, '2023-01-25', 50.00, 'Online Store', 'Purchase', 'USA'),
    (1565739562, 1353752, '2023-02-28', 25.00, 'Coffee Shop', 'Purchase', 'UK'),
    (1837565733, 1947463, '2023-03-20', 100.00, 'Supermarket', 'Purchase', 'France'),
    (1938565254, 1856451, '2023-01-28', 100.00, 'Electronics Store', 'Purchase', 'USA'),
    (1475692695, 1353752, '2023-03-01', 50.00, 'Grocery Store', 'Purchase', 'Germany'),
    (1192836566, 1947463, '2023-04-05', 75.00, 'Gas Station', 'Purchase', 'France'),
    (1459373477, 1856451, '2023-02-05', 20.00, 'ATM Withdrawal', 'Withdrawal', 'USA'),
    (1338586068, 1353752, '2023-03-10', 15.00, 'Online Subscription', 'Purchase', 'UK'),
    (1284575579, 1947463, '2023-05-20', 10.00, 'Clothing Store', 'Purchase', 'Germany'),
    (1585768410, 1856451, '2023-03-15', 30.00, 'Refund', 'Refund', 'USA'),
    (1393857511, 1353752, '2023-04-20', 40.00, 'Restaurant', 'Purchase', 'UK'),
    (1557574812, 1947463, '2023-06-01', 60.00, 'Electronics Store', 'Purchase', 'France')
ON CONFLICT (transaction_id) DO NOTHING;

-- Task 1. Customer Insights 
-- - Retrieve a list of all customers who signed up in the last 30 days.
SELECT 
    customer_id, 
    signup_date
FROM customers
--WHERE signup_date BETWEEN now() - interval '1 month' AND now();
WHERE signup_date BETWEEN date '2023-03-30' - interval '1 month' AND date '2023-03-30';

-- - Find the total number of active cards per customer.
SELECT 
    customer_id, 
    COUNT(status = 'Active' OR NULL) AS active_cards
FROM cards
GROUP BY customer_id;

-- Task 2. Transaction Analysis
-- - Calculate the total transaction amount and the average transaction amount per card in the last month.
SELECT 
    cards.card_id, 
    SUM(amount) FILTER(WHERE transaction_type != 'Refund') AS non_refund_total_amount, 
    AVG(amount) FILTER(WHERE transaction_type != 'Refund') AS non_refund_avg_amount, 
    COALESCE(SUM(amount) FILTER(WHERE transaction_type != 'Refund'), 0) - COALESCE(SUM(amount) FILTER(WHERE transaction_type = 'Refund'), 0) AS total_amount,
    COALESCE(AVG(amount) FILTER(WHERE transaction_type != 'Refund'), 0) - COALESCE(AVG(amount) FILTER(WHERE transaction_type = 'Refund'), 0) AS avg_amount
FROM cards
LEFT JOIN transactions 
    ON transactions.card_id = cards.card_id
--WHERE transaction_date BETWEEN now() - interval '1 month' AND now();
WHERE transaction_date BETWEEN date '2023-03-30' - interval '1 month' AND date '2023-03-30'
GROUP BY cards.card_id;

-- - Identify the top 5 merchants by the number of transactions processed in the last month.
SELECT 
    merchant_name,
    COUNT(*) AS transactions_num
FROM transactions 
--WHERE transaction_date BETWEEN now() - interval '1 month' AND now();
WHERE transaction_date BETWEEN date '2023-03-30' - interval '1 month' AND date '2023-03-30'
GROUP BY merchant_name
ORDER BY transactions_num DESC
LIMIT 5;

-- Task 3. Card Usage
-- - Determine the number of cards that have not been used for transactions in the last 60 days.
-- Option 1
SELECT
    COUNT(DISTINCT c.card_id) AS card_num
FROM cards AS c
WHERE NOT EXISTS (SELECT card_id FROM transactions AS t
        --WHERE transaction_date BETWEEN now() - interval '2 months' AND now()
        WHERE transaction_date BETWEEN date '2023-03-30' - interval '2 months' AND date '2023-03-30'
            AND c.card_id = t.card_id);

-- Option 2
SELECT
    COUNT(DISTINCT c.card_id) AS card_num
FROM cards AS c
LEFT JOIN (SELECT card_id FROM transactions AS t
        --WHERE transaction_date BETWEEN now() - interval '2 months' AND now()
        WHERE transaction_date BETWEEN date '2023-03-30' - interval '2 months' AND date '2023-03-30') AS t
    ON c.card_id = t.card_id
WHERE t.card_id IS NULL;

-- - List all customers who have made international transactions (transactions in a country different from their residence) in the last month.
SELECT 
    customers.customer_id
FROM transactions 
LEFT JOIN cards 
    ON cards.card_id = transactions.card_id 
LEFT JOIN customers 
    ON customers.customer_id = cards.customer_id
--WHERE transaction_date BETWEEN now() - interval '1 month' AND now()
WHERE transaction_date BETWEEN date '2023-03-30' - interval '1 month' AND date '2023-03-30'
    AND transactions.country != customers.country;


-- Task 4. Bonus Challenge (Optional)
-- - For each customer, calculate the month-over-month percentage change in spending. Consider the last 3 months for this analysis.
-- Option 1
SELECT 
    customers.customer_id, 
    date_trunc('month', transaction_date) AS month,
    COALESCE(SUM(amount) FILTER(WHERE transaction_type != 'Refund'), 0) - COALESCE(SUM(amount) FILTER(WHERE transaction_type = 'Refund'), 0) AS amount,
    LAG(COALESCE(SUM(amount) FILTER(WHERE transaction_type != 'Refund'), 0) - COALESCE(SUM(amount) FILTER(WHERE transaction_type = 'Refund'), 0)) OVER (PARTITION BY customers.customer_id ORDER BY date_trunc('month', transaction_date)) AS prev_month_amount,
    COALESCE(SUM(amount) FILTER(WHERE transaction_type != 'Refund'), 0) - COALESCE(SUM(amount) FILTER(WHERE transaction_type = 'Refund'), 0) - LAG(COALESCE(SUM(amount) FILTER(WHERE transaction_type != 'Refund'), 0) - COALESCE(SUM(amount) FILTER(WHERE transaction_type = 'Refund'), 0)) OVER (PARTITION BY customers.customer_id ORDER BY date_trunc('month', transaction_date)) AS amount_change,
    ROUND((COALESCE(SUM(amount) FILTER(WHERE transaction_type != 'Refund'), 0) - COALESCE(SUM(amount) FILTER(WHERE transaction_type = 'Refund'), 0) - LAG(COALESCE(SUM(amount) FILTER(WHERE transaction_type != 'Refund'), 0) - COALESCE(SUM(amount) FILTER(WHERE transaction_type = 'Refund'), 0)) OVER (PARTITION BY customers.customer_id ORDER BY date_trunc('month', transaction_date))) /
    	(COALESCE(SUM(amount) FILTER(WHERE transaction_type != 'Refund'), 0) - COALESCE(SUM(amount) FILTER(WHERE transaction_type = 'Refund'), 0)) * 100, 2) AS percentage_change
FROM transactions 
LEFT JOIN cards 
    ON cards.card_id = transactions.card_id 
LEFT JOIN customers 
    ON customers.customer_id = cards.customer_id
WHERE transaction_date BETWEEN now() - interval '3 months' AND now()
--WHERE transaction_date BETWEEN date '2023-03-30' - interval '3 months' AND date '2023-03-30'
    AND transactions.transaction_type != 'Refund'
GROUP BY customers.customer_id, date_trunc('month', transaction_date);


-- Option 2 (may be slower, but readable with CTE, can be transfered into DWH)
WITH month_by_month AS 
(SELECT 
    customers.customer_id, 
    date_trunc('month', transaction_date) AS month,
    COALESCE(SUM(amount) FILTER(WHERE transaction_type != 'Refund'), 0) - COALESCE(SUM(amount) FILTER(WHERE transaction_type = 'Refund'), 0) AS amount,
    LAG(COALESCE(SUM(amount) FILTER(WHERE transaction_type != 'Refund'), 0) - COALESCE(SUM(amount) FILTER(WHERE transaction_type = 'Refund'), 0)) OVER (PARTITION BY customers.customer_id ORDER BY date_trunc('month', transaction_date)) AS prev_month_amount
FROM transactions 
LEFT JOIN cards 
    ON cards.card_id = transactions.card_id 
LEFT JOIN customers 
    ON customers.customer_id = cards.customer_id
WHERE transaction_date BETWEEN now() - interval '3 months' AND now()
--WHERE transaction_date BETWEEN date '2023-03-30' - interval '3 months' AND date '2023-03-30'
    AND transactions.transaction_type != 'Refund'
GROUP BY customers.customer_id, date_trunc('month', transaction_date))

SELECT 
	customer_id, 
    month, 
    ROUND((amount - prev_month_amount) / amount * 100, 2) AS percentage_change 
FROM month_by_month;
