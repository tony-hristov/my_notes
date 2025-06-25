-- OAuth
-- See OAuth documentation page here: https://confluence.alkami.com/display/APITeam/OAuth#OAuth-BasicworkflowforAPIrequestswithOAuth
-- See Slack discussion here: https://alkami.slack.com/archives/CD3MGAHEZ/p1708108429923739
-- See Dynamic Mobile Configs ARD: https://confluence.alkami.com/display/DKB/DEV-164701+-+Dynamic+Mobile+Configurations 

set nocount on
set transaction isolation level read uncommitted

-- select top 100 ra.* from dbo.RegisteredApplications ra with (nolock) order by ra.ID
-- select top 100 oas.* from dbo.OAuthScopes oas with (nolock) order by oas.ID
declare @RegisteredAppID int = 1001
select top 100 'Registered Apps' as query_title,
 ra.ID as RegisteredAppID,
 ra.[Name] as RegisteredAppName,
 ra.[Description] as RegisteredAppDescrp,
 ra.ClientKey,
 ra.ClientSecret,
 ra.TokenLifespan as TokenLifespan,
 ra.RefreshEnabled as RefreshEnabled
from
 dbo.RegisteredApplications ra with (nolock)
where
 (@RegisteredAppID is null or ra.ID = @RegisteredAppID)
order by
 ra.ID

-- select top 100 oas.* from dbo.OAuthScopes oas with (nolock) order by oas.ID -- holds a static list of the OAuth scopes available to the system
select top 100 'Registered Application OAuth Scopes' as query_title,
 ra.ID as RegisteredAppID,
 ra.[Name] as RegisteredAppName,
 -- ra.[Description] as RegisteredAppDescrp,
 oas.ID as OAuthScopeID,
 oas.[Name] as OAuthScopeName,
 oas.[Permissions] as OAuthPermissions,
 oas.[Description] as OAuthScoreDescrp
from
 dbo.RegisteredApplicationOAuthScopes raoas with (nolock)
 join dbo.RegisteredApplications ra with (nolock) on ra.ID = raoas.RegisteredApplicationID
 join dbo.OAuthScopes oas with (nolock) on oas.ID = raoas.OAuthScopeID
where
 (@RegisteredAppID is null or ra.ID = @RegisteredAppID)
order by
 ra.ID,
 oas.ID

-- select top 100 u.* from core.Users u with (nolock)
declare @UserName nvarchar(64) = 'carol.brady'
-- danielc / Test_12345 / 91725
-- jmanning / Test_12345 / 121229

select top 100 'Registered Application Users' as query_title,
 u.UserIdentifier,
 u.DisplayName as UserDisplayName,
 rau.RegisteredApplicationId as UserRegisteredApplicationId,
 ra.[Name] as RegisteredAppName
from
 core.STSProviderUser sts with (nolock)
 join core.Users u with (nolock) on u.ID = sts.Userid
 join dbo.RegisteredApplicationUsers rau with (nolock) on rau.UserKey = u.UserIdentifier
 join dbo.RegisteredApplications ra with (nolock) on ra.ID = rau.RegisteredApplicationID

where 1=1
  and (@UserName is null OR sts.stsid = @UserName)
order by
 u.ID

-- select top 100 * from dbo.Tokens t
-- select top 100 * from dbo.RegisteredApplicationUsers rau
select top 100 'User Tokens Per Application' as query_title,
 u.UserIdentifier,
 rau.RegisteredApplicationId as UserRegisteredApplicationId,
 ra.[Name] as RegisteredAppName,
 t.ID as TokenID,
 t.CreateDate as TokenCreatedDt,
 t.AccessToken,
 t.RefreshToken, -- once used, it will be cleared, so that cannot be used again
 t.LifeSpan
from
 core.STSProviderUser sts with (nolock)
 join core.Users u with (nolock) on u.ID = sts.Userid
 join dbo.RegisteredApplicationUsers rau with (nolock) on rau.UserKey = u.UserIdentifier
 join dbo.RegisteredApplications ra with (nolock) on ra.ID = rau.RegisteredApplicationID
 join dbo.Tokens t with (nolock) on t.RegisteredApplicationUserId = rau.ID
 where
  (@UserName is null OR sts.stsid = @UserName)
  -- and (@RegisteredAppID is null or ra.ID = @RegisteredAppID)
order by
 u.ID,
 t.CreateDate



