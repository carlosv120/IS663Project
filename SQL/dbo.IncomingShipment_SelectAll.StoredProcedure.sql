/****** Object:  StoredProcedure [dbo].[IncomingShipment_SelectAll]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author
-- Create Date 2024-12-08
-- Description Retrieves paginated list of incoming shipments with their details in JSON format.
-- =============================================

CREATE PROCEDURE [dbo].[IncomingShipment_SelectAll]
					@PageIndex INT
				   ,@PageSize INT
AS
/*
    Example Call

    DECLARE @PageIndex INT = 1
          ,@PageSize  INT = 10

    EXECUTE [dbo].[IncomingShipment_SelectAll]
         @PageIndex
        ,@PageSize

    SELECT * FROM [dbo].[IncomingShipment]
    SELECT * FROM [dbo].[IncomingShipmentDetails]
*/

BEGIN
    SET NOCOUNT ON

    DECLARE @Offset INT = (@PageIndex - 1) * @PageSize

    -- Return total count of incoming shipments
    SELECT COUNT(*) AS TotalCount
    FROM [dbo].[IncomingShipment]

    -- Select paginated incoming shipments with JSON details
    SELECT
         [i].[IncomingShipmentID]
        ,[i].[RequestID]
        ,[i].[TransactionID]
        ,[i].[Notes]
        ,[uC].[FirstName] AS [CreatedByFirstName]
        ,[uC].[LastName] AS [CreatedByLastName]
        ,[uM].[FirstName] AS [ModifiedByFirstName]
        ,[uM].[LastName] AS [ModifiedByLastName]
        ,[i].[DateCreated]
        ,[i].[DateModified]
        ,ShipmentDetails = (
            SELECT
                 [d].[IncomingShipmentDetailID]
                ,[d].[RequestDetailID]
                ,[d].[SupplierID]
                ,[d].[SupplierInvoiceNumber]
                ,[d].[SupplierInvoiceDate]
                ,[d].[OrderNumber]
                ,[d].[TrackingNumber]
                ,[d].[ShipmentDate]
                ,[d].[ArrivalDate]
                ,[d].[QuantityReceived]
                ,[d].[BatchNumber]
                ,[d].[SerialNumber]
                ,[d].[Notes]
                ,[d].[IsActive]
                ,[d].[DateCreated]
                ,[d].[DateModified]
            FROM [dbo].[IncomingShipmentDetails] AS [d]
            WHERE [d].[IncomingShipmentID] = [i].[IncomingShipmentID] AND [d].[IsActive] = 1
            FOR JSON PATH
         )
    FROM [dbo].[IncomingShipment] AS [i]
    INNER JOIN [dbo].[Users] AS [uC] ON [i].[CreatedBy] = [uC].[UserID]
    INNER JOIN [dbo].[Users] AS [uM] ON [i].[ModifiedBy] = [uM].[UserID]
    ORDER BY [i].[IncomingShipmentID]
    OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY
END
GO
