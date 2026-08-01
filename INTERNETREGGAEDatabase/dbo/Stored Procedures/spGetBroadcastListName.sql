


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].spGetBroadcastListName

@counter int
AS

select BroadcastListName from BroadcastMaster
where [counter] =@counter
