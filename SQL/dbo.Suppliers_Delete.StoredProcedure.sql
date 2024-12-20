/****** Object:  StoredProcedure [dbo].[Suppliers_Delete]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Carlos Vanegas
-- Create Date: 2024-11-23
-- Description: Deactivates a supplier by setting IsActive to 0.
-- =============================================

CREATE PROC [dbo].[Suppliers_Delete]
									 @SupplierID	INT
									,@ModifiedBy	INT
AS
/*
    Example Call:

    DECLARE		 @SupplierID	INT = 8
				,@ModifiedBy	INT = 1

    EXECUTE [dbo].[Suppliers_Delete]
										 @SupplierID
										,@ModifiedBy

    SELECT *
    FROM [dbo].[Supplier]
    WHERE [SupplierID] = @SupplierID
*/

BEGIN
    DECLARE @DateModified DATETIME2 = SYSDATETIMEOFFSET() AT TIME ZONE 'UTC' AT TIME ZONE 'Eastern Standard Time'

    UPDATE [dbo].[Supplier]
       SET [IsActive]		= 0
          ,[ModifiedBy]		= @ModifiedBy
          ,[DateModified]	= @DateModified
     WHERE [SupplierID]		= @SupplierID
END
GO
