# SQL-Stored-Procedures

```
# Customer Summary Stored Procedure

A SQL Server stored procedure that reports on customers, scores, orders, and sales for a given country.

## What it does

1. **Step 1 — Ad-hoc query**: Counts US customers and averages their Score.
2. **Step 2 — Wrap in a procedure**: Turns that query into GetCustomerSummary.
3. **Step 3 — Execute**: Runs the procedure with EXEC GetCustomerSummary.
4. **Parameterize & extend**: ALTER PROCEDURE adds a @Country parameter (default 'USA') and expands the logic into three parts:
   - **Data cleaning**: sets any NULL Score values to 0 for the selected country, with a PRINT message either way.
   - **Customer report**: computes TotalCustomers and AvgScore for the selected country and prints them.
   - **Orders report**: joins Sales.Orders to Sales.Customers to return TotalOrders and TotalSales for the selected country.
   - **Error handling**: wraps everything in TRY...CATCH, printing the error message, number, and line on failure.

## Requirements

- SQL Server (uses NVARCHAR, TRY...CATCH, ERROR_MESSAGE(), etc. — T-SQL syntax).
- Tables Sales.Customers (with CustomerID, Country, Score) and Sales.Orders (with CustomerID, Sales).

## Usage

-- Default country (USA)
EXEC GetCustomerSummary;

-- Specific country
EXEC GetCustomerSummary @Country = 'Germany';

## Known issue — script won't run as-is

The CATCH block has an incomplete line:

PRINT('Error Proedure ' + ERROR
END CATCH

This is missing the function call and closing parenthesis, so it will throw a syntax error. Fix it to something like:

PRINT('Error Procedure: ' + ISNULL(ERROR_PROCEDURE(), 'N/A'));

(ERROR_PROCEDURE() returns NULL if the error didn't occur inside a stored procedure, so wrapping it in ISNULL avoids a NULL concatenation issue when casting/printing.)

## Notes / suggestions

- PRINT output is only visible in tools like SSMS's Messages tab — it won't be returned as query results to an application. Consider RAISERROR/THROW or an output parameter if the caller needs to detect success/failure programmatically.
- The final two EXEC statements at the bottom (Germany and default) are example calls, not part of the procedure definition — run them after the GO batch separator.
- Since @AvgScore is FLOAT, casting directly to NVARCHAR may produce scientific notation for some values; consider CAST(@AvgScore AS NVARCHAR(20)) or ROUND() first if you want cleaner output.
```
