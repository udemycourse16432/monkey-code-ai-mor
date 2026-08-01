




-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spDeleteWebSearchSuggestionsITEMFEATURES] 

 @ItemFeature1 nvarchar(255)
,@ItemFeature2 nvarchar(255)
,@ItemFeature3 nvarchar(255)
,@ItemFeature4 nvarchar(255)
,@ItemFeature5 nvarchar(255)
,@ItemFeature6 nvarchar(255)
,@ItemFeature7 nvarchar(255)
,@ItemFeature8 nvarchar(255)
,@ItemFeature9 nvarchar(255)
,@ItemFeature10 nvarchar(255)

AS

delete WebSearchSuggestions
where (Hint=@ItemFeature1 or Hint=@ItemFeature2 or Hint=@ItemFeature3 or Hint=@ItemFeature4 or Hint=@ItemFeature5 or Hint=@ItemFeature6 or Hint=@ItemFeature7 or Hint=@ItemFeature8 or Hint=@ItemFeature9 or Hint=@ItemFeature10)
and SearchType='Item Feature'




