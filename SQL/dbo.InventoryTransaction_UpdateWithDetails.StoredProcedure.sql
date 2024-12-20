/****** Object:  StoredProcedure [dbo].[InventoryTransaction_UpdateWithDetails]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:
-- Create Date: 2024-11-26
-- Description: Updates an existing inventory transaction along with its associated details.
-- =============================================

CREATE PROC [dbo].[InventoryTransaction_UpdateWithDetails]
														 @TransactionID         INT,
														 @StatusID              INT,
														 @IsRequest             BIT,
														 @RequestID             INT,
														 @Notes                 NVARCHAR(255),
														 @ModifiedBy            INT,
														 @TransactionDetailList NVARCHAR(MAX) -- JSON string containing InventoryTransactionDetails
AS
/*
    Example Call:

       DECLARE @TransactionID         INT = 5,
               @StatusID              INT = 2,
               @IsRequest             BIT = 1,
               @RequestID             INT = 7,
               @Notes                 NVARCHAR(255) = 'Updated transaction',
               @ModifiedBy            INT = 1,
               @TransactionDetailList NVARCHAR(MAX) = '[
                   {"SupplierID":5,"OrderNumber":"ORD123","Quantity":50,"TrackingNumber":"TRK123","ExpectedArrivalDate":"2024-12-01T00:00:00","Notes":"Updated urgent delivery"},
                   {"SupplierID":6,"OrderNumber":"ORD124","Quantity":30,"TrackingNumber":"TRK124","ExpectedArrivalDate":"2024-12-05T00:00:00","Notes":"Updated standard delivery"}
               ]'

       EXECUTE [dbo].[InventoryTransaction_UpdateWithDetails]
                @TransactionID,
                @StatusID,
                @IsRequest,
                @RequestID,
                @Notes,
                @ModifiedBy,
                @TransactionDetailList

	SELECT * FROM [dbo].[Request] WHERE RequestID = 7
	SELECT * FROM [dbo].[RequestDetails] WHERE RequestID = 7

	SELECT * FROM [dbo].[InventoryTransaction] WHERE TransactionID = 5
	SELECT * FROM [dbo].[InventoryTransactionDetails] WHERE TransactionID = 5
*/

BEGIN
    SET NOCOUNT ON
    SET XACT_ABORT ON

    DECLARE @DateModified DATETIME2 = SYSDATETIMEOFFSET() AT TIME ZONE 'UTC' AT TIME ZONE 'Eastern Standard Time'

    BEGIN TRANSACTION

    -- Update InventoryTransaction table
    UPDATE [dbo].[InventoryTransaction]
    SET
         [StatusID]      = @StatusID,
         [IsRequest]     = @IsRequest,
         [RequestID]     = @RequestID,
         [Notes]         = @Notes,
         [ModifiedBy]    = @ModifiedBy,
         [DateModified]  = @DateModified
    WHERE [TransactionID] = @TransactionID

    -- If IsRequest = 1, update the Request table
    IF @IsRequest = 1
    BEGIN
        UPDATE [dbo].[Request]
        SET
             [TransactionID] = @TransactionID,
             [DateModified]  = @DateModified
        WHERE [RequestID] = @RequestID
    END

    -- Create temporary table for incoming details
    CREATE TABLE #TempTransactionDetails (
         SupplierID INT,
         OrderNumber NVARCHAR(50),
         Quantity INT,
         TrackingNumber NVARCHAR(50),
         ExpectedArrivalDate DATETIME2,
         Notes NVARCHAR(255)
    )

    -- Populate temporary table from JSON payload
    INSERT INTO #TempTransactionDetails (SupplierID, OrderNumber, Quantity, TrackingNumber, ExpectedArrivalDate, Notes)
    SELECT
         JSON_VALUE(value, '$.SupplierID')        AS SupplierID,
         JSON_VALUE(value, '$.OrderNumber')       AS OrderNumber,
         JSON_VALUE(value, '$.Quantity')          AS Quantity,
         JSON_VALUE(value, '$.TrackingNumber')    AS TrackingNumber,
         JSON_VALUE(value, '$.ExpectedArrivalDate') AS ExpectedArrivalDate,
         JSON_VALUE(value, '$.Notes')             AS Notes
    FROM OPENJSON(@TransactionDetailList)

    -- Create a table to merge RequestDetailID with new data
    CREATE TABLE #FinalDetails (
         RequestDetailID INT,
         SupplierID INT,
         OrderNumber NVARCHAR(50),
         Quantity INT,
         TrackingNumber NVARCHAR(50),
         ExpectedArrivalDate DATETIME2,
         Notes NVARCHAR(255)
    )

    -- Insert merged data into #FinalDetails
    INSERT INTO #FinalDetails
    SELECT
         e.RequestDetailID,
         t.SupplierID,
         t.OrderNumber,
         t.Quantity,
         t.TrackingNumber,
         t.ExpectedArrivalDate,
         t.Notes
    FROM (
        SELECT
             [RequestDetailID],
             ROW_NUMBER() OVER (ORDER BY [TransactionDetailID]) AS RowNum
        FROM [dbo].[InventoryTransactionDetails]
        WHERE [TransactionID] = @TransactionID AND [IsActive] = 1
    ) e
    INNER JOIN (
        SELECT
             ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowNum,
             SupplierID,
             OrderNumber,
             Quantity,
             TrackingNumber,
             ExpectedArrivalDate,
             Notes
        FROM #TempTransactionDetails
    ) t ON e.RowNum = t.RowNum

    -- Mark all existing details as inactive
    UPDATE [dbo].[InventoryTransactionDetails]
    SET [IsActive] = 0
    WHERE [TransactionID] = @TransactionID
      AND [IsActive] = 1

    -- Insert new details with the assigned RequestDetailID
    INSERT INTO [dbo].[InventoryTransactionDetails] (
         [TransactionID],
         [RequestDetailID],
         [SupplierID],
         [OrderNumber],
         [Quantity],
         [TrackingNumber],
         [ExpectedArrivalDate],
         [Notes],
         [IsActive],
         [CreatedBy],
         [ModifiedBy]
    )
    SELECT
         @TransactionID AS TransactionID,
         f.RequestDetailID,
         f.SupplierID,
         f.OrderNumber,
         f.Quantity,
         f.TrackingNumber,
         f.ExpectedArrivalDate,
         f.Notes,
         1 AS IsActive,
         @ModifiedBy AS CreatedBy,
         @ModifiedBy AS ModifiedBy
    FROM #FinalDetails f

    -- Drop temporary tables
    DROP TABLE #TempTransactionDetails
    DROP TABLE #FinalDetails

    COMMIT TRANSACTION
END
GO
