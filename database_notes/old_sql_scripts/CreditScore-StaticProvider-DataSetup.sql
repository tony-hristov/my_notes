-- CreditScore-StaticProvider-DataSetup.sql

WHILE @@TRANCOUNT > 0 ROLLBACK
SET XACT_ABORT ON
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
--------------------------------------------------------------------------------------------------
-------------///////////////////////////////////////////////////////////////////////--------------
--------------------------------------------------------------------------------------------------
BEGIN TRAN
    
--USE <DB>
    
    
    
------THE VARIABLES BELOW NEED YOUR ATTENTION.------
     
--Current valid JSON setting names are: 'TestingCreditScoreAlertJson' AND 'TestingCreditScoreJson'
--ScoreRatingValue enum:
-- (Default) Unknown = 0,
-- (300-499) VeryPoor = 1,
-- (500-600) Poor = 2,
-- (601-660) Fair = 3,
-- (661-780) Good = 4,
-- (781-850) Excellent = 5
DECLARE @TestingCreditScoreAlertValue VARCHAR(MAX) =
'{
  "$id": "1",
  "ItemList": [
    {
      "ProviderUrl": "/SavvyMoney",
      "Score": 787,
      "ScoreChange": 203,
      "ScoreRatingValue": 5,
      "ScoreRefreshAvailable": false,
      "ScoreRefreshDate": "2024-01-03T00:00:00",
    }
  ]-
  "CorrelationId": null,
  "HasError": false,
  "MessageIdentifier": "00000000-0000-0000-0000-000000000000",
  "SystemMessage": null,
  "ValidationResults": []
}';
  
DECLARE @TestingCreditScoreValue VARCHAR(MAX) =
'{
  "$id": "1",
  "ItemList": [
    {
      "NotificationsCount": 3,
      "ProviderUrl": "/SavvyMoney",
      "Score": 787,
      "ScoreChange": 203,
      "ScoreRatingValue": 5,
      "ScoreRefreshAvailable": false,
      "ScoreRefreshDate": "2024-01-03T00:00:00",
    }
  ],
  "CorrelationId": null,
  "HasError": false,
  "MessageIdentifier": "00000000-0000-0000-0000-000000000000",
  "SystemMessage": null,
  "ValidationResults": []
}';
    
    
DECLARE @Ticket varchar(100) = 'ABC-1234'
    
--#region Declarations
DECLARE @ProviderName varchar(100) = 'Static Credit Score Info Provider'
DECLARE @ProviderDescription varchar(100) = 'Static Credit Score Info Provider'
DECLARE @ProviderAssemblyVersion varchar(100) = 'Alkami.MS.CreditScoreInfoProviders.Static.Service.Host'
DECLARE @SUser NVARCHAR(500) = SUSER_NAME(), @CurrentTime DATETIME = GETDATE()
DECLARE @InsertedCount NVARCHAR(MAX), @UpdateCount NVARCHAR(MAX), @DeletedCount NVARCHAR(MAX), @CreateDate DATETIME = GETUTCDATE(), @version NVARCHAR(10) = '1.0.0.0', @bankID BIGINT = (SELECT TOP 1 ID FROM core.bank), @bankidentifier NVARCHAR(50) = (SELECT TOP 1 BankIdentifier FROM core.bank), @ClientURLSignature NVARCHAR(150) = (SELECT TOP 1 urlsignature FROM core.bank)
CREATE TABLE #ProvidertypeOutput (Action NVARCHAR(100), NewID BIGINT, NewName NVARCHAR(100), NewDisplayName NVARCHAR(100), NewDescription NVARCHAR(150), NewCreateDate DATETIME, NewViewPage NVARCHAR(100), OldID BIGINT, OldName NVARCHAR(100), OldDisplayName NVARCHAR(100), OldDescription NVARCHAR(150), OldCreateDate DATETIME, OldViewPage NVARCHAR(100))
CREATE TABLE #TempProvidertype (Name NVARCHAR(100), DisplayName NVARCHAR(100), Description NVARCHAR(150), CreateDate DATETIME, ViewPage NVARCHAR(100))
CREATE TABLE #ProviderOutput (Action NVARCHAR(100), NewID BIGINT, NewProviderTypeID BIGINT, NewName NVARCHAR(100), NewDescription NVARCHAR(150), NewAssemblyInfo NVARCHAR(500), NewCreateDate DATETIME, OldID BIGINT, OldProviderTypeID BIGINT, OldName NVARCHAR(100), OldDescription NVARCHAR(150), OldAssemblyInfo NVARCHAR(500), OldCreateDate DATETIME)
CREATE TABLE #TempProvider (ProviderTypeID BIGINT, Name NVARCHAR(100), Description NVARCHAR(150), AssemblyInfo NVARCHAR(500), CreateDate DATETIME)
CREATE TABLE #ItemOutput (Action NVARCHAR(100), NewId BIGINT, NewItemType VARCHAR(50), NewParentId BIGINT, NewSecondaryId BIGINT, NewName VARCHAR(500), NewCreatedUtc DATETIME, NewVersion VARCHAR(10), NewDeleted BIT, NewLastUpdate DATETIME, OldId BIGINT, OldItemType VARCHAR(50), OldParentId BIGINT, OldSecondaryId BIGINT, OldName VARCHAR(500), OldCreatedUtc DATETIME, OldVersion VARCHAR(10), OldDeleted BIT, OldLastUpdate DATETIME)
CREATE TABLE #TempItem (ItemType VARCHAR(50), ParentId BIGINT, SecondaryId BIGINT, Name VARCHAR(500), CreatedUtc DATETIME, Version VARCHAR(10), Deleted BIT, lastupdate DATETIME)
CREATE TABLE #ItemSettingOutput (Action NVARCHAR(100), NewId BIGINT, NewItemId BIGINT, NewName VARCHAR(500), NewValue NVARCHAR(MAX), NewCreatedUtc DATETIME, NewVersion VARCHAR(10), NewLastUpdate DATETIME, OldId BIGINT, OldItemId BIGINT, OldName VARCHAR(500), OldValue NVARCHAR(MAX), OldCreatedUtc DATETIME, OldVersion VARCHAR(10), OldLastUpdate DATETIME)
CREATE TABLE #ChangeSetOutput (Action nvarchar(100), NewId BIGINT, NewItemId BIGINT, NewVersion BIGINT, NewAuthor NVARCHAR(500), NewCreatedUtc DATETIME, NewNotes NVARCHAR(MAX), OldId BIGINT, OldItemId BIGINT, OldVersion BIGINT, OldAuthor NVARCHAR(500), OldCreatedUtc DATETIME, OldNotes NVARCHAR(MAX))
CREATE TABLE #ChangeSetDetailOutput (Action nvarchar(100), NewChangesetId BIGINT, NewItemSettingId BIGINT, NewOldValue NVARCHAR(MAX), NewNewValue NVARCHAR(MAX), OldChangesetId BIGINT, OldItemSettingId BIGINT, OldOldValue NVARCHAR(MAX), OldNewValue NVARCHAR(MAX))
CREATE TABLE #TempItemsetting (ItemId BIGINT, Name VARCHAR(500), Value NVARCHAR(MAX), CreatedUtc DATETIME, Version VARCHAR(10))
--#endregion Declarations
    
--#region Merge Section
--#region core.Providertype
INSERT INTO #TempProvidertype (Name,DisplayName,Description,CreateDate,ViewPage)
VALUES ('CreditScoreInfo','CreditScoreInfoProvider','Provider that provides credit score information',@CreateDate,NULL)
    
MERGE core.ProviderType AS TARGET USING #TempProvidertype AS SOURCE
    ON (target.name = source.Name)
WHEN MATCHED AND (TARGET.Name <> SOURCE.Name OR TARGET.DisplayName <> SOURCE.DisplayName OR TARGET.Description <> SOURCE.Description OR TARGET.ViewPage <> SOURCE.ViewPage) THEN
    UPDATE SET TARGET.Name = SOURCE.Name, TARGET.DisplayName = SOURCE.DisplayName, TARGET.Description = SOURCE.Description, TARGET.ViewPage = SOURCE.ViewPage
WHEN NOT MATCHED THEN
    INSERT(Name,DisplayName,Description,CreateDate,ViewPage)
    VALUES(SOURCE.Name,SOURCE.DisplayName,SOURCE.Description,SOURCE.CreateDate,SOURCE.ViewPage)
OUTPUT CONCAT($ACTION, ' Providertype') AS Action,Inserted.ID,Inserted.Name,Inserted.DisplayName,Inserted.Description,Inserted.CreateDate,Inserted.ViewPage,Deleted.ID,Deleted.Name,Deleted.DisplayName,Deleted.Description,Deleted.CreateDate,Deleted.ViewPage INTO #ProvidertypeOutput;
--#endregion core.Providertype
--#region core.Provider
DECLARE @SavvyMoneyCreditScoreProviderTypeId INT = (SELECT TOP 1 ID FROM core.ProviderType WHERE name = 'CreditScoreInfo')
    
INSERT INTO #TempProvider (ProviderTypeID,Name,Description,AssemblyInfo,CreateDate)
VALUES (@SavvyMoneyCreditScoreProviderTypeId, @ProviderName, @ProviderDescription,@ProviderAssemblyVersion,@CreateDate);
    
MERGE core.Provider AS TARGET USING #TempProvider AS SOURCE
    ON (TARGET.AssemblyInfo = SOURCE.AssemblyInfo)
WHEN MATCHED AND (TARGET.ProviderTypeID <> SOURCE.ProviderTypeID OR TARGET.Name <> SOURCE.Name OR TARGET.Description <> SOURCE.Description) THEN
    UPDATE SET TARGET.ProviderTypeID = SOURCE.ProviderTypeID, TARGET.Name = SOURCE.Name, TARGET.Description = SOURCE.Description
WHEN NOT MATCHED THEN
    INSERT(ProviderTypeID,Name,Description,AssemblyInfo,CreateDate)
    VALUES(SOURCE.ProviderTypeID,SOURCE.Name,SOURCE.Description,SOURCE.AssemblyInfo,SOURCE.CreateDate)
OUTPUT CONCAT($ACTION, ' Provider') AS Action,Inserted.ID,Inserted.ProviderTypeID,Inserted.Name,Inserted.Description,Inserted.AssemblyInfo,Inserted.CreateDate,Deleted.ID,Deleted.ProviderTypeID,Deleted.Name,Deleted.Description,Deleted.AssemblyInfo,Deleted.CreateDate INTO #ProviderOutput;
--#endregion core.Provider
--#region core.Item
DECLARE @SavvyMoneyCreditScoreProviderID INT = (SELECT TOP 1 ID FROM core.Provider WHERE AssemblyInfo = @ProviderAssemblyVersion)
INSERT INTO #TempItem (ItemType,ParentId,SecondaryId,Name,CreatedUtc,Version,Deleted)
VALUES ('Connector',@SavvyMoneyCreditScoreProviderID,@bankID,@ProviderName,@CreateDate,@version,0);
    
MERGE core.Item AS TARGET USING #TempItem AS SOURCE
    ON (TARGET.ParentID = SOURCE.Parentid AND TARGET.SecondaryID = SOURCE.SecondaryID AND TARGET.ItemType = SOURCE.ItemType)
WHEN MATCHED AND (TARGET.Name <> SOURCE.Name OR TARGET.Deleted <> SOURCE.Deleted) THEN
    UPDATE SET TARGET.Name = SOURCE.Name, TARGET.Version = PARSENAME(SOURCE.Version,4) + '.' + PARSENAME(SOURCE.Version,3) + '.' + CONVERT(NVARCHAR, CAST(PARSENAME(SOURCE.Version,2) AS INT) + 1) + '.' + PARSENAME(SOURCE.Version,1), TARGET.Deleted = SOURCE.Deleted, target.LastUpdate=GETUTCDATE()
WHEN NOT MATCHED THEN
    INSERT(ItemType,ParentId,SecondaryId,Name,CreatedUtc,Version,Deleted,LastUpdate)
    VALUES(SOURCE.ItemType,SOURCE.ParentId,SOURCE.SecondaryId,SOURCE.Name,SOURCE.CreatedUtc,@Version,SOURCE.Deleted,NULL)
OUTPUT CONCAT($ACTION, ' Item') AS Action
    ,Inserted.Id,Inserted.ItemType,Inserted.ParentId,Inserted.SecondaryId,Inserted.Name,Inserted.CreatedUtc,Inserted.Version,Inserted.Deleted, Inserted.LastUpdate
    ,Deleted.Id,Deleted.ItemType,Deleted.ParentId,Deleted.SecondaryId,Deleted.Name,Deleted.CreatedUtc,Deleted.Version,Deleted.Deleted,Deleted.LastUpdate INTO #ItemOutput;
--#endregion core.Item
--#region core.Itemsetting
DECLARE @SavvyMoneyCreditScoreItemId INT = (SELECT TOP 1 ID FROM core.item WHERE name = @ProviderName)
    
INSERT INTO #TempItemsetting (ItemId,Name,Value,CreatedUtc,Version)
VALUES
(@SavvyMoneyCreditScoreItemId,'TestingCreditScoreAlertJson',@TestingCreditScoreAlertValue,@CreateDate,@version)
  
INSERT INTO #TempItemsetting (ItemId,Name,Value,CreatedUtc,Version)
VALUES
(@SavvyMoneyCreditScoreItemId,'TestingCreditScoreJson',@TestingCreditScoreValue,@CreateDate,@version)
    
--#endregion core.Itemsetting
    
MERGE core.ItemSetting AS TARGET USING #TempItemsetting AS SOURCE
    ON (TARGET.Name = SOURCE.Name AND TARGET.ItemID = SOURCE.ItemID)
WHEN MATCHED AND (TARGET.Value <> SOURCE.Value) THEN
    UPDATE SET TARGET.Value = SOURCE.Value, TARGET.Version = PARSENAME(SOURCE.Version,4) + '.' + PARSENAME(SOURCE.Version,3) + '.' + CONVERT(NVARCHAR, CAST(PARSENAME(SOURCE.Version,2) AS INT) + 1) + '.' + PARSENAME(SOURCE.Version,1),target.LastUpdate=GETUTCDATE()
WHEN NOT MATCHED THEN
    INSERT(ItemId,Name,Value,CreatedUtc,Version,LastUpdate)
    VALUES(SOURCE.ItemId,SOURCE.Name,SOURCE.Value,SOURCE.CreatedUtc,@Version,NULL)
OUTPUT CONCAT($ACTION, ' Itemsetting') AS Action
    ,Inserted.Id,Inserted.ItemId,Inserted.Name,Inserted.Value,Inserted.CreatedUtc,Inserted.Version,Inserted.LastUpdate
    ,Deleted.Id,Deleted.ItemId,Deleted.Name,Deleted.Value,Deleted.CreatedUtc,Deleted.Version,Deleted.LastUpdate INTO #ItemSettingOutput;
--#endregion Merge Itemsettings
--#endregion Merge Section
--#region Outputs
IF EXISTS(SELECT 1 FROM #ProviderTypeOutput)
    BEGIN
        SELECT CONVERT(NVARCHAR,COUNT(*)) + CASE WHEN COUNT(*) = 1 THEN ' row inserted' ELSE ' rows inserted' END + ' in core.ProviderType' AS ProviderTypeRowsAffected FROM #ProviderTypeOutput WHERE Action LIKE '%insert%' UNION ALL
        SELECT CONVERT(NVARCHAR,COUNT(*)) + CASE WHEN COUNT(*) = 1 THEN ' row updated' ELSE ' rows updated' END + ' in core.ProviderType' AS ProviderTypeRowsAffected FROM #ProviderTypeOutput WHERE Action LIKE '%update%' UNION ALL
        SELECT CONVERT(NVARCHAR,COUNT(*)) + CASE WHEN COUNT(*) = 1 THEN ' row deleted' ELSE ' rows deleted' END + ' from core.ProviderType' AS ProviderTypeRowsAffected FROM #ProviderTypeOutput WHERE Action LIKE '%delete%'
        SELECT * FROM #ProviderTypeOutput
    END
IF EXISTS(SELECT 1 FROM #ProviderOutput)
    BEGIN
        SELECT CONVERT(NVARCHAR,COUNT(*)) + CASE WHEN COUNT(*) = 1 THEN ' row inserted' ELSE ' rows inserted' END + ' in dbo.Provider' AS ProviderRowsAffected FROM #ProviderOutput WHERE Action LIKE '%insert%' UNION ALL
        SELECT CONVERT(NVARCHAR,COUNT(*)) + CASE WHEN COUNT(*) = 1 THEN ' row updated' ELSE ' rows updated' END + ' in dbo.Provider' AS ProviderRowsAffected FROM #ProviderOutput WHERE Action LIKE '%update%' UNION ALL
        SELECT CONVERT(NVARCHAR,COUNT(*)) + CASE WHEN COUNT(*) = 1 THEN ' row deleted' ELSE ' rows deleted' END + ' from dbo.Provider' AS ProviderRowsAffected FROM #ProviderOutput WHERE Action LIKE '%delete%'
        SELECT * FROM #ProviderOutput
    END
IF EXISTS(SELECT 1 FROM #ItemOutput)
    BEGIN
        SELECT CONVERT(NVARCHAR,COUNT(*)) + CASE WHEN COUNT(*) = 1 THEN ' row inserted' ELSE ' rows inserted' END + ' in core.Item' AS ItemRowsAffected FROM #ItemOutput WHERE Action LIKE '%insert%' UNION ALL
        SELECT CONVERT(NVARCHAR,COUNT(*)) + CASE WHEN COUNT(*) = 1 THEN ' row updated' ELSE ' rows updated' END + ' in core.Item' AS ItemRowsAffected FROM #ItemOutput WHERE Action LIKE '%update%' UNION ALL
        SELECT CONVERT(NVARCHAR,COUNT(*)) + CASE WHEN COUNT(*) = 1 THEN ' row deleted' ELSE ' rows deleted' END + ' from core.Item' AS ItemRowsAffected FROM #ItemOutput WHERE Action LIKE '%delete%'
        SELECT * FROM #ItemOutput
    END
IF EXISTS(SELECT 1 FROM #ItemSettingOutput)
    BEGIN
        insert into core.Changeset (ItemId,Version,Author,CreatedUtc,Notes)
        OUTPUT 'INSERT INTO core.Changeset' as Action, Inserted.Id,Inserted.ItemId,Inserted.Version,Inserted.Author,Inserted.CreatedUtc,Inserted.Notes,null,null,null,null,null,null INTO #changesetOutput
        select s.ItemID as ItemID, CASE WHEN s.Version IS NULL THEN CAST(PARSENAME(@version,4) AS BIGINT) * 100000000000000 + CAST(PARSENAME(@version,3) AS BIGINT) * 1000000000 + CAST(PARSENAME(@version,2) AS BIGINT) * 10000 +
            CAST(PARSENAME('2.0.0.0',1) AS BIGINT) * 1 ELSE CAST(PARSENAME(s.Version,4) AS BIGINT) * 100000000000000 + CAST(PARSENAME(s.Version,3) AS BIGINT) * 1000000000 + CAST(PARSENAME(s.Version,2) AS BIGINT) * 10000 +
            CAST(PARSENAME(s.Version,1) AS BIGINT) * 1 END as Version, SUSER_NAME(), @createDate,
            CONCAT(@Ticket, CASE WHEN t.OldId IS NULL
                            THEN ' - Created a new '+i.ItemType+' setting for Provider ['+i.Name+'] with Name: [' + s.Name + ']'
                            ELSE ' - Updated '+i.ItemType+' ['+i.Name+'] setting Name: [' + s.Name + '] From ['+t.OldValue+'] To ['+t.newValue+']' END) AS Notes
        FROM #ItemSettingOutput t
        join core.Itemsetting s on t.newitemid = s.ItemId and t.newname = s.name JOIN core.Item i ON i.ID = s.ItemID         
    
        insert into core.ChangesetDetail (ChangesetId,ItemSettingId,OldValue,NewValue)
        OUTPUT 'Insert ChangeSetDetail' as Action, Inserted.ChangesetId,Inserted.ItemSettingId,Inserted.OldValue,Inserted.NewValue,null,null,null,null INTO #ChangesetDetailOutput
        select c.ID, t.NewItemSettingID, t.OldValue, t.NewValue
        from (select s.ItemID as ItemID, CASE WHEN s.Version IS NULL THEN CAST(PARSENAME(@Version,4) AS BIGINT) * 100000000000000 + CAST(PARSENAME(@Version,3) AS BIGINT) * 1000000000 + CAST(PARSENAME(@Version,2) AS BIGINT) * 10000 + CAST(PARSENAME(@Version,1) AS BIGINT) * 1
                    ELSE CAST(PARSENAME(s.Version,4) AS BIGINT) * 100000000000000 + CAST(PARSENAME(s.Version,3) AS BIGINT) * 1000000000 + CAST(PARSENAME(s.Version,2) AS BIGINT) * 10000 + CAST(PARSENAME(s.Version,1) AS BIGINT) * 1  END as Version,
                    SUSER_NAME() AS Author, @createDate as CreatedUTC, CONCAT( @Ticket, CASE WHEN ts.OldId IS NULL THEN ' - Created a new '+i.ItemType+' setting for Provider ['+i.Name+'] with Name: [' + s.Name + ']'
                        ELSE ' - Updated '+i.ItemType+' ['+i.Name+'] setting Name: [' + s.Name + '] From ['+ISNULL(ts.OldValue,'')+'] To ['+ts.newValue+']' END )AS Notes,
                    s.ID as NewItemSettingId, ts.newValue as NewValue, ts.OldValue as OldValue
                FROM #ItemSettingOutput ts join core.ItemSetting s on s.ItemId = ts.newItemId and s.Name = ts.newName JOIN core.Item i ON i.ID = s.ItemID) t
        join core.Changeset c on t.ItemID = c.ItemID and t.Version = c.Version and t.Author = c.Author and t.Notes = c.Notes and t.CreatedUTC = c.CreatedUTC
    
        SELECT CONVERT(NVARCHAR,COUNT(*)) + CASE WHEN COUNT(*) = 1 THEN ' row inserted' ELSE ' rows inserted' END + ' in core.ItemSetting' AS ItemSettingRowsAffected FROM #ItemSettingOutput WHERE Action LIKE '%insert%' UNION ALL
        SELECT CONVERT(NVARCHAR,COUNT(*)) + CASE WHEN COUNT(*) = 1 THEN ' row updated' ELSE ' rows updated' END + ' in core.ItemSetting' AS ItemSettingRowsAffected FROM #ItemSettingOutput WHERE Action LIKE '%update%' UNION ALL
        SELECT CONVERT(NVARCHAR,COUNT(*)) + CASE WHEN COUNT(*) = 1 THEN ' row deleted' ELSE ' rows deleted' END + ' from core.ItemSetting' AS ItemSettingRowsAffected FROM #ItemSettingOutput WHERE Action LIKE '%delete%'
        SELECT * FROM #ItemSettingOutput
    END
IF EXISTS(SELECT 1 FROM #ChangesetOutput)
    BEGIN
        SELECT CONVERT(NVARCHAR,COUNT(*)) + CASE WHEN COUNT(*) = 1 THEN ' row inserted' ELSE ' rows inserted' END + ' in core.Changeset' AS ChangesetRowsAffected FROM #ChangesetOutput WHERE Action LIKE 'insert%' UNION ALL
        SELECT CONVERT(NVARCHAR,COUNT(*)) + CASE WHEN COUNT(*) = 1 THEN ' row updated' ELSE ' rows updated' END + ' in core.Changeset' AS ChangesetRowsAffected FROM #ChangesetOutput WHERE Action LIKE 'update%' UNION ALL
        SELECT CONVERT(NVARCHAR,COUNT(*)) + CASE WHEN COUNT(*) = 1 THEN ' row deleted' ELSE ' rows deleted' END + ' from core.Changeset' AS ChangesetRowsAffected FROM #ChangesetOutput WHERE Action LIKE 'delete%'
        SELECT * FROM #ChangesetOutput
    END
IF EXISTS(SELECT 1 FROM #ChangesetDetailOutput)
    BEGIN
        SELECT CONVERT(NVARCHAR,COUNT(*)) + CASE WHEN COUNT(*) = 1 THEN ' row inserted' ELSE ' rows inserted' END + ' in core.ChangesetDetail' AS ChangesetDetailRowsAffected FROM #ChangesetDetailOutput WHERE Action LIKE 'insert%' UNION ALL
        SELECT CONVERT(NVARCHAR,COUNT(*)) + CASE WHEN COUNT(*) = 1 THEN ' row updated' ELSE ' rows updated' END + ' in core.ChangesetDetail' AS ChangesetDetailRowsAffected FROM #ChangesetDetailOutput WHERE Action LIKE 'update%' UNION ALL
        SELECT CONVERT(NVARCHAR,COUNT(*)) + CASE WHEN COUNT(*) = 1 THEN ' row deleted' ELSE ' rows deleted' END + ' from core.ChangesetDetail' AS ChangesetDetailRowsAffected FROM #ChangesetDetailOutput WHERE Action LIKE 'delete%'
        SELECT * FROM #ChangesetDetailOutput
    END
--#endregion Outputs
    
--#region Cleanup
DROP TABLE #TempProvidertype
DROP TABLE #ProvidertypeOutput
DROP TABLE #TempProvider
DROP TABLE #ProviderOutput
DROP TABLE #TempItem
DROP TABLE #ItemOutput
DROP TABLE #ChangeSetOutput
DROP TABLE #TempItemsetting
DROP TABLE #ItemsettingOutput
DROP TABLE #ChangeSetDetailOutput
--#endregion Cleanup
    
    
select * from core.itemsetting it
join core.item i on i.id = it.itemId
join core.Provider p on p.ID = i.ParentId
where p.Name like '%Credit Score%'
    
    
ROLLBACK TRAN
--COMMIT TRAN
    
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF
WHILE @@TRANCOUNT > 0 ROLLBACK



select top 1000 * from core.ItemSetting where Name in ('OverrideTransactionCreditAmountDefaultColor', 'OverrideTransactionDebitAmountDefaultColor')