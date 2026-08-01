













CREATE PROCEDURE [dbo].[spDownload_Customers]

AS

select top 1 * from Customers where InSync ='n' order by counter











