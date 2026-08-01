


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spGetCountryInfoFromCounter]

@counter int

AS

select * from CountryList
where [counter] =@counter


