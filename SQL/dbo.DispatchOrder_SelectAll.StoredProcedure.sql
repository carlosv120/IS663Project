/****** Object:  StoredProcedure [dbo].[DispatchOrder_SelectAll]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:
-- Create Date: 2024-11-27
-- Description: Retrieves a paginated list of active dispatch orders with their details in JSON format.
-- =============================================

CREATE PROC [dbo].[DispatchOrder_SelectAll]
														@PageIndex   INT
													   ,@PageSize    INT
AS
/*
    Example Call:

    DECLARE @PageIndex   INT = 1
           ,@PageSize    INT = 5

    EXECUTE [dbo].[DispatchOrder_SelectAll]
													@PageIndex
												   ,@PageSize
*/

BEGIN
    SET NOCOUNT ON;

    DECLARE @Offset INT = (@PageIndex - 1) * @PageSize

    SELECT
         [do].[DispatchOrderID]
        ,[do].[IsPrescription]
        ,[do].[PatientID]
        ,[do].[PrescriptionNumber]
        ,[do].[ReceiverID]
        ,[do].[ReceiverOrderNumber]
        ,[do].[DateRequested]
        ,[do].[IsCompleted] AS [DispatchIsCompleted]
        ,[do].[Notes] AS [DispatchNotes]
        ,[do].[IsActive] AS [DispatchIsActive]
        ,[uC].[FirstName] AS [CreatedByFirstName]
        ,[uC].[LastName] AS [CreatedByLastName]
        ,[uM].[FirstName] AS [ModifiedByFirstName]
        ,[uM].[LastName] AS [ModifiedByLastName]
        ,[do].[DateCreated]
        ,[do].[DateModified]
        ,DispatchOrderDetails = (
               SELECT
                    [dod].[DispatchOrderDetailID]
                   ,[dod].[ItemID]
                   ,[dod].[ItemDetailID]
                   ,[dod].[Quantity]
                   ,[dod].[IsCompleted]
                   ,[dod].[Notes] AS [DetailNotes]
               FROM
                    [dbo].[DispatchOrderDetails] AS [dod]
               WHERE
                    [dod].[DispatchOrderID] = [do].[DispatchOrderID]
               FOR JSON PATH
           )
        ,TotalCount = (SELECT COUNT(1) FROM [dbo].[DispatchOrder] WHERE [IsActive] = 1)
    FROM [dbo].[DispatchOrder] AS [do]
    INNER JOIN [dbo].[Users] AS [uC] ON [do].[CreatedBy] = [uC].[UserID]
    INNER JOIN [dbo].[Users] AS [uM] ON [do].[ModifiedBy] = [uM].[UserID]
    WHERE [do].[IsActive] = 1
    ORDER BY [do].[DispatchOrderID]
    OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY
END
GO
