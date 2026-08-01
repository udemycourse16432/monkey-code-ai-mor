


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spUpdateEmailedOrderConfirmation]

 @OrderNumber nvarchar(15)

AS

UPDATE orders
SET emailedconfirmation='yes'
WHERE ordernumber=upper(@OrderNumber)
