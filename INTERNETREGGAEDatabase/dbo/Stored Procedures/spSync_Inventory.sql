


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spSync_Inventory]

 @ID int
,@ArtistTitle nvarchar(350)
,@Label nvarchar(120)
,@RetailPrice smallmoney
,@Inventory int
,@Format nvarchar(7)
,@InStockDate datetime
,@RhythmName nvarchar(400)
,@YearFrom nvarchar(30)
,@YearTo nvarchar(30)
,@StorePrice smallmoney
,@BackInStockDate datetime
,@ProduceGroup nvarchar(max)
,@MusicianGroup nvarchar(max)
,@TracksGroup nvarchar(max)
,@Catalog nvarchar(30)
,@FormatOrder int
,@ExportPrice smallmoney
,@WebEssential nvarchar(1)
,@WebReviewHTML nvarchar(max)
,@Cutout nvarchar(1)
,@WeightInGrams decimal(18,2)
,@NumberOfTracks int
,@Deleted nvarchar(1)
,@Cost smallmoney
,@MP3FileCompleted nvarchar(1)
,@UsedItem nvarchar(1)
,@ConditionJacket nvarchar(3)
,@ConditionVinylOrCD nvarchar(3)
,@ConditionNotes nvarchar(max)
,@MP3SoundGroup int
,@DateAdded datetime
,@Genre1 nvarchar(30)
,@Genre2 nvarchar(30)
,@Genre3 nvarchar(30)
,@Genre4 nvarchar(30)
,@Genre5 nvarchar(30)
,@Genre6 nvarchar(30)
,@Genre7 nvarchar(30)
,@Genre8 nvarchar(30)
,@Genre9 nvarchar(30)
,@UPC nvarchar(50)
,@ItemDetailsWeb nvarchar(100)
,@ItemDetailsWebProductDetails nvarchar(255)
,@Sale_RetailPrice numeric(5,2)
,@Sale_RetailEndDate datetime
,@Sale_RetailFootnoteText nvarchar(255)
,@Sale_RetailItemDetailsText nvarchar(255)
,@Sale_WholesalePrice numeric(5,2)
,@Sale_WholesaleEndDate datetime
,@Sale_WholesaleFootnoteText nvarchar(255)
,@Sale_WholesaleItemDetailsText nvarchar(255)
,@ItemFootnoteText nvarchar(255)
,@SupplierID int
,@StreetDate datetime
,@ShowOnWebsite nvarchar(1)
,@ConditionText nvarchar(max)
,@KirbyItem nvarchar(1)
,@KirbysCut numeric(6,2)
,@KirbyCost numeric(6,2)


AS

BEGIN TRY

BEGIN TRANSACTION Z


if exists (select ID from Inventory where ID=@ID)
 begin
  update Inventory set
   ArtistTitle=@ArtistTitle
  ,Label=@Label
  ,RetailPrice=@RetailPrice
  ,Inventory=@Inventory
  ,[Format]=@Format
  ,InStockDate=@InStockDate
  ,RhythmName=@RhythmName
  ,YearFrom=@YearFrom
  ,YearTo=@YearTo
  ,StorePrice=@StorePrice
  ,BackInStockDate=@BackInStockDate
  ,ProduceGroup=@ProduceGroup
  ,MusicianGroup=@MusicianGroup
  ,TracksGroup=@TracksGroup
  ,[Catalog]=@Catalog
  ,FormatOrder=@FormatOrder
  ,ExportPrice=@ExportPrice
  ,WebEssential=@WebEssential
  ,WebReviewHTML=@WebReviewHTML
  ,Cutout=@Cutout
  ,WeightInGrams=@WeightInGrams
  ,NumberOfTracks=@NumberOfTracks
  ,Deleted=@Deleted
  ,Cost=@Cost
  ,MP3FileCompleted=@MP3FileCompleted
  ,UsedItem=@UsedItem
  ,ConditionJacket=@ConditionJacket
  ,ConditionVinylOrCD=@ConditionVinylOrCD
  ,ConditionNotes=@ConditionNotes
  ,MP3SoundGroup=@MP3SoundGroup
  ,DateAdded=@DateAdded
  ,Genre1=@Genre1
  ,Genre2=@Genre2
  ,Genre3=@Genre3
  ,Genre4=@Genre4
  ,Genre5=@Genre5
  ,Genre6=@Genre6
  ,Genre7=@Genre7
  ,Genre8=@Genre8
  ,Genre9=@Genre9
  ,UPC=@UPC
  ,ItemDetailsWeb=@ItemDetailsWeb
  ,ItemDetailsWebProductDetails=@ItemDetailsWebProductDetails
  ,Sale_RetailPrice=@Sale_RetailPrice
  ,Sale_RetailEndDate=@Sale_RetailEndDate
  ,Sale_RetailFootnoteText=@Sale_RetailFootnoteText
  ,Sale_RetailItemDetailsText=@Sale_RetailItemDetailsText
  ,Sale_WholesalePrice=@Sale_WholesalePrice
  ,Sale_WholesaleEndDate=@Sale_WholesaleEndDate
  ,Sale_WholesaleFootnoteText=@Sale_WholesaleFootnoteText
  ,Sale_WholesaleItemDetailsText=@Sale_WholesaleItemDetailsText
  ,ItemFootnoteText=@ItemFootnoteText
  ,SupplierID=@SupplierID
  ,StreetDate=@StreetDate
  ,ShowOnWebsite=@ShowOnWebsite
  ,ConditionText=@ConditionText
  ,KirbyItem=@KirbyItem
  ,KirbysCut=@KirbysCut
  ,KirbyCost=@KirbyCost
  where ID=@ID
 end
else
 begin
  insert into Inventory
  (ID
  ,ArtistTitle
  ,Label
  ,RetailPrice
  ,Inventory
  ,[Format]
  ,InStockDate
  ,RhythmName
  ,YearFrom
  ,YearTo
  ,StorePrice
  ,BackInStockDate
  ,ProduceGroup
  ,MusicianGroup
  ,TracksGroup
  ,[Catalog]
  ,FormatOrder
  ,ExportPrice
  ,WebEssential
  ,WebReviewHTML
  ,Cutout
  ,WeightInGrams
  ,NumberOfTracks
  ,Deleted
  ,Cost
  ,MP3FileCompleted
  ,UsedItem
  ,ConditionJacket
  ,ConditionVinylOrCD
  ,ConditionNotes
  ,MP3SoundGroup
  ,DateAdded
  ,Genre1
  ,Genre2
  ,Genre3
  ,Genre4
  ,Genre5
  ,Genre6
  ,Genre7
  ,Genre8
  ,Genre9
  ,UPC
  ,ItemDetailsWeb
  ,ItemDetailsWebProductDetails
  ,Sale_RetailPrice
  ,Sale_RetailEndDate
  ,Sale_RetailFootnoteText
  ,Sale_RetailItemDetailsText
  ,Sale_WholesalePrice
  ,Sale_WholesaleEndDate
  ,Sale_WholesaleFootnoteText
  ,Sale_WholesaleItemDetailsText
  ,ItemFootnoteText
  ,SupplierID
  ,StreetDate
  ,ShowOnWebsite
  ,ConditionText
  ,KirbyItem
  ,KirbysCut
  ,KirbyCost)
  values
  (@ID
  ,@ArtistTitle
  ,@Label
  ,@RetailPrice
  ,@Inventory
  ,@Format
  ,@InStockDate
  ,@RhythmName
  ,@YearFrom
  ,@YearTo
  ,@StorePrice
  ,@BackInStockDate
  ,@ProduceGroup
  ,@MusicianGroup
  ,@TracksGroup
  ,@Catalog
  ,@FormatOrder
  ,@ExportPrice
  ,@WebEssential
  ,@WebReviewHTML
  ,@Cutout
  ,@WeightInGrams
  ,@NumberOfTracks
  ,@Deleted
  ,@Cost
  ,@MP3FileCompleted
  ,@UsedItem
  ,@ConditionJacket
  ,@ConditionVinylOrCD
  ,@ConditionNotes
  ,@MP3SoundGroup
  ,@DateAdded
  ,@Genre1
  ,@Genre2
  ,@Genre3
  ,@Genre4
  ,@Genre5
  ,@Genre6
  ,@Genre7
  ,@Genre8
  ,@Genre9
  ,@UPC
  ,@ItemDetailsWeb
  ,@ItemDetailsWebProductDetails
  ,@Sale_RetailPrice
  ,@Sale_RetailEndDate
  ,@Sale_RetailFootnoteText
  ,@Sale_RetailItemDetailsText
  ,@Sale_WholesalePrice
  ,@Sale_WholesaleEndDate
  ,@Sale_WholesaleFootnoteText
  ,@Sale_WholesaleItemDetailsText
  ,@ItemFootnoteText
  ,@SupplierID
  ,@StreetDate
  ,@ShowOnWebsite
  ,@ConditionText
  ,@KirbyItem
  ,@KirbysCut
  ,@KirbyCost)
 end

select 'success' as ReturnValue

COMMIT TRANSACTION Z

END TRY
BEGIN CATCH
  rollback
 select 'SQL SERVER ERROR in SPROC spSync_Inventory: ' + ERROR_MESSAGE() + ' LINE ' + cast(ERROR_LINE() as nvarchar(10)) as ReturnValue
END CATCH
















