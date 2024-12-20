/****** Object:  StoredProcedure [dbo].[DispatchShipment_SelectAll]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:
-- Create Date: 2024-11-28
-- Description: Retrieves a paginated list of active dispatch shipments with their details in JSON format.
-- =============================================

CREATE PROC [dbo].[DispatchShipment_SelectAll]
														@PageIndex   INT
													   ,@PageSize    INT
AS
/*
    Example Call:

    DECLARE @PageIndex   INT = 1
           ,@PageSize    INT = 5

    EXECUTE [dbo].[DispatchShipment_SelectAll]
													@PageIndex
												   ,@PageSize
*/

BEGIN
    SET NOCOUNT ON

    DECLARE @Offset INT = (@PageIndex - 1) * @PageSize

    SELECT
         [ds].[DispatchShipmentID]
        ,[ds].[DispatchOrderID]
        ,[ds].[StatusID]
        ,[ds].[DispatchDate]
        ,[ds].[ExpectedDeliveryDate]
        ,[ds].[ActualDeliveryDate]
        ,[ds].[TrackingNumber]
        ,[ds].[Notes] AS [ShipmentNotes]
        ,[ds].[IsActive] AS [ShipmentIsActive]
        ,[uC].[FirstName] AS [CreatedByFirstName]
        ,[uC].[LastName] AS [CreatedByLastName]
        ,[uM].[FirstName] AS [ModifiedByFirstName]
        ,[uM].[LastName] AS [ModifiedByLastName]
        ,[ds].[DateCreated]
        ,[ds].[DateModified]
        ,DispatchShipmentDetails = (
               SELECT
                    [dsd].[DispatchShipmentDetailID]
                   ,[dsd].[DispatchOrderDetailID]
                   ,[dsd].[QuantityShipped]
                   ,[dsd].[BatchNumber]
                   ,[dsd].[SerialNumber]
                   ,[dsd].[Notes] AS [DetailNotes]
               FROM
                    [dbo].[DispatchShipmentDetails] AS [dsd] 
               WHERE
                    [dsd].[DispatchShipmentID] = [ds].[DispatchShipmentID] AND [IsActive] = 1
               FOR JSON PATH
           )
        ,TotalCount = (SELECT COUNT(1) FROM [dbo].[DispatchShipment] WHERE [IsActive] = 1)
    FROM [dbo].[DispatchShipment] AS [ds]
    INNER JOIN [dbo].[Users] AS [uC] ON [ds].[CreatedBy] = [uC].[UserID]
    INNER JOIN [dbo].[Users] AS [uM] ON [ds].[ModifiedBy] = [uM].[UserID]
    WHERE [ds].[IsActive] = 1
    ORDER BY [ds].[DispatchShipmentID]
    OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY
END
GO
