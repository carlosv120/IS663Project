/****** Object:  StoredProcedure [dbo].[DispatchReceiver_Delete]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: 
-- Create Date: 2024-11-24
-- Description: Soft deletes a dispatch receiver by setting IsActive to 0.
-- =============================================

CREATE PROC [dbo].[DispatchReceiver_Delete]
											@ReceiverID			INT
										   ,@ModifiedBy			INT
AS
/*
    Example Call:

    DECLARE    @ReceiverID			INT		= 1
			  ,@ModifiedBy			INT		= 1

    EXECUTE [dbo].[DispatchReceiver_Delete]
											@ReceiverID
										   ,@ModifiedBy

	SELECT *
    FROM [dbo].[DispatchReceiver]
    WHERE [DispatchReceiver] = @ReceiverID
*/

BEGIN
    DECLARE @DateModified DATETIME2 = SYSDATETIMEOFFSET() AT TIME ZONE 'UTC' AT TIME ZONE 'Eastern Standard Time';

    -- Perform a soft delete by setting IsActive to 0
    UPDATE [dbo].[DispatchReceiver]
       SET [IsActive]		= 0
          ,[ModifiedBy]		= @ModifiedBy
          ,[DateModified]	= @DateModified
     WHERE [ReceiverID]		= @ReceiverID;
END
GO
