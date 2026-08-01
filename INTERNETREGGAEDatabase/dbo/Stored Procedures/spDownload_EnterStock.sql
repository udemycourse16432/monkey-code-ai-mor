













create PROCEDURE [dbo].[spDownload_EnterStock]

AS

select top 1 * from EnterStock where Status ='completed' order by counter











