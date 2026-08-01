



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spEnterStockSpeedLast300Items]

 @Worker nvarchar(100)

AS

select top 300 counter,Batch,[DateTime] from enterstock
where worker = @Worker
order by counter desc

