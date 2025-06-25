-- AccountTransactions.sql

-- (1) find account transactions

-- use AlkamiICCU_Red14
set nocount on
set transaction isolation level read uncommitted

declare @UserName nvarchar(128) = 'awaite'
declare @AccountIdentifier uniqueidentifier = '83005d16-a173-4610-9915-7f3cd14ad4fe'
declare @AccountID int

select @AccountID = ua.AccountID
from core.UserAccount ua with (nolock)
join core.Account a with (nolock) on a.ID = ua.AccountID
join core.stsprovideruser sts with (nolock) on sts.userid = ua.userid
join core.users u with (nolock) on u.id = ua.userid
where
sts.stsid = @UserName
and a.AccountIdentifier = @AccountIdentifier

select 'UserAccount:', ua.*
from core.UserAccount ua with (nolock)
where ua.AccountID = @AccountID

select COUNT(*) as [Count Transactions]
from core.transactions t with (nolock)
where t.accountid = @AccountID

select COUNT(*) as [Count Pending Transactions]
from core.accounthold ah with (nolock)
where ah.accountid = @AccountID

select top 3 *
from core.accounthold ah with (nolock)
where ah.accountid = @AccountID

