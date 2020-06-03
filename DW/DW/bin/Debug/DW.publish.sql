/*
DW 的部署脚本

此代码由工具生成。
如果重新生成此代码，则对此文件的更改可能导致
不正确的行为并将丢失。
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "DW"
:setvar DefaultFilePrefix "DW"
:setvar DefaultDataPath "C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\"
:setvar DefaultLogPath "C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\"

GO
:on error exit
GO
/*
请检测 SQLCMD 模式，如果不支持 SQLCMD 模式，请禁用脚本执行。
要在启用 SQLCMD 模式后重新启用脚本，请执行:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'要成功执行此脚本，必须启用 SQLCMD 模式。';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ANSI_NULLS ON,
                ANSI_PADDING ON,
                ANSI_WARNINGS ON,
                ARITHABORT ON,
                CONCAT_NULL_YIELDS_NULL ON,
                QUOTED_IDENTIFIER ON,
                ANSI_NULL_DEFAULT ON,
                CURSOR_DEFAULT LOCAL 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET PAGE_VERIFY NONE 
            WITH ROLLBACK IMMEDIATE;
    END


GO
PRINT N'已跳过具有键 42b5746b-fd53-4b22-8a2a-e01c33178ee8, a3f1c747-86af-49c4-b434-cdddaf8e30e8 的重命名重构操作，不会将元素 [dbo].[DIM_CUBE_CALENDAR].[Id] (SqlSimpleColumn) 重命名为 DDATE';


GO
PRINT N'已跳过具有键 6317e8d3-3ac5-4c0d-875d-a0b8a62b4174, d8e39058-1705-467a-952b-118e4e87e19f 的重命名重构操作，不会将元素 [dbo].[DIM_CUBE_CALENDAR].[WEEK] (SqlSimpleColumn) 重命名为 WEEKCALENDAR_YEAR';


GO
PRINT N'已跳过具有键 d70fe146-be43-45b6-b569-b84df6903e99 的重命名重构操作，不会将元素 [dbo].[DIM_WAREHOUSE].[Id] (SqlSimpleColumn) 重命名为 WHSE_ID';


GO
PRINT N'已跳过具有键 caa64c83-81be-46ad-b192-02aa09f297c4 的重命名重构操作，不会将元素 [dbo].[DIM_CUSTOMER].[Id] (SqlSimpleColumn) 重命名为 CUS_ID';


GO
PRINT N'已跳过具有键 54c1c189-284a-4c0c-a9d4-f68594c2e2c6, 529b24ed-67ee-43a1-a3a2-1e9d37d88b1a, 2ba67bbe-1149-45ee-9c98-81cbe9bbcbaa 的重命名重构操作，不会将元素 [dbo].[DIM_ARTICLE].[Id] (SqlSimpleColumn) 重命名为 ARTICLE_ID';


GO
PRINT N'已跳过具有键 c80d5de9-8aed-4f74-babe-b26bd0ed17c0, 44917719-a9bb-4890-a291-28005e4490c1 的重命名重构操作，不会将元素 [dbo].[DIM_ARTICLE].[V] (SqlSimpleColumn) 重命名为 PRODUCT_LINE_ROOT';


GO
PRINT N'已跳过具有键 89eb2fa9-57b4-4187-aaad-fa22b9acf904, bdb41061-51dc-469d-998b-dcaceb6c3c60 的重命名重构操作，不会将元素 [dbo].[DIM_ARTICLE].[CINVNAME] (SqlSimpleColumn) 重命名为 ARTICLE_NAME';


GO
PRINT N'正在创建 [dbo].[DIM_ARTICLE]...';


GO
CREATE TABLE [dbo].[DIM_ARTICLE] (
    [ARTICLE_ID]        VARCHAR (50)  NOT NULL,
    [ARTICLE_NAME]      NVARCHAR (50) NULL,
    [ARTICLE_CODE_NAME] NVARCHAR (50) NULL,
    [STYLE]             VARCHAR (50)  NULL,
    [COLOR]             VARCHAR (50)  NULL,
    [SEASON]            VARCHAR (50)  NULL,
    [PRODUCT_LINE_ROOT] VARCHAR (50)  NULL,
    [DIVISION]          VARCHAR (50)  NULL,
    [CATEGORY]          VARCHAR (50)  NULL,
    [GENDER]            VARCHAR (50)  NULL,
    PRIMARY KEY CLUSTERED ([ARTICLE_ID] ASC)
);


GO
PRINT N'正在创建 [dbo].[DIM_CUBE_CALENDAR]...';


GO
CREATE TABLE [dbo].[DIM_CUBE_CALENDAR] (
    [DDATE]             VARCHAR (8)  NOT NULL,
    [YEAR]              VARCHAR (4)  NOT NULL,
    [MONTH]             VARCHAR (4)  NULL,
    [WEEKCALENDAR_YEAR] VARCHAR (4)  NULL,
    [WEEKCALENDAR_WEEK] VARCHAR (2)  NULL,
    [WEEKDAY]           VARCHAR (20) NULL,
    [ISWEEKEND]         BIT          NULL,
    [ISMONTHEND]        BIT          NULL,
    PRIMARY KEY CLUSTERED ([DDATE] ASC)
);


GO
PRINT N'正在创建 [dbo].[DIM_CUSTOMER]...';


GO
CREATE TABLE [dbo].[DIM_CUSTOMER] (
    [CUS_ID]             VARCHAR (50)  NOT NULL,
    [CUS_NAME]           NVARCHAR (50) NULL,
    [CUS_REGION]         NVARCHAR (50) NULL,
    [CUS_REGION_CHINESE] NVARCHAR (50) NULL,
    [CUS_RANK]           NVARCHAR (50) NULL,
    [CHANNEL]            NVARCHAR (50) NULL,
    [PROVINCE]           NVARCHAR (50) NULL,
    [IS_DOCKED]          BIT           NULL,
    PRIMARY KEY CLUSTERED ([CUS_ID] ASC)
);


GO
PRINT N'正在创建 [dbo].[DIM_WAREHOUSE]...';


GO
CREATE TABLE [dbo].[DIM_WAREHOUSE] (
    [WHSE_ID]   VARCHAR (2)   NOT NULL,
    [WHSE_NAME] NVARCHAR (50) NULL,
    PRIMARY KEY CLUSTERED ([WHSE_ID] ASC)
);


GO
-- 正在重构步骤以使用已部署的事务日志更新目标服务器

IF OBJECT_ID(N'dbo.__RefactorLog') IS NULL
BEGIN
    CREATE TABLE [dbo].[__RefactorLog] (OperationKey UNIQUEIDENTIFIER NOT NULL PRIMARY KEY)
    EXEC sp_addextendedproperty N'microsoft_database_tools_support', N'refactoring log', N'schema', N'dbo', N'table', N'__RefactorLog'
END
GO
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '42b5746b-fd53-4b22-8a2a-e01c33178ee8')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('42b5746b-fd53-4b22-8a2a-e01c33178ee8')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '6317e8d3-3ac5-4c0d-875d-a0b8a62b4174')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('6317e8d3-3ac5-4c0d-875d-a0b8a62b4174')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'a3f1c747-86af-49c4-b434-cdddaf8e30e8')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('a3f1c747-86af-49c4-b434-cdddaf8e30e8')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'd8e39058-1705-467a-952b-118e4e87e19f')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('d8e39058-1705-467a-952b-118e4e87e19f')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'd70fe146-be43-45b6-b569-b84df6903e99')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('d70fe146-be43-45b6-b569-b84df6903e99')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'caa64c83-81be-46ad-b192-02aa09f297c4')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('caa64c83-81be-46ad-b192-02aa09f297c4')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '54c1c189-284a-4c0c-a9d4-f68594c2e2c6')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('54c1c189-284a-4c0c-a9d4-f68594c2e2c6')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'c80d5de9-8aed-4f74-babe-b26bd0ed17c0')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('c80d5de9-8aed-4f74-babe-b26bd0ed17c0')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '529b24ed-67ee-43a1-a3a2-1e9d37d88b1a')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('529b24ed-67ee-43a1-a3a2-1e9d37d88b1a')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '89eb2fa9-57b4-4187-aaad-fa22b9acf904')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('89eb2fa9-57b4-4187-aaad-fa22b9acf904')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '2ba67bbe-1149-45ee-9c98-81cbe9bbcbaa')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('2ba67bbe-1149-45ee-9c98-81cbe9bbcbaa')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'bdb41061-51dc-469d-998b-dcaceb6c3c60')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('bdb41061-51dc-469d-998b-dcaceb6c3c60')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '44917719-a9bb-4890-a291-28005e4490c1')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('44917719-a9bb-4890-a291-28005e4490c1')

GO

GO
PRINT N'更新完成。';


GO
