CREATE TABLE [dbo].[TermsOfSaleAdditionsAndRemovals] (
    [counter]     INT          IDENTITY (1, 1) NOT NULL,
    [Type]        INT          NOT NULL,
    [CustID]      INT          NOT NULL,
    [AddOrRemove] NVARCHAR (8) NOT NULL,
    [DateTime]    DATETIME     NOT NULL
);


GO
CREATE CLUSTERED INDEX [IX_CustID]
    ON [dbo].[TermsOfSaleAdditionsAndRemovals]([CustID] ASC);

