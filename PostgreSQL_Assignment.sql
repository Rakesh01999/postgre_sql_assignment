-- Active: 1743601378217@@127.0.0.1@5432@bookstore_db

-- PostgreSQL Bookstore Database Assignment

-- DATABASE CREATION
-- Create a new database named "bookstore_db"
-- Note: Run this command from a connection to any database other than the one you're creating
-- CREATE DATABASE bookstore_db;
-- Then connect to the newly created database

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
    customer_id INTEGER REFERENCES customers(id),
    book_id INTEGER REFERENCES books(id),
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
-- DROP TABLE orders;



-- POSTGRESQL QUERIES

-- 1. Find books that are out of stock
-- This Query selects the titles of the books with zero stock
SELECT title
FROM books
WHERE stock = 0;

-- 2. Retrieve the most expensive book in the store
-- This query returns all details of the book with the highest price
SELECT *
FROM books
ORDER BY price DESC
LIMIT 1;

-- 3. Find the total number of orders placed by each customer
-- This query counts the number of orders for each customer
SELECT c.name, COUNT(o.id) AS total_orders
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
GROUP BY c.name;

-- 4. Calculate the total revenue generated from book sales
-- This query multiplies book price by order quantity and sums the results
SELECT SUM(b.price * o.quantity) AS total_revenue
FROM orders o
JOIN books b ON o.book_id = b.id;

-- 5. List all customers who have placed more than one order
-- This query counts orders per customer and filters those with more than one
SELECT c.name, COUNT(o.id) AS orders_count
FROM customers c
JOIN orders o ON c.id = o.customer_id
GROUP BY c.name
HAVING COUNT(o.id) > 1;

-- 6. Find the average price of books in the store
-- This query calculates the average price across all books
SELECT ROUND(AVG(price), 2) AS avg_book_price
FROM books;

-- 7. Increase the price of all books published before 2000 by 10%
-- This query updates the prices of books published before 2000
UPDATE books
SET price = price * 1.1
WHERE published_year < 2000;

-- 8. Delete customers who haven't placed any orders
-- This query removes customers with no associated orders
DELETE FROM customers
WHERE id NOT IN (
    SELECT DISTINCT customer_id
    FROM orders
);

-- Verify updates after operations

-- Check updated book prices after applying 10% increase
SELECT * FROM books;

-- Check remaining customers after deletion
SELECT * FROM customers;
