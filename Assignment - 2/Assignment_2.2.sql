Use BOOK


SELECT * FROM authors
SELECT * FROM books
SELECT * FROM sales
GO
-- Task 1: Stored Procedure for Total Sales by Author
-- Create a stored procedure to get the total sales amount for a specific author and write a query to call the procedure for 'J.K. Rowling'.

SELECT SUM(s.total_amount) AS Total FROM sales s
    JOIN books b
    ON b.book_id = s.book_id
    JOIN authors a 
    ON a.author_id = b.author_id
    WHERE a.name = 'J.K. Rowling'

GO
ALTER PROC sp_TotalSalesByAuthor
@AuthorName VARCHAR(30)
AS 
BEGIN
    SELECT SUM(s.total_amount) AS Total FROM sales s
    JOIN books b
    ON b.book_id = s.book_id
    JOIN authors a 
    ON a.author_id = b.author_id
    WHERE a.name  = @AuthorName
END
GO

EXEC sp_TotalSalesByAuthor 'J.K. Rowling'

-- Task 2: Function to Calculate Total Quantity Sold for a Book
-- Create a function to calculate the total quantity sold for a given book title and write a query to use this function for '1984'.
GO
CREATE FUNCTION TotalQuantitySold(@Title VARCHAR(50))
RETURNS TABLE 
AS
RETURN(
    SELECT b.title,b.genre,SUM(s.quantity) AS QuantitySold FROM books b
    JOIN sales s
    ON s.book_id = b.book_id
    GROUP BY b.title,b.genre
    HAVING b.title = @Title
)
GO
SELECT * FROM dbo.TotalQuantitySold('1984')
-- Task 3: View for Best-Selling Books
-- Create a view to show the best-selling books (those with total sales amount above $30) and write a query to select from this view.
GO
CREATE VIEW vWBestSellingBooks
AS
SELECT b.title,b.genre, s.total_amount
FROM books b
JOIN sales s 
ON s.book_id = b.book_id
WHERE s.total_amount > 30
GO

SELECT * FROM vWBestSellingBooks
ORDER BY total_amount DESC
-- Task 4: Stored Procedure for Average Book Price by Author
-- Create a stored procedure to get the average price of books for a specific author and write a query to call the procedure for 'Mark Twain'.

GO
ALTER PROC sp_AvgBookPriceByAuthor
@AuthorName VARCHAR(30)
AS
BEGIN
    SELECT  a.Author_id, 
            a.name,
            COUNT(b.title) No_Of_Books,
            AVG(b.price) AvgBookPrice
    FROM authors a
    JOIN books b 
    ON b.author_id = a.author_id
    WHERE a.name = @AuthorName
    GROUP BY a.author_id,a.name
END

EXEC sp_AvgBookPriceByAuthor 'Mark Twain'

-- Task 5: Function to Calculate Total Sales in a Month
-- Create a function to calculate the total sales amount in a given month and year, and write a query to use this function for January 2024.
GO
ALTER FUNCTION MonthlyTotalSales(@Date DATE)
RETURNS TABLE
AS
RETURN(
    SELECT  FORMAT(sale_date,'yyyy-MM') AS Month,
        SUM(total_amount) As TotalSales 
    FROM sales
    WHERE MONTH(sale_date) = MONTH(@Date) and YEAR(sale_date) = YEAR(@Date)
    GROUP BY FORMAT(sale_date,'yyyy-MM')
)
GO


SELECT * FROM dbo.MonthlyTotalSales('April 2024')

-- Task 6: View for Authors with Multiple Genres
-- Create a view to show authors who have written books in multiple genres and write a query to select from this view.
GO 
CREATE VIEW vWAuthorsWithMultipleGenres
AS
SELECT Name FROM authors 
WHERE author_id IN ( SELECT author_id
                        FROM books
                        GROUP BY author_id
                        HAVING COUNT(DISTINCT genre) > 1
)
GO
SELECT * FROM vWAuthorsWithMultipleGenres
ORDER BY name

-- Task 7: Ranking Authors by Total Sales
-- Write a query to rank authors by their total sales amount and display the top 3 authors.

GO
WITH TopAuthors_CTE
AS (
SELECT  b.author_id,
        a.name,
        SUM(s.total_amount) AS TotalSales,
        DENSE_RANK() OVER (ORDER By SUM(s.total_amount) DESC ) AS Rank
FROM books b
JOIN sales s 
ON s.book_id = b.book_id
JOIN authors a
ON a.author_id = b.author_id
GROUP BY b.author_id,a.name
)

SELECT Name, TotalSales 
FROM TopAuthors_CTE
WHERE Rank < 4

GO
-- Task 8: Stored Procedure for Top-Selling Book in a Genre
-- Create a stored procedure to get the top-selling book in a specific genre and write a query to call the procedure for 'Fantasy'.
GO
ALTER PROC sp_TopSellingBooks
@Genre VARCHAR(20)
AS
BEGIN
    WITH TopBook_CTE
    AS(
    SELECT  b.book_id,
            b.title,
            b.genre,
            SUM(s.total_amount) AS TotalSalesAmount,
            DENSE_RANK() OVER (Partition By b.genre ORDER BY s.total_amount DESC) AS RANK
    FROM books b
    JOIN sales s
    ON s.book_id = b.book_id
    GROUP BY b.book_id,
             b.title,
             b.genre,
             s.total_amount
    )
    SELECT Title, Genre, TotalSalesAmount FROM TopBook_CTE
    WHERE Genre = @Genre and Rank < 2
END

EXEC sp_TopSellingBooks 'Fantasy'

-- Task 9: Function to Calculate Average Sales Per Genre
-- Create a function to calculate the average sales amount for books in a given genre and write a query to use this function for 'Romance'.
GO
CREATE FUNCTION AvgSalesPerGenre(@Genre VARCHAR(20))
RETURNS TABLE
AS
RETURN(
    SELECT  b.genre,
            AVG(s.total_amount) AS AvgSalesAmount
    FROM books b
    JOIN sales s
    ON s.book_id = b.book_id
    GROUP BY b.genre
)
GO

SELECT * FROM dbo.AvgSalesPerGenre('Fantasy')

