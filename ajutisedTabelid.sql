--ajutisedTabelid fail nr 34

SELECT * FROM DimCustomer;
-- Allpool olevas SP-s luuakse ajutine tabel #PersonsDetails ja edastab andmeid ja 
-- l�hub ajutise tabeli automaatselt peale k�su l�pule j�udmist.
CREATE PROCEDURE spCreateLocalTempTable
AS 
BEGIN
CREATE TABLE #DimEmployee(EmployeeKey INT, FirstName NVARCHAR(20))
INSERT INTO #DimEmployee VALUES(1,'Mike')
INSERT INTO #DimEmployee VALUES(2,'John')
INSERT INTO #DimEmployee VALUES(3,'Todd')
SELECT * FROM #DimEmployee
END
-- K�ivita funktsiooni
EXEC spCreateLocalTempTable