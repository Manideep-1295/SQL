USE BOOK

SELECT * FROM books

-- 1. Add New Book and Update Author's Average Price
-- Create a stored procedure that adds a new book and updates the average price of books for the author. 
-- Ensure the price is positive, use transactions to ensure data integrity, and return the new average price.

INSERT INTO books VALUES 
(12, 'Harry Potter', 2, 'Fantasy', 25.00),
(13, 'Adventures of Huckleberry Finn', 3, 'Fiction', 10.00)

GO
CREATE PROC sp_AddNewBook

SELECT  a.author_id,
        AVG(s.total_amount) AS Avg
FROM sales s
JOIN books b
ON b.book_id = s.book_id
JOIN authors a
ON a.author_id = b.author_id
GROUP BY a.author_id
GO


-- 2. Delete Book and Update Author's Total Sales
-- Create a stored procedure that deletes a book and updates the author's total sales. 
-- Ensure the book exists, use transactions to ensure data integrity, and return the new total sales for the author.



-- 3. Transfer Book Sales to Another Book
-- Create a stored procedure that transfers sales from one book to another and updates the total sales for both books. 
-- Ensure both books exist, use transactions to ensure data integrity, and return the new total sales for both books.



-- 4. Add Sale and Update Book Quantity
-- Create a stored procedure that adds a sale and updates the total quantity sold for the book. 
-- Ensure the quantity is positive, use transactions to ensure data integrity, and return the new total quantity sold for the book.



-- 5. Update Book Price and Recalculate Author's Average Price
-- Create a stored procedure that updates the price of a book and recalculates the average price of books for the author. 
-- Ensure the price is positive, use transactions to ensure data integrity, and return the new average price.



SELECT  a.author_id,
        AVG(s.total_amount) AS Avg
FROM sales s
JOIN books b
ON b.book_id = s.book_id
JOIN authors a
ON a.author_id = b.author_id
GROUP BY a.author_id