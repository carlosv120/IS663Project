/****** Object:  Table [dbo].[DispatchReceiver]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DispatchReceiver](
	[ReceiverID] [int] IDENTITY(1,1) NOT NULL,
	[ReceiverName] [varchar](50) NOT NULL,
	[CompanyName] [varchar](50) NULL,
	[ContactNumber] [varchar](20) NOT NULL,
	[Email] [varchar](50) NULL,
	[Address] [varchar](50) NOT NULL,
	[City] [varchar](50) NOT NULL,
	[State] [varchar](50) NOT NULL,
	[PostalCode] [varchar](20) NOT NULL,
	[Country] [varchar](50) NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedBy] [int] NULL,
	[ModifiedBy] [int] NULL,
	[DateCreated] [datetime2](7) NOT NULL,
	[DateModified] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_DispatchReceiver] PRIMARY KEY CLUSTERED 
(
	[ReceiverID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_DispatchReceiver_ReceiverName_CompanyName] UNIQUE NONCLUSTERED 
(
	[ReceiverName] ASC,
	[CompanyName] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DispatchReceiver] ADD  CONSTRAINT [DF_DispatchReceiver_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[DispatchReceiver] ADD  CONSTRAINT [DF_DispatchReceiver_CreatedBy]  DEFAULT ((1)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[DispatchReceiver] ADD  CONSTRAINT [DF_DispatchReceiver_ModifiedBy]  DEFAULT ((1)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[DispatchReceiver] ADD  CONSTRAINT [DF_DispatchReceiver_DateCreated]  DEFAULT ((sysdatetimeoffset() AT TIME ZONE 'Eastern Standard Time')) FOR [DateCreated]
GO
ALTER TABLE [dbo].[DispatchReceiver] ADD  CONSTRAINT [DF_DispatchReceiver_DateModified]  DEFAULT ((sysdatetimeoffset() AT TIME ZONE 'Eastern Standard Time')) FOR [DateModified]
GO
ALTER TABLE [dbo].[DispatchReceiver]  WITH CHECK ADD  CONSTRAINT [FK_DispatchReceiver_CreatedBy_Users_UserID] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[DispatchReceiver] CHECK CONSTRAINT [FK_DispatchReceiver_CreatedBy_Users_UserID]
GO
ALTER TABLE [dbo].[DispatchReceiver]  WITH CHECK ADD  CONSTRAINT [FK_DispatchReceiver_ModifiedBy_Users_UserID] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[DispatchReceiver] CHECK CONSTRAINT [FK_DispatchReceiver_ModifiedBy_Users_UserID]
GO
