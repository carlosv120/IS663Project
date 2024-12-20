/****** Object:  StoredProcedure [dbo].[Request_UpdateWithDetails]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:
-- Create Date: 2024-11-27
-- Description: Updates an existing request along with its associated details without using RequestDetailID.
-- =============================================

CREATE PROC [dbo].[Request_UpdateWithDetails]
											 @RequestID         INT
											,@AlertID           INT
											,@Notes             NVARCHAR(255)
											,@ModifiedBy        INT
											,@RequestDetailList NVARCHAR(MAX) -- JSON string containing RequestDetails
AS
/*
    Example Call:

    DECLARE     @RequestID         INT = 7
			   ,@AlertID           INT = NULL
			   ,@Notes             NVARCHAR(255) = 'Updated request'
			   ,@ModifiedBy        INT = 1
			   ,@RequestDetailList NVARCHAR(MAX) = '[ 
					{"ItemID": 6, "ItemDetailID": 13, "Quantity": 100, "Notes": "Updated Quantity Existing Item"},
					{"ItemID": 8, "ItemDetailID": 17, "Quantity": 20, "Notes": "UPDATED"}
                ]'

		-- IF PREVIOUS ITEMS ARE NOT INSERTED INTO THE JSON ABOVE, THEY WILL BE DELETED.

    EXECUTE [dbo].[Request_UpdateWithDetails]
         @RequestID
        ,@AlertID
        ,@Notes
        ,@ModifiedBy
        ,@RequestDetailList

    SELECT * FROM Request  WHERE RequestID = 5
    SELECT * FROM RequestDetails
    WHERE RequestID = 5 AND IsActive = 1
*/


BEGIN
    SET NOCOUNT ON
    SET XACT_ABORT ON

    -- Declare a consistent DateModified timestamp
    DECLARE @DateModified DATETIME2 = SYSDATETIMEOFFSET() AT TIME ZONE 'UTC' AT TIME ZONE 'Eastern Standard Time'

    -- Begin the transaction
    BEGIN TRANSACTION

    -- Update the Request table
    UPDATE [dbo].[Request]
    SET
         [AlertID]       = @AlertID,
         [Notes]         = @Notes,
         [ModifiedBy]    = @ModifiedBy,
         [DateModified]  = @DateModified
    WHERE [RequestID] = @RequestID

    -- Create a temporary table to store incoming request details
    CREATE TABLE #TempRequestDetails (
        ItemID INT,
        ItemDetailID INT,
        Quantity INT,
        Notes NVARCHAR(255)
    );

    -- Populate the temporary table with data from the JSON payload
    INSERT INTO #TempRequestDetails (ItemID, ItemDetailID, Quantity, Notes)
    SELECT
        JSON_VALUE(value, '$.ItemID') AS ItemID,
        JSON_VALUE(value, '$.ItemDetailID') AS ItemDetailID,
        JSON_VALUE(value, '$.Quantity') AS Quantity,
        JSON_VALUE(value, '$.Notes') AS Notes
    FROM OPENJSON(@RequestDetailList)

    -- Mark all existing RequestDetails as inactive
    UPDATE [dbo].[RequestDetails]
    SET [IsActive] = 0
    WHERE [RequestID] = @RequestID
      AND [IsActive] = 1

    -- Update existing details that match the incoming payload
    UPDATE rd
    SET
         [Quantity] = t.Quantity,
         [Notes]    = t.Notes,
         [IsActive] = 1
    FROM [dbo].[RequestDetails] rd
    INNER JOIN #TempRequestDetails t
        ON rd.[RequestID] = @RequestID
       AND rd.[ItemID] = t.ItemID
       AND rd.[ItemDetailID] = t.ItemDetailID

    -- Insert new details for items not already in the table
    INSERT INTO [dbo].[RequestDetails] (
         [RequestID],
         [ItemID],
         [ItemDetailID],
         [Quantity],
         [Notes],
         [IsActive]
    )
    SELECT
         @RequestID AS RequestID,
         t.ItemID,
         t.ItemDetailID,
         t.Quantity,
         t.Notes,
         1 AS IsActive
    FROM #TempRequestDetails t
    WHERE NOT EXISTS (
        SELECT 1
        FROM [dbo].[RequestDetails] rd
        WHERE rd.[RequestID] = @RequestID
          AND rd.[ItemID] = t.ItemID
          AND rd.[ItemDetailID] = t.ItemDetailID
    );

    -- Drop the temporary table
    DROP TABLE #TempRequestDetails

    -- Commit the transaction
    COMMIT TRANSACTION
END;
GO
