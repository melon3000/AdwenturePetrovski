--funktsioonid fail nr 32

--Tabelisiseväärtusega funktsioon e Inline Table Valued function (ILTVF) koodinäide:
Create Function fn_ILTVF_GetEmployees()

Returns Table
as
Return (Select EmployeeKey, FirstName, CAST(BirthDate AS date) as DOB
	From dbo.DimEmployee)

SELECT * FROM fn_ILTVF_GetEmployees();
 

 -- Mitme avaldisega tabeliväärtusega funktsioonid e multi-statement table valued function (MSTVF):
create function fn_mstvf_getemployees()
returns @Table table (id int,Name nvarchar(20), DOB date)
as
begin
insert into @Table
select EmployeeKey,FirstName,cast(BirthDate as date)
from dimEmployee
return
end
--kontroll
Select * from fn_MSTVF_GetEmployees()

	
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
