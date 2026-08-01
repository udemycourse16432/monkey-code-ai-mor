



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spTermsOfSaleTypesAdditions]

@CustID int

AS

select [Type] from TermsOfSaleAdditionsAndRemovals
where CustID=@CustID and upper(AddOrRemove)='ADD'


