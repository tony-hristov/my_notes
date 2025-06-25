-- DisclosureRegistrationAcceptance.sql

select a.ledgerbalance,
ua.DisplayName,
ua.id,
a.id,
ua.DisplayName,
a.AccountTypeID,
at.AccountTypeClassID,
ua.relationship,
at.IsCreditCardAccount,* from core.STSProviderUser sts
join core.useraccount ua on sts.Userid = ua.UseriD
join core.Users u on u.ID = ua.UserID
join core.account a on ua.AccountID = a.ID 
join core.AccountType at on a.AccountTypeID = at.ID
where sts.stsid = 'jmanning'

-- danielc / Test_12345 / 91725
-- jmanning / Test_12345 / 121229

select * from content.DisclosureAcceptance where UserID in (91725, 121229) and DisclosureID = 1
select * from content.Element where name in ('DisclosureRegistration', 'DisclosureBusinessRegistration')
--DisclosureRegistration = 1
--DisclosureBusinessRegistration - 5715
--delete from content.DisclosureAcceptance where UserID in (91725, 121229) and DisclosureID = 1

