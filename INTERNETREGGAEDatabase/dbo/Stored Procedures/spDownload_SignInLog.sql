












CREATE PROCEDURE [dbo].[spDownload_SignInLog]

AS

select top 1 * from SignInLog where insync='n' order by counter










