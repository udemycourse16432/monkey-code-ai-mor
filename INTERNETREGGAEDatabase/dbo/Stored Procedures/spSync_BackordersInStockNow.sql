





-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spSync_BackordersInStockNow]

 @counter int
,@CustomerID int
,@BackorderInventoryID int
,@BackorderQuantity int
,@DateOrdered smalldatetime
,@PONumber nvarchar(50)


AS

if exists (select counter from BackordersInStockNow where counter=@counter)
 begin
  update BackordersInStockNow set
   CustomerID=@CustomerID
  ,BackorderInventoryID=@BackorderInventoryID
  ,BackorderQuantity=@BackorderQuantity
  ,DateOrdered=@DateOrdered
  ,PONumber=@PONumber
 where counter=@counter
 end
else
 begin
  insert into BackordersInStockNow
   (counter
   ,CustomerID
   ,BackorderInventoryID 
   ,BackorderQuantity 
   ,DateOrdered 
   ,PONumber) 
  values
   (@counter
   ,@CustomerID
   ,@BackorderInventoryID 
   ,@BackorderQuantity 
   ,@DateOrdered 
   ,@PONumber) 
 end






