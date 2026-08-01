






-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spSiteMapItemsNumberOfRecords] 


AS

select count(*) as NumberOfRecords
from inventory
where Inventory>0






