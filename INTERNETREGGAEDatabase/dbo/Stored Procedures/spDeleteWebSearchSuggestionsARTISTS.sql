


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spDeleteWebSearchSuggestionsARTISTS] 

 @Artist1 nvarchar(255)
,@Artist2 nvarchar(255)
,@Artist3 nvarchar(255)
,@Artist4 nvarchar(255)
,@Artist5 nvarchar(255)
,@Artist6 nvarchar(255)

AS

delete WebSearchSuggestions
where (Hint=@Artist1 or Hint=@Artist2 or Hint=@Artist3 or Hint=@Artist4 or Hint=@Artist5 or Hint=@Artist6)
and SearchType='Artist'


