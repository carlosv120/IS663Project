/****** Object:  Table [dbo].[IncomingShipmentDetails]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IncomingShipmentDetails](
	[IncomingShipmentDetailID] [int] IDENTITY(1,1) NOT NULL,
	[IncomingShipmentID] [int] NOT NULL,
	[RequestDetailID] [int] NOT NULL,
	[SupplierID] [int] NOT NULL,
	[SupplierInvoiceNumber] [nvarchar](50) NOT NULL,
	[SupplierInvoiceDate] [datetime2](7) NOT NULL,
	[OrderNumber] [nvarchar](50) NOT NULL,
	[TrackingNumber] [nvarchar](50) NOT NULL,
	[ShipmentDate] [datetime2](7) NOT NULL,
	[ArrivalDate] [nvarchar](50) NOT NULL,
	[QuantityReceived] [int] NOT NULL,
	[BatchNumber] [varchar](50) NULL,
	[SerialNumber] [varchar](50) NULL,
	[Notes] [nvarchar](255) NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[DateCreated] [datetime2](7) NOT NULL,
	[DateModified] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_IncomingShipmentDetails] PRIMARY KEY CLUSTERED 
(
	[IncomingShipmentDetailID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_IncomingShipmentDetails_IncomingShipmentID_RequestDetailID] UNIQUE NONCLUSTERED 
(
	[IncomingShipmentID] ASC,
	[RequestDetailID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[IncomingShipmentDetails] ADD  CONSTRAINT [DF_IncomingShipmentDetails_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[IncomingShipmentDetails] ADD  CONSTRAINT [DF__IncomingS__Creat__28F7FFC9]  DEFAULT ((1)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[IncomingShipmentDetails] ADD  CONSTRAINT [DF__IncomingS__Modif__29EC2402]  DEFAULT ((1)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[IncomingShipmentDetails] ADD  CONSTRAINT [DF__IncomingS__DateC__2AE0483B]  DEFAULT ((sysdatetimeoffset() AT TIME ZONE 'Eastern Standard Time')) FOR [DateCreated]
GO
ALTER TABLE [dbo].[IncomingShipmentDetails] ADD  CONSTRAINT [DF__IncomingS__DateM__2BD46C74]  DEFAULT ((sysdatetimeoffset() AT TIME ZONE 'Eastern Standard Time')) FOR [DateModified]
GO
ALTER TABLE [dbo].[IncomingShipmentDetails]  WITH CHECK ADD  CONSTRAINT [FK_IncomingShipmentDetails_SupplierID_Supplier_SupplierID] FOREIGN KEY([SupplierID])
REFERENCES [dbo].[Supplier] ([SupplierID])
GO
ALTER TABLE [dbo].[IncomingShipmentDetails] CHECK CONSTRAINT [FK_IncomingShipmentDetails_SupplierID_Supplier_SupplierID]
GO
