








-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spSync_InventoryItemFeatures_Deletes]

@counter int

AS

delete InventoryItemFeatures where ID=@counter
exec spFigureSearchSuggestionsForInventoryID @counter









