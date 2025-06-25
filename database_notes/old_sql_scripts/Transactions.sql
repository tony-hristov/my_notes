
select * from core.TransactionCategoryDefault where ID = 189
select * from core.TransactionCategoryDefault where ID = 302
select * from core.TransactionCategoryDefault where ParentTransactionCategoryDefaultID = 302
select * from core.TransactionCategoryClassification where ID = 632
select top 1000 * from core.TransactionCategory
select top 1000 * from core.Transactions
select top 1000 * from core.TransactionType
-- select count(*) from core.TransactionCategory

-- select top 1000 * from core.Widget where WidgetType = 0

select top 1000 * from core.Widget where DisplaySettings = 7

select
  w.*,
  fw.NativeDisplaySetting
from
  core.Widget w
    join core.FlavorWidget fw on fw.WidgetID = w.ID
	join core.Flavor fl on fl.ID = fw.FlavorID
where
  fw.WidgetID in ( 3001, 2907)
  and fl.ID in (3107)
order by
  w.ID, fw.FlavorID

select top 1000 * from core.Widget where name in ('SavvyMoney', 'MyAccountsV2')
select * from [core].[WidgetNotificationAction] ws where ws.WidgetID in ( 3001, 2907)
select * from core.WidgetSetting ws where ws.WidgetID in ( 3001, 2907)
select * from core.WidgetTag ws where ws.WidgetID in ( 3001, 2907)
select * from core.WidgetUserImpression ws where ws.WidgetID in ( 3001, 2907)
