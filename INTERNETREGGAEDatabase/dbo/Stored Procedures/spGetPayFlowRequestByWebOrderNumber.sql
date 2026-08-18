-- =============================================
-- Looks up the persisted PayFlow request row for a web order number.
-- Used by the PayPal webhook (POST /api/paypal/webhook) to reconcile an
-- abandoned-browser capture: it supplies the customer server counter,
-- the server-computed expected total (Request_AMT) for the C1 amount
-- verification, the selected shipping code (Request_COMMENT2) and the
-- client context (UserAgent / Request_CUSTIP) that are otherwise only
-- available in the lost browser session.
-- =============================================
CREATE PROCEDURE [dbo].[spGetPayFlowRequestByWebOrderNumber]
    @WebOrderNumber nvarchar(20)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP 1
        counter,
        Status,
        UserAgent,
        Request_EXPDATE,
        Request_AMT,
        Request_CUSTIP,
        Request_COMMENT2,
        WebOrderNumber,
        CustomerID,
        RightFour
    FROM [dbo].[PayFlowRequests]
    WHERE WebOrderNumber = @WebOrderNumber
    ORDER BY counter DESC;
END
