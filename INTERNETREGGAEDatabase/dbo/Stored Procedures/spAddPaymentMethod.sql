







create PROCEDURE [dbo].[spAddPaymentMethod]
 @CustomerID int
,@Type int

AS

Insert TermsOfSaleAdditionsAndRemovals
(Type
,CustID
,AddOrRemove
,[DateTime])

values

(@Type
,@CustomerID
,'add'
,getdate())











