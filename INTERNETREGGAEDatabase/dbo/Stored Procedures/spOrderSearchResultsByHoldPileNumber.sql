

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].spOrderSearchResultsByHoldPileNumber

 @OrderNumber nvarchar(15)

AS

select Orders.Status as OrdersStatus,Orders.CustomerServerCounter as OrdersCustomerServerCounter,Orders.DownloadGroup as OrdersDownloadGroup,Orders.Password as OrdersPassword,Orders.Status as OrdersStatus,Orders.FullName as OrdersFullName,Orders.StreetAddress1 as OrdersStreetAddress1,Orders.City as OrdersCity,Orders.StateProvince as OrdersStateProvince,Orders.Country as OrdersCountry,Orders.UserAgent as OrdersUserAgent,Orders.*,HoldPilesForWeb.CustomerID as HoldPilesCustomerID,HoldPilesForWeb.*
from HoldPilesForWeb
left join Orders on HoldPilesForWeb.HoldPileNumber=Orders.OrderNumber
where HoldPileNumber=@OrderNumber