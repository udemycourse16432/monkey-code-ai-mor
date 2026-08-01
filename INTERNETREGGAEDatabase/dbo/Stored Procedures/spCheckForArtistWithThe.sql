



create PROCEDURE [dbo].[spCheckForArtistWithThe]
 @Artist nvarchar(255)

AS

select top 1 ArtistTitle from  Inventory
where substring([ArtistTitle],1,charindex(' - ',[ArtistTitle]))=@Artist


