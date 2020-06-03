﻿CREATE TABLE [dbo].[DIM_ARTICLE]
(
	[ARTICLE_ID] VARCHAR(50) NOT NULL PRIMARY KEY, 
	[ARTICLE_NAME] NVARCHAR(50) NULL,
	[ARTICLE_CODE_NAME] NVARCHAR(50) NULL,
    [STYLE] VARCHAR(50) NULL, 
    [COLOR] VARCHAR(50) NULL, 
    [SEASON] VARCHAR(50) NULL, 
    [PRODUCT_LINE_ROOT] VARCHAR(50) NULL, 
	[DIVISION] VARCHAR(50) NULL,
    [CATEGORY] VARCHAR(50) NULL, 
    [GENDER] VARCHAR(50) NULL
)
