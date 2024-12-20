/****** Object:  Table [dbo].[InventoryItemDetails]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InventoryItemDetails](
	[ItemDetailID] [int] IDENTITY(1,1) NOT NULL,
	[ItemID] [int] NOT NULL,
	[InStoreLocationID] [int] NOT NULL,
	[StatusID] [int] NOT NULL,
	[SupplierID] [int] NOT NULL,
	[Manufacturer] [varchar](50) NOT NULL,
	[Size] [nvarchar](50) NULL,
	[Color] [nvarchar](50) NULL,
	[Capacity] [nvarchar](50) NULL,
	[Gauge] [nvarchar](50) NULL,
	[Material] [nvarchar](50) NULL,
	[QuantityInStock] [int] NOT NULL,
	[UnitOfMeasurement] [varchar](20) NOT NULL,
	[ReorderLevel] [int] NOT NULL,
	[CostPerUnit] [decimal](10, 2) NULL,
	[SellingPricePerUnit] [decimal](10, 2) NULL,
	[ExpirationDate] [datetime2](7) NULL,
	[Barcode] [varchar](100) NULL,
	[Notes] [varchar](50) NULL,
	[IsActive] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[DateCreated] [datetime2](7) NOT NULL,
	[DateModified] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_InventoryItemDetails] PRIMARY KEY CLUSTERED 
(
	[ItemDetailID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[InventoryItemDetails] ADD  CONSTRAINT [DF_InventoryItemsDetails_StatusID]  DEFAULT ((1)) FOR [StatusID]
GO
ALTER TABLE [dbo].[InventoryItemDetails] ADD  CONSTRAINT [DF__Inventory__Quant__6C23FBB3]  DEFAULT ((0)) FOR [QuantityInStock]
GO
ALTER TABLE [dbo].[InventoryItemDetails] ADD  CONSTRAINT [DF__Inventory__UnitO__6D181FEC]  DEFAULT ('Units') FOR [UnitOfMeasurement]
GO
ALTER TABLE [dbo].[InventoryItemDetails] ADD  CONSTRAINT [DF_InventoryItemDetails_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[InventoryItemDetails] ADD  CONSTRAINT [DF__Inventory__DateC__6F00685E]  DEFAULT ((sysdatetimeoffset() AT TIME ZONE 'Eastern Standard Time')) FOR [DateCreated]
GO
ALTER TABLE [dbo].[InventoryItemDetails] ADD  CONSTRAINT [DF__Inventory__DateM__6FF48C97]  DEFAULT ((sysdatetimeoffset() AT TIME ZONE 'Eastern Standard Time')) FOR [DateModified]
GO
ALTER TABLE [dbo].[InventoryItemDetails]  WITH CHECK ADD  CONSTRAINT [FK_InventoryItemDetails_CreatedBy_Users_UserID] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[InventoryItemDetails] CHECK CONSTRAINT [FK_InventoryItemDetails_CreatedBy_Users_UserID]
GO
ALTER TABLE [dbo].[InventoryItemDetails]  WITH CHECK ADD  CONSTRAINT [FK_InventoryItemDetails_InStoreLocationID_InStoreLocation_LocationID] FOREIGN KEY([InStoreLocationID])
REFERENCES [dbo].[InStoreLocation] ([LocationID])
GO
ALTER TABLE [dbo].[InventoryItemDetails] CHECK CONSTRAINT [FK_InventoryItemDetails_InStoreLocationID_InStoreLocation_LocationID]
GO
ALTER TABLE [dbo].[InventoryItemDetails]  WITH CHECK ADD  CONSTRAINT [FK_InventoryItemDetails_ItemID_InventoryItem_ItemID] FOREIGN KEY([ItemID])
REFERENCES [dbo].[InventoryItem] ([ItemID])
GO
ALTER TABLE [dbo].[InventoryItemDetails] CHECK CONSTRAINT [FK_InventoryItemDetails_ItemID_InventoryItem_ItemID]
GO
ALTER TABLE [dbo].[InventoryItemDetails]  WITH CHECK ADD  CONSTRAINT [FK_InventoryItemDetails_ModifiedBy_Users_UserID] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[InventoryItemDetails] CHECK CONSTRAINT [FK_InventoryItemDetails_ModifiedBy_Users_UserID]
GO
ALTER TABLE [dbo].[InventoryItemDetails]  WITH CHECK ADD  CONSTRAINT [FK_InventoryItemDetails_StatusID_Status_StatusID] FOREIGN KEY([StatusID])
REFERENCES [dbo].[Status] ([StatusID])
GO
ALTER TABLE [dbo].[InventoryItemDetails] CHECK CONSTRAINT [FK_InventoryItemDetails_StatusID_Status_StatusID]
GO
ALTER TABLE [dbo].[InventoryItemDetails]  WITH CHECK ADD  CONSTRAINT [FK_InventoryItemDetails_SupplierID_Supplier_SupplierID] FOREIGN KEY([SupplierID])
REFERENCES [dbo].[Supplier] ([SupplierID])
GO
ALTER TABLE [dbo].[InventoryItemDetails] CHECK CONSTRAINT [FK_InventoryItemDetails_SupplierID_Supplier_SupplierID]
GO
