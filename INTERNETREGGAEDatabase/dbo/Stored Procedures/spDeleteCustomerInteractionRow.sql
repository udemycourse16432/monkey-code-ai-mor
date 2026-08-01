


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spDeleteCustomerInteractionRow]

@Counter int
,@JavascriptRandomNumber int

AS

delete CustomerInteraction
where counter=@Counter and JavascriptRandomNumber=@JavascriptRandomNumber
