-- select aggregated accounts.sql

select sts.stsid, ua.deleted, ua.displayname, p.Name,
ua.* from core.account a
join core.useraccount ua on ua.accountid = a.id
left join core.UserAccountPermission uap on uap.UserAccountID = ua.ID
left join core.Permission p on p.ID = uap.PermissionID
join core.stsprovideruser sts on sts.userid = ua.userid
where
--sts.stsid = ''
--and
relationship = 4 and deleted = 0