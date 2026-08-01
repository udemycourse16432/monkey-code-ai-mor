


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spDeleteWebSearchSuggestionsLABEL] 

 @Hint nvarchar(255)

AS

delete WebSearchSuggestions
where Hint=@Hint
and SearchType='Label'


