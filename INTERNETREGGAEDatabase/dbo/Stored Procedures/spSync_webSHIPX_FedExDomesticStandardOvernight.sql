












-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spSync_webSHIPX_FedExDomesticStandardOvernight]

 @counter int
,@WeightInPounds float
,@Zone2 money
,@Zone3 money
,@Zone4 money
,@Zone5 money
,@Zone6 money
,@Zone7 money
,@Zone8 money

AS

if exists (select counter from webSHIPX_FedExDomesticStandardOvernight where counter=@counter)
 begin
  update webSHIPX_FedExDomesticStandardOvernight set
   WeightInPounds=@WeightInPounds
  ,Zone2=@Zone2
  ,Zone3=@Zone3
  ,Zone4=@Zone4
  ,Zone5=@Zone5
  ,Zone6=@Zone6
  ,Zone7=@Zone7
  ,Zone8=@Zone8
  where counter=@counter
 end
else
 begin
  insert into webSHIPX_FedExDomesticStandardOvernight
  (counter 
  ,WeightInPounds 
  ,Zone2 
  ,Zone3 
  ,Zone4 
  ,Zone5 
  ,Zone6 
  ,Zone7 
  ,Zone8)
 values
  (@counter 
  ,@WeightInPounds 
  ,@Zone2 
  ,@Zone3 
  ,@Zone4 
  ,@Zone5 
  ,@Zone6 
  ,@Zone7 
  ,@Zone8)
 end













