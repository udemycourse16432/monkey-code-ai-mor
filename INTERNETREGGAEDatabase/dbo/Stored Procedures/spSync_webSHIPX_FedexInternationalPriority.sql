











-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spSync_webSHIPX_FedexInternationalPriority]

 @counter int
,@WeightInPounds float
,@ZoneA money
,@ZoneB money
,@ZoneC money
,@ZoneD money
,@ZoneE money
,@ZoneF money
,@ZoneG money
,@ZoneH money
,@ZoneI money
,@ZoneJ money
,@ZoneK money
,@ZoneL money
,@ZoneM money
,@ZoneN money
,@ZoneO money

AS

if exists (select counter from webSHIPX_FedexInternationalPriority where counter=@counter)
 begin
  update webSHIPX_FedexInternationalPriority set
   WeightInPounds=@WeightInPounds
  ,ZoneA=@ZoneA
  ,ZoneB=@ZoneB
  ,ZoneC=@ZoneC
  ,ZoneD=@ZoneD
  ,ZoneE=@ZoneE
  ,ZoneF=@ZoneF
  ,ZoneG=@ZoneG
  ,ZoneH=@ZoneH
  ,ZoneI=@ZoneI
  ,ZoneJ=@ZoneJ
  ,ZoneK=@ZoneK
  ,ZoneL=@ZoneL
  ,ZoneM=@ZoneM
  ,ZoneN=@ZoneN
  ,ZoneO=@ZoneO

  where counter=@counter
 end
else
 begin
  insert into webSHIPX_FedexInternationalPriority
  (counter 
  ,WeightInPounds 
  ,ZoneA
  ,ZoneB
  ,ZoneC
  ,ZoneD
  ,ZoneE
  ,ZoneF
  ,ZoneG
  ,ZoneH
  ,ZoneI
  ,ZoneJ
  ,ZoneK
  ,ZoneL
  ,ZoneM
  ,ZoneN
  ,ZoneO)
 values
  (@counter 
  ,@WeightInPounds 
  ,@ZoneA
  ,@ZoneB
  ,@ZoneC
  ,@ZoneD
  ,@ZoneE
  ,@ZoneF
  ,@ZoneG
  ,@ZoneH
  ,@ZoneI
  ,@ZoneJ
  ,@ZoneK
  ,@ZoneL
  ,@ZoneM
  ,@ZoneN
  ,@ZoneO)
 end












