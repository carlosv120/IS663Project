/****** Object:  StoredProcedure [dbo].[Users_GetByID]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Carlos Vanegas
-- Create Date: 2024-12-03
-- Description: Retrieves user details by UserID.
-- =============================================

CREATE PROCEDURE [dbo].[Users_GetByID]
										@UserID INT
AS
/*
    Example Call:
    DECLARE @UserID INT = 1

    EXECUTE [dbo].[Users_GetByID] @UserID
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
        ,[DateCreated]
        ,[DateModified]
    FROM [dbo].[Users]
    WHERE [UserID] = @UserID
END
GO
