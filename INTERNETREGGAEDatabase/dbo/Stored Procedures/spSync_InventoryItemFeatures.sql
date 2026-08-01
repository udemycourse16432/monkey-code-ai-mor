











-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spSync_InventoryItemFeatures]
  
  @ID0 int
 ,@InventoryItemFeatureID0 int
 ,@ItemID0 int
 ,@ID1 int
 ,@InventoryItemFeatureID1 int
 ,@ItemID1 int
 ,@ID2 int
 ,@InventoryItemFeatureID2 int
 ,@ItemID2 int
 ,@ID3 int
 ,@InventoryItemFeatureID3 int
 ,@ItemID3 int
 ,@ID4 int
 ,@InventoryItemFeatureID4 int
 ,@ItemID4 int
 ,@ID5 int
 ,@InventoryItemFeatureID5 int
 ,@ItemID5 int
 ,@ID6 int
 ,@InventoryItemFeatureID6 int
 ,@ItemID6 int
 ,@ID7 int
 ,@InventoryItemFeatureID7 int
 ,@ItemID7 int
 ,@ID8 int
 ,@InventoryItemFeatureID8 int
 ,@ItemID8 int
 ,@ID9 int
 ,@InventoryItemFeatureID9 int
 ,@ItemID9 int
 ,@ID10 int
 ,@InventoryItemFeatureID10 int
 ,@ItemID10 int
 ,@ID11 int
 ,@InventoryItemFeatureID11 int
 ,@ItemID11 int
 ,@ID12 int
 ,@InventoryItemFeatureID12 int
 ,@ItemID12 int
 ,@ID13 int
 ,@InventoryItemFeatureID13 int
 ,@ItemID13 int
 ,@ID14 int
 ,@InventoryItemFeatureID14 int
 ,@ItemID14 int
 ,@ID15 int
 ,@InventoryItemFeatureID15 int
 ,@ItemID15 int
 ,@ID16 int
 ,@InventoryItemFeatureID16 int
 ,@ItemID16 int
 ,@ID17 int
 ,@InventoryItemFeatureID17 int
 ,@ItemID17 int
 ,@ID18 int
 ,@InventoryItemFeatureID18 int
 ,@ItemID18 int
 ,@ID19 int
 ,@InventoryItemFeatureID19 int
 ,@ItemID19 int
 ,@ID20 int
 ,@InventoryItemFeatureID20 int
 ,@ItemID20 int
 ,@ID21 int
 ,@InventoryItemFeatureID21 int
 ,@ItemID21 int
 ,@ID22 int
 ,@InventoryItemFeatureID22 int
 ,@ItemID22 int
 ,@ID23 int
 ,@InventoryItemFeatureID23 int
 ,@ItemID23 int
 ,@ID24 int
 ,@InventoryItemFeatureID24 int
 ,@ItemID24 int
 ,@ID25 int
 ,@InventoryItemFeatureID25 int
 ,@ItemID25 int
 ,@ID26 int
 ,@InventoryItemFeatureID26 int
 ,@ItemID26 int
 ,@ID27 int
 ,@InventoryItemFeatureID27 int
 ,@ItemID27 int
 ,@ID28 int
 ,@InventoryItemFeatureID28 int
 ,@ItemID28 int
 ,@ID29 int
 ,@InventoryItemFeatureID29 int
 ,@ItemID29 int

AS

BEGIN TRY

BEGIN TRANSACTION Z

--ID0 ------------------------------------------------------------------------------------------
if @ID0>0
 begin
  if exists (select ID from InventoryItemFeatures where ID=@ID0)
   begin
    update InventoryItemFeatures set
      InventoryItemFeatureID=@InventoryItemFeatureID0
     ,ItemID=@ItemID0
    where ID=@ID0
   end
  else
   begin
    insert into InventoryItemFeatures
     (ID
     ,InventoryItemFeatureID
     ,ItemID)
    values
     (@ID0
     ,@InventoryItemFeatureID0
     ,@ItemID0)
   end
   exec spFigureSearchSuggestionsForInventoryID @ItemID0
 end

--ID1 ------------------------------------------------------------------------------------------
if @ID1>0
 begin
  if exists (select ID from InventoryItemFeatures where ID=@ID1)
   begin
    update InventoryItemFeatures set
      InventoryItemFeatureID=@InventoryItemFeatureID1
     ,ItemID=@ItemID1
    where ID=@ID1
   end
  else
   begin
    insert into InventoryItemFeatures
     (ID
     ,InventoryItemFeatureID
     ,ItemID)
    values
     (@ID1
     ,@InventoryItemFeatureID1
     ,@ItemID1)
   end
   exec spFigureSearchSuggestionsForInventoryID @ItemID1
 end

--ID2 ------------------------------------------------------------------------------------------
if @ID2>0
 begin
  if exists (select ID from InventoryItemFeatures where ID=@ID2)
   begin
    update InventoryItemFeatures set
      InventoryItemFeatureID=@InventoryItemFeatureID2
     ,ItemID=@ItemID2
    where ID=@ID2
   end
  else
   begin
    insert into InventoryItemFeatures
     (ID
     ,InventoryItemFeatureID
     ,ItemID)
    values
     (@ID2
     ,@InventoryItemFeatureID2
     ,@ItemID2)
   end
   exec spFigureSearchSuggestionsForInventoryID @ItemID2
 end

--ID3 ------------------------------------------------------------------------------------------
if @ID3>0
 begin
  if exists (select ID from InventoryItemFeatures where ID=@ID3)
   begin
    update InventoryItemFeatures set
      InventoryItemFeatureID=@InventoryItemFeatureID3
     ,ItemID=@ItemID3
    where ID=@ID3
   end
  else
   begin
    insert into InventoryItemFeatures
     (ID
     ,InventoryItemFeatureID
     ,ItemID)
    values
     (@ID3
     ,@InventoryItemFeatureID3
     ,@ItemID3)
   end
   exec spFigureSearchSuggestionsForInventoryID @ItemID3
 end

--ID4 ------------------------------------------------------------------------------------------
if @ID4>0
 begin
  if exists (select ID from InventoryItemFeatures where ID=@ID4)
   begin
    update InventoryItemFeatures set
      InventoryItemFeatureID=@InventoryItemFeatureID4
     ,ItemID=@ItemID4
    where ID=@ID4
   end
  else
   begin
    insert into InventoryItemFeatures
     (ID
     ,InventoryItemFeatureID
     ,ItemID)
    values
     (@ID4
     ,@InventoryItemFeatureID4
     ,@ItemID4)
   end
   exec spFigureSearchSuggestionsForInventoryID @ItemID4
 end

--ID5 ------------------------------------------------------------------------------------------
if @ID5>0
 begin
  if exists (select ID from InventoryItemFeatures where ID=@ID5)
   begin
    update InventoryItemFeatures set
      InventoryItemFeatureID=@InventoryItemFeatureID5
     ,ItemID=@ItemID5
    where ID=@ID5
   end
  else
   begin
    insert into InventoryItemFeatures
     (ID
     ,InventoryItemFeatureID
     ,ItemID)
    values
     (@ID5
     ,@InventoryItemFeatureID5
     ,@ItemID5)
   end
   exec spFigureSearchSuggestionsForInventoryID @ItemID5
 end

--ID6 ------------------------------------------------------------------------------------------
if @ID6>0
 begin
  if exists (select ID from InventoryItemFeatures where ID=@ID6)
   begin
    update InventoryItemFeatures set
      InventoryItemFeatureID=@InventoryItemFeatureID6
     ,ItemID=@ItemID6
    where ID=@ID6
   end
  else
   begin
    insert into InventoryItemFeatures
     (ID
     ,InventoryItemFeatureID
     ,ItemID)
    values
     (@ID6
     ,@InventoryItemFeatureID6
     ,@ItemID6)
   end
   exec spFigureSearchSuggestionsForInventoryID @ItemID6
 end

--ID7 ------------------------------------------------------------------------------------------
if @ID7>0
 begin
  if exists (select ID from InventoryItemFeatures where ID=@ID7)
   begin
    update InventoryItemFeatures set
      InventoryItemFeatureID=@InventoryItemFeatureID7
     ,ItemID=@ItemID7
    where ID=@ID7
   end
  else
   begin
    insert into InventoryItemFeatures
     (ID
     ,InventoryItemFeatureID
     ,ItemID)
    values
     (@ID7
     ,@InventoryItemFeatureID7
     ,@ItemID7)
   end
   exec spFigureSearchSuggestionsForInventoryID @ItemID7
 end

--ID8 ------------------------------------------------------------------------------------------
if @ID8>0
 begin
  if exists (select ID from InventoryItemFeatures where ID=@ID8)
   begin
    update InventoryItemFeatures set
      InventoryItemFeatureID=@InventoryItemFeatureID8
     ,ItemID=@ItemID8
    where ID=@ID8
   end
  else
   begin
    insert into InventoryItemFeatures
     (ID
     ,InventoryItemFeatureID
     ,ItemID)
    values
     (@ID8
     ,@InventoryItemFeatureID8
     ,@ItemID8)
   end
   exec spFigureSearchSuggestionsForInventoryID @ItemID8
 end

--ID9 ------------------------------------------------------------------------------------------
if @ID9>0
 begin
  if exists (select ID from InventoryItemFeatures where ID=@ID9)
   begin
    update InventoryItemFeatures set
      InventoryItemFeatureID=@InventoryItemFeatureID9
     ,ItemID=@ItemID9
    where ID=@ID9
   end
  else
   begin
    insert into InventoryItemFeatures
     (ID
     ,InventoryItemFeatureID
     ,ItemID)
    values
     (@ID9
     ,@InventoryItemFeatureID9
     ,@ItemID9)
   end
   exec spFigureSearchSuggestionsForInventoryID @ItemID9
 end

--ID10 ------------------------------------------------------------------------------------------
if @ID10>0
 begin
  if exists (select ID from InventoryItemFeatures where ID=@ID10)
   begin
    update InventoryItemFeatures set
      InventoryItemFeatureID=@InventoryItemFeatureID10
     ,ItemID=@ItemID10
    where ID=@ID10
   end
  else
   begin
    insert into InventoryItemFeatures
     (ID
     ,InventoryItemFeatureID
     ,ItemID)
    values
     (@ID10
     ,@InventoryItemFeatureID10
     ,@ItemID10)
   end
   exec spFigureSearchSuggestionsForInventoryID @ItemID10
 end

--ID11 ------------------------------------------------------------------------------------------
if @ID11>0
 begin
  if exists (select ID from InventoryItemFeatures where ID=@ID11)
   begin
    update InventoryItemFeatures set
      InventoryItemFeatureID=@InventoryItemFeatureID11
     ,ItemID=@ItemID11
    where ID=@ID11
   end
  else
   begin
    insert into InventoryItemFeatures
     (ID
     ,InventoryItemFeatureID
     ,ItemID)
    values
     (@ID11
     ,@InventoryItemFeatureID11
     ,@ItemID11)
   end
   exec spFigureSearchSuggestionsForInventoryID @ItemID11
 end

--ID12 ------------------------------------------------------------------------------------------
if @ID12>0
 begin
  if exists (select ID from InventoryItemFeatures where ID=@ID12)
   begin
    update InventoryItemFeatures set
      InventoryItemFeatureID=@InventoryItemFeatureID12
     ,ItemID=@ItemID12
    where ID=@ID12
   end
  else
   begin
    insert into InventoryItemFeatures
     (ID
     ,InventoryItemFeatureID
     ,ItemID)
    values
     (@ID12
     ,@InventoryItemFeatureID12
     ,@ItemID12)
   end
   exec spFigureSearchSuggestionsForInventoryID @ItemID12
 end

--ID13 ------------------------------------------------------------------------------------------
if @ID13>0
 begin
  if exists (select ID from InventoryItemFeatures where ID=@ID13)
   begin
    update InventoryItemFeatures set
      InventoryItemFeatureID=@InventoryItemFeatureID13
     ,ItemID=@ItemID13
    where ID=@ID13
   end
  else
   begin
    insert into InventoryItemFeatures
     (ID
     ,InventoryItemFeatureID
     ,ItemID)
    values
     (@ID13
     ,@InventoryItemFeatureID13
     ,@ItemID13)
   end
   exec spFigureSearchSuggestionsForInventoryID @ItemID13
 end

--ID14 ------------------------------------------------------------------------------------------
if @ID14>0
 begin
  if exists (select ID from InventoryItemFeatures where ID=@ID14)
   begin
    update InventoryItemFeatures set
      InventoryItemFeatureID=@InventoryItemFeatureID14
     ,ItemID=@ItemID14
    where ID=@ID14
   end
  else
   begin
    insert into InventoryItemFeatures
     (ID
     ,InventoryItemFeatureID
     ,ItemID)
    values
     (@ID14
     ,@InventoryItemFeatureID14
     ,@ItemID14)
   end
   exec spFigureSearchSuggestionsForInventoryID @ItemID14
 end

--ID15 ------------------------------------------------------------------------------------------
if @ID15>0
 begin
  if exists (select ID from InventoryItemFeatures where ID=@ID15)
   begin
    update InventoryItemFeatures set
      InventoryItemFeatureID=@InventoryItemFeatureID15
     ,ItemID=@ItemID15
    where ID=@ID15
   end
  else
   begin
    insert into InventoryItemFeatures
     (ID
     ,InventoryItemFeatureID
     ,ItemID)
    values
     (@ID15
     ,@InventoryItemFeatureID15
     ,@ItemID15)
   end
   exec spFigureSearchSuggestionsForInventoryID @ItemID15
 end

--ID16 ------------------------------------------------------------------------------------------
if @ID16>0
 begin
  if exists (select ID from InventoryItemFeatures where ID=@ID16)
   begin
    update InventoryItemFeatures set
      InventoryItemFeatureID=@InventoryItemFeatureID16
     ,ItemID=@ItemID16
    where ID=@ID16
   end
  else
   begin
    insert into InventoryItemFeatures
     (ID
     ,InventoryItemFeatureID
     ,ItemID)
    values
     (@ID16
     ,@InventoryItemFeatureID16
     ,@ItemID16)
   end
   exec spFigureSearchSuggestionsForInventoryID @ItemID16
 end

--ID17 ------------------------------------------------------------------------------------------
if @ID17>0
 begin
  if exists (select ID from InventoryItemFeatures where ID=@ID17)
   begin
    update InventoryItemFeatures set
      InventoryItemFeatureID=@InventoryItemFeatureID17
     ,ItemID=@ItemID17
    where ID=@ID17
   end
  else
   begin
    insert into InventoryItemFeatures
     (ID
     ,InventoryItemFeatureID
     ,ItemID)
    values
     (@ID17
     ,@InventoryItemFeatureID17
     ,@ItemID17)
   end
   exec spFigureSearchSuggestionsForInventoryID @ItemID17
 end

--ID18 ------------------------------------------------------------------------------------------
if @ID18>0
 begin
  if exists (select ID from InventoryItemFeatures where ID=@ID18)
   begin
    update InventoryItemFeatures set
      InventoryItemFeatureID=@InventoryItemFeatureID18
     ,ItemID=@ItemID18
    where ID=@ID18
   end
  else
   begin
    insert into InventoryItemFeatures
     (ID
     ,InventoryItemFeatureID
     ,ItemID)
    values
     (@ID18
     ,@InventoryItemFeatureID18
     ,@ItemID18)
   end
   exec spFigureSearchSuggestionsForInventoryID @ItemID18
  end

--ID19 ------------------------------------------------------------------------------------------
if @ID19>0
 begin
  if exists (select ID from InventoryItemFeatures where ID=@ID19)
   begin
    update InventoryItemFeatures set
      InventoryItemFeatureID=@InventoryItemFeatureID19
     ,ItemID=@ItemID19
    where ID=@ID19
   end
  else
   begin
    insert into InventoryItemFeatures
     (ID
     ,InventoryItemFeatureID
     ,ItemID)
    values
     (@ID19
     ,@InventoryItemFeatureID19
     ,@ItemID19)
   end
   exec spFigureSearchSuggestionsForInventoryID @ItemID19
 end

--ID20 ------------------------------------------------------------------------------------------
if @ID20>0
 begin
  if exists (select ID from InventoryItemFeatures where ID=@ID20)
   begin
    update InventoryItemFeatures set
      InventoryItemFeatureID=@InventoryItemFeatureID20
     ,ItemID=@ItemID20
    where ID=@ID20
   end
  else
   begin
    insert into InventoryItemFeatures
     (ID
     ,InventoryItemFeatureID
     ,ItemID)
    values
     (@ID20
     ,@InventoryItemFeatureID20
     ,@ItemID20)
   end
   exec spFigureSearchSuggestionsForInventoryID @ItemID20
 end

--ID21 ------------------------------------------------------------------------------------------
if @ID21>0
 begin
  if exists (select ID from InventoryItemFeatures where ID=@ID21)
   begin
    update InventoryItemFeatures set
      InventoryItemFeatureID=@InventoryItemFeatureID21
     ,ItemID=@ItemID21
    where ID=@ID21
   end
  else
   begin
    insert into InventoryItemFeatures
     (ID
     ,InventoryItemFeatureID
     ,ItemID)
    values
     (@ID21
     ,@InventoryItemFeatureID21
     ,@ItemID21)
   end
   exec spFigureSearchSuggestionsForInventoryID @ItemID21
 end

--ID22 ------------------------------------------------------------------------------------------
if @ID22>0
 begin
  if exists (select ID from InventoryItemFeatures where ID=@ID22)
   begin
    update InventoryItemFeatures set
      InventoryItemFeatureID=@InventoryItemFeatureID22
     ,ItemID=@ItemID22
    where ID=@ID22
   end
  else
   begin
    insert into InventoryItemFeatures
     (ID
     ,InventoryItemFeatureID
     ,ItemID)
    values
     (@ID22
     ,@InventoryItemFeatureID22
     ,@ItemID22)
   end
   exec spFigureSearchSuggestionsForInventoryID @ItemID22
 end

--ID23 ------------------------------------------------------------------------------------------
if @ID23>0
 begin
  if exists (select ID from InventoryItemFeatures where ID=@ID23)
   begin
    update InventoryItemFeatures set
      InventoryItemFeatureID=@InventoryItemFeatureID23
     ,ItemID=@ItemID23
    where ID=@ID23
   end
  else
   begin
    insert into InventoryItemFeatures
     (ID
     ,InventoryItemFeatureID
     ,ItemID)
    values
     (@ID23
     ,@InventoryItemFeatureID23
     ,@ItemID23)
   end
   exec spFigureSearchSuggestionsForInventoryID @ItemID23
 end

--ID24 ------------------------------------------------------------------------------------------
if @ID24>0
 begin
  if exists (select ID from InventoryItemFeatures where ID=@ID24)
   begin
    update InventoryItemFeatures set
      InventoryItemFeatureID=@InventoryItemFeatureID24
     ,ItemID=@ItemID24
    where ID=@ID24
   end
  else
   begin
    insert into InventoryItemFeatures
     (ID
     ,InventoryItemFeatureID
     ,ItemID)
    values
     (@ID24
     ,@InventoryItemFeatureID24
     ,@ItemID24)
   end
   exec spFigureSearchSuggestionsForInventoryID @ItemID24
 end

--ID25 ------------------------------------------------------------------------------------------
if @ID25>0
 begin
  if exists (select ID from InventoryItemFeatures where ID=@ID25)
   begin
    update InventoryItemFeatures set
      InventoryItemFeatureID=@InventoryItemFeatureID25
     ,ItemID=@ItemID25
    where ID=@ID25
   end
  else
   begin
    insert into InventoryItemFeatures
     (ID
     ,InventoryItemFeatureID
     ,ItemID)
    values
     (@ID25
     ,@InventoryItemFeatureID25
     ,@ItemID25)
   end
   exec spFigureSearchSuggestionsForInventoryID @ItemID25
 end

--ID26 ------------------------------------------------------------------------------------------
if @ID26>0
 begin
  if exists (select ID from InventoryItemFeatures where ID=@ID26)
   begin
    update InventoryItemFeatures set
      InventoryItemFeatureID=@InventoryItemFeatureID26
     ,ItemID=@ItemID26
    where ID=@ID26
   end
  else
   begin
    insert into InventoryItemFeatures
     (ID
     ,InventoryItemFeatureID
     ,ItemID)
    values
     (@ID26
     ,@InventoryItemFeatureID26
     ,@ItemID26)
   end
   exec spFigureSearchSuggestionsForInventoryID @ItemID26
 end

--ID27 ------------------------------------------------------------------------------------------
if @ID27>0
 begin
  if exists (select ID from InventoryItemFeatures where ID=@ID27)
   begin
    update InventoryItemFeatures set
      InventoryItemFeatureID=@InventoryItemFeatureID27
     ,ItemID=@ItemID27
    where ID=@ID27
   end
  else
   begin
    insert into InventoryItemFeatures
     (ID
     ,InventoryItemFeatureID
     ,ItemID)
    values
     (@ID27
     ,@InventoryItemFeatureID27
     ,@ItemID27)
   end
   exec spFigureSearchSuggestionsForInventoryID @ItemID27
 end

--ID28 ------------------------------------------------------------------------------------------
if @ID28>0
 begin
  if exists (select ID from InventoryItemFeatures where ID=@ID28)
   begin
    update InventoryItemFeatures set
      InventoryItemFeatureID=@InventoryItemFeatureID28
     ,ItemID=@ItemID28
    where ID=@ID28
   end
  else
   begin
    insert into InventoryItemFeatures
     (ID
     ,InventoryItemFeatureID
     ,ItemID)
    values
     (@ID28
     ,@InventoryItemFeatureID28
     ,@ItemID28)
   end
   exec spFigureSearchSuggestionsForInventoryID @ItemID28
 end

--ID29 ------------------------------------------------------------------------------------------
if @ID29>0
 begin
  if exists (select ID from InventoryItemFeatures where ID=@ID29)
   begin
    update InventoryItemFeatures set
      InventoryItemFeatureID=@InventoryItemFeatureID29
     ,ItemID=@ItemID29
    where ID=@ID29
   end
  else
   begin
    insert into InventoryItemFeatures
     (ID
     ,InventoryItemFeatureID
     ,ItemID)
    values
     (@ID29
     ,@InventoryItemFeatureID29
     ,@ItemID29)
   end
   exec spFigureSearchSuggestionsForInventoryID @ItemID29
 end

select 'success' as ReturnValue

COMMIT TRANSACTION Z

END TRY
BEGIN CATCH
 if @@trancount>0
  rollback
 select 'SQL SERVER ERROR in SPROC spSync_InventoryItemFeatures: ' + ERROR_MESSAGE() + ' LINE ' + cast(ERROR_LINE() as nvarchar(10)) as ReturnValue
END CATCH











