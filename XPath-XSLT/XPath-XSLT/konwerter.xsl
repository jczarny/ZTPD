<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:template match="/">
        <PRACOWNICY>
            <xsl:apply-templates select="//PRACOWNICY/ROW">
                <xsl:sort select="ID_PRAC" data-type="number"/>
            </xsl:apply-templates>
        </PRACOWNICY>
    </xsl:template>
    <xsl:template match="ROW">
        <PRACOWNIK>
            <xsl:attribute name="ID_PRAC">
                <xsl:value-of select="ID_PRAC"/>
            </xsl:attribute>
            <xsl:attribute name="ID_ZESP">
                <xsl:value-of select="ID_ZESP"/>
            </xsl:attribute>
            <xsl:attribute name="ID_SZEFA">
                <xsl:variable name="szef_id" select="ID_SZEFA"/>
                <xsl:choose>
                    <xsl:when test="/ZESPOLY/ROW/PRACOWNICY/ROW[ID_PRAC = $szef_id]/ID_SZEFA">
                        <xsl:value-of select="/ZESPOLY/ROW/PRACOWNICY/ROW[ID_PRAC = $szef_id]/ID_SZEFA"/>
                    </xsl:when>
                    <xsl:otherwise>Brak</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:copy-of select="NAZWISKO | ETAT | ZATRUDNIONY | PLACA_POD | PLACA_DOD"/>
        </PRACOWNIK>
    </xsl:template>

</xsl:stylesheet>