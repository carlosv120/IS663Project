/****** Object:  StoredProcedure [dbo].[InventoryItem_Delete]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:
-- Create Date: 2024-12-07
-- Description: Soft deletes an inventory item along with its details.
-- =============================================

CREATE PROC [dbo].[InventoryItem_Delete]
     @ItemID              INT
    ,@ModifiedBy          INT
AS
/*
    Example Call:

    DECLARE @ItemID      INT = 1
          ,@ModifiedBy   INT = 1

    EXECUTE [dbo].[InventoryItem_Delete]
         @ItemID,
         @ModifiedBy
*/

BEGIN
    SET NOCOUNT ON

    -- Declare a consistent DateModified timestamp
    DECLARE @DateModified DATETIME2 = SYSDATETIMEOFFSET() AT TIME ZONE 'UTC' AT TIME ZONE 'Eastern Standard Time'

    -- Soft delete the InventoryItem
    UPDATE [dbo].[InventoryItem]
    SET
         [IsActive]     = 0
        ,[ModifiedBy]   = @ModifiedBy
        ,[DateModified] = @DateModified
    WHERE [ItemID] = @ItemID

    -- Soft delete the associated InventoryItemDetails
    UPDATE [dbo].[InventoryItemDetails]
    SET
         [IsActive]     = 0
        ,[ModifiedBy]   = @ModifiedBy
        ,[DateModified] = @DateModified
    WHERE [ItemID] = @ItemID

END
GO
