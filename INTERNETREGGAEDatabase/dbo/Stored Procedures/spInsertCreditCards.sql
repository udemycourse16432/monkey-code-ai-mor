


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spInsertCreditCards] 

 @ExpirationDate nvarchar(6)
,@RightFour nvarchar(4)
,@Account varchar(25)
,@CVV2 nvarchar(4)
,@CustomerServerCounter int
,@WebOrderNumber nvarchar(20)
,@EncryptionKey varchar(100)

AS


insert into CreditCards
(ExpirationDate
,RightFour
,Account
,CVV2
,CustomerServerCounter
,WebOrderNumber)
values
(@ExpirationDate
,@RightFour
,EncryptByPassphrase(@EncryptionKey,@Account)
,EncryptByPassphrase(@EncryptionKey,@CVV2)
,@CustomerServerCounter
,@WebOrderNumber)



