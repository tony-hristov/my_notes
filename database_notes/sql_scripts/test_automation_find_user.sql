-- test_automation_find_user.sql

SET TRANSACTION ISOLATION LEVEL READ COMMITTED

use TestAutomation
go

select top 100
  utd.[Fi]
, utd.[DataType]
, utd.[UserName]
, (CAST(CAST('' AS XML).value('xs:base64Binary(sql:column("password"))', 'VARBINARY(MAX)') AS VARCHAR(MAX))) AS DecodedPassword
, utd.[Password]
, utd.[MemberID]
, utd.[Comments]
, utd.[Id]
from
  [dbo].[UserTestData_staging] utd (nolock)
WHERE 1=1
  and [Fi] like '%texan%'


  -- and [Fi] like '%iccu%' 
  -- and UserName = 'ALKATOAIUser' -- alk@mi12345TEST
  -- and UserName = 'iccusub20230802 -- alk@mi1234TEST

  -- and [Fi] = 'mountainamerica' 
  -- and DataType = 'Default'

-- Staging / Macu / alkami01 / Macu1234
-- Smith / Macu / joebiztest / alk@mi1234TEST

