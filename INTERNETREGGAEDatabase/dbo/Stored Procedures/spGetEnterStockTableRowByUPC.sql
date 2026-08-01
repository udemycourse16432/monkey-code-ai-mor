








CREATE PROCEDURE [dbo].[spGetEnterStockTableRowByUPC]

@UPC nvarchar(50)

AS

select * from EnterStock
where UPC=@UPC
order by counter desc
















