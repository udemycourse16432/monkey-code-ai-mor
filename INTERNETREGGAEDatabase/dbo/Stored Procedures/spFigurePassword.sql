

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spFigurePassword]


AS

declare @Password nvarchar(6)
declare @z int = 0

while @z = 0 or @z=73 or @z=79
begin
 set @z = rand()*(90-65+1)+65
end
set @Password=char(@z)
set @z=0

while @z = 0 or @z=73 or @z=79
begin
 set @z = rand()*(90-65+1)+65
end
set @Password=@Password+char(@z)
set @z=0

set @z = rand()*(57-50+1)+50
set @Password=@Password+char(@z)
set @z=0

set @z = rand()*(57-50+1)+50
set @Password=@Password+char(@z)
set @z=0

while @z = 0 or @z=73 or @z=79
begin
 set @z = rand()*(90-65+1)+65
end
set @Password=@Password+char(@z)
set @z=0

while @z = 0 or @z=73 or @z=79
begin
 set @z = rand()*(90-65+1)+65
end
set @Password=@Password+char(@z)
set @z=0


select @Password as Password

