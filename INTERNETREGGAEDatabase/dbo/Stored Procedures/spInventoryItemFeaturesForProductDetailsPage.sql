


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spInventoryItemFeaturesForProductDetailsPage]

@InventoryID int

AS

SELECT InventoryItemFeatureIndex.*
from InventoryItemFeatures
inner join  InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
where InventoryItemFeatures.ItemID=@InventoryID
order by ItemFeatureWebProductDetailsPageTextDisplaySequence

