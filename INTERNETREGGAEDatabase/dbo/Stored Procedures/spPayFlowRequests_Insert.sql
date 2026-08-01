









CREATE PROCEDURE [dbo].[spPayFlowRequests_Insert]

(@EncryptionKey varchar(100)
,@Status nvarchar(20)
,@UserAgent nvarchar(300)
,@Request_TRXTYPE nvarchar(1)
,@Request_TENDER nvarchar(1)
,@Request_ACCT varchar(25)
,@Request_EXPDATE nvarchar(6)
,@Request_AMT numeric(9,2)
,@Request_CVV2 nvarchar(4)
,@Request_BILLTOFIRSTNAME nvarchar(30)
,@Request_BILLTOLASTNAME nvarchar(30)
,@Request_BILLTOSTREET nvarchar(30)
,@Request_BILLTOSTREET2 nvarchar(30)
,@Request_BILLTOCITY nvarchar(20)
,@Request_BILLTOSTATE nvarchar(2)
,@Request_BILLTOZIP nvarchar(9)
,@Request_BILLTOCOUNTRY nvarchar(3)
,@Request_CUSTIP nvarchar(20)
,@Request_ORDERID nvarchar(100)
,@Request_COMMENT1 nvarchar(128)
,@Request_COMMENT2 nvarchar(128)
,@WebOrderNumber nvarchar(20)
,@CustomerID int
,@RightFour nvarchar(4)
,@IV nvarchar(50)
,@CounterOUTPUT int OUTPUT)

AS
BEGIN

Insert into PayFlowRequests
(Status
,UserAgent
,Request_TRXTYPE
,Request_TENDER
,Request_ACCT
,Request_EXPDATE
,Request_AMT
,Request_CVV2
,Request_BILLTOFIRSTNAME
,Request_BILLTOLASTNAME
,Request_BILLTOSTREET
,Request_BILLTOSTREET2
,Request_BILLTOCITY
,Request_BILLTOSTATE
,Request_BILLTOZIP
,Request_BILLTOCOUNTRY
,Request_CUSTIP
,Request_ORDERID
,Request_COMMENT1
,Request_COMMENT2
,WebOrderNumber
,CustomerID
,RightFour
,IV)

values

(@Status
,@UserAgent
,@Request_TRXTYPE
,@Request_TENDER
,EncryptByPassphrase(@EncryptionKey,@Request_ACCT)
,@Request_EXPDATE
,@Request_AMT
,EncryptByPassphrase(@EncryptionKey,@Request_CVV2)
,@Request_BILLTOFIRSTNAME
,@Request_BILLTOLASTNAME
,@Request_BILLTOSTREET
,@Request_BILLTOSTREET2
,@Request_BILLTOCITY
,@Request_BILLTOSTATE
,@Request_BILLTOZIP
,@Request_BILLTOCOUNTRY
,@Request_CUSTIP
,@Request_ORDERID
,@Request_COMMENT1
,@Request_COMMENT2
,@WebOrderNumber
,@CustomerID
,@RightFour
,@IV)

select @CounterOUTPUT = SCOPE_IDENTITY()
select @CounterOUTPUT as counter
END






