


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spGetItemFeatureFromHint]

 @Hint nvarchar(255)

AS

select * from InventoryItemFeatureIndex
where Hint = @Hint





