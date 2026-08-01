




-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spCheckIfPasswordExists]

@Password nvarchar(50)

AS

select Password from Customers
where Password =@Password




