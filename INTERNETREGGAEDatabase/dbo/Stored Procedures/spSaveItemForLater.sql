


create PROCEDURE [dbo].[spSaveItemForLater]
 @ID int
,@SaveForLater int
,@CartName nvarchar(60)

AS

 if @SaveForLater=1
  BEGIN
   update Carts Set SaveForLater='y'
   where CartName=@CartName
   and ItemID=@ID
  END 
 else 
  BEGIN
   update Carts Set SaveForLater=null
   where CartName=@CartName
   and ItemID=@ID
  END 


