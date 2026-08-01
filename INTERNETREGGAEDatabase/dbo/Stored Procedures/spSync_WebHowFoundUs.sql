






-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spSync_WebHowFoundUs]

 @counter int
,@HowFoundUs nvarchar(100)

AS

if exists (select counter from WebHowFoundUs where counter=@counter)
 begin
  update WebHowFoundUs set
   HowFoundUs=@HowFoundUs
  where counter=@counter
 end
else
 begin
  insert into WebHowFoundUs
   (counter
   ,HowFoundUs)
  values
   (@counter
   ,@HowFoundUs)
 end







