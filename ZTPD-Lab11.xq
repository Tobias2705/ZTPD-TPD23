(: Zad.5 :)
for $book in doc("db/bib/bib.xml")//book
for $author in $book/author
return $author/last

(: Zad.6 :)
for $book in doc("db/bib/bib.xml")//book
for $title in $book/title
for $author in $book/author
return 
  <książka>
    <author>
      {$author/last}
      {$author/first}
    </author>
    {$title}
  </książka>

(: Zad.7 :)
for $book in doc("db/bib/bib.xml")//book
for $title in $book/title
for $author in $book/author
return 
  <książka>
    <autor>{$author/last/text()}{$author/first/text()}</autor>
    <tytul>{$title/text()}</tytul>
  </książka>

(: Zad.8 :)
for $book in doc("db/bib/bib.xml")//book
for $title in $book/title
for $author in $book/author
return 
  <książka>
    <autor>{concat($author/last, " ", $author/first)}</autor>
    <tytul>{$title/text()}</tytul>
  </książka>

(: Zad.9 :)
<wynik>{
  for $book in doc("db/bib/bib.xml")//book
  for $title in $book/title
  for $author in $book/author
  return 
    <książka>
      <autor>{concat($author/last, " ", $author/first)}</autor>
      <tytul>{$title/text()}</tytul>
    </książka>
}</wynik>

(: Zad.10 :)
<imiona>{
  for $book in doc("db/bib/bib.xml")//book
  where $book/title = "Data on the Web"
  for $author in $book/author
  return <imie>{$author/first/text()}</imie>
}</imiona>

(: Zad.11 :)
<DataOnTheWeb>{
  doc("db/bib/bib.xml")//book[title = "Data on the Web"]
}</DataOnTheWeb>

<DataOnTheWeb>{
  for $book in doc("db/bib/bib.xml")//book
  where $book/title = "Data on the Web"
  return $book
}</DataOnTheWeb>

(: Zad.12 :)
<Data>{
  for $book in doc("db/bib/bib.xml")//book
  where contains($book/title, "Data")
  for $author in $book/author
  return <nazwisko>{$author/last/text()}</nazwisko>
}</Data>

(: Zad.13 :)
<Data>{
  for $book in doc("db/bib/bib.xml")//book
  where contains($book/title, "Data")
  return (
    $book/title,
    for $author in $book/author
    return <nazwisko>{$author/last/text()}</nazwisko>
  )
}</Data>

(: Zad.14 :)
for $book in doc("db/bib/bib.xml")//book
where count($book/author) <= 2
return $book/title

(: Zad.15 :)
for $book in doc("db/bib/bib.xml")//book
return 
  <ksiazka>
    {$book/title}
    <autorow>{count($book/author)}</autorow>
  </ksiazka>

(: Zad.16 :)
let $years := doc("db/bib/bib.xml")//book/@year
return
  <przedział>{min($years)} - {max($years)}</przedział>

(: Zad.17 :)
let $prices := doc("db/bib/bib.xml")//book/price
return
  <różnica>{max($prices) - min($prices)}</różnica>

(: Zad.18 :)
let $minPrice := min(doc("db/bib/bib.xml")//book/price)
return
  <najtańsze>{
    for $book in doc("db/bib/bib.xml")//book
    where $book/price = $minPrice
    return 
      <najtańsza>
        {$book/title},
        {
          for $author in $book/author
          return 
            <author>
              {$author/last}
              {$author/first}
            </author>
        }
      </najtańsza>
  }</najtańsze>

(: Zad.19 :)
for $author in distinct-values(doc("db/bib/bib.xml")//author/last/text())
return 
  <autor>{
    <last>{$author}</last>,
    for $book in doc("db/bib/bib.xml")//book[author/last = $author]
    return $book/title
  }</autor>

(: Zad.20 :)
<wynik>{
  for $play in collection("db/shakespeare")//PLAY
  return $play/TITLE
}</wynik>

(: Zad.21 :)
for $play in collection("db/shakespeare")//PLAY
where some $line in $play//LINE satisfies contains($line, "or not to be")
return $play/TITLE

(: Zad.22 :)

<wynik>{
  for $play in collection("db/shakespeare")//PLAY
  let $title := $play/TITLE/text()
  let $characters := count($play//PERSONA)
  let $acts := count($play//ACT)
  let $scenes := count($play//SCENE)
  return 
    <sztuka tytul="{$title}">
      <postaci>{$characters}</postaci>
      <aktow>{$acts}</aktow>
      <scen>{$scenes}</scen>
    </sztuka>
}</wynik>
