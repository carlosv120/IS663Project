/****** Object:  StoredProcedure [dbo].[DispatchOrder_InsertWithDetails]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:
-- Create Date: 2024-11-27
-- Description: Inserts a new dispatch order along with its associated details.
-- =============================================

CREATE PROC [dbo].[DispatchOrder_InsertWithDetails]
												 @IsPrescription      BIT
												,@PatientID           INT
												,@PrescriptionNumber  NVARCHAR(50)
												,@ReceiverID          INT
												,@ReceiverOrderNumber NVARCHAR(50)
												,@Notes               NVARCHAR(255)
												,@CreatedBy           INT
												,@DispatchOrderDetailList NVARCHAR(MAX) -- JSON string containing DispatchOrderDetails
AS
/*
    Example Call:

       DECLARE     @IsPrescription      BIT = 0
				  ,@PatientID           INT = NULL
				  ,@PrescriptionNumber  NVARCHAR(50) = NULL
				  ,@ReceiverID          INT = 1
				  ,@ReceiverOrderNumber NVARCHAR(50) = 'ORD67890'
				  ,@Notes               NVARCHAR(255) = 'Urgent delivery'
				  ,@CreatedBy           INT = 1
				  ,@DispatchOrderDetailList NVARCHAR(MAX) = '[ 
                    {"ItemID": 5, "ItemDetailID": 11, "Quantity": 50, "Notes": "High Priority"},
                    {"ItemID": 6, "ItemDetailID": 13, "Quantity": 10, "Notes": "Standard"}
                ]'

       EXECUTE [dbo].[DispatchOrder_InsertWithDetails]
                 @IsPrescription
                ,@PatientID
                ,@PrescriptionNumber
                ,@ReceiverID
                ,@ReceiverOrderNumber
                ,@Notes
                ,@CreatedBy
                ,@DispatchOrderDetailList
*/

BEGIN
    SET NOCOUNT ON
    SET XACT_ABORT ON

    -- Begin the transaction
    BEGIN TRANSACTION

    -- Insert into DispatchOrder table
    INSERT INTO [dbo].[DispatchOrder] (
         [IsPrescription]
        ,[PatientID]
        ,[PrescriptionNumber]
        ,[ReceiverID]
        ,[ReceiverOrderNumber]
        ,[Notes]
        ,[CreatedBy]
        ,[ModifiedBy]
    )
    VALUES (
         @IsPrescription
        ,@PatientID
        ,@PrescriptionNumber
        ,@ReceiverID
        ,@ReceiverOrderNumber
        ,@Notes
        ,@CreatedBy
        ,@CreatedBy
    )

    -- Retrieve the new DispatchOrderID
    DECLARE @DispatchOrderID INT = SCOPE_IDENTITY()

    -- Insert into DispatchOrderDetails table
    INSERT INTO [dbo].[DispatchOrderDetails] (
         [DispatchOrderID]
        ,[ItemID]
        ,[ItemDetailID]
        ,[Quantity]
        ,[Notes]
    )
    SELECT
         @DispatchOrderID AS DispatchOrderID
        ,JSON_VALUE(value, '$.ItemID')			AS ItemID
        ,JSON_VALUE(value, '$.ItemDetailID')	AS ItemDetailID
        ,JSON_VALUE(value, '$.Quantity')		AS Quantity
        ,JSON_VALUE(value, '$.Notes')			AS Notes
    FROM
        OPENJSON(@DispatchOrderDetailList)

    -- Commit the transaction
    COMMIT TRANSACTION

    -- Return the DispatchOrderID
    SELECT @DispatchOrderID AS DispatchOrderID
END
GO
