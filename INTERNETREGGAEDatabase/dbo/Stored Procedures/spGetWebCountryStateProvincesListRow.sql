
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spGetWebCountryStateProvincesListRow]

@Country nvarchar(100)
,@StateProvince nvarchar(100)
AS

select * from WebCountryStateProvincesList
where Country=@Country and StateProvince=@StateProvince
