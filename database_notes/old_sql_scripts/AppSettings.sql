
-- Admin Api Applications: Setup -> Registered applications -> Mobile Native Application -> Client Settings.

select its.*
from
core.ItemSetting its
inner join core.Item i on its.ItemId = i.Id
inner join core.Provider p on i.ParentId = p.ID
inner join core.ProviderType pt on p.ProviderTypeID = pt.ID
inner join dbo.RegisteredApplications ra on p.Name = (CONVERT(NVARCHAR (10), ra.ID)) + ' :: ApplicationSettings Provider'
where
i.ItemType = 'Processor'
and pt.Name = 'ApplicationSettings'
and ra.Name = 'Mobile Native Application'
and its.[Name] = 'CreditScoreEnabled'
and its.[Value] = 'False'

