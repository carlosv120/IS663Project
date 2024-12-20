/****** Object:  Table [dbo].[Alerts]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Alerts](
	[AlertID] [int] NOT NULL,
	[AlertTypeID] [int] NOT NULL,
	[IsResolved] [bit] NOT NULL,
	[Message] [varchar](255) NULL,
	[UserNotified] [int] NOT NULL,
	[NotificationSent] [bit] NOT NULL,
	[CreatedBy] [int] NULL,
	[ModifiedBy] [int] NULL,
	[DateCreated] [datetime2](7) NOT NULL,
	[DateModified] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_AlertID] PRIMARY KEY CLUSTERED 
(
	[AlertID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Alerts] ADD  CONSTRAINT [DF__Alerts__IsResolv__7834CCDD]  DEFAULT ((0)) FOR [IsResolved]
GO
ALTER TABLE [dbo].[Alerts] ADD  CONSTRAINT [DF__Alerts__Notifica__7928F116]  DEFAULT ((0)) FOR [NotificationSent]
GO
ALTER TABLE [dbo].[Alerts] ADD  CONSTRAINT [DF__Alerts__CreatedB__7C055DC1]  DEFAULT ((1)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[Alerts] ADD  CONSTRAINT [DF__Alerts__Modified__7CF981FA]  DEFAULT ((1)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[Alerts] ADD  CONSTRAINT [DF__Alerts__DateCrea__7A1D154F]  DEFAULT ((sysdatetimeoffset() AT TIME ZONE 'Eastern Standard Time')) FOR [DateCreated]
GO
ALTER TABLE [dbo].[Alerts] ADD  CONSTRAINT [DF__Alerts__DateModi__7B113988]  DEFAULT ((sysdatetimeoffset() AT TIME ZONE 'Eastern Standard Time')) FOR [DateModified]
GO
ALTER TABLE [dbo].[Alerts]  WITH CHECK ADD  CONSTRAINT [FK_Alerts_AlertID_AlertType_AlertTypeID] FOREIGN KEY([AlertTypeID])
REFERENCES [dbo].[AlertType] ([AlertTypeID])
GO
ALTER TABLE [dbo].[Alerts] CHECK CONSTRAINT [FK_Alerts_AlertID_AlertType_AlertTypeID]
GO
ALTER TABLE [dbo].[Alerts]  WITH CHECK ADD  CONSTRAINT [FK_Alerts_CreatedBy_Users_UserID] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[Alerts] CHECK CONSTRAINT [FK_Alerts_CreatedBy_Users_UserID]
GO
ALTER TABLE [dbo].[Alerts]  WITH CHECK ADD  CONSTRAINT [FK_Alerts_ModifiedBy_Users_UserID] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[Alerts] CHECK CONSTRAINT [FK_Alerts_ModifiedBy_Users_UserID]
GO
ALTER TABLE [dbo].[Alerts]  WITH CHECK ADD  CONSTRAINT [FK_Alerts_NotificationSent_Users_UserID] FOREIGN KEY([UserNotified])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[Alerts] CHECK CONSTRAINT [FK_Alerts_NotificationSent_Users_UserID]
GO
