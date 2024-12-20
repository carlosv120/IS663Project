/****** Object:  StoredProcedure [dbo].[Patient_Update]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: 
-- Create Date: 2024-11-23
-- Description: Updates patient details.
-- =============================================

CREATE PROC [dbo].[Patient_Update]
									 @PatientID					INT
									,@FirstName					NVARCHAR(50)
									,@LastName					NVARCHAR(50)
									,@DateOfBirth				DATE
									,@ContactNumber				NVARCHAR(20)
									,@Email						NVARCHAR(100)
									,@Address					NVARCHAR(255)
									,@City						NVARCHAR(50)
									,@State						NVARCHAR(50)
									,@PostalCode				NVARCHAR(20)
									,@Country					NVARCHAR(50)
									,@EmergencyContactName		NVARCHAR(100)
									,@EmergencyContactNumber	NVARCHAR(20)
									,@MedicalNotes				NVARCHAR(255)
									,@ModifiedBy				INT
AS
/*
    Example Call:

    DECLARE    @PatientID				INT				= 1
			  ,@FirstName				NVARCHAR(50)	= 'Updated John'
			  ,@LastName				NVARCHAR(50)	= 'Updated Doe'
			  ,@DateOfBirth				DATE			= '1985-07-15'
			  ,@ContactNumber			NVARCHAR(20)	= '123-456-7890'
			  ,@Email					NVARCHAR(100)	= 'updated.email@example.com'
			  ,@Address					NVARCHAR(255)	= 'Updated Address'
			  ,@City					NVARCHAR(50)	= 'Updated City'
			  ,@State					NVARCHAR(50)	= 'Updated State'
			  ,@PostalCode				NVARCHAR(20)	= '12345'
			  ,@Country					NVARCHAR(50)	= 'Updated Country'
			  ,@EmergencyContactName	NVARCHAR(100)	= 'Updated Jane'
			  ,@EmergencyContactNumber	NVARCHAR(20)	= '987-654-3210'
			  ,@MedicalNotes			NVARCHAR(255)	= 'Updated notes'
			  ,@ModifiedBy				INT				= 1

    EXECUTE [dbo].[Patient_Update]
									 @PatientID
									,@FirstName
									,@LastName
									,@DateOfBirth
									,@ContactNumber
									,@Email
									,@Address
									,@City
									,@State
									,@PostalCode
									,@Country
									,@EmergencyContactName
									,@EmergencyContactNumber
									,@MedicalNotes
									,@ModifiedBy

    SELECT *
    FROM [dbo].[Patient]
    WHERE [PatientID] = @PatientID
*/

BEGIN
    DECLARE @DateModified DATETIME2 = SYSDATETIMEOFFSET() AT TIME ZONE 'UTC' AT TIME ZONE 'Eastern Standard Time'

    UPDATE [dbo].[Patient]
       SET [FirstName]				= @FirstName
          ,[LastName]				= @LastName
          ,[DateOfBirth]			= @DateOfBirth
          ,[ContactNumber]			= @ContactNumber
          ,[Email]					= @Email
          ,[Address]				= @Address
          ,[City]					= @City
          ,[State]					= @State
          ,[PostalCode]				= @PostalCode
          ,[Country]				= @Country
          ,[EmergencyContactName]	= @EmergencyContactName
          ,[EmergencyContactNumber]	= @EmergencyContactNumber
          ,[MedicalNotes]			= @MedicalNotes
          ,[ModifiedBy]				= @ModifiedBy
          ,[DateModified]			= @DateModified

     WHERE [PatientID]				= @PatientID
END
GO
