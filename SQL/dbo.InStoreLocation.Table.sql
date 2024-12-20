/****** Object:  Table [dbo].[InStoreLocation]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InStoreLocation](
	[LocationID] [int] IDENTITY(1,1) NOT NULL,
	[LocationName] [varchar](100) NOT NULL,
	[Description] [varchar](255) NOT NULL,
	[Zone] [varchar](50) NOT NULL,
	[SubZone] [varchar](50) NULL,
	[Bin] [varchar](50) NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedBy] [int] NULL,
	[ModifiedBy] [int] NULL,
	[DateCreated] [datetime2](7) NOT NULL,
	[DateModified] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_InStoreLocation] PRIMARY KEY CLUSTERED 
(
	[LocationID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_InStoreLocation_Composite] UNIQUE NONCLUSTERED 
(
	[LocationName] ASC,
	[Description] ASC,
	[Zone] ASC,
	[SubZone] ASC,
	[Bin] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[InStoreLocation] ADD  CONSTRAINT [DF_InStoreLocation_LocationName]  DEFAULT ('NoLocationName') FOR [LocationName]
GO
ALTER TABLE [dbo].[InStoreLocation] ADD  CONSTRAINT [DF_InStoreLocation_Description]  DEFAULT ('NoDescription') FOR [Description]
GO
ALTER TABLE [dbo].[InStoreLocation] ADD  CONSTRAINT [DF_InStoreLocation_Zone]  DEFAULT ('NoZone') FOR [Zone]
GO
ALTER TABLE [dbo].[InStoreLocation] ADD  CONSTRAINT [DF_InStoreLocation_SubZone]  DEFAULT ('NoSubzone') FOR [SubZone]
GO
ALTER TABLE [dbo].[InStoreLocation] ADD  CONSTRAINT [DF__InStoreLo__IsAct__4E53A1AA]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[InStoreLocation] ADD  CONSTRAINT [DF_InStoreLocation_CreatedBy]  DEFAULT ((1)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[InStoreLocation] ADD  CONSTRAINT [DF_InStoreLocation_ModifiedBy]  DEFAULT ((1)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[InStoreLocation] ADD  CONSTRAINT [DF_InStoreLocation_DateCreated]  DEFAULT ((sysdatetimeoffset() AT TIME ZONE 'Eastern Standard Time')) FOR [DateCreated]
GO
ALTER TABLE [dbo].[InStoreLocation] ADD  CONSTRAINT [DF_InStoreLocation_DateModified]  DEFAULT ((sysdatetimeoffset() AT TIME ZONE 'Eastern Standard Time')) FOR [DateModified]
GO
ALTER TABLE [dbo].[InStoreLocation]  WITH CHECK ADD  CONSTRAINT [FK_InStoreLocation_CreatedBy_Users_UserID] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[InStoreLocation] CHECK CONSTRAINT [FK_InStoreLocation_CreatedBy_Users_UserID]
GO
ALTER TABLE [dbo].[InStoreLocation]  WITH CHECK ADD  CONSTRAINT [FK_InStoreLocation_ModifiedBy_Users_UserID] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[InStoreLocation] CHECK CONSTRAINT [FK_InStoreLocation_ModifiedBy_Users_UserID]
GO
