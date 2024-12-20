/****** Object:  StoredProcedure [dbo].[InventoryTransaction_Insert]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:
-- Create Date: 2024-11-26
-- Description: Inserts a new inventory transaction along with its details. Updates the Request table if IsRequest = 1.
-- =============================================

CREATE PROC [dbo].[InventoryTransaction_Insert]
     @StatusID              INT
    ,@IsRequest             BIT
    ,@RequestID             INT
    ,@TransactionDetailList NVARCHAR(MAX) -- JSON string containing InventoryTransactionDetails
    ,@Notes                 NVARCHAR(255)
    ,@CreatedBy             INT
AS
/*
    Example Call:

    DECLARE 
           @StatusID              INT = 2
          ,@IsRequest             BIT = 1
          ,@RequestID             INT = 1
          ,@TransactionDetailList NVARCHAR(MAX) = '[
			{"RequestDetailID":1,"SupplierID":5,"OrderNumber":"ORD123","Quantity":10,"TrackingNumber":"TRK123","ExpectedArrivalDate":"2024-12-01T00:00:00","Notes":"Urgent delivery"},
			{"RequestDetailID":2,"SupplierID":6,"OrderNumber":"ORD124","Quantity":20,"TrackingNumber":"TRK124","ExpectedArrivalDate":"2024-12-05T00:00:00","Notes":"Standard delivery"}]'
          
		  ,@Notes                 NVARCHAR(255) = 'New inventory transaction.'
          ,@CreatedBy             INT = 1

    EXECUTE [dbo].[InventoryTransaction_Insert]
													 @StatusID
													,@IsRequest
													,@RequestID
													,@TransactionDetailList
													,@Notes
													,@CreatedBy

	SELECT * FROM [dbo].[Request] WHERE RequestID = 7
	SELECT * FROM [dbo].[RequestDetails] WHERE RequestID = 7

	SELECT * FROM [dbo].[InventoryTransaction] WHERE TransactionID = 5
	SELECT * FROM [dbo].[InventoryTransactionDetails] WHERE TransactionID = 5
*/

BEGIN
    SET NOCOUNT ON
    SET XACT_ABORT ON

    -- Begin the transaction
    BEGIN TRANSACTION

    -- Declare a consistent timestamp
    DECLARE @DateCreated DATETIME2 = SYSDATETIMEOFFSET() AT TIME ZONE 'UTC' AT TIME ZONE 'Eastern Standard Time';

    -- Insert into InventoryTransaction table
    INSERT INTO [dbo].[InventoryTransaction] (	 [StatusID]
												,[IsRequest]
												,[RequestID]
												,[Notes]
												,[CreatedBy]
												,[ModifiedBy])
    VALUES (	 @StatusID
				,@IsRequest
				,@RequestID
				,@Notes
				,@CreatedBy
				,@CreatedBy )

    -- Retrieve the new TransactionID
    DECLARE @TransactionID INT = SCOPE_IDENTITY()

    -- If IsRequest = 1, update the Request table
    IF @IsRequest = 1
    BEGIN
        UPDATE [dbo].[Request]
        SET
             [IsApproved]     = 1
            ,[DateApproved]   = @DateCreated
            ,[TransactionID]  = @TransactionID
        WHERE [RequestID] = @RequestID
    END;

    -- Insert into InventoryTransactionDetails table
    INSERT INTO [dbo].[InventoryTransactionDetails] (
         [TransactionID]
        ,[RequestDetailID]
        ,[SupplierID]
        ,[OrderNumber]
        ,[Quantity]
        ,[TrackingNumber]
        ,[ExpectedArrivalDate]
        ,[Notes]
        ,[CreatedBy]
        ,[ModifiedBy]
    )
    SELECT
         @TransactionID AS TransactionID
        ,JSON_VALUE(value, '$.RequestDetailID')    AS RequestDetailID
        ,JSON_VALUE(value, '$.SupplierID')        AS SupplierID
        ,JSON_VALUE(value, '$.OrderNumber')       AS OrderNumber
        ,JSON_VALUE(value, '$.Quantity')          AS Quantity
        ,JSON_VALUE(value, '$.TrackingNumber')    AS TrackingNumber
        ,JSON_VALUE(value, '$.ExpectedArrivalDate') AS ExpectedArrivalDate
        ,JSON_VALUE(value, '$.Notes')             AS Notes
        ,@CreatedBy AS CreatedBy
        ,@CreatedBy AS ModifiedBy
    FROM
        OPENJSON(@TransactionDetailList)

    -- Commit the transaction
    COMMIT TRANSACTION

    -- Return the TransactionID
    SELECT @TransactionID AS TransactionID
END;
GO
