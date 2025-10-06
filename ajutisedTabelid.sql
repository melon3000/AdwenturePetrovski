--ajutisedTabelid fail nr 34

SELECT * FROM DimCustomer;
-- Allpool olevas SP-s luuakse ajutine tabel #PersonsDetails ja edastab andmeid ja 
-- lõhub ajutise tabeli automaatselt peale käsu lõpule jõudmist.
CREATE PROCEDURE spCreateLocalTempTable
AS 
BEGIN
CREATE TABLE #DimEmployee(EmployeeKey INT, FirstName NVARCHAR(20))
INSERT INTO #DimEmployee VALUES(1,'Mike')
INSERT INTO #DimEmployee VALUES(2,'John')
INSERT INTO #DimEmployee VALUES(3,'Todd')
SELECT * FROM #DimEmployee
END
-- Käivita funktsiooni
EXEC spCreateLocalTempTable