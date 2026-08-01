












CREATE PROCEDURE [dbo].[spDownload_Carts]

AS

select top 1

counter,
CartName,
[DateTime],
ItemID,
Quantity,
Price,
IPAddress,
SaveForLater

from Carts where InSync='n' order by counter









