

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spGetWebSearchSuggestionRow] 
@Counter int

AS

select * from WebSearchSuggestions
where Counter=@Counter



