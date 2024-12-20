/****** Object:  StoredProcedure [dbo].[DispatchShipment_Received]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:
-- Create Date: 2024-11-28
-- Description: Updates DispatchShipment.ActualDeliveryDate and marks DispatchOrder as completed.
-- =============================================

CREATE PROC [dbo].[DispatchShipment_Received]
											 @DispatchShipmentID    INT
											,@ActualDeliveryDate    DATETIME2(7)
AS
/*
    Example Call:

    DECLARE @DispatchShipmentID    INT = 3
           ,@ActualDeliveryDate    DATETIME2(7) = '2024-11-29'

    EXECUTE [dbo].[DispatchShipment_Received]
             @DispatchShipmentID
            ,@ActualDeliveryDate
*/

BEGIN
    SET NOCOUNT ON
    SET XACT_ABORT ON

    -- Begin the transaction
    BEGIN TRANSACTION

    -- Update the DispatchShipment table with the ActualDeliveryDate
    UPDATE [dbo].[DispatchShipment]
    SET [ActualDeliveryDate] = @ActualDeliveryDate
    WHERE [DispatchShipmentID] = @DispatchShipmentID

    -- Update the associated DispatchOrder
    UPDATE [dbo].[DispatchOrder]
    SET 
         [IsCompleted]    = 1
        ,[DateCompleted]  = @ActualDeliveryDate
    WHERE [DispatchOrderID] = (
        SELECT [DispatchOrderID]
        FROM [dbo].[DispatchShipment]
        WHERE [DispatchShipmentID] = @DispatchShipmentID
    )

    -- Commit the transaction
    COMMIT TRANSACTION

    -- Return the DispatchShipmentID for confirmation
    SELECT @DispatchShipmentID AS DispatchShipmentID, @ActualDeliveryDate AS ActualDeliveryDate
END
GO
