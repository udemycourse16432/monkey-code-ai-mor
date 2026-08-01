

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spCheckForZoneInShippingTable]

@TableName nvarchar(100)

AS

declare @sql nvarchar(max)
set @sql = 'select * from Web'+@TableName

exec (@sql)
