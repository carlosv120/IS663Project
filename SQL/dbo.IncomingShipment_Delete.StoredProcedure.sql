/****** Object:  StoredProcedure [dbo].[IncomingShipment_Delete]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:
-- Create Date: 2024-12-08
-- Description: Soft deletes an incoming shipment and its details by setting IsActive to 0.
-- =============================================

CREATE PROC [dbo].[IncomingShipment_Delete]
						  @IncomingShipmentID INT
						 ,@ModifiedBy INT
AS
/*
    Example Call:

    DECLARE  @IncomingShipmentID INT = 23
			,@ModifiedBy INT = 1

    EXECUTE [dbo].[IncomingShipment_Delete]
								  @IncomingShipmentID
								 ,@ModifiedBy

	SELECT * FROM IncomingShipment
	SELECT * FROM IncomingShipmentDetails
*/

BEGIN
    SET NOCOUNT ON

    -- Declare a consistent DateModified timestamp
    DECLARE @DateModified DATETIME2 = SYSDATETIMEOFFSET() AT TIME ZONE 'UTC' AT TIME ZONE 'Eastern Standard Time'

    -- Soft delete the IncomingShipment
    UPDATE [dbo].[IncomingShipment]
    SET
        [IsActive] = 0,
        [ModifiedBy] = @ModifiedBy,
        [DateModified] = @DateModified
    WHERE [IncomingShipmentID] = @IncomingShipmentID AND [IsActive] = 1

    -- Soft delete the associated IncomingShipmentDetails
    UPDATE [dbo].[IncomingShipmentDetails]
    SET
        [IsActive] = 0,
        [ModifiedBy] = @ModifiedBy,
        [DateModified] = @DateModified
    WHERE [IncomingShipmentID] = @IncomingShipmentID AND [IsActive] = 1

END

GO
