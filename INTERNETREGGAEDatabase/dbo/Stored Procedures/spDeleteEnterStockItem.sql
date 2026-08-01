





-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spDeleteEnterStockItem] 

 @counter int

AS


delete EnterStock where counter=@counter






