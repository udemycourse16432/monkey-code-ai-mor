
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].spInsertOrderCorrectionNote

 @OrderNumber nvarchar(50)
,@Email nvarchar(150)
,@CustomerName nvarchar(300)
,@LogInEmail nvarchar(100)
,@Password nvarchar(50)
,@CustomerID nvarchar(50)
,@CustomerServerCounter int
,@CorrectionNote varchar(5000)
,@DateTimeOrdered datetime

AS

insert OrderCorrectionNotes
(OrderNumber
,Email
,CustomerName
,LogInEmail
,Password 
,CustomerID
,CustomerServerCounter
,CorrectionNote
,DateTimeOrdered)
values
(@OrderNumber
,@Email
,@CustomerName
,@LogInEmail
,@Password 
,@CustomerID
,@CustomerServerCounter
,@CorrectionNote
,@DateTimeOrdered)

