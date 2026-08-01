




-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spGetImportantCartItem]

@CartName nvarchar(60)
AS

select Format,Genre1,YearFrom,YearTo,RhythmName,ID from Carts
inner join Inventory on Carts.ItemID=Inventory.ID
where CartName=@CartName
and Genre1 is not null
and YearFrom is not null
order by FormatOrder,Quantity desc,SalesLast30Days desc, ItemID desc



