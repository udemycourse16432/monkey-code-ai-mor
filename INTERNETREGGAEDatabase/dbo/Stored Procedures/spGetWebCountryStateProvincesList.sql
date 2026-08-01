



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spGetWebCountryStateProvincesList]

@Country nvarchar(100)
AS

select * from WebCountryStateProvincesList
where Country=@Country
order by StateProvince



