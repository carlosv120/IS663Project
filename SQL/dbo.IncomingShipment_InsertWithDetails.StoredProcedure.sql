/****** Object:  StoredProcedure [dbo].[IncomingShipment_InsertWithDetails]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:
-- Create Date: 2024-12-07
-- Description: Inserts a new incoming shipment along with its details and includes logic for updating related tables.
-- =============================================

CREATE PROCEDURE [dbo].[IncomingShipment_InsertWithDetails]
					 @RequestID              INT
					,@TransactionID          INT
					,@Notes                  NVARCHAR(100)
					,@ShipmentDetailList     NVARCHAR(MAX) -- JSON string containing IncomingShipmentDetails
					,@CreatedBy              INT
AS
/*
    Example Call:

    DECLARE 
           @RequestID               INT = 7
          ,@TransactionID           INT = 5
          ,@Notes                   NVARCHAR(255) = 'Urgent shipment.'
          ,@ShipmentDetailList      NVARCHAR(MAX) = '[{
														  "RequestDetailID": 16,
														  "SupplierID": 3,
														  "SupplierInvoiceNumber": "SUPPLIERINVOICE1",
														  "SupplierInvoiceDate": "2024-12-06",
														  "OrderNumber": "UpdatedOrder11",
														  "TrackingNumber": "UpdatedOrder11",
														  "ShipmentDate": "2024-12-06",
														  "ArrivalDate": "2024-12-10",
														  "QuantityReceived": 100,
														  "BatchNumber": "BATCH1",
														  "SerialNumber": "BATCH2",
														  "Notes": "UPDATED SQL"
													}]'
          ,@CreatedBy               INT = 1

    EXECUTE [dbo].[IncomingShipment_InsertWithDetails]
													 @RequestID              
													,@TransactionID          
													,@Notes                  
													,@ShipmentDetailList     
													,@CreatedBy              
*/

BEGIN
    SET NOCOUNT ON
    SET XACT_ABORT ON

    BEGIN TRANSACTION

    -- Declare a consistent timestamp
    DECLARE @DateCreated DATETIME2(7) = SYSDATETIMEOFFSET() AT TIME ZONE 'UTC' AT TIME ZONE 'Eastern Standard Time'

    -- Insert into IncomingShipment table
    INSERT INTO [dbo].[IncomingShipment] (
         [TransactionID]
        ,[RequestID]
        ,[Notes]
        ,[CreatedBy]
        ,[ModifiedBy]
        ,[DateCreated]
        ,[DateModified]
    )
    VALUES (
         @TransactionID
        ,@RequestID
        ,@Notes
        ,@CreatedBy
        ,@CreatedBy
        ,@DateCreated
        ,@DateCreated
    )

    -- Capture the new IncomingShipmentID
    DECLARE @IncomingShipmentID INT = SCOPE_IDENTITY()

    -- Insert into IncomingShipmentDetails table
    INSERT INTO [dbo].[IncomingShipmentDetails] (
         [IncomingShipmentID]
        ,[RequestDetailID]
        ,[SupplierID]
        ,[SupplierInvoiceNumber]
        ,[SupplierInvoiceDate]
        ,[OrderNumber]
        ,[TrackingNumber]
        ,[ShipmentDate]
        ,[ArrivalDate]
        ,[QuantityReceived]
        ,[BatchNumber]
        ,[SerialNumber]
        ,[Notes]
        ,[CreatedBy]
        ,[ModifiedBy]
        ,[DateCreated]
        ,[DateModified]
    )
    SELECT
         @IncomingShipmentID AS IncomingShipmentID
        ,JSON_VALUE(value, '$.RequestDetailID') AS RequestDetailID
        ,JSON_VALUE(value, '$.SupplierID') AS SupplierID
        ,JSON_VALUE(value, '$.SupplierInvoiceNumber') AS SupplierInvoiceNumber
        ,JSON_VALUE(value, '$.SupplierInvoiceDate') AS SupplierInvoiceDate
        ,JSON_VALUE(value, '$.OrderNumber') AS OrderNumber
        ,JSON_VALUE(value, '$.TrackingNumber') AS TrackingNumber
        ,JSON_VALUE(value, '$.ShipmentDate') AS ShipmentDate
        ,JSON_VALUE(value, '$.ArrivalDate') AS ArrivalDate
        ,JSON_VALUE(value, '$.QuantityReceived') AS QuantityReceived
        ,JSON_VALUE(value, '$.BatchNumber') AS BatchNumber
        ,JSON_VALUE(value, '$.SerialNumber') AS SerialNumber
        ,JSON_VALUE(value, '$.Notes') AS Notes
        ,@CreatedBy AS CreatedBy
        ,@CreatedBy AS ModifiedBy
        ,@DateCreated AS DateCreated
        ,@DateCreated AS DateModified
    FROM OPENJSON(@ShipmentDetailList)

    -- Update QuantityInStock in InventoryItemDetails
    UPDATE iid
    SET 
         iid.QuantityInStock = iid.QuantityInStock + ins.QuantityReceived
        ,iid.DateModified = @DateCreated
        ,iid.ModifiedBy = @CreatedBy
    FROM [dbo].[InventoryItemDetails] iid
    INNER JOIN [dbo].[RequestDetails] rd
        ON iid.ItemDetailID = rd.ItemDetailID
    INNER JOIN OPENJSON(@ShipmentDetailList) WITH (
         RequestDetailID INT '$.RequestDetailID',
         QuantityReceived INT '$.QuantityReceived'
    ) ins
        ON rd.RequestDetailID = ins.RequestDetailID

    -- Update DateModified and ModifiedBy in InventoryItem
    UPDATE ii
    SET 
         ii.DateModified = @DateCreated
        ,ii.ModifiedBy = @CreatedBy
    FROM [dbo].[InventoryItem] ii
    INNER JOIN [dbo].[InventoryItemDetails] iid
        ON ii.ItemID = iid.ItemID
    WHERE iid.ItemDetailID IN (
        SELECT rd.ItemDetailID
        FROM [dbo].[RequestDetails] rd
        INNER JOIN OPENJSON(@ShipmentDetailList) WITH (
             RequestDetailID INT '$.RequestDetailID'
        ) ins
            ON rd.RequestDetailID = ins.RequestDetailID
    )

    -- Update IsCompleted in RequestDetails table
    UPDATE rd
    SET rd.IsCompleted = CASE 
                           WHEN ins.QuantityReceived >= rd.Quantity THEN 1 
                           ELSE 0 
                         END
    FROM [dbo].[RequestDetails] rd
    INNER JOIN (
        SELECT JSON_VALUE(value, '$.RequestDetailID') AS RequestDetailID,
               JSON_VALUE(value, '$.QuantityReceived') AS QuantityReceived
        FROM OPENJSON(@ShipmentDetailList)
    ) ins ON rd.RequestDetailID = ins.RequestDetailID

    -- Update ModifiedBy and DateModified in Request
    UPDATE r
    SET 
         r.DateModified = @DateCreated
        ,r.ModifiedBy = @CreatedBy
    FROM [dbo].[Request] r
    WHERE r.RequestID = @RequestID

    COMMIT TRANSACTION

    -- Return the new IncomingShipmentID
    SELECT @IncomingShipmentID AS IncomingShipmentID
END
GO
