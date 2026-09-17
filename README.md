# 📚 Online Bookstore — SQL Analysis

A hands-on SQL project analysing a fictional online bookstore. The goal: move
beyond `SELECT *` and use SQL to answer real business questions — revenue,
best-sellers, dead inventory, customer value and data-quality checks.

**Tools:** SQLite · DB Browser for SQLite

---

## Dataset

The database (`OnlineBookstore.db`) has three tables, 500 rows each:

| Table | Rows | Key columns |
|-------|------|-------------|
| **Books** | 500 | `Book_ID` (PK), Title, Author, Genre, Published_Year, Price, Stock |
| **Customers** | 500 | `Customer_ID` (PK), Name, Email, Phone, City, Country |
| **Orders** | 500 | `Order_ID` (PK), Customer_ID (FK), Book_ID (FK), Order_Date, Quantity, Total_Amount |

`Orders` links to `Books` on `Book_ID` and to `Customers` on `Customer_ID`.

---

## Key findings

- **Total revenue of ~$75,628** across 500 orders and 2,697 books sold.
- **Romance** generates the most revenue (~$13.1k); **Mystery** sells the most units.
- **37% of the catalogue (183 of 500 books) was never ordered** — a clear dead-inventory signal.
- **Only 307 of 500 customers ever placed an order** (61% activation); the rest are dormant.
- Several titles show **negative remaining stock**, meaning ordered quantity exceeded
  stock on hand — a data-integrity issue surfaced with `LEFT JOIN` + `COALESCE`.

---

## What the queries cover

| # | Theme | Techniques |
|---|-------|-----------|
| 1–4 | Retrieval & filtering | `WHERE`, `ORDER BY`, `LIMIT` |
| 5–7 | Aggregation | `SUM`, `AVG`, `COUNT`, `GROUP BY` |
| 8–10 | Joins | `INNER JOIN` across 3 tables |
| 11–13 | Subqueries | `NOT EXISTS`, `NOT IN`, scalar subquery |
| 14 | Stock reconciliation | `LEFT JOIN`, `COALESCE` |
| 15–16 | Time trends | `strftime` date functions |

All queries live in [`online_bookstore_analysis.sql`](online_bookstore_analysis.sql).

---

## How to run

1. Install [DB Browser for SQLite](https://sqlitebrowser.org/) (free).
2. Open `OnlineBookstore.db`.
3. Go to the **Execute SQL** tab, paste a query from the `.sql` file, and run it.

---

## Author

**Rimsha Ibrahim** — Aspiring Data Analyst
