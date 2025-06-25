

select * from core.Entity
select * from core.EntityGroup

select * from core.EntityPermission
select * from core.EntityGroupPermission


select * from core.EntityGroupPermission egp
join core.Permission p on p.ID = egp.PermissionID
where p.Name = 'AccountAggregationSubUserControl'
