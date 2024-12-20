/****** Object:  StoredProcedure [dbo].[DispatchReceiver_Update]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: 
-- Create Date: 2024-11-24
-- Description: Updates an existing dispatch receiver.
-- =============================================

CREATE PROC [dbo].[DispatchReceiver_Update]
											@ReceiverID			INT
										   ,@ReceiverName		NVARCHAR(50)
										   ,@CompanyName		NVARCHAR(50)
										   ,@ContactNumber		NVARCHAR(20)
										   ,@Email				NVARCHAR(50)
										   ,@Address			NVARCHAR(50)
										   ,@City				NVARCHAR(50)
										   ,@State				NVARCHAR(50)
										   ,@PostalCode			NVARCHAR(20)
										   ,@Country			NVARCHAR(50)
										   ,@ModifiedBy			INT
AS
/*
    Example Call:

    DECLARE    @ReceiverID			INT				= 1
			  ,@ReceiverName		NVARCHAR(50)	= 'Updated Receiver'
			  ,@CompanyName			NVARCHAR(50)	= 'Updated Company'
			  ,@ContactNumber		NVARCHAR(20)	= '987-654-3210'
			  ,@Email				NVARCHAR(50)	= 'updated@example.com'
			  ,@Address				NVARCHAR(50)	= '456 Elm St'
			  ,@City				NVARCHAR(50)	= 'Shelbyville'
			  ,@State				NVARCHAR(50)	= 'IN'
			  ,@PostalCode			NVARCHAR(20)	= '46074'
			  ,@Country				NVARCHAR(50)	= 'USA'
			  ,@ModifiedBy			INT				= 1

    EXECUTE [dbo].[DispatchReceiver_Update]
											@ReceiverID
										   ,@ReceiverName
										   ,@CompanyName
										   ,@ContactNumber
										   ,@Email
										   ,@Address
										   ,@City
										   ,@State
										   ,@PostalCode
										   ,@Country
										   ,@ModifiedBy
*/

BEGIN
    DECLARE @DateModified DATETIME2 = SYSDATETIMEOFFSET() AT TIME ZONE 'UTC' AT TIME ZONE 'Eastern Standard Time'

    UPDATE [dbo].[DispatchReceiver]
       SET [ReceiverName]		= @ReceiverName
          ,[CompanyName]		= @CompanyName
          ,[ContactNumber]		= @ContactNumber
          ,[Email]				= @Email
          ,[Address]			= @Address
          ,[City]				= @City
          ,[State]				= @State
          ,[PostalCode]			= @PostalCode
          ,[Country]			= @Country
          ,[ModifiedBy]			= @ModifiedBy
          ,[DateModified]		= @DateModified

     WHERE [ReceiverID]			= @ReceiverID
END
GO
