-- CreditScore-StaticProvider-OnlyOneRunningp.sql

begin tran
--UPDATE THIS VARIABLE FOR YOUR DESIRED STATE.
DECLARE @SavvyProviderDeleted as bit = 1;
 
 
DECLARE
@SavvyProviderId as bigint = (select Id from core.Item where Name = 'SavvyMoneyCreditScoreInfoProvider'),
@StaticProviderId as bigint = (select Id from core.Item where Name = 'Static Credit Score Info Provider');
 
SELECT i.* from core.Provider p
JOIN core.Item i on i.ParentId = p.ID
WHERE p.[Name] like '%credit%score%';
 
update core.Item set Deleted = @SavvyProviderDeleted where Id = @SavvyProviderId
 
update core.Item set Deleted = ~@SavvyProviderDeleted where Id = @StaticProviderId
 
SELECT i.* from core.Provider p
JOIN core.Item i on i.ParentId = p.ID
WHERE p.[Name] like '%credit%score%';
 
rollback tran