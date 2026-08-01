



CREATE PROCEDURE [dbo].[spHTTPDownloadDataOK]

@counter nvarchar(10),
@TableName nvarchar(100)

AS

declare @SQL1 nvarchar(1000)
set @SQL1="update "+@TableName+" set DownloadGroup=100000 where counter="+@counter
EXEC (@SQL1)

if @TableName='Orders'
 Begin
  set @SQL1="update "+@TableName+" set CreditCardNumber=right(CreditCardNumber,4) where counter="+@counter+" and CreditCardNumber is not null"
  EXEC (@SQL1)
 End

