






-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spSync_TermsOfSaleTypes]

 @counter int
,@Type int
,@TextOnInvoice nvarchar(100)
,@TextOnWebsitePaymentButton nvarchar(100)
,@DaysUntilDue int
,@RetailUSA char(1)
,@RetailInternational char(1)
,@WholesaleUSA char(1)
,@WholesaleInternational char(1)
,@TermsDays int

AS

if exists (select counter from TermsOfSaleTypes where counter=@counter)
 begin
  update TermsOfSaleTypes set
    [Type]=@Type
   ,TextOnInvoice=@TextOnInvoice
   ,TextOnWebsitePaymentButton=@TextOnWebsitePaymentButton
   ,DaysUntilDue=@DaysUntilDue
   ,RetailUSA=@RetailUSA
   ,RetailInternational=@RetailInternational
   ,WholesaleUSA=@WholesaleUSA
   ,WholesaleInternational=@WholesaleInternational
   ,TermsDays=@TermsDays
 where counter=@counter
 end
else
 begin
  insert into TermsOfSaleTypes
  (counter 
  ,[Type]
  ,TextOnInvoice
  ,TextOnWebsitePaymentButton 
  ,DaysUntilDue 
  ,RetailUSA 
  ,RetailInternational 
  ,WholesaleUSA 
  ,WholesaleInternational 
  ,TermsDays)
  values
  (@counter 
  ,@Type
  ,@TextOnInvoice
  ,@TextOnWebsitePaymentButton 
  ,@DaysUntilDue 
  ,@RetailUSA 
  ,@RetailInternational 
  ,@WholesaleUSA 
  ,@WholesaleInternational 
  ,@TermsDays)
 end







