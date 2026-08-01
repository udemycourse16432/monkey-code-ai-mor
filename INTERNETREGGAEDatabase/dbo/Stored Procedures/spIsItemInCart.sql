

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spIsItemInCart]

 @NameOfCart nvarchar(60)
,@ItemID int

AS

select Quantity,Price,DateTime from Carts where ItemID =@ItemID and CartName=@NameOfCart
