


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].spResidentialDelivery

 @counter int


AS

select ResidentialDelivery from Customers" _
   & " where [counter] =@counter
