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

CREATE PROCEDURE spGetAMessageFromErnieMessages

AS

select *
 ,datename(month,DateTime) as sqlMonth
 ,datename(day,DateTime) as sqlDay
 ,datename(year,DateTime) as sqlYear from AMessageFromErnie
 where Message is not null and [Title] is not null
 order by ID desc
