

CREATE FUNCTION [dbo].[FigureWebReviewHTML] 
(
 @UsedItem char(1)
,@ConditionJacket nvarchar(3)
,@ConditionVinylOrCD nvarchar(3)
,@WebReview nvarchar(max)
,@Format nvarchar(7)
)

RETURNS nvarchar(max)
AS
BEGIN
 Declare @WebReviewHTML as nvarchar(max)
 set @WebReviewHTML=''
 if @WebReview is null
  set @WebReview=''
 if upper(@UsedItem) = 'Y'
  begin
   if @ConditionJacket is not null
    set @WebReviewHTML = 'Jacket Condition = ' + @ConditionJacket
   if @ConditionVinylOrCD is not null
    begin
     if @Format='LP' or @Format='12"' or @Format='10"' or @Format='7"'
      begin
       if @WebReviewHTML=''
        set @WebReviewHTML = 'Vinyl Condition &nbsp;&nbsp;= ' + @ConditionVinylOrCD
       else
        set @WebReviewHTML = @WebReviewHTML + '<BR>Vinyl Condition &nbsp;&nbsp;= ' + @ConditionVinylOrCD
      end
    end
   if @ConditionJacket ='N' and @ConditionVinylOrCD ='N'
    set @WebReviewHTML=''
   if @WebReviewHTML=''
    begin
     if len(@WebReview)>0
      set @WebReviewHTML = '<img src="http://www.ebreggae.com/a/yr1.gif"><br>' + @WebReview
    end
   else
    begin
     set @WebReviewHTML = '<img src="http://www.ebreggae.com/a/co1.gif"><a href="http://www.ebreggae.com/CE.asp"><img class="a"src="http://www.ebreggae.com/a/ce.gif"></a><BR>' + @WebReviewHTML
     if len(@WebReview)>0
      set @WebReviewHTML = @WebReviewHTML + '<BR><img src="http://www.ebreggae.com/a/yrd.gif"><br>' + @WebReview
    end
  end
 else
  begin
   if len(@WebReview)>0
    set @WebReviewHTML = '<img src="http://www.ebreggae.com/a/yr1.gif"><br>' + @WebReview
  end
 
 if left(@WebReviewHTML,4)='<BR>'
  set @WebReviewHTML=right(@WebReviewHTML,len(@WebReviewHTML)-4)
 if @WebReviewHTML=''
  set @WebReviewHTML = null
 return @WebReviewHTML
END


