/****** Object:  StoredProcedure [dbo].[InStoreLocations_Delete]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:
-- Create Date: 2024-11-23
-- Description: Deactivates an in-store location by setting IsActive to 0.
-- =============================================

CREATE PROC [dbo].[InStoreLocations_Delete]
											 @LocationID	INT
											,@ModifiedBy	INT
AS
/*
    Example Call:

    DECLARE @LocationID	INT = 12
           ,@ModifiedBy	INT = 1

    EXECUTE [dbo].[InStoreLocations_Delete]
											 @LocationID
											,@ModifiedBy

    SELECT *
    FROM	[dbo].[InStoreLocation]
    WHERE	[LocationID] = @LocationID
*/

BEGIN
    DECLARE @DateModified DATETIME2 = SYSDATETIMEOFFSET() AT TIME ZONE 'UTC' AT TIME ZONE 'Eastern Standard Time'

    UPDATE [dbo].[InStoreLocation]
       SET [IsActive]		= 0
          ,[ModifiedBy]		= @ModifiedBy
          ,[DateModified]	= @DateModified
     WHERE [LocationID]		= @LocationID
END
GO
