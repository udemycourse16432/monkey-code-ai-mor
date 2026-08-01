
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].spGetOrdersRow

@OrderNumber nvarchar(15)

AS

select * from orders
where OrderNumber=@OrderNumber