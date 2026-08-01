


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spUpdateScanPathForWebSearchSuggestion] 
 @Hint nvarchar(350)
,@ScanPath nvarchar(50)
,@SortOrder int

AS

update WebSearchSuggestions set ScanPath=@ScanPath,SortOrder=@SortOrder
where Hint=@Hint
and SearchType='Album'



