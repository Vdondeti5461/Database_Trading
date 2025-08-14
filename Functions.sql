-- Functions 


--Function 1

CREATE OR REPLACE FUNCTION GetUserEmail(p_UserID IN Users.UserID%TYPE)
RETURN VARCHAR2 IS
  v_Email Users.Email%TYPE;
BEGIN
  SELECT Email INTO v_Email
  FROM Users
  WHERE UserID = p_UserID;

  RETURN v_Email;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN 'No user found with the given UserID.';
  WHEN OTHERS THEN
    RETURN 'Error occurred: ' || SQLERRM;
END;
/


--Function 2
CREATE OR REPLACE FUNCTION GetUserBalance(p_UserID IN Accounts.UserID%TYPE)
RETURN NUMBER IS
  v_Balance Accounts.Balance%TYPE;
BEGIN
  SELECT Balance INTO v_Balance
  FROM Accounts
  WHERE UserID = p_UserID;

  RETURN v_Balance;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20001, 'No account found for the given UserID.');
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20002, 'Error occurred: ' || SQLERRM);
END;
/


--function 3

CREATE OR REPLACE FUNCTION CountUserOrders(p_UserID IN Orders.UserID%TYPE)
RETURN NUMBER IS
  v_OrderCount NUMBER;
BEGIN
  SELECT COUNT(*)
  INTO v_OrderCount
  FROM Orders
  WHERE UserID = p_UserID;

  RETURN v_OrderCount;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN 0; -- Assuming no orders means count is 0
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20006, 'Error occurred: ' || SQLERRM);
END;
/


--function 4

CREATE OR REPLACE FUNCTION GetInstrumentType(p_InstrumentID IN Instruments.InstrumentID%TYPE)
RETURN VARCHAR2 IS
  v_Type Instruments.Type%TYPE;
BEGIN
  SELECT Type INTO v_Type
  FROM Instruments
  WHERE InstrumentID = p_InstrumentID;

  RETURN v_Type;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20009, 'Instrument not found.');
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20010, 'Error occurred: ' || SQLERRM);
END;
/

--Function f5

CREATE OR REPLACE FUNCTION GetTotalDeposits(p_UserID IN Users.UserID%TYPE)
RETURN DECIMAL IS
  v_TotalDeposits DECIMAL(10, 2) := 0;
BEGIN
  SELECT SUM(d.Amount)
  INTO v_TotalDeposits
  FROM Deposits d
  INNER JOIN Wallets w ON d.WalletID = w.WalletID
  WHERE w.UserID = p_UserID;

  RETURN NVL(v_TotalDeposits, 0);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN 0; -- Assuming no deposits means total is 0
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20014, 'Error occurred: ' || SQLERRM);
END;
/


-- Function 6

CREATE OR REPLACE FUNCTION CalculateTotalPortfolioValue_V3(p_UserID IN Users.UserID%TYPE)
RETURN DECIMAL IS
  v_TotalValue DECIMAL(10, 2) := 0;
BEGIN
  SELECT SUM(md.ClosePrice)
  INTO v_TotalValue
  FROM PortfolioInstruments pi
  JOIN Instruments ins ON pi.InstrumentID = ins.InstrumentID
  JOIN MarketData md ON ins.InstrumentID = md.InstrumentID
  WHERE pi.PortfolioID IN (SELECT PortfolioID FROM Portfolios WHERE UserID = p_UserID);

  RETURN NVL(v_TotalValue, 0);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN 0; -- Return 0 if no portfolio data is found
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20025, 'Error occurred: ' || SQLERRM);
END;
/


--Function 7

CREATE OR REPLACE FUNCTION GetUserRecentTransaction(p_UserID IN Users.UserID%TYPE)
RETURN VARCHAR2 IS
  v_TransactionDetails VARCHAR2(4000);
BEGIN
  SELECT 'TransactionID: ' || TransactionID || ', OrderID: ' || OrderID || ', Timestamp: ' || Timestamp
  INTO v_TransactionDetails
  FROM Transactions
  WHERE OrderID IN (SELECT OrderID FROM Orders WHERE UserID = p_UserID)
  ORDER BY Timestamp DESC
  FETCH FIRST 1 ROW ONLY;

  RETURN v_TransactionDetails;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN 'No transactions found for the user.';
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20026, 'Error occurred: ' || SQLERRM);
END;
/

-- test git url 



