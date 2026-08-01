CREATE TABLE [dbo].[PayFlowRequests] (
    [counter]                 INT             IDENTITY (1, 1) NOT NULL,
    [Status]                  NVARCHAR (50)   NULL,
    [UserAgent]               NVARCHAR (300)  NULL,
    [Request_TRXTYPE]         NVARCHAR (1)    NULL,
    [Request_TENDER]          NVARCHAR (1)    NULL,
    [Request_ACCT]            VARBINARY (MAX) NULL,
    [Request_EXPDATE]         NVARCHAR (6)    NULL,
    [Request_AMT]             NUMERIC (9, 2)  NULL,
    [Request_CVV2]            VARBINARY (MAX) NULL,
    [Request_BILLTOFIRSTNAME] NVARCHAR (30)   NULL,
    [Request_BILLTOLASTNAME]  NVARCHAR (30)   NULL,
    [Request_BILLTOSTREET]    NVARCHAR (30)   NULL,
    [Request_BILLTOSTREET2]   NVARCHAR (30)   NULL,
    [Request_BILLTOCITY]      NVARCHAR (20)   NULL,
    [Request_BILLTOSTATE]     NVARCHAR (2)    NULL,
    [Request_BILLTOZIP]       NVARCHAR (9)    NULL,
    [Request_BILLTOCOUNTRY]   NVARCHAR (3)    NULL,
    [Request_CUSTIP]          NVARCHAR (20)   NULL,
    [Request_ORDERID]         NVARCHAR (100)  NULL,
    [Request_COMMENT1]        NVARCHAR (128)  NULL,
    [Request_COMMENT2]        NVARCHAR (128)  NULL,
    [Response_PNREF]          NVARCHAR (20)   NULL,
    [Response_PPREF]          NVARCHAR (25)   NULL,
    [Response_RESULT]         INT             NULL,
    [Response_CVV2MATCH]      NVARCHAR (1)    NULL,
    [Response_RESPMSG]        NVARCHAR (MAX)  NULL,
    [Response_DUPLICATE]      SMALLINT        NULL,
    [Response_PROCAVS]        NVARCHAR (10)   NULL,
    [WebOrderNumber]          NVARCHAR (20)   NULL,
    [CustomerID]              INT             NULL,
    [VBNETPostType]           NVARCHAR (10)   NULL,
    [DateTime]                DATETIME        CONSTRAINT [DF_PayFlowRequests_DateTime] DEFAULT (getdate()) NULL,
    [RightFour]               NVARCHAR (4)    NULL,
    [IV]                      NVARCHAR (50)   NULL,
    [InSync]                  CHAR (1)        CONSTRAINT [DF_PayFlowRequests_InSync] DEFAULT ('n') NULL,
    CONSTRAINT [PK_PayFlowRequests] PRIMARY KEY CLUSTERED ([counter] ASC)
);


GO
create TRIGGER [PayFlowRequests_UpdateTrigger]
   ON  dbo.PayFlowRequests 
   for UPDATE
AS 
 Update PayFlowRequests
  set InSync='n'
 where counter in (select deleted.counter from deleted
  where InSync='y')
