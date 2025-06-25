
use AlkamiTTCUFCU_Red14
go


SELECT * FROM core.ItemSetting WHERE Name LIKE '%Issuer%' AND Value LIKE '%ip%'

select sts.STSID, ua.ID as useraccountid, ua.DisplayName, a.CreateDate, * from core.Account a
join core.UserAccount ua on ua.AccountID = a.id
join core.Users u on u.ID = ua.UserID
join core.STSProviderUser sts on sts.UserId = u.ID
where STSID  = 'ajarrett' 
order by a.CreateDate DESC


