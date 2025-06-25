-- Account.sql

use AlkamiEducators_Red14

set nocount on
set transaction isolation level read uncommitted

declare @AccountIdentifier uniqueidentifier = '3e7a6def-aab2-485e-9ab6-d7cce2278017'


select top 100 'Registered Application Users' as query_title
, sts.stsid
, a.id as AccountId
, a.AccountIdentifier
, a.MICRAccountNumber
, a.AvailableBalance
, a.LedgerBalance
, a.NextPaymentAmountDue
, a.NextPaymentDate
, a.LastTransactionSyncScheduled
, a.LastTransactionSyncFinished
, a.LastUpdate
, at.IsPayoffCalculatorDisplayed
, at.CoreName
, at.AccountTypeClassID
, atc.Name as AccountTypeClassName
from
 core.account a with (nolock)
 join core.AccountType at with (nolock) on at.ID = a.AccountTypeID
 join core.AccountTypeClass atc with (nolock) on atc.ID = at.AccountTypeClassID
 join core.UserAccount ua with (nolock) on ua.AccountID = a.ID
 join core.Users u with (nolock) on u.ID = ua.UserID
 join core.STSProviderUser sts with (nolock) on sts.Userid = ua.UseriD
where
 (@AccountIdentifier is null or a.AccountIdentifier = @AccountIdentifier)