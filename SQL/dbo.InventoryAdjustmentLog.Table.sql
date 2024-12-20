/****** Object:  Table [dbo].[InventoryAdjustmentLog]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InventoryAdjustmentLog](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[ItemID] [int] NOT NULL,
	[ChangeType] [varchar](50) NOT NULL,
	[Details] [varchar](255) NULL,
	[CreatedBy] [int] NULL,
	[ModifiedBy] [int] NULL,
	[DateCreated] [datetime2](7) NOT NULL,
	[DateModified] [datetime2](7) NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_InventoryAuditLog] PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[InventoryAdjustmentLog] ADD  CONSTRAINT [DF_InventoryAuditLog_ItemID]  DEFAULT ((1)) FOR [ItemID]
GO
ALTER TABLE [dbo].[InventoryAdjustmentLog] ADD  CONSTRAINT [DF_InventoryAuditLog_ChangeType]  DEFAULT ('NoChangeType') FOR [ChangeType]
GO
ALTER TABLE [dbo].[InventoryAdjustmentLog] ADD  CONSTRAINT [DF_InventoryAuditLog_Details]  DEFAULT ('NoDetails') FOR [Details]
GO
ALTER TABLE [dbo].[InventoryAdjustmentLog] ADD  CONSTRAINT [DF_InventoryAuditLog_CreatedBy]  DEFAULT ((1)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[InventoryAdjustmentLog] ADD  CONSTRAINT [DF_InventoryAuditLog_ModifiedBy]  DEFAULT ((1)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[InventoryAdjustmentLog] ADD  CONSTRAINT [DF_InventoryAuditLog_DateCreated]  DEFAULT ((sysdatetimeoffset() AT TIME ZONE 'Eastern Standard Time')) FOR [DateCreated]
GO
ALTER TABLE [dbo].[InventoryAdjustmentLog] ADD  CONSTRAINT [DF_InventoryAuditLog_DateModified]  DEFAULT ((sysdatetimeoffset() AT TIME ZONE 'Eastern Standard Time')) FOR [DateModified]
GO
ALTER TABLE [dbo].[InventoryAdjustmentLog] ADD  CONSTRAINT [DF_InventoryAuditLog_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[InventoryAdjustmentLog]  WITH CHECK ADD  CONSTRAINT [FK_InventoryAuditLog_CreatedBy_Users_UserID] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[InventoryAdjustmentLog] CHECK CONSTRAINT [FK_InventoryAuditLog_CreatedBy_Users_UserID]
GO
ALTER TABLE [dbo].[InventoryAdjustmentLog]  WITH CHECK ADD  CONSTRAINT [FK_InventoryAuditLog_ItemID_InventoryItem_ItemID] FOREIGN KEY([ItemID])
REFERENCES [dbo].[InventoryItem] ([ItemID])
GO
ALTER TABLE [dbo].[InventoryAdjustmentLog] CHECK CONSTRAINT [FK_InventoryAuditLog_ItemID_InventoryItem_ItemID]
GO
ALTER TABLE [dbo].[InventoryAdjustmentLog]  WITH CHECK ADD  CONSTRAINT [FK_InventoryAuditLog_ModifiedBy_Users_UserID] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[InventoryAdjustmentLog] CHECK CONSTRAINT [FK_InventoryAuditLog_ModifiedBy_Users_UserID]
GO
