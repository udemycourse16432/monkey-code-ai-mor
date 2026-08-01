





-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spGetEnter7InchRowFromRandomNumberID]

 @RandomNumberID nvarchar(50)

AS

select * from Enter7Inch where RandomNumberID=@RandomNumberID
