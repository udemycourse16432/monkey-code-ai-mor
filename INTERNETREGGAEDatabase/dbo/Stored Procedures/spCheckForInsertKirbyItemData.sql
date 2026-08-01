





create PROCEDURE [dbo].[spCheckForInsertKirbyItemData]

AS
if not exists
 (select counter from KirbyItemData
 where Year([DateTime])=Year(GetDate())
 and Month([DateTime])=Month(GetDate())
 and Day([DateTime])=Day(GetDate()))
 begin
  select 'y' as [InsertData]
 end
 else
 begin
  select 'n' as [InsertData]
 end











