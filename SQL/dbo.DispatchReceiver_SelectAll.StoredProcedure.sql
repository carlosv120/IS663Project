/****** Object:  StoredProcedure [dbo].[DispatchReceiver_SelectAll]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: 
-- Create Date: 2024-11-24
-- Description: Retrieves paginated list of active dispatch receivers.
-- =============================================

CREATE PROC [dbo].[DispatchReceiver_SelectAll]
											@PageIndex	INT
										   ,@PageSize	INT
AS
/*
    Example Call:

    DECLARE    @PageIndex	INT = 1
			  ,@PageSize	INT = 3

    EXECUTE [dbo].[DispatchReceiver_SelectAll]
											@PageIndex
										   ,@PageSize
	SELECT * 
	FROM DispatchReceiver
*/

BEGIN
    DECLARE @Offset INT = (@PageIndex - 1) * @PageSize

	-- Return total count of active receivers
    SELECT COUNT(*) AS TotalCount
    FROM [dbo].[DispatchReceiver]
    WHERE IsActive = 1

    SELECT   [dr].[ReceiverID]
			,[dr].[ReceiverName]
			,[dr].[CompanyName]
			,[dr].[ContactNumber]
			,[dr].[Email]
			,[dr].[Address]
			,[dr].[City]
			,[dr].[State]
			,[dr].[PostalCode]
			,[dr].[Country]
			,[dr].[IsActive]
			,[uC].[FirstName] AS [CreatedByFirstName]
			,[uC].[LastName]  AS [CreatedByLastName]
			,[uM].[FirstName] AS [ModifiedByFirstName]
			,[uM].[LastName]  AS [ModifiedByLastName]
			,[dr].[DateCreated]
			,[dr].[DateModified]
    FROM [dbo].[DispatchReceiver] AS [dr]
    INNER JOIN [dbo].[Users] AS [uC] ON [dr].[CreatedBy] = [uC].[UserID]
    INNER JOIN [dbo].[Users] AS [uM] ON [dr].[ModifiedBy] = [uM].[UserID]
    WHERE [dr].[IsActive] = 1
    ORDER BY [dr].[ReceiverID]
    OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY
END
GO
