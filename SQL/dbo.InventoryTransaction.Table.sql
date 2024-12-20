/****** Object:  Table [dbo].[InventoryTransaction]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InventoryTransaction](
	[TransactionID] [int] IDENTITY(1,1) NOT NULL,
	[StatusID] [int] NOT NULL,
	[IsRequest] [bit] NOT NULL,
	[RequestID] [int] NULL,
	[Notes] [varchar](255) NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[DateCreated] [datetime2](7) NOT NULL,
	[DateModified] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_InventoryTransaction] PRIMARY KEY CLUSTERED 
(
	[TransactionID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[InventoryTransaction] ADD  CONSTRAINT [DF_InventoryTransaction_StatusID]  DEFAULT ((1)) FOR [StatusID]
GO
ALTER TABLE [dbo].[InventoryTransaction] ADD  CONSTRAINT [DF__Inventory__IsReq__32B6742D]  DEFAULT ((0)) FOR [IsRequest]
GO
ALTER TABLE [dbo].[InventoryTransaction] ADD  CONSTRAINT [DF_InventoryTransaction_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[InventoryTransaction] ADD  CONSTRAINT [DF_InventoryTransaction_CreatedBy]  DEFAULT ((1)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[InventoryTransaction] ADD  CONSTRAINT [DF_InventoryTransaction_ModifiedBy]  DEFAULT ((1)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[InventoryTransaction] ADD  CONSTRAINT [DF_InventoryTransaction_DateCreated]  DEFAULT ((sysdatetimeoffset() AT TIME ZONE 'Eastern Standard Time')) FOR [DateCreated]
GO
ALTER TABLE [dbo].[InventoryTransaction] ADD  CONSTRAINT [DF_InventoryTransaction_DateModified]  DEFAULT ((sysdatetimeoffset() AT TIME ZONE 'Eastern Standard Time')) FOR [DateModified]
GO
ALTER TABLE [dbo].[InventoryTransaction]  WITH CHECK ADD  CONSTRAINT [FK_InventoryTransaction_CreatedBy_Users_UserID] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[InventoryTransaction] CHECK CONSTRAINT [FK_InventoryTransaction_CreatedBy_Users_UserID]
GO
ALTER TABLE [dbo].[InventoryTransaction]  WITH CHECK ADD  CONSTRAINT [FK_InventoryTransaction_ModifiedBy_Users_UserID] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[InventoryTransaction] CHECK CONSTRAINT [FK_InventoryTransaction_ModifiedBy_Users_UserID]
GO
ALTER TABLE [dbo].[InventoryTransaction]  WITH CHECK ADD  CONSTRAINT [FK_InventoryTransaction_RequestID_Request_RequestID] FOREIGN KEY([RequestID])
REFERENCES [dbo].[Request] ([RequestID])
GO
ALTER TABLE [dbo].[InventoryTransaction] CHECK CONSTRAINT [FK_InventoryTransaction_RequestID_Request_RequestID]
GO
ALTER TABLE [dbo].[InventoryTransaction]  WITH CHECK ADD  CONSTRAINT [FK_InventoryTransaction_StatusID_Status_StatusID] FOREIGN KEY([StatusID])
REFERENCES [dbo].[Status] ([StatusID])
GO
ALTER TABLE [dbo].[InventoryTransaction] CHECK CONSTRAINT [FK_InventoryTransaction_StatusID_Status_StatusID]
GO
