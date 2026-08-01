






-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spSync_WebCountryStateProvincesList]

 @counter int
,@Country nvarchar(100)
,@StateProvince nvarchar(100)
,@StateProvinceAbbreviation nvarchar(50)

AS

if exists (select counter from WebCountryStateProvincesList where counter=@counter)
 begin
  update WebCountryStateProvincesList set
   Country=@Country
  ,StateProvince=@StateProvince
  ,StateProvinceAbbreviation=@StateProvinceAbbreviation
  where counter=@counter
 end
else
 begin
  insert into WebCountryStateProvincesList
   (counter
   ,Country
   ,StateProvince
   ,StateProvinceAbbreviation)
  values
   (@counter
   ,@Country
   ,@StateProvince
   ,@StateProvinceAbbreviation)
 end







