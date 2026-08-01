





-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spSync_CountryList_Deletes]

@counter int

AS

delete CountryList where counter=@counter





