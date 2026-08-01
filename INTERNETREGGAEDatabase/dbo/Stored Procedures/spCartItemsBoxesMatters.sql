
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spCartItemsBoxesMatters]

@CartName nvarchar(60)

AS

SELECT CartName,WebFormatInformation.Format, Sum([Quantity]/[MaxNumberFitInOneBox]) AS Expr1
FROM Carts
INNER JOIN [inventory] ON Carts.ItemID = [inventory].ID
INNER JOIN [WebFormatInformation] ON [inventory].format = [WebFormatInformation].Format
GROUP BY CartName,WebFormatInformation.Format,Inventory
HAVING CartName=@CartName and Inventory>0
