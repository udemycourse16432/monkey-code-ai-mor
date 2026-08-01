

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spGetPayPalPaymentStatus]

@OrderNumber nvarchar(15)

AS

select PayPalPaymentStatus,Status,DownloadGroup from Orders
where OrderNumber=@OrderNumber

