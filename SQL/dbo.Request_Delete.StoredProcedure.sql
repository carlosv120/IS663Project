/****** Object:  StoredProcedure [dbo].[Request_Delete]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:
-- Create Date: 2024-11-25
-- Description: Soft deletes a request by setting IsActive to 0.
-- =============================================

CREATE PROC [dbo].[Request_Delete]
										 @RequestID   INT
										,@ModifiedBy  INT
AS
/*
    Example Call:

       DECLARE     @RequestID   INT = 3
				  ,@ModifiedBy  INT = 1

       EXECUTE [dbo].[Request_Delete]
                                            @RequestID
                                           ,@ModifiedBy
	SELECT * 
	FROM Request
	SELECT * 
	FROM RequestDetails
*/

BEGIN
    SET NOCOUNT ON

    DECLARE @DateModified DATETIME2 = SYSDATETIMEOFFSET() AT TIME ZONE 'UTC' AT TIME ZONE 'Eastern Standard Time'

    -- Soft delete the Request
    UPDATE [dbo].[Request]
       SET [IsActive]     = 0,
           [ModifiedBy]   = @ModifiedBy,
           [DateModified] = @DateModified
     WHERE [RequestID]    = @RequestID

    -- Soft delete the associated RequestDetails
    UPDATE [dbo].[RequestDetails]
       SET [IsActive]     = 0
     WHERE [RequestID]    = @RequestID


END
GO
