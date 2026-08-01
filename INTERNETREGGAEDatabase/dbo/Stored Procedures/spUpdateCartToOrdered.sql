
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].spUpdateCartToOrdered

 @CartName nvarchar(60)
,@OrderNumber nvarchar(15)

AS

UPDATE Carts
SET OrderNumber=@OrderNumber
WHERE CartName=@CartName