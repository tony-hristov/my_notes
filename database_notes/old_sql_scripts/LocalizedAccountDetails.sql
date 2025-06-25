-- Localized items

select * from core. ItemSetting its
join core.item it on it.Id = its. ItemId
join dbo.LocalizableResource lr on lr.id = it.ParentId
where lr.Name like '%accounttypefield%'