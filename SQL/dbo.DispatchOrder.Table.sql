/****** Object:  Table [dbo].[DispatchOrder]    Script Date: 12/15/2024 11:45:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DispatchOrder](
	[DispatchOrderID] [int] IDENTITY(1,1) NOT NULL,
	[IsPrescription] [bit] NOT NULL,
	[PatientID] [int] NULL,
	[PrescriptionNumber] [nvarchar](50) NULL,
	[ReceiverID] [int] NULL,
	[ReceiverOrderNumber] [nvarchar](50) NULL,
	[DateRequested] [datetime2](7) NOT NULL,
	[IsCompleted] [bit] NOT NULL,
	[DateCompleted] [datetime2](7) NULL,
	[Notes] [varchar](255) NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[DateCreated] [datetime2](7) NOT NULL,
	[DateModified] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_DispatchOrder] PRIMARY KEY CLUSTERED 
(
	[DispatchOrderID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DispatchOrder] ADD  CONSTRAINT [DF__DispatchO__IsPre__15B0212B]  DEFAULT ((0)) FOR [IsPrescription]
GO
ALTER TABLE [dbo].[DispatchOrder] ADD  CONSTRAINT [DF_DispatchOrder_DateRequested]  DEFAULT ((sysdatetimeoffset() AT TIME ZONE 'Eastern Standard Time')) FOR [DateRequested]
GO
ALTER TABLE [dbo].[DispatchOrder] ADD  CONSTRAINT [DF__DispatchO__IsCom__6AC5C326]  DEFAULT ((0)) FOR [IsCompleted]
GO
ALTER TABLE [dbo].[DispatchOrder] ADD  CONSTRAINT [DF_DispatchOrder_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[DispatchOrder] ADD  CONSTRAINT [DF__DispatchO__Creat__6BB9E75F]  DEFAULT ((1)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[DispatchOrder] ADD  CONSTRAINT [DF__DispatchO__Modif__6CAE0B98]  DEFAULT ((1)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[DispatchOrder] ADD  CONSTRAINT [DF__DispatchO__DateC__6DA22FD1]  DEFAULT ((sysdatetimeoffset() AT TIME ZONE 'Eastern Standard Time')) FOR [DateCreated]
GO
ALTER TABLE [dbo].[DispatchOrder] ADD  CONSTRAINT [DF__DispatchO__DateM__6E96540A]  DEFAULT ((sysdatetimeoffset() AT TIME ZONE 'Eastern Standard Time')) FOR [DateModified]
GO
ALTER TABLE [dbo].[DispatchOrder]  WITH CHECK ADD  CONSTRAINT [FK_DispatchOrder_CreatedBy_Users_UserID] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[DispatchOrder] CHECK CONSTRAINT [FK_DispatchOrder_CreatedBy_Users_UserID]
GO
ALTER TABLE [dbo].[DispatchOrder]  WITH CHECK ADD  CONSTRAINT [FK_DispatchOrder_ModifiedBy_Users_UserID] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[DispatchOrder] CHECK CONSTRAINT [FK_DispatchOrder_ModifiedBy_Users_UserID]
GO
ALTER TABLE [dbo].[DispatchOrder]  WITH CHECK ADD  CONSTRAINT [FK_DispatchOrder_PatientID_Patient_PatientID] FOREIGN KEY([PatientID])
REFERENCES [dbo].[Patient] ([PatientID])
GO
ALTER TABLE [dbo].[DispatchOrder] CHECK CONSTRAINT [FK_DispatchOrder_PatientID_Patient_PatientID]
GO
ALTER TABLE [dbo].[DispatchOrder]  WITH CHECK ADD  CONSTRAINT [FK_DispatchOrder_ReceiverID_DispatchReceiver_ReceiverID] FOREIGN KEY([ReceiverID])
REFERENCES [dbo].[DispatchReceiver] ([ReceiverID])
GO
ALTER TABLE [dbo].[DispatchOrder] CHECK CONSTRAINT [FK_DispatchOrder_ReceiverID_DispatchReceiver_ReceiverID]
GO
