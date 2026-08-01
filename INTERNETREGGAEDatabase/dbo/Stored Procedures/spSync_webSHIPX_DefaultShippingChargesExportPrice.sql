






-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spSync_webSHIPX_DefaultShippingChargesExportPrice]

 @counter int
,@ShippingMethod nvarchar(50)
,@AmountPerPoundSurcharge money
,@PercentOfPurchaseValueSurcharge float
,@FlatAmountSurcharge money
,@ShippingCostSurcharge float

AS

if exists (select counter from webSHIPX_DefaultShippingChargesExportPrice where counter=@counter)
 begin
  update webSHIPX_DefaultShippingChargesExportPrice set
   ShippingMethod=@ShippingMethod
  ,AmountPerPoundSurcharge=@AmountPerPoundSurcharge
  ,PercentOfPurchaseValueSurcharge=@PercentOfPurchaseValueSurcharge
  ,FlatAmountSurcharge=@FlatAmountSurcharge
  ,ShippingCostSurcharge=@ShippingCostSurcharge
  where counter=@counter
 end
else
 begin
  insert into webSHIPX_DefaultShippingChargesExportPrice
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







