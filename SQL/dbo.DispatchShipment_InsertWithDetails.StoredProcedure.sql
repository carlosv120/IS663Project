/****** Object:  StoredProcedure [dbo].[DispatchShipment_InsertWithDetails]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:
-- Create Date: 2024-11-28
-- Description: Inserts a new dispatch shipment along with its associated details, updates DispatchOrderDetails.IsCompleted, and adjusts InventoryItemDetails quantities.
-- =============================================

CREATE PROC [dbo].[DispatchShipment_InsertWithDetails]
												 @DispatchOrderID         INT
												,@StatusID                INT
												,@DispatchDate            DATETIME2(7)
												,@ExpectedDeliveryDate    DATETIME2(7)
												,@TrackingNumber          NVARCHAR(50)
												,@Notes                   NVARCHAR(255)
												,@CreatedBy               INT
												,@DispatchShipmentDetailList NVARCHAR(MAX) -- JSON string containing DispatchShipmentDetails
AS
/*
    Example Call:

 DECLARE       @DispatchOrderID          INT = 3
              ,@StatusID                 INT = 10
              ,@DispatchDate             DATETIME2(7) = SYSDATETIMEOFFSET()
              ,@ExpectedDeliveryDate     DATETIME2(7) = '2024-11-30'
              ,@TrackingNumber           NVARCHAR(50) = 'TRACK12345'
              ,@Notes                    NVARCHAR(255) = 'Urgent shipment'
              ,@CreatedBy                INT = 1
              ,@DispatchShipmentDetailList NVARCHAR(MAX) = '[ 
                    {"DispatchOrderDetailID": 4, "QuantityShipped": 5, "BatchNumber": "BATCH001", "SerialNumber": "SERIAL001", "Notes": "First shipment"},
                    {"DispatchOrderDetailID": 8, "QuantityShipped": 10, "BatchNumber": "BATCH001", "SerialNumber": "SERIAL001", "Notes": "First shipment"},
					{"DispatchOrderDetailID": 9, "QuantityShipped": 20, "BatchNumber": "BATCH002", "SerialNumber": "SERIAL002", "Notes": "First shipment"}
                ]'

    EXECUTE [dbo].[DispatchShipment_InsertWithDetails]
             @DispatchOrderID
            ,@StatusID
            ,@DispatchDate
            ,@ExpectedDeliveryDate
            ,@TrackingNumber
            ,@Notes
            ,@CreatedBy
            ,@DispatchShipmentDetailList



*/

BEGIN
    SET NOCOUNT ON
    SET XACT_ABORT ON

    -- Declare a consistent DateCreated timestamp
    DECLARE @DateCreated DATETIME2 = SYSDATETIMEOFFSET() AT TIME ZONE 'UTC' AT TIME ZONE 'Eastern Standard Time'

    -- Begin the transaction
    BEGIN TRANSACTION

    -- Insert into DispatchShipment table
    INSERT INTO [dbo].[DispatchShipment] (
         [DispatchOrderID]
        ,[StatusID]
        ,[DispatchDate]
        ,[ExpectedDeliveryDate]
        ,[TrackingNumber]
        ,[Notes]
        ,[CreatedBy]
        ,[ModifiedBy]
    )
    VALUES (
         @DispatchOrderID
        ,@StatusID
        ,@DispatchDate
        ,@ExpectedDeliveryDate
        ,@TrackingNumber
        ,@Notes
        ,@CreatedBy
        ,@CreatedBy
    )

    -- Retrieve the new DispatchShipmentID
    DECLARE @DispatchShipmentID INT = SCOPE_IDENTITY()

    -- Insert into DispatchShipmentDetails table
    INSERT INTO [dbo].[DispatchShipmentDetails] (
         [DispatchShipmentID]
        ,[DispatchOrderDetailID]
        ,[QuantityShipped]
        ,[BatchNumber]
        ,[SerialNumber]
        ,[Notes]
        ,[CreatedBy]
        ,[ModifiedBy]
    )
    SELECT
         @DispatchShipmentID AS DispatchShipmentID
        ,JSON_VALUE(value, '$.DispatchOrderDetailID') AS DispatchOrderDetailID
        ,JSON_VALUE(value, '$.QuantityShipped')      AS QuantityShipped
        ,JSON_VALUE(value, '$.BatchNumber')          AS BatchNumber
        ,JSON_VALUE(value, '$.SerialNumber')         AS SerialNumber
        ,JSON_VALUE(value, '$.Notes')               AS Notes
        ,@CreatedBy                                 AS CreatedBy
        ,@CreatedBy                                 AS ModifiedBy
    FROM OPENJSON(@DispatchShipmentDetailList)

    -- Update DispatchOrderDetails.IsCompleted if fully shipped
    UPDATE dod
    SET [IsCompleted] = 1
    FROM [dbo].[DispatchOrderDetails] dod
    INNER JOIN (
        SELECT 
            JSON_VALUE(value, '$.DispatchOrderDetailID') AS DispatchOrderDetailID,
            JSON_VALUE(value, '$.QuantityShipped')      AS QuantityShipped
        FROM OPENJSON(@DispatchShipmentDetailList)
    ) ds ON dod.DispatchOrderDetailID = ds.DispatchOrderDetailID
    WHERE dod.Quantity = ds.QuantityShipped

    -- Subtract QuantityShipped from InventoryItemDetails.Quantity
    UPDATE iid
    SET [QuantityInStock] = [Quantity] - ds.QuantityShipped
    FROM [dbo].[InventoryItemDetails] iid
    INNER JOIN [dbo].[DispatchOrderDetails] dod
        ON iid.ItemID = dod.ItemID
       AND iid.ItemDetailID = dod.ItemDetailID
    INNER JOIN (
        SELECT 
            JSON_VALUE(value, '$.DispatchOrderDetailID') AS DispatchOrderDetailID,
            JSON_VALUE(value, '$.QuantityShipped')      AS QuantityShipped
        FROM OPENJSON(@DispatchShipmentDetailList)
    ) ds ON dod.DispatchOrderDetailID = ds.DispatchOrderDetailID

    -- Commit the transaction
    COMMIT TRANSACTION

    -- Return the DispatchShipmentID
    SELECT @DispatchShipmentID AS DispatchShipmentID
END
GO
