
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spEmailData] 
@ID int

AS
BEGIN
select * from EmailsFromTheWebServer
where ID=@ID

END

