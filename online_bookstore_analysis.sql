/* =============================================================
   Online Bookstore — SQL Analysis
   Database : OnlineBookstore.db  (SQLite)
   Tables   : Books (500) · Customers (500) · Orders (500)
   Author   : Usama Ibrahim
   -------------------------------------------------------------
   A walkthrough of the bookstore dataset, from basic retrieval
   to joins, subqueries and date analysis. Each block states the
   business question it answers.
   ============================================================= */


/* ---------- 1. Basic retrieval & filtering ---------- */

-- 1) All books in the "Fantasy" genre
SELECT Book_ID, Title, Author, Price
FROM Books
WHERE Genre = 'Fantasy'
ORDER BY Price DESC;

-- 2) Books published after the year 2000
SELECT Title, Published_Year, Price
FROM Books
WHERE Published_Year > 2000
ORDER BY Published_Year;

-- 3) The 5 most expensive books in the catalogue
SELECT Title, Author, Price
FROM Books
ORDER BY Price DESC
LIMIT 5;

-- 4) Customers based in a specific country (example: Denmark)
SELECT Name, City, Country
FROM Customers
WHERE Country = 'Denmark';


/* ---------- 2. Aggregation ---------- */

-- 5) Headline numbers: total revenue and total units sold
SELECT ROUND(SUM(Total_Amount), 2) AS total_revenue,
       SUM(Quantity)               AS total_units,
       COUNT(*)                    AS total_orders
FROM Orders;

-- 6) Average selling price of a book, by genre
SELECT Genre,
       COUNT(*)              AS titles,
       ROUND(AVG(Price), 2)  AS avg_price
FROM Books
GROUP BY Genre
ORDER BY avg_price DESC;

-- 7) Number of books available per genre
SELECT Genre, COUNT(*) AS num_books
FROM Books
GROUP BY Genre
ORDER BY num_books DESC;


/* ---------- 3. Joins (Orders + Books + Customers) ---------- */

-- 8) Revenue and units sold by genre (Orders JOIN Books)
SELECT b.Genre,
       ROUND(SUM(o.Total_Amount), 2) AS revenue,
       SUM(o.Quantity)               AS units_sold
FROM Orders o
JOIN Books b ON b.Book_ID = o.Book_ID
GROUP BY b.Genre
ORDER BY revenue DESC;

-- 9) Top 5 best-selling books by units sold
SELECT b.Title,
       SUM(o.Quantity) AS units_sold
FROM Orders o
JOIN Books b ON b.Book_ID = o.Book_ID
GROUP BY b.Book_ID
ORDER BY units_sold DESC
LIMIT 5;

-- 10) Top 5 customers by total spend
SELECT c.Name,
       COUNT(*)                       AS orders,
       ROUND(SUM(o.Total_Amount), 2)  AS total_spend
FROM Orders o
JOIN Customers c ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID
ORDER BY total_spend DESC
LIMIT 5;


/* ---------- 4. Subqueries ---------- */

-- 11) Books that have NEVER been ordered (dead inventory)
SELECT COUNT(*) AS never_ordered
FROM Books b
WHERE NOT EXISTS (
    SELECT 1 FROM Orders o
    WHERE o.Book_ID = b.Book_ID
);

-- 12) Customers who have never placed an order
SELECT Name, Country
FROM Customers
WHERE Customer_ID NOT IN (
    SELECT DISTINCT Customer_ID FROM Orders
);

-- 13) Books priced above the overall average price
SELECT Title, Price
FROM Books
WHERE Price > (SELECT AVG(Price) FROM Books)
ORDER BY Price DESC;


/* ---------- 5. LEFT JOIN & COALESCE ---------- */

-- 14) Remaining stock after fulfilling every order.
--     LEFT JOIN keeps books with no orders; COALESCE turns their
--     NULL quantity into 0. Negative values = oversold titles.
SELECT b.Book_ID,
       b.Title,
       b.Stock,
       COALESCE(SUM(o.Quantity), 0)                AS units_ordered,
       b.Stock - COALESCE(SUM(o.Quantity), 0)      AS remaining_stock
FROM Books b
LEFT JOIN Orders o ON o.Book_ID = b.Book_ID
GROUP BY b.Book_ID
ORDER BY remaining_stock ASC;


/* ---------- 6. Date analysis ---------- */

-- 15) Orders and revenue per calendar year
SELECT strftime('%Y', Order_Date)       AS year,
       COUNT(*)                          AS orders,
       ROUND(SUM(Total_Amount), 2)       AS revenue
FROM Orders
GROUP BY year
ORDER BY year;

-- 16) Monthly revenue trend (year-month)
SELECT strftime('%Y-%m', Order_Date)     AS month,
       ROUND(SUM(Total_Amount), 2)       AS revenue
FROM Orders
GROUP BY month
ORDER BY month;

/* ---------- end of file ---------- */
