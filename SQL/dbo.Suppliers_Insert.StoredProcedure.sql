/****** Object:  StoredProcedure [dbo].[Suppliers_Insert]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Carlos Vanegas
-- Create Date: 2024-11-23
-- Description: Inserts a new supplier record.
-- =============================================

CREATE PROC [dbo].[Suppliers_Insert]
									 @Company			NVARCHAR(50)
									,@MainContactName	NVARCHAR(100)
									,@MainContactNumber NVARCHAR(20)
									,@MainContactEmail	NVARCHAR(50)
									,@CreatedBy			INT
									,@SupplierID		INT				OUTPUT				
AS
/*
    Example Call:
    DECLARE	   @SupplierID			INT				= 1
			  ,@Company				NVARCHAR(50)	= 'Supplier Co.'
			  ,@MainContactName		NVARCHAR(100)	= 'John Doe Jr.'
			  ,@MainContactNumber	NVARCHAR(20)	= '123-456-7890'
			  ,@MainContactEmail	NVARCHAR(50)	= 'john.doe.jr@example.com'
			  ,@CreatedBy			INT				= 1

    EXECUTE [dbo].[Suppliers_Insert]	 @Company
										,@MainContactName
										,@MainContactNumber
										,@MainContactEmail
										,@CreatedBy
										,@SupplierID	OUTPUT

	SELECT *
    FROM [dbo].[Supplier]
*/
BEGIN

	INSERT INTO [dbo].[Supplier] (   [Company]
									,[MainContactName]
									,[MainContactNumber]
									,[MainContactEmail]
									,[CreatedBy]
									,[ModifiedBy]
								)
	VALUES (	 @Company
				,@MainContactName
				,@MainContactNumber
				,@MainContactEmail
				,@CreatedBy
				,@CreatedBy
			)

	SET @SupplierID = SCOPE_IDENTITY()
	--SELECT SCOPE_IDENTITY() AS SupplierID
END

GO
