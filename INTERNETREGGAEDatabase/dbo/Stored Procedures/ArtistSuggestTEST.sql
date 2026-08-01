
create PROCEDURE [dbo].[ArtistSuggestTEST]

 @FromRow int
,@ToRow int
,@Text1 nvarchar(50)
,@Text2 nvarchar(50)
,@Text3 nvarchar(50)
,@Text4 nvarchar(50)
,@Text5 nvarchar(50)
,@Text6 nvarchar(50)
,@Text7 nvarchar(50)
,@Text8 nvarchar(50)
,@Text9 nvarchar(50)
,@Text10 nvarchar(50)

AS

select * from (

 select Row_Number() over(order by SortOrder,total desc,SalesLast30Days desc,Hint) row_num
 ,Hint,Total,CD,Vinyl,Other,SearchType,ScanPath,counter
 from WebSearchSuggestionsTEST
 where (Word1 like @Text1
 or Word2 like @Text1
 or Word3 like @Text1
 or Word4 like @Text1
 or Word5 like @Text1
 or Word6 like @Text1
 or Word7 like @Text1
 or Word8 like @Text1
 or Word9 like @Text1
 or Word10 like @Text1
 or Word11 like @Text1
 or Word12 like @Text1
 or Word13 like @Text1
 or Word14 like @Text1
 or Word15 like @Text1
 or Word16 like @Text1
 or Word17 like @Text1
 or Word18 like @Text1
 or Word19 like @Text1
 or Word20 like @Text1)

 and (Word1 like @Text2
 or Word2 like @Text2
 or Word3 like @Text2
 or Word4 like @Text2
 or Word5 like @Text2
 or Word6 like @Text2
 or Word7 like @Text2
 or Word8 like @Text2
 or Word9 like @Text2
 or Word10 like @Text2
 or Word11 like @Text2
 or Word12 like @Text2
 or Word13 like @Text2
 or Word14 like @Text2
 or Word15 like @Text2
 or Word16 like @Text2
 or Word17 like @Text2
 or Word18 like @Text2
 or Word19 like @Text2
 or Word20 like @Text2)

 and (Word1 like @Text3
 or Word2 like @Text3
 or Word3 like @Text3
 or Word4 like @Text3
 or Word5 like @Text3
 or Word6 like @Text3
 or Word7 like @Text3
 or Word8 like @Text3
 or Word9 like @Text3
 or Word10 like @Text3
 or Word11 like @Text3
 or Word12 like @Text3
 or Word13 like @Text3
 or Word14 like @Text3
 or Word15 like @Text3
 or Word16 like @Text3
 or Word17 like @Text3
 or Word18 like @Text3
 or Word19 like @Text3
 or Word20 like @Text3)

 and (Word1 like @Text4
 or Word2 like @Text4
 or Word3 like @Text4
 or Word4 like @Text4
 or Word5 like @Text4
 or Word6 like @Text4
 or Word7 like @Text4
 or Word8 like @Text4
 or Word9 like @Text4
 or Word10 like @Text4
 or Word11 like @Text4
 or Word12 like @Text4
 or Word13 like @Text4
 or Word14 like @Text4
 or Word15 like @Text4
 or Word16 like @Text4
 or Word17 like @Text4
 or Word18 like @Text4
 or Word19 like @Text4
 or Word20 like @Text4)

 and (Word1 like @Text5
 or Word2 like @Text5
 or Word3 like @Text5
 or Word4 like @Text5
 or Word5 like @Text5
 or Word6 like @Text5
 or Word7 like @Text5
 or Word8 like @Text5
 or Word9 like @Text5
 or Word10 like @Text5
 or Word11 like @Text5
 or Word12 like @Text5
 or Word13 like @Text5
 or Word14 like @Text5
 or Word15 like @Text5
 or Word16 like @Text5
 or Word17 like @Text5
 or Word18 like @Text5
 or Word19 like @Text5
 or Word20 like @Text5)

 and (Word1 like @Text6
 or Word2 like @Text6
 or Word3 like @Text6
 or Word4 like @Text6
 or Word5 like @Text6
 or Word6 like @Text6
 or Word7 like @Text6
 or Word8 like @Text6
 or Word9 like @Text6
 or Word10 like @Text6
 or Word11 like @Text6
 or Word12 like @Text6
 or Word13 like @Text6
 or Word14 like @Text6
 or Word15 like @Text6
 or Word16 like @Text6
 or Word17 like @Text6
 or Word18 like @Text6
 or Word19 like @Text6
 or Word20 like @Text6)

 and (Word1 like @Text7
 or Word2 like @Text7
 or Word3 like @Text7
 or Word4 like @Text7
 or Word5 like @Text7
 or Word6 like @Text7
 or Word7 like @Text7
 or Word8 like @Text7
 or Word9 like @Text7
 or Word10 like @Text7
 or Word11 like @Text7
 or Word12 like @Text7
 or Word13 like @Text7
 or Word14 like @Text7
 or Word15 like @Text7
 or Word16 like @Text7
 or Word17 like @Text7
 or Word18 like @Text7
 or Word19 like @Text7
 or Word20 like @Text7)

 and (Word1 like @Text8
 or Word2 like @Text8
 or Word3 like @Text8
 or Word4 like @Text8
 or Word5 like @Text8
 or Word6 like @Text8
 or Word7 like @Text8
 or Word8 like @Text8
 or Word9 like @Text8
 or Word10 like @Text8
 or Word11 like @Text8
 or Word12 like @Text8
 or Word13 like @Text8
 or Word14 like @Text8
 or Word15 like @Text8
 or Word16 like @Text8
 or Word17 like @Text8
 or Word18 like @Text8
 or Word19 like @Text8
 or Word20 like @Text8)

 and (Word1 like @Text9
 or Word2 like @Text9
 or Word3 like @Text9
 or Word4 like @Text9
 or Word5 like @Text9
 or Word6 like @Text9
 or Word7 like @Text9
 or Word8 like @Text9
 or Word9 like @Text9
 or Word10 like @Text9
 or Word11 like @Text9
 or Word12 like @Text9
 or Word13 like @Text9
 or Word14 like @Text9
 or Word15 like @Text9
 or Word16 like @Text9
 or Word17 like @Text9
 or Word18 like @Text9
 or Word19 like @Text9
 or Word20 like @Text9)

 and (Word1 like @Text10
 or Word2 like @Text10
 or Word3 like @Text10
 or Word4 like @Text10
 or Word5 like @Text10
 or Word6 like @Text10
 or Word7 like @Text10
 or Word8 like @Text10
 or Word9 like @Text10
 or Word10 like @Text10
 or Word11 like @Text10
 or Word12 like @Text10
 or Word13 like @Text10
 or Word14 like @Text10
 or Word15 like @Text10
 or Word16 like @Text10
 or Word17 like @Text10
 or Word18 like @Text10
 or Word19 like @Text10
 or Word20 like @Text10)

) x

where row_num between @FromRow and @ToRow






















