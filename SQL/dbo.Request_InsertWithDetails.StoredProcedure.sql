/****** Object:  StoredProcedure [dbo].[Request_InsertWithDetails]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:
-- Create Date: 2024-11-25
-- Description: Inserts a new request along with its associated details.
-- =============================================

CREATE PROC [dbo].[Request_InsertWithDetails]
												 @AlertID           INT
												,@DateRequested     DATETIME2(7)
												,@Notes             NVARCHAR(255)
												,@CreatedBy         INT
												,@RequestDetailList NVARCHAR(MAX) -- JSON string containing RequestDetails
AS
/*
    Example Call:

       DECLARE     @AlertID           INT			= NULL
				  ,@DateRequested     DATETIME2(7)	= SYSDATETIMEOFFSET()
				  ,@Notes             NVARCHAR(255) = 'Urgent request'
				  ,@CreatedBy         INT			= 1
				  ,@RequestDetailList NVARCHAR(MAX) = '[
                    {"ItemID": 5, "ItemDetailID": 11, "Quantity": 50, "Notes": "High Priority"},
                    {"ItemID": 6, "ItemDetailID": 13, "Quantity": 10, "Notes": "Standard"}
                ]'

    EXECUTE [dbo].[Request_InsertWithDetails]
                                                 @AlertID
                                                ,@DateRequested
                                                ,@Notes
                                                ,@CreatedBy
                                                ,@RequestDetailList

	SELECT *
	FROM [dbo].[Request]

*/

BEGIN
    SET NOCOUNT ON
    SET XACT_ABORT ON

    -- Begin the transaction
    BEGIN TRANSACTION

    -- Insert into Request table
    INSERT INTO [dbo].[Request] (	 [AlertID]
									,[DateRequested]
									,[Notes]
									,[CreatedBy]
									,[ModifiedBy])
    VALUES ( @AlertID
			,@DateRequested
			,@Notes
			,@CreatedBy
			,@CreatedBy)

    -- Retrieve the new RequestID
    DECLARE @RequestID INT = SCOPE_IDENTITY()

    -- Insert into RequestDetails table
    INSERT INTO [dbo].[RequestDetails] (	 [RequestID]
											,[ItemID]
											,[ItemDetailID]
											,[Quantity]
											,[Notes]
										)
    SELECT
         @RequestID AS RequestID
        ,JSON_VALUE(value, '$.ItemID')			AS ItemID
        ,JSON_VALUE(value, '$.ItemDetailID')	AS ItemDetailID
        ,JSON_VALUE(value, '$.Quantity')		AS Quantity
        ,JSON_VALUE(value, '$.Notes')			AS Notes
    FROM
        OPENJSON(@RequestDetailList)

    -- Commit the transaction
    COMMIT TRANSACTION

    -- Return the RequestID
    SELECT @RequestID AS RequestID
END
GO
