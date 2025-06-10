-- cd_maturity.sql


-- use AlkamiVermontFCU_Red14
use AlkamiCommFCU_Red14
GO

select
  sts.stsid,
  ua.accountid,
  p.DisplayName,
  a.ledgerbalance,
  ua.DisplayName,
  a.MaturityPaymentMethod,
  case 
    -- see: https://gitlab.mgmt.alkami.net/CORE/alkami.core.common/-/blob/master/Core/Alkami.Core.Data/Accounts/MaturityPaymentMethodType.cs
    when a.MaturityPaymentMethod = 1 then 'Check' -- A payment type of check
    when a.MaturityPaymentMethod = 2 then 'InternalTransfer' -- A payment type of Internal Transfer, or a transfer to account in the same bank
    when a.MaturityPaymentMethod = 3 then 'Renew' -- Dividend will be reinvested in the account
    when a.MaturityPaymentMethod = 4 then 'Suspend' -- The funds remains in the share until transfered manually
    else 'None'
  end as MaturityPaymentMethodType,
  a.MaturityTransferAccountIdentifier,
  a.AccountIdentifier,
  a.AvailableBalance,
  ua.UserID as UserId,
  a.id,
  ua.DisplayName,
  at.CoreName,
  a.AccountTypeID,
  at.AccountTypeClassID,
  ua.relationship,
  ua.ID as 'UserAccountId',
  at.IsCreditCardAccount,
  *
from core.STSProviderUser sts
  left join core.useraccount ua on sts.UserId=ua.UserID
  left join core.account a on ua.AccountID=a.ID
  left join core.AccountType at on a.AccountTypeID=at.ID AND at.CoreName like '%S:005%'
  left join payment.FundingAccount fa on fa.UserAccountId = ua.id and fa.IsDeleted = 0
  left join core.UserAccountPermission uap on uap.UserAccountID = ua.id
  left join core.Permission p on p.id = uap.PermissionID
where 1=1
  and sts.stsid like '%Tallai%'
  and a.AccountIdentifier = '4ae206be-f028-4e9a-867b-046e43781548'
  -- and sts.stsid like '%janepickell%'
  -- and sts.stsid like '%Mariocapp%' -- janepickell, Mariocapp, vlafave0628, mcmillian and rbwolynec

