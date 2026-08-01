













CREATE PROCEDURE [dbo].[LabelSuggestRowCount]
@Text nvarchar(255)
AS
BEGIN
 select count(distinct [Label]) as CountOfLabel
 from inventory
 where [Label] like @Text
 and inventory>0
 and deleted<>'y'
END











