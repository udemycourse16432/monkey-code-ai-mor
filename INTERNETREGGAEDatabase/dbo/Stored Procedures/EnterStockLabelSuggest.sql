


CREATE PROCEDURE [dbo].[EnterStockLabelSuggest]
 @Text nvarchar(255)

AS

select top 10 Label,count(ID) as Qty from Inventory
where Label like @Text
group by Label
order by Qty desc

