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
PRINT N'已跳过具有键 edd321f4-28ee-4948-8ff6-98e4325d73aa 的重命名重构操作，不会将元素 [dbo].[FACT_TRANSFER_RECORD].[Id] (SqlSimpleColumn) 重命名为 ID';


GO
PRINT N'已跳过具有键 c9f46c3e-86d1-4cfe-a576-c4b7730735d6 的重命名重构操作，不会将元素 [dbo].[FACT_TRANSFER_RECORD].[T] (SqlSimpleColumn) 重命名为 TYPE';


GO
PRINT N'已跳过具有键 8540c801-6578-436e-b14d-c0398b28e2ad, ad0a0c5e-46d1-45ab-bc2a-4c7be12781fc 的重命名重构操作，不会将元素 [dbo].[FACT_TRANSFER_RECORD].[VHOUCH_ID] (SqlSimpleColumn) 重命名为 VOUCHER_ID';


GO
PRINT N'已跳过具有键 7291f966-3511-4623-ad71-fccb5f3a968f, eb0c0d82-207d-42fe-9562-198f53988105 的重命名重构操作，不会将元素 [dbo].[FACT_TRANSFER_RECORD].[V] (SqlSimpleColumn) 重命名为 VOUCHER_AUTOID';


GO
PRINT N'已跳过具有键 3933e7c2-b5fc-48c8-9d55-6c26695400b9 的重命名重构操作，不会将元素 [dbo].[FACT_TRANFER_RECORD].[VOUCER_ID] (SqlSimpleColumn) 重命名为 VOUCHER_ID';


GO
PRINT N'已跳过具有键 519aa20f-2093-4867-a412-2a72dadaab7f 的重命名重构操作，不会将元素 [dbo].[FACT_TRANFER_RECORD].[VOU] (SqlSimpleColumn) 重命名为 VOUCHER_AUTOID';


GO
PRINT N'已跳过具有键 15d6d51c-bea5-4169-bb12-38f63518af67 的重命名重构操作，不会将元素 [dbo].[FK_FACT_TRANFER_RECORD_ToTable] (SqlForeignKeyConstraint) 重命名为 [FK_FACT_TRANFER_RECORD_TOWHSE]';


GO
PRINT N'已跳过具有键 0c4ee950-2921-45a1-b4de-a429a73352db 的重命名重构操作，不会将元素 [dbo].[FACT_TRANFER_RECORD].[Id] (SqlSimpleColumn) 重命名为 ID';


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
ALTER TABLE [dbo].[FACT_TRANFER_RECORD] WITH NOCHECK
    ADD CONSTRAINT [FK_FACT_TRANFER_RECORD_TOCUSTOMER] FOREIGN KEY ([CUS_ID]) REFERENCES [dbo].[DIM_CUSTOMER] ([CUS_ID]);


GO
PRINT N'正在创建 [dbo].[FK_FACT_TRANFER_RECORD_TOWHSE]...';


GO
ALTER TABLE [dbo].[FACT_TRANFER_RECORD] WITH NOCHECK
    ADD CONSTRAINT [FK_FACT_TRANFER_RECORD_TOWHSE] FOREIGN KEY ([WHSE_ID]) REFERENCES [dbo].[DIM_WAREHOUSE] ([WHSE_ID]);


GO
-- 正在重构步骤以使用已部署的事务日志更新目标服务器
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
PRINT N'根据新创建的约束检查现有的数据';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[FACT_TRANFER_RECORD] WITH CHECK CHECK CONSTRAINT [FK_FACT_TRANFER_RECORD_TOCUSTOMER];

ALTER TABLE [dbo].[FACT_TRANFER_RECORD] WITH CHECK CHECK CONSTRAINT [FK_FACT_TRANFER_RECORD_TOWHSE];


GO
PRINT N'更新完成。';


GO
