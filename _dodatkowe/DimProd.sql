use contosoretaildw
GO

ALTER VIEW [olap].[vDimProduct]
AS
SELECT
	p.[ProductKey] + 0 AS [ProductKey]
,	p.[ProductLabel]
,	p.[ProductName]
,	p.[ClassID]
,	p.[ClassName]
,	p.[StockTypeID]
,	p.[StockTypeName]
,	p.[ColorID]
,	p.[ColorName]
,	p.[UnitOfMeasureID]
,	p.[UnitOfMeasureName]
,	s.[ProductSubcategoryKey]		AS [SubcategoryKey]		--	<<	z subcategory
,	s.[ProductSubcategoryLabel]		AS [SubcategoryLabel]
,	s.[ProductSubcategoryName]		AS [SubcategoryName]	--	<<	z subcategory
,	c.[ProductCategoryKey]			AS [CategoryKey]			--	<< z category
,	c.[ProductCategoryLabel]		AS [CategoryLabel]
,	c.[ProductCategoryName]			AS [CategoryName]			--	<< z category
FROM 
			[dbo].[DimProduct]				AS p
INNER JOIN	[dbo].[DimProductSubcategory]	AS s ON p.[ProductSubcategoryKey]	= s.[ProductSubcategoryKey]
INNER JOIN	[dbo].[DimProductCategory]		AS c ON s.[ProductCategoryKey]		= c.[ProductCategoryKey]
GO

--	1. dodaæ do DSV, ustawiæ klucz
--	2. dodaæ wymiar (ustawiæ nazwê od razu), w atrybutach dodaæ wszystkie ID oraz Klucze
--	3. dodaæ hierarchiê kategorii + atribute relationship (na kluczach)
--	4. na atrybutach kluczy oraz ID podmieniæ wyœwietlane nazwy