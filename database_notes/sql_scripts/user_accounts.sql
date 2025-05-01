-- user_accounts.sql

SET TRANSACTION ISOLATION LEVEL READ COMMITTED

DECLARE @UserName NVARCHAR(100) = 'awaite'
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


