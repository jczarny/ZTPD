(:
26.
for $k in doc('file:///C:/Users/.../Downloads/XPath-XSLT/XPath-XSLT/swiat.xml')/SWIAT/KONTYNENTY/KONTYNENT
return <KRAJ>
 {$k/NAZWA, $k/STOLICA}
</KRAJ>

27.
for $k in doc('file:///C:/Users/.../Downloads/XPath-XSLT/XPath-XSLT/swiat.xml')/SWIAT/KRAJE/KRAJ
return <KRAJ>
 {$k/NAZWA, $k/STOLICA}
</KRAJ>

28.
for $k in doc('file:///C:/Users/.../Downloads/XPath-XSLT/XPath-XSLT/swiat.xml')/SWIAT/KRAJE/KRAJ[starts-with(NAZWA, 'A')]
return <KRAJ>
  {$k/NAZWA, $k/STOLICA}
</KRAJ>

29.
for $k in doc('file:///C:/Users/.../Downloads/XPath-XSLT/XPath-XSLT/swiat.xml')/SWIAT/KRAJE/KRAJ
  [substring(NAZWA, 1, 1) = substring(STOLICA, 1, 1)]
return <KRAJ>
  {$k/NAZWA, $k/STOLICA}
</KRAJ>

30.
doc('file:///C:/Users/.../Downloads/XPath-XSLT/XPath-XSLT/zesp_prac.xml')//KRAJ

31.
doc('file:///C:/Users/.../Downloads/XPath-XSLT/XPath-XSLT/zesp_prac.xml')

32.
for $k in doc('file:///C:/Users/.../Downloads/XPath-XSLT/XPath-XSLT/zesp_prac.xml')
return $k//ROW/NAZWISKO

33.
for $k in doc('file:///C:/Users/.../Downloads/XPath-XSLT/XPath-XSLT/zesp_prac.xml')//ROW[NAZWA = 'SYSTEMY EKSPERCKIE']
return $k//ROW/NAZWISKO

34.
count(doc('file:///C:/Users/.../Downloads/XPath-XSLT/XPath-XSLT/zesp_prac.xml')//ROW[ID_ZESP=10]/PRACOWNICY/ROW)

35.
doc('file:///C:/Users/.../Downloads/XPath-XSLT/XPath-XSLT/zesp_prac.xml')//ROW/PRACOWNICY//ROW[ID_SZEFA=100]/NAZWISKO

36.
sum(for $a in doc('file:///C:/Users/.../Downloads/XPath-XSLT/XPath-XSLT/zesp_prac.xml')//ROW/PRACOWNICY
where some $b in $a satisfies ($a/ROW/NAZWISKO = 'BRZEZINSKI')
return $a/ROW/PLACA_POD)
:)