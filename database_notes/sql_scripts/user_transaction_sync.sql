-- user_transaction_sync.sql

SET TRANSACTION ISOLATION LEVEL READ COMMITTED

DECLARE @UserIdentifier UNIQUEIDENTIFIER = 'a3e95399-f819-40d6-96a5-9ea477f61523'
DECLARE @AccountIdentifier UNIQUEIDENTIFIER = 'f4c239b8-6419-428e-a54f-5c02c8246f0d'

select top 100
  'Account information' as Select_Name
, 'core.UserAccount:' as Table_Core_UserAccount
, ua.UserID
, ua.DisplayName
, ua.MobileDisplayName
, ua.AccountID
, 'core.Accounts:' as Table_Core_Accounts
, a.ID as AccountID
, a.AccountIdentifier
, a.AvailableBalance
, a.LastCoreUpdate
, a.LastTransactionsUpdate
, a.LastTransactionSyncScheduled
, a.LastTransactionSyncFinished
from
  core.Account a with (nolock)
  join core.UserAccount ua with (nolock) on ua.AccountID = a.ID
  join core.Users u with (nolock) on u.ID = ua.UserID
where
  a.AccountIdentifier = @AccountIdentifier
  and u.UserIdentifier = @UserIdentifier
  and ua.Deleted != 1

/*

-- Update transaction sync
-- LastTransactionSyncFinished in core.account should be before LastTransactionSyncScheduled to show "Not all transactions synced"
-- It can be controlled via flag "transaction_sync_status_indicator" from Admin -> MyAccountsV2 Widget Settings.
--


DECLARE @LastTransactionSyncFinished DATETIME
-- when in the past, the app shows "not all transactions synced" message on transaction view screen
-- otherwise when in the feature - no message
SET @LastTransactionSyncFinished = DATEADD(month, -10, CURRENT_TIMESTAMP)

select @LastTransactionSyncFinished

begin tran

update core.Account
set LastTransactionSyncFinished = @LastTransactionSyncFinished where ID = 405944

-- commit
rollback tran

*/