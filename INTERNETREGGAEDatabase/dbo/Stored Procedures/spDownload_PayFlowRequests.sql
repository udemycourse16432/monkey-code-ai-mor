














CREATE PROCEDURE [dbo].[spDownload_PayFlowRequests]

AS

select top 1 
 counter
,Status
,UserAgent
,Request_TRXTYPE
,Request_TENDER
,Request_EXPDATE
,REQUEST_Amt
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
,Response_PNREF
,Response_PPREF
,Response_RESULT
,Response_CVV2MATCH
,Response_RESPMSG
,Response_DUPLICATE
,Response_PROCAVS
,WebOrderNumber
,CustomerID
,VBNETPostType
,[DateTime]
,RightFour


from PayFlowRequests where InSync='n' order  by counter












