USE [DeviceManagement]
GO
/****** Object:  Table [dbo].[Backend]    Script Date: 10/21/2020 6:31:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Backend](
	[Name] [nvarchar](50) NOT NULL,
	[Address] [nvarchar](200) NOT NULL,
	[ID] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_Backend] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Device]    Script Date: 10/21/2020 6:31:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Device](
	[IMEI] [nvarchar](20) NOT NULL,
	[Model] [nvarchar](50) NOT NULL,
	[SimCardNumber] [varchar](20) NOT NULL,
	[Enable] [bit] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[Createdby] [varchar](50) NOT NULL,
	[BackendID] [int] NULL
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Backend] ON 
GO
INSERT [dbo].[Backend] ([Name], [Address], [ID]) VALUES (N'Sandeep', N'Rajarhat', 1)
GO
SET IDENTITY_INSERT [dbo].[Backend] OFF
GO
INSERT [dbo].[Device] ([IMEI], [Model], [SimCardNumber], [Enable], [CreatedDateTime], [Createdby], [BackendID]) VALUES (N'1233', N'Nokia', N'998877', 1, CAST(N'2020-09-10T00:00:00.000' AS DateTime), N'Sandeep', 1)
GO
ALTER TABLE [dbo].[Device]  WITH CHECK ADD  CONSTRAINT [FK_Device_Backend] FOREIGN KEY([BackendID])
REFERENCES [dbo].[Backend] ([ID])
GO
ALTER TABLE [dbo].[Device] CHECK CONSTRAINT [FK_Device_Backend]
GO
/****** Object:  StoredProcedure [dbo].[USP_DeleteDeviceData]    Script Date: 10/21/2020 6:31:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_DeleteDeviceData]
@ID int
AS
BEGIN
DELETE FROM [dbo].[Device] where BackendID=@ID
DELETE FROM Backend where ID=@ID
END


GO
/****** Object:  StoredProcedure [dbo].[USP_GetDeviceData]    Script Date: 10/21/2020 6:31:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_GetDeviceData]
AS
BEGIN
SELECT 
	[Backend].ID,
	[Name],[Address],
	[IMEI]
      ,[Model]
      ,[SimCardNumber]
      ,[Enable]
      ,[CreatedDateTime]
      ,[Createdby]
      ,[BackendID]
  FROM [dbo].[Device] join [dbo].[Backend] on [Device].BackendID=[Backend].ID
END


GO
/****** Object:  StoredProcedure [dbo].[USP_InsertDevice]    Script Date: 10/21/2020 6:31:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[USP_InsertDevice]
   (@IMEI nvarchar(20),
    @Model nvarchar(50),
    @SimCardNumber varchar(20),
    @Enable bit,
    @CreatedDateTime datetime,
    @Createdby varchar(50),
	@NAME nvarchar (50),
	@Address nvarchar (200),
    @BackendID int=0)

AS
BEGIN TRAN
BEGIN TRY

INSERT INTO [dbo].[Backend]
           ([Name]
           ,[Address])
     VALUES
           (@Name,
           @Address)


INSERT INTO [dbo].[Device]
           ([IMEI]
           ,[Model]
           ,[SimCardNumber]
           ,[Enable]
           ,[CreatedDateTime]
           ,[Createdby]
           ,[BackendID])
     VALUES
           (@IMEI
           ,@Model
           ,@SimCardNumber
           ,@Enable
           ,@CreatedDateTime
           ,@Createdby
           ,SCOPE_IDENTITY())



   COMMIT TRAN

END TRY
BEGIN CATCH

  ROLLBACK TRAN

END CATCH






GO
/****** Object:  StoredProcedure [dbo].[USP_UpdateDevice]    Script Date: 10/21/2020 6:31:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Proc [dbo].[USP_UpdateDevice]
   (@IMEI nvarchar(20),
    @Model nvarchar(50),
    @SimCardNumber varchar(20),
    @Enable bit,
    @CreatedDateTime datetime,
    @Createdby varchar(50),
	@NAME nvarchar (50),
	@ID int,
	@Address nvarchar (200))

	AS
BEGIN TRAN
BEGIN TRY

UPDATE [dbo].[Device]
   SET [IMEI] = @IMEI
      ,[Model] =@Model
      ,[SimCardNumber] = @SimCardNumber
      ,[Enable] = @Enable
      ,[CreatedDateTime] = @CreatedDateTime
      ,[Createdby] = @Createdby
 WHERE BackendID=@ID

 Update [dbo].[Backend]
SET Name=@NAME,Address=@Address Where ID=@ID
   COMMIT TRAN

END TRY
BEGIN CATCH

  ROLLBACK TRAN

END CATCH





GO
