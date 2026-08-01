CREATE PROCEDURE [dbo].[spRecordPurchase]
 @LogInEmail nvarchar(100)
,@Password nvarchar(50)
,@PriceGroup nvarchar(20)
,@UserAgent nvarchar(1024)
,@Weight numeric(10,2)
,@DateTime datetime
,@CustomerServerCounter int
,@ChangedAddress nvarchar(500)
,@PowerUserName nvarchar(10)
,@RemHost nvarchar(400)
,@SessionID nvarchar(50)
,@ShippingMethod nvarchar(50)
,@CreditCardNumber nvarchar(255)
,@ExpDate nvarchar(6)
,@CreditCardAmountPaid numeric(10,2)
,@PONumber nvarchar(100)
,@PrintedInvoice nvarchar(1)
,@Email nvarchar(100)
,@ShippingMethodPullSheetText nvarchar(50)
,@Phone nvarchar(30)
,@FullName nvarchar(300)
,@StreetAddress1 nvarchar(300)
,@StreetAddress2 nvarchar(300)
,@City nvarchar(100)
,@Island nvarchar(50)
,@StateProvince nvarchar(100)
,@PostalCode nvarchar(25)
,@Country nvarchar(100)
,@BillingFullName nvarchar(200)
,@BillingStreetAddress1 nvarchar(100)
,@BillingStreetAddress2 nvarchar(120)
,@BillingCity nvarchar(100)
,@BillingIsland nvarchar(50)
,@BillingStateProvince nvarchar(100)
,@BillingPostalCode nvarchar(25)
,@BillingCountry nvarchar(100)
,@HowFoundUs nvarchar(50)
,@Status nvarchar(20)
,@OrderNumber nvarchar(15)
,@OrderProcessChoice nvarchar(50)
,@CustomerID nvarchar(30)
,@PayPalAmountDue numeric(10, 2)
,@GoogleCheckoutAmountDue numeric(10, 2)
,@WesternUnionAmountDue numeric(10, 2)
,@CheckCashorMoneyOrderAmountDue numeric(10, 2)
,@IPAddress nvarchar(50)
,@OrderNotes nvarchar(1000)
,@Shipping numeric(7, 2)
,@Tax numeric(7, 2)
,@TotalPrice numeric(8, 2)
,@OrderTotal numeric(8, 2)
,@TotalQuantity int
,@GiftCardAmount numeric(18, 2)
,@GiftCardNumber nvarchar(20)
,@GiftCardAccountsServerCounter int
,@NumberOfLineItems int
,@CartName nvarchar(60)
AS

--Orders Table--------------------------------------------------------

INSERT INTO Orders
(LogInEmail
,Password
,PriceGroup
,UserAgent
,Weight
,[DateTime]
,CustomerServerCounter
,ChangedAddress
,PowerUserName
,RemHost
,SessionID
,ShippingMethod
,CreditCardNumber
,ExpDate
,CreditCardAmountPaid
,PONumber
,PrintedInvoice
,Email
,ShippingMethodPullSheetText
,Phone
,FullName
,StreetAddress1
,StreetAddress2
,City
,Island
,StateProvince
,PostalCode
,Country
,BillingFullName
,BillingStreetAddress1
,BillingStreetAddress2
,BillingCity
,BillingIsland
,BillingStateProvince
,BillingPostalCode
,BillingCountry
,HowFoundUs
,Status
,OrderNumber
,OrderProcessChoice
,CustomerID
,PayPalAmountDue
,GoogleCheckoutAmountDue
,WesternUnionAmountDue
,CheckCashorMoneyOrderAmountDue
,IPAddress
,OrderNotes
,Shipping
,Tax
,TotalPrice
,OrderTotal
,TotalQuantity
,GiftCardAmount
,GiftCardNumber
,GiftCardAccountsServerCounter
,NumberOfLineItems)

VALUES

(@LogInEmail
,@Password
,@PriceGroup
,@UserAgent
,@Weight
,@DateTime
,@CustomerServerCounter
,@ChangedAddress
,@PowerUserName
,@RemHost
,@SessionID
,@ShippingMethod
,@CreditCardNumber
,@ExpDate
,@CreditCardAmountPaid
,@PONumber
,@PrintedInvoice
,@Email
,@ShippingMethodPullSheetText
,@Phone
,@FullName
,@StreetAddress1
,@StreetAddress2
,@City
,@Island
,@StateProvince
,@PostalCode
,@Country
,@BillingFullName
,@BillingStreetAddress1
,@BillingStreetAddress2
,@BillingCity
,@BillingIsland
,@BillingStateProvince
,@BillingPostalCode
,@BillingCountry
,@HowFoundUs
,@Status
,@OrderNumber
,@OrderProcessChoice
,@CustomerID
,@PayPalAmountDue
,@GoogleCheckoutAmountDue
,@WesternUnionAmountDue
,@CheckCashorMoneyOrderAmountDue
,@IPAddress
,@OrderNotes
,@Shipping
,@Tax
,@TotalPrice
,@OrderTotal
,@TotalQuantity
,@GiftCardAmount
,@GiftCardNumber
,@GiftCardAccountsServerCounter
,@NumberOfLineItems)

--OrderItems Table-----------------------------------------------------------

INSERT INTO orderitems

(OrderNumber
,InventoryID
,Quantity
,Price
,Format
,[Catalog]
,Description
,Label
,Inventory
,SearchCriteriaStatisticsID
,SupplierID
,KirbyItem
,KirbysCut
,Cost
,KirbyCost)

SELECT

 @OrderNumber
,ItemID
,Quantity
,Price
,Format
,Catalog
,LTrim(RTrim([ArtistTitle]+' '+isnull([ItemDetailsWeb],'')))
,Label
,Inventory
,SearchCriteriaStatisticsID
,SupplierID
,KirbyItem
,KirbysCut
,Cost
,KirbyCost

FROM Carts
INNER JOIN inventory on Carts.ItemID = inventory.ID
WHERE CartName=@CartName
and SaveForLater is null
