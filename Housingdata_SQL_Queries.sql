Cleaning Data in SQL Queries
*/


Select *
From Housing_data.dbo.House


-- Standardize Date Format


Select SaleDate, CONVERT(Date,SaleDate) 'SaleDate'
From Housing_data.dbo.House


Update dbo.House
SET SaleDate = CONVERT(Date,SaleDate)

-- If it doesn't Update properly

ALTER TABLE Housing_data.dbo.House
Add SaleDateConverted Date;

Update Housing_data.dbo.House
SET SaleDateConverted = CONVERT(Date,SaleDate)



-- Populate Property Address data

Select *
From Housing_data.dbo.House
--Where PropertyAddress is null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From Housing_data.dbo.House a
JOIN Housing_data.dbo.House b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From Housing_data.dbo.House a
JOIN Housing_data.dbo.House b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null





-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From Housing_data.dbo.House
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From Housing_data.dbo.House


ALTER TABLE Housing_data.dbo.House
Add PropertySplitAddress Nvarchar(255);

Update Housing_data.dbo.House
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE Housing_data.dbo.House
Add PropertySplitCity Nvarchar(255);

Update Housing_data.dbo.House
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From Housing_data.dbo.House




Select OwnerAddress
From Housing_data.dbo.House


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From Housing_data.dbo.House



ALTER TABLE dbo.House
Add OwnerSplitAddress Nvarchar(255);

Update dbo.House
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE Housing_data.dbo.House
Add OwnerSplitCity Nvarchar(255);

Update dbo.House
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE dbo.House
Add OwnerSplitState Nvarchar(255);

Update Housing_data.dbo.House
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From Housing_data.dbo.House



-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From Housing_data.dbo.House
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From Housing_data.dbo.House


Update dbo.House
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END






-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From Housing_data.dbo.House
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From Housing_data.dbo.House




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From Housing_data.dbo.House


ALTER TABLE Housing_data.dbo.House
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate


