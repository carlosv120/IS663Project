/****** Object:  StoredProcedure [dbo].[Request_SelectAll]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:
-- Create Date: 2024-11-25
-- Description: Retrieves paginated list of active requests with their details in JSON format.
-- =============================================

CREATE PROC [dbo].[Request_SelectAll]
										 @PageIndex   INT
										,@PageSize    INT
AS
/*
    Example Call:

    DECLARE @PageIndex   INT = 1
           ,@PageSize    INT = 2

    EXECUTE [dbo].[Request_SelectAll]
										 @PageIndex
										,@PageSize

	SELECT *
    FROM [dbo].[Request]
*/

BEGIN
    SET NOCOUNT ON

    DECLARE @Offset INT = (@PageIndex - 1) * @PageSize

	-- Return total count of active requests
    SELECT COUNT(*) AS TotalCount
    FROM [dbo].[Request]
    WHERE IsActive = 1

    SELECT
         [r].[RequestID]
        ,[r].[AlertID]
        ,[r].[DateRequested]
        ,[r].[IsApproved]
        ,[r].[DateApproved]
        ,[r].[TransactionID]
        ,[r].[IsCompleted] AS [RequestIsCompleted]
        ,[r].[Notes] AS [RequestNotes]
        ,[r].[IsActive] AS [RequestIsActive]
        ,[uC].[FirstName] AS [CreatedByFirstName]
        ,[uC].[LastName] AS [CreatedByLastName]
        ,[uM].[FirstName] AS [ModifiedByFirstName]
        ,[uM].[LastName] AS [ModifiedByLastName]
        ,[r].[DateCreated]
        ,[r].[DateModified]
        ,RequestDetails = (
               SELECT
                    [rd].[RequestDetailID]
                   ,[rd].[ItemID]
                   ,[rd].[ItemDetailID]
                   ,[rd].[Quantity]
                   ,[rd].[IsCompleted]
                   ,[rd].[Notes]
               FROM
                    [dbo].[RequestDetails] AS [rd]
               WHERE
                    [rd].[RequestID] = [r].[RequestID] AND [rd].[IsActive] = 1 -- Filter active details only
               FOR JSON PATH
           )
    FROM [dbo].[Request] AS [r]
    INNER JOIN [dbo].[Users] AS [uC] ON [r].[CreatedBy] = [uC].[UserID]
    INNER JOIN [dbo].[Users] AS [uM] ON [r].[ModifiedBy] = [uM].[UserID]
    WHERE [r].[IsActive] = 1
    ORDER BY [r].[RequestID]
    OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY
END
GO
