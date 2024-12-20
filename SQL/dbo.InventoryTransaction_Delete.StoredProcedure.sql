/****** Object:  StoredProcedure [dbo].[InventoryTransaction_Delete]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:
-- Create Date: 2024-11-26
-- Description: Soft deletes an inventory transaction by setting IsActive to 0.
-- =============================================

CREATE PROC [dbo].[InventoryTransaction_Delete]
															@TransactionID   INT
														   ,@ModifiedBy      INT
AS
/*
    Example Call:

       DECLARE @TransactionID   INT = 3
              ,@ModifiedBy      INT = 1

       EXECUTE [dbo].[InventoryTransaction_Delete]
															@TransactionID
														   ,@ModifiedBy
*/

BEGIN
    SET NOCOUNT ON

    -- Declare a consistent DateModified timestamp
    DECLARE @DateModified DATETIME2 = SYSDATETIMEOFFSET() AT TIME ZONE 'UTC' AT TIME ZONE 'Eastern Standard Time'

    -- Soft delete the InventoryTransaction
    UPDATE [dbo].[InventoryTransaction]
    SET
        [IsActive]     = 0,
        [ModifiedBy]   = @ModifiedBy,
        [DateModified] = @DateModified
    WHERE [TransactionID] = @TransactionID

    -- Soft delete the associated InventoryTransactionDetails
    UPDATE [dbo].[InventoryTransactionDetails]
    SET
        [IsActive] = 0,
        [ModifiedBy] = @ModifiedBy,
        [DateModified] = @DateModified
    WHERE [TransactionID] = @TransactionID

END
GO
