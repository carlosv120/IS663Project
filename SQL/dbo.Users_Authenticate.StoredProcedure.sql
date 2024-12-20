/****** Object:  StoredProcedure [dbo].[Users_Authenticate]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Carlos Vanegas
-- Create Date: 2024-12-03
-- Description: Authenticates a user by username and password hash.
-- =============================================

CREATE PROCEDURE [dbo].[Users_Authenticate]
											@Username NVARCHAR(50)
										   ,@PasswordHash NVARCHAR(155)
AS
/*
    Example Call:
    DECLARE @Username NVARCHAR(50) = 'Admin'
          ,@PasswordHash NVARCHAR(155) = 'PlaceholderPassword'

    EXECUTE [dbo].[Users_Authenticate] @Username, @PasswordHash
*/
BEGIN
    SELECT 
         [UserID]
        ,[Username]
        ,[FirstName]
        ,[LastName]
        ,[Email]
        ,[Role]
        ,[LastLogin]
        ,[IsActive]
    FROM [dbo].[Users]
    WHERE [Username] = @Username AND [PasswordHash] = @PasswordHash AND [IsActive] = 1
END
GO
