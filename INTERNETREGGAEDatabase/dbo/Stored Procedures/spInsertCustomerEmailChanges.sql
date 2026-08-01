


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spInsertCustomerEmailChanges]

 @CustomerID int
,@CustomerServerCounter int
,@OldEmail nvarchar(100)
,@NewEmail nvarchar(100)

AS

insert CustomerEmailChanges
(CustomerID
,CustomerServerCounter
,OldEmail
,NewEmail)
values
(@CustomerID
,@CustomerServerCounter
,@OldEmail
,@NewEmail)



