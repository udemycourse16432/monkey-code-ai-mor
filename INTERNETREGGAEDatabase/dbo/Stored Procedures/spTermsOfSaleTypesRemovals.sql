




-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spTermsOfSaleTypesRemovals]

@CustID int

AS

select [Type],AddOrRemove from TermsOfSaleAdditionsAndRemovals
where CustID=@CustID
order by Type, counter desc



