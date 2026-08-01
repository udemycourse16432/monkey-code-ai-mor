
CREATE PROCEDURE [spCheckImages]

AS

select id from inventory
where inventory>0
and ShowOnWebsite='y'
order by id