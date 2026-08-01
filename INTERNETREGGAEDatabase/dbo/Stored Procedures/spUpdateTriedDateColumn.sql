




-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spUpdateTriedDateColumn]

 @counter int

AS

update WebSearchSuggestionsToFigure
set TriedDateTime=GetDate()
where counter=@counter







