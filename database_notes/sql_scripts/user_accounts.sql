-- user_accounts.sql
--
-- Use this script to find test automation users and their passwords
--
-- Connect to server "DC00DB01" for DEV (Red14, ...) databases
-- Connect to server "QC00DB01" for Staging (Smith, Neo ...) databases

-- SET TRANSACTION ISOLATION LEVEL READ COMMITTED

-- use AlkamiICCU_Trin -- CHANGE AS NEEDED
-- go

DECLARE @UserName NVARCHAR(100) = 'RegTestTrin1'
DECLARE @UserIdentifier UNIQUEIDENTIFIER
DECLARE @UserID BIGINT

SELECT top 1
  @UserIdentifier = u.UserIdentifier
, @UserID=u.ID
FROM
  core.Users u with (nolock)
  JOIN core.STSProviderUser sts ON sts.UserId = u.id
WHERE 1=1
  and sts.stsid = @UserName


SELECT @UserName as [@UserName], @UserIdentifier as [@UserIdentifier], @UserID as [@UserID]


-- Show user info

select top 100
  'User information' as Select_Name
, sts.stsid
, 'core.Users:' as Table_Core_Users
, u.ID
, u.UserIdentifier
, u.BankID
, b.BankIdentifier
, u.FirstName
, u.LastName
, u.DisplayName
, u.FlavorID
, u.LastCoreUpdate
, u.LastLoginDate
, u.IsActive
, u.IsLockedOut
, u.IsACHEnabled
, u.ACHDisclosureAccepted
from
  core.Users u with (nolock)
  JOIN core.STSProviderUser sts ON sts.UserId = u.id
  JOIN core.Bank b (nolock) on b.ID = u.BankID
where 1=1
  and u.ID = @UserID


-- Show user's accouts 
select top 100
  'User accounts' as Select_Name
, 'core.UserAccount:' as Table_Core_UserAccount
, ua.UserID
, ua.DisplayName
, ua.MobileDisplayName
, ua.ThemeColorIndex
, ua.Ordering
, ua.Relationship
, ua.HideFromEndUser
, ua.IsHiddenFromBillPay
, ua.AccountID
, 'core.Accounts:' as Table_Core_Accounts
, a.AccountIdentifier
, a.AccountTypeID
, a.Number
, a.AvailableBalance
, a.LedgerBalance
, a.LastPaymentDate
, a.LastPaymentAmount
, a.NextPaymentDate
, a.NextPaymentAmountDue
, a.PastDueAmount
, a.LastUpdate
, a.LastCoreUpdate
, a.LastTransactionsUpdate
, a.LastTransactionSyncScheduled
, a.LastTransactionSyncFinished
, a.CoreProviderID
, 'core.Provider:' as Table_Core_Provider
, p.Name as CoreProviderName
, p.ProviderTypeID
, 'core.ProviderType' as Table_Core_ProviderType
, pt.Name as ProviderTypeName
, pt.DisplayName as ProviderTypeNameDisplayName
from
  core.UserAccount ua with (nolock)
  join core.Account a with (nolock) on a.Id = ua.AccountId
  join core.Provider p with (nolock) on p.ID = a.CoreProviderID
  left outer join core.ProviderType pt with (nolock) on pt.ID = p.ProviderTypeID
where 1=1
  and ua.UserID = @UserID
  and ua.Deleted != 1
order by
  ua.Ordering

select top 100
  'DisclosureAcceptance >>',
  da.*,
  'Disclosure >>',
  d.ID
  'ArticleVersion >>',
  av.*,
  (CAST(CAST('' AS XML).value('xs:base64Binary(sql:column("av.Data"))', 'VARBINARY(MAX)') AS VARCHAR(MAX))) AS Txt

from
  content.DisclosureAcceptance da (nolock)
  join content.Disclosure d (nolock) on d.ID = da.DisclosureID
  join content.ArticleVersion av (nolock) on av.ID = da.ArticleVersionID
where da.[UserID] = @UserID


-- delete from content.DisclosureAcceptance where UserID = 124919


select top 100
  'Transactions list: '
  , t.UserID
  -- , a.UserID
  , 'Table core.Transactions t >>'
  , t.*
  , 'Table core.Account a >>'
  , a.*
from
  core.Transactions t 
  left outer join core.Account a (nolock) on a.ID = t.AccountID
where 1=1
  and t.CheckNumber is not null
  -- and t.[UserID] = @UserID
order BY
  t.ID desc

-- select top 100 tt.* from core.TransactionType tt

