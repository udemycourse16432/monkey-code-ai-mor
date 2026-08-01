

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spGetOrdersRowByPayPalTransactionID]

@PaypalTransactionID nvarchar(50)

AS

select * from orders
where PaypalTransactionID=@PaypalTransactionID
