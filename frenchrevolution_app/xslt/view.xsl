<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:exist="http://exist.sourceforge.net/NS/exist"
  exclude-result-prefixes="exist" 
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  version="1.0">

  <xsl:import href="tei.xsl"/>

  <xsl:output method="html"/>


  <xsl:template match="/">
    <div>
    <xsl:apply-templates/>
    </div>
  </xsl:template>

  <!-- from Michael Kazanjian's styling for pat -->

  <xsl:template match="tei:div1|tei:div2|tei:div3"> 
    <div>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="tei:head|tei:title|tei:titlePart|tei:author|tei:byline|tei:docAuthor|tei:figure|tei:stanza|tei:epigraph|tei:prologue|tei:epilogue">
    <p><xsl:apply-templates/></p>
  </xsl:template>

  <xsl:template match="tei:date|tei:pubPlace|tei:publisher|tei:docImprint|tei:docTitle">
    <br/>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="tei:bibl">
    <p>
      <xsl:apply-templates/>
    </p>
    <hr/>
  </xsl:template>

  <xsl:template match="tei:figDesc|tei:argument|tei:hi">
    <i><xsl:apply-templates/></i>
  </xsl:template>

  <xsl:template match="tei:pb">
    <div class="pagebreak">
      <span class="page">Page <xsl:value-of select="@n"/></span>
      <hr/>
    </div>
  </xsl:template>

  <xsl:template match="tei:note">
    <hr/>
    <p>Note: <xsl:apply-templates/></p>
    <hr/>
  </xsl:template>

<xsl:template match="exist:match">
    <span class="match"><xsl:apply-templates/></span>
  </xsl:template>

<!-- highlight matches in text -->
<xsl:template match="exist:match">
  <span class="exist-match">
    <xsl:apply-templates/>
  </span>
</xsl:template>

</xsl:stylesheet>
