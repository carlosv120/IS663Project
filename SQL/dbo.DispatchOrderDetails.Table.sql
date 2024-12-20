/****** Object:  Table [dbo].[DispatchOrderDetails]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DispatchOrderDetails](
	[DispatchOrderDetailID] [int] IDENTITY(1,1) NOT NULL,
	[DispatchOrderID] [int] NOT NULL,
	[ItemID] [int] NOT NULL,
	[ItemDetailID] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[IsCompleted] [bit] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Notes] [varchar](255) NULL,
 CONSTRAINT [PK_DispatchOrderDetails] PRIMARY KEY CLUSTERED 
(
	[DispatchOrderDetailID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DispatchOrderDetails] ADD  CONSTRAINT [DF__DispatchO__IsCom__75435199]  DEFAULT ((0)) FOR [IsCompleted]
GO
ALTER TABLE [dbo].[DispatchOrderDetails] ADD  CONSTRAINT [DF_DispatchOrderDetails_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[DispatchOrderDetails]  WITH CHECK ADD  CONSTRAINT [FK_DispatchOrderDetails_DispatchOrderID_DispatchOrder_DispatchOrderID] FOREIGN KEY([DispatchOrderID])
REFERENCES [dbo].[DispatchOrder] ([DispatchOrderID])
GO
ALTER TABLE [dbo].[DispatchOrderDetails] CHECK CONSTRAINT [FK_DispatchOrderDetails_DispatchOrderID_DispatchOrder_DispatchOrderID]
GO
ALTER TABLE [dbo].[DispatchOrderDetails]  WITH CHECK ADD  CONSTRAINT [FK_DispatchOrderDetails_ItemDetailID_InventoryItemDetails_ItemDetailID] FOREIGN KEY([ItemDetailID])
REFERENCES [dbo].[InventoryItemDetails] ([ItemDetailID])
GO
ALTER TABLE [dbo].[DispatchOrderDetails] CHECK CONSTRAINT [FK_DispatchOrderDetails_ItemDetailID_InventoryItemDetails_ItemDetailID]
GO
ALTER TABLE [dbo].[DispatchOrderDetails]  WITH CHECK ADD  CONSTRAINT [FK_DispatchOrderDetails_ItemID_InventoryItem_ItemID] FOREIGN KEY([ItemID])
REFERENCES [dbo].[InventoryItem] ([ItemID])
GO
ALTER TABLE [dbo].[DispatchOrderDetails] CHECK CONSTRAINT [FK_DispatchOrderDetails_ItemID_InventoryItem_ItemID]
GO
