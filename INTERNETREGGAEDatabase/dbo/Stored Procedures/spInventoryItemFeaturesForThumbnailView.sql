




-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spInventoryItemFeaturesForThumbnailView]

@InventoryID int

AS

SELECT InventoryItemFeatureIndex.*
from InventoryItemFeatures
inner join  InventoryItemFeatureIndex on InventoryItemFeatures.InventoryItemFeatureID=InventoryItemFeatureIndex.InventoryItemFeatureID
where InventoryItemFeatures.ItemID=@InventoryID
and ItemFeatureWebGalleryText is not null
order by ItemFeatureWebProductDetailsPageTextDisplaySequence



