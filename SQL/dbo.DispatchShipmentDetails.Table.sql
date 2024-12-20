/****** Object:  Table [dbo].[DispatchShipmentDetails]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DispatchShipmentDetails](
	[DispatchShipmentDetailID] [int] IDENTITY(1,1) NOT NULL,
	[DispatchShipmentID] [int] NOT NULL,
	[DispatchOrderDetailID] [int] NOT NULL,
	[QuantityShipped] [int] NOT NULL,
	[BatchNumber] [varchar](50) NULL,
	[SerialNumber] [varchar](50) NULL,
	[Notes] [nvarchar](255) NULL,
	[IsActive] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[DateCreated] [datetime2](7) NOT NULL,
	[DateModified] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_DispatchShipmentDetails] PRIMARY KEY CLUSTERED 
(
	[DispatchShipmentDetailID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DispatchShipmentDetails] ADD  CONSTRAINT [DF_DispatchShipmentDetails_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[DispatchShipmentDetails] ADD  CONSTRAINT [DF_DispatchShipmentDetails_CreatedBy]  DEFAULT ((1)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[DispatchShipmentDetails] ADD  CONSTRAINT [DF_DispatchShipmentDetails_ModifiedBy]  DEFAULT ((1)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[DispatchShipmentDetails] ADD  CONSTRAINT [DF_DispatchShipmentDetails_DateCreated]  DEFAULT ((sysdatetimeoffset() AT TIME ZONE 'Eastern Standard Time')) FOR [DateCreated]
GO
ALTER TABLE [dbo].[DispatchShipmentDetails] ADD  CONSTRAINT [DF_DispatchShipmentDetails_DateModified]  DEFAULT ((sysdatetimeoffset() AT TIME ZONE 'Eastern Standard Time')) FOR [DateModified]
GO
ALTER TABLE [dbo].[DispatchShipmentDetails]  WITH CHECK ADD  CONSTRAINT [FK_DispatchShipmentDetails_CreatedBy_Users_UserID] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[DispatchShipmentDetails] CHECK CONSTRAINT [FK_DispatchShipmentDetails_CreatedBy_Users_UserID]
GO
ALTER TABLE [dbo].[DispatchShipmentDetails]  WITH CHECK ADD  CONSTRAINT [FK_DispatchShipmentDetails_DispatchShipmentID_DispatchShipment_DispatchShipmentID] FOREIGN KEY([DispatchShipmentID])
REFERENCES [dbo].[DispatchShipment] ([DispatchShipmentID])
GO
ALTER TABLE [dbo].[DispatchShipmentDetails] CHECK CONSTRAINT [FK_DispatchShipmentDetails_DispatchShipmentID_DispatchShipment_DispatchShipmentID]
GO
ALTER TABLE [dbo].[DispatchShipmentDetails]  WITH CHECK ADD  CONSTRAINT [FK_DispatchShipmentDetails_ModifiedBy_Users_UserID] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[DispatchShipmentDetails] CHECK CONSTRAINT [FK_DispatchShipmentDetails_ModifiedBy_Users_UserID]
GO
