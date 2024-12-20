/****** Object:  StoredProcedure [dbo].[Suppliers_SelectAll]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      
-- Create Date: 
-- Description: Retrieves paginated list of active suppliers with creator and modifier details.
-- =============================================


CREATE PROC [dbo].[Suppliers_SelectAll]
										 @PageIndex INT
										,@PageSize  INT
AS
/*
    DECLARE @PageIndex INT = 2
           ,@PageSize  INT = 5

    EXECUTE [dbo].[Suppliers_SelectAll]
										 @PageIndex
										,@PageSize

    SELECT *
    FROM [dbo].[Supplier]
*/
BEGIN
    DECLARE @Offset INT = (@PageIndex - 1) * @PageSize

-- Return total count of active suppliers
    SELECT COUNT(*) AS TotalCount
    FROM [dbo].[Supplier]
    WHERE IsActive = 1

    -- Return paginated list of suppliers
    SELECT   [s].[SupplierID]
			,[s].[Company]
			,[s].[MainContactName]
			,[s].[MainContactNumber]
			,[s].[MainContactEmail]
			,[s].[IsActive]
			,[uC].[FirstName]	AS [CreatedByFirstName]
			,[uC].[LastName]	AS [CreatedByLastName]
			,[uM].[FirstName]	AS [ModifiedByFirstName]
			,[uM].[LastName]	AS [ModifiedByLastName]
			,[s].[DateCreated]
			,[s].[DateModified]
    FROM [dbo].[Supplier] AS [s]
    INNER JOIN [dbo].[Users] AS [uC] ON [s].[CreatedBy] = [uC].[UserID]
    INNER JOIN [dbo].[Users] AS [uM] ON [s].[ModifiedBy] = [uM].[UserID]
    WHERE [s].[IsActive] = 1
    ORDER BY [s].[SupplierID]
    OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY;
END

GO
