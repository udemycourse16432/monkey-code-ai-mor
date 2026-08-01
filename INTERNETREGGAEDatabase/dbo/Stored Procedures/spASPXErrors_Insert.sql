

















-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spASPXErrors_Insert]

 @CartName nvarchar(60)
,@UserAgent nvarchar(300)
,@IPAddress nvarchar(50)
,@PowerUserName nvarchar(50)
,@ErrorMessage nvarchar(500)
,@ErrorStackTrace nvarchar(2000)
,@QueryString nvarchar(1000)
,@FormValues nvarchar(2000)
,@ErrorLevel nvarchar(50)
,@CounterOUTPUT int OUTPUT


AS

  insert into ASPXErrors (CartName,UserAgent,IPAddress,PowerUserName,ErrorMessage,ErrorStackTrace,QueryString,FormValues,ErrorLevel)
   values
(@CartName
,@UserAgent
,@IPAddress
,@PowerUserName
,@ErrorMessage
,@ErrorStackTrace
,@QueryString
,@FormValues
,@ErrorLevel)

select @CounterOUTPUT = SCOPE_IDENTITY()
select @CounterOUTPUT as counter














