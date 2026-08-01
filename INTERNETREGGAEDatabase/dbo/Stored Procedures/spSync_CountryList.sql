






-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spSync_CountryList]

 @counter int
,@CountryText nvarchar(100)
,@Country nvarchar(100)
,@StateProvince nvarchar(100)
,@SortOrderText nvarchar(100)
,@City nvarchar(100)

AS

if exists (select counter from CountryList where counter=@counter)
 begin
  update CountryList set
   CountryText=@CountryText
  ,Country=@Country
  ,StateProvince=@StateProvince 
  ,SortOrderText=@SortOrderText 
  ,City=@City 
  where counter=@counter
 end
else
 begin
  insert into CountryList
   (counter
   ,CountryText 
   ,Country 
   ,StateProvince 
   ,SortOrderText 
   ,City)
  values
   (@counter
   ,@CountryText 
   ,@Country 
   ,@StateProvince 
   ,@SortOrderText 
   ,@City)
 end







