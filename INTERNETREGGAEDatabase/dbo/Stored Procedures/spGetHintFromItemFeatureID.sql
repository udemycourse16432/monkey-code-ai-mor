



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spGetHintFromItemFeatureID]

 @ItemFeatureID int

AS

select * from InventoryItemFeatureIndex
where InventoryItemFeatureID = @ItemFeatureID






