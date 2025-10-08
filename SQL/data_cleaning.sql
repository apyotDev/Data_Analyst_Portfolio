--Cleaning Data in SQL Queries:


Select* from portfolio_projects..Nashville_housing

--Standardize Date Format:

Alter table Nashville_housing
add sale_date_formatted Date;

Update Nashville_housing
set sale_date_formatted=Convert(Date,SaleDate)

--Populate Property Address Data:
Select *
from portfolio_projects..Nashville_housing
order by ParcelID

Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,
isnull(a.PropertyAddress,b.PropertyAddress)
from portfolio_projects..Nashville_housing a
join portfolio_projects..Nashville_housing b
on  a.ParcelID=b.ParcelID and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress= isnull(a.PropertyAddress,b.PropertyAddress)
from portfolio_projects..Nashville_housing a
join portfolio_projects..Nashville_housing b
on  a.ParcelID=b.ParcelID and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null


--Breaking out Address INTO individual Columns(Address,City,State) in PropertyAddress Column:

select PropertyAddress from
portfolio_projects..Nashville_housing

Select 
Substring(PropertyAddress,1,charIndex(',',PropertyAddress)-1) 
as Address,
Substring(PropertyAddress,charIndex(',',PropertyAddress)+1,len(PropertyAddress)) 
as Address
from
portfolio_projects..Nashville_housing
----------------------------------------------------------
--Adding Column and inserting data to Address:
Alter table portfolio_projects..Nashville_housing
add Property_Split_Address nvarchar(255)

update portfolio_projects..Nashville_housing 
set Property_Split_Address=Substring(PropertyAddress,1,charIndex(',',PropertyAddress)-1)

------------------------------------------------------------------------------------------
--Adding Column and inserting data to City:
alter table portfolio_projects..Nashville_housing
add Property_Split_City nvarchar(255)

update portfolio_projects..Nashville_housing 
set Property_Split_City=Substring(PropertyAddress,
charIndex(',',PropertyAddress)+1,len(PropertyAddress))



--Breaking out Address INTO individual Columns(Address,City,State) in OwnerAddress Column:


Select OwnerAddress from
portfolio_projects..Nashville_housing 


 Select Parsename(replace(OwnerAddress,',','.'),3),
 Parsename(replace(OwnerAddress,',','.'),2),
 Parsename(replace(OwnerAddress,',','.'),1)
 from portfolio_projects..Nashville_housing

 --For Owners Address:
 Alter Table portfolio_projects..Nashville_housing
 add Owner_Split_Address nvarchar(255)

 Update portfolio_projects..Nashville_housing
 set Owner_Split_Address=Parsename(replace(OwnerAddress,',','.'),3)
 
 --For Owners City:
 Alter Table portfolio_projects..Nashville_housing
 add Owner_Split_City nvarchar(255)

 Update portfolio_projects..Nashville_housing
 set Owner_Split_City=Parsename(replace(OwnerAddress,',','.'),2)

 --For Owners States:
 Alter Table portfolio_projects..Nashville_housing
 add Owner_Split_State nvarchar(255)

 Update portfolio_projects..Nashville_housing
 set Owner_Split_State=Parsename(replace(OwnerAddress,',','.'),1)


--Change Y and N to Yes and No in 'SoldAsVacant' Field:

select distinct(SoldAsVacant),count(SoldAsVacant)
from portfolio_projects..Nashville_housing
group by SoldAsVacant 


select SoldAsVacant,
case
when SoldAsVacant ='Y' then 'Yes'
when SoldAsVacant='N' then 'No'
else SoldAsVacant
end as Updated_SoldAsVacant
from portfolio_projects..Nashville_housing

--Updating Column,SoldASVacant:
Update portfolio_projects..Nashville_housing
set SoldAsVacant=
Case
when SoldAsVacant ='Y' then 'Yes'
when SoldAsVacant='N' then 'No'
else SoldAsVacant
end 

select distinct(SoldAsVacant),count(SoldAsVacant)
from portfolio_projects..Nashville_housing
group by SoldAsVacant 

--Removing Duplicate Data:
select * from portfolio_projects..Nashville_housing

with RowNumCTE as(
select *,
Row_number() over (partition by ParcelID,PropertyAddress,
SalePrice,sale_date_formatted,
LegalReference
order by UniqueID ) row_num
from portfolio_projects..Nashville_housing
)

select * from RowNumCTE
where row_num>1

delete from RowNumCTE
where row_num>1


--Remove Unused Column:
select * from portfolio_projects..Nashville_housing

alter table portfolio_projects..Nashville_housing
drop column OwnerAddress,TaxDistrict,PropertyAddress,SaleDate









