






CREATE PROCEDURE [dbo].[spMarkOrderAsCanceled]
@OrderNumber nvarchar(15)
AS

update Orders
set Status='canceled'
where OrderNumber=@OrderNumber












