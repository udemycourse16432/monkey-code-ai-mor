






CREATE PROCEDURE [dbo].[spDownloadOK_Customers]

 @Counter nvarchar(10)
,@NewCustomerID nvarchar(50)

AS

update Customers set
 Insync='y'
,CustomerID=@NewCustomerID
where counter=@counter

update Orders set
CustomerID=@NewCustomerID
where CustomerServerCounter=@Counter





