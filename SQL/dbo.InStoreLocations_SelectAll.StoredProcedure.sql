/****** Object:  StoredProcedure [dbo].[InStoreLocations_SelectAll]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: 
-- Create Date: 2024-11-23
-- Description: Retrieves paginated list of active in-store locations.
-- =============================================

CREATE PROC [dbo].[InStoreLocations_SelectAll]
												 @PageIndex	INT
												,@PageSize	INT
AS
/*
    Example Call:

    DECLARE @PageIndex	INT = 2
           ,@PageSize	INT = 4

    EXECUTE [dbo].[InStoreLocations_SelectAll]
												 @PageIndex
												,@PageSize

    SELECT *
    FROM [dbo].[InStoreLocation]
*/

BEGIN
    DECLARE @Offset INT = (@PageIndex - 1) * @PageSize

	-- Return total count of active locations
    SELECT COUNT(*) AS TotalCount
    FROM [dbo].[InStoreLocation]
    WHERE IsActive = 1

    SELECT   [l].[LocationID]
			,[l].[LocationName]
			,[l].[Description]
			,[l].[Zone]
			,[l].[SubZone]
			,[l].[Bin]
			,[l].[IsActive]
				,[uC].[FirstName]	AS [CreatedByFirstName]
				,[uC].[LastName]	AS [CreatedByLastName]
				,[uM].[FirstName]	AS [ModifiedByFirstName]
				,[uM].[LastName]	AS [ModifiedByLastName]
			,[l].[DateCreated]
			,[l].[DateModified]
    FROM [dbo].[InStoreLocation] AS [l]
    INNER JOIN [dbo].[Users] AS [uC] ON [l].[CreatedBy] = [uC].[UserID]
    INNER JOIN [dbo].[Users] AS [uM] ON [l].[ModifiedBy] = [uM].[UserID]
    WHERE [l].[IsActive] = 1
    ORDER BY [l].[LocationID]
    OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY
END
GO
