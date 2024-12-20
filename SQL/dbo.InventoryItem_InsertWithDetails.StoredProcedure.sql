/****** Object:  StoredProcedure [dbo].[InventoryItem_InsertWithDetails]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:
-- Create Date: 2024-12-07
-- Description: Inserts a new inventory item along with its details.
-- =============================================

CREATE PROC [dbo].[InventoryItem_InsertWithDetails]
     @StatusID              INT
    ,@Name                  NVARCHAR(100)
    ,@Description           NVARCHAR(255)
    ,@Category              NVARCHAR(100)
    ,@Notes                 NVARCHAR(255)
    ,@ItemDetailList        NVARCHAR(MAX) -- JSON string containing InventoryItemDetails
    ,@CreatedBy             INT
AS
/*
    Example Call:

    DECLARE 
           @StatusID           INT = 10
          ,@Name               NVARCHAR(100) = 'New Item'
          ,@Description        NVARCHAR(255) = 'Description'
          ,@Category           NVARCHAR(100) = 'Category'
          ,@Notes              NVARCHAR(255) = 'Notes'
          ,@ItemDetailList     NVARCHAR(MAX) = '[{
                "InStoreLocationID": 1,
                "StatusID": 2,
                "SupplierID": 3,
                "Manufacturer": "Manufacturer A",
                "Size": "Large",
                "Color": "Red",
                "Capacity": "50ml",
                "Gauge": "12",
                "Material": "Plastic",
                "QuantityInStock": 100,
                "UnitOfMeasurement": "Pieces",
                "ReorderLevel": 50,
                "CostPerUnit": 5.25,
                "SellingPricePerUnit": 10.50,
                "ExpirationDate": "2025-12-31T00:00:00",
                "Barcode": "123456789012",
                "Notes": "Fragile"
            }]'
          ,@CreatedBy          INT = 1

    EXECUTE [dbo].[InventoryItem_InsertWithDetails]
         @StatusID
        ,@Name
        ,@Description
        ,@Category
        ,@Notes
        ,@ItemDetailList
        ,@CreatedBy

	SELECT * FROM InventoryItem WHERE ItemID = 10
	SELECT * FROM InventoryItemDetails WHERE ItemID = 10
*/

BEGIN
    SET NOCOUNT ON
    SET XACT_ABORT ON

    -- Begin transaction
    BEGIN TRANSACTION

    -- Declare a consistent timestamp
    DECLARE @DateCreated DATETIME2 = SYSDATETIMEOFFSET() AT TIME ZONE 'UTC' AT TIME ZONE 'Eastern Standard Time'

    -- Insert into InventoryItem table
    INSERT INTO [dbo].[InventoryItem] (
         [StatusID]
        ,[Name]
        ,[Description]
        ,[Category]
        ,[Notes]
        ,[CreatedBy]
        ,[ModifiedBy]
        ,[DateCreated]
        ,[DateModified]
    )
    VALUES (
         @StatusID
        ,@Name
        ,@Description
        ,@Category
        ,@Notes
        ,@CreatedBy
        ,@CreatedBy
        ,@DateCreated
        ,@DateCreated
    )

    -- Capture the new ItemID
    DECLARE @ItemID INT = SCOPE_IDENTITY()

    -- Insert into InventoryItemDetails table
    INSERT INTO [dbo].[InventoryItemDetails] (
         [ItemID]
        ,[InStoreLocationID]
        ,[StatusID]
        ,[SupplierID]
        ,[Manufacturer]
        ,[Size]
        ,[Color]
        ,[Capacity]
        ,[Gauge]
        ,[Material]
        ,[QuantityInStock]
        ,[UnitOfMeasurement]
        ,[ReorderLevel]
        ,[CostPerUnit]
        ,[SellingPricePerUnit]
        ,[ExpirationDate]
        ,[Barcode]
        ,[Notes]
        ,[CreatedBy]
        ,[ModifiedBy]
        ,[DateCreated]
        ,[DateModified]
    )
    SELECT
         @ItemID AS ItemID
        ,JSON_VALUE(value, '$.InStoreLocationID') AS InStoreLocationID
        ,JSON_VALUE(value, '$.StatusID') AS StatusID
        ,JSON_VALUE(value, '$.SupplierID') AS SupplierID
        ,JSON_VALUE(value, '$.Manufacturer') AS Manufacturer
        ,JSON_VALUE(value, '$.Size') AS Size
        ,JSON_VALUE(value, '$.Color') AS Color
        ,JSON_VALUE(value, '$.Capacity') AS Capacity
        ,JSON_VALUE(value, '$.Gauge') AS Gauge
        ,JSON_VALUE(value, '$.Material') AS Material
        ,JSON_VALUE(value, '$.QuantityInStock') AS QuantityInStock
        ,JSON_VALUE(value, '$.UnitOfMeasurement') AS UnitOfMeasurement
        ,JSON_VALUE(value, '$.ReorderLevel') AS ReorderLevel
        ,JSON_VALUE(value, '$.CostPerUnit') AS CostPerUnit
        ,JSON_VALUE(value, '$.SellingPricePerUnit') AS SellingPricePerUnit
        ,JSON_VALUE(value, '$.ExpirationDate') AS ExpirationDate
        ,JSON_VALUE(value, '$.Barcode') AS Barcode
        ,JSON_VALUE(value, '$.Notes') AS Notes
        ,@CreatedBy AS CreatedBy
        ,@CreatedBy AS ModifiedBy
        ,@DateCreated AS DateCreated
        ,@DateCreated AS DateModified
    FROM OPENJSON(@ItemDetailList)

    -- Commit transaction
    COMMIT TRANSACTION

    -- Return the new ItemID
    SELECT @ItemID AS ItemID
END
GO
