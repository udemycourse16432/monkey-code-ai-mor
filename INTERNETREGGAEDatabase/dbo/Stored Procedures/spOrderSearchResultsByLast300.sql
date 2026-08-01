

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].spOrderSearchResultsByLast300

AS

select top 300 Orders.CustomerServerCounter as OrdersCustomerServerCounter,Orders.Password as OrdersPassword,Orders.Status as OrdersStatus,Orders.DownloadGroup as OrdersDownloadGroup,Orders.FullName as OrdersFullName,Orders.StreetAddress1 as OrdersStreetAddress1,Orders.City as OrdersCity,Orders.StateProvince as OrdersStateProvince,Orders.Country as OrdersCountry,Orders.UserAgent as OrdersUserAgent,Orders.*
,HoldPilesForWeb.CustomerID as HoldPilesCustomerID,HoldPilesForWeb.*
from HoldPilesForWeb
left join Orders on HoldPilesForWeb.HoldPileNumber=Orders.OrderNumber
where HoldPilesForWeb.CustomerID<>'-' and HoldPilesForWeb.CustomerID is not null
order by HoldPilesForWeb.Date desc