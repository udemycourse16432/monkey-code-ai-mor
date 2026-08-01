




-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spSync_EmailsFromTheWebServer]

@ID int,
@Description nvarchar(255),
@PageUsed nvarchar(50),
@Notes nvarchar(max),
@Subject1 nvarchar(255),
@DescriptionOfCodeAfterSubject1 nvarchar(255),
@Subject2 nvarchar(255),
@Body1 nvarchar(max),
@DescriptionOfCodeAfterBody1 nvarchar(255),
@Body2 nvarchar(max),
@DescriptionOfCodeAfterBody2 nvarchar(255),
@Body3 nvarchar(max),
@DescriptionOfCodeAfterBody3 nvarchar(255),
@Body4 nvarchar(max),
@DescriptionOfCodeAfterBody4 nvarchar(255),
@Body5 nvarchar(max),
@DescriptionOfCodeAfterBody5 nvarchar(255),
@Body6 nvarchar(max),
@CustomFooter nvarchar(255)

AS

if exists (select ID from EmailsFromTheWebServer where ID=@ID)
 begin
  update EmailsFromTheWebServer set
  Description=@Description
  ,PageUsed=@PageUsed
  ,Notes=@Notes
  ,Subject1=@Subject1
  ,DescriptionOfCodeAfterSubject1=@DescriptionOfCodeAfterSubject1
  ,Subject2=@Subject2
  ,Body1=@Body1
  ,DescriptionOfCodeAfterBody1=@DescriptionOfCodeAfterBody1
  ,Body2=@Body2
  ,DescriptionOfCodeAfterBody2=@DescriptionOfCodeAfterBody2
  ,Body3=@Body3
  ,DescriptionOfCodeAfterBody3=@DescriptionOfCodeAfterBody3
  ,Body4=@Body4
  ,DescriptionOfCodeAfterBody4=@DescriptionOfCodeAfterBody4
  ,Body5=@Body5
  ,DescriptionOfCodeAfterBody5=@DescriptionOfCodeAfterBody5
  ,Body6=@Body6
  ,CustomFooter=@CustomFooter
  where ID=@ID
 end
else
 begin
  insert into EmailsFromTheWebServer
   (ID
   ,Description
   ,PageUsed
   ,Notes
   ,Subject1
   ,DescriptionOfCodeAfterSubject1
   ,Subject2
   ,Body1
   ,DescriptionOfCodeAfterBody1
   ,Body2
   ,DescriptionOfCodeAfterBody2
   ,Body3
   ,DescriptionOfCodeAfterBody3
   ,Body4
   ,DescriptionOfCodeAfterBody4
   ,Body5
   ,DescriptionOfCodeAfterBody5
   ,Body6
   ,CustomFooter)
  values
   (@ID
   ,@Description
   ,@PageUsed
   ,@Notes
   ,@Subject1
   ,@DescriptionOfCodeAfterSubject1
   ,@Subject2
   ,@Body1
   ,@DescriptionOfCodeAfterBody1
   ,@Body2
   ,@DescriptionOfCodeAfterBody2
   ,@Body3
   ,@DescriptionOfCodeAfterBody3
   ,@Body4
   ,@DescriptionOfCodeAfterBody4
   ,@Body5
   ,@DescriptionOfCodeAfterBody5
   ,@Body6
   ,@CustomFooter)
 end





