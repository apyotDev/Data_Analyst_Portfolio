--Cleaning Data in SQL Queries:


Select* from portfolio_projects..Nashville_housing

--Standardize Date Format:

Alter table Nashville_housing
add sale_date_formatted Date;

Update Nashville_housing
set sale_date_formatted=Convert(Date,SaleDate)

alter table Nashville_housing
drop column SaleDate

--Populate Property Address Data:

sel

--Change Y and N to Yes and No in 'SoldAsVacant' Field:
--Remove Duplicate Rows:

--Remove Unused Column