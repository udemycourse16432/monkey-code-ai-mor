


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].spUpdateCartPrice

 @CartCounter int
,@Price numeric(5,2)

AS

UPDATE Carts
SET Carts.Price=@Price
WHERE Carts.counter=@CartCounter