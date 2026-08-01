












CREATE PROCEDURE [dbo].[spDownload_Carts_Deletes]

AS

select top 1

counter,
DeleteCounter

from Carts_Deletes where InSync='n' order by counter









