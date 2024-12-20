/****** Object:  Table [dbo].[AlertDetails]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AlertDetails](
	[AlertDetailID] [int] NOT NULL,
	[AlertID] [int] NOT NULL,
	[ItemID] [int] NOT NULL,
	[Notes] [varchar](255) NULL,
 CONSTRAINT [PK_AlertDetailID] PRIMARY KEY CLUSTERED 
(
	[AlertDetailID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AlertDetails]  WITH CHECK ADD  CONSTRAINT [FK_AlertDetails_AlertID_Alerts_AlertID] FOREIGN KEY([AlertID])
REFERENCES [dbo].[Alerts] ([AlertID])
GO
ALTER TABLE [dbo].[AlertDetails] CHECK CONSTRAINT [FK_AlertDetails_AlertID_Alerts_AlertID]
GO
ALTER TABLE [dbo].[AlertDetails]  WITH CHECK ADD  CONSTRAINT [FK_AlertDetails_ItemID_InventoryItem_ItemID] FOREIGN KEY([ItemID])
REFERENCES [dbo].[InventoryItem] ([ItemID])
GO
ALTER TABLE [dbo].[AlertDetails] CHECK CONSTRAINT [FK_AlertDetails_ItemID_InventoryItem_ItemID]
GO
