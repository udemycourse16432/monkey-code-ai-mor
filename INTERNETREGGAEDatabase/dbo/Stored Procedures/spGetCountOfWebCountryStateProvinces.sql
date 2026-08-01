

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spGetCountOfWebCountryStateProvinces]

@Country nvarchar(100)
AS

select count(*) as ccc from WebCountryStateProvincesList
where country=@Country

