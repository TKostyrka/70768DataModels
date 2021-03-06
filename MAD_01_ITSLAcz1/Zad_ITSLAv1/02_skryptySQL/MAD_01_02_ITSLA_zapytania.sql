USE [ContosoRetailDW]
GO

--	StarJoin
---------------------------------------------------------------------

	SELECT 
		[f].[ITSLAkey]
	,	[dd].[FullDateLabel]
	,	[ds].[StoreName]
	,	[do].[OutageLabel]
	,	[do].[OutageName]
	,	[do].[OutageType]
	,	[dm].[MachineLabel]
	,	[f].[OutageStartTime]
	,	[f].[OutageEndTime]
	,	[f].[DownTime]
	FROM 
				[dbo].[FactITSLA]	AS f
	INNER JOIN	[dbo].[DimDate]		AS dd ON [dd].[Datekey]		= [f].[DateKey]
	INNER JOIN	[dbo].[DimStore]	AS ds ON [ds].[StoreKey]	= [f].[StoreKey]
	INNER JOIN	[dbo].[DimOutage]	AS do ON [do].[OutageKey]	= [f].[OutageKey]
	INNER JOIN	[dbo].[DimMachine]	AS dm ON [dm].[MachineKey]	= [f].[MachineKey]
	ORDER BY 
		[f].[ITSLAkey]
	;

---------------------------------------------------------------------
	
	WITH cte
	AS
	(
		SELECT 
			[dd].[CalendarYear]
		,	[dm].[MachineType]
		,	[do].[OutageName]
		,	[do].[OutageType]
		,	SUM([f].[DownTime]) AS [DownTime]
		FROM 
					[dbo].[FactITSLA]	AS f
		INNER JOIN	[dbo].[DimDate]		AS dd ON [dd].[Datekey]		= [f].[DateKey]
		INNER JOIN	[dbo].[DimStore]	AS ds ON [ds].[StoreKey]	= [f].[StoreKey]
		INNER JOIN	[dbo].[DimOutage]	AS do ON [do].[OutageKey]	= [f].[OutageKey]
		INNER JOIN	[dbo].[DimMachine]	AS dm ON [dm].[MachineKey]	= [f].[MachineKey]
		WHERE 1=1
		AND [do].[OutageName] = 'Hardware'
		AND [dm].[MachineType] LIKE 'POS%'
		GROUP BY
			[dm].[MachineType]
		,	[dd].[CalendarYear]
		,	[do].[OutageName]
		,	[do].[OutageType]
	)
	SELECT 
			[pv].[MachineType]
		,	[pv].[OutageName]
        ,	[pv].[OutageType]
        ,	ISNULL([pv].[2007], 0 )	AS [2007]
        ,	ISNULL([pv].[2008], 0 )	AS [2008]
        ,	ISNULL([pv].[2009], 0 )	AS [2009]
		,	CAST(
					CAST(ISNULL([pv].[2009], 0 ) - ISNULL([pv].[2007], 0 ) AS NUMERIC(10,2)) / 
					CAST([pv].[2007] AS NUMERIC(10,2))
					AS NUMERIC(10,2)
					) AS [Diff2007vs2009]
	FROM [cte] AS c
	PIVOT 
	(
		SUM([DownTime]) FOR [CalendarYear] IN ([2007],[2008],[2009])
	) AS pv
	ORDER BY
			[pv].[MachineType]
		,	[pv].[OutageType]
	;
