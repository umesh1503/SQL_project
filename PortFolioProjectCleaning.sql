--Cleaning Data in SQL 

Select *
From [PortFolio].[dbo].[NationalHousing] 

--Standardizing the Date Column 

Select SaleDate , Convert(Date, SaleDate) 
From [PortFolio].[dbo].[NationalHousing]

Update NationalHousing
SET SaleDate =  Convert(Date, SaleDate) 

-- Another Way of Altering the table through Adding a Column
Alter Table NationalHousing
Add SaleDate2 date;

Update NationalHousing
Set SaleDate2 = Convert(Date, SaleDate) 

--Populating the address column (Based on Personal ID)

Select PropertyAddress
From [PortFolio].[dbo].[NationalHousing]
Where PropertyAddress is null 

Select a.ParcelID , a.PropertyAddress , b.ParcelID , b.PropertyAddress
From [PortFolio].[dbo].[NationalHousing] as a
Join [PortFolio].[dbo].[NationalHousing] as b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null 

Update a
Set a.PropertyAddress = Isnull(a.PropertyAddress , b.PropertyAddress)
From [PortFolio].[dbo].[NationalHousing] as a
Join [PortFolio].[dbo].[NationalHousing] as b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]


-- Formating the Address as Address,City,State

Select 
Substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
Substring(PropertyAddress,CHARINDEX(',',PropertyAddress) +1,LEN(PropertyAddress)) as City
From [PortFolio].[dbo].[NationalHousing] 

Alter Table NationalHousing
Add Property_address Varchar(200);

Update NationalHousing
Set Property_address = Substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

Alter Table [PortFolio].[dbo].[NationalHousing] 
Add Property_city varchar(200);

update [PortFolio].[dbo].[NationalHousing] 
Set Property_city = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))


--Formating SoldAsVacant (Y,Yes,N,No)

Select distinct(SoldAsVacant) , count(SoldAsVacant)
From [PortFolio].[dbo].[NationalHousing]
group by SoldAsVacant
order by SoldAsVacant

Select SoldAsVacant
,Case
	When SoldAsVacant = 'Y' THEN 'YES'
	When SoldAsVacant = 'N' THEN 'NO'
	Else SoldAsVacant 
    END 
From [PortFolio].[dbo].[NationalHousing]

Update [PortFolio].[dbo].[NationalHousing]

Set SoldAsVacant = Case
	When SoldAsVacant = 'Y' THEN 'YES'
	When SoldAsVacant = 'N' THEN 'NO'
	Else SoldAsVacant 
    END 


 

