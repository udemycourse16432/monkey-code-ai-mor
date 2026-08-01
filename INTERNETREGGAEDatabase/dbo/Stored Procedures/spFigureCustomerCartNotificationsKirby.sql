
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spFigureCustomerCartNotificationsKirby]

 @MinimumCartDollarAmount numeric(9,2)
,@CartStaleForHowManyDays int
,@LastEmailedHowManyDaysAgo int

as

declare @Rows int

insert CustomerCartNotificationsToSend
(CustomerServerCounter)
select CustomerServerCounter from SignInCartTotalsTableKirby
where TotalPrice>=@MinimumCartDollarAmount
and (datediff(day,LastCartAdjustment,getdate())>=@CartStaleForHowManyDays or LastCartAdjustment is null)
and (datediff(day,LastEmailDate,getdate())>=@LastEmailedHowManyDaysAgo or LastEmailDate is null)

select (select count(CustomerServerCounter) from SignInCartTotalsTableKirby
where TotalPrice>=@MinimumCartDollarAmount
and (datediff(day,LastCartAdjustment,getdate())>=@CartStaleForHowManyDays or LastCartAdjustment is null)
and (datediff(day,LastEmailDate,getdate())>=@LastEmailedHowManyDaysAgo or LastEmailDate is null)) as Rows