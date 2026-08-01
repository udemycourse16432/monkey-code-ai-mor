













-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spInsertSearchCriteriaStatistics]

 @PowerUserName nvarchar(10)
,@IPAddress nvarchar(50)
,@SessionID nvarchar(50)
,@UserAgentString nvarchar(200)
,@QueryType nvarchar(50)
,@ArtistTitle nvarchar(50)
,@Format nvarchar(10)
,@HowRecent nvarchar(20)
,@YearRange nvarchar(20)
,@PriceRange nvarchar(20)
,@Genre nvarchar(30)
,@Label nvarchar(120)
,@NewOrUsed nvarchar(10)
,@SortOrder nvarchar(20)
,@NumberOfRecords int
,@PageOn smallint
,@DisplayType nvarchar(15)
,@ArtistSelected nvarchar(100)
,@LabelSelected nvarchar(100)
,@GenreSelected nvarchar(30)
,@SearchTypeDescription nvarchar(255)
,@SearchID nvarchar(50)
,@CustomerID nvarchar(50)
,@CustomerServerCounter int
,@AllArtist nvarchar(100)
,@AllLabel nvarchar(100)
,@AllRhythm nvarchar(100)
,@AllGenre nvarchar(100)
,@HTTP_REFERER nvarchar(300)
,@REMOTE_HOST nvarchar(300)
,@ButtonColor nvarchar(15)
,@FromOurSite nvarchar(1)
AS

insert SearchCriteriaStatistics
([DateTime]
,PowerUserName
,IPAddress
,SessionID
,UserAgentString
,QueryType
,ArtistTitle
,Format
,HowRecent
,YearRange
,PriceRange
,Genre
,Label
,NewOrUsed
,SortOrder
,NumberOfRecords
,PageOn
,DisplayType
,ArtistSelected
,LabelSelected
,GenreSelected
,SearchTypeDescription
,SearchID
,CustomerID
,CustomerServerCounter
,AllArtist
,Alllabel
,AllRhythm
,AllGenre
,HTTP_REFERER
,REMOTE_HOST
,ButtonColor
,FromOurSite
)

values

(GetDate()
,@PowerUserName
,@IPAddress
,@SessionID
,@UserAgentString
,@QueryType
,@ArtistTitle
,@Format
,@HowRecent
,@YearRange
,@PriceRange
,@Genre
,@Label
,@NewOrUsed
,@SortOrder
,@NumberOfRecords
,@PageOn
,@DisplayType
,@ArtistSelected
,@LabelSelected
,@GenreSelected
,@SearchTypeDescription
,@SearchID
,@CustomerID
,@CustomerServerCounter
,@AllArtist
,@Alllabel
,@AllRhythm
,@AllGenre
,@HTTP_REFERER
,@REMOTE_HOST
,@ButtonColor
,@FromOurSite

)


--Customers Table

update Customers
set DateOfLastSearch=GetDate()
where counter=@CustomerServerCounter










