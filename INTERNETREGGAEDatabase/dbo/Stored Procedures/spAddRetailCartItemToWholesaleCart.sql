


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spAddRetailCartItemToWholesaleCart]

 @CartName nvarchar(60)
,@ItemID int
,@Quantity int
,@WholesalePrice smallmoney
,@SearchCriteriaStatisticsID nvarchar(50)
,@IPAddress nvarchar(20)

AS

if exists (select ItemID from Carts
where ItemID=@ItemID and CartName=@CartName)

 begin
  update Carts
  set quantity = quantity+@Quantity
  ,price= @WholesalePrice
  ,[DateTime]=getdate()
  where ItemID=@ItemID and CartName=@CartName
 end
else
 begin
  insert Carts
  (Cartname
  ,ItemID
  ,Price
  ,quantity
  ,[DateTime]
  ,SearchCriteriaStatisticsID
  ,IPAddress)
  values
  (@CartName
  ,@ItemID
  ,@WholesalePrice
  ,@Quantity
  ,getdate()
  ,@SearchCriteriaStatisticsID
  ,@IPAddress)
 end

