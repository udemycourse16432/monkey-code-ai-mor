



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].spInsertNewReleaseEmailOptInOrOut

 
 @Password nvarchar(50)
,@Email nvarchar(100)
,@FullName nvarchar(120)

AS

insert NewReleaseEmailOptInOrOut
(Password
,Email
,OptIn
,FullName
,[DateTime])

values

(@Password
,@Email
,'no'
,@FullName
,GetDate())
