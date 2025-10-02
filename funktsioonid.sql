--funktsioonid
SELECT * FROM DimEmployee

--Tabelisisev‰‰rtusega funktsioon e Inline Table Valued function (ILTVF) koodin‰ide:
Create Function fn_ILTVF_GetEmployees()

Returns Table
as
Return (Select EmployeeKey, FirstName, CAST(BirthDate AS date) as DOB
	From dbo.DimEmployee)

SELECT * FROM fn_ILTVF_GetEmployees();
 