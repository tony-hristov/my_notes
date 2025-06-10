-- yodlee

-- If records do not match - delete and retry the flow
-- Check for Yodlee member identifier in the Iav table
--

SELECT uuid.STSID, iavu.* 
FROM [User].[UserIdentity] uuid
JOIN core.Users u ON uuid.UserId = u.id 
JOIN iav.IavUser iavu ON u.id = iavu.UserId
WHERE uuid.STSID LIKE '%awaite123%'

SELECT uuid.STSID, yodus.* 
FROM [User].[UserIdentity] uuid
JOIN core.Users u ON uuid.UserId = u.id 
JOIN yodlee.Users yodus ON u.id = yodus.UserId
WHERE uuid.STSID LIKE '%awaite123%'

