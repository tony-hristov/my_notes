-- File: widget_names.sql
-- Description: Get list of widgets with their localized names

-- use AlkamiICCU_Red14 -- Server DC00DB01
-- go

use [DeveloperDynamic] -- localhost
go

SET TRANSACTION ISOLATION LEVEL READ COMMITTED

-- Get list of all widget name localizations in the database (for the FI)

select top 1000
  lr.[Name] as LocalizableResourceKey_Name,
  lr.[SecondaryId] as LocalizableResourceKey_SecondaryId,
  w.[Name] as WidgetName,
  its.[Value] as DisplayName,
  i.Id as ItemId,
  i.SecondaryId as LocaleId,
  l.[Name] as LocaleName,
  '>>> Table core.widget w >>>',
  w.*,
  '>>> Table dbo.LocalizableResource lr >>>',
  lr.*,
  '>>> Table core.Item i >>>',
  i.*,
  '>>> Table core.ItemSetting its >>>',
  its.*
from core.widget w (nolock)
  join dbo.LocalizableResource lr (nolock) on lr.Name = 'Widget.' + w.Name
  join core.Item i (nolock) on lr.ID = i.ParentId
	and i.ItemType = 'Localizable Resource'
  join core.ItemSetting its (nolock) on its.ItemId = i.Id
	and its.Name = 'DisplayName'
  join dbo.Locale l (nolock) on l.LocaleID = i.SecondaryId
where 1=1
  -- and w.[Name] = 'MessageCenter'
order by
  lr.[Name],
  lr.SecondaryId desc

-- Some additional tables bellow

-- 1224079	1131101	DisplayName	Alerts
-- 1224080	1131102	DisplayName	Alertas

select * from core.ItemSetting its where its.Id = 1224080
-- update core.ItemSetting set Value = ' ' where Id = 1224080
-- update core.ItemSetting set Value = 'Alertas' where Id = 1224080

select * from core.ItemSetting its where its.Id = 1224079
-- update core.ItemSetting set Value = ' ' where Id = 1224079
-- update core.ItemSetting set Value = 'Alerts' where Id = 1224079


select * from core.ItemSetting its where its.Id = 301 -- 'Bill Pay'
-- update core.ItemSetting set Value = ' ' where Id = 301
-- update core.ItemSetting set Value = 'Bill Pay' where Id = 301


/*
begin tran
delete from dbo.LocalizableResource where [Name] = 'Widget.MessageCenter'
insert into dbo.LocalizableResource ([Name], SecondaryId) Values ('Widget.MessageCenter', -1)

update dbo.LocalizableResource set ID = 211 where [Name] = 'Widget.MessageCenter'
where ID = 211
commit
*/

/*
select *
from dbo.Locale

select *
from [dbo].[LocalizableResource]

select *
from [Contact].[Locale]
where 1 = 1
  and BaseLocaleId in (1033, 21514)
  and CultureCode in ('es-US', 'en-US')
  and IsAvailable = 1
*/

/*
update [Contact].[Locale]
set IsAvailable = 1
where Id = 21514
*/