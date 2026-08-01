




-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spGetEnterStockRowFromRandomNumberID]

 @RandomNumberID nvarchar(50)

AS

select * from EnterStock where RandomNumberID=@RandomNumberID