USE Book

-- Inline Table-Valued Function (iTVF)
-- Create an inline table-valued function that returns the total sales amount for each book and use it in a query to display the results.

GO
CREATE FUNCTION TotalSalesForEachBook(@BookID INT)
RETURNS TABLE 
AS
RETURN (
SELECT  a.name,
        b.book_id,
        SUM(s.total_amount) AS TotalSales
FROM books b
JOIN sales s 
ON s.book_id = b.book_id
JOIN authors a
ON a.author_id = b.author_id
GROUP BY b.book_id,a.name
HAVING b.book_id = @BookID 
)
GO

SELECT * FROM TotalSalesForEachBook(1)
-- Multi-Statement Table-Valued Function (MTVF)
-- Create a multi-statement table-valued function that returns the total quantity sold for each genre and use it in a query to display the results.

GO
CREATE FUNCTION TotalQuantitySoldForGenre()
RETURNS @TotalQuantitySold TABLE(Genre VARCHAR(20),TotalQuantity INT)
BEGIN
    INSERT @TotalQuantitySold
    SELECT b.Genre, SUM(s.quantity) AS QuantitySold
    FROM books b
    JOIN sales s
    ON b.book_id = s.book_id
    GROUP BY b.genre
    RETURN;
END
GO

SELECT * FROM TotalQuantitySoldForGenre()

-- Scalar Function
-- Create a scalar function that returns the average price of books for a given author and use it in a query to display the average price for 'Jane Austen'.
GO
CREATE FUNCTION AvgBookPriceForAuthor(@Author VARCHAR(30))
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN(
        SELECT AVG(b.price) AS AvgBooksPrice 
        FROM books b
        JOIN authors a
        ON a.author_id = b.author_id
        GROUP BY b.author_id,a.name
        HAVING a.name = @Author
    )
END
GO

SELECT dbo.AvgBookPriceForAuthor('Jane Austen') AS AvgBooksPrice

-- Stored Procedure for Books with Minimum Sales
-- Create a stored procedure that returns books with total sales above a specified amount and use it to display books with total sales above $40.

GO
ALTER PROC sp_BooksWithMinSales
@Amount DECIMAL(10,2)
AS
BEGIN
    SELECT s.Book_id,
            b.Title,
            b.Genre,
            SUM(s.total_amount) AS TotalSales
    FROM sales s
    JOIN books b
    ON b.book_id = s.book_id
    GROUP BY s.book_id,b.title,b.genre
    HAVING SUM(s.total_amount) > @Amount
END
GO

EXEC sp_BooksWithMinSales 40

-- Indexing for Performance Improvement
-- Create an index on the sales table to improve query performance for queries filtering by book_id.



-- Export Data as XML
-- Write a query to export the authors and their books as XML.

SELECT  a.name AS [Author], 
        b.title AS [Title]
FROM authors a
JOIN books b
ON b.author_id = a.author_id
ORDER BY a.name
FOR XML PATH('Book'), ROOT('Books')


-- Export Data as JSON
-- Write a query to export the authors and their books as JSON.


SELECT  a.name AS 'Author', 
        b.title AS 'Title'
FROM authors a
JOIN books b
ON b.author_id = a.author_id
ORDER BY a.name
FOR JSON PATH, ROOT('Books')

-- Scalar Function for Total Sales in a Year
-- Create a scalar function that returns the total sales amount in a given year and use it in a query to display the total sales for 2024.

GO
CREATE FUNCTION TotalSalesInYear(@Year DATE)
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN  ( SELECT SUM(total_amount)
    FROM sales
    WHERE YEAR(sale_date) = YEAR(@Year)
    GROUP BY YEAR(sale_date)
    )
END
GO

SELECT dbo.TotalSalesInYear('2024') AS TotalSales

--- ITVF Solution-2
GO
ALTER FUNCTION TSY(@Year DATE)
RETURNS TABLE
AS
RETURN(
    SELECT  FORMAT(sale_date,'yyyy') AS Year,
        SUM(total_amount) As TotalSales 
    FROM sales
    WHERE YEAR(sale_date) = YEAR(@Year)
    GROUP BY FORMAT(sale_date,'yyyy')
)
GO

SELECT * FROM TSY('2025')
-- Stored Procedure for Genre Sales Report
-- Create a stored procedure that returns a sales report for a specific genre, including total sales and average sales, and use it to display the report for 'Fiction'.
Select * FROM Sales

GO
CREATE PROC sp_GenreSalesReport
@Genre VARCHAR(20)
AS
BEGIN
    SELECT  b.Genre,
            AVG(s.total_amount) AS AvgSales,
            SUM(s.total_amount) AS TotalSales
    FROM sales s
    JOIN books b
    ON s.book_id = b.book_id
    GROUP BY b.genre
    HAVING b.genre = @Genre
END
GO

EXEC sp_GenreSalesReport 'Fiction'

-- Ranking Books by Average Rating (assuming a ratings table)
-- Write a query to rank books by their average rating and display the top 3 books. Assume a ratings table with book_id and rating columns.
SELECT * FROM Books
GO
CREATE TABLE Ratings(book_id INT, rating DECIMAL(10,1))
INSERT INTO Ratings VALUES
(1,3),
(2,4.5),
(3,4),
(4,3.8),
(5,3.6),
(11,4.2);
SELECT * FROM Ratings

GO
WITH AvgRatings_CTE
AS(
SELECT  b.title, 
        r.rating, 
        DENSE_RANK() OVER (ORDER BY r.rating DESC) AS RANK 
FROM books b
JOIN Ratings r
ON b.book_id = r.book_id
)

SELECT * FROM AvgRatings_CTE
WHERE Rank < 4