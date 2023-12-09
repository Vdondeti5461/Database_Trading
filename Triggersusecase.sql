--first trigger Test case

-- Insert a mock session
INSERT INTO UserSessions (SessionID, UserID, Token, ExpiresAt)
VALUES (SessionID_SEQ.NEXTVAL, 1, 'token123', SYSDATE + 7);

-- Query the Logs table to verify the trigger action
SELECT * FROM Logs WHERE UserID = 1;


--second trigger use case

-- Insert a mock deposit (replace the WalletID and UserID with actual values from your database)
INSERT INTO Deposits (DepositID, WalletID, Amount, Timestamp)
VALUES (DepositID_SEQ.NEXTVAL, [Your WalletID], 1000.00, SYSDATE);

-- Query the Accounts table to verify the trigger action (replace the UserID with the actual UserID linked to the WalletID used above)
SELECT * FROM Accounts WHERE UserID = [Your UserID];


--Third Trigger use case

-- Attempt a mock withdrawal (replace the WalletID with an actual value from your database and set an Amount greater than the account balance)
INSERT INTO Withdrawals (WithdrawalID, WalletID, Amount, Timestamp)
VALUES (WithdrawalID_SEQ.NEXTVAL, [Your WalletID], [Amount Greater Than Balance], SYSDATE);

--Fourth Trigger use case

-- Update a user's password (replace UserID and Password with appropriate values)
UPDATE Users
SET Password = 'newPassword'
WHERE UserID = [Your UserID];

--Fifth Tigger Use case

-- Update a user's profile (replace ProfileID with an actual value)
UPDATE UserProfiles
SET FirstName = 'UpdatedFirstName', LastName = 'UpdatedLastName'
WHERE ProfileID = [Your ProfileID];

-- Query the Logs table to verify the trigger action
SELECT * FROM Logs WHERE UserID = [Your UserID] AND Action = 'User profile updated';

--sixth trigger use case

-- Update an order's status (replace OrderID with an actual value and set a new status)
UPDATE Orders
SET Status = 'NewStatus'
WHERE OrderID = [Your OrderID];

-- Query the Notifications table to verify the trigger action
SELECT * FROM Notifications WHERE UserID = [Associated UserID with Order];


-- Query the AuditTrail table to verify the trigger action
SELECT * FROM AuditTrail WHERE UserID = [Your UserID];

