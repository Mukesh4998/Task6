CREATE DATABASE practice;
USE practice;
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    city VARCHAR(50)
);

INSERT INTO Customers VALUES
(1, 'Alice', 'Delhi'),
(2, 'Bob', 'Mumbai'),
(3, 'Charlie', 'Chennai'),
(4, 'David', 'Delhi');


CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

INSERT INTO Orders VALUES
(101, 1, '2025-09-01', 5000.00),
(102, 2, '2025-09-05', 2000.00),
(103, 1, '2025-09-10', 3500.00),
(104, 3, '2025-09-15', 8000.00);


SELECT * FROM Customers;
SELECT * FROM Orders;

-- 1) Find customers who have placed at least one order. (IN)
SELECT customer_name
FROM Customers
WHERE customer_id IN (
  SELECT customer_id FROM Orders
);

-- 2) Find customers who have never placed an order. (NOT IN)
SELECT customer_name
FROM Customers
WHERE customer_id NOT IN (
  SELECT customer_id FROM Orders
);

-- 3) Find customers who placed orders worth more than 5000. (EXISTS, correlated)
SELECT c.customer_name
FROM Customers c
WHERE EXISTS (
  SELECT 1
  FROM Orders o
  WHERE o.customer_id = c.customer_id
    AND o.amount > 5000
);

-- 4) List all customers from Delhi who have placed at least one order. (EXISTS)
SELECT c.customer_name
FROM Customers c
WHERE c.city = 'Delhi'
  AND EXISTS (
    SELECT 1 FROM Orders o WHERE o.customer_id = c.customer_id
);

-- 5) Find customers who placed orders on the same date as Alice. (IN)
SELECT DISTINCT c.customer_name
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.order_date IN (
  SELECT o2.order_date
  FROM Orders o2
  JOIN Customers c2 ON o2.customer_id = c2.customer_id
  WHERE c2.customer_name = 'Alice'
);


-- 6) Find customers who have placed an order greater than all of Bob’s orders. (ALL)
SELECT DISTINCT c.customer_name
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.amount > ALL (
  SELECT o2.amount
  FROM Orders o2
  JOIN Customers c2 ON o2.customer_id = c2.customer_id
  WHERE c2.customer_name = 'Bob'
);

-- 7) Find customers who have placed an order greater than the average order amount.
SELECT DISTINCT c.customer_name
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.amount > (
  SELECT AVG(amount) FROM Orders
);

-- 8) Find customers who have placed at least one order in September 2025. (EXISTS)
SELECT c.customer_name
FROM Customers c
WHERE EXISTS (
  SELECT 1
  FROM Orders o
  WHERE o.customer_id = c.customer_id
    AND o.order_date BETWEEN '2025-09-01' AND '2025-09-30'
);


-- 9) Find customers who share the same city as any customer who placed an order. (IN)
SELECT customer_name, city
FROM Customers
WHERE city IN (
  SELECT DISTINCT c2.city
  FROM Customers c2
  JOIN Orders o2 ON c2.customer_id = o2.customer_id
);


-- 10) Find customers who have more than one order. (correlated subquery with COUNT)
SELECT c.customer_name
FROM Customers c
WHERE (
  SELECT COUNT(*)
  FROM Orders o
  WHERE o.customer_id = c.customer_id
) > 1;
