

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spGetCartItemsForPurchase]

 @CartName nvarchar(60)

AS

select * from Carts
where CartName=@CartName
and SaveForLater is null
