



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spDeleteWebSearchSuggestionsGENRES] 

 @Genre1 nvarchar(255)
,@Genre2 nvarchar(255)
,@Genre3 nvarchar(255)
,@Genre4 nvarchar(255)
,@Genre5 nvarchar(255)
,@Genre6 nvarchar(255)
,@Genre7 nvarchar(255)
,@Genre8 nvarchar(255)
,@Genre9 nvarchar(255)

AS

delete WebSearchSuggestions
where (Hint=@Genre1 or Hint=@Genre2 or Hint=@Genre3 or Hint=@Genre4 or Hint=@Genre5 or Hint=@Genre6 or Hint=@Genre7 or Hint=@Genre8 or Hint=@Genre9)
and SearchType='Genre'



