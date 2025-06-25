-- test_automation_find_user.sql
--
-- Use this script to find test automation users and their passwords
--
-- Connect to server "DC00DB01" for the TestAutomation database


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
  [dbo].[UserTestData_trin] utd (nolock)
WHERE 1=1
  and [Fi] like '%iccu%' 
  -- and UserName = 'ALKATOAIUser' -- alk@mi12345TEST
  and UserName = 'awaite123' -- alk@mi1234TEST
  -- and UserName = 'ACRIdaho'

  -- and [Fi] = 'mountainamerica' 
  -- and DataType = 'Default'

-- Staging / Macu / alkami01 / Macu1234
-- Smith / Macu / joebiztest / alk@mi1234TEST

