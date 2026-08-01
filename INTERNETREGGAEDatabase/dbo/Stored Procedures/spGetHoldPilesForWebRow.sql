
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].spGetHoldPilesForWebRow

@HoldPileNumber nvarchar(20)

AS

select * from HoldPilesForWeb
where HoldPileNumber=@HoldPileNumber