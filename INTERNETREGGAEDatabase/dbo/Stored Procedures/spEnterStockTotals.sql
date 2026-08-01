



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spEnterStockTotals]

 @Worker nvarchar(100)

AS

declare @TotalEntered int
set @TotalEntered=(select count(counter) from enterstock
where worker = @Worker)

select @TotalEntered as 'TotalEntered',year(DateTime) as 'Year',datename(month,dateadd(month,Month(DateTime),0)-1) as 'Month',count(counter) as 'Qty' from enterstock
where worker = @Worker
group by year(DateTime),Month(DateTime)
order by year(DateTime),Month(DateTime)

