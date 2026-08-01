

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spFind7InchDuplicateInInventoryTable]

 @ArtistTitle nvarchar(300),
 @Label nvarchar(150)

AS

select ID from Inventory
where ArtistTitle=@ArtistTitle and Label=@Label and UsedItem='n' and Format='7""'
