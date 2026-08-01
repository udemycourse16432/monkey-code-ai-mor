


create PROCEDURE [dbo].[spSync_Residential]
 @CustomerServerCounter int
,@FedExResidential nvarchar(1)

AS

update Customers
set ResidentialDelivery=@FedExResidential
where counter=@CustomerServerCounter