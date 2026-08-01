












-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spSync_SoldItems]
  
  @ID0 int
 ,@InvoiceDate0 datetime
 ,@ItemID0 int
 ,@Quantity0 smallint
 ,@SalesChannel0 nvarchar(15)
 ,@KirbyItem0 nvarchar(1)
 ,@KirbysCut0 numeric(6,2)
 ,@SupplierID0 int
 ,@Cost0 smallmoney
 ,@FalseSale0 smallint
 ,@KirbyCost0 numeric(6,2)
 ,@ID1 int
 ,@InvoiceDate1 datetime
 ,@ItemID1 int
 ,@Quantity1 smallint
 ,@SalesChannel1 nvarchar(15)
 ,@KirbyItem1 nvarchar(1)
 ,@KirbysCut1 numeric(6,2)
 ,@SupplierID1 int
 ,@Cost1 smallmoney
 ,@FalseSale1 smallint
 ,@KirbyCost1 numeric(6,2)
 ,@ID2 int
 ,@InvoiceDate2 datetime
 ,@ItemID2 int
 ,@Quantity2 smallint
 ,@SalesChannel2 nvarchar(15)
 ,@KirbyItem2 nvarchar(1)
 ,@KirbysCut2 numeric(6,2)
 ,@SupplierID2 int
 ,@Cost2 smallmoney
 ,@FalseSale2 smallint
 ,@KirbyCost2 numeric(6,2)
 ,@ID3 int
 ,@InvoiceDate3 datetime
 ,@ItemID3 int
 ,@Quantity3 smallint
 ,@SalesChannel3 nvarchar(15)
 ,@KirbyItem3 nvarchar(1)
 ,@KirbysCut3 numeric(6,2)
 ,@SupplierID3 int
 ,@Cost3 smallmoney
 ,@FalseSale3 smallint
 ,@KirbyCost3 numeric(6,2)
 ,@ID4 int
 ,@InvoiceDate4 datetime
 ,@ItemID4 int
 ,@Quantity4 smallint
 ,@SalesChannel4 nvarchar(15)
 ,@KirbyItem4 nvarchar(1)
 ,@KirbysCut4 numeric(6,2)
 ,@SupplierID4 int
 ,@Cost4 smallmoney
 ,@FalseSale4 smallint
 ,@KirbyCost4 numeric(6,2)
 ,@ID5 int
 ,@InvoiceDate5 datetime
 ,@ItemID5 int
 ,@Quantity5 smallint
 ,@SalesChannel5 nvarchar(15)
 ,@KirbyItem5 nvarchar(1)
 ,@KirbysCut5 numeric(6,2)
 ,@SupplierID5 int
 ,@Cost5 smallmoney
 ,@FalseSale5 smallint
 ,@KirbyCost5 numeric(6,2)
 ,@ID6 int
 ,@InvoiceDate6 datetime
 ,@ItemID6 int
 ,@Quantity6 smallint
 ,@SalesChannel6 nvarchar(15)
 ,@KirbyItem6 nvarchar(1)
 ,@KirbysCut6 numeric(6,2)
 ,@SupplierID6 int
 ,@Cost6 smallmoney
 ,@FalseSale6 smallint
 ,@KirbyCost6 numeric(6,2)
 ,@ID7 int
 ,@InvoiceDate7 datetime
 ,@ItemID7 int
 ,@Quantity7 smallint
 ,@SalesChannel7 nvarchar(15)
 ,@KirbyItem7 nvarchar(1)
 ,@KirbysCut7 numeric(6,2)
 ,@SupplierID7 int
 ,@Cost7 smallmoney
 ,@FalseSale7 smallint
 ,@KirbyCost7 numeric(6,2)
 ,@ID8 int
 ,@InvoiceDate8 datetime
 ,@ItemID8 int
 ,@Quantity8 smallint
 ,@SalesChannel8 nvarchar(15)
 ,@KirbyItem8 nvarchar(1)
 ,@KirbysCut8 numeric(6,2)
 ,@SupplierID8 int
 ,@Cost8 smallmoney
 ,@FalseSale8 smallint
 ,@KirbyCost8 numeric(6,2)
 ,@ID9 int
 ,@InvoiceDate9 datetime
 ,@ItemID9 int
 ,@Quantity9 smallint
 ,@SalesChannel9 nvarchar(15)
 ,@KirbyItem9 nvarchar(1)
 ,@KirbysCut9 numeric(6,2)
 ,@SupplierID9 int
 ,@Cost9 smallmoney
 ,@FalseSale9 smallint
 ,@KirbyCost9 numeric(6,2)
 ,@ID10 int
 ,@InvoiceDate10 datetime
 ,@ItemID10 int
 ,@Quantity10 smallint
 ,@SalesChannel10 nvarchar(15)
 ,@KirbyItem10 nvarchar(1)
 ,@KirbysCut10 numeric(6,2)
 ,@SupplierID10 int
 ,@Cost10 smallmoney
 ,@FalseSale10 smallint
 ,@KirbyCost10 numeric(6,2)
 ,@ID11 int
 ,@InvoiceDate11 datetime
 ,@ItemID11 int
 ,@Quantity11 smallint
 ,@SalesChannel11 nvarchar(15)
 ,@KirbyItem11 nvarchar(1)
 ,@KirbysCut11 numeric(6,2)
 ,@SupplierID11 int
 ,@Cost11 smallmoney
 ,@FalseSale11 smallint
 ,@KirbyCost11 numeric(6,2)
 ,@ID12 int
 ,@InvoiceDate12 datetime
 ,@ItemID12 int
 ,@Quantity12 smallint
 ,@SalesChannel12 nvarchar(15)
 ,@KirbyItem12 nvarchar(1)
 ,@KirbysCut12 numeric(6,2)
 ,@SupplierID12 int
 ,@Cost12 smallmoney
 ,@FalseSale12 smallint
 ,@KirbyCost12 numeric(6,2)
 ,@ID13 int
 ,@InvoiceDate13 datetime
 ,@ItemID13 int
 ,@Quantity13 smallint
 ,@SalesChannel13 nvarchar(15)
 ,@KirbyItem13 nvarchar(1)
 ,@KirbysCut13 numeric(6,2)
 ,@SupplierID13 int
 ,@Cost13 smallmoney
 ,@FalseSale13 smallint
 ,@KirbyCost13 numeric(6,2)
 ,@ID14 int
 ,@InvoiceDate14 datetime
 ,@ItemID14 int
 ,@Quantity14 smallint
 ,@SalesChannel14 nvarchar(15)
 ,@KirbyItem14 nvarchar(1)
 ,@KirbysCut14 numeric(6,2)
 ,@SupplierID14 int
 ,@Cost14 smallmoney
 ,@FalseSale14 smallint
 ,@KirbyCost14 numeric(6,2)
 ,@ID15 int
 ,@InvoiceDate15 datetime
 ,@ItemID15 int
 ,@Quantity15 smallint
 ,@SalesChannel15 nvarchar(15)
 ,@KirbyItem15 nvarchar(1)
 ,@KirbysCut15 numeric(6,2)
 ,@SupplierID15 int
 ,@Cost15 smallmoney
 ,@FalseSale15 smallint
 ,@KirbyCost15 numeric(6,2)
 ,@ID16 int
 ,@InvoiceDate16 datetime
 ,@ItemID16 int
 ,@Quantity16 smallint
 ,@SalesChannel16 nvarchar(15)
 ,@KirbyItem16 nvarchar(1)
 ,@KirbysCut16 numeric(6,2)
 ,@SupplierID16 int
 ,@Cost16 smallmoney
 ,@FalseSale16 smallint
 ,@KirbyCost16 numeric(6,2)
 ,@ID17 int
 ,@InvoiceDate17 datetime
 ,@ItemID17 int
 ,@Quantity17 smallint
 ,@SalesChannel17 nvarchar(15)
 ,@KirbyItem17 nvarchar(1)
 ,@KirbysCut17 numeric(6,2)
 ,@SupplierID17 int
 ,@Cost17 smallmoney
 ,@FalseSale17 smallint
 ,@KirbyCost17 numeric(6,2)
 ,@ID18 int
 ,@InvoiceDate18 datetime
 ,@ItemID18 int
 ,@Quantity18 smallint
 ,@SalesChannel18 nvarchar(15)
 ,@KirbyItem18 nvarchar(1)
 ,@KirbysCut18 numeric(6,2)
 ,@SupplierID18 int
 ,@Cost18 smallmoney
 ,@FalseSale18 smallint
 ,@KirbyCost18 numeric(6,2)
 ,@ID19 int
 ,@InvoiceDate19 datetime
 ,@ItemID19 int
 ,@Quantity19 smallint
 ,@SalesChannel19 nvarchar(15)
 ,@KirbyItem19 nvarchar(1)
 ,@KirbysCut19 numeric(6,2)
 ,@SupplierID19 int
 ,@Cost19 smallmoney
 ,@FalseSale19 smallint
 ,@KirbyCost19 numeric(6,2)
 ,@ID20 int
 ,@InvoiceDate20 datetime
 ,@ItemID20 int
 ,@Quantity20 smallint
 ,@SalesChannel20 nvarchar(15)
 ,@KirbyItem20 nvarchar(1)
 ,@KirbysCut20 numeric(6,2)
 ,@SupplierID20 int
 ,@Cost20 smallmoney
 ,@FalseSale20 smallint
 ,@KirbyCost20 numeric(6,2)
 ,@ID21 int
 ,@InvoiceDate21 datetime
 ,@ItemID21 int
 ,@Quantity21 smallint
 ,@SalesChannel21 nvarchar(15)
 ,@KirbyItem21 nvarchar(1)
 ,@KirbysCut21 numeric(6,2)
 ,@SupplierID21 int
 ,@Cost21 smallmoney
 ,@FalseSale21 smallint
 ,@KirbyCost21 numeric(6,2)
 ,@ID22 int
 ,@InvoiceDate22 datetime
 ,@ItemID22 int
 ,@Quantity22 smallint
 ,@SalesChannel22 nvarchar(15)
 ,@KirbyItem22 nvarchar(1)
 ,@KirbysCut22 numeric(6,2)
 ,@SupplierID22 int
 ,@Cost22 smallmoney
 ,@FalseSale22 smallint
 ,@KirbyCost22 numeric(6,2)
 ,@ID23 int
 ,@InvoiceDate23 datetime
 ,@ItemID23 int
 ,@Quantity23 smallint
 ,@SalesChannel23 nvarchar(15)
 ,@KirbyItem23 nvarchar(1)
 ,@KirbysCut23 numeric(6,2)
 ,@SupplierID23 int
 ,@Cost23 smallmoney
 ,@FalseSale23 smallint
 ,@KirbyCost23 numeric(6,2)
 ,@ID24 int
 ,@InvoiceDate24 datetime
 ,@ItemID24 int
 ,@Quantity24 smallint
 ,@SalesChannel24 nvarchar(15)
 ,@KirbyItem24 nvarchar(1)
 ,@KirbysCut24 numeric(6,2)
 ,@SupplierID24 int
 ,@Cost24 smallmoney
 ,@FalseSale24 smallint
 ,@KirbyCost24 numeric(6,2)
 ,@ID25 int
 ,@InvoiceDate25 datetime
 ,@ItemID25 int
 ,@Quantity25 smallint
 ,@SalesChannel25 nvarchar(15)
 ,@KirbyItem25 nvarchar(1)
 ,@KirbysCut25 numeric(6,2)
 ,@SupplierID25 int
 ,@Cost25 smallmoney
 ,@FalseSale25 smallint
 ,@KirbyCost25 numeric(6,2)
 ,@ID26 int
 ,@InvoiceDate26 datetime
 ,@ItemID26 int
 ,@Quantity26 smallint
 ,@SalesChannel26 nvarchar(15)
 ,@KirbyItem26 nvarchar(1)
 ,@KirbysCut26 numeric(6,2)
 ,@SupplierID26 int
 ,@Cost26 smallmoney
 ,@FalseSale26 smallint
 ,@KirbyCost26 numeric(6,2)
 ,@ID27 int
 ,@InvoiceDate27 datetime
 ,@ItemID27 int
 ,@Quantity27 smallint
 ,@SalesChannel27 nvarchar(15)
 ,@KirbyItem27 nvarchar(1)
 ,@KirbysCut27 numeric(6,2)
 ,@SupplierID27 int
 ,@Cost27 smallmoney
 ,@FalseSale27 smallint
 ,@KirbyCost27 numeric(6,2)
 ,@ID28 int
 ,@InvoiceDate28 datetime
 ,@ItemID28 int
 ,@Quantity28 smallint
 ,@SalesChannel28 nvarchar(15)
 ,@KirbyItem28 nvarchar(1)
 ,@KirbysCut28 numeric(6,2)
 ,@SupplierID28 int
 ,@Cost28 smallmoney
 ,@FalseSale28 smallint
 ,@KirbyCost28 numeric(6,2)
 ,@ID29 int
 ,@InvoiceDate29 datetime
 ,@ItemID29 int
 ,@Quantity29 smallint
 ,@SalesChannel29 nvarchar(15)
 ,@KirbyItem29 nvarchar(1)
 ,@KirbysCut29 numeric(6,2)
 ,@SupplierID29 int
 ,@Cost29 smallmoney
 ,@FalseSale29 smallint
 ,@KirbyCost29 numeric(6,2)

AS

BEGIN TRY

BEGIN TRANSACTION Z

--ID0 ------------------------------------------------------------------------------------------
if @ID0>0
 begin
  if exists (select ID from SoldItems where ID=@ID0)
   begin
    update SoldItems set
     InvoiceDate=@InvoiceDate0
     ,ItemID=@ItemID0
     ,Quantity=@Quantity0
     ,SalesChannel=@SalesChannel0
     ,KirbyItem=@KirbyItem0   
     ,KirbysCut=@KirbysCut0
     ,SupplierID=@SupplierID0
     ,Cost=@Cost0
     ,FalseSale=@FalseSale0
     ,KirbyCost=@KirbyCost0
    where ID=@ID0
   end
  else
 begin
  insert into SoldItems
   (ID
   ,InvoiceDate
   ,ItemID
   ,Quantity
   ,SalesChannel
   ,KirbyItem
   ,KirbysCut
   ,SupplierID
   ,Cost
   ,FalseSale
   ,KirbyCost)
  values
   (@ID0
   ,@InvoiceDate0
   ,@ItemID0
   ,@Quantity0
   ,@SalesChannel0
   ,@KirbyItem0
   ,@KirbysCut0
   ,@SupplierID0
   ,@Cost0
   ,@FalseSale0
   ,@KirbyCost0)
  end
 end

--ID1 ------------------------------------------------------------------------------------------
if @ID1>0
 begin
  if exists (select ID from SoldItems where ID=@ID1)
   begin
    update SoldItems set
     InvoiceDate=@InvoiceDate1
     ,ItemID=@ItemID1
     ,Quantity=@Quantity1
     ,SalesChannel=@SalesChannel1
     ,KirbyItem=@KirbyItem1   
     ,KirbysCut=@KirbysCut1
     ,SupplierID=@SupplierID1
     ,Cost=@Cost1
     ,FalseSale=@FalseSale1
     ,KirbyCost=@KirbyCost1
    where ID=@ID1
   end
  else
 begin
  insert into SoldItems
   (ID
   ,InvoiceDate
   ,ItemID
   ,Quantity
   ,SalesChannel
   ,KirbyItem
   ,KirbysCut
   ,SupplierID
   ,Cost
   ,FalseSale
   ,KirbyCost)
  values
   (@ID1
   ,@InvoiceDate1
   ,@ItemID1
   ,@Quantity1
   ,@SalesChannel1
   ,@KirbyItem1
   ,@KirbysCut1
   ,@SupplierID1
   ,@Cost1
   ,@FalseSale1
   ,@KirbyCost1)
  end
 end


--ID2 ------------------------------------------------------------------------------------------
if @ID2>0
  begin
  if exists (select ID from SoldItems where ID=@ID2)
   begin
    update SoldItems set
     InvoiceDate=@InvoiceDate2
     ,ItemID=@ItemID2
     ,Quantity=@Quantity2
     ,SalesChannel=@SalesChannel2
     ,KirbyItem=@KirbyItem2   
     ,KirbysCut=@KirbysCut2
     ,SupplierID=@SupplierID2
     ,Cost=@Cost2
     ,FalseSale=@FalseSale2
     ,KirbyCost=@KirbyCost2
    where ID=@ID2
   end
  else
 begin
  insert into SoldItems
   (ID
   ,InvoiceDate
   ,ItemID
   ,Quantity
   ,SalesChannel
   ,KirbyItem
   ,KirbysCut
   ,SupplierID
   ,Cost
   ,FalseSale
   ,KirbyCost)
  values
   (@ID2
   ,@InvoiceDate2
   ,@ItemID2
   ,@Quantity2
   ,@SalesChannel2
   ,@KirbyItem2
   ,@KirbysCut2
   ,@SupplierID2
   ,@Cost2
   ,@FalseSale2
   ,@KirbyCost2)
  end
 end

--ID3 ------------------------------------------------------------------------------------------
if @ID3>0
 begin
  if exists (select ID from SoldItems where ID=@ID3)
   begin
    update SoldItems set
     InvoiceDate=@InvoiceDate3
     ,ItemID=@ItemID3
     ,Quantity=@Quantity3
     ,SalesChannel=@SalesChannel3
     ,KirbyItem=@KirbyItem3   
     ,KirbysCut=@KirbysCut3
     ,SupplierID=@SupplierID3
     ,Cost=@Cost3
     ,FalseSale=@FalseSale3
     ,KirbyCost=@KirbyCost3
    where ID=@ID3
   end
  else
 begin
  insert into SoldItems
   (ID
   ,InvoiceDate
   ,ItemID
   ,Quantity
   ,SalesChannel
   ,KirbyItem
   ,KirbysCut
   ,SupplierID
   ,Cost
   ,FalseSale
   ,KirbyCost)
  values
   (@ID3
   ,@InvoiceDate3
   ,@ItemID3
   ,@Quantity3
   ,@SalesChannel3
   ,@KirbyItem3
   ,@KirbysCut3
   ,@SupplierID3
   ,@Cost3
   ,@FalseSale3
   ,@KirbyCost3)
  end
 end

--ID4 ------------------------------------------------------------------------------------------
if @ID4>0
 begin
  if exists (select ID from SoldItems where ID=@ID4)
   begin
    update SoldItems set
     InvoiceDate=@InvoiceDate4
     ,ItemID=@ItemID4
     ,Quantity=@Quantity4
     ,SalesChannel=@SalesChannel4
     ,KirbyItem=@KirbyItem4   
     ,KirbysCut=@KirbysCut4
     ,SupplierID=@SupplierID4
     ,Cost=@Cost4
     ,FalseSale=@FalseSale4
     ,KirbyCost=@KirbyCost4
    where ID=@ID4
   end
  else
 begin
  insert into SoldItems
   (ID
   ,InvoiceDate
   ,ItemID
   ,Quantity
   ,SalesChannel
   ,KirbyItem
   ,KirbysCut
   ,SupplierID
   ,Cost
   ,FalseSale
   ,KirbyCost)
  values
   (@ID4
   ,@InvoiceDate4
   ,@ItemID4
   ,@Quantity4
   ,@SalesChannel4
   ,@KirbyItem4
   ,@KirbysCut4
   ,@SupplierID4
   ,@Cost4
   ,@FalseSale4
   ,@KirbyCost4)
  end
 end

--ID5 ------------------------------------------------------------------------------------------
if @ID5>0
  begin
  if exists (select ID from SoldItems where ID=@ID5)
   begin
    update SoldItems set
     InvoiceDate=@InvoiceDate5
     ,ItemID=@ItemID5
     ,Quantity=@Quantity5
     ,SalesChannel=@SalesChannel5
     ,KirbyItem=@KirbyItem5   
     ,KirbysCut=@KirbysCut5
     ,SupplierID=@SupplierID5
     ,Cost=@Cost5
     ,FalseSale=@FalseSale5
     ,KirbyCost=@KirbyCost5
    where ID=@ID5
   end
  else
 begin
  insert into SoldItems
   (ID
   ,InvoiceDate
   ,ItemID
   ,Quantity
   ,SalesChannel
   ,KirbyItem
   ,KirbysCut
   ,SupplierID
   ,Cost
   ,FalseSale
   ,KirbyCost)
  values
   (@ID5
   ,@InvoiceDate5
   ,@ItemID5
   ,@Quantity5
   ,@SalesChannel5
   ,@KirbyItem5
   ,@KirbysCut5
   ,@SupplierID5
   ,@Cost5
   ,@FalseSale5
   ,@KirbyCost5)
  end
 end

--ID6 ------------------------------------------------------------------------------------------
if @ID6>0
  begin
  if exists (select ID from SoldItems where ID=@ID6)
   begin
    update SoldItems set
     InvoiceDate=@InvoiceDate6
     ,ItemID=@ItemID6
     ,Quantity=@Quantity6
     ,SalesChannel=@SalesChannel6
     ,KirbyItem=@KirbyItem6   
     ,KirbysCut=@KirbysCut6
     ,SupplierID=@SupplierID6
     ,Cost=@Cost6
     ,FalseSale=@FalseSale6
     ,KirbyCost=@KirbyCost6
    where ID=@ID6
   end
  else
 begin
  insert into SoldItems
   (ID
   ,InvoiceDate
   ,ItemID
   ,Quantity
   ,SalesChannel
   ,KirbyItem
   ,KirbysCut
   ,SupplierID
   ,Cost
   ,FalseSale
   ,KirbyCost)
  values
   (@ID6
   ,@InvoiceDate6
   ,@ItemID6
   ,@Quantity6
   ,@SalesChannel6
   ,@KirbyItem6
   ,@KirbysCut6
   ,@SupplierID6
   ,@Cost6
   ,@FalseSale6
   ,@KirbyCost6)
  end
 end

--ID7 ------------------------------------------------------------------------------------------
if @ID7>0
  begin
  if exists (select ID from SoldItems where ID=@ID7)
   begin
    update SoldItems set
     InvoiceDate=@InvoiceDate7
     ,ItemID=@ItemID7
     ,Quantity=@Quantity7
     ,SalesChannel=@SalesChannel7
     ,KirbyItem=@KirbyItem7   
     ,KirbysCut=@KirbysCut7
     ,SupplierID=@SupplierID7
     ,Cost=@Cost7
     ,FalseSale=@FalseSale7
     ,KirbyCost=@KirbyCost7
    where ID=@ID7
   end
  else
 begin
  insert into SoldItems
   (ID
   ,InvoiceDate
   ,ItemID
   ,Quantity
   ,SalesChannel
   ,KirbyItem
   ,KirbysCut
   ,SupplierID
   ,Cost
   ,FalseSale
   ,KirbyCost)
  values
   (@ID7
   ,@InvoiceDate7
   ,@ItemID7
   ,@Quantity7
   ,@SalesChannel7
   ,@KirbyItem7
   ,@KirbysCut7
   ,@SupplierID7
   ,@Cost7
   ,@FalseSale7
   ,@KirbyCost7)
  end
 end

--ID8 ------------------------------------------------------------------------------------------
if @ID8>0
 begin
  if exists (select ID from SoldItems where ID=@ID8)
   begin
    update SoldItems set
     InvoiceDate=@InvoiceDate8
     ,ItemID=@ItemID8
     ,Quantity=@Quantity8
     ,SalesChannel=@SalesChannel8
     ,KirbyItem=@KirbyItem8   
     ,KirbysCut=@KirbysCut8
     ,SupplierID=@SupplierID8
     ,Cost=@Cost8
     ,FalseSale=@FalseSale8
     ,KirbyCost=@KirbyCost8
    where ID=@ID8
   end
  else
 begin
  insert into SoldItems
   (ID
   ,InvoiceDate
   ,ItemID
   ,Quantity
   ,SalesChannel
   ,KirbyItem
   ,KirbysCut
   ,SupplierID
   ,Cost
   ,FalseSale
   ,KirbyCost)
  values
   (@ID8
   ,@InvoiceDate8
   ,@ItemID8
   ,@Quantity8
   ,@SalesChannel8
   ,@KirbyItem8
   ,@KirbysCut8
   ,@SupplierID8
   ,@Cost8
   ,@FalseSale8
   ,@KirbyCost8)
  end
 end

--ID9 ------------------------------------------------------------------------------------------
if @ID9>0
  begin
  if exists (select ID from SoldItems where ID=@ID9)
   begin
    update SoldItems set
     InvoiceDate=@InvoiceDate9
     ,ItemID=@ItemID9
     ,Quantity=@Quantity9
     ,SalesChannel=@SalesChannel9
     ,KirbyItem=@KirbyItem9   
     ,KirbysCut=@KirbysCut9
     ,SupplierID=@SupplierID9
     ,Cost=@Cost9
     ,FalseSale=@FalseSale9
     ,KirbyCost=@KirbyCost9
    where ID=@ID9
   end
  else
 begin
  insert into SoldItems
   (ID
   ,InvoiceDate
   ,ItemID
   ,Quantity
   ,SalesChannel
   ,KirbyItem
   ,KirbysCut
   ,SupplierID
   ,Cost
   ,FalseSale
   ,KirbyCost)
  values
   (@ID9
   ,@InvoiceDate9
   ,@ItemID9
   ,@Quantity9
   ,@SalesChannel9
   ,@KirbyItem9
   ,@KirbysCut9
   ,@SupplierID9
   ,@Cost9
   ,@FalseSale9
   ,@KirbyCost9)
  end
 end

--ID10 ------------------------------------------------------------------------------------------
if @ID10>0
  begin
  if exists (select ID from SoldItems where ID=@ID10)
   begin
    update SoldItems set
     InvoiceDate=@InvoiceDate10
     ,ItemID=@ItemID10
     ,Quantity=@Quantity10
     ,SalesChannel=@SalesChannel10
     ,KirbyItem=@KirbyItem10   
     ,KirbysCut=@KirbysCut10
     ,SupplierID=@SupplierID10
     ,Cost=@Cost10
     ,FalseSale=@FalseSale10
     ,KirbyCost=@KirbyCost10
    where ID=@ID10
   end
  else
 begin
  insert into SoldItems
   (ID
   ,InvoiceDate
   ,ItemID
   ,Quantity
   ,SalesChannel
   ,KirbyItem
   ,KirbysCut
   ,SupplierID
   ,Cost
   ,FalseSale
   ,KirbyCost)
  values
   (@ID10
   ,@InvoiceDate10
   ,@ItemID10
   ,@Quantity10
   ,@SalesChannel10
   ,@KirbyItem10
   ,@KirbysCut10
   ,@SupplierID10
   ,@Cost10
   ,@FalseSale10
   ,@KirbyCost10)
  end
 end

--ID11 ------------------------------------------------------------------------------------------
if @ID11>0
  begin
  if exists (select ID from SoldItems where ID=@ID11)
   begin
    update SoldItems set
     InvoiceDate=@InvoiceDate11
     ,ItemID=@ItemID11
     ,Quantity=@Quantity11
     ,SalesChannel=@SalesChannel11
     ,KirbyItem=@KirbyItem11   
     ,KirbysCut=@KirbysCut11
     ,SupplierID=@SupplierID11
     ,Cost=@Cost11
     ,FalseSale=@FalseSale11
     ,KirbyCost=@KirbyCost11
    where ID=@ID11
   end
  else
 begin
  insert into SoldItems
   (ID
   ,InvoiceDate
   ,ItemID
   ,Quantity
   ,SalesChannel
   ,KirbyItem
   ,KirbysCut
   ,SupplierID
   ,Cost
   ,FalseSale
   ,KirbyCost)
  values
   (@ID11
   ,@InvoiceDate11
   ,@ItemID11
   ,@Quantity11
   ,@SalesChannel11
   ,@KirbyItem11
   ,@KirbysCut11
   ,@SupplierID11
   ,@Cost11
   ,@FalseSale11
   ,@KirbyCost11)
  end
 end

--ID12 ------------------------------------------------------------------------------------------
if @ID12>0
 begin
  if exists (select ID from SoldItems where ID=@ID12)
   begin
    update SoldItems set
     InvoiceDate=@InvoiceDate12
     ,ItemID=@ItemID12
     ,Quantity=@Quantity12
     ,SalesChannel=@SalesChannel12
     ,KirbyItem=@KirbyItem12   
     ,KirbysCut=@KirbysCut12
     ,SupplierID=@SupplierID12
     ,Cost=@Cost12
     ,FalseSale=@FalseSale12
     ,KirbyCost=@KirbyCost12
    where ID=@ID12
   end
  else
 begin
  insert into SoldItems
   (ID
   ,InvoiceDate
   ,ItemID
   ,Quantity
   ,SalesChannel
   ,KirbyItem
   ,KirbysCut
   ,SupplierID
   ,Cost
   ,FalseSale
   ,KirbyCost)
  values
   (@ID12
   ,@InvoiceDate12
   ,@ItemID12
   ,@Quantity12
   ,@SalesChannel12
   ,@KirbyItem12
   ,@KirbysCut12
   ,@SupplierID12
   ,@Cost12
   ,@FalseSale12
   ,@KirbyCost12)
  end
 end

--ID13 ------------------------------------------------------------------------------------------
if @ID13>0
 begin
  if exists (select ID from SoldItems where ID=@ID13)
   begin
    update SoldItems set
     InvoiceDate=@InvoiceDate13
     ,ItemID=@ItemID13
     ,Quantity=@Quantity13
     ,SalesChannel=@SalesChannel13
     ,KirbyItem=@KirbyItem13   
     ,KirbysCut=@KirbysCut13
     ,SupplierID=@SupplierID13
     ,Cost=@Cost13
     ,FalseSale=@FalseSale13
     ,KirbyCost=@KirbyCost13
    where ID=@ID13
   end
  else
 begin
  insert into SoldItems
   (ID
   ,InvoiceDate
   ,ItemID
   ,Quantity
   ,SalesChannel
   ,KirbyItem
   ,KirbysCut
   ,SupplierID
   ,Cost
   ,FalseSale
   ,KirbyCost)
  values
   (@ID13
   ,@InvoiceDate13
   ,@ItemID13
   ,@Quantity13
   ,@SalesChannel13
   ,@KirbyItem13
   ,@KirbysCut13
   ,@SupplierID13
   ,@Cost13
   ,@FalseSale13
   ,@KirbyCost13)
  end
 end

--ID14 ------------------------------------------------------------------------------------------
if @ID14>0
 begin
  if exists (select ID from SoldItems where ID=@ID14)
   begin
    update SoldItems set
     InvoiceDate=@InvoiceDate14
     ,ItemID=@ItemID14
     ,Quantity=@Quantity14
     ,SalesChannel=@SalesChannel14
     ,KirbyItem=@KirbyItem14   
     ,KirbysCut=@KirbysCut14
     ,SupplierID=@SupplierID14
     ,Cost=@Cost14
     ,FalseSale=@FalseSale14
     ,KirbyCost=@KirbyCost14
    where ID=@ID14
   end
  else
 begin
  insert into SoldItems
   (ID
   ,InvoiceDate
   ,ItemID
   ,Quantity
   ,SalesChannel
   ,KirbyItem
   ,KirbysCut
   ,SupplierID
   ,Cost
   ,FalseSale
   ,KirbyCost)
  values
   (@ID14
   ,@InvoiceDate14
   ,@ItemID14
   ,@Quantity14
   ,@SalesChannel14
   ,@KirbyItem14
   ,@KirbysCut14
   ,@SupplierID14
   ,@Cost14
   ,@FalseSale14
   ,@KirbyCost14)
  end
 end

--ID15 ------------------------------------------------------------------------------------------
if @ID15>0
  begin
  if exists (select ID from SoldItems where ID=@ID15)
   begin
    update SoldItems set
     InvoiceDate=@InvoiceDate15
     ,ItemID=@ItemID15
     ,Quantity=@Quantity15
     ,SalesChannel=@SalesChannel15
     ,KirbyItem=@KirbyItem15   
     ,KirbysCut=@KirbysCut15
     ,SupplierID=@SupplierID15
     ,Cost=@Cost15
     ,FalseSale=@FalseSale15
     ,KirbyCost=@KirbyCost15
    where ID=@ID15
   end
  else
 begin
  insert into SoldItems
   (ID
   ,InvoiceDate
   ,ItemID
   ,Quantity
   ,SalesChannel
   ,KirbyItem
   ,KirbysCut
   ,SupplierID
   ,Cost
   ,FalseSale
   ,KirbyCost)
  values
   (@ID15
   ,@InvoiceDate15
   ,@ItemID15
   ,@Quantity15
   ,@SalesChannel15
   ,@KirbyItem15
   ,@KirbysCut15
   ,@SupplierID15
   ,@Cost15
   ,@FalseSale15
   ,@KirbyCost15)
  end
 end

--ID16 ------------------------------------------------------------------------------------------
if @ID16>0
  begin
  if exists (select ID from SoldItems where ID=@ID16)
   begin
    update SoldItems set
     InvoiceDate=@InvoiceDate16
     ,ItemID=@ItemID16
     ,Quantity=@Quantity16
     ,SalesChannel=@SalesChannel16
     ,KirbyItem=@KirbyItem16   
     ,KirbysCut=@KirbysCut16
     ,SupplierID=@SupplierID16
     ,Cost=@Cost16
     ,FalseSale=@FalseSale16
     ,KirbyCost=@KirbyCost16
    where ID=@ID16
   end
  else
 begin
  insert into SoldItems
   (ID
   ,InvoiceDate
   ,ItemID
   ,Quantity
   ,SalesChannel
   ,KirbyItem
   ,KirbysCut
   ,SupplierID
   ,Cost
   ,FalseSale
   ,KirbyCost)
  values
   (@ID16
   ,@InvoiceDate16
   ,@ItemID16
   ,@Quantity16
   ,@SalesChannel16
   ,@KirbyItem16
   ,@KirbysCut16
   ,@SupplierID16
   ,@Cost16
   ,@FalseSale16
   ,@KirbyCost16)
  end
 end

--ID17 ------------------------------------------------------------------------------------------
if @ID17>0
 begin
  if exists (select ID from SoldItems where ID=@ID17)
   begin
    update SoldItems set
     InvoiceDate=@InvoiceDate17
     ,ItemID=@ItemID17
     ,Quantity=@Quantity17
     ,SalesChannel=@SalesChannel17
     ,KirbyItem=@KirbyItem17   
     ,KirbysCut=@KirbysCut17
     ,SupplierID=@SupplierID17
     ,Cost=@Cost17
     ,FalseSale=@FalseSale17
     ,KirbyCost=@KirbyCost17
    where ID=@ID17
   end
  else
 begin
  insert into SoldItems
   (ID
   ,InvoiceDate
   ,ItemID
   ,Quantity
   ,SalesChannel
   ,KirbyItem
   ,KirbysCut
   ,SupplierID
   ,Cost
   ,FalseSale
   ,KirbyCost)
  values
   (@ID17
   ,@InvoiceDate17
   ,@ItemID17
   ,@Quantity17
   ,@SalesChannel17
   ,@KirbyItem17
   ,@KirbysCut17
   ,@SupplierID17
   ,@Cost17
   ,@FalseSale17
   ,@KirbyCost17)
  end
 end

--ID18 ------------------------------------------------------------------------------------------
if @ID18>0
 begin
  if exists (select ID from SoldItems where ID=@ID18)
   begin
    update SoldItems set
     InvoiceDate=@InvoiceDate18
     ,ItemID=@ItemID18
     ,Quantity=@Quantity18
     ,SalesChannel=@SalesChannel18
     ,KirbyItem=@KirbyItem18   
     ,KirbysCut=@KirbysCut18
     ,SupplierID=@SupplierID18
     ,Cost=@Cost18
     ,FalseSale=@FalseSale18
     ,KirbyCost=@KirbyCost18
    where ID=@ID18
   end
  else
 begin
  insert into SoldItems
   (ID
   ,InvoiceDate
   ,ItemID
   ,Quantity
   ,SalesChannel
   ,KirbyItem
   ,KirbysCut
   ,SupplierID
   ,Cost
   ,FalseSale
   ,KirbyCost)
  values
   (@ID18
   ,@InvoiceDate18
   ,@ItemID18
   ,@Quantity18
   ,@SalesChannel18
   ,@KirbyItem18
   ,@KirbysCut18
   ,@SupplierID18
   ,@Cost18
   ,@FalseSale18
   ,@KirbyCost18)
  end
 end

--ID19 ------------------------------------------------------------------------------------------
if @ID19>0
 begin
  if exists (select ID from SoldItems where ID=@ID19)
   begin
    update SoldItems set
     InvoiceDate=@InvoiceDate19
     ,ItemID=@ItemID19
     ,Quantity=@Quantity19
     ,SalesChannel=@SalesChannel19
     ,KirbyItem=@KirbyItem19   
     ,KirbysCut=@KirbysCut19
     ,SupplierID=@SupplierID19
     ,Cost=@Cost19
     ,FalseSale=@FalseSale19
     ,KirbyCost=@KirbyCost19
    where ID=@ID19
   end
  else
 begin
  insert into SoldItems
   (ID
   ,InvoiceDate
   ,ItemID
   ,Quantity
   ,SalesChannel
   ,KirbyItem
   ,KirbysCut
   ,SupplierID
   ,Cost
   ,FalseSale
   ,KirbyCost)
  values
   (@ID19
   ,@InvoiceDate19
   ,@ItemID19
   ,@Quantity19
   ,@SalesChannel19
   ,@KirbyItem19
   ,@KirbysCut19
   ,@SupplierID19
   ,@Cost19
   ,@FalseSale19
   ,@KirbyCost19)
  end
 end

--ID20 ------------------------------------------------------------------------------------------
if @ID20>0
 begin
  if exists (select ID from SoldItems where ID=@ID20)
   begin
    update SoldItems set
     InvoiceDate=@InvoiceDate20
     ,ItemID=@ItemID20
     ,Quantity=@Quantity20
     ,SalesChannel=@SalesChannel20
     ,KirbyItem=@KirbyItem20   
     ,KirbysCut=@KirbysCut20
     ,SupplierID=@SupplierID20
     ,Cost=@Cost20
     ,FalseSale=@FalseSale20
     ,KirbyCost=@KirbyCost20
    where ID=@ID20
   end
  else
 begin
  insert into SoldItems
   (ID
   ,InvoiceDate
   ,ItemID
   ,Quantity
   ,SalesChannel
   ,KirbyItem
   ,KirbysCut
   ,SupplierID
   ,Cost
   ,FalseSale
   ,KirbyCost)
  values
   (@ID20
   ,@InvoiceDate20
   ,@ItemID20
   ,@Quantity20
   ,@SalesChannel20
   ,@KirbyItem20
   ,@KirbysCut20
   ,@SupplierID20
   ,@Cost20
   ,@FalseSale20
   ,@KirbyCost20)
  end
 end

--ID21 ------------------------------------------------------------------------------------------
if @ID21>0
 begin
  if exists (select ID from SoldItems where ID=@ID21)
   begin
    update SoldItems set
     InvoiceDate=@InvoiceDate21
     ,ItemID=@ItemID21
     ,Quantity=@Quantity21
     ,SalesChannel=@SalesChannel21
     ,KirbyItem=@KirbyItem21   
     ,KirbysCut=@KirbysCut21
     ,SupplierID=@SupplierID21
     ,Cost=@Cost21
     ,FalseSale=@FalseSale21
     ,KirbyCost=@KirbyCost21
    where ID=@ID21
   end
  else
 begin
  insert into SoldItems
   (ID
   ,InvoiceDate
   ,ItemID
   ,Quantity
   ,SalesChannel
   ,KirbyItem
   ,KirbysCut
   ,SupplierID
   ,Cost
   ,FalseSale
   ,KirbyCost)
  values
   (@ID21
   ,@InvoiceDate21
   ,@ItemID21
   ,@Quantity21
   ,@SalesChannel21
   ,@KirbyItem21
   ,@KirbysCut21
   ,@SupplierID21
   ,@Cost21
   ,@FalseSale21
   ,@KirbyCost21)
  end
 end

--ID22 ------------------------------------------------------------------------------------------
if @ID22>0
 begin
  if exists (select ID from SoldItems where ID=@ID22)
   begin
    update SoldItems set
     InvoiceDate=@InvoiceDate22
     ,ItemID=@ItemID22
     ,Quantity=@Quantity22
     ,SalesChannel=@SalesChannel22
     ,KirbyItem=@KirbyItem22   
     ,KirbysCut=@KirbysCut22
     ,SupplierID=@SupplierID22
     ,Cost=@Cost22
     ,FalseSale=@FalseSale22
     ,KirbyCost=@KirbyCost22
    where ID=@ID22
   end
  else
 begin
  insert into SoldItems
   (ID
   ,InvoiceDate
   ,ItemID
   ,Quantity
   ,SalesChannel
   ,KirbyItem
   ,KirbysCut
   ,SupplierID
   ,Cost
   ,FalseSale
   ,KirbyCost)
  values
   (@ID22
   ,@InvoiceDate22
   ,@ItemID22
   ,@Quantity22
   ,@SalesChannel22
   ,@KirbyItem22
   ,@KirbysCut22
   ,@SupplierID22
   ,@Cost22
   ,@FalseSale22
   ,@KirbyCost22)
  end
 end

--ID23 ------------------------------------------------------------------------------------------
if @ID23>0
 begin
  if exists (select ID from SoldItems where ID=@ID23)
   begin
    update SoldItems set
     InvoiceDate=@InvoiceDate23
     ,ItemID=@ItemID23
     ,Quantity=@Quantity23
     ,SalesChannel=@SalesChannel23
     ,KirbyItem=@KirbyItem23   
     ,KirbysCut=@KirbysCut23
     ,SupplierID=@SupplierID23
     ,Cost=@Cost23
     ,FalseSale=@FalseSale23
     ,KirbyCost=@KirbyCost23
    where ID=@ID23
   end
  else
 begin
  insert into SoldItems
   (ID
   ,InvoiceDate
   ,ItemID
   ,Quantity
   ,SalesChannel
   ,KirbyItem
   ,KirbysCut
   ,SupplierID
   ,Cost
   ,FalseSale
   ,KirbyCost)
  values
   (@ID23
   ,@InvoiceDate23
   ,@ItemID23
   ,@Quantity23
   ,@SalesChannel23
   ,@KirbyItem23
   ,@KirbysCut23
   ,@SupplierID23
   ,@Cost23
   ,@FalseSale23
   ,@KirbyCost23)
  end
 end

--ID24 ------------------------------------------------------------------------------------------
if @ID24>0
 begin
  if exists (select ID from SoldItems where ID=@ID24)
   begin
    update SoldItems set
     InvoiceDate=@InvoiceDate24
     ,ItemID=@ItemID24
     ,Quantity=@Quantity24
     ,SalesChannel=@SalesChannel24
     ,KirbyItem=@KirbyItem24   
     ,KirbysCut=@KirbysCut24
     ,SupplierID=@SupplierID24
     ,Cost=@Cost24
     ,FalseSale=@FalseSale24
     ,KirbyCost=@KirbyCost24
    where ID=@ID24
   end
  else
 begin
  insert into SoldItems
   (ID
   ,InvoiceDate
   ,ItemID
   ,Quantity
   ,SalesChannel
   ,KirbyItem
   ,KirbysCut
   ,SupplierID
   ,Cost
   ,FalseSale
   ,KirbyCost)
  values
   (@ID24
   ,@InvoiceDate24
   ,@ItemID24
   ,@Quantity24
   ,@SalesChannel24
   ,@KirbyItem24
   ,@KirbysCut24
   ,@SupplierID24
   ,@Cost24
   ,@FalseSale24
   ,@KirbyCost24)
  end
 end

--ID25 ------------------------------------------------------------------------------------------
if @ID25>0
 begin
  if exists (select ID from SoldItems where ID=@ID25)
   begin
    update SoldItems set
     InvoiceDate=@InvoiceDate25
     ,ItemID=@ItemID25
     ,Quantity=@Quantity25
     ,SalesChannel=@SalesChannel25
     ,KirbyItem=@KirbyItem25   
     ,KirbysCut=@KirbysCut25
     ,SupplierID=@SupplierID25
     ,Cost=@Cost25
     ,FalseSale=@FalseSale25
     ,KirbyCost=@KirbyCost25
    where ID=@ID25
   end
  else
 begin
  insert into SoldItems
   (ID
   ,InvoiceDate
   ,ItemID
   ,Quantity
   ,SalesChannel
   ,KirbyItem
   ,KirbysCut
   ,SupplierID
   ,Cost
   ,FalseSale
   ,KirbyCost)
  values
   (@ID25
   ,@InvoiceDate25
   ,@ItemID25
   ,@Quantity25
   ,@SalesChannel25
   ,@KirbyItem25
   ,@KirbysCut25
   ,@SupplierID25
   ,@Cost25
   ,@FalseSale25
   ,@KirbyCost25)
  end
 end

--ID26 ------------------------------------------------------------------------------------------
if @ID26>0
 begin
  if exists (select ID from SoldItems where ID=@ID26)
   begin
    update SoldItems set
     InvoiceDate=@InvoiceDate26
     ,ItemID=@ItemID26
     ,Quantity=@Quantity26
     ,SalesChannel=@SalesChannel26
     ,KirbyItem=@KirbyItem26   
     ,KirbysCut=@KirbysCut26
     ,SupplierID=@SupplierID26
     ,Cost=@Cost26
     ,FalseSale=@FalseSale26
     ,KirbyCost=@KirbyCost26
    where ID=@ID26
   end
  else
 begin
  insert into SoldItems
   (ID
   ,InvoiceDate
   ,ItemID
   ,Quantity
   ,SalesChannel
   ,KirbyItem
   ,KirbysCut
   ,SupplierID
   ,Cost
   ,FalseSale
   ,KirbyCost)
  values
   (@ID26
   ,@InvoiceDate26
   ,@ItemID26
   ,@Quantity26
   ,@SalesChannel26
   ,@KirbyItem26
   ,@KirbysCut26
   ,@SupplierID26
   ,@Cost26
   ,@FalseSale26
   ,@KirbyCost26)
  end
 end

--ID27 ------------------------------------------------------------------------------------------
if @ID27>0
 begin
  if exists (select ID from SoldItems where ID=@ID27)
   begin
    update SoldItems set
     InvoiceDate=@InvoiceDate27
     ,ItemID=@ItemID27
     ,Quantity=@Quantity27
     ,SalesChannel=@SalesChannel27
     ,KirbyItem=@KirbyItem27   
     ,KirbysCut=@KirbysCut27
     ,SupplierID=@SupplierID27
     ,Cost=@Cost27
     ,FalseSale=@FalseSale27
     ,KirbyCost=@KirbyCost27
    where ID=@ID27
   end
  else
 begin
  insert into SoldItems
   (ID
   ,InvoiceDate
   ,ItemID
   ,Quantity
   ,SalesChannel
   ,KirbyItem
   ,KirbysCut
   ,SupplierID
   ,Cost
   ,FalseSale
   ,KirbyCost)
  values
   (@ID27
   ,@InvoiceDate27
   ,@ItemID27
   ,@Quantity27
   ,@SalesChannel27
   ,@KirbyItem27
   ,@KirbysCut27
   ,@SupplierID27
   ,@Cost27
   ,@FalseSale27
   ,@KirbyCost27)
  end
 end

--ID28 ------------------------------------------------------------------------------------------
if @ID28>0
 begin
  if exists (select ID from SoldItems where ID=@ID28)
   begin
    update SoldItems set
     InvoiceDate=@InvoiceDate28
     ,ItemID=@ItemID28
     ,Quantity=@Quantity28
     ,SalesChannel=@SalesChannel28
     ,KirbyItem=@KirbyItem28   
     ,KirbysCut=@KirbysCut28
     ,SupplierID=@SupplierID28
     ,Cost=@Cost28
     ,FalseSale=@FalseSale28
     ,KirbyCost=@KirbyCost28
    where ID=@ID28
   end
  else
 begin
  insert into SoldItems
   (ID
   ,InvoiceDate
   ,ItemID
   ,Quantity
   ,SalesChannel
   ,KirbyItem
   ,KirbysCut
   ,SupplierID
   ,Cost
   ,FalseSale
   ,KirbyCost)
  values
   (@ID28
   ,@InvoiceDate28
   ,@ItemID28
   ,@Quantity28
   ,@SalesChannel28
   ,@KirbyItem28
   ,@KirbysCut28
   ,@SupplierID28
   ,@Cost28
   ,@FalseSale28
   ,@KirbyCost28)
  end
 end

--ID29 ------------------------------------------------------------------------------------------
if @ID29>0
 begin
  if exists (select ID from SoldItems where ID=@ID29)
   begin
    update SoldItems set
     InvoiceDate=@InvoiceDate29
     ,ItemID=@ItemID29
     ,Quantity=@Quantity29
     ,SalesChannel=@SalesChannel29
     ,KirbyItem=@KirbyItem29   
     ,KirbysCut=@KirbysCut29
     ,SupplierID=@SupplierID29
     ,Cost=@Cost29
     ,FalseSale=@FalseSale29
     ,KirbyCost=@KirbyCost29
    where ID=@ID29
   end
  else
 begin
  insert into SoldItems
   (ID
   ,InvoiceDate
   ,ItemID
   ,Quantity
   ,SalesChannel
   ,KirbyItem
   ,KirbysCut
   ,SupplierID
   ,Cost
   ,FalseSale
   ,KirbyCost)
  values
   (@ID29
   ,@InvoiceDate29
   ,@ItemID29
   ,@Quantity29
   ,@SalesChannel29
   ,@KirbyItem29
   ,@KirbysCut29
   ,@SupplierID29
   ,@Cost29
   ,@FalseSale29
   ,@KirbyCost29)
  end
 end


select 'success' as ReturnValue

COMMIT TRANSACTION Z

END TRY
BEGIN CATCH
 if @@trancount>0
  rollback
 select 'SQL SERVER ERROR in SPROC spSync_SoldItems: ' + ERROR_MESSAGE() + ' LINE ' + cast(ERROR_LINE() as nvarchar(10)) as ReturnValue
END CATCH











