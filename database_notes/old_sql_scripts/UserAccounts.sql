-- UserAccounts.sql

-- (1) find an account to modify
-- use DeveloperDynamic
set nocount on
set transaction isolation level read uncommitted

declare @UserName nvarchar(64) = null -- either null or value such as 'carol.brady'
declare @UserIdentifier uniqueidentifier = null -- either null or value such as 'AD73637C-7573-47FB-B102-8D61264C8189'
declare @AccountIdentifier uniqueidentifier = '83005d16-a173-4610-9915-7f3cd14ad4fe' -- either null or value such as '3e7a6def-aab2-485e-9ab6-d7cce2278017'

select top 1000 'Accounts' as query_title
, sts.stsid
, u.ID
, u.DisplayName as UserDisplayName
, u.UserIdentifier
, ua.id as UserAccountId
, ua.DisplayName as AccountDisplayName
, a.id as AccountId
, a.AccountIdentifier
, a.MICRAccountNumber
, a.AvailableBalance
, a.LedgerBalance
, a.NextPaymentAmountDue
, a.NextPaymentDate
, at.CoreName
, at.AccountTypeClassID
, at.AllowTransfersOut
, atc.Name as AccountTypeClassName
from core.STSProviderUser sts with (nolock)
  join core.UserAccount ua with (nolock) on sts.Userid = ua.UseriD
  join core.Users u with (nolock) on u.ID = ua.UserID
  join core.account a with (nolock) on ua.AccountID = a.ID 
  join core.AccountType at with (nolock) on a.AccountTypeID = at.ID
  join core.AccountTypeClass atc with (nolock) on atc.ID = at.AccountTypeClassID
where 1=1
  and (@UserName is null or sts.stsid = @UserName)
  and (@UserIdentifier is null or u.UserIdentifier = @UserIdentifier)
  -- and (@AccountIdentifier is null or ua.UserID in ( select ua1.UserID from core.UserAccount ua1 with (nolock) join core.account a1 with (nolock) on a1.ID = ua1.AccountID where a1.AccountIdentifier = @AccountIdentifier ))
  and (@AccountIdentifier is null or a.AccountIdentifier = @AccountIdentifier)
  -- and atc.Name in ('Loans', 'Credit Cards')
order by
  u.UserIdentifier
, a.AccountIdentifier

go


-- (2) change the account so it has a zero dollar payment due
-- use DeveloperDynamic
set nocount on
set transaction isolation level read uncommitted

declare @AccountIdentifier uniqueidentifier =  '83005d16-a173-4610-9915-7f3cd14ad4fe'

-- update core.account set NextPaymentAmountDue = 0, NextPaymentDate = '2/5/2024' where AccountIdentifier = @AccountIdentifier

select a.NextPaymentAmountDue
, a.NextPaymentDate
, * from core.account a with (nolock) where a.AccountIdentifier = @AccountIdentifier
go

-- select * from core.AccountType