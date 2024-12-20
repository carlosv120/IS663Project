/****** Object:  StoredProcedure [dbo].[InStoreLocations_Insert]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:
-- Create Date: 2024-11-23
-- Description: Inserts a new in-store location.
-- =============================================

CREATE PROC [dbo].[InStoreLocations_Insert]
									 @LocationName	NVARCHAR(100)
									,@Description	NVARCHAR(255)
									,@Zone			NVARCHAR(50)
									,@SubZone		NVARCHAR(50)
									,@Bin			NVARCHAR(50)
									,@CreatedBy		INT
									,@LocationID	INT OUTPUT
AS
/*
    Example Call:

    DECLARE    @LocationID		INT			  = 0
			  ,@LocationName	NVARCHAR(100) = 'Pharmacy A'
			  ,@Description		NVARCHAR(255) = 'Pharmacy section A'
			  ,@Zone			NVARCHAR(50)  = 'Zone 1'
			  ,@SubZone			NVARCHAR(50)  = 'SubZone 1'
			  ,@Bin				NVARCHAR(50)  = 'Bin 5'
			  ,@CreatedBy		INT			  = 1

    EXECUTE [dbo].[InStoreLocations_Insert]
             @LocationName
            ,@Description
            ,@Zone
            ,@SubZone
            ,@Bin
            ,@CreatedBy
            ,@LocationID OUTPUT

    SELECT *
    FROM [dbo].[InStoreLocation]
*/

BEGIN
    INSERT INTO [dbo].[InStoreLocation] ( [LocationName]
										 ,[Description]
										 ,[Zone]
										 ,[SubZone]
										 ,[Bin]
										 ,[CreatedBy]
										 ,[ModifiedBy] )
    VALUES (	 @LocationName
				,@Description
				,@Zone
				,@SubZone
				,@Bin
				,@CreatedBy
				,@CreatedBy )

	SET @LocationID = SCOPE_IDENTITY()
	--SELECT SCOPE_IDENTITY() AS LocationID

END
GO
