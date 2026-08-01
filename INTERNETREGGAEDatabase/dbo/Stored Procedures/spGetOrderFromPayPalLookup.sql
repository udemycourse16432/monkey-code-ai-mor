

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spGetOrderFromPayPalLookup]

 @StartDate datetime
,@EndDate datetime


AS

select * from orders
where DateTime>=@StartDate
and DateTime<=@EndDate
and Status='ChosePayPal'
order by counter desc
