/****** Object:  Table [dbo].[InventoryTransactionDetails]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InventoryTransactionDetails](
	[TransactionDetailID] [int] IDENTITY(1,1) NOT NULL,
	[TransactionID] [int] NOT NULL,
	[RequestDetailID] [nchar](10) NULL,
	[SupplierID] [int] NULL,
	[OrderNumber] [nvarchar](50) NOT NULL,
	[Quantity] [int] NOT NULL,
	[TrackingNumber] [nvarchar](50) NULL,
	[ExpectedArrivalDate] [datetime2](7) NULL,
	[Notes] [nvarchar](255) NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[DateCreated] [datetime2](7) NOT NULL,
	[DateModified] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_InventoryTransactionDetails] PRIMARY KEY CLUSTERED 
(
	[TransactionDetailID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[InventoryTransactionDetails] ADD  CONSTRAINT [DF_InventoryTransactionDetails_TransactionID]  DEFAULT ((1)) FOR [TransactionID]
GO
ALTER TABLE [dbo].[InventoryTransactionDetails] ADD  CONSTRAINT [DF_InventoryTransactionDetails_Quantity]  DEFAULT ((0)) FOR [Quantity]
GO
ALTER TABLE [dbo].[InventoryTransactionDetails] ADD  CONSTRAINT [DF_InventoryTransactionDetails_ExpectedArrivalDate]  DEFAULT ((sysdatetimeoffset() AT TIME ZONE 'Eastern Standard Time')) FOR [ExpectedArrivalDate]
GO
ALTER TABLE [dbo].[InventoryTransactionDetails] ADD  CONSTRAINT [DF_InventoryTransactionDetails_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[InventoryTransactionDetails] ADD  CONSTRAINT [DF__Inventory__Creat__672A3C6C]  DEFAULT ((1)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[InventoryTransactionDetails] ADD  CONSTRAINT [DF__Inventory__Modif__681E60A5]  DEFAULT ((1)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[InventoryTransactionDetails] ADD  CONSTRAINT [DF__Inventory__DateC__691284DE]  DEFAULT (sysutcdatetime()) FOR [DateCreated]
GO
ALTER TABLE [dbo].[InventoryTransactionDetails] ADD  CONSTRAINT [DF__Inventory__DateM__6A06A917]  DEFAULT (sysutcdatetime()) FOR [DateModified]
GO
ALTER TABLE [dbo].[InventoryTransactionDetails]  WITH CHECK ADD  CONSTRAINT [FK_InventoryTransactionDetails_CreatedBy_Users_UserID] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[InventoryTransactionDetails] CHECK CONSTRAINT [FK_InventoryTransactionDetails_CreatedBy_Users_UserID]
GO
ALTER TABLE [dbo].[InventoryTransactionDetails]  WITH CHECK ADD  CONSTRAINT [FK_InventoryTransactionDetails_InventoryTransaction] FOREIGN KEY([TransactionID])
REFERENCES [dbo].[InventoryTransaction] ([TransactionID])
GO
ALTER TABLE [dbo].[InventoryTransactionDetails] CHECK CONSTRAINT [FK_InventoryTransactionDetails_InventoryTransaction]
GO
ALTER TABLE [dbo].[InventoryTransactionDetails]  WITH CHECK ADD  CONSTRAINT [FK_InventoryTransactionDetails_ModifiedBy_Users_UserID] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[InventoryTransactionDetails] CHECK CONSTRAINT [FK_InventoryTransactionDetails_ModifiedBy_Users_UserID]
GO
ALTER TABLE [dbo].[InventoryTransactionDetails]  WITH CHECK ADD  CONSTRAINT [FK_InventoryTransactionDetails_SupplierID_Supplier_SupplierID] FOREIGN KEY([SupplierID])
REFERENCES [dbo].[Supplier] ([SupplierID])
GO
ALTER TABLE [dbo].[InventoryTransactionDetails] CHECK CONSTRAINT [FK_InventoryTransactionDetails_SupplierID_Supplier_SupplierID]
GO
