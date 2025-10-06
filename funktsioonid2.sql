-- funktsioonid 2 fail nr33

-- Skaleeritav funktsioon ilma krüpteerimata
CREATE FUNCTION fn_GetEmployeeNameById(@Id INT)
RETURNS NVARCHAR(20)
AS
BEGIN
RETURN (SELECT FirstName FROM DimEmployee WHERE EmployeeKey = @Id)
END
-- Käivita funktsiooni
SELECT dbo.fn_GetEmployeeNameById(1);

-- Nüüd muudame funktsiooni ja krüpteerime selle ära
ALTER FUNCTION fn_GetEmployeeNameById(@Id INT)
RETURNS NVARCHAR(20)
WITH ENCRYPTION
AS
BEGIN
RETURN (SELECT FirstName FROM DimEmployee WHERE EmployeeKey = @Id)
END
-- Käivita funktsiooni
SELECT dbo.fn_GetEmployeeNameById(1);

-- Nüüd muuda funktsiooni ja kasuta käsklust WITH SCHEMABINDING valikut
ALTER FUNCTION fn_GetEmployeeNameById(@Id INT)
RETURNS NVARCHAR(20)
WITH SCHEMABINDING
AS
BEGIN
RETURN (SELECT FirstName FROM dbo.DimEmployee WHERE EmployeeKey = @Id)
END
-- Käivita funktsiooni
SELECT dbo.fn_GetEmployeeNameById(1);