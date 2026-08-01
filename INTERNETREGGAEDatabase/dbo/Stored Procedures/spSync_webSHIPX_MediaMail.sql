









-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spSync_webSHIPX_MediaMail]

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

AS

if exists (select counter from webSHIPX_MediaMail where counter=@counter)
 begin
  update webSHIPX_MediaMail set
   WeightInPounds=@WeightInPounds
  ,Zone1=@Zone1
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
  insert into webSHIPX_MediaMail
  (counter 
  ,WeightInPounds 
  ,Zone1 
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
  ,@Zone1 
  ,@Zone2 
  ,@Zone3 
  ,@Zone4 
  ,@Zone5 
  ,@Zone6 
  ,@Zone7 
  ,@Zone8)
 end










