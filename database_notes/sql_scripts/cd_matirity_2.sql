USE AlkamiVermontFCU_Red14
 
SELECT Distinct ua.DisplayName, sts.STSID, at.CoreName, a.MaturityDate, a.MaturityPaymentMethod, a.MaturityTransferAccountIdentifier
FROM core.STSProviderUser sts
JOIN core.users u ON sts.UserId = u.id
JOIN core.UserAccount ua ON u.id = ua.UserID
JOIN core.Account a ON ua.AccountID = a.id
JOIN core.AccountType at ON a.AccountTypeID = at.ID
JOIN core.AccountTypeClass atc ON at.AccountTypeClassID = atc.id
JOIN core.item i ON i.ParentId = at.id
JOIN core.ItemSetting its ON its.ItemId = i.id
--WHERE sts.STSID = 'brdaniels'
WHERE
    (at.IsCertificateAccount = 1
        OR (its.name LIKE '%IsCertifi%' AND its.value like '%true%')
    )
AND a.MaturityDate > GETUTCDATE()
ORDER BY ua.DisplayName ASC