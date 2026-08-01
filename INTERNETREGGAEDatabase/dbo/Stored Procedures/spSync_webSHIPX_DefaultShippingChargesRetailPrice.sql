







-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spSync_webSHIPX_DefaultShippingChargesRetailPrice]

 @counter int
,@ShippingMethod nvarchar(50)
,@AmountPerPoundSurcharge money
,@PercentOfPurchaseValueSurcharge float
,@FlatAmountSurcharge money
,@ShippingCostSurcharge float

AS

if exists (select counter from webSHIPX_DefaultShippingChargesRetailPrice where counter=@counter)
 begin
  update webSHIPX_DefaultShippingChargesRetailPrice set
   ShippingMethod=@ShippingMethod
  ,AmountPerPoundSurcharge=@AmountPerPoundSurcharge
  ,PercentOfPurchaseValueSurcharge=@PercentOfPurchaseValueSurcharge
  ,FlatAmountSurcharge=@FlatAmountSurcharge
  ,ShippingCostSurcharge=@ShippingCostSurcharge
  where counter=@counter
 end
else
 begin
  insert into webSHIPX_DefaultShippingChargesRetailPrice
 (counter 
 ,ShippingMethod 
 ,AmountPerPoundSurcharge 
 ,PercentOfPurchaseValueSurcharge 
 ,FlatAmountSurcharge 
 ,ShippingCostSurcharge)
  values
 (@counter 
 ,@ShippingMethod 
 ,@AmountPerPoundSurcharge 
 ,@PercentOfPurchaseValueSurcharge 
 ,@FlatAmountSurcharge 
 ,@ShippingCostSurcharge)
 end








