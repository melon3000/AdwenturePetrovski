--35
--Nüüd loome indeksi, mis aitab päringut: Loome indeksi Salary veerule.
CREATE INDEX IX_DimEmployee_BaseRate
ON DimEmployee(BaseRate ASC)

--kontroll või execute
execute sp_help DimEmployee;

--kustuta või drop
DROP INDEX DimEmployee.IX_DimEmployee_BaseRate

ALTER TABLE DimEmployee
DROP CONSTRAINT FK_DimEmployee_DimEmployee;


--36
select * from DimEmployee
--esimene index
create clustered index ix_dimemployee_name
on dimemployee(FirstName)
--Selle tulemusel SQL server ei luba luua rohkem, 
--kui ühte klastreeritud indeksit tabeli kohta. Järgnev skript annab veateate: 
--'Cannot create more than one clustered index on table 'tblEmployee'. Drop the existing clustered index PK__tblEmplo__3214EC0706CD04F7 before creating another.' 

--Nüüd loome klastreeritud indeksi kahe veeruga. Selleks peame enne kustutama praeguse klastreeritud indeksi Id veerus:
drop index dimemployee.PK_dimEmplo__3214EC070A9D95DB

--Nüüd käivita järgnev kood uue klastreeritud ühendindeksi loomiseks Gender ja Salary veeru põhjal:
create clustered index ix_dimempoyee_gender_salaryflag
on dimemployee(Gender desc,salariedflag asc)

--Järgnev kood loob SQL-s mitte-klastreeritud indeksi Name veeru järgi tblEmployee tabelis:
create nonclustered index ix_dimemployee_firstname
on dimemployee(firstname)

--37
--Kuna oleme märkinud Id primaarvõtmeks, siis UNIQUE CLUSTERED INDEX luuakse Id veergu ja Id on indeksvõti.
--Saame kontrollida seda käsklusega sp_helpindex , mis on süsteemi SP talletatud.
exec sp_helpindex dimEmployee

--Unikaalsus on indeksi omadus ja nii klastreeritud kui ma mitte-klastreeritud indeksid saavad olla unikaalsed.
--Kuidas saab luua unikaalset mitte-klastreeritud indeksit FirstName ja LastName veeru põhjal.
create unique nonclustered index uix_dimemployee_firstname_lastname
on dimemployee(firstname,lastname)

--Kui peaksid lisama unikaalse piirangu, siis unikaalne indeks luuakse tagataustal. 
--Selle tõestuseks lisame koodiga unikaalse piirangu City veerule.
ALTER TABLE dimEmployee 
ADD CONSTRAINT UQ_dimEmployee_Title
UNIQUE NONCLUSTERED (Title)

--kui soovite sisestada kümme rida andmeid, millest viis sisaldavad korduvaid andmeid, siis kõik kümme rida lükatakse tagasi.
--Kui soovite tagasi lükata ainult viis rida ja sisestada viis kordumatut rida, siis kasutage selleks valikut IGNORE_DUP_KEY
CREATE UNIQUE INDEX IX_dimEmployee_City
ON dimEmployee(Title)
WITH IGNORE_DUP_KEY


--38
--Loo mitte-klastreeritud indeks Salary veerule:
create nonclustered index ix_tblemployee_sickleavehours
on dimemployee(sickleavehours asc)

--Järgnev SELECT päring saab kasu Salary veeru indeksist kuna palgad on indeksis langevas järjestuses. 
--Indeksist lähtuvalt on kergem üles otsida palkasid, mis jäävad vahemikku 4000 kuni 8000 ning kasutada reaaadressi.
select * from DimEmployee where SickLeaveHours > 20 and SickLeaveHours <50

--Mitte ainult SELECT käsklus, vaid isegi DELETE ja UPDATE väljendid saavad indeksist kasu. 
--Kui soovid uuendada või kustutada rida, siis SQL server peab esmalt leidma rea ja indeks saab aidata seda otsingut kiirendada.
delete from DimEmployee where SickLeaveHours = 20
update DimEmployee set SalariedFlag = 1 where SalariedFlag = 12

--See välistab päringu käivitamisel ridade sorteerimise, mis oluliselt  suurendab  protsessiaega.
select * from DimEmployee order by SickLeaveHours

-- BaseRate veeru indeks saab aidata ka allpool olevat päringut. Seda tehakse indeksi tagurpidi skanneerimises.
select * from DimEmployee order by SickLeaveHours desc
 
 -- GROUP BY päringud saavad kasu indeksitest. Kui soovid grupeerida töötajaid sama palgaga, siis päringumootor saab kasutada BaseRate veeru indeksit
 select SickLeaveHours, count(SickLeaveHours) as total
 from dimemployee
 group by SickLeaveHours
