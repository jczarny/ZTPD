
-- 1.
create or replace type samochod AS OBJECT (
    marka varchar2(20),
    model varchar2(20),
    kilometry number,
    data_produkcji date,
    cena number(10,2)
)

create table samochody of samochod;

insert into samochody values (new samochod('Fiat', 'Brava', 60000, to_date('30-11-1999','DD-MM-YYYY'), 25000));
insert into samochody values (new samochod('Ford', 'Mondeo', 80000, to_date('10-05-1997','DD-MM-YYYY'), 45000));
insert into samochody values (new samochod('Mazda', '323', 12000, to_date('22-09-2000','DD-MM-YYYY'), 52000));

-- 2.
create table wlasciciele (
    imie varchar2(20),
    nazwisko varchar2(20),
    auto samochod  
);

insert into wlasciciele values ('Jan', 'Kowalski', new Samochod('Fiat', 'Seicento', 30000, to_date('02-12-0010', 'DD-MM-YYYY'), 19500));
insert into wlasciciele values ('Adam', 'Nowak', new Samochod('Opel', 'Astra', 34000, to_date('01-06-0009', 'DD-MM-YYYY'), 33700));

-- 3.
ALTER TYPE Samochod REPLACE AS OBJECT (
    marka varchar2(20),
    model varchar2(20),
    kilometry number,
    data_produkcji date,
    cena number(10,2),
    MEMBER FUNCTION wartosc RETURN NUMBER
);

create or replace type body samochod as
    MEMBER FUNCTION wartosc RETURN NUMBER IS
    BEGIN
        RETURN cena * POWER(0,9, EXTRACT (YEAR FROM CURRENT_DATE) - EXTRACT (YEAR FROM data_produkcji));
    END wartosc;
END;

create or replace type body samochod as
    MEMBER FUNCTION wartosc RETURN NUMBER IS
    BEGIN
        RETURN round(cena * POWER(0.9, EXTRACT (YEAR FROM CURRENT_DATE) - EXTRACT (YEAR FROM data_produkcji)));
    END wartosc;
    MEMBER FUNCTION wiek RETURN NUMBER IS
    BEGIN
        RETURN 1;
    END wiek;
END;

-- 4.
ALTER TYPE Samochod ADD MAP MEMBER FUNCTION odwzoruj
RETURN NUMBER CASCADE INCLUDING TABLE DATA;

CREATE OR REPLACE TYPE BODY Samochod AS
    MEMBER FUNCTION wartosc RETURN NUMBER IS
    BEGIN
        RETURN round(cena * POWER(0.9, EXTRACT (YEAR FROM CURRENT_DATE) - EXTRACT (YEAR FROM data_produkcji)));
    END wartosc;
    MEMBER FUNCTION wiek RETURN NUMBER IS
    BEGIN
        RETURN 1;
    END wiek;
MAP MEMBER FUNCTION odwzoruj RETURN NUMBER IS
BEGIN
RETURN EXTRACT (YEAR FROM CURRENT_DATE) - EXTRACT (YEAR FROM data_produkcji) + ROUND(kilometry);
END odwzoruj;
END;

-- 5.
create or replace type Wlasciciel AS OBJECT (
    imie varchar2(20),
    nazwisko varchar2(20)
);

ALTER TYPE Samochod ADD ATTRIBUTE s_wlasciciel REF Wlasciciel CASCADE;
CREATE TABLE wlascicieleObj OF Wlasciciel;
insert into wlascicieleObj values (new Wlasciciel('Jakub', 'Czarnecki'));
insert into wlascicieleObj values (new Wlasciciel('Jan', 'Kowalski'));
insert into wlascicieleObj values (new Wlasciciel('Krzysztof', 'Kolumb'));

update samochody set s_wlasciciel = ( SELECT REF(w) FROM wlascicieleObj w WHERE w.imie = 'Jakub' ) where marka='Fiat';
update samochody set s_wlasciciel = ( SELECT REF(w) FROM wlascicieleObj w WHERE w.imie = 'Jan' ) where marka='Mazda';
update samochody set s_wlasciciel = ( SELECT REF(w) FROM wlascicieleObj w WHERE w.imie = 'Krzysztof' ) where marka='Ford';

-- 6. Przekopiowanie kodu

-- 7.
DECLARE
    TYPE t_ksiazki IS VARRAY(100) OF VARCHAR2(20);
    moje_ksiazki t_ksiazki := t_ksiazki('KSIAZKA_1');
    BEGIN
    moje_ksiazki.EXTEND(19);
    FOR i IN 2..20 LOOP
    moje_ksiazki(i) := 'KSIAZKA_' || i;
    END LOOP;
    moje_ksiazki.trim(1);
    moje_ksiazki.trim(2);
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_ksiazki.COUNT());
    moje_ksiazki(5) := 'KSIAZKA_100';
    moje_ksiazki.EXTEND(10);
    FOR i IN 1..moje_ksiazki.COUNT() LOOP
        DBMS_OUTPUT.PUT_LINE(moje_ksiazki(i));
    END LOOP;
END;


-- 8. Przekopiowanie kodu
-- 9.
DECLARE
	TYPE t_miesiace IS TABLE OF VARCHAR2(20);
	miesiace t_miesiace := t_miesiace();
BEGIN
	miesiace.EXTEND(12);
	miesiace(1) := 'STYCZEŃ'; miesiace(2) := 'LUTY'; miesiace(3) := 'MARZEC';
	miesiace(4) := 'KWIECIEŃ'; miesiace(5) := 'MAJ'; miesiace(6) := 'CZERWIEC';
	miesiace(7) := 'LIPIEC'; miesiace(8) := 'SIERPIEŃ'; miesiace(9) := 'WRZESIEŃ';
	miesiace(10) := 'PAŹDZIERNIK'; miesiace(11) := 'LISTOPAD'; miesiace(12) := 'GRUDZIEŃ';

	miesiace.DELETE(2,3);
	miesiace.TRIM(1);
	FOR i IN miesiace.FIRST()..miesiace.LAST() LOOP
		IF miesiace.EXISTS(i) THEN
		DBMS_OUTPUT.PUT_LINE(miesiace(i));
		END IF;
	END LOOP;
	DBMS_OUTPUT.PUT_LINE('Limit: ' || miesiace.LIMIT());
	DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || miesiace.COUNT());
END;

-- 10. Przekopiowanie kodu
-- 11.
CREATE TYPE produkty AS TABLE OF VARCHAR2(20);
CREATE TYPE zakup AS OBJECT (
    numer NUMBER,
    koszyk_produktow produkty
);

CREATE TABLE zakupy OF zakup NESTED TABLE koszyk_produktow STORE AS tab_koszyk_produktow;
INSERT INTO zakupy VALUES(zakup(1, produkty('CHLEB', 'CZEKOALDA', 'OSHEE')));
INSERT INTO zakupy VALUES(zakup(2, produkty('POMIDORY', 'PIZZA', 'PIWO')));
INSERT INTO zakupy VALUES(zakup(3, produkty('WODA', 'PIWO', 'KAJZERKA')));

SELECT z.numer, kp.* FROM zakupy z, TABLE (z.koszyk_produktow) kp;
DELETE FROM zakupy WHERE numer IN (SELECT DISTINCT(z.numer) FROM zakupy z, TABLE(z.koszyk_produktow) kp where kp.column_value = 'PIWO');
SELECT z.numer, kp.* FROM zakupy z, TABLE (z.koszyk_produktow) kp;

-- 12. Przekopiowanie kodu 