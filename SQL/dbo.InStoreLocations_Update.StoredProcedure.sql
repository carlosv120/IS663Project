/****** Object:  StoredProcedure [dbo].[InStoreLocations_Update]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:
-- Create Date: 2024-11-23
-- Description: Updates in-store location details.
-- =============================================

CREATE PROC [dbo].[InStoreLocations_Update]
											 @LocationID	INT
											,@LocationName	NVARCHAR(100)
											,@Description	NVARCHAR(255)
											,@Zone			NVARCHAR(50)
											,@SubZone		NVARCHAR(50)
											,@Bin			NVARCHAR(50)
											,@ModifiedBy	INT
AS
/*
    Example Call:

    DECLARE @LocationID		INT = 12
           ,@LocationName	NVARCHAR(100) = 'Updated Location Name'
           ,@Description	NVARCHAR(255) = 'Updated Description'
           ,@Zone			NVARCHAR(50)  = 'Updated Zone'
           ,@SubZone		NVARCHAR(50)  = 'Updated SubZone'
           ,@Bin			NVARCHAR(50)  = 'Updated Bin'
           ,@ModifiedBy		INT = 1
	
	SELECT *
    FROM [dbo].[InStoreLocation]
    WHERE [LocationID] = @LocationID

    EXECUTE [dbo].[InStoreLocations_Update]
											 @LocationID
											,@LocationName
											,@Description
											,@Zone
											,@SubZone
											,@Bin
											,@ModifiedBy

    SELECT *
    FROM [dbo].[InStoreLocation]
    WHERE [LocationID] = @LocationID
*/

BEGIN
    DECLARE @DateModified DATETIME2 = SYSDATETIMEOFFSET() AT TIME ZONE 'UTC' AT TIME ZONE 'Eastern Standard Time'

    UPDATE [dbo].[InStoreLocation]
       SET [LocationName]	= @LocationName
          ,[Description]	= @Description
          ,[Zone]			= @Zone
          ,[SubZone]		= @SubZone
          ,[Bin]			= @Bin
          ,[ModifiedBy]		= @ModifiedBy
          ,[DateModified]	= @DateModified

     WHERE [LocationID]		= @LocationID
END
GO
