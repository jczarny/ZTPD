(:
5.
doc("db/bib/bib.xml")//author/last

6.
for $i in doc("db/bib/bib.xml")//book
return 
<ksiazka>
  {$i/author}
  {$i/title}
</ksiazka>

7.
for $i in doc("db/bib/bib.xml")//book
return 
<ksiazka>
  <autor>{concat($i/author/first, $i/author/last)}</autor>
  <tytul>{$i/title/text()}</tytul>
</ksiazka>

8.
for $i in doc("db/bib/bib.xml")//book
return 
<ksiazka>
  <autor>{concat($i/author/first, ' ', $i/author/last)}</autor>
  <tytul>{$i/title/text()}</tytul>
</ksiazka>

9.
<wynik>
{
  for $i in doc("db/bib/bib.xml")//book
return
<ksiazka>
  <autor>{concat($i/author/first, ' ', $i/author/last)}</autor>
  <tytul>{$i/title/text()}</tytul>
</ksiazka>
}
</wynik>

10.
<imiona>
{
for $i in doc("db/bib/bib.xml")//book[title='Data on the Web']//author
return
<imie>{$i/first/text()}</imie>
}
</imiona>

11.
<DataOnTheWeb>
{doc("db/bib/bib.xml")//book[title = "Data on the Web"]}
</DataOnTheWeb>

<DataOnTheWeb>
{
  for $book in doc("db/bib/bib.xml")//book
  where $book/title = "Data on the Web"
  return $book
}
</DataOnTheWeb>

12.
<Data>
{
  for $author in doc("db/bib/bib.xml")//book[contains(title, 'Data')]//author
  return <nazwisko>
    {$author/last/text()}
  </nazwisko>
}
</Data>

13.
for $book in doc("db/bib/bib.xml")//book
where contains($book/title, 'Data')
  return
    <Data>
      <tytul>{ $book/title/text() }</tytul>
      {
        for $author in $book//author
        return
          <nazwisko>{$author/last/text()}</nazwisko>
      }
     </Data>
     
14.
for $book in doc("db/bib/bib.xml")//book
where count($book//author) <= 2
  return
    $book/title
    
15.
for $book in doc("db/bib/bib.xml")//book
  return
    <ksiazka>
      {$book/title}
      <autorow>{count($book//author)}</autorow>
    </ksiazka>
    
16.
for $books in doc("db/bib/bib.xml")/bib
let $min := min($books/book/@year)
let $max := max($books/book/@year)
return <przedzial>
  {concat($min, ' - ', $max)}
</przedzial>

17.
for $books in doc("db/bib/bib.xml")/bib
let $min := min($books/book/price)
let $max := max($books/book/price)
return <roznica>
  {$max - $min}
</roznica>

18.
<najtańsze>
{
    let $minPrice := min(doc("db/bib/bib.xml")//book/price)
    for $book in doc("db/bib/bib.xml")//book
    where $book/price = $minPrice
    return 
        <najtańsza>
            <title>{$book/title}</title>
            {for $author in $book/author return $author}
        </najtańsza>
}
</najtańsze>

19.
let $authorsLast := distinct-values(doc("db/bib/bib.xml")//book/author/last)

for $i in $authorsLast
return 
<autor>
  <last>{$i}</last>
  {
    for $book in doc("db/bib/bib.xml")//book
    where $book/author/last = $i
    return $book/title
  }
</autor>

20.
<wynik>{
    for $play in collection("db/shakespeare")//PLAY
    return $play/TITLE
}</wynik>

21.
for $play in collection("db/shakespeare")//PLAY
where some $l in $play//LINE satisfies contains($l, "or not to be")
return $play/TITLE

22.
<wynik>
{
  for $play in collection("db/shakespeare")//PLAY
  return 
  <sztuka tytul="{$play/TITLE}">
    <postaci>{count($play//PERSONA)}</postaci>
    <aktow>{count($play//ACT)}</aktow>
    <scen>{count($play//SCENE)}</scen>
  </sztuka>
}
</wynik>
:)

<wynik>
{
  for $play in collection("db/shakespeare")//PLAY
  return 
  <sztuka tytul="{$play/TITLE}">
    <postaci>{count($play//PERSONA)}</postaci>
    <aktow>{count($play//ACT)}</aktow>
    <scen>{count($play//SCENE)}</scen>
  </sztuka>
}
</wynik>