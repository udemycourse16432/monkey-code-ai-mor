


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].spSeeIfOrderNumberExists

@OrderNumber nvarchar(15)

AS

select OrderNumber from Orders where OrderNumber=@OrderNumber

