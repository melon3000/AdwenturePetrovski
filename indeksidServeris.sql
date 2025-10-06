--indeksidServeris fail nr 35

SELECT * FROM DimEmployee
-- Loome indeksi, mis aitab paringut: Loome indeksi Salary veerule.
CREATE INDEX IX_DimEmployee_BaseRate
ON DimEmployee(BaseRate ASC)
-- Kui soovid vaadata Indeksit
EXEC sp_help DimEmployee;
-- Kui soovid kustutada indeksit
DROP INDEX DimEmployee.IX_DimEmployee_BaseRate