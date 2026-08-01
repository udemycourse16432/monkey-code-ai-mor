






-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spSync_webSHIPX_AirParcelPost]

 @counter int
,@WeightInPounds float
,@Zone1 money
,@Zone2 money
,@Zone3 money
,@Zone4 money
,@Zone5 money
,@Zone6 money
,@Zone7 money
,@Zone8 money
,@Zone9 money
,@Zone10 money
,@Zone11 money
,@Zone12 money
,@Zone13 money
,@Zone14 money
,@Zone15 money
,@Zone16 money
,@Zone17 money

AS

if exists (select counter from webSHIPX_AirParcelPost where counter=@counter)
 begin
  update webSHIPX_AirParcelPost set
   WeightInPounds=@WeightInPounds
  ,Zone1=@Zone1
  ,Zone2=@Zone2
  ,Zone3=@Zone3
  ,Zone4=@Zone4
  ,Zone5=@Zone5
  ,Zone6=@Zone6
  ,Zone7=@Zone7
  ,Zone8=@Zone8
  ,Zone9=@Zone9
  ,Zone10=@Zone10
  ,Zone11=@Zone11
  ,Zone12=@Zone12
  ,Zone13=@Zone13
  ,Zone14=@Zone14
  ,Zone15=@Zone15
  ,Zone16=@Zone16
  ,Zone17=@Zone17
  where counter=@counter
 end
else
 begin
  insert into webSHIPX_AirParcelPost
  (counter 
  ,WeightInPounds 
  ,Zone1 
  ,Zone2 
  ,Zone3 
  ,Zone4 
  ,Zone5 
  ,Zone6 
  ,Zone7 
  ,Zone8 
  ,Zone9 
  ,Zone10 
  ,Zone11 
  ,Zone12 
  ,Zone13 
  ,Zone14 
  ,Zone15 
  ,Zone16 
  ,Zone17)
  values
  (@counter 
  ,@WeightInPounds 
  ,@Zone1 
  ,@Zone2 
  ,@Zone3 
  ,@Zone4 
  ,@Zone5 
  ,@Zone6 
  ,@Zone7 
  ,@Zone8 
  ,@Zone9 
  ,@Zone10 
  ,@Zone11 
  ,@Zone12 
  ,@Zone13 
  ,@Zone14 
  ,@Zone15 
  ,@Zone16 
  ,@Zone17)
 end







