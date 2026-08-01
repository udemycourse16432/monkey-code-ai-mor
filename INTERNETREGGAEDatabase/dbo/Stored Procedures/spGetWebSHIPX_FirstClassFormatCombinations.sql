
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].spGetWebSHIPX_FirstClassFormatCombinations

 @NumberOf7Inchs int
,@NumberOfDVDs int
,@NumberOfCDs int

AS

select * from webSHIPX_FirstClassFormatCombinations
where NumberOf7Inchs=@NumberOf7Inchs
and NumberOfDVDs=@NumberOfDVDs
and NumberOfCDs=@NumberOfCDs