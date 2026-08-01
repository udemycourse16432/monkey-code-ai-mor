





-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spSync_EmailFooter]

 @counter int
,@footer nvarchar(max)

AS

if exists (select counter from EmailFooter where counter=@counter)
 begin
  update EmailFooter set
   footer=@footer
  where counter=@counter
 end
else
 begin
  insert into EmailFooter
   (counter
   ,Footer)
  values
   (@counter
   ,@footer)
 end






