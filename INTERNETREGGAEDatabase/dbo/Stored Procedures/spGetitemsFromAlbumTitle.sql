




-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spGetitemsFromAlbumTitle] 
@ArtistTitle nvarchar(350)

AS

select ID,Format from Inventory
where ArtistTitle=@ArtistTitle
and Inventory>0
order by Format desc, ID desc






