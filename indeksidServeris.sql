--35
--N��d loome indeksi, mis aitab p�ringut: Loome indeksi Salary veerule.
CREATE INDEX IX_DimEmployee_BaseRate
ON DimEmployee(BaseRate ASC)

--kontroll v�i execute
execute sp_help DimEmployee;

--kustuta v�i drop
DROP INDEX DimEmployee.IX_DimEmployee_BaseRate

ALTER TABLE DimEmployee
DROP CONSTRAINT FK_DimEmployee_DimEmployee;


--36
select * from DimEmployee
--esimene index
create clustered index ix_dimemployee_name
on dimemployee(FirstName)
--Selle tulemusel SQL server ei luba luua rohkem, 
--kui �hte klastreeritud indeksit tabeli kohta. J�rgnev skript annab veateate: 
--'Cannot create more than one clustered index on table 'tblEmployee'. Drop the existing clustered index PK__tblEmplo__3214EC0706CD04F7 before creating another.' 

--N��d loome klastreeritud indeksi kahe veeruga. Selleks peame enne kustutama praeguse klastreeritud indeksi Id veerus:
drop index dimemployee.PK_dimEmplo__3214EC070A9D95DB

--N��d k�ivita j�rgnev kood uue klastreeritud �hendindeksi loomiseks Gender ja Salary veeru p�hjal:
create clustered index ix_dimempoyee_gender_salaryflag
on dimemployee(Gender desc,salariedflag asc)

--J�rgnev kood loob SQL-s mitte-klastreeritud indeksi Name veeru j�rgi tblEmployee tabelis:
create nonclustered index ix_dimemployee_firstname
on dimemployee(firstname)

--37
--Kuna oleme m�rkinud Id primaarv�tmeks, siis UNIQUE CLUSTERED INDEX luuakse Id veergu ja Id on indeksv�ti.
--Saame kontrollida seda k�sklusega sp_helpindex , mis on s�steemi SP talletatud.
exec sp_helpindex dimEmployee

--Unikaalsus on indeksi omadus ja nii klastreeritud kui ma mitte-klastreeritud indeksid saavad olla unikaalsed.
--Kuidas saab luua unikaalset mitte-klastreeritud indeksit FirstName ja LastName veeru p�hjal.
create unique nonclustered index uix_dimemployee_firstname_lastname
on dimemployee(firstname,lastname)

--Kui peaksid lisama unikaalse piirangu, siis unikaalne indeks luuakse tagataustal. 
--Selle t�estuseks lisame koodiga unikaalse piirangu City veerule.
ALTER TABLE dimEmployee 
ADD CONSTRAINT UQ_dimEmployee_Title
UNIQUE NONCLUSTERED (Title)

--kui soovite sisestada k�mme rida andmeid, millest viis sisaldavad korduvaid andmeid, siis k�ik k�mme rida l�katakse tagasi.
--Kui soovite tagasi l�kata ainult viis rida ja sisestada viis kordumatut rida, siis kasutage selleks valikut IGNORE_DUP_KEY
CREATE UNIQUE INDEX IX_dimEmployee_City
ON dimEmployee(Title)
WITH IGNORE_DUP_KEY


--38
--Loo mitte-klastreeritud indeks Salary veerule:
create nonclustered index ix_tblemployee_sickleavehours
on dimemployee(sickleavehours asc)

--J�rgnev SELECT p�ring saab kasu Salary veeru indeksist kuna palgad on indeksis langevas j�rjestuses. 
--Indeksist l�htuvalt on kergem �les otsida palkasid, mis j��vad vahemikku 4000 kuni 8000 ning kasutada reaaadressi.
select * from DimEmployee where SickLeaveHours > 20 and SickLeaveHours <50

--Mitte ainult SELECT k�sklus, vaid isegi DELETE ja UPDATE v�ljendid saavad indeksist kasu. 
--Kui soovid uuendada v�i kustutada rida, siis SQL server peab esmalt leidma rea ja indeks saab aidata seda otsingut kiirendada.
delete from DimEmployee where SickLeaveHours = 20
update DimEmployee set SalariedFlag = 1 where SalariedFlag = 12

--See v�listab p�ringu k�ivitamisel ridade sorteerimise, mis oluliselt  suurendab  protsessiaega.
select * from DimEmployee order by SickLeaveHours

-- BaseRate veeru indeks saab aidata ka allpool olevat p�ringut. Seda tehakse indeksi tagurpidi skanneerimises.
select * from DimEmployee order by SickLeaveHours desc
 
 -- GROUP BY p�ringud saavad kasu indeksitest. Kui soovid grupeerida t��tajaid sama palgaga, siis p�ringumootor saab kasutada BaseRate veeru indeksit
 select SickLeaveHours, count(SickLeaveHours) as total
 from dimemployee
 group by SickLeaveHours
