-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE spInsertCreditCardInfo

 @LogInEmail nvarchar(100)
,@Password nvarchar(50)
,@PriceGroup nvarchar(30)
,@FullName nvarchar(150)
,@StreetAddress1 nvarchar(150)
,@CreditCardNumber nvarchar(128)
,@CustomerID nvarchar(50)
,@CustomerServerCounter int
,@SpecialNote varchar(2000)
,@ExpDate nvarchar(10)


AS

insert into CreditCardInfo
(LogInEmail
,Password
,PriceGroup
,[DateTime]
,FullName
,StreetAddress1
,CreditCardNumber
,CustomerID
,CustomerServerCounter
,SpecialNote
,ExpDate)
values (
 @LogInEmail
,@Password
,@PriceGroup
,getdate()
,@FullName
,@StreetAddress1
,@CreditCardNumber
,@CustomerID
,@CustomerServerCounter
,@SpecialNote
,@ExpDate)


