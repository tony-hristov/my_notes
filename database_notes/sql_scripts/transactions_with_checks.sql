-- Find transactions with check
-- transactions_with_checks.sql

-- Step 1: Find transactions with check

select top 100
  'Transactions with checks'
  , t.UserID
  , 'core.Transactions'
  , t.*
  , 'Table core.Account'
  , a.*
from
  core.Transactions t 
  left outer join core.Account a (nolock) on a.ID = t.AccountID
where t.CheckNumber is not null
  -- and t.UserID not in (127055, 127783, 107187, 127250,127248,127208,121072,122745,121756,124979,127248,122907,121870,121651)
order BY t.ID desc

-- Step 2: See the user and the user's accounts

DECLARE @UserID BIGINT = 127783 -- Change the UserID here
DECLARE @AccountID BIGINT = 451448

select top 100
  'User information' as Select_Name
, sts.stsid
, 'core.Users:' as Table_Core_Users
, u.FlavorID
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
from
  core.UserAccount ua with (nolock)
  join core.Account a with (nolock) on a.Id = ua.AccountId
where 1=1
  and ua.UserID = @UserID
  -- and ua.Deleted != 1
  and @AccountID is null or ua.AccountID = @AccountID
order by
  ua.Ordering
