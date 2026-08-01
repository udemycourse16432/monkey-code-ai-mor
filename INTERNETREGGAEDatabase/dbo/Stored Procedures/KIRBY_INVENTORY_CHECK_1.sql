

create PROCEDURE [dbo].KIRBY_INVENTORY_CHECK_1 as

select sum(inventory*storeprice) from inventory where format='LP'



select inventory*storeprice,inventory,id,ArtistTitle from inventory where format='LP'
order by inventory*storeprice desc

