







-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spSync_WebSHIPX_Packaging_Weight_2]

 @counter int
,@ItemWeight int
,@PackagingWeight int
,@PackageDescription nvarchar(50)

AS

if exists (select counter from WebSHIPX_Packaging_Weight_2 where counter=@counter)
 begin
  update WebSHIPX_Packaging_Weight_2 set
   ItemWeight=@ItemWeight
  ,PackagingWeight=@PackagingWeight
  ,PackageDescription=@PackageDescription 
  where counter=@counter
 end
else
 begin
  insert into WebSHIPX_Packaging_Weight_2
   (counter
   ,ItemWeight 
   ,PackagingWeight 
   ,PackageDescription)
  values
   (@counter
   ,@ItemWeight 
   ,@PackagingWeight 
   ,@PackageDescription) 
 end








