












CREATE PROCEDURE [dbo].[LabelSuggest]
@Text nvarchar(255)

AS
select [Label],count(Label) as CountOfLabel
 from inventory
 where [Label] like @Text
 and inventory>0
 and deleted<>'y'
 and ShowOnWebsite='y'
 group by [Label]
 order by CountOfLabel desc















