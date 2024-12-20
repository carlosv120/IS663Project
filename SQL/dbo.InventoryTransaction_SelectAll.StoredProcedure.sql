/****** Object:  StoredProcedure [dbo].[InventoryTransaction_SelectAll]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:
-- Create Date: 2024-11-25
-- Description: Retrieves paginated list of active inventory transactions with their details in JSON format.
-- =============================================

CREATE PROC [dbo].[InventoryTransaction_SelectAll]
													 @PageIndex   INT
													,@PageSize    INT
AS
/*
    Example Call:

    DECLARE @PageIndex   INT = 1
           ,@PageSize    INT = 2

    EXECUTE [dbo].[InventoryTransaction_SelectAll]
													 @PageIndex
													,@PageSize

	SELECT *
	FROM [dbo].[InventoryTransaction]
	SELECT * FROM InventoryTransactionDetails
*/

BEGIN
    SET NOCOUNT ON

    DECLARE @Offset INT = (@PageIndex - 1) * @PageSize

    -- Return total count of active transactions
    SELECT COUNT(*) AS TotalCount
    FROM [dbo].[InventoryTransaction]
    WHERE IsActive = 1

    -- Select paginated transactions with JSON details
    SELECT
         [t].[TransactionID],
         [t].[StatusID],
         [t].[IsRequest],
         [t].[RequestID],
         [t].[Notes] AS [TransactionNotes],
         [uC].[FirstName] AS [CreatedByFirstName],
         [uC].[LastName] AS [CreatedByLastName],
         [uM].[FirstName] AS [ModifiedByFirstName],
         [uM].[LastName] AS [ModifiedByLastName],
         [t].[DateCreated],
         [t].[DateModified],
         TransactionDetails = (
             SELECT
                 [td].[TransactionDetailID],
                 [td].[RequestDetailID],
                 [td].[SupplierID],
                 [td].[OrderNumber],
                 [td].[Quantity],
                 [td].[TrackingNumber],
                 [td].[ExpectedArrivalDate],
                 [td].[Notes] AS [DetailNotes]
             FROM [dbo].[InventoryTransactionDetails] AS [td]
             WHERE [td].[TransactionID] = [t].[TransactionID] AND [td].[IsActive] = 1 -- Filter active details only
             FOR JSON PATH
         )
    FROM [dbo].[InventoryTransaction] AS [t]
    INNER JOIN [dbo].[Users] AS [uC] ON [t].[CreatedBy] = [uC].[UserID]
    INNER JOIN [dbo].[Users] AS [uM] ON [t].[ModifiedBy] = [uM].[UserID]
    WHERE [t].[IsActive] = 1
    ORDER BY [t].[TransactionID]
    OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY
END;
GO
