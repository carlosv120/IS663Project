/****** Object:  StoredProcedure [dbo].[DispatchOrder_UpdateWithDetails]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:
-- Create Date: 2024-11-27
-- Description: Updates an existing dispatch order along with its associated details without using DispatchOrderDetailID.
-- =============================================

CREATE PROC [dbo].[DispatchOrder_UpdateWithDetails]
											 @DispatchOrderID         INT
											,@IsPrescription          BIT
											,@PatientID               INT
											,@PrescriptionNumber      NVARCHAR(50)
											,@ReceiverID              INT
											,@ReceiverOrderNumber     NVARCHAR(50)
											,@Notes                   NVARCHAR(255)
											,@ModifiedBy              INT
											,@DispatchOrderDetailList NVARCHAR(MAX) -- JSON string containing DispatchOrderDetails
AS
/*
    Example Call:

    DECLARE        @DispatchOrderID         INT = 3
				  ,@IsPrescription          BIT = 0
				  ,@PatientID               INT = NULL
				  ,@PrescriptionNumber      NVARCHAR(50) = NULL
				  ,@ReceiverID              INT = 1
				  ,@ReceiverOrderNumber     NVARCHAR(50) = 'UPDORD1234'
				  ,@Notes                   NVARCHAR(255) = 'Updated'
				  ,@ModifiedBy              INT = 1
				  ,@DispatchOrderDetailList NVARCHAR(MAX) = '[ 
                    {"ItemID": 5, "ItemDetailID": 11, "Quantity": 5, "Notes": ""},
				    {"ItemID": 7, "ItemDetailID": 14, "Quantity": 10, "Notes": "UPDATED"},
					{"ItemID": 8, "ItemDetailID": 17, "Quantity": 20, "Notes": "New Item"}
                ]'
		-- FOR NULL USE "" or OMIT IT COMPLETELY. THE ITEMS ABOVE WILL BE EITHER MODIFIED OR INCLUDED
		-- IF PREVIOUS ITEMS ARE NOT INSERTED INTO THE JSON ABOVE, THEY WILL BE DELETED.

       EXECUTE [dbo].[DispatchOrder_UpdateWithDetails]
                 @DispatchOrderID
                ,@IsPrescription
                ,@PatientID
                ,@PrescriptionNumber
                ,@ReceiverID
                ,@ReceiverOrderNumber
                ,@Notes
                ,@ModifiedBy
                ,@DispatchOrderDetailList


SELECT * FROM DispatchOrder
SELECT * FROM DispatchOrderDetails
WHERE DispatchOrderID = 3 AND IsActive = 1
*/

BEGIN
    SET NOCOUNT ON
    SET XACT_ABORT ON

    -- Declare a consistent DateModified timestamp
    DECLARE @DateModified DATETIME2 = SYSDATETIMEOFFSET() AT TIME ZONE 'UTC' AT TIME ZONE 'Eastern Standard Time'

    -- Begin the transaction
    BEGIN TRANSACTION

    -- Update the DispatchOrder table
    UPDATE [dbo].[DispatchOrder]
    SET
         [IsPrescription]      = @IsPrescription
        ,[PatientID]           = @PatientID
        ,[PrescriptionNumber]  = @PrescriptionNumber
        ,[ReceiverID]          = @ReceiverID
        ,[ReceiverOrderNumber] = @ReceiverOrderNumber
        ,[Notes]               = @Notes
        ,[ModifiedBy]          = @ModifiedBy
        ,[DateModified]        = @DateModified
    WHERE [DispatchOrderID] = @DispatchOrderID

    -- Mark records as inactive only if they are not in the incoming JSON
    UPDATE [dbo].[DispatchOrderDetails]
    SET [IsActive] = 0
    WHERE [DispatchOrderID] = @DispatchOrderID
      AND CONCAT([ItemID], '-', [ItemDetailID]) NOT IN (
          SELECT CONCAT(JSON_VALUE(value, '$.ItemID'), '-', JSON_VALUE(value, '$.ItemDetailID'))
          FROM OPENJSON(@DispatchOrderDetailList)
      )
      AND [IsActive] = 1

    -- Update existing details
    UPDATE dod
    SET
         [Quantity]     = JSON_VALUE(value, '$.Quantity')
        ,[Notes]        = JSON_VALUE(value, '$.Notes')
    FROM [dbo].[DispatchOrderDetails] dod
    INNER JOIN OPENJSON(@DispatchOrderDetailList) j
        ON dod.[DispatchOrderID] = @DispatchOrderID
       AND dod.[ItemID] = JSON_VALUE(j.value, '$.ItemID')
       AND dod.[ItemDetailID] = JSON_VALUE(j.value, '$.ItemDetailID')
    WHERE dod.[IsActive] = 1

    -- Insert new details for items not already in the table
    INSERT INTO [dbo].[DispatchOrderDetails] (
         [DispatchOrderID]
        ,[ItemID]
        ,[ItemDetailID]
        ,[Quantity]
        ,[Notes]
        ,[IsActive]
    )
    SELECT
         @DispatchOrderID AS DispatchOrderID
        ,JSON_VALUE(value, '$.ItemID')			AS ItemID
        ,JSON_VALUE(value, '$.ItemDetailID')	AS ItemDetailID
        ,JSON_VALUE(value, '$.Quantity')		AS Quantity
        ,JSON_VALUE(value, '$.Notes')			AS Notes
        ,1                                       AS IsActive
    FROM OPENJSON(@DispatchOrderDetailList)
    WHERE CONCAT(JSON_VALUE(value, '$.ItemID'), '-', JSON_VALUE(value, '$.ItemDetailID')) NOT IN (
        SELECT CONCAT([ItemID], '-', [ItemDetailID])
        FROM [dbo].[DispatchOrderDetails]
        WHERE [DispatchOrderID] = @DispatchOrderID
          AND [IsActive] = 1
    )

    -- Commit the transaction
    COMMIT TRANSACTION
END
GO
