


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spGetWebSHIPX_MaxWeightOfBoxForPacking]

@CartName nvarchar(60)

AS

declare @HasVinyl nvarchar(1)

select @HasVinyl = Format from Carts
left join inventory on Carts.ItemID = inventory.ID
where Carts.CartName=@CartName
and Inventory>0
and (Format='LP' or Format='12""' or Format='10""' or Format='7""')

if @HasVinyl is null
 begin
  select max(ItemWeight) as MaxWeightInGrams from WebSHIPX_Packaging_Weight_1 
 end

else
 begin
  select max(ItemWeight) as MaxWeightInGrams from WebSHIPX_Packaging_Weight_2  
 end




