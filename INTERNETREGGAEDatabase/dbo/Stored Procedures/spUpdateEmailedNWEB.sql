



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spUpdateEmailedNWEB]

 @counter int

AS

UPDATE customers
SET emailedNWEB='yes'
WHERE counter=@counter
