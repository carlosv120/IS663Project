/****** Object:  StoredProcedure [dbo].[IncomingShipment_UpdateWithDetails]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:
-- Create Date: 2024-12-07
-- Description: Updates an existing incoming shipment along with its details and ensures accurate inventory tracking.
-- =============================================

CREATE PROCEDURE [dbo].[IncomingShipment_UpdateWithDetails]
				 @IncomingShipmentID     INT
				,@Notes                  NVARCHAR(100)
				,@ModifiedBy             INT
				,@ShipmentDetailList     NVARCHAR(MAX) -- JSON string containing IncomingShipmentDetails
AS
/*
    Example Call:

    DECLARE 
           @IncomingShipmentID      INT = 23
          ,@Notes                   NVARCHAR(255) = 'Updated shipment.'
          ,@ModifiedBy              INT = 1
          ,@ShipmentDetailList      NVARCHAR(MAX) = '[{
                                                           "RequestDetailID": 17,
                                                           "SupplierID": 2,
                                                           "SupplierInvoiceNumber": "SUPPLIERINVOICE1",
                                                           "SupplierInvoiceDate": "2024-12-06",
                                                           "OrderNumber": "UpdatedOrder11",
                                                           "TrackingNumber": "UpdatedOrder11",
                                                           "ShipmentDate": "2024-12-06",
                                                           "ArrivalDate": "2024-12-10",
                                                           "QuantityReceived": 90,
                                                           "BatchNumber": "BATCH1",
                                                           "SerialNumber": "BATCH2",
                                                           "Notes": "UPDATED SQL"
                                                     }]'

    EXECUTE [dbo].[IncomingShipment_UpdateWithDetails]
         @IncomingShipmentID
        ,@Notes
        ,@ModifiedBy
        ,@ShipmentDetailList
*/

BEGIN
    SET NOCOUNT ON
    SET XACT_ABORT ON

    BEGIN TRANSACTION

    -- Declare a consistent timestamp
    DECLARE @DateModified DATETIME2(7) = SYSDATETIMEOFFSET() AT TIME ZONE 'UTC' AT TIME ZONE 'Eastern Standard Time'

    -- Update IncomingShipment table
    UPDATE [dbo].[IncomingShipment]
    SET 
         [Notes] = @Notes
        ,[ModifiedBy] = @ModifiedBy
        ,[DateModified] = @DateModified
    WHERE [IncomingShipmentID] = @IncomingShipmentID

    -- Process IncomingShipmentDetails
    CREATE TABLE #TempDetails (
         RequestDetailID INT
        ,SupplierID INT
        ,SupplierInvoiceNumber NVARCHAR(50)
        ,SupplierInvoiceDate DATETIME2(7)
        ,OrderNumber NVARCHAR(50)
        ,TrackingNumber NVARCHAR(50)
        ,ShipmentDate DATETIME2(7)
        ,ArrivalDate DATETIME2(7)
        ,QuantityReceived INT
        ,BatchNumber NVARCHAR(50)
        ,SerialNumber NVARCHAR(50)
        ,Notes NVARCHAR(255)
    )

    -- Populate temporary table from JSON payload
    INSERT INTO #TempDetails (
         RequestDetailID
        ,SupplierID
        ,SupplierInvoiceNumber
        ,SupplierInvoiceDate
        ,OrderNumber
        ,TrackingNumber
        ,ShipmentDate
        ,ArrivalDate
        ,QuantityReceived
        ,BatchNumber
        ,SerialNumber
        ,Notes
    )
    SELECT
         JSON_VALUE(value, '$.RequestDetailID') AS RequestDetailID
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
    FROM OPENJSON(@ShipmentDetailList)

    -- Loop through temporary table and update or insert details
    DECLARE @RequestDetailID INT
    DECLARE @QuantityReceived INT
    DECLARE @ExistingQuantity INT
    DECLARE @Difference INT

    DECLARE detail_cursor CURSOR FOR
    SELECT RequestDetailID, QuantityReceived
    FROM #TempDetails

    OPEN detail_cursor

    FETCH NEXT FROM detail_cursor INTO @RequestDetailID, @QuantityReceived

    WHILE @@FETCH_STATUS = 0
    BEGIN
		-- Check for duplicates
        IF EXISTS (
            SELECT 1
            FROM [dbo].[IncomingShipmentDetails]
            WHERE IncomingShipmentID = @IncomingShipmentID AND RequestDetailID = @RequestDetailID
        )
        BEGIN
            THROW 50000, 'Duplicate entry detected for IncomingShipmentID and RequestDetailID.', 1;
        END

        -- Check if the record exists
        SELECT @ExistingQuantity = QuantityReceived
        FROM [dbo].[IncomingShipmentDetails]
        WHERE IncomingShipmentID = @IncomingShipmentID AND RequestDetailID = @RequestDetailID

        IF @ExistingQuantity IS NOT NULL
        BEGIN
            -- Calculate the difference and update QuantityInStock
            SET @Difference = @QuantityReceived - @ExistingQuantity

            UPDATE iid
            SET 
                 iid.QuantityInStock = iid.QuantityInStock + @Difference
                ,iid.DateModified = @DateModified
                ,iid.ModifiedBy = @ModifiedBy
            FROM [dbo].[InventoryItemDetails] iid
            INNER JOIN [dbo].[RequestDetails] rd
                ON iid.ItemDetailID = rd.ItemDetailID
            WHERE rd.RequestDetailID = @RequestDetailID

            -- Update the record
            UPDATE [dbo].[IncomingShipmentDetails]
            SET 
                 SupplierID = (SELECT SupplierID FROM #TempDetails WHERE RequestDetailID = @RequestDetailID)
                ,SupplierInvoiceNumber = (SELECT SupplierInvoiceNumber FROM #TempDetails WHERE RequestDetailID = @RequestDetailID)
                ,SupplierInvoiceDate = (SELECT SupplierInvoiceDate FROM #TempDetails WHERE RequestDetailID = @RequestDetailID)
                ,OrderNumber = (SELECT OrderNumber FROM #TempDetails WHERE RequestDetailID = @RequestDetailID)
                ,TrackingNumber = (SELECT TrackingNumber FROM #TempDetails WHERE RequestDetailID = @RequestDetailID)
                ,ShipmentDate = (SELECT ShipmentDate FROM #TempDetails WHERE RequestDetailID = @RequestDetailID)
                ,ArrivalDate = (SELECT ArrivalDate FROM #TempDetails WHERE RequestDetailID = @RequestDetailID)
                ,QuantityReceived = @QuantityReceived
                ,BatchNumber = (SELECT BatchNumber FROM #TempDetails WHERE RequestDetailID = @RequestDetailID)
                ,SerialNumber = (SELECT SerialNumber FROM #TempDetails WHERE RequestDetailID = @RequestDetailID)
                ,Notes = (SELECT Notes FROM #TempDetails WHERE RequestDetailID = @RequestDetailID)
                ,ModifiedBy = @ModifiedBy
                ,DateModified = @DateModified
            WHERE IncomingShipmentID = @IncomingShipmentID AND RequestDetailID = @RequestDetailID
        END
        ELSE
        BEGIN
            -- Insert new record and update QuantityInStock
            INSERT INTO [dbo].[IncomingShipmentDetails] (
                 IncomingShipmentID
                ,RequestDetailID
                ,SupplierID
                ,SupplierInvoiceNumber
                ,SupplierInvoiceDate
                ,OrderNumber
                ,TrackingNumber
                ,ShipmentDate
                ,ArrivalDate
                ,QuantityReceived
                ,BatchNumber
                ,SerialNumber
                ,Notes
                ,CreatedBy
                ,ModifiedBy
                ,DateCreated
                ,DateModified
            )
            SELECT 
                 @IncomingShipmentID
                ,RequestDetailID
                ,SupplierID
                ,SupplierInvoiceNumber
                ,SupplierInvoiceDate
                ,OrderNumber
                ,TrackingNumber
                ,ShipmentDate
                ,ArrivalDate
                ,QuantityReceived
                ,BatchNumber
                ,SerialNumber
                ,Notes
                ,@ModifiedBy
                ,@ModifiedBy
                ,@DateModified
                ,@DateModified
            FROM #TempDetails
            WHERE RequestDetailID = @RequestDetailID

            -- Add Quantity to QuantityInStock
            UPDATE iid
            SET 
                 iid.QuantityInStock = iid.QuantityInStock + @QuantityReceived
                ,iid.DateModified = @DateModified
                ,iid.ModifiedBy = @ModifiedBy
            FROM [dbo].[InventoryItemDetails] iid
            INNER JOIN [dbo].[RequestDetails] rd
                ON iid.ItemDetailID = rd.ItemDetailID
            WHERE rd.RequestDetailID = @RequestDetailID
        END

        FETCH NEXT FROM detail_cursor INTO @RequestDetailID, @QuantityReceived
    END

    CLOSE detail_cursor
    DEALLOCATE detail_cursor


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
         r.DateModified = @DateModified
        ,r.ModifiedBy = @ModifiedBy
    FROM [dbo].[Request] r
    WHERE r.RequestID = (SELECT DISTINCT RequestID 
                         FROM [dbo].[RequestDetails] rd
                         WHERE rd.RequestDetailID IN (SELECT RequestDetailID FROM #TempDetails))

    DROP TABLE #TempDetails

    COMMIT TRANSACTION

    -- Return the updated IncomingShipmentID
    SELECT @IncomingShipmentID AS IncomingShipmentID
END;
GO
