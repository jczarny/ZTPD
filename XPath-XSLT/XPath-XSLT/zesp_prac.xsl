<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:template match="/">
        <html>
            <body>
                <h1>ZESPOŁY:</h1>

                <ol>
                    <xsl:apply-templates select="/ZESPOLY/ROW" mode="zad_6"/>
                </ol>

                <xsl:apply-templates select="/ZESPOLY/ROW" mode="zad_7_8"/>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="ROW" mode="zad_6">
        <li>
            <a href="#{ID_ZESP}">
                <xsl:value-of select="NAZWA"/>
            </a>
        </li>
    </xsl:template>
    <xsl:template match="ROW" mode="zad_7_8">
        <b>
            NAZWA: <xsl:value-of select="NAZWA"/>
            <br/>
            ADRES: <xsl:value-of select="ADRES"/>
        </b>
        <br/>
        <xsl:choose>
            <xsl:when test="count(PRACOWNICY/ROW) > 0">
                <table>
                    <tr>
                        <th>Nazwisko</th>
                        <th>Etat</th>
                        <th>Zatrudniony</th>
                        <th>Placa pod.</th>
                        <th>Szef</th>
                    </tr>
                    <xsl:apply-templates select="PRACOWNICY/ROW" mode="lista_pracownikow">
                        <xsl:sort select="NAZWISKO"/>
                    </xsl:apply-templates>
                </table>
            </xsl:when>
        </xsl:choose>
        Liczba pracowników: <xsl:value-of select="count(PRACOWNICY/ROW)"/>
        <br/><br/>
    </xsl:template>
    <xsl:template match="ROW" mode="lista_pracownikow">
        <tr>
            <td><xsl:value-of select="NAZWISKO"/></td>
            <td><xsl:value-of select="ETAT"/></td>
            <td><xsl:value-of select="ZATRUDNIONY"/></td>
            <td><xsl:value-of select="PLACA_POD"/></td>
            <td>
                <xsl:variable name="szef_id" select="ID_SZEFA"/>
                <xsl:choose>
                    <xsl:when test="/ZESPOLY/ROW/PRACOWNICY/ROW[ID_PRAC = $szef_id]/NAZWISKO">
                        <xsl:value-of select="/ZESPOLY/ROW/PRACOWNICY/ROW[ID_PRAC = $szef_id]/NAZWISKO"/>
                    </xsl:when>
                    <xsl:otherwise>Brak</xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
    </xsl:template>
</xsl:stylesheet>