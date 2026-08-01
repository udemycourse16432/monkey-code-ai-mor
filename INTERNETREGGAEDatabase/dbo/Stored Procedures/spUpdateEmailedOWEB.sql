



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spUpdateEmailedOWEB]

 @OrderNumber nvarchar(15)

AS

UPDATE orders
SET emailedOWEB='yes'
WHERE ordernumber=upper(@OrderNumber)
