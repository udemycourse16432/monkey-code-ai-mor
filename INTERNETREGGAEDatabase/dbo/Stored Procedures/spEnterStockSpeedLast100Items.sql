



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spEnterStockSpeedLast100Items]

 @Worker nvarchar(100)

AS

select top 100 counter,Batch,[DateTime] from enterstock
where worker = @Worker
order by counter desc

