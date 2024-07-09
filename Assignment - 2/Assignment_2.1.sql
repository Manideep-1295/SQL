CREATE DATABASE BOOK
USE BOOK
GO
-- Creating table for books
CREATE TABLE books
(
    book_id INT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    author_id INT NOT NULL,
    genre VARCHAR(50) NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);
GO
-- Creating table for authors
CREATE TABLE authors
(
    author_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    country VARCHAR(50) NOT NULL,
    birth_year INT NOT NULL
);
GO
-- Creating table for sales
CREATE TABLE sales
(
    sale_id INT PRIMARY KEY,
    book_id INT NOT NULL,
    sale_date DATE NOT NULL,
    quantity INT NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (book_id) REFERENCES books(book_id)
);

-- Inserting data into authors
INSERT INTO authors
    (author_id, name, country, birth_year)
VALUES
    (1, 'George Orwell', 'UK', 1903),
    (2, 'J.K. Rowling', 'UK', 1965),
    (3, 'Mark Twain', 'USA', 1835),
    (4, 'Jane Austen', 'UK', 1775),
    (5, 'Ernest Hemingway', 'USA', 1899);


-- Inserting data into books
INSERT INTO books
    (book_id, title, author_id, genre, price)
VALUES
    (1, '1984', 1, 'Dystopian', 15.99),
    (2, 'Harry Potter and the Philosophers Stone', 2, 'Fantasy', 20.00),
    (3, 'Adventures of Huckleberry Finn', 3, 'Fiction', 10.00),
    (4, 'Pride and Prejudice', 4, 'Romance', 12.00),
    (5, 'The Old Man and the Sea', 5, 'Fiction', 8.99),
    (6, 'Brave New World', 4, 'Dystopian', 16.99),
    (7, 'Harry Potter and the Chamber of Secrets', 5, 'Fantasy', 22.00),
    (8, 'The Great Gatsby', 1, 'Fiction', 11.00),
    (9, 'Sense and Sensibility', 3, 'Romance', 14.00),
    (10, 'The Catcher in the Rye', 3, 'Fiction', 10.99),
    (11,'1984',1,'Romance',15.99);



-- Inserting data into sales
INSERT INTO sales
    (sale_id, book_id, sale_date, quantity, total_amount)
VALUES
    (1, 1, '2024-01-15', 3, 47.97),
    (2, 2, '2024-02-10', 2, 40.00),
    (3, 3, '2024-03-05', 5, 50.00),
    (4, 4, '2024-04-20', 1, 12.00),
    (5, 5, '2024-05-25', 4, 35.96),
    (6, 2, '2025-01-10', 1, 20.00),
    (7, 1, '2024-02-25', 2, 31.98),
    (8, 11, '2024-04-18', 3, 47.97);



SELECT * FROM authors
SELECT * FROM books
SELECT * FROM sales

DELETE FROM books
WHERE book_id = 10

-- Task 1
-- Write a query to display authors who have written books in multiple genres and group the results by author name.

SELECT a.name,COUNT(b.genre) AS No_Of_Books_in_Genres
FROM authors a
JOIN books b
ON a.author_id = b.author_id
Group By a.name,b.genre
Order By a.name

SELECT a.author_id,a.name,b.genre
FROM authors a
JOIN books b
ON a.author_id = b.author_id
Group By a.author_id,a.name,b.genre
Order By a.name


-- Task 2
-- Write a query to find the books that have the highest sale total for each genre and group the results by genre.
SELECT * FROM authors
SELECT * FROM books
SELECT * FROM sales

GO
WITH Max_total_sales_CTE
AS (
SELECT  b.title,
        a.name,
        b.genre, 
        MAX(s.total_amount) AS Total_Sales,
        DENSE_RANK() OVER (Partition by b.genre order by sum(s.Total_amount) DESC) AS RANK
FROM authors a
JOIN books b
ON a.author_id = b.author_id
JOIN sales s
ON s.book_id = b.book_id
GROUP BY b.genre,b.title,a.name
)
SELECT Title, name as Author, Genre, Total_Sales 
FROM Max_total_sales_CTE 
WHERE RANK<2

-- Task 3
-- Write a query to find the average price of books for each author and group the results by author name, only including authors whose average book price is higher than the overall average book price.

WITH Avg_CTE
AS(
SELECT  a.author_id,
        a.name,
        AVG(b.price) AS AvgBooksPrice,
        RANK() OVER (PARTITION BY a.author_id ORDER BY AVG(b.Price) DESC) AS Rank
FROM books b
JOIN authors a
ON a.author_id = b.author_id
GROUP BY a.author_id,a.name
)
SELECT author_id, name, AvgBooksPrice FROM Avg_CTE
WHERE AvgBooksPrice > (SELECT AVG(price) FROM books)

-- Task 4
-- Write a query to find authors who have sold more books than the average number of books sold per author and group the results by country.
WITH AvgSale_CTE
AS
(
SELECT  a.author_id,
        a.name,
        SUM(s.quantity) TotalQ,
        RANK() OVER (PARTITION BY a.author_id ORDER BY AVG(s.quantity) DESC) AS Rank
FROM books b
JOIN authors a
ON a.author_id = b.author_id
JOIN sales s
ON s.book_id = b.book_id
GROUP BY a.author_id,a.name
)

SELECT Name FROM AvgSale_CTE
WHERE TotalQ > (SELECT AVG(quantity) FROM sales)

-- Task 5
-- Write a query to find the top 2 highest-priced books and the total quantity sold for each, grouped by book title.


SELECT  TOP 2 b.Title, 
        b.price,
        b.genre,
        SUM(s.Quantity) AS TotalQuantity
FROM books b
JOIN sales s
ON s.book_id = b.book_id
GROUP BY b.title,b.price,b.genre
ORDER BY b.price DESC


-- Solution - 2

WITH TopPricedBooks_CTE
AS(
SELECT  b.Title,b.genre,b.price,
        RANK() OVER (ORDER BY b.price DESC) AS Rank
FROM books b
JOIN sales s
ON s.book_id = b.book_id
GROUP BY b.title,b.genre,b.price
)
SELECT Title FROM TopPricedBooks_CTE
WHERE Rank < 3

-- Task 6
-- Write a query to display authors whose birth year is earlier than the average birth year of authors from their country and rank them within their country.

SELECT * FROM authors
SELECT * FROM books
SELECT * FROM sales

GO
SELECT * ,
        RANK() OVER(Partition BY Country ORDER BY Birth_year) AS Rank
FROM authors a1
WHERE a1.Birth_year < (SELECT AVG(Birth_year) FROM authors a2
                        WHERE a2.country = a1.country
                        GROUP BY a2.country
                        )



-- Task 7
-- Write a query to find the authors who have written books in both 'Fiction' and 'Romance' genres and group the results by author name.

SELECT a.author_id,a.name
FROM authors a
JOIN books b
ON b.author_id = a.author_id
WHERE b.genre = 'Fiction' 
INTERSECT(
SELECT a.author_id,a.name
FROM authors a
JOIN books b
ON b.author_id = a.author_id
WHERE b.genre = 'Romance'
)
-- Task 8
-- Write a query to find authors who have never written a book in the 'Fantasy' genre and group the results by country.

-- Solution 1
SELECT a.name, b.genre, a.country 
FROM authors a
JOIN books b
ON b.author_id = a.author_id
GROUP BY a.name, a.country, b.genre
EXCEPT(
SELECT a.name, b.genre, a.country 
FROM authors a
JOIN books b
ON b.author_id = a.author_id
GROUP BY a.name, a.country, b.genre
HAVING b.genre = 'Fantasy'
)
ORDER BY a.country,a.name



-- Solution 2
SELECT a.name, b.genre, a.country 
FROM authors a
JOIN books b
ON b.author_id = a.author_id
GROUP BY a.name, a.country, b.genre
HAVING b.genre != 'Fantasy'
ORDER BY a.country,a.name

-- Task 9
-- Write a query to find the books that have been sold in both January and February 2024 and group the results by book title.

SELECT  b.Title
FROM Books b
JOIN sales s
ON b.book_id = s.book_id
WHERE MONTH(sale_date) = 1 and YEAR(sale_date) = 2024
GROUP BY b.title
INTERSECT
SELECT  b.Title
FROM Books b
JOIN sales s
ON b.book_id = s.book_id
WHERE MONTH(sale_date) = 2 and YEAR(sale_date) = 2024


-- Task 10
-- Write a query to display the authors whose average book price is higher than every book price in the 'Fiction' genre and group the results by author name.
SELECT * FROM authors
SELECT * FROM books
SELECT * FROM sales

GO

WITH AvgHigherThenFiction_CTE
AS
(
SELECT  AVG(b.price) AS AvgPrice,
        a.author_id,
        a.name
FROM books b
JOIN authors a
ON a.author_id = b.author_id
GROUP BY a.author_id,a.name
)
SELECT author_id, name, AvgPrice FROM AvgHigherThenFiction_CTE
WHERE AvgPrice > ALL(SELECT price FROM books
                        WHERE genre = 'Fiction')


