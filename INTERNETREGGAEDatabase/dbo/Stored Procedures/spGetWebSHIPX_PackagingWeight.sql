


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spGetWebSHIPX_PackagingWeight]

 @WeightInGrams numeric(9,2)
,@CartName nvarchar(60)

AS

declare @HasVinyl nvarchar(1)
declare @MaxWeightInGrams int

select @HasVinyl = Format from Carts
left join inventory on Carts.ItemID = inventory.ID
where Carts.CartName=@CartName
and Inventory>0
and (Format='LP' or Format='12""' or Format='10""' or Format='7""')
and SaveForLater is null

if @HasVinyl is null
 begin
  select @MaxWeightInGrams =max(ItemWeight) from WebSHIPX_Packaging_Weight_1
  if @MaxWeightInGrams<@WeightInGrams
    set @WeightInGrams=@MaxWeightInGrams

  select PackagingWeight from WebSHIPX_Packaging_Weight_1
  where ItemWeight>=@WeightInGrams
  order by ItemWeight
 end

else
 begin
  select @MaxWeightInGrams =max(ItemWeight) from WebSHIPX_Packaging_Weight_2
  if @MaxWeightInGrams<@WeightInGrams
    set @WeightInGrams=@MaxWeightInGrams

  select PackagingWeight from WebSHIPX_Packaging_Weight_2
  where ItemWeight>=@WeightInGrams
  order by ItemWeight
 end



