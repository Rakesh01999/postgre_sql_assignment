-- Active: 1743601378217@@127.0.0.1@5432@bookstore_db


-- DATABASE CREATION
--  a new database named "bookstore_db" created

-- TABLE CREATION
-- 1. Create the "books" table
CREATE TABLE books (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) CHECK (price >= 0) NOT NULL,
    stock INTEGER NOT NULL,
    published_year INTEGER NOT NULL
);

-- 2. Create the "customers" table
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    joined_date DATE DEFAULT CURRENT_DATE
);

-- 3. Create the "orders" table with foreign key constraints
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers (id),
    book_id INTEGER REFERENCES books (id),
    quantity INTEGER CHECK (quantity > 0) NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- DATA INSERTION
-- 1. Insert sample data into the "books" table
INSERT INTO books (id, title, author, price, stock, published_year) VALUES
    (1, 'The Pragmatic Programmer', 'Andrew Hunt', 40.00, 10, 1999),
    (2, 'Clean Code', 'Robert C. Martin', 35.00, 5, 2008),
    (3, 'You Don''t Know JS', 'Kyle Simpson', 30.00, 8, 2014),
    (4, 'Refactoring', 'Martin Fowler', 50.00, 3, 1999),
    (5, 'Database Design Principles', 'Jane Smith', 20.00, 0, 2018);

-- 2. Insert sample data into the "customers" table
INSERT INTO customers (id, name, email, joined_date) VALUES
    (1, 'Alice', 'alice@email.com', '2023-01-10'),
    (2, 'Bob', 'bob@email.com', '2022-05-15'),
    (3, 'Charlie', 'charlie@email.com', '2023-06-20');

-- 3. Insert sample data into the "orders" table
INSERT INTO orders (id, customer_id, book_id, quantity, order_date) VALUES
    (1, 1, 2, 1, '2024-03-10'),
    (2, 2, 1, 1, '2024-02-20'),
    (3, 1, 3, 2, '2024-03-05');




SELECT * FROM books ORDER BY id ASC;
SELECT * FROM customers;
SELECT * FROM orders;

-- DROP a table
-- DROP TABLE books;
-- DROP TABLE customers;
-- DROP TABLE orders;

-- POSTGRESQL QUERIES

-- 1. Find books that are out of stock
-- This Query selects the titles of the books with zero stock
SELECT title FROM books WHERE stock = 0;

-- 2. Retrieve the most expensive book in the store
-- This query returns all details of the book with the highest price
SELECT * FROM books ORDER BY price DESC LIMIT 1;

-- 3. Find the total number of orders placed by each customer
-- This query counts the number of orders for each customer using a LEFT JOIN to include all customers
-- even if they have not placed any orders
SELECT customers.name, COUNT(orders.id) AS total_orders
FROM customers
    LEFT JOIN orders ON customers.id = orders.customer_id
-- GROUP BY customers.name;
GROUP BY customers.id, customers.name;


-- 4. Calculate the total revenue generated from book sales
-- This query calculates revenue by multiplying the book price by the order quantity
-- and summing these values across all orders
SELECT SUM(books.price * orders.quantity) AS total_revenue
FROM orders
    JOIN books ON orders.book_id = books.id;

-- 5. List all customers who have placed more than one order
-- This query identifies customers with multiple orders by counting orders per customer
-- and filtering using the HAVING clause to show only those with more than one order
SELECT customers.name, COUNT(orders.id) AS orders_count
FROM customers
    JOIN orders ON customers.id = orders.customer_id
GROUP BY
    customers.name
HAVING
    COUNT(orders.id) > 1;

-- 6. Find the average price of books in the store
-- This query calculates the mean price across all books in the inventory
-- and rounds the result to 2 decimal places for proper currency representation
SELECT ROUND(AVG(price), 2) AS average_book_price FROM books;

-- 7. Increase the price of all books published before 2000 by 10%
-- This query updates the price field for older books by multiplying their current price
--  "increase by 10%" mean? =>
-- It means you're adding 10 percent of the current price to the current price.
-- Let ,
-- If a book's price is ৳100,
-- → 10% of 100 = ৳10
-- → New price = ৳100 + ৳10 = ৳110
-- by a factor of 1.1 (representing a 10% increase)
UPDATE books SET price = price * 1.1 WHERE published_year < 2000;

-- 8. Delete customers who haven't placed any orders
-- This query removes customer records that have no corresponding entries in the orders table
-- by using a subquery to identify customers who have placed at least one order
DELETE FROM customers
WHERE
    id NOT IN (
        SELECT DISTINCT
            customer_id
        FROM orders
    );

-- Verify updates after operations

-- Check updated book prices after applying the 10% price increase, (randomly)
SELECT * FROM books;
-- Check updated book prices after applying the 10% price increase, (by ascending order of id)
SELECT * FROM books ORDER BY id ASC;

-- Check remaining customers after deleting those with no orders
SELECT * FROM customers;
