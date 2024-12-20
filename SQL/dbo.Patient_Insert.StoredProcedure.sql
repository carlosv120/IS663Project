/****** Object:  StoredProcedure [dbo].[Patient_Insert]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: 
-- Create Date: 2024-11-23
-- Description: Inserts a new patient record.
-- =============================================

CREATE PROC [dbo].[Patient_Insert]
									 @FirstName				NVARCHAR(50)
									,@LastName				NVARCHAR(50)
									,@DateOfBirth			DATE
									,@ContactNumber			NVARCHAR(20)
									,@Email					NVARCHAR(100)
									,@Address				NVARCHAR(255)
									,@City					NVARCHAR(50)
									,@State					NVARCHAR(50)
									,@PostalCode			NVARCHAR(20)
									,@Country				NVARCHAR(50)
									,@EmergencyContactName	NVARCHAR(100)
									,@EmergencyContactNumber NVARCHAR(20)
									,@MedicalNotes		    NVARCHAR(255)
									,@CreatedBy				INT
									,@PatientID				INT				OUTPUT
AS
/*
    Example Call:

    DECLARE    @PatientID				INT				=  1
			  ,@FirstName				NVARCHAR(50)	= 'Rob'
			  ,@LastName				NVARCHAR(50)	= 'Doe'
			  ,@DateOfBirth				DATE			= '1985-07-15'
			  ,@ContactNumber			NVARCHAR(20)	= '123-456-7890'
			  ,@Email					NVARCHAR(100)	= 'john.doe@example.com'
			  ,@Address					NVARCHAR(255)	= '123 Main St'
			  ,@City					NVARCHAR(50)	= 'Springfield'
			  ,@State					NVARCHAR(50)	= 'IL'
			  ,@PostalCode				NVARCHAR(20)	= '62704'
			  ,@Country					NVARCHAR(50)	= 'USA'
			  ,@EmergencyContactName	NVARCHAR(100)	= 'Jane Doe'
			  ,@EmergencyContactNumber	NVARCHAR(20)	= '987-654-3210'
			  ,@MedicalNotes			NVARCHAR(255)	= 'Allergic to penicillin'
			  ,@CreatedBy				INT				= 1

    EXECUTE [dbo].[Patient_Insert]
									 @FirstName
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
									,@CreatedBy
									,@PatientID					OUTPUT
    SELECT *
    FROM [dbo].[Patient]

*/

BEGIN
    INSERT INTO [dbo].[Patient] (	 [FirstName]
									,[LastName]
									,[DateOfBirth]
									,[ContactNumber]
									,[Email]
									,[Address]
									,[City]
									,[State]
									,[PostalCode]
									,[Country]
									,[EmergencyContactName]
									,[EmergencyContactNumber]
									,[MedicalNotes]
									,[CreatedBy]
									,[ModifiedBy] 
								)
    VALUES (	 @FirstName
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
				,@CreatedBy
				,@CreatedBy )

	SET @PatientID = SCOPE_IDENTITY()
	--SELECT SCOPE_IDENTITY() AS PatientID


END
GO
