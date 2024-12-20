/****** Object:  Table [dbo].[DispatchShipment]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DispatchShipment](
	[DispatchShipmentID] [int] IDENTITY(1,1) NOT NULL,
	[DispatchOrderID] [int] NOT NULL,
	[StatusID] [int] NOT NULL,
	[DispatchDate] [datetime2](7) NOT NULL,
	[ExpectedDeliveryDate] [datetime2](7) NOT NULL,
	[ActualDeliveryDate] [datetime2](7) NULL,
	[TrackingNumber] [varchar](50) NULL,
	[Notes] [varchar](255) NULL,
	[IsActive] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[DateCreated] [datetime2](7) NOT NULL,
	[DateModified] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_DispatchShipment] PRIMARY KEY CLUSTERED 
(
	[DispatchShipmentID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DispatchShipment] ADD  CONSTRAINT [DF_DispatchShipment_StatusID]  DEFAULT ((1)) FOR [StatusID]
GO
ALTER TABLE [dbo].[DispatchShipment] ADD  CONSTRAINT [DF_DispatchShipment_DispatchDate]  DEFAULT ((sysdatetimeoffset() AT TIME ZONE 'Eastern Standard Time')) FOR [DispatchDate]
GO
ALTER TABLE [dbo].[DispatchShipment] ADD  CONSTRAINT [DF_DispatchShipment_ExpectedDeliveryDate]  DEFAULT ((sysdatetimeoffset() AT TIME ZONE 'Eastern Standard Time')) FOR [ExpectedDeliveryDate]
GO
ALTER TABLE [dbo].[DispatchShipment] ADD  CONSTRAINT [DF_DispatchShipment_TrackingNumber]  DEFAULT ('NoTrackingNumber') FOR [TrackingNumber]
GO
ALTER TABLE [dbo].[DispatchShipment] ADD  CONSTRAINT [DF_DispatchShipment_Notes]  DEFAULT ('NoNotes') FOR [Notes]
GO
ALTER TABLE [dbo].[DispatchShipment] ADD  CONSTRAINT [DF_DispatchShipment_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[DispatchShipment] ADD  CONSTRAINT [DF_DispatchShipment_CreatedBy]  DEFAULT ((1)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[DispatchShipment] ADD  CONSTRAINT [DF_DispatchShipment_ModifiedBy]  DEFAULT ((1)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[DispatchShipment] ADD  CONSTRAINT [DF_DispatchShipment_DateCreated]  DEFAULT ((sysdatetimeoffset() AT TIME ZONE 'Eastern Standard Time')) FOR [DateCreated]
GO
ALTER TABLE [dbo].[DispatchShipment] ADD  CONSTRAINT [DF_DispatchShipment_DateModified]  DEFAULT ((sysdatetimeoffset() AT TIME ZONE 'Eastern Standard Time')) FOR [DateModified]
GO
ALTER TABLE [dbo].[DispatchShipment]  WITH CHECK ADD  CONSTRAINT [FK_DispatchShipment_CreatedBy_Users_UserID] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[DispatchShipment] CHECK CONSTRAINT [FK_DispatchShipment_CreatedBy_Users_UserID]
GO
ALTER TABLE [dbo].[DispatchShipment]  WITH CHECK ADD  CONSTRAINT [FK_DispatchShipment_DispatchOrderID_DispatchOrder_DispatchOrderID] FOREIGN KEY([DispatchOrderID])
REFERENCES [dbo].[DispatchOrder] ([DispatchOrderID])
GO
ALTER TABLE [dbo].[DispatchShipment] CHECK CONSTRAINT [FK_DispatchShipment_DispatchOrderID_DispatchOrder_DispatchOrderID]
GO
ALTER TABLE [dbo].[DispatchShipment]  WITH CHECK ADD  CONSTRAINT [FK_DispatchShipment_ModifiedBy_Users_UserID] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[DispatchShipment] CHECK CONSTRAINT [FK_DispatchShipment_ModifiedBy_Users_UserID]
GO
