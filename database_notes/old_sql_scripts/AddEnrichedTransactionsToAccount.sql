use DeveloperDynamic

-- update these two for the user 
DECLARE @UserId BIGINT = 4859;		
DECLARE @AccountID BIGINT = 21073;	

-- flag / toggle for whether or not to also insert an enrichment transaction
DECLARE @addEnrichment BIT = 1;
DECLARE @transactionsCount BIGINT = 35;

BEGIN TRAN

DECLARE @Counter INT = 0;
DECLARE @date DATETIME = DATEADD(DAY, ((-1)*(35)), GETUTCDATE());
DECLARE @NewTxnId BIGINT;
DECLARE @PreviousBalance decimal(19,5) = (select top 1 Balance from core.Transactions where AccountID=@AccountID order by PostingDate desc, ID desc);
DECLARE @Amount decimal(19,5);


IF (@PreviousBalance is null)
	set @PreviousBalance = 0.00


WHILE ( @Counter < @transactionsCount)
BEGIN

	-- sprouts
	SET @Amount = -164.49000;
	SET @PreviousBalance = @PreviousBalance + @Amount;
	INSERT [core].[Transactions] ([AccountID], [PostingDate], [EffectiveDate], [Amount], [Balance], [BatchNumber], [CheckNumber], [ImageSequence], [TransactionCode], [GeneralDescription], [SpecificDescription], [CoreSequence], [PostingSequence], [Obsolete_PayeeID], [UserID], [Debit], [CreateDate], [TranKey], [PrincipalAmount], [InterestAmount], [MICRAccountNumber], [EscrowAmount], [FeeAmount], [OtherAmount], [MerchantClassificationCode], [TraceNumber], [IsVoid], [LastUpdate])
	VALUES (@AccountID, @date, @date, @Amount, @PreviousBalance, NULL, 0, N'NULL', N'336', 
		N'TEST TRANSACTION' + cast(@Counter as nvarchar),		-- General Description
		N'TEST TRANSACTION SPEC' + cast(@Counter as nvarchar),		-- Specific Description
		177835428, 0, NULL, @UserId, 
		1,  -- debit
		GETUTCDATE(), NULL, NULL, NULL,NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL
	);
	SET @NewTxnId = SCOPE_IDENTITY();
	IF (@addEnrichment = 1)
	BEGIN
	INSERT INTO [transaction].Enrichment 
	values
	(
		@NewTxnId,
		@UserId,
		179819648,
		10, -- category
		'Test Transactions', -- cleansed desc
		'Test Merchant', -- merch
		GETUTCDATE(),GETUTCDATE(),
		'33.12171200',
		'-96.80285800',
		'5190 Preston Rd',
		'Frisco',
		'TX',
		'75034',
		'US',
		NULL
	);
	END

	SET @date = DATEADD(DAY, 1, @date);

SET @Counter = @Counter + 1
END

select * from core.transactions where accountid =@AccountID order by id desc;

select year(PostingDate), month(PostingDate), day(PostingDate), Count(Id) as transactionCount from core.transactions where accountid =@AccountID and year(PostingDate) > 2018 group by year(PostingDate), month(PostingDate), day(PostingDate) order by year(PostingDate) desc;


commit tran
-- rollback TRAN