/****** Object:  StoredProcedure [dbo].[Patient_SelectAll]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: 
-- Create Date: 2024-11-23
-- Description: Retrieves paginated list of active patients with complete details.
-- =============================================

CREATE PROC [dbo].[Patient_SelectAll]
									 @PageIndex	INT
									,@PageSize	INT
AS
/*
    Example Call:

    DECLARE @PageIndex	INT = 2
           ,@PageSize	INT = 3

    EXECUTE [dbo].[Patient_SelectAll]
										 @PageIndex
										,@PageSize

    SELECT *
    FROM [dbo].[Patient]
*/

BEGIN
    DECLARE @Offset INT = (@PageIndex - 1) * @PageSize

    -- Return total count of active patients
    SELECT COUNT(*) AS TotalCount
    FROM [dbo].[Patient]
    WHERE IsActive = 1

    -- Return paginated list of patients with full details
    SELECT   [p].[PatientID]
			,[p].[FirstName]
			,[p].[LastName]
			,[p].[DateOfBirth]
			,[p].[ContactNumber]
			,[p].[Email]
			,[p].[Address]
			,[p].[City]
			,[p].[State]
			,[p].[PostalCode]
			,[p].[Country]
			,[p].[EmergencyContactName]
			,[p].[EmergencyContactNumber]
			,[p].[MedicalNotes]
			,[p].[IsActive]
			,[uC].[FirstName]	AS [CreatedByFirstName]
			,[uC].[LastName]	AS [CreatedByLastName]
			,[uM].[FirstName]	AS [ModifiedByFirstName]
			,[uM].[LastName]	AS [ModifiedByLastName]
			,[p].[DateCreated]
			,[p].[DateModified]
    FROM [dbo].[Patient] AS [p]
    INNER JOIN [dbo].[Users] AS [uC] ON [p].[CreatedBy] = [uC].[UserID]
    INNER JOIN [dbo].[Users] AS [uM] ON [p].[ModifiedBy] = [uM].[UserID]
    WHERE [p].[IsActive] = 1
    ORDER BY [p].[PatientID]
    OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY;
END
GO
