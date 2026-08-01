








-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spSync_InventoryItemFeatureIndex]
  @Counter int
 ,@InventoryItemFeatureID int
 ,@DescriptionForInternalUse nvarchar(255)
 ,@FormatText nvarchar(25)
 ,@FormatForInternalUse nvarchar(10)
 ,@ItemFeatureWebGalleryText nvarchar(100)
 ,@ItemFeatureWebGalleryTextDisplaySequence int
 ,@ItemFeatureHoverOverText nvarchar(255)
 ,@ItemFeatureWebProductDetailsPageText nvarchar(255)
 ,@ItemFeatureWebProductDetailsPageTextDisplaySequence int
 ,@ItemFeatureWebProductDetailsPageHyperlinkText nvarchar(max)
 ,@ItemFeaturesOrderAndInvoicePagesText nvarchar(255)
 ,@ItemFeaturesOrderAndInvoicePagesTextDisplaySequence int
 ,@ItemFeatureExcelFileText nvarchar(255)
 ,@ItemFeatureExcelFileTextDisplaySequence int
 ,@EBrecordsInventoryItemFeatureID int
 ,@Hint nvarchar(255)

AS

if exists (select InventoryItemFeatureID from InventoryItemFeatureIndex where InventoryItemFeatureID=@InventoryItemFeatureID)
 begin
  update InventoryItemFeatureIndex set
    InventoryItemFeatureID=@InventoryItemFeatureID
   ,DescriptionForInternalUse=@DescriptionForInternalUse
   ,FormatText=@FormatText
   ,FormatForInternalUse=@FormatForInternalUse
   ,ItemFeatureWebGalleryText=@ItemFeatureWebGalleryText
   ,ItemFeatureWebGalleryTextDisplaySequence=@ItemFeatureWebGalleryTextDisplaySequence
   ,ItemFeatureHoverOverText=@ItemFeatureHoverOverText
   ,ItemFeatureWebProductDetailsPageText=@ItemFeatureWebProductDetailsPageText
   ,ItemFeatureWebProductDetailsPageTextDisplaySequence=@ItemFeatureWebProductDetailsPageTextDisplaySequence
   ,ItemFeatureWebProductDetailsPageHyperlinkText=@ItemFeatureWebProductDetailsPageHyperlinkText
   ,ItemFeaturesOrderAndInvoicePagesText=@ItemFeaturesOrderAndInvoicePagesText
   ,ItemFeaturesOrderAndInvoicePagesTextDisplaySequence=@ItemFeaturesOrderAndInvoicePagesTextDisplaySequence
   ,ItemFeatureExcelFileText=@ItemFeatureExcelFileText
   ,ItemFeatureExcelFileTextDisplaySequence=@ItemFeatureExcelFileTextDisplaySequence
   ,EBrecordsInventoryItemFeatureID=@EBrecordsInventoryItemFeatureID
   ,Hint=@Hint
  where Counter=@Counter
 end
else
 begin
  insert into InventoryItemFeatureIndex
   (counter
   ,InventoryItemFeatureID
   ,DescriptionForInternalUse
   ,FormatText
   ,FormatForInternalUse
   ,ItemFeatureWebGalleryText
   ,ItemFeatureWebGalleryTextDisplaySequence
   ,ItemFeatureHoverOverText
   ,ItemFeatureWebProductDetailsPageText
   ,ItemFeatureWebProductDetailsPageTextDisplaySequence
   ,ItemFeatureWebProductDetailsPageHyperlinkText
   ,ItemFeaturesOrderAndInvoicePagesText
   ,ItemFeaturesOrderAndInvoicePagesTextDisplaySequence
   ,ItemFeatureExcelFileText
   ,ItemFeatureExcelFileTextDisplaySequence
   ,EBrecordsInventoryItemFeatureID
   ,Hint)
  values
   (@Counter
   ,@InventoryItemFeatureID
   ,@DescriptionForInternalUse
   ,@FormatText
   ,@FormatForInternalUse
   ,@ItemFeatureWebGalleryText
   ,@ItemFeatureWebGalleryTextDisplaySequence
   ,@ItemFeatureHoverOverText
   ,@ItemFeatureWebProductDetailsPageText
   ,@ItemFeatureWebProductDetailsPageTextDisplaySequence
   ,@ItemFeatureWebProductDetailsPageHyperlinkText
   ,@ItemFeaturesOrderAndInvoicePagesText
   ,@ItemFeaturesOrderAndInvoicePagesTextDisplaySequence
   ,@ItemFeatureExcelFileText
   ,@ItemFeatureExcelFileTextDisplaySequence
   ,@EBrecordsInventoryItemFeatureID
   ,@Hint)
 end









