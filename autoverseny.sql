create database autoverseny character set utf8mb4 collate utf8mb4_general_ci;
use autoverseny;

/*
    táblák 
*/

create table csapat(
    id int primary key, 
    nev varchar(255),
    alapitva int
);

create table palya(
    id int primary key, 
    nev varchar(255),
    hossz float,
    orszag varchar(255)
);

create table versenyzo(
    id int, 
    nev varchar(255),
    eletkor int, 
    csapatid int, 
    primary key (id),
    CONSTRAINT FK_versenyzo_csapat_id FOREIGN KEY(csapatid) REFERENCES csapat(id)
);

create table korido(
    id int primary key, 
    palyaid int, 
    versenyzoid int, 
    korido time default null, 
    /*
        amikor azt akarjuk, hogy valamilyen be legyen állítva az értéke, akkor használjuk a default-ot és lehet azt is, hogy ez a default 
        érték ez null 
        -> 
        korido time default null
    */
    kor int default null,
    CONSTRAINT FK_korido_palya_id FOREIGN KEY (palyaid) REFERENCES palya(id),
    CONSTRAINT FK_korido_versenyzo_id FOREIGN KEY (versenyzoid) REFERENCES versenyzo(id)
)

/*
    itt ami nagyon fontos -> FLOAT 
    tehát ezek lehetnek tört számok is, mert az int(integer) az csak egész szám lehet 
    ->
    hossz float
*/

/*
    itt töltjük majd fel a táblákat adatokkal 
*/

INSERT INTO csapat VALUES
(1, 'Versenylovak', 1901),
(2, 'MintaPinty', 1948),
(3, 'Villámlás', 1967),
(4, 'SzélTiks', 1957),
(5, 'RemeteRákok', 1990),
(6, 'CsigaCsapat', 1919),
(7, 'OlajozottMénkű', 1999),
(8, 'TeljesGőz', 1934),
(9, 'Rakéták', 1982);

INSERT INTO palya VALUES
(1, 'Gran Prix Circuit', 3.6, 'Anglia'),
(2, 'International Circuit', 3.2, 'Belgium'),
(3, 'Record Raceway', 3.9, 'Franciaország'),
(4, 'Red Ring', 3.23, 'Olaszország'),
(5, 'Autodrome', 4.1, 'Németország'),
(6, 'StreetRing', 3.89, 'Monaco');

/*
    Listázza ki az adatbázisban található versenyzők neveit! A nevek életkor szerint csökkenő rendben
    legyenek! (3. feladat:)
*/

select nev
from versenyzo 
order by eletkor desc;

/*
    Határozza meg és írja ki az adatbázisban megtalálható pályák számát! A lekérdezés fejléce a minta
    szerinti legyen! (4. feladat:) 

    Itt lehet az is, hogy mivel nincs több palya, csak annyi amennyi adat, rekord van, ezért megszámoljuk az összeset 
    select count(*)
    de ehelyett lehetett volna az is, hogy count(palya.id) mondjuk
*/

select count(*) as "pályák száma" 
from palya;

/*
    Listázza ki a „z” karaktert tartalmazó csapat neveket és a csapathoz tartozó versenyzők neveit! A
    lekérdezés fejléce a minta szerinti legyen! A sorok a csapat név mező szerint ABC rendben
    legyenek! (5. feladat:) 
*/

select csapat.nev, versenyzo.nev as "versenyzo" 
from csapat 
inner join versenyzo
on versenyzo.csapatid = csapat.id
having csapat.nev like "%z%"
order by versenyzo.nev;

/*
    Listázza ki, hogy az Olaszországban található versenypályákon a versenyek első körében
    milyen köridőket futottak a versenyzők! A lekérdezésben a pálya neve, a versenyző neve
    és a futott köridó szerepeljen! A lekérdezés fejléce a minta szerinti legyen!
*/

/*
    fontos, hogy itt majd kettő feltétel is kell, tehát egy WHERE és egy AND
*/

select palya.nev as "pályanév", versenyzo.nev as "versenyzőnév", korido.korido as "köridő"
from korido 
/*azzal kezdünk, ahol mindegyik össze van kapcsolva egy foreign key-vel*/
inner join palya 
on korido.palyaido = palya.id
inner join versenyzo 
on korido.versenyzoid = versenyzo.id
where palya.orszag = "Olaszország" 
and korido.kor = 1;