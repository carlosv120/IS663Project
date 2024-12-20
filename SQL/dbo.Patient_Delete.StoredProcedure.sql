/****** Object:  StoredProcedure [dbo].[Patient_Delete]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: 
-- Create Date: 2024-11-23
-- Description: Deactivates a patient by setting IsActive to 0.
-- =============================================

CREATE PROC [dbo].[Patient_Delete]
									 @PatientID		INT
									,@ModifiedBy	INT
AS
/*
    Example Call:

    DECLARE	 @PatientID		INT = 38
			,@ModifiedBy	INT = 1

    EXECUTE [dbo].[Patient_Delete]
									 @PatientID
									,@ModifiedBy

    SELECT *
    FROM [dbo].[Patient]
    WHERE [PatientID] = @PatientID
*/

BEGIN
    DECLARE @DateModified DATETIME2 = SYSDATETIMEOFFSET() AT TIME ZONE 'UTC' AT TIME ZONE 'Eastern Standard Time'

    UPDATE [dbo].[Patient]
       SET [IsActive]		= 0
          ,[ModifiedBy]		= @ModifiedBy
          ,[DateModified]	= @DateModified
     WHERE [PatientID]		= @PatientID
END
GO
