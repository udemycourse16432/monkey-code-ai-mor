





create PROCEDURE [dbo].[spPayFlowRequests_Update_Answer]

(@Status nvarchar(50)
,@Response_PNREF nvarchar(20)
,@Response_PPREF nvarchar(25)
,@Response_RESULT int
,@Response_CVV2MATCH nvarchar(1)
,@Response_RESPMSG nvarchar(max)
,@Response_DUPLICATE smallint
,@Response_PROCAVS nvarchar(10)
,@VBNETPostType nvarchar(10)
,@Counter int)

AS
BEGIN

Update PayFlowRequests

Set

Status=@Status
,Response_PNREF=@Response_PNREF
,Response_PPREF=@Response_PPREF
,Response_RESULT=@Response_RESULT
,Response_CVV2MATCH=@Response_CVV2MATCH
,Response_RESPMSG=@Response_RESPMSG
,Response_DUPLICATE=@Response_DUPLICATE
,Response_PROCAVS=@Response_PROCAVS
,VBNETPostType=@VBNETPostType
,InSync='n'
where counter=@Counter

END

