






create PROCEDURE [dbo].[spRemovePaymentMethod]
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
,'remove'
,getdate())










