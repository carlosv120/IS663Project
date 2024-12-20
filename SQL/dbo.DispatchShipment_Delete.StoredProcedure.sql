/****** Object:  StoredProcedure [dbo].[DispatchShipment_Delete]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:
-- Create Date: 2024-11-28
-- Description: Soft deletes a dispatch shipment by setting IsActive to 0.
-- =============================================

CREATE PROC [dbo].[DispatchShipment_Delete]
										 @DispatchShipmentID   INT
										,@ModifiedBy           INT
AS
/*
    Example Call:

       DECLARE     @DispatchShipmentID   INT = 3
				  ,@ModifiedBy           INT = 1

       EXECUTE [dbo].[DispatchShipment_Delete]
                 @DispatchShipmentID
                ,@ModifiedBy

*/

BEGIN
    SET NOCOUNT ON

    -- Declare a consistent DateModified timestamp
    DECLARE @DateModified DATETIME2 = SYSDATETIMEOFFSET() AT TIME ZONE 'UTC' AT TIME ZONE 'Eastern Standard Time'

    -- Soft delete the DispatchShipment
    UPDATE [dbo].[DispatchShipment]
    SET [IsActive]     = 0
       ,[ModifiedBy]   = @ModifiedBy
       ,[DateModified] = @DateModified
    WHERE [DispatchShipmentID] = @DispatchShipmentID

    -- Return the DispatchShipmentID for confirmation
    SELECT @DispatchShipmentID AS DispatchShipmentID
END
GO
