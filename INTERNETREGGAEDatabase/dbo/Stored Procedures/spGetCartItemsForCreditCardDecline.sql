

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spGetCartItemsForCreditCardDecline]

 @CartName nvarchar(60)

AS

select * from Carts inner join inventory
on Carts.ItemID=Inventory.ID
where CartName=@CartName
order by [Format],ArtistTitle
