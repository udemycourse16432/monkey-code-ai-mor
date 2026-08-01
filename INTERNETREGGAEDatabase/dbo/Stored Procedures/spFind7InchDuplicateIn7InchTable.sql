

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spFind7InchDuplicateIn7InchTable]

 @ArtistTitle nvarchar(300),
 @Label nvarchar(150)

AS

select * from Enter7Inch
where FullDescription=@ArtistTitle and Label=@Label
