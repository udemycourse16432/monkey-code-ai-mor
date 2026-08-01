

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spGetTermsOfSaleTypesRow]

 @Type int

AS

select * from TermsOfSaleTypes where Type=@Type
