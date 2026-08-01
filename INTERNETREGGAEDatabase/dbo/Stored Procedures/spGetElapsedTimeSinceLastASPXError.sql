
CREATE PROCEDURE [dbo].[spGetElapsedTimeSinceLastASPXError]
AS

select top 1 datediff(minute,[DateTime],GetDate()) as Minutes,IPAddress
from ASPXErrors
order by counter desc

