# PostgreSQL Bookstore Database Assignment

This repository contains the solution for the PostgreSQL database assignment. The project involves creating and managing a bookstore database with three tables (books, customers, orders), inserting sample data, and performing various SQL operations to manipulate and retrieve data.

## Table of Contents
- [Assignment Objective](#assignment-objective)
- [Database Setup](#database-setup)
- [Table Creation](#table-creation)
- [Sample Data](#sample-data)
- [PostgreSQL Problems & Solutions](#postgresql-problems--solutions)
- [Bonus Section: PostgreSQL Q&A](#bonus-section-postgresql-qa)

## Assignment Objective

This assignment focuses on PostgreSQL database operations. The task involves creating and managing three tables (books, customers, orders), inserting sample data, and performing essential SQL queries. Key tasks include CRUD operations, constraints, JOINs, aggregations, filtering, and data manipulation to reinforce understanding of relational databases.

## Database Setup

1. Install PostgreSQL on your system if it is not already installed.
2. Open pgAdmin or your PostgreSQL terminal.
3. Create a new database named "bookstore_db".
4. Connect to the newly created database.

```sql
-- Create and connect to database
CREATE DATABASE bookstore_db;
\c bookstore_db
```

## Table Creation

### 1. Books Table

```sql
CREATE TABLE books (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) CHECK (price >= 0) NOT NULL,
    stock INTEGER NOT NULL,
    published_year INTEGER NOT NULL
);
```

### 2. Customers Table

```sql
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    joined_date DATE DEFAULT CURRENT_DATE
);
```

### 3. Orders Table

```sql
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers (id),
    book_id INTEGER REFERENCES books (id),
    quantity INTEGER CHECK (quantity > 0) NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## Sample Data

### Books Table Data

```sql
INSERT INTO books (id, title, author, price, stock, published_year) VALUES
    (1, 'The Pragmatic Programmer', 'Andrew Hunt', 40.00, 10, 1999),
    (2, 'Clean Code', 'Robert C. Martin', 35.00, 5, 2008),
    (3, 'You Don''t Know JS', 'Kyle Simpson', 30.00, 8, 2014),
    (4, 'Refactoring', 'Martin Fowler', 50.00, 3, 1999),
    (5, 'Database Design Principles', 'Jane Smith', 20.00, 0, 2018);
```

### Customers Table Data

```sql
INSERT INTO customers (id, name, email, joined_date) VALUES
    (1, 'Alice', 'alice@email.com', '2023-01-10'),
    (2, 'Bob', 'bob@email.com', '2022-05-15'),
    (3, 'Charlie', 'charlie@email.com', '2023-06-20');
```

### Orders Table Data

```sql
INSERT INTO orders (id, customer_id, book_id, quantity, order_date) VALUES
    (1, 1, 2, 1, '2024-03-10'),
    (2, 2, 1, 1, '2024-02-20'),
    (3, 1, 3, 2, '2024-03-05');
```

## PostgreSQL Problems & Solutions

### 1. Find books that are out of stock

This query selects the titles of books with zero stock.

```sql
SELECT title FROM books WHERE stock = 0;
```

**Sample Output:**
```
title
----------------------------
Database Design Principles
```

### 2. Retrieve the most expensive book in the store

This query returns all details of the book with the highest price.

```sql
SELECT * FROM books ORDER BY price DESC LIMIT 1;
```

**Sample Output:**
```
| id  | title       | author        | price | stock | published_year |
| --- | ----------- | ------------- | ----- | ----- | -------------- |
| 4   | Refactoring | Martin Fowler | 50.00 | 3     | 1999           |
```

### 3. Find the total number of orders placed by each customer

This query counts the number of orders for each customer using a LEFT JOIN to include all customers even if they have not placed any orders.

```sql
SELECT customers.name, COUNT(orders.id) AS total_orders
FROM customers
    LEFT JOIN orders ON customers.id = orders.customer_id
GROUP BY customers.id, customers.name;
```

**Sample Output:**
```
| name    | total_orders |
| ------- | ------------ |
| Alice   | 2            |
| Bob     | 1            |
| Charlie | 0            |
```

### 4. Calculate the total revenue generated from book sales

This query calculates revenue by multiplying the book price by the order quantity and summing these values across all orders.

```sql
SELECT SUM(books.price * orders.quantity) AS total_revenue
FROM orders
    JOIN books ON orders.book_id = books.id;
```

**Sample Output:**
```
total_revenue
-----------------
135.00
```

### 5. List all customers who have placed more than one order

This query identifies customers with multiple orders by counting orders per customer and filtering using the HAVING clause to show only those with more than one order.

```sql
SELECT customers.name, COUNT(orders.id) AS orders_count
FROM customers
    JOIN orders ON customers.id = orders.customer_id
GROUP BY
    customers.name
HAVING
    COUNT(orders.id) > 1;
```

**Sample Output:**
```
| name    | orders_count |
| ------- | ------------ |
| Alice   | 2            |
```

### 6. Find the average price of books in the store

This query calculates the mean price across all books in the inventory and rounds the result to 2 decimal places for proper currency representation.

```sql
SELECT ROUND(AVG(price), 2) AS average_book_price FROM books;
```

**Sample Output:**
```
average_book_price
----------------------------
35.00
```

### 7. Increase the price of all books published before 2000 by 10%

This query updates the price field for older books by multiplying their current price by a factor of 1.1 (representing a 10% increase).

```sql
UPDATE books SET price = price * 1.1 WHERE published_year < 2000;
```

**Sample Output after update:**
```
| id  | title                        | author             | price  | stock | published_year |
|-----|------------------------------|--------------------|--------|-------|----------------|
| 1   | The Pragmatic Programmer     | Andrew Hunt        | 44.00  | 10    | 1999           |
| 2   | Clean Code                   | Robert C. Martin   | 35.00  | 5     | 2008           |
| 3   | You Don't Know JS            | Kyle Simpson       | 30.00  | 8     | 2014           |
| 4   | Refactoring                  | Martin Fowler      | 55.00  | 3     | 1999           |
| 5   | Database Design Principles   | Jane Smith         | 20.00  | 0     | 2018           |
```

### 8. Delete customers who haven't placed any orders

This query removes customer records that have no corresponding entries in the orders table by using a subquery to identify customers who have placed at least one order.

```sql
DELETE FROM customers
WHERE
    id NOT IN (
        SELECT DISTINCT
            customer_id
        FROM orders
    );
```

**Sample Output after deletion:**
```
| id  | name    | email              | joined_date  |
| --- | ------- | ------------------ | ------------ |
| 1   | Alice   | alice@email.com    | 2023-01-10   |
| 2   | Bob     | bob@email.com      | 2022-05-15   |
```

## Bonus Section: PostgreSQL Q&A

### ১. What is PostgreSQL?(PostgreSQL কী?)
PostgreSQL হল একটি শক্তিশালী, ওপেন-সোর্স অবজেক্ট-রিলেশনাল ডাটাবেস ম্যানেজমেন্ট সিস্টেম (ORDBMS)। এটি ৩০ বছরেরও বেশি সময় ধরে বিকশিত হয়েছে এবং বিশ্বসেরা ডাটাবেস সিস্টেমগুলোর মধ্যে একটি। PostgreSQL SQL মানদণ্ড অনুসরণ করে এবং উন্নত বৈশিষ্ট্য যেমন কাস্টম টাইপ, টেবিল ইনহেরিটেন্স, ইভেন্ট-ভিত্তিক ট্রিগার, এবং জটিল কোয়েরি সমর্থন করে। এটি ডাটা সম্পূর্ণতা নিশ্চিত করতে ACID (Atomicity, Consistency, Isolation, Durability) বৈশিষ্ট্য উপস্থাপন করে।

### ২. What is the purpose of a database schema in PostgreSQL ?(PostgreSQL-এ ডাটাবেস স্কিমার উদ্দেশ্য কী?)
একটি ডাটাবেস স্কিমা হল ডাটাবেসের কাঠামোর একটি লজিকাল সংগঠন যা টেবিল, ভিউ, ইনডেক্স, সিকোয়েন্স, ডাটা টাইপ, ফাংশন, অপারেটর এবং অন্যান্য অবজেক্টগুলির গ্রুপিং নির্দেশ করে। এটির উদ্দেশ্যগুলি হল:

- **সংগঠন**: সম্পর্কিত অবজেক্টগুলিকে একসাথে গ্রুপ করা
- **সুরক্ষা**: ডাটার অ্যাক্সেস নিয়ন্ত্রণ করা
- **ন্যামস্পেস বিভাজন**: একই নামের অবজেক্টগুলিকে আলাদা করা 
- **পরিচালনা**: পরিষেবাগুলির প্রশাসন সহজ করা
- **ইস্কিমা মডিউলারিটি**: কোডবেসকে ছোট, পরিচালনযোগ্য অংশে বিভক্ত করা

PostgreSQL-এ স্কিমা ডাটাবেস অবজেক্টগুলির জন্য একটি লজিকাল কন্টেইনার প্রদান করে এবং দলগত প্রজেক্টে কাজ করার সময় এটি বিশেষভাবে উপযোগী।

### ৩. Explain the Primary Key and Foreign Key concepts in PostgreSQL.(PostgreSQL-এ প্রাইমারি কী এবং ফরেন কী ধারণাগুলি ব্যাখ্যা করুন।)
**প্রাইমারি কী (Primary Key):**
- টেবিলের প্রতিটি রেকর্ডকে অনন্যভাবে চিহ্নিত করে
- টেবিলে নাল বা ডুপ্লিকেট মান থাকতে পারে না
- সাধারণত ইনডেক্স করা হয় দ্রুত অ্যাক্সেসের জন্য
- প্রতিটি টেবিলে সর্বাধিক একটি প্রাইমারি কী থাকতে পারে
- উদাহরণ: 
```sql
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100)
);
```

**ফরেন কী (Foreign Key):**
- অন্য টেবিলের প্রাইমারি কী বা অনন্য কলামের উল্লেখ করে 
- টেবিলগুলির মধ্যে সম্পর্ক তৈরি করে
- রেফারেনশিয়াল ইন্টিগ্রিটি বজায় রাখে
- উদাহরণ:
```sql
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(id),
    order_date DATE
);
```

ফরেন কী সম্পর্কগুলি নিশ্চিত করে যে টেবিলগুলি সঠিকভাবে সংযুক্ত আছে এবং অবৈধ ডাটা যোগ না করার মাধ্যমে ডাটাবেসের অখন্ডতা রক্ষা করে।

### ৪. What is the difference between the VARCHAR and CHAR data types?(VARCHAR এবং CHAR ডাটা টাইপের মধ্যে পার্থক্য কী?)

| বৈশিষ্ট্য | VARCHAR | CHAR |
|---------|---------|------|
| **সংজ্ঞা** | পরিবর্তনশীল দৈর্ঘ্যের স্ট্রিং | নির্দিষ্ট দৈর্ঘ্যের স্ট্রিং |
| **স্টোরেজ** | শুধুমাত্র প্রয়োজনীয় স্থান ব্যবহার করে | সবসময় নির্দিষ্ট দৈর্ঘ্য ব্যবহার করে |
| **পাডিং** | ছোট স্ট্রিংগুলি পাড করা হয় না | ছোট স্ট্রিংগুলি স্পেস দিয়ে পাড করা হয় |
| **কখন ব্যবহার করবেন** | পরিবর্তনশীল দৈর্ঘ্যের ডাটার জন্য | সবসময় একই দৈর্ঘ্যের ডাটার জন্য |
| **উদাহরণ** | ইমেইল, নাম, ঠিকানা | ISO কোড, রাজ্য কোড |
| **সিনট্যাক্স** | `VARCHAR(n)` | `CHAR(n)` |

উদাহরণ:
```sql
-- 'Hello' স্টোর করে, 5 বাইট ব্যবহার করে
VARCHAR(10) 'Hello'

-- 'Hello' স্টোর করে, 10 বাইট ব্যবহার করে (5 স্পেস পাড করে)
CHAR(10) 'Hello     '
```

### ৫. Explain the purpose of the WHERE clause in a SELECT statement.(SELECT স্টেটমেন্টে WHERE ক্লজের উদ্দেশ্য ব্যাখ্যা করুন।)
WHERE ক্লজ SQL কোয়েরিতে ফিল্টারিং মেকানিজম হিসাবে কাজ করে। এটি কোয়েরি থেকে কোন রো প্রদর্শন করা হবে তা নির্ধারণ করে। WHERE ক্লজ ছাড়া, একটি SELECT স্টেটমেন্ট টেবিলের সমস্ত রো প্রদর্শন করবে।

**উদ্দেশ্য:**
- রিজাল্ট সেটে শুধুমাত্র নির্দিষ্ট শর্ত পূরণকারী রো অন্তর্ভুক্ত করা
- সিলেকশন মানদণ্ড প্রয়োগ করা
- সুনির্দিষ্ট প্রয়োজনীয় ডাটা খুঁজে বের করা
- অনাবশ্যক তথ্য বাদ দেওয়া

**উদাহরণ:**
```sql
-- 10 বা তার বেশি স্টক আছে এমন বইগুলি প্রদর্শন করুন
SELECT title, author, stock
FROM books
WHERE stock >= 10;

-- মূল্য $30 এবং $50-এর মধ্যে থাকা বইগুলি প্রদর্শন করুন
SELECT title, price
FROM books
WHERE price BETWEEN 30 AND 50;

-- যে বইগুলি বর্তমানে স্টকে নেই
SELECT title 
FROM books
WHERE stock = 0;
```

### ৬. What are the LIMIT and OFFSET clauses used for?(LIMIT এবং OFFSET ক্লজ কী কাজে ব্যবহৃত হয়?)
**LIMIT ক্লজ:**
- রিজাল্ট সেটে কতগুলি রো প্রদর্শন করা হবে তা সীমাবদ্ধ করে
- বড় রিজাল্ট সেটগুলিকে ছোট, পরিচালনযোগ্য ব্যাচে ভাগ করতে সাহায্য করে
- একটি কোয়েরির আউটপুট সীমিত করার একটি দক্ষ উপায়

**OFFSET ক্লজ:**
- রিজাল্ট সেট থেকে কতগুলি রো এড়িয়ে যাওয়া হবে তা নির্দিষ্ট করে
- প্রথম n রো বাদ দিয়ে রিজাল্ট দেখার জন্য ব্যবহৃত হয়
- LIMIT-এর সাথে সাধারণত পেজিনেশনের জন্য ব্যবহৃত হয়

**একসাথে ব্যবহার:**
```sql
-- সবচেয়ে দামী 5টি বই দেখান, সবচেয়ে দামী থেকে শুরু করে
SELECT title, price
FROM books
ORDER BY price DESC
LIMIT 5;

-- দ্বিতীয় পৃষ্ঠায় 10টি বই দেখান (রো 11-20)
SELECT title, author
FROM books
ORDER BY title
LIMIT 10 OFFSET 10;
```

পেজিনেশন সূত্র:
```
LIMIT = records_per_page
OFFSET = (page_number - 1) * records_per_page
```

### ৭. How can you modify data using UPDATE statements?(UPDATE স্টেটমেন্ট ব্যবহার করে কীভাবে ডাটা পরিবর্তন করা যায়?)
UPDATE স্টেটমেন্ট একটি টেবিলে বিদ্যমান রেকর্ডগুলির মান পরিবর্তন করতে ব্যবহৃত হয়। এটি বিভিন্ন জটিলতার হতে পারে, একটি সরল আপডেট থেকে শুরু করে একাধিক টেবিল জড়িত জটিল আপডেট পর্যন্ত।

**মৌলিক সিনট্যাক্স:**
```sql
UPDATE table_name
SET column1 = value1, column2 = value2, ...
WHERE condition;
```

**উদাহরণ:**
```sql
-- একটি নির্দিষ্ট বইয়ের মূল্য আপডেট করুন
UPDATE books
SET price = 45.00
WHERE id = 1;

-- একাধিক কলাম আপডেট করুন
UPDATE books
SET price = price * 1.1, stock = stock + 5
WHERE published_year < 2000;

-- WHERE ক্লজ ছাড়া (সমস্ত রো আপডেট করা হবে - সাবধানে ব্যবহার করুন!)
UPDATE customers
SET last_login = CURRENT_TIMESTAMP;
```

**উন্নত UPDATE:**
```sql
-- কোয়েরি থেকে মান আপডেট করা
UPDATE books
SET stock = 0
WHERE id IN (SELECT book_id FROM out_of_stock_list);

-- RETURNING ক্লজ (আপডেট করা রো প্রদর্শন করে)
UPDATE books
SET price = price * 1.05
WHERE published_year = 2023
RETURNING id, title, price;
```

### ৮. What is the significance of the JOIN operation, and how does it work in PostgreSQL?(JOIN অপারেশনের গুরুত্ব কী এবং PostgreSQL-এ এটি কীভাবে কাজ করে?)
JOIN অপারেশন একাধিক টেবিল থেকে ডাটা সংযুক্ত করতে ব্যবহৃত হয়, যা রিলেশনাল ডাটাবেসের একটি অন্যতম শক্তিশালী বৈশিষ্ট্য।

**গুরুত্ব:**
1. **ডাটা নরমালাইজেশন**: সম্পর্কিত টেবিলগুলিতে বিভক্ত ডাটা পুনরুদ্ধার করতে সক্ষম করে
2. **রিডানডেন্সি কমানো**: টেবিলগুলিতে ডাটার পুনরাবৃত্তি হ্রাস করে
3. **ডাটা ইন্টিগ্রিটি**: সম্পর্কিত টেবিলগুলির মধ্যে সম্পর্ক বজায় রাখে
4. **কমপ্লেক্স কোয়েরি**: জটিল প্রশ্নের উত্তর দেওয়ার জন্য বিভিন্ন ডাটা সোর্স থেকে তথ্য সংগ্রহ করে

**PostgreSQL-এ JOIN প্রকারগুলি:**

1. **INNER JOIN**: শুধুমাত্র উভয় টেবিলে মিলে যাওয়া রো প্রদর্শন করে
   ```sql
   SELECT books.title, customers.name
   FROM orders
   INNER JOIN books ON orders.book_id = books.id
   INNER JOIN customers ON orders.customer_id = customers.id;
   ```

2. **LEFT JOIN**: প্রথম (বাম) টেবিলের সমস্ত রো এবং দ্বিতীয় (ডান) টেবিল থেকে মিলে যাওয়া রো প্রদর্শন করে
   ```sql
   SELECT customers.name, COUNT(orders.id) AS total_orders
   FROM customers
   LEFT JOIN orders ON customers.id = orders.customer_id
   GROUP BY customers.name;
   ```

3. **RIGHT JOIN**: দ্বিতীয় (ডান) টেবিলের সমস্ত রো এবং প্রথম (বাম) টেবিল থেকে মিলে যাওয়া রো প্রদর্শন করে
   ```sql
   SELECT books.title, orders.id
   FROM orders
   RIGHT JOIN books ON orders.book_id = books.id;
   ```

4. **FULL OUTER JOIN**: উভয় টেবিলের সমস্ত রো প্রদর্শন করে, মিলে যাওয়া রো এবং না-মিলে যাওয়া রো উভয়ই
   ```sql
   SELECT books.title, orders.id
   FROM books
   FULL OUTER JOIN orders ON books.id = orders.book_id;
   ```

5. **CROSS JOIN**: দুটি টেবিলের মধ্যে কার্টেসিয়ান প্রোডাক্ট তৈরি করে (প্রথম টেবিলের প্রতিটি রো দ্বিতীয় টেবিলের প্রতিটি রোর সাথে সংযুক্ত করে)
   ```sql
   SELECT customers.name, books.title
   FROM customers
   CROSS JOIN books;
   ```

### ৯. Explain the GROUP BY clause and its role in aggregation operations.(GROUP BY ক্লজ এবং অ্যাগ্রিগেশন অপারেশনে এর ভূমিকা ব্যাখ্যা করুন।)
GROUP BY ক্লজ একটি ফান্ডামেন্টাল SQL বৈশিষ্ট্য যা রিজাল্ট সেটকে নির্দিষ্ট কলামের মানের উপর ভিত্তি করে সম্পর্কিত রো গ্রুপে বিভক্ত করে। এটি প্রায়শই অ্যাগ্রিগেট ফাংশনের সাথে ব্যবহৃত হয় যেমন COUNT(), SUM(), AVG() ইত্যাদি।

**GROUP BY-এর ভূমিকা:**
1. **ডাটা সংক্ষিপ্তকরণ**: ব্যক্তিগত রো থেকে গ্রুপ-ভিত্তিক ম্যাট্রিক্সে ডাটা রূপান্তর করে
2. **অ্যাগ্রিগেশন**: একটি গ্রুপের জন্য একক মান গণনা করতে অ্যাগ্রিগেট ফাংশন অ্যাপ্লাই করতে সক্ষম করে
3. **ডাটা বিশ্লেষণ**: ট্রেন্ড, প্যাটার্ন, এবং সারসংক্ষেপ আবিষ্কার করতে সাহায্য করে
4. **রিপোর্টিং**: বিভিন্ন বিভাগ, বিভাগ, বা ক্যাটাগরি অনুসারে সংক্ষিপ্ত ডাটা তৈরি করে

**GROUP BY-এর কার্যপ্রণালী:**
1. যে কলামগুলি GROUP BY ক্লজে উল্লেখ করা হয়েছে সেগুলি দ্বারা রো গ্রুপ করা হয়
2. প্রতিটি গ্রুপে একাধিক রো থাকতে পারে, তবে গ্রুপিং কলামগুলির জন্য সমান মান থাকে
3. GROUP BY-এর মাধ্যমে গ্রুপ করা রোগুলি নির্বাচিত কলামগুলিতে অ্যাগ্রিগেট ফাংশন প্রয়োগ করে একটি একক আউটপুট রো হিসাবে সংক্ষিপ্ত করা হয়
4. গ্রুপিং কলাম ছাড়া প্রতিটি কলাম অবশ্যই একটি অ্যাগ্রিগেট ফাংশনের অধীনে থাকতে হবে

**উদাহরণ:**
```sql
-- প্রতিটি লেখকের বই গণনা করুন
SELECT author, COUNT(*) AS book_count
FROM books
GROUP BY author;

-- প্রতিটি গ্রাহক দ্বারা মোট খরচ সন্ধান করুন
SELECT customers.name, SUM(books.price * orders.quantity) AS total_spent
FROM orders
JOIN customers ON orders.customer_id = customers.id
JOIN books ON orders.book_id = books.id
GROUP BY customers.name;

-- HAVING ক্লজ সহ (GROUP BY-এর জন্য একটি ফিল্টার)
SELECT published_year, AVG(price) AS avg_price
FROM books
GROUP BY published_year
HAVING AVG(price) > 30;
```


## ১০. How can you calculate aggregate functions like COUNT(), SUM(), and AVG() in PostgreSQL?(PostgreSQL-এ COUNT(), SUM(), এবং AVG() এর মতো অ্যাগ্রিগেট ফাংশন কীভাবে গণনা করা যায়?)
অ্যাগ্রিগেট ফাংশন রো গ্রুপের উপর অপারেশন করে এবং একটি একক মান প্রদান করে। এগুলি ডাটা থেকে উপযোগী সংক্ষিপ্ত তথ্য পাওয়ার একটি শক্তিশালী উপায়।

**সাধারণ অ্যাগ্রিগেট ফাংশন:**

1. **COUNT()**: রো সংখ্যা গণনা করে
   ```sql
   -- টেবিলে মোট বই সংখ্যা গণনা 
   SELECT COUNT(*) AS total_books FROM books;
   
   -- শুধুমাত্র নির্দিষ্ট বইয়ের সংখ্যা গণনা 
   SELECT COUNT(*) AS low_stock_books FROM books WHERE stock < 5;
   
   -- লেখক অনুসারে বই সংখ্যা গণনা 
   SELECT author, COUNT(*) FROM books GROUP BY author;
   ```

2. **SUM()**: নিউমেরিক মানগুলির যোগফল গণনা করে
   ```sql
   -- সমস্ত বইয়ের মোট মূল্য
   SELECT SUM(price) AS total_inventory_value FROM books;
   
   -- মোট বিক্রয় মূল্য
   SELECT SUM(books.price * orders.quantity) AS total_sales
   FROM orders JOIN books ON orders.book_id = books.id;
   ```

3. **AVG()**: নিউমেরিক মানগুলির গড় গণনা করে
   ```sql
   -- সমস্ত বইয়ের গড় মূল্য
   SELECT AVG(price) AS average_book_price FROM books;
   
   -- প্রকাশের বছর অনুসারে গড় মূল্য
   SELECT published_year, AVG(price) AS avg_price
   FROM books GROUP BY published_year;
   ```

4. **MIN()**: সেটের সর্বনিম্ন মান খুঁজে বের করে
   ```sql
   -- সবচেয়ে সস্তা বইয়ের মূল্য
   SELECT MIN(price) AS cheapest_book_price FROM books;
   ```

5. **MAX()**: সেটের সর্বোচ্চ মান খুঁজে বের করে
   ```sql
   -- সবচেয়ে দামী বইয়ের মূল্য
   SELECT MAX(price) AS most_expensive_book FROM books;
   ```

**অ্যাডভান্সড ব্যবহার:**

1. **DISTINCT সহ**:
   ```sql
   -- অনন্য লেখকদের সংখ্যা
   SELECT COUNT(DISTINCT author) FROM books;
   ```

2. **শর্তাধীন অ্যাগ্রিগেশন**:
   ```sql
   -- বছর অনুযায়ী বইয়ের সংখ্যা এবং গড় মূল্য
   SELECT 
       published_year,
       COUNT(*) AS book_count,
       AVG(price) AS avg_price,
       SUM(CASE WHEN stock > 0 THEN 1 ELSE 0 END) AS in_stock_count
   FROM books
   GROUP BY published_year;
   ```

3. **নেস্টেড অ্যাগ্রিগেট ফাংশন**:
   ```sql
   -- গড় বই মূল্য থেকে স্ট্যান্ডার্ড ডেভিয়েশন
   SELECT 
       AVG(price) AS avg_price,
       SQRT(AVG(price*price) - AVG(price)*AVG(price)) AS price_stddev
   FROM books;
   ```

4. **FILTER ক্লজ সহ (PostgreSQL-এ অনন্য)**:
   ```sql
   -- একই কোয়েরিতে বিভিন্ন অবস্থার জন্য বিভিন্ন গণনা
   SELECT 
       COUNT(*) AS total_books,
       COUNT(*) FILTER (WHERE price < 30) AS affordable_books,
       COUNT(*) FILTER (WHERE price >= 30) AS premium_books
   FROM books;
   ```

   