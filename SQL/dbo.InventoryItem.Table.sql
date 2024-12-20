/****** Object:  Table [dbo].[InventoryItem]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InventoryItem](
	[ItemID] [int] IDENTITY(1,1) NOT NULL,
	[StatusID] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [varchar](100) NULL,
	[Category] [varchar](25) NOT NULL,
	[Notes] [varchar](50) NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[DateCreated] [datetime2](7) NOT NULL,
	[DateModified] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_InventoryItem] PRIMARY KEY CLUSTERED 
(
	[ItemID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[InventoryItem] ADD  CONSTRAINT [DF_InventoryItems_Status]  DEFAULT ((1)) FOR [StatusID]
GO
ALTER TABLE [dbo].[InventoryItem] ADD  CONSTRAINT [DF_InventoryItems_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[InventoryItem] ADD  CONSTRAINT [DF_InventoryItems_DateAdded]  DEFAULT ((1)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[InventoryItem] ADD  CONSTRAINT [DF_InventoryItems_LastUpdated]  DEFAULT ((1)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[InventoryItem] ADD  CONSTRAINT [DF_InventoryItems_DateCreated]  DEFAULT ((sysdatetimeoffset() AT TIME ZONE 'Eastern Standard Time')) FOR [DateCreated]
GO
ALTER TABLE [dbo].[InventoryItem] ADD  CONSTRAINT [DF_InventoryItems_DateModified]  DEFAULT ((sysdatetimeoffset() AT TIME ZONE 'Eastern Standard Time')) FOR [DateModified]
GO
ALTER TABLE [dbo].[InventoryItem]  WITH CHECK ADD  CONSTRAINT [FK_InventoryItems_CreatedBy_Users_UserID] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[InventoryItem] CHECK CONSTRAINT [FK_InventoryItems_CreatedBy_Users_UserID]
GO
ALTER TABLE [dbo].[InventoryItem]  WITH CHECK ADD  CONSTRAINT [FK_InventoryItems_ModifiedBy_Users_UserID] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[InventoryItem] CHECK CONSTRAINT [FK_InventoryItems_ModifiedBy_Users_UserID]
GO
ALTER TABLE [dbo].[InventoryItem]  WITH CHECK ADD  CONSTRAINT [FK_InventoryItems_StatusID_Status_StatusID] FOREIGN KEY([StatusID])
REFERENCES [dbo].[Status] ([StatusID])
GO
ALTER TABLE [dbo].[InventoryItem] CHECK CONSTRAINT [FK_InventoryItems_StatusID_Status_StatusID]
GO
