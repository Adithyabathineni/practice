/*Write a SELECT statement that returns four columns from the Products table:
product_code, product_name, list_price, and discount_percent. Then, run this statement
to make sure it works correctly.
Add an ORDER BY clause to this statement that sorts the result set by list price in
descending sequence. Then, run this statement again to make sure it works correctly.
This is a good way to build and test a statement, one clause at a time.*/
SELECT product_code, product_name, list_price, discount_percent
FROM Products;
/*Write a SELECT statement that returns one column from the Customers table named
full_name that joins the last_name and first_name columns.
Format this column with the last name, a comma, a space, and the first name like this:
Doe, John
Sort the result set by the last_name column in ascending sequence.
Return only the customers whose last name begins with letters from M to Z.
NOTE: When comparing strings of characters, ‘M’ comes before any string of
characters that begins with ‘M’. For example, ‘M’ comes before ‘Murach’. Screen*/
SELECT CONCAT(last_name, ', ', first_name) AS full_name
FROM Customers
WHERE last_name >= 'M'
ORDER BY last_name ASC;
/*Write a SELECT statement that returns these columns from the Products table:
product_name The product_name column
list_price The list_price column
date_added The date_added column
Return only the rows with a list price that’s greater than 500 and less than 2000.
Sort the result set by the date_added column in descending sequence. */
SELECT product_name, list_price, date_added
FROM Products
WHERE list_price > 500 AND list_price < 2000
ORDER BY date_added DESC;
/*Write a SELECT statement that returns these column names and data from the
Products table:
product_name The product_name column
list_price The list_price column
discount_percent The discount_percent column
discount_amount A column that’s calculated from the previous two
columns
discount_price A column that’s calculated from the previous three
columns
Round the discount_amount and discount_price columns to 2 decimal places.
Sort the result set by the discount_price column in descending sequence.
Use the LIMIT clause so the result set contains only the first 5 rows. Label as*/
SELECT 
    product_name, 
    list_price, 
    discount_percent,
    ROUND(list_price * (discount_percent / 100), 2) AS discount_amount,
    ROUND(list_price - (list_price * (discount_percent / 100)), 2) AS discount_price
FROM 
    Products
ORDER BY 
    discount_price DESC
LIMIT 5;
/*Write a SELECT statement that returns these column names and data from the
Order_Items table:
item_id The item_id column
item_price The item_price column
discount_amount The discount_amount column
quantity The quantity column
price_total A column that’s calculated by multiplying the item
price by the quantity
discount_total A column that’s calculated by multiplying the
discount amount by the quantity
item_total A column that’s calculated by subtracting the
discount amount from the item price and then
multiplying by the quantity
Only return rows where the item_total is greater than 500.
Sort the result set by the item_total column in descending sequence. Label as Screen*/
SELECT 
    item_id, 
    item_price, 
    discount_amount, 
    quantity,
    item_price * quantity AS price_total,
    discount_amount * quantity AS discount_total,
    (item_price - discount_amount) * quantity AS item_total
FROM 
    Order_Items
WHERE 
    (item_price - discount_amount) * quantity > 500
ORDER BY 
    item_total DESC;
/*------------------------------------2-----------------------------------
Write a SELECT statement that returns one row for each
category that has products with these columns:
-The category_name column from the Categories table 
-The count of the products in the Products table 
-The list price of the most expensive product in the Products table
Sort the result set so the category with the most products appears first.
------------------------------------------------------------------------*/

SELECT 
    c.category_name,
    COUNT(p.product_id) AS count,
    MAX(p.list_price)
FROM
    categories AS c
        INNER JOIN
    products p ON c.category_id = p.category_id
GROUP BY c.category_name
ORDER BY count DESC;
/*------------------------------------7-----------------------------------
Write a SELECT statement that answers this question: Which customers have ordered more than
one product? Return these columns:
-The email address from the Customers table
-The count of distinct products from the customer’s orders
------------------------------------------------------------------------*/
SELECT 
    c.email_address, COUNT(DISTINCT oi.product_id) AS count
FROM
    customers AS c
        INNER JOIN
    orders o ON c.customer_id = o.customer_id
        INNER JOIN
    order_items oi ON o.order_id = oi.order_id
GROUP BY c.email_address
HAVING count > 1;
Write a SELECT statement that returns one row for each customer that 
has orders with these columns:
-The email_address column from the Customers table
-The sum of the item price in the Order_Items table multiplied by the quantity in the Order_Items table
-The sum of the discount amount column in the Order_Items table multiplied by the quantity in the Order_Items table
Sort the result set in descending sequence by the item price total for each customer.
------------------------------------------------------------------------*/
/*------------------------------------3-----------------------------------
Write a SELECT statement that returns one row for each customer that 
has orders with these columns:
-The email_address column from the Customers table
-The sum of the item price in the Order_Items table multiplied by the quantity in the Order_Items table
-The sum of the discount amount column in the Order_Items table multiplied by the quantity in the Order_Items table
Sort the result set in descending sequence by the item price total for each customer.
------------------------------------------------------------------------*/
SELECT 
    c.email_address,
    SUM(o.item_price) * COUNT(o.item_id) AS first_sum_by_count,
    SUM(o.discount_amount) * COUNT(o.item_id) AS second_sum_by_count
FROM
    customers AS c
        INNER JOIN
    orders AS ord ON c.customer_id = ord.customer_id
        INNER JOIN
    order_items AS o ON o.order_id = ord.order_id
GROUP BY c.customer_id
ORDER BY SUM(o.item_price) DESC;


-- QUESTION 1: Link book titles to publisher contacts
-- Logic: Join BOOKS and PUBLISHER on PubID to retrieve contact info.
SELECT b.Title, p.Contact AS ContactName, p.Phone
FROM JL_BOOKS b
JOIN JL_PUBLISHER p ON b.PubID = p.PubID;

-- QUESTION 2: Identify unshipped orders with customer names
-- Logic: Filter orders where ShipDate is NULL and sort by OrderDate.
SELECT o.Order_id, CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName, o.OrderDate
FROM JL_ORDERS o
JOIN JL_CUSTOMERS c ON o.Customer_id = c.Customer_id
WHERE o.ShipDate IS NULL
ORDER BY o.OrderDate;

-- QUESTION 3: FL customers who bought COMPUTER books
-- Logic: Chain joins from CUSTOMERS → ORDERS → ORDERITEMS → BOOKS. Filter FL + COMPUTER.
SELECT CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName, b.Title, o.Order_id, b.Category
FROM JL_CUSTOMERS c
JOIN JL_ORDERS o ON c.Customer_id = o.Customer_id
JOIN JL_ORDERITEMS oi ON o.Order_id = oi.Order_id
JOIN JL_BOOKS b ON oi.ISBN = b.ISBN
WHERE c.State = 'FL' AND b.Category = 'COMPUTER';

-- QUESTION 4: Unique books purchased by Jake Lucas
-- Logic: Use DISTINCT to avoid duplicates; filter by full name.
SELECT DISTINCT b.Title
FROM JL_CUSTOMERS c
JOIN JL_ORDERS o ON c.Customer_id = o.Customer_id
JOIN JL_ORDERITEMS oi ON o.Order_id = oi.Order_id
JOIN JL_BOOKS b ON oi.ISBN = b.ISBN
WHERE c.FirstName = 'JAKE' AND c.LastName = 'LUCAS';

-- QUESTION 5: Profit calculation for Jake Lucas
-- Logic: Profit = PaidEach - Cost. Sort by date then profit DESC.
SELECT o.OrderDate, b.Title, (oi.PaidEach - b.Cost) AS Profit
FROM JL_CUSTOMERS c
JOIN JL_ORDERS o ON c.Customer_id = o.Customer_id
JOIN JL_ORDERITEMS oi ON o.Order_id = oi.Order_id
JOIN JL_BOOKS b ON oi.ISBN = b.ISBN
WHERE c.FirstName = 'JAKE' AND c.LastName = 'LUCAS'
ORDER BY o.OrderDate, Profit DESC;

-- QUESTION 6: Books by author "Adams"
-- Logic: Join AUTHOR → BOOK_AUTHOR → BOOKS. Filter by last name.
SELECT b.Title
FROM JL_AUTHOR a
JOIN JL_BOOK_AUTHOR ba ON a.AUTHORid = ba.JL_AUTHORID
JOIN JL_BOOKS b ON ba.ISBN = b.ISBN
WHERE a.Lname = 'ADAMS';

-- QUESTION 7: Gift for "Shortest Poems" purchase
-- Logic: Match book's Retail price to PROMOTION tiers using BETWEEN.
SELECT p.Gift
FROM JL_BOOKS b
JOIN JL_PROMOTION p ON b.Retail BETWEEN p.Minretail AND p.Maxretail
WHERE b.Title = 'SHORTEST POEMS';

-- QUESTION 8: Authors of Becca Nelson's books
-- Logic: Chain joins from CUSTOMER → ORDERS → ORDERITEMS → BOOK_AUTHOR → AUTHOR.
SELECT DISTINCT a.Fname, a.Lname
FROM JL_CUSTOMERS c
JOIN JL_ORDERS o ON c.Customer_id = o.Customer_id
JOIN JL_ORDERITEMS oi ON o.Order_id = oi.Order_id
JOIN JL_BOOK_AUTHOR ba ON oi.ISBN = ba.ISBN
JOIN JL_AUTHOR a ON ba.JL_AUTHORID = a.AUTHORid
WHERE c.FirstName = 'BECCA' AND c.LastName = 'NELSON';

-- QUESTION 9: All books with optional order details
-- Logic: LEFT JOIN retains all books, even if unordered.
SELECT b.Title, o.Order_id, c.State
FROM JL_BOOKS b
LEFT JOIN JL_ORDERITEMS oi ON b.ISBN = oi.ISBN
LEFT JOIN JL_ORDERS o ON oi.Order_id = o.Order_id
LEFT JOIN JL_CUSTOMERS c ON o.Customer_id = c.Customer_id;

-- QUESTION 10: Authors with "IN" in last name
-- Logic: Wildcard search with %IN%. Sort by last name then first name.
SELECT Lname, Fname
FROM JL_AUTHOR
WHERE Lname LIKE '%IN%'
ORDER BY Lname, Fname;

-- QUESTION 11A: Customers in GA/NJ using IN
-- Logic: IN operator simplifies multi-state filtering.
SELECT Customer_id, LastName, State
FROM JL_CUSTOMERS
WHERE State IN ('GA', 'NJ')
ORDER BY LastName ASC;

-- QUESTION 11B: Customers in GA/NJ using OR
-- Logic: OR explicitly checks each state.
SELECT Customer_id, LastName, State
FROM JL_CUSTOMERS
WHERE State = 'GA' OR State = 'NJ'
ORDER BY LastName ASC;

-- QUESTION 12A: Children/Cooking books via wildcards
-- Logic: Pattern matching with LIKE.
SELECT Title, Category
FROM JL_BOOKS
WHERE Category LIKE 'CHILD%' OR Category LIKE 'COOK%';

-- QUESTION 12B: Children/Cooking books via OR
-- Logic: Exact category names with OR.
SELECT Title, Category
FROM JL_BOOKS
WHERE Category = 'CHILDREN' OR Category = 'COOKING';

-- QUESTION 12C: Children/Cooking books via IN
-- Logic: IN operator for concise category selection.
SELECT Title, Category
FROM JL_BOOKS
WHERE Category IN ('CHILDREN', 'COOKING');

-- QUESTION 13: Title pattern with A (2nd) and N (4th)
-- Logic: _A% for 2nd char A, ___N% for 4th char N.
SELECT ISBN, Title
FROM JL_BOOKS
WHERE Title LIKE '_A%' AND Title LIKE '___N%'
ORDER BY Title DESC;

-- QUESTION 14A: 2005 Computer books via date range
-- Logic: BETWEEN for dates in 2005.
SELECT Title, PubDate
FROM JL_BOOKS
WHERE Category = 'COMPUTER' AND PubDate BETWEEN '2005-01-01' AND '2005-12-31';

-- QUESTION 14B: 2005 Computer books via YEAR()
-- Logic: Extract year from PubDate.
SELECT Title, PubDate
FROM JL_BOOKS
WHERE Category = 'COMPUTER' AND YEAR(PubDate) = 2005;

-- QUESTION 14C: 2005 Computer books via pattern
-- Logic: Match year prefix in date string.
SELECT Title, PubDate
FROM JL_BOOKS
WHERE Category = 'COMPUTER' AND PubDate LIKE '2005-%';

