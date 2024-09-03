create database teke character set utf8mb4 collate utf8mb4_general_ci;

/*
    de itt lehet használni a default-ot is, ugyanúgy amikor meg akarunk adni egy default értéket egy table, amikor csináljuk 

    CREATE DATABASE mydatabase
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_general_ci;

*/

use teke;

create table egyesuletek(
    id int,
    nev varchar(30) not null, 
    constraint pk_egyesuletek primary key (id)
);

create table versenyzok(
    rajtszam int,
    nev varchar(25) not null,
    egyid int not null,
    korcsop varchar(1) not null,
    constraint pk_versenyzok primary key (rajtszam),
    constraint fk_versenyzok foreign key (egyid) references egyesuletek(id)
);

create table eredmenyek(
    sorsz int,
    versenyzo int not null,
    teli int not null,
    tarolas int not null, 
    ures int not null,
    constraint pk_eredmenyek primary key (sorsz),
    constraint fk_eredmenyek foreign key (versenyzo) references versenyzok(rajtszam)
);

/*
    Listázza ki az A korcsoportban indulók névsorát ábécé rendben
*/

/*
    itt csak a nevet kell majd megjeleníteni és majd csak order by-olni kell majd a ugyanyúgy a nev szerint 
    de majd lesz egy kikötés, hogy az a korcsop, tehát egy where 
*/

select nev from versenyzok
where korcsop = "A" 
order by nev;

/*
    Listázza ki azon versenyzők rajtszámait, akiknek volt üres gurítása! Ha több üres gurítása
    volt valakinek, akkor is csak egyszer írja ki a rajtszámát!
*/

/*
    Ami itt nagyon fontos, hogy csak egyszer írja ki majd a nevet(versenyzo), itt kell a DISTINCT  
    és van egy olyan mező, hogy ures, aminek majd nagyobbnak kell lenni, mint nulla, mert az jelzi, hogy volt ures 
*/

select distinct versenyzo /*distinct-et mindig a mező elé rakjuk be, amit meg akarunk majd jeleníteni!!!*/
from eredmenyek 
where ures > 0;

/*
    Listázza ki minden versenyzőre az átlagos tarolási pontértékét! A versenyzők neve mellett
    a számított mező címkéje „atlagpont” legyen! A listát rendezze a számított mező szerint
    csökkenő rendbe!
*/

/*
    itt van egy tarolási érték, ami majd egy AVG() lesz és fontos, hogy ezt minden versenyzo-re, tehát majd a (rajtszam) szerint kell group by
    csőkkenő értékben kell majd ezt, tehát ami itt az AVG()-ben van a desc legyen 

    fontos, hogy két táblát majd össze kell kötni 
*/

select nev, AVG(tarolas) 
from versenyzok 
inner join eredmenyek 
on versenyzok.rajtszam = eredmenyek.versenyzo
group by versenyzok.rajtszam 
/*
    fontos, hogy általában id van ilyesmi szerint kell majd rendezni, mert itt is lehet, hogy van két olyan versenyzo, akinek a neve 
    ugyanaz, de viszont mindenkinek van egy külön rajtszama!!!! 
*/
order by AVG(tarolas) desc;

/*
    Listázza ki a legtöbb versenyzőt adó egyesület nevét!
*/

/*
    Ez majd egy count lesz, mert meg kell számolni valamit, pl. itt az id-t megszámoljuk és majd ha van count, akkor rendezni is kell 
    és összekötjük a versenyzok táblával és ott mindenkinek van egy ilyenje, hogy egyid 
*/

select egyesuletek.nev, count(egyesuletek.id) 
from egyesuletek
inner join versenyzok
on versenyzok.egyid = egyesuletek.id
group by egyesuletek.id
order by count(egyesuletek.id) desc
limit 1;

/*
    Listázza ki a B korcsoport egyéni eredményhirdető táblázatát! A mezők címkéi
    „nev”, „eredmeny”, „tarolas” és „ures” legyen! Az „eredmeny” mezőben a telitalálatok
    összesített pontjának és a tarolások összesített pontjának összegét kell megjeleníteni, míg a
    másik kettőben a névazonos mezők összesítését! A tornán a helyezéseket az alábbiak szerint
    kell eldönteni: összesített eredmények egyenlősége esetén a magasabb tarolási pontszám
    számít, ha pedig ezek is egyenlők, akkor a minél kevesebb üres gurítás! A listát rendezze
    úgy, hogy a legjobb eredményt elérő versenyző nevével kezdődjön!

    itt ami fontos, hogyha két mezőnek az értékeit kell majd összeszámolni, akkor egy sum()-ban összeadjuk azokat
    ->
    sum(teli + tarolas) as "eredmények"

    meg arra is jó példa, hogyha több dolgot figyelembe véve kell majd order by-olni!!! 
    itt nagyon fontos a sorrend
    ->
    order by sum(teli + tarolas) desc, tarolas desc, count(ures = 1)
*/

select nev, sum(teli + tarolas) as "eredmények", tarolas, count(ures = 1)
from eredmenyek
inner join versenyzok 
on versenyzok.rajtszam = eredmenyek.versenyzo 
where versenyzok.korcsop = "B"
group by versenyzok.rajtszam /*fontos, hogy egyedi valamiként kell group by-olni általában*/
order by sum(teli + tarolas) desc, tarolas desc, count(ures = 1);


