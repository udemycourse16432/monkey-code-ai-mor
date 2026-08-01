
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spGetCartItems]

 @CartName nvarchar(60)

AS

select * from Carts
where CartName=@CartName
