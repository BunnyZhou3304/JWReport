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
:setvar DefaultDataPath ""
:setvar DefaultLogPath ""

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
USE [master];


GO

IF (DB_ID(N'$(DatabaseName)') IS NOT NULL) 
BEGIN
    ALTER DATABASE [$(DatabaseName)]
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [$(DatabaseName)];
END

GO
PRINT N'正在创建 $(DatabaseName)...'
GO
CREATE DATABASE [$(DatabaseName)] COLLATE SQL_Latin1_General_CP1_CI_AS
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
                NUMERIC_ROUNDABORT OFF,
                QUOTED_IDENTIFIER ON,
                ANSI_NULL_DEFAULT ON,
                CURSOR_DEFAULT LOCAL,
                RECOVERY FULL,
                CURSOR_CLOSE_ON_COMMIT OFF,
                AUTO_CREATE_STATISTICS ON,
                AUTO_SHRINK OFF,
                AUTO_UPDATE_STATISTICS ON,
                RECURSIVE_TRIGGERS OFF 
            WITH ROLLBACK IMMEDIATE;
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_CLOSE OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ALLOW_SNAPSHOT_ISOLATION OFF;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET READ_COMMITTED_SNAPSHOT OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_UPDATE_STATISTICS_ASYNC OFF,
                PAGE_VERIFY NONE,
                DATE_CORRELATION_OPTIMIZATION OFF,
                DISABLE_BROKER,
                PARAMETERIZATION SIMPLE,
                SUPPLEMENTAL_LOGGING OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'$(DatabaseName)')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [$(DatabaseName)]
    SET TRUSTWORTHY OFF,
        DB_CHAINING OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'无法修改数据库设置。您必须是 SysAdmin 才能应用这些设置。';
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'$(DatabaseName)')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [$(DatabaseName)]
    SET HONOR_BROKER_PRIORITY OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'无法修改数据库设置。您必须是 SysAdmin 才能应用这些设置。';
    END


GO
ALTER DATABASE [$(DatabaseName)]
    SET TARGET_RECOVERY_TIME = 0 SECONDS 
    WITH ROLLBACK IMMEDIATE;


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET FILESTREAM(NON_TRANSACTED_ACCESS = OFF),
                CONTAINMENT = NONE 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_CREATE_STATISTICS ON(INCREMENTAL = OFF),
                MEMORY_OPTIMIZED_ELEVATE_TO_SNAPSHOT = OFF,
                DELAYED_DURABILITY = DISABLED 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF fulltextserviceproperty(N'IsFulltextInstalled') = 1
    EXECUTE sp_fulltext_database 'enable';


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
PRINT N'正在创建 [dbo].[DIM_WAREHOUSE]...';


GO
CREATE TABLE [dbo].[DIM_WAREHOUSE] (
    [WHSE_ID]   VARCHAR (2)   NOT NULL,
    [WHSE_NAME] NVARCHAR (50) NULL,
    PRIMARY KEY CLUSTERED ([WHSE_ID] ASC)
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
PRINT N'正在创建 [dbo].[FACT_TRANFER_RECORD]...';


GO
CREATE TABLE [dbo].[FACT_TRANFER_RECORD] (
    [ID]             BIGINT       IDENTITY (1, 1) NOT NULL,
    [DDATE]          DATE         NOT NULL,
    [VOUCHER_ID]     VARCHAR (50) NULL,
    [VOUCHER_AUTOID] VARCHAR (50) NULL,
    [VOUCHER_TYPE]   VARCHAR (50) NULL,
    [CUS_ID]         VARCHAR (50) NULL,
    [WHSE_ID]        VARCHAR (2)  NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
PRINT N'正在创建 [dbo].[FK_FACT_TRANFER_RECORD_TOCUSTOMER]...';


GO
ALTER TABLE [dbo].[FACT_TRANFER_RECORD]
    ADD CONSTRAINT [FK_FACT_TRANFER_RECORD_TOCUSTOMER] FOREIGN KEY ([CUS_ID]) REFERENCES [dbo].[DIM_CUSTOMER] ([CUS_ID]);


GO
PRINT N'正在创建 [dbo].[FK_FACT_TRANFER_RECORD_TOWHSE]...';


GO
ALTER TABLE [dbo].[FACT_TRANFER_RECORD]
    ADD CONSTRAINT [FK_FACT_TRANFER_RECORD_TOWHSE] FOREIGN KEY ([WHSE_ID]) REFERENCES [dbo].[DIM_WAREHOUSE] ([WHSE_ID]);


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
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'edd321f4-28ee-4948-8ff6-98e4325d73aa')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('edd321f4-28ee-4948-8ff6-98e4325d73aa')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'c9f46c3e-86d1-4cfe-a576-c4b7730735d6')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('c9f46c3e-86d1-4cfe-a576-c4b7730735d6')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '8540c801-6578-436e-b14d-c0398b28e2ad')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('8540c801-6578-436e-b14d-c0398b28e2ad')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '7291f966-3511-4623-ad71-fccb5f3a968f')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('7291f966-3511-4623-ad71-fccb5f3a968f')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'ad0a0c5e-46d1-45ab-bc2a-4c7be12781fc')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('ad0a0c5e-46d1-45ab-bc2a-4c7be12781fc')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'eb0c0d82-207d-42fe-9562-198f53988105')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('eb0c0d82-207d-42fe-9562-198f53988105')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '3933e7c2-b5fc-48c8-9d55-6c26695400b9')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('3933e7c2-b5fc-48c8-9d55-6c26695400b9')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '519aa20f-2093-4867-a412-2a72dadaab7f')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('519aa20f-2093-4867-a412-2a72dadaab7f')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '15d6d51c-bea5-4169-bb12-38f63518af67')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('15d6d51c-bea5-4169-bb12-38f63518af67')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '0c4ee950-2921-45a1-b4de-a429a73352db')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('0c4ee950-2921-45a1-b4de-a429a73352db')

GO

GO
DECLARE @VarDecimalSupported AS BIT;

SELECT @VarDecimalSupported = 0;

IF ((ServerProperty(N'EngineEdition') = 3)
    AND (((@@microsoftversion / power(2, 24) = 9)
          AND (@@microsoftversion & 0xffff >= 3024))
         OR ((@@microsoftversion / power(2, 24) = 10)
             AND (@@microsoftversion & 0xffff >= 1600))))
    SELECT @VarDecimalSupported = 1;

IF (@VarDecimalSupported > 0)
    BEGIN
        EXECUTE sp_db_vardecimal_storage_format N'$(DatabaseName)', 'ON';
    END


GO
ALTER DATABASE [$(DatabaseName)]
    SET MULTI_USER 
    WITH ROLLBACK IMMEDIATE;


GO
PRINT N'更新完成。';


GO
