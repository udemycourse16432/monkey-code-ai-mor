-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================

CREATE PROCEDURE [spUpdateAMessageFromErnie] 

 @Message text
,@Title nvarchar(42)
,@ID int

AS

UPDATE AMessageFromErnie
  SET Message=@Message
  ,Title=@Title
  WHERE ID=@ID
