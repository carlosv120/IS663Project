/****** Object:  Table [dbo].[RequestDetails]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RequestDetails](
	[RequestDetailID] [int] IDENTITY(1,1) NOT NULL,
	[RequestID] [int] NOT NULL,
	[ItemID] [int] NOT NULL,
	[ItemDetailID] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[IsCompleted] [bit] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Notes] [varchar](255) NULL,
 CONSTRAINT [PK_RequestDetails] PRIMARY KEY CLUSTERED 
(
	[RequestDetailID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RequestDetails] ADD  CONSTRAINT [DF__RequestDe__IsCom__3CFEF876]  DEFAULT ((0)) FOR [IsCompleted]
GO
ALTER TABLE [dbo].[RequestDetails] ADD  CONSTRAINT [DF_RequestDetails_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[RequestDetails]  WITH CHECK ADD  CONSTRAINT [FK_RequestDetails_ItemDetailID_InventoryItemDetails_ItemDetailID] FOREIGN KEY([ItemDetailID])
REFERENCES [dbo].[InventoryItemDetails] ([ItemDetailID])
GO
ALTER TABLE [dbo].[RequestDetails] CHECK CONSTRAINT [FK_RequestDetails_ItemDetailID_InventoryItemDetails_ItemDetailID]
GO
ALTER TABLE [dbo].[RequestDetails]  WITH CHECK ADD  CONSTRAINT [FK_RequestDetails_ItemID_InventoryItem_ItemID] FOREIGN KEY([ItemID])
REFERENCES [dbo].[InventoryItem] ([ItemID])
GO
ALTER TABLE [dbo].[RequestDetails] CHECK CONSTRAINT [FK_RequestDetails_ItemID_InventoryItem_ItemID]
GO
ALTER TABLE [dbo].[RequestDetails]  WITH CHECK ADD  CONSTRAINT [FK_RequestDetails_RequestID_Request_RequestID] FOREIGN KEY([RequestID])
REFERENCES [dbo].[Request] ([RequestID])
GO
ALTER TABLE [dbo].[RequestDetails] CHECK CONSTRAINT [FK_RequestDetails_RequestID_Request_RequestID]
GO
