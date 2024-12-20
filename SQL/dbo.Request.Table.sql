/****** Object:  Table [dbo].[Request]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Request](
	[RequestID] [int] IDENTITY(1,1) NOT NULL,
	[AlertID] [int] NULL,
	[DateRequested] [datetime2](7) NOT NULL,
	[IsApproved] [bit] NOT NULL,
	[DateApproved] [datetime2](7) NULL,
	[TransactionID] [int] NULL,
	[IsCompleted] [bit] NOT NULL,
	[Notes] [varchar](255) NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[DateCreated] [datetime2](7) NOT NULL,
	[DateModified] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_Requests] PRIMARY KEY CLUSTERED 
(
	[RequestID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Request] ADD  CONSTRAINT [DF__Requests__DateRe__6DB73E6A]  DEFAULT ((sysdatetimeoffset() AT TIME ZONE 'Eastern Standard Time')) FOR [DateRequested]
GO
ALTER TABLE [dbo].[Request] ADD  CONSTRAINT [DF_Requests_IsApproved]  DEFAULT ((0)) FOR [IsApproved]
GO
ALTER TABLE [dbo].[Request] ADD  CONSTRAINT [DF__Requests__IsComp__3DF31CAF]  DEFAULT ((0)) FOR [IsCompleted]
GO
ALTER TABLE [dbo].[Request] ADD  CONSTRAINT [DF_Request_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Request] ADD  CONSTRAINT [DF_Request_DateCreated]  DEFAULT ((sysdatetimeoffset() AT TIME ZONE 'Eastern Standard Time')) FOR [DateCreated]
GO
ALTER TABLE [dbo].[Request] ADD  CONSTRAINT [DF_Request_DateModified]  DEFAULT ((sysdatetimeoffset() AT TIME ZONE 'Eastern Standard Time')) FOR [DateModified]
GO
ALTER TABLE [dbo].[Request]  WITH CHECK ADD  CONSTRAINT [FK_Requests_AlertID_Alerts_Alert_ID] FOREIGN KEY([AlertID])
REFERENCES [dbo].[Alerts] ([AlertID])
GO
ALTER TABLE [dbo].[Request] CHECK CONSTRAINT [FK_Requests_AlertID_Alerts_Alert_ID]
GO
ALTER TABLE [dbo].[Request]  WITH CHECK ADD  CONSTRAINT [FK_Requests_CreatedBy_Users_UserID] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[Request] CHECK CONSTRAINT [FK_Requests_CreatedBy_Users_UserID]
GO
ALTER TABLE [dbo].[Request]  WITH CHECK ADD  CONSTRAINT [FK_Requests_ModifiedBy_Users_UserID] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[Request] CHECK CONSTRAINT [FK_Requests_ModifiedBy_Users_UserID]
GO
ALTER TABLE [dbo].[Request]  WITH CHECK ADD  CONSTRAINT [FK_Requests_TransactionID_InventoryTransaction_TransactionID] FOREIGN KEY([TransactionID])
REFERENCES [dbo].[InventoryTransaction] ([TransactionID])
GO
ALTER TABLE [dbo].[Request] CHECK CONSTRAINT [FK_Requests_TransactionID_InventoryTransaction_TransactionID]
GO
