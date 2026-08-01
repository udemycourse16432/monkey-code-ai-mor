



CREATE PROCEDURE [dbo].[EnterStockRhythmSuggest]
 @Text nvarchar(255)

AS

select top 10 RhythmName,count(counter) as Qty from Enter7Inch
where RhythmName like @Text
group by RhythmName
order by Qty desc

