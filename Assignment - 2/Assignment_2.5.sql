USE Book

-- Running Total of Sales Amount by Book
-- Create a view that displays each sale for a book along with the running total of the sales amount using the OVER clause.
GO
CREATE VIEW vWSalesAmountByBook
AS(
SELECT  b.book_id, 
        s.total_amount as TotalSales,
	    SUM(s.total_amount) over(order by b.book_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as CurrentTotal
FROM sales s
JOIN books b
ON b.book_id = s.book_id
)
GO

SELECT * FROM vWSalesAmountByBook
-- Running Total of Sales Quantity by Author
-- Create a view that displays each sale for an author along with the running total of the sales quantity using the OVER clause.
GO
ALTER VIEW vWSalesQuantityByAuthor
AS(
SELECT  b.book_id,
        a.name,
        s.total_amount AS TotalSales,
        s.quantity AS TotalQuantity,
	    SUM(s.quantity) OVER(ORDER BY b.book_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS CurrentTotal,
        Avg(s.total_amount) over(Partition By b.genre order by b.book_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as CurrentAvgTotalSales
FROM sales s
JOIN books b
ON b.book_id = s.book_id
JOIN authors a
ON a.author_id = b.author_id
)
GO
SELECT * FROM vWSalesQuantityByAuthor

-- Running Total and Running Average of Sales Amount by Genre
-- Create a view that displays each sale for a genre along with both the running total and the running average of the sales amount using the OVER clause.
GO
ALTER VIEW vWSalesAmountByGenre
AS(
SELECT  b.book_id,
        a.name,
        b.genre,
        s.total_amount AS TotalSales,
        SUM(s.total_amount) over(Partition By b.genre order by b.book_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as CurrentTotalSales,
	    Avg(s.total_amount) over(Partition By b.genre order by b.book_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as CurrentAvgTotalSales
FROM sales s
JOIN books b
ON b.book_id = s.book_id
JOIN authors a
ON a.author_id = b.author_id
)
GO

SELECT * FROM vWSalesAmountByGenre