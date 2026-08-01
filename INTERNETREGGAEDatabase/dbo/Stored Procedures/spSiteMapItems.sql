






-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spSiteMapItems] 


AS

select ArtistTitle,Format,UsedItem,ID,StorePrice from inventory
where Inventory>0
order by ID





