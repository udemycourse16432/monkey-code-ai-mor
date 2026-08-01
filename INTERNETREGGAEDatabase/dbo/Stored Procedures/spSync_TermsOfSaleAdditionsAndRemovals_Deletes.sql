





-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spSync_TermsOfSaleAdditionsAndRemovals_Deletes]

@counter int

AS

delete TermsOfSaleAdditionsAndRemovals where counter=@counter





