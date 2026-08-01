

















CREATE PROCEDURE [dbo].[spCheckForLPor12InchInCart]
@CartName nvarchar(60)
AS

select counter
from Carts
inner join Inventory on Carts.ItemID=Inventory.ID
where CartName=@CartName
and ([Format]='LP' or [Format]='12"')
and Inventory.Inventory>0
and SaveForLater is null














