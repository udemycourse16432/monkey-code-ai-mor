


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spGetOrderItems]

 @OrderNumber nvarchar(15)

AS

select * from orderitems where ordernumber=@OrderNumber
order by [format],description

