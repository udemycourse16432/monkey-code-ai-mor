CREATE PROCEDURE [dbo].[spUpdateItemFeaturesForInventoryID]
  @InventoryID int,
  @ItemFeature1 nvarchar(max),
  @ItemFeature2 nvarchar(max),
  @ItemFeature3 nvarchar(max),
  @ItemFeature4 nvarchar(max),
  @ItemFeature5 nvarchar(max),
  @ItemFeature6 nvarchar(max),
  @ItemFeature7 nvarchar(max),
  @ItemFeature8 nvarchar(max),
  @ItemFeature9 nvarchar(max),
  @ItemFeature10 nvarchar(max)
AS

if @ItemFeature1='' set @ItemFeature1=null
if @ItemFeature2='' set @ItemFeature2=null
if @ItemFeature3='' set @ItemFeature3=null
if @ItemFeature4='' set @ItemFeature4=null
if @ItemFeature5='' set @ItemFeature5=null
if @ItemFeature6='' set @ItemFeature6=null
if @ItemFeature7='' set @ItemFeature7=null
if @ItemFeature8='' set @ItemFeature8=null
if @ItemFeature9='' set @ItemFeature9=null
if @ItemFeature10='' set @ItemFeature10=null

if EXISTS (
  SELECT 1 from Inventory where
  ID = @InventoryID and (
    ItemFeatures1<>@ItemFeature1 or (ItemFeatures1 is null and @ItemFeature1 is not null) or (ItemFeatures1 is not null and @ItemFeature1 is null) or
    ItemFeatures2<>@ItemFeature2 or (ItemFeatures2 is null and @ItemFeature2 is not null) or (ItemFeatures2 is not null and @ItemFeature2 is null) or
    ItemFeatures3<>@ItemFeature3 or (ItemFeatures3 is null and @ItemFeature3 is not null) or (ItemFeatures3 is not null and @ItemFeature3 is null) or
    ItemFeatures4<>@ItemFeature4 or (ItemFeatures4 is null and @ItemFeature4 is not null) or (ItemFeatures4 is not null and @ItemFeature4 is null) or
    ItemFeatures5<>@ItemFeature5 or (ItemFeatures5 is null and @ItemFeature5 is not null) or (ItemFeatures5 is not null and @ItemFeature5 is null) or
    ItemFeatures6<>@ItemFeature6 or (ItemFeatures6 is null and @ItemFeature6 is not null) or (ItemFeatures6 is not null and @ItemFeature6 is null) or
    ItemFeatures7<>@ItemFeature7 or (ItemFeatures7 is null and @ItemFeature7 is not null) or (ItemFeatures7 is not null and @ItemFeature7 is null) or
    ItemFeatures8<>@ItemFeature8 or (ItemFeatures8 is null and @ItemFeature8 is not null) or (ItemFeatures8 is not null and @ItemFeature8 is null) or
    ItemFeatures9<>@ItemFeature9 or (ItemFeatures9 is null and @ItemFeature9 is not null) or (ItemFeatures9 is not null and @ItemFeature9 is null) or
    ItemFeatures10<>@ItemFeature10 or (ItemFeatures10 is null and @ItemFeature10 is not null) or (ItemFeatures10 is not null and @ItemFeature10 is null)
  )
) BEGIN
  update Inventory set
    ItemFeatures1=@ItemFeature1,
    ItemFeatures2=@ItemFeature2,
    ItemFeatures3=@ItemFeature3,
    ItemFeatures4=@ItemFeature4,
    ItemFeatures5=@ItemFeature5,
    ItemFeatures6=@ItemFeature6,
    ItemFeatures7=@ItemFeature7,
    ItemFeatures8=@ItemFeature8,
    ItemFeatures9=@ItemFeature9,
    ItemFeatures10=@ItemFeature10
  where ID=@InventoryID
END