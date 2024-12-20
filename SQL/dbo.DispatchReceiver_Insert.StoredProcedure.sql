/****** Object:  StoredProcedure [dbo].[DispatchReceiver_Insert]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: 
-- Create Date: 2024-11-24
-- Description: Inserts a new dispatch receiver.
-- =============================================

CREATE PROC [dbo].[DispatchReceiver_Insert]
											@ReceiverName		NVARCHAR(50)
										   ,@CompanyName		NVARCHAR(50)
										   ,@ContactNumber		NVARCHAR(20)
										   ,@Email				NVARCHAR(50)
										   ,@Address			NVARCHAR(50)
										   ,@City				NVARCHAR(50)
										   ,@State				NVARCHAR(50)
										   ,@PostalCode			NVARCHAR(20)
										   ,@Country			NVARCHAR(50)
										   ,@CreatedBy			INT
										   ,@ReceiverID			INT				OUTPUT
AS
/*
    Example Call:

    DECLARE    @ReceiverID				INT			 = 1
			  ,@ReceiverName			NVARCHAR(50) = 'John Smith'
			  ,@CompanyName				NVARCHAR(50) = 'Testing Company'
			  ,@ContactNumber			NVARCHAR(20) = '123-456-7890'
			  ,@Email					NVARCHAR(50) = 'john@example.com'
			  ,@Address					NVARCHAR(50) = '123 Main St'
			  ,@City					NVARCHAR(50) = 'Springfield'
			  ,@State					NVARCHAR(50) = 'IL'
			  ,@PostalCode				NVARCHAR(20) = '62704'
			  ,@Country					NVARCHAR(50) = 'USA'
			  ,@CreatedBy				INT			= 1

    EXECUTE [dbo].[DispatchReceiver_Insert]
											@ReceiverName
										   ,@CompanyName
										   ,@ContactNumber
										   ,@Email
										   ,@Address
										   ,@City
										   ,@State
										   ,@PostalCode
										   ,@Country
										   ,@CreatedBy
										   ,@ReceiverID OUTPUT

	SELECT *
    FROM [dbo].[DispatchReceiver]										
*/

BEGIN
    INSERT INTO [dbo].[DispatchReceiver] (    [ReceiverName]
											 ,[CompanyName]
											 ,[ContactNumber]
											 ,[Email]
											 ,[Address]
											 ,[City]
											 ,[State]
											 ,[PostalCode]
											 ,[Country]
											 ,[CreatedBy]
											 ,[ModifiedBy] 
										)
    VALUES (	 @ReceiverName
				,@CompanyName
				,@ContactNumber
				,@Email
				,@Address
				,@City
				,@State
				,@PostalCode
				,@Country
				,@CreatedBy
				,@CreatedBy )

    SET @ReceiverID = SCOPE_IDENTITY()
    --SELECT SCOPE_IDENTITY() AS ReceiverID
END
GO
