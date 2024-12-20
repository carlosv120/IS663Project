/****** Object:  StoredProcedure [dbo].[Users_Register]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Carlos Vanegas
-- Create Date: 2024-12-03
-- Description: Registers a new user.
-- =============================================

CREATE PROCEDURE [dbo].[Users_Register]
										@Username NVARCHAR(50)
									   ,@PasswordHash NVARCHAR(155)
									   ,@FirstName NVARCHAR(50)
									   ,@LastName NVARCHAR(50)
									   ,@Email NVARCHAR(50)
									   ,@Role NVARCHAR(25)
									   ,@CreatedBy INT
									   ,@ModifiedBy INT
									   ,@UserID INT OUTPUT
AS
/*
    Example Call:
    DECLARE @UserID INT

    EXECUTE [dbo].[Users_Register]
									  @Username = 'newuser'
									 ,@PasswordHash = 'hashedpassword'
									 ,@FirstName = 'John'
									 ,@LastName = 'Doe'
									 ,@Email = 'john.doe@example.com'
									 ,@Role = 'Admin'
									 ,@CreatedBy = 1
									 ,@ModifiedBy = 1
									 ,@UserID = @UserID OUTPUT

    SELECT @UserID
*/
BEGIN
    INSERT INTO [dbo].[Users] (
         [Username]
        ,[PasswordHash]
        ,[FirstName]
        ,[LastName]
        ,[Email]
        ,[Role]
        ,[CreatedBy]
        ,[ModifiedBy]
    )
    VALUES (
         @Username
        ,@PasswordHash
        ,@FirstName
        ,@LastName
        ,@Email
        ,@Role
        ,@CreatedBy
        ,@ModifiedBy
    );

    SET @UserID = SCOPE_IDENTITY()
END
GO
