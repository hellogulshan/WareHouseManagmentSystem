USE [WHMS_DB]
GO
/****** Object:  StoredProcedure [dbo].[pr_AddNewProduct]    Script Date: 14-02-2025 6.32.24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Add new Products 
--EXEC pr_AddProduct 
--    @ProductCode = 'PROD3001', 
--    @ProductName = 'Wireless Mouse', 
--    @WarrantyDate = '2026-06-30', 
--    @ProductTypeName = 'Electronics',  -- Existing type
--    @CurrentQuantity = 150;


CREATE   PROCEDURE [dbo].[pr_AddNewProduct]
    @ProductCode NVARCHAR(50),
    @ProductName NVARCHAR(100),
    @WarrantyDate DATE = NULL,
    @ProductTypeName NVARCHAR(50),
    @CurrentQuantity INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ProductTypeID INT;

    BEGIN TRY
        -- Check if the ProductCode already exists (Ensure Unique Product)
        IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = @ProductCode)
        BEGIN
            PRINT 'Error: ProductCode already exists.';
            RETURN;
        END

        -- Check if ProductTypeName exists
        SELECT @ProductTypeID = ProductTypeID FROM ProductTypes WHERE ProductTypeName = @ProductTypeName;

        -- If ProductTypeName does not exist, insert it and get the new ProductTypeID using SCOPE_IDENTITY()
        IF @ProductTypeID IS NULL
        BEGIN
            INSERT INTO ProductTypes (ProductTypeName) 
            VALUES (@ProductTypeName);
            
            -- Get the newly inserted ProductTypeID
            SET @ProductTypeID = SCOPE_IDENTITY();
        END

        -- Insert the product with the determined ProductTypeID
        INSERT INTO Products (ProductCode, ProductName, WarrantyDate, ProductTypeID, CurrentQuantity)
        VALUES (@ProductCode, @ProductName, @WarrantyDate, @ProductTypeID, @CurrentQuantity);

        PRINT 'Product added successfully';
    END TRY
    BEGIN CATCH
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH;
END;

GO
/****** Object:  StoredProcedure [dbo].[pr_DeleteProductById]    Script Date: 14-02-2025 6.32.24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Delete Records By Product Id
--EXEC pr_DeleteProductById @ProductID = 3;

CREATE   PROCEDURE [dbo].[pr_DeleteProductById]
    @ProductID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- First, delete related records in OrderItems
        DELETE FROM OrderItems WHERE ProductID = @ProductID;

        -- Now, delete the product itself
        DELETE FROM Products WHERE ProductID = @ProductID;

        -- Return number of affected rows
        SELECT @@ROWCOUNT AS RowsAffected;
    END TRY
    BEGIN CATCH
        -- Return error message if deletion fails
        SELECT ERROR_MESSAGE() AS ErrorMessage;
    END CATCH;
END;
GO
/****** Object:  StoredProcedure [dbo].[pr_GetAllOrders]    Script Date: 14-02-2025 6.32.24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--get all order details
--exec pr_getAllOrders
CREATE   PROCEDURE [dbo].[pr_GetAllOrders]
AS
BEGIN
select o.OrderID,o.OrderDate,p.ProductName,p.WarrantyDate,
		oi.Quantity,o.CustomerName,o.CustomerAddress,do.DeliveryOptionName,
		o.FulfillmentDate
from Orders O,OrderItems oi,DeliveryOptions do,Products p 
where 
oi.ProductID = p.ProductID
and
o.OrderID = oi.OrderID
and
o.DeliveryOptionID = do.DeliveryOptionID
END
GO
/****** Object:  StoredProcedure [dbo].[pr_GetAllProducts]    Script Date: 14-02-2025 6.32.24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Retrieve all Products  --EXEC pr_GetAllProducts;  CREATE   PROCEDURE [dbo].[pr_GetAllProducts]  AS  BEGIN      SELECT P.ProductId, 		p.ProductTypeID,        P.ProductCode,         P.ProductName,         P.WarrantyDate,         PT.ProductTypeName,  -- Rename the column        P.CurrentQuantity   FROM Products P      INNER JOIN ProductTypes PT ON P.ProductTypeID = PT.ProductTypeID  END;
GO
/****** Object:  StoredProcedure [dbo].[pr_GetOrdersByDate]    Script Date: 14-02-2025 6.32.24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Retrieve all Orders By Date
--EXEC pr_GetOrdersByDate @StartDate = '2024-01-01', @EndDate = '2024-02-01';
CREATE PROCEDURE [dbo].[pr_GetOrdersByDate]
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SELECT 
        o.OrderID,
        o.OrderDate,
        o.CustomerName,
        o.CustomerAddress,
        d.DeliveryOptionName,
        o.FulfillmentDate
    FROM Orders o
    INNER JOIN DeliveryOptions d ON o.DeliveryOptionID = d.DeliveryOptionID
    WHERE o.OrderDate BETWEEN @StartDate AND @EndDate
    ORDER BY o.OrderDate DESC;
END;
GO
/****** Object:  StoredProcedure [dbo].[pr_GetProductById]    Script Date: 14-02-2025 6.32.24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Retrieve Products By Id--EXEC pr_GetProductById @ProductID = 1;CREATE   PROCEDURE [dbo].[pr_GetProductById]      @ProductID INT  AS  BEGIN      SELECT         P.ProductId,          P.ProductTypeID,          P.ProductCode,          P.ProductName,          P.WarrantyDate,          PT.ProductTypeName,          P.CurrentQuantity      FROM Products P      INNER JOIN ProductTypes PT ON P.ProductTypeID = PT.ProductTypeID      WHERE P.ProductId = @ProductID;  END;
GO
/****** Object:  StoredProcedure [dbo].[pr_GetProductsByTypeId]    Script Date: 14-02-2025 6.32.24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Retrieve all Products By Type Id
--EXEC pr_GetProductsByTypeId @ProductTypeID = 1;
CREATE PROCEDURE [dbo].[pr_GetProductsByTypeId]
    @ProductTypeID INT
AS
BEGIN
    SELECT * FROM Products P
    INNER JOIN ProductTypes PT ON P.ProductTypeID = PT.ProductTypeID
    WHERE P.ProductTypeID = @ProductTypeID ORDER BY P.ProductName ASC;
END;
GO
/****** Object:  StoredProcedure [dbo].[pr_GetProductTypes]    Script Date: 14-02-2025 6.32.24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Retrieve all ProductTypes
--EXEC pr_GetProductTypes;
  
CREATE PROCEDURE [dbo].[pr_GetProductTypes]
AS
BEGIN
    SELECT * FROM ProductTypes;
END;
GO
/****** Object:  StoredProcedure [dbo].[pr_InsertOrder]    Script Date: 14-02-2025 6.32.24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--EXEC pr_InsertOrder '2025-02-13','GUDDU','RAIPUR',3,'PROD1001',10

CREATE   PROCEDURE [dbo].[pr_InsertOrder]
(
    @orderDate DATE = NULL,
    @customerName VARCHAR(20),
    @customerAddress NVARCHAR(50),
    @deliveryOptionId INT,
    @productCode VARCHAR(20),
    @orderQuantity INT
)
AS
BEGIN
    DECLARE @fulfillmentDate DATE,
            @productId INT,
            @orderId INT,
            @availableQuantity INT;

    -- If @orderDate is NULL, set it to the current date
    IF @orderDate IS NULL
        SET @orderDate = GETDATE();

    -- Calculate Fulfillment Date
    SET @fulfillmentDate = DATEADD(DAY, 7, @orderDate);

    BEGIN TRANSACTION;

    BEGIN TRY
        -- Insert into Orders
        INSERT INTO Orders (OrderDate, CustomerName, CustomerAddress, DeliveryOptionID, FulfillmentDate)
        VALUES (@orderDate, @customerName, @customerAddress, @deliveryOptionId, @fulfillmentDate);

        -- Get the last inserted OrderID
        SET @orderId = SCOPE_IDENTITY();

        -- Get Product ID
        SELECT @productId = ProductID FROM Products WHERE ProductCode = @productCode;

        -- Validate if Product exists
        IF @productId IS NULL
        BEGIN
            ROLLBACK TRANSACTION;
            PRINT 'Transaction rolled back: Product not found!';
            THROW 50001, 'Product with the given code does not exist.', 1;
            RETURN;
        END

        -- Get Available Quantity
        SELECT @availableQuantity = CurrentQuantity FROM Products WHERE ProductID = @productId;

        -- Check if stock is sufficient
        IF @availableQuantity >= @orderQuantity
        BEGIN
            -- Insert into OrderItems
            INSERT INTO OrderItems (OrderID, ProductID, Quantity)
            VALUES (@orderId, @productId, @orderQuantity);

            -- Update Product Quantity
            UPDATE Products
            SET CurrentQuantity = CurrentQuantity - @orderQuantity
            WHERE ProductID = @productId;

            -- Commit transaction if everything succeeds
            COMMIT TRANSACTION;
            PRINT 'Transaction committed successfully!';
        END
        ELSE
        BEGIN
            -- Rollback transaction if stock is insufficient
            ROLLBACK TRANSACTION;
            PRINT 'Transaction rolled back: Insufficient stock!';
            THROW 50002, 'Insufficient stock available for the requested product.', 1;
            RETURN;
        END
    END TRY

    BEGIN CATCH
        -- Rollback transaction if any error occurs
        ROLLBACK TRANSACTION;
        PRINT 'Transaction rolled back due to an error!';
        
        -- Display error details
        PRINT ERROR_MESSAGE();
        THROW;
    END CATCH;
END;
GO
/****** Object:  StoredProcedure [dbo].[pr_UpdateProduct]    Script Date: 14-02-2025 6.32.24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Update Product
--EXEC pr_UpdateProduct 
--    @ProductId = 1, 
--    @ProductCode = 'PROD1001', 
--    @ProductName = 'Laptop', 
--    @WarrantyDate = '2024-12-31', 
--    @ProductTypeID = 1, 
--    @ProductTypeName = 'Electronics', 
--    @CurrentQuantity = 50;


CREATE   PROCEDURE [dbo].[pr_UpdateProduct]
    @ProductId INT,
    @ProductCode NVARCHAR(50),
    @ProductName NVARCHAR(100),
    @WarrantyDate DATE,
    @ProductTypeID INT,
    @ProductTypeName NVARCHAR(100),
    @CurrentQuantity INT,
    @RowsAffected INT OUTPUT  -- Output parameter to return affected rows
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Check if the product exists
        IF NOT EXISTS (SELECT 1 FROM Products WHERE ProductId = @ProductId)
        BEGIN
            SET @RowsAffected = 0;
            RETURN;
        END

        -- Validate ProductTypeID and ProductTypeName (Ensure they match)
        IF NOT EXISTS (
            SELECT 1 FROM ProductTypes 
            WHERE ProductTypeID = @ProductTypeID 
            AND ProductTypeName = @ProductTypeName
        )
        BEGIN
            SET @RowsAffected = 0;
            RETURN;
        END

        -- Validate CurrentQuantity (ensure it's not negative)
        IF @CurrentQuantity < 0
        BEGIN
            SET @RowsAffected = 0;
            RETURN;
        END

        -- Perform update
        UPDATE p
        SET 
            p.ProductCode = @ProductCode,
            p.ProductName = @ProductName,
            p.WarrantyDate = @WarrantyDate,
            p.ProductTypeID = @ProductTypeID,
            p.CurrentQuantity = @CurrentQuantity
        FROM Products p
        INNER JOIN ProductTypes pt ON p.ProductTypeID = pt.ProductTypeID
        WHERE p.ProductId = @ProductId;

        -- Return number of affected rows
        SET @RowsAffected = @@ROWCOUNT;
    END TRY
    BEGIN CATCH
        SET @RowsAffected = -1; -- Error case
    END CATCH;
END;

GO
