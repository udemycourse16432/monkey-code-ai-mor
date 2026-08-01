






CREATE PROCEDURE [dbo].[CustomerNameSuggest]
 @Text1 nvarchar(255)
,@Text2 nvarchar(255)
,@Text3 nvarchar(255)
,@Text4 nvarchar(255)
,@Text5 nvarchar(255)
,@Sort nvarchar(2)
,@Top nvarchar(5)
AS

declare @SortString nvarchar(255)
if @Sort='N' set @SortString=' Order by FullName,Counter desc'
else set @SortString=' Order by DateOfLastLogin desc,DateOfLastOrder desc,Counter desc'

BEGIN
 IF @Text1<>'%**%'
  BEGIN
   exec ('select top '+@Top+' counter,FullName,left(PriceGroup,1) as PriceGroup,UserName,Password,CustomerID,StreetAddress1,City,StateProvince,Country,Phone,Email,DateOfLastOrder,DateOfLastLogIn,DateOfLastCustomerInteraction,DateOfLastCartAdjustment,CartQuantity,LogInEmail
   from Customers
   where (FullName like '''+@Text1+''' or BillingFullName like '''+@Text1+''') and (FullName like '''+@Text2+''' or BillingFullName like '''+@Text2+''') and (FullName like '''+@Text3+''' or BillingFullName like '''+@Text3+''') and (FullName like '''+@Text4+''' or BillingFullName like '''+@Text4+''') and (FullName like '''+@Text5+''' or BillingFullName like '''+@Text5+''')
   and superpowerusername is null and powerusername is null'+@SortString)
  END

 IF @Text1='%**%'
  BEGIN
   exec ('select top '+@Top+' Notes,CustomerInteraction.DateTime,Customers.counter,FullName,left(PriceGroup,1) as PriceGroup,UserName,Password,Customers.CustomerID,StreetAddress1,City,StateProvince,Country,Phone,Email,DateOfLastOrder,DateOfLastLogIn,DateOfLastCustomerInteraction,DateOfLastCartAdjustment,CartQuantity,LogInEmail
   from Customers left join CustomerInteraction on Customers.counter=CustomerInteraction.CustomerServerCounter
   and superpowerusername is null and powerusername is null order by DateTime desc')
  END

END

































