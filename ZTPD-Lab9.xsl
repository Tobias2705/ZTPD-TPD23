<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <!--Zad. 9-->
    <xsl:apply-templates select="SWIAT/KRAJE/KRAJ"/>

    <!--Zad. 11-->
    <xsl:apply-templates select="SWIAT/KRAJE/KRAJ[@KONTYNENT='k1']"/>

    <!--Zad. 12-->
    <xsl:apply-templates select="SWIAT/KRAJE/KRAJ[@KONTYNENT = /SWIAT/KONTYNENTY/KONTYNENT[NAZWA='Europe']/@ID]"/>

    <!--Zad. 15-->
    Liczba krajów:
    <xsl:value-of select="count(SWIAT/KRAJE/KRAJ[@KONTYNENT = /SWIAT/KONTYNENTY/KONTYNENT[NAZWA='Europe']/@ID])"/>

    <!--Zad. 17-->
    <td>
        <xsl:value-of select="position()"/>
    </td>

    <!--Zad. 21-->
    <xsl:sort select="NAZWA"/>

    <!--Zad. 27-->
    for $k in doc('file:///C:/Users/User/Desktop/Studia/Sem2-mgr/ZTPD/XML/XPath-XSLT/swiat.xml')/SWIAT/KRAJE/KRAJ
    return
    <KRAJ>
        {$k/NAZWA, $k/STOLICA}
    </KRAJ>

    <!--Zad. 28-->
    for $k in
    doc('file:///C:/Users/User/Desktop/Studia/Sem2-mgr/ZTPD/XML/XPath-XSLT/swiat.xml')/SWIAT/KRAJE/KRAJ[starts-with(NAZWA,
    'A')]
    return
    <KRAJ>
        {$k/NAZWA, $k/STOLICA}
    </KRAJ>

    <!--Zad. 29-->
    for $k in doc('file:///C:/Users/User/Desktop/Studia/Sem2-mgr/ZTPD/XML/XPath-XSLT/swiat.xml')/SWIAT/KRAJE/KRAJ
    where starts-with($k/STOLICA, substring($k/NAZWA, 1, 1))
    return
    <KRAJ>
        {$k/NAZWA, $k/STOLICA}
    </KRAJ>

    <!--Zad. 30-->
    xquery version "3.1";
    doc('file:///C:/Users/User/Desktop/Studia/Sem2-mgr/ZTPD/XML/XPath-XSLT/swiat.xml')//KRAJ

    <!--Zad. 32-->
    xquery version "3.1";
    for $nazwisko in doc('file:///C:/Users/User/Desktop/Studia/Sem2-mgr/ZTPD/XML/XPath-XSLT/zesp_prac.xml')//ROW/PRACOWNICY/ROW/NAZWISKO
    return $nazwisko

    <!--Zad. 33-->
    xquery version "3.1";
    let $nazwiska :=
        for $nazwisko in doc('file:///C:/Users/User/Desktop/Studia/Sem2-mgr/ZTPD/XML/XPath-XSLT/zesp_prac.xml')//ROW[NAZWA = 'SYSTEMY EKSPERCKIE']/PRACOWNICY/ROW/NAZWISKO
        return $nazwisko/text()
    return string-join($nazwiska, '&#10;')

    <!--Zad. 34-->
    xquery version "3.1";
    count(doc('file:///C:/Users/User/Desktop/Studia/Sem2-mgr/ZTPD/XML/XPath-XSLT/zesp_prac.xml')//ROW[ID_ZESP = '10']/PRACOWNICY/ROW)

    <!--Zad. 35-->
    xquery version "3.1";
    for $pracownik in doc('file:///C:/Users/User/Desktop/Studia/Sem2-mgr/ZTPD/XML/XPath-XSLT/zesp_prac.xml')//ROW[ID_SZEFA = '100']
    return $pracownik/NAZWISKO

    <!--Zad. 36-->
    xquery version "3.1";
    let $zespolId := doc('file:///C:/Users/User/Desktop/Studia/Sem2-mgr/ZTPD/XML/XPath-XSLT/zesp_prac.xml')//ROW[NAZWISKO = 'BRZEZINSKI']/ID_ZESP

    return sum(
        for $pracownik in doc('file:///C:/Users/User/Desktop/Studia/Sem2-mgr/ZTPD/XML/XPath-XSLT/zesp_prac.xml')//ROW[ID_ZESP = $zespolId]
        return $pracownik/PLACA_POD
    )
</xsl:stylesheet>
