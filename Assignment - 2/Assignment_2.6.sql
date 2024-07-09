USE book

SELECT * FROM authors
SELECT * FROM books
SELECT * FROM sales

-- Trigger to Update Total Sales After Insert on Sales Table
-- Create a trigger that updates the total sales for a book in the books table after a new record is inserted into the sales table.
GO
CREATE TRIGGER TGR_UpdateTotalSales
ON sales
AFTER INSERT
AS
BEGIN
     
END
GO

-- Trigger to Log Deletions from the Sales Table
-- Create a trigger that logs deletions from the sales table into a sales_log table with the sale_id, book_id, and the delete_date.

CREATE TABLE sales_log(sales_id INT, book_id INT, delete_date DATE)

GO
CREATE TRIGGER TGR_SalesDeleteLog
ON sales
AFTER DELETE
AS
BEGIN
    INSERT INTO sales_log
    SELECT sale_id,book_id,GetDate()
    FROM deleted
END
GO

DELETE FROM sales
WHERE sale_id = 8

SELECT * FROM sales_log
SELECT * FROM sales

-- Trigger to Prevent Negative Quantity on Update
-- Create a trigger that prevents updates to the sales table if the new quantity is negative.

GO
CREATE TRIGGER TGR_PreventNegQuantity
ON sales
AFTER UPDATE
AS
BEGIN
    DECLARE @quantity INT
    DECLARE @sale_id INT
    BEGIN TRANSACTION NegQunatity
    BEGIN TRY
    IF @quantity < 0
        THROW 50001,'Quantity is Negative',1;
    ELSE 
        UPDATE sales
        SET quantity = @quantity
        WHERE sale_id = @sale_id
    COMMIT TRANSACTION NegQunatity
    END TRY
    BEGIN CATCH 
        ROLLBACK TRANSACTION NegQunatity;
        PRINT CONCAT('Error Number : ',Error_Number())
        PRINT CONCAT('Error Message : ',Error_Message())
        PRINT CONCAT('Error State : ',Error_State())
    END CATCH
END 
GO

UPDATE sales
SET quantity = -2
WHERE sale_id = 6

SELECT * FROM sales