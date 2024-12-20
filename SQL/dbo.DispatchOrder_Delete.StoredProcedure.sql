/****** Object:  StoredProcedure [dbo].[DispatchOrder_Delete]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:
-- Create Date: 2024-11-27
-- Description: Soft deletes a dispatch order by setting IsActive to 0.
-- =============================================

CREATE PROC [dbo].[DispatchOrder_Delete]
											 @DispatchOrderID INT
											,@ModifiedBy      INT
AS
/*
    Example Call:

       DECLARE @DispatchOrderID INT = 3
              ,@ModifiedBy      INT = 1

       EXECUTE [dbo].[DispatchOrder_Delete]
											@DispatchOrderID
										   ,@ModifiedBy

*/

BEGIN
    SET NOCOUNT ON

    DECLARE @DateModified DATETIME2 = SYSDATETIMEOFFSET() AT TIME ZONE 'UTC' AT TIME ZONE 'Eastern Standard Time'

    -- Soft delete the DispatchOrder
    UPDATE [dbo].[DispatchOrder]
       SET [IsActive]     = 0
          ,[ModifiedBy]   = @ModifiedBy
          ,[DateModified] = @DateModified
     WHERE [DispatchOrderID] = @DispatchOrderID

    -- Return the DispatchOrderID for confirmation
    SELECT @DispatchOrderID AS DispatchOrderID
END
GO
