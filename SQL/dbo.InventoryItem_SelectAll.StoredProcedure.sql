/****** Object:  StoredProcedure [dbo].[InventoryItem_SelectAll]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:
-- Create Date: 2024-12-07
-- Description: Retrieves paginated list of active inventory items with their details in JSON format.
-- =============================================

CREATE PROC [dbo].[InventoryItem_SelectAll]
    @PageIndex INT
    ,@PageSize INT
AS
/*
    Example Call:

    DECLARE @PageIndex INT = 1
           ,@PageSize  INT = 10

    EXECUTE [dbo].[InventoryItem_SelectAll]
											 @PageIndex
											,@PageSize

    SELECT * FROM [dbo].[InventoryItem]
    SELECT * FROM [dbo].[InventoryItemDetails]
*/

BEGIN
    SET NOCOUNT ON

    DECLARE @Offset INT = (@PageIndex - 1) * @PageSize

    -- Return total count of active inventory items
    SELECT COUNT(*) AS TotalCount
    FROM [dbo].[InventoryItem]
    WHERE IsActive = 1

    -- Select paginated inventory items with JSON details
    SELECT
         [i].[ItemID],
         [i].[StatusID],
         [i].[Name],
         [i].[Description],
         [i].[Category],
         [i].[Notes],
         [uC].[FirstName] AS [CreatedByFirstName],
         [uC].[LastName] AS [CreatedByLastName],
         [uM].[FirstName] AS [ModifiedByFirstName],
         [uM].[LastName] AS [ModifiedByLastName],
         [i].[DateCreated],
         [i].[DateModified],
         ItemDetails = (
            SELECT
                 [id].[ItemDetailID],
                 [id].[InStoreLocationID],
                 [id].[StatusID],
                 [id].[SupplierID],
                 [id].[Manufacturer],
                 [id].[Size],
                 [id].[Color],
                 [id].[Capacity],
                 [id].[Gauge],
                 [id].[Material],
                 [id].[QuantityInStock],
                 [id].[UnitOfMeasurement],
                 [id].[ReorderLevel],
                 [id].[CostPerUnit],
                 [id].[SellingPricePerUnit],
                 [id].[ExpirationDate],
                 [id].[Barcode],
                 [id].[Notes]
            FROM [dbo].[InventoryItemDetails] AS [id]
            WHERE [id].[ItemID] = [i].[ItemID] AND [id].[IsActive] = 1 -- Filter active details only
            FOR JSON PATH
        )
    FROM [dbo].[InventoryItem] AS [i]
    INNER JOIN [dbo].[Users] AS [uC] ON [i].[CreatedBy] = [uC].[UserID]
    INNER JOIN [dbo].[Users] AS [uM] ON [i].[ModifiedBy] = [uM].[UserID]
    WHERE [i].[IsActive] = 1
    ORDER BY [i].[ItemID]
    OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY
END
GO
