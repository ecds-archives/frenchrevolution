<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:tei="http://www.tei-c.org/ns/1.0"
                version="1.0">

  <xsl:output method="xml" omit-xml-declaration="yes"/>

  <xsl:param name="keyword"/>

  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="tei:TEI">
    <p>
      <a>
        <xsl:attribute name="href">view.php?doc=<xsl:value-of select="tei:docname"/>&amp;kw=<xsl:value-of select="$keyword"/></xsl:attribute>
        <xsl:apply-templates select="tei:titleStmt/tei:author"/> 
        <xsl:apply-templates select="tei:titleStmt/tei:title"/>
      </a>
      <br/>
      <xsl:apply-templates select="hits"/> match<xsl:if test="hits > 1">es</xsl:if>
    </p>
  </xsl:template>

  <xsl:template match="tei:author">
    <xsl:if test=". != ''">
      <xsl:apply-templates/>,      
    </xsl:if>
  </xsl:template>

  <xsl:template match="tei:title">
    <xsl:value-of select="substring-before(., ': electronic edition')"/>.
  </xsl:template>

</xsl:stylesheet>
