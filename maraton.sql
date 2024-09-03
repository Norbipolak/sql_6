create database maratonvalto set character utf8mb4 collate utf8mb4_general_ci;

use maratonvalto;

/*
    ami nagyon fontos, hogy amikor itt csináljuk a table-eket, akkor csak beleírjuk majd, hogy milyen mezők lesznek benne és azoknak a 
    fajtáit, hogy int, varchar, bit stb. meg itt adjuk meg, hogy melyik lesz majd a primary key meg a foreign key 

    és majd ha ezeknek a mezőknek értékeket akarunk adni akkor kell az insert és ott kell majd prop-ként felsorolni a mezőket egy zárójelben 
    és majd lesz egy olyan, hogy values(), ott meg megadjuk nekik az értékeit 
*/

create table futok (
    fid int primary key auto_increment, 
    fnev varchar(100) not null, 
    szulev int not null, 
    szulho int not null, 
    csapat int not null, 
    ffi bit not null
    /*
        lehet még úgy is, hogy ide adjuk meg a fid-t mint primary key és akkor kell a constraint 
        ->
        constraint pk_futok primary key (fid)
    */
);

    /*
        lehet még úgy is, hogy ide adjuk meg a fid-t mint primary key és akkor kell a constraint 
        ->
        constraint pk_futok primary key (fid)
    */

/*
    ffi bit not null
    Ha ilyen logikai van pl. itt az ffi a nem-re fog ultani és ez olyan értékeket kaphat majd, hogy 0 vagy 1 és itt kell majd a BIT!!!! 
*/

create table eredmenyek (
    futo int, 
    kor int not null,
    ido int not null
    constraint pk_eredmenyek primary key (futo, kor)
    constraint fk_eredmenyek foreign key (futo) references futok(id);
);

/*
    Ezzel a constrant-es megoldással is meg lehet adni majd a foreign meg a primary key-t is 
    fontos, hogy a constraint után kell, hogy melyik tábla meg a foreign key vagy a primary key-nek is a rövidítése 
    pk -> primary key 
    fk -> foreign key 
    tehát eddig constraint fk_eredmenyek 
    ezután meg kell adni, hogy melyik mező lesz a foreign key, úgy hogy foreign key és utána írjuk a mező nevét egy zárójelben 
    -> foreign key (futo) 
    ezután meg a references-vel csatoljuk hozzá a primary key-t, annak a formája pedig, hogy melyik table-ből van és egy zárójelben a mező neve
    -> references futok(id)

    az egész 
    constraint fk_eredmenyek foreign key (futo) references futok(id)
*/

/*
    3. feladat
    Tóth Antal (1044-es rajtszámmal) 4. körös eredménye kimaradt a nyilvántartásból, pedig
    sikeresen teljesítette a távot. Rögzítse az eredmenyek táblában a futó 15 765 másodperces
    köridejét! 

    kimaradt, tehét ez majd egy INSERT lesz és az eredmények táblába kell majd bevinni
    kell egy futo, ami össze van kapcsolva a futok tábla id-jével és ezt majd onnan tudjuk megkapni egy allekérdezéssel, mert az tudjuk, hogy 
    a futo neve mi, ami megint csak a futok táblán van meg és ha tudjuk, hogy mi a neve, akkor tudjuk, hogy mi az id-ja is és majd ez lesz itt 
    az eredmeny táblán a futo, mert ezt kötöttük össze  
    kor-t meg az ido-t meg csak megadjuk a számokat, amik itt vannak 
*/

insert into eredmenyek(futo, kor, ido) 
values(
    (select fid from futok where nev = "Tóth Antal"),
    4,
    15765
);

/*
    Listázza ki a női futók nevét és születési évét! A névmező címkéje „futo” legyen! A listát
    rendezze név szerint ábécé rendbe! (4. feladat:) 

    Tehát amit meg kell majd jeleníteni az a fnev és a szulev és aszerint, hogy futo nö legyen, tehát az ffi az nulla 
    ezt mind meg tudjuk csinálni egy táblából, ahol majd kell egy where aminek megadjuk a kikötést 
    és majd nev szerint kell az order by, de itt nem kell majd asc-et írni mert az az alapvetően megadott 
*/

select fnev, szulev from futok
where ffi = 0
order by fnev;

/*
    Listázza ki a 42 éves vagy ennél idősebb futók nevét és korát! A névmező címkéje „futo”,
    a számított mező címkéje „kor” legyen! Az életkorszámítás során a verseny 2016-os
    évszámával számoljon! A listát rendezze az életkor (év és azon belül hónap) szerint
    csökkenő rendbe! 

    Hogyan tudjuk, hogy valaki már betöltötte a 42-t, hogy a szulev-et meg a szulho kivonjuk 2016-ból 
    itt kell majd timestampdiff, amit majd year-ben adunk meg emellett kell ennek majd két paraméter és mindig a kisebb szám a második 
    paraméter a harmadik paraméter pedig a nagyobb, tehátt itt a szulev, szulho lesz majd a második a 2016 pedig a harmadik 

    makedate függvény meg vár egy hónapot meg egy évet 
    makedate(szulev, szulho)

    mit csinál a makedate egy int-ből, mint itt is a szulev meg a szulho csinál majd egy date-t ->
    pl. ha valaki 1992 a szulev a szulho meg 12, akkor csinál egy ilyen date-t, hogy 1992-12-01, csak jelen esetben itt nem volt megadva nap

    de lehet így is csinálni, hogy megadunk egy évet meg egy napot -> 
    SELECT MAKEDATE(2024, 60);
    és ebből csinál majd egy ilyet, hogy 2024-02-29, tehát ez a 60-dik napja az évnek
*/

select fnev as "futo", timestampdiff(year, makedate(szulev, szulho), makedate(2016, 1) as "kor") 
from futok 
/*itt jön majd a kikőtés, hogy ez nagyobb vagy egyenlő, mint 42*/
where timestampdiff(year, makedate(szulev, szulho), makedate(2016, 1)) >= 42
order by szulev, szulho;

/*
    és ami nagyon fontos, hogyha több dolgot adunk meg az order by-nak akkor legelöször szulev-nek megfelelően fog majd rendezni 
    de ha szulev megegyezik, akkor meg a szulho szerint és mindegyik itt alapból asc, tehát azt veszi, aki 43 mondjuk és ha van több
    ilyen, akkor az lesz az első aki januárban, tehát 1-ben születtet utána meg aki februárban 2-ben és így tovább 
*/

/*
    Listázza ki a 10 legjobb köridőt futó férfi nevét és köridejét! A név mező címkéje „futo”
    legyen! (Feltételezheti, hogy nem volt holtverseny a futók között.) (6. feladat:) 

    ezt majd két listáról kell majd megszerezni, mert a korido az az eredmenyek táblán van a név meg a futokon 
    úgy kapjuk meg a leggyorsabb köröket, hogy majd azokat order by-oljuk és mivel a leggyorsdabb az a legkisebb idő ezért nem is kell majd 
    semmit oda írni, mert ugy alapból asc 
    és itt kell majd a limit 10, tehát a 10-et szeretnénk majd megjeleníteni 
    kell még egy where ahol majd megadjuk, hogy a futo az férfi, tehát az ffi az 1 legyen 
*/

select fnev as "futó", ido
from futok 
inner join eredmenyek
on eredmenyek.futo = futok.id 
where ffi = 1 
order by ido 
limit 10;

/*
    Listázza ki csapatonként a csapattagok összesített köridejét! A mezők címkéi „csapat” és
    „csapatido” legyen! A listát rendezze úgy, hogy a leggyorsabb csapattal kezdődjön! 
*/

/*
    csapattagok összes körideje, tehát az kor-t kell majd sum-olni és fontos, hogy csapat-onkét, tehát az lesz majd az order by 
    és még lesz egy olyan is a leggyorsabbal kezdje, tehát order by és itt az lesz, hogy ami a sum-os 
    de majd össze kell kapcsolni a két táblát is 
*/

select csapat as "csapat", sum(ido) as "csapatidő" 
from eredmenyek 
inner join futok 
on futok.id = eredmenyek.futo
group by csapat 
order by sum(ido);