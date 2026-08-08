--Step 1: Write a Query 
--For US ustomer Find the Total Number Of customer and the average score

SELECT 
    COUNT(*) TotalCustomers,
    AVG(Score) AvgScore
FROM Sales.Customers
WHERE Country = 'USA'

--Step 2 : Turning the Query Into a Stored Procedure

CREATE PROCEDURE GetCustomerSummary AS
BEGIN
SELECT
    COUNT(*) TotalCustomers,
    AVG(Score) AvgScore
FROM Sales.Customers
WHERE Country = 'USA'
END

--Step 3 : Execute the Stored Procedure
EXEC GetCustomerSummary



--Defining the Stored Procedure Parameters
ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA'
AS
BEGIN
    BEGIN TRY
          DECLARE @TotalCustomers INT,  @AvgScore FLOAT;

        -------------------------------------
        --Step 1: Preparing and Cleaning Data
        -------------------------------------
        IF EXISTS (SELECT 1 FROM Sales.Customers WHERE Score IS NULL AND Country = @Country)
        BEGIN
            PRINT 'Updating NULL Scores to 0';
            UPDATE Sales.Customers
            SET Score = 0
            WHERE Score IS NULL AND Country = @Country;
        END

        ELSE
        BEGIN
            PRINT 'No NULL Scores found';
        END;

        ------------------------------------
        -- Stp 2: Generating Customer Report
        ------------------------------------
        -- Calulate Total Customers and Average Score for Specific Country
        SELECT
            @TotalCustomers = COUNT(*),
            @AvgScore = AVG(Score)
        FROM Sales.Customers
        WHERE Country = @Country;

        PRINT 'Total Customers from ' + @Country + ': '  + CAST(@TotalCustomers AS NVARCHAR);
        PRINT 'Average Score from ' + @Country + ': '  + CAST(@AvgScore AS NVARCHAR);

        -----------------------------------------------------------------------
        --Calulate Total Numbers of Orders and Total Sales for Specific Country
        -----------------------------------------------------------------------
        SELECT
            COUNT(*) AS TotalOrders,
            SUM(Sales) AS TotalSales
        FROM Sales.Orders o
        JOIN Sales.Customers c
        ON c.CustomerID = o.CustomerID
        WHERE c.Country = @Country;

    END TRY
    BEGIN CATCH
        --Error Handling
        PRINT('An error occure.');
        PRINT('Error Message: ' + ERROR_MESSAGE());
        PRINT('Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR));
        PRINT('Error Line: ' + CAST(ERROR_LINE() AS NVARCHAR));
        PRINT('Error Proedure ' + ERROR
    END CATCH
END
GO

--Execute
EXEC GetCustomerSummary @Country = 'Germany'
EXEC GetCustomerSummary 

