
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].spDeleteSavedRetailCart

@CartPassword nvarchar(50)
,@Email nvarchar(100) 

AS

delete from WebSavedRetailCarts
where CartPassword=@CartPassword
and Email=@Email

