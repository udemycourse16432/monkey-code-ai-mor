





-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spSync_TermsOfSaleAdditionsAndRemovals]

 @counter int
,@Type int
,@CustID int
,@AddOrRemove nvarchar(8)
,@DateTime datetime

AS

if exists (select counter from TermsOfSaleAdditionsAndRemovals where counter=@counter)
 begin
  update TermsOfSaleAdditionsAndRemovals set
    [Type]=@Type
   ,CustID=@CustID
   ,AddOrRemove=@AddOrRemove
   ,[DateTime]=@DateTime
  where counter=@counter
 end
else
 begin
  insert into TermsOfSaleAdditionsAndRemovals
  (counter 
  ,[Type]
  ,CustID 
  ,AddOrRemove
  ,[DateTime])
  values
  (@counter 
  ,@Type
  ,@CustID 
  ,@AddOrRemove
  ,@DateTime)
 end






