/****** Object:  Table [dbo].[IncomingShipment]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IncomingShipment](
	[IncomingShipmentID] [int] IDENTITY(1,1) NOT NULL,
	[RequestID] [int] NULL,
	[TransactionID] [int] NOT NULL,
	[Notes] [varchar](255) NULL,
	[IsActive] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[DateCreated] [datetime2](7) NOT NULL,
	[DateModified] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_IncomingShipment] PRIMARY KEY CLUSTERED 
(
	[IncomingShipmentID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_RequestID_TransactionID] UNIQUE NONCLUSTERED 
(
	[RequestID] ASC,
	[TransactionID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[IncomingShipment] ADD  CONSTRAINT [DF_IncomingShipment_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[IncomingShipment] ADD  CONSTRAINT [DF_IncomingShipment_CreatedBy]  DEFAULT ((1)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[IncomingShipment] ADD  CONSTRAINT [DF_IncomingShipment_ModifiedBy]  DEFAULT ((1)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[IncomingShipment] ADD  CONSTRAINT [DF_IncomingShipment_DateCreated]  DEFAULT ((sysdatetimeoffset() AT TIME ZONE 'Eastern Standard Time')) FOR [DateCreated]
GO
ALTER TABLE [dbo].[IncomingShipment] ADD  CONSTRAINT [DF_IncomingShipment_DateModified]  DEFAULT ((sysdatetimeoffset() AT TIME ZONE 'Eastern Standard Time')) FOR [DateModified]
GO
ALTER TABLE [dbo].[IncomingShipment]  WITH CHECK ADD  CONSTRAINT [FK_IncomingShipment_CreatedBy_Users_UserID] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[IncomingShipment] CHECK CONSTRAINT [FK_IncomingShipment_CreatedBy_Users_UserID]
GO
ALTER TABLE [dbo].[IncomingShipment]  WITH CHECK ADD  CONSTRAINT [FK_IncomingShipment_ModifiedBy_Users_UserID] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[IncomingShipment] CHECK CONSTRAINT [FK_IncomingShipment_ModifiedBy_Users_UserID]
GO
ALTER TABLE [dbo].[IncomingShipment]  WITH CHECK ADD  CONSTRAINT [FK_IncomingShipment_RequestID_Request_RequestID] FOREIGN KEY([RequestID])
REFERENCES [dbo].[Request] ([RequestID])
GO
ALTER TABLE [dbo].[IncomingShipment] CHECK CONSTRAINT [FK_IncomingShipment_RequestID_Request_RequestID]
GO
ALTER TABLE [dbo].[IncomingShipment]  WITH CHECK ADD  CONSTRAINT [FK_IncomingShipment_TransactionID_InventoryTransaction_TransactionID] FOREIGN KEY([TransactionID])
REFERENCES [dbo].[InventoryTransaction] ([TransactionID])
GO
ALTER TABLE [dbo].[IncomingShipment] CHECK CONSTRAINT [FK_IncomingShipment_TransactionID_InventoryTransaction_TransactionID]
GO
