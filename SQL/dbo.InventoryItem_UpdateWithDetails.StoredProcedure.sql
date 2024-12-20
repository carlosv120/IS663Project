/****** Object:  StoredProcedure [dbo].[InventoryItem_UpdateWithDetails]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:
-- Create Date: 2024-12-07
-- Description: Updates an existing inventory item along with its associated details.
-- =============================================

CREATE PROC [dbo].[InventoryItem_UpdateWithDetails]
			 @ItemID              INT
			,@StatusID            INT
			,@Name                NVARCHAR(100)
			,@Description         NVARCHAR(255)
			,@Category            NVARCHAR(100)
			,@Notes               NVARCHAR(255)
			,@ModifiedBy          INT
			,@ItemDetailList      NVARCHAR(MAX) -- JSON string containing InventoryItemDetails
AS
/*
    Example Call:

    DECLARE    @ItemID              INT = 1
			  ,@StatusID            INT = 10
			  ,@Name                NVARCHAR(100) = 'Updated Item'
			  ,@Description         NVARCHAR(255) = 'Updated description'
			  ,@Category            NVARCHAR(100) = 'Updated Category'
			  ,@Notes               NVARCHAR(255) = 'Updated Notes'
			  ,@ModifiedBy          INT = 1
			  ,@ItemDetailList      NVARCHAR(MAX) = '[{
					"InStoreLocationID": 19
				   ,"StatusID": 10
				   ,"SupplierID": 2
				   ,"Manufacturer": "Updated Manufacturer"
				   ,"Size": "Medium"
				   ,"Color": "Blue"
				   ,"Capacity": "500ml"
				   ,"Gauge": "12G"
				   ,"Material": "Plastic"
				   ,"QuantityInStock": 300
				   ,"UnitOfMeasurement": "Pieces"
				   ,"ReorderLevel": 50
				   ,"CostPerUnit": 8.50
				   ,"SellingPricePerUnit": 15.00
				   ,"ExpirationDate": "2025-12-31T00:00:00"
				   ,"Barcode": "1122334455667"
				   ,"Notes": "Updated Details Notes"
				}]'

    EXECUTE [dbo].[InventoryItem_UpdateWithDetails]
         @ItemID
        ,@StatusID
        ,@Name
        ,@Description
        ,@Category
        ,@Notes
        ,@ModifiedBy
        ,@ItemDetailList
*/

BEGIN
    SET NOCOUNT ON
    SET XACT_ABORT ON

    DECLARE @DateModified DATETIME2 = SYSDATETIMEOFFSET() AT TIME ZONE 'UTC' AT TIME ZONE 'Eastern Standard Time'

    BEGIN TRANSACTION

    -- Update InventoryItem table
    UPDATE [dbo].[InventoryItem]
    SET
         [StatusID]       = @StatusID
        ,[Name]           = @Name
        ,[Description]    = @Description
        ,[Category]       = @Category
        ,[Notes]          = @Notes
        ,[ModifiedBy]     = @ModifiedBy
        ,[DateModified]   = @DateModified
    WHERE [ItemID] = @ItemID

    -- Create temporary table for incoming details
    CREATE TABLE #TempItemDetails (
         InStoreLocationID INT
        ,StatusID INT
        ,SupplierID INT
        ,Manufacturer NVARCHAR(50)
        ,Size NVARCHAR(50)
        ,Color NVARCHAR(50)
        ,Capacity NVARCHAR(50)
        ,Gauge NVARCHAR(50)
        ,Material NVARCHAR(50)
        ,QuantityInStock INT
        ,UnitOfMeasurement NVARCHAR(20)
        ,ReorderLevel INT
        ,CostPerUnit DECIMAL(10, 2)
        ,SellingPricePerUnit DECIMAL(10, 2)
        ,ExpirationDate DATETIME2
        ,Barcode NVARCHAR(100)
        ,Notes NVARCHAR(255)
    )

    -- Populate temporary table from JSON payload
    INSERT INTO #TempItemDetails (
         InStoreLocationID
        ,StatusID
        ,SupplierID
        ,Manufacturer
        ,Size
        ,Color
        ,Capacity
        ,Gauge
        ,Material
        ,QuantityInStock
        ,UnitOfMeasurement
        ,ReorderLevel
        ,CostPerUnit
        ,SellingPricePerUnit
        ,ExpirationDate
        ,Barcode
        ,Notes
    )
    SELECT
         JSON_VALUE(value, '$.InStoreLocationID')
        ,JSON_VALUE(value, '$.StatusID')
        ,JSON_VALUE(value, '$.SupplierID')
        ,JSON_VALUE(value, '$.Manufacturer')
        ,JSON_VALUE(value, '$.Size')
        ,JSON_VALUE(value, '$.Color')
        ,JSON_VALUE(value, '$.Capacity')
        ,JSON_VALUE(value, '$.Gauge')
        ,JSON_VALUE(value, '$.Material')
        ,JSON_VALUE(value, '$.QuantityInStock')
        ,JSON_VALUE(value, '$.UnitOfMeasurement')
        ,JSON_VALUE(value, '$.ReorderLevel')
        ,JSON_VALUE(value, '$.CostPerUnit')
        ,JSON_VALUE(value, '$.SellingPricePerUnit')
        ,JSON_VALUE(value, '$.ExpirationDate')
        ,JSON_VALUE(value, '$.Barcode')
        ,JSON_VALUE(value, '$.Notes')
    FROM OPENJSON(@ItemDetailList)

    -- Mark all existing details as inactive
    UPDATE [dbo].[InventoryItemDetails]
    SET [IsActive] = 0
    WHERE [ItemID] = @ItemID AND [IsActive] = 1

    -- Insert new details for items in the incoming list
    INSERT INTO [dbo].[InventoryItemDetails] (
         [ItemID]
        ,InStoreLocationID
        ,StatusID
        ,SupplierID
        ,Manufacturer
        ,Size
        ,Color
        ,Capacity
        ,Gauge
        ,Material
        ,QuantityInStock
        ,UnitOfMeasurement
        ,ReorderLevel
        ,CostPerUnit
        ,SellingPricePerUnit
        ,ExpirationDate
        ,Barcode
        ,Notes
        ,[CreatedBy]
        ,[ModifiedBy]
    )
    SELECT
         @ItemID AS ItemID
        ,InStoreLocationID
        ,StatusID
        ,SupplierID
        ,Manufacturer
        ,Size
        ,Color
        ,Capacity
        ,Gauge
        ,Material
        ,QuantityInStock
        ,UnitOfMeasurement
        ,ReorderLevel
        ,CostPerUnit
        ,SellingPricePerUnit
        ,ExpirationDate
        ,Barcode
        ,Notes
        ,@ModifiedBy AS CreatedBy
        ,@ModifiedBy AS ModifiedBy
    FROM #TempItemDetails

    -- Drop temporary table
    DROP TABLE #TempItemDetails

    COMMIT TRANSACTION
END
GO
