


CREATE PROCEDURE [dbo].[CustomerNameSuggestRowCount]
@Text1 nvarchar(255)
,@Text2 nvarchar(255)
,@Text3 nvarchar(255)
,@Text4 nvarchar(255)
,@Text5 nvarchar(255)
AS

BEGIN
 IF @Text1<>'%**%'
  BEGIN
   select count(distinct counter) as CountOfFullName
   from Customers
   where FullName like @Text1 and FullName like @Text2 and FullName like @Text3 and FullName like @Text4 and FullName like @Text5
   and superpowerusername is null and powerusername is null
  END

 IF @Text1='%**%'
  BEGIN
   select count(distinct CustomerInteraction.counter) as CountOfFullName
   from Customers left join CustomerInteraction on Customers.counter=CustomerInteraction.CustomerServerCounter
   where CustomerInteraction.EBRep like @Text2 and CustomerTableName='Customers'
   and superpowerusername is null and powerusername is null
  END
END

















