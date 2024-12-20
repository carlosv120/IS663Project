/****** Object:  StoredProcedure [dbo].[Suppliers_Update]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Carlos Vanegas
-- Create Date: 2024-11-23
-- Description: Updates supplier details.
-- =============================================

CREATE PROC [dbo].[Suppliers_Update]
									 @SupplierID		INT				
									,@Company			NVARCHAR(50)
									,@MainContactName	NVARCHAR(100)
									,@MainContactNumber NVARCHAR(20)
									,@MainContactEmail	NVARCHAR(50)
									,@ModifiedBy		INT
AS
/*
    Example Call:
    
	DECLARE @SupplierID				INT				= 8
		   ,@Company				NVARCHAR(50)	= 'Updated Supplier Co.'
		   ,@MainContactName		NVARCHAR(100)	= 'Updated Name'
		   ,@MainContactNumber		NVARCHAR(20)	= '987-654-3210'
		   ,@MainContactEmail		NVARCHAR(50)	= 'updated.email@example.com'
		   ,@ModifiedBy				INT				= 1

    EXECUTE [dbo].[Suppliers_Update]
										 @SupplierID
										,@Company
										,@MainContactName
										,@MainContactNumber
										,@MainContactEmail
										,@ModifiedBy
									    


    SELECT *
    FROM [dbo].[Supplier]
    WHERE SupplierID = @SupplierID
*/

BEGIN

    DECLARE @DateModified DATETIME2 = SYSDATETIMEOFFSET() AT TIME ZONE 'UTC' AT TIME ZONE 'Eastern Standard Time'

    UPDATE [dbo].[Supplier]
       SET [Company]			= @Company
          ,[MainContactName]	= @MainContactName
          ,[MainContactNumber]	= @MainContactNumber
          ,[MainContactEmail]	= @MainContactEmail
          ,[ModifiedBy]			= @ModifiedBy
          ,[DateModified]		= @DateModified

     WHERE [SupplierID] = @SupplierID
END
GO
