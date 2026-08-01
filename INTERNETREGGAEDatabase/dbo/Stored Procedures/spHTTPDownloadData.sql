










CREATE PROCEDURE [dbo].[spHTTPDownloadData]

@TableName nvarchar(100)

AS

declare @SQL1 nvarchar(1000)

if @TableName='Orders'
 begin
  set @SQL1="select top 1 * from Orders where DownloadGroup is null and Status='ordered' order by counter"
 end
else if @TableName='OrderItems'
 begin
  set @SQL1="select top 1 OrderItems.* from OrderItems
  inner join Orders on OrderItems.OrderNumber = Orders.OrderNumber
  where Orders.Status='ordered'
  and OrderItems.DownloadGroup is null
  order by counter"
 end
else if @TableName='Customers'
 begin
  set @SQL1="select top 1 * from Customers 
  where DownloadGroup is null
  and PowerUserName is null and SuperPowerUserName is null order by counter"
 end
else if @TableName='GiftCards'
 begin
  set @SQL1="select top 1 * from GiftCards 
  where DownloadGroup is null
  and IPAddress is not null
  order by counter"
 end
else
 begin
  set @SQL1="select top 1 * from "+@TableName+" where DownloadGroup is null order by counter"
 end

EXEC (@SQL1)








