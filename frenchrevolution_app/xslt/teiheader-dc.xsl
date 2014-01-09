<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:dc="http://purl.org/dc/elements/1.1/"
		xmlns:dcterms="http://purl.org/dc/terms"
		xmlns:tei="http://www.tei-c.org/ns/1.0"
                version="1.0">

  <xsl:output method="xml" omit-xml-declaration="yes"/>

  <xsl:param name="qualified">true</xsl:param>

  <!-- specific to French Revolution Pamphlets : Michael Kazanjian's name should show up -->
  <xsl:template match="tei:titleStmt/tei:respStmt">
    <xsl:element name="dc:contributor">
      <xsl:value-of select="tei:resp"/><xsl:text> </xsl:text><xsl:value-of select="tei:name"/> 
    </xsl:element>
  </xsl:template>


  <xsl:template match="/">
    <dc>
      <!--      <xsl:apply-templates select="//tei:bibl"/> -->
      <xsl:apply-templates select="//tei:teiHeader"/>

      <xsl:call-template name="common-fields"/>
    </dc>
  </xsl:template>

  <!-- static fields for all records-->
  <xsl:template name="common-fields">
    <dc:language>French</dc:language>
    <dc:subject>
      <xsl:if test="$qualified='true'">
        <xsl:attribute name="scheme">LSCH</xsl:attribute>
      </xsl:if>
      <xsl:text>France--History--Revolution, 1789-1799--Pamphlets.</xsl:text>
    </dc:subject>
    <dc:subject>
      <xsl:if test="$qualified = 'true'">
        <xsl:attribute name="scheme">LSCH</xsl:attribute>
      </xsl:if>
      <xsl:text>France--Politics and government--1789-1799.</xsl:text>
    </dc:subject>
    <dc:type>Text</dc:type>
    <dc:format>text/xml</dc:format>
  </xsl:template>

  <xsl:template match="tei:titleStmt/tei:title">
    <xsl:element name="dc:title">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tei:titleStmt/tei:author">
    <xsl:element name="dc:creator">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tei:editor">
    <xsl:element name="dc:contributor">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <!-- publisher -->
  <xsl:template match="tei:publicationStmt">
    <xsl:element name="dc:publisher">  <xsl:value-of select="tei:publisher"/>, <xsl:value-of
    select="tei:pubPlace"/>. <xsl:value-of select="tei:date"/>: <xsl:value-of 
    select="tei:address/tei:addrLine"/>.</xsl:element> 
    <!-- pick up rights statement --> 
    <xsl:apply-templates/>
  </xsl:template> 

  <!-- ignore here: explicitly included above -->
  <xsl:template match="tei:publicationStmt/tei:publisher"/>

  <!-- FIXME: is date of electronic edition interesting/relevant? -->
  <xsl:template match="tei:publicationStmt/tei:date">
    <xsl:choose>
      <xsl:when test="$qualified = 'true'">
        <xsl:element name="dcterms:issued">
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="dc:date">
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--  <xsl:template match="publisher[not(parent::imprint)]">
    <xsl:element name="dc:publisher">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>  -->


  <!-- ignore source publisher & date for now; include in dc:source -->
  <xsl:template match="tei:imprint/tei:publisher"/>
  <xsl:template match="tei:bibl/tei:date"/>
  
  <xsl:template match="tei:date">
    <xsl:element name="dc:date">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tei:publicationStmt/tei:idno[@type='ark']">
    <xsl:element name="dc:identifier">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>


  <!-- ignore for now; do these fit anywhere? -->
  <xsl:template match="tei:publicationStmt/tei:address"/>
  <xsl:template match="tei:publicationStmt/tei:pubPlace|tei:imprint/tei:pubPlace|tei:pubPlace"/>
  <xsl:template match="tei:respStmt"/>

  <xsl:template match="tei:availability">
    <xsl:element name="dc:rights">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tei:seriesStmt/tei:title">

    <xsl:choose>
      <xsl:when test="$qualified = 'true'">
        <xsl:element name="dcterms:isPartOf"><xsl:value-of select="."/></xsl:element>

        <xsl:element name="dcterms:isPartOf">
          <xsl:attribute name="scheme">URI</xsl:attribute>
          <xsl:text>http://beck.library.emory.edu/frenchrevolution/</xsl:text>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <!-- FIXME: should both be included for unqualified dublin core? -->
        <xsl:element name="dc:relation"><xsl:value-of select="."/></xsl:element>
        <xsl:element name="dc:relation">http://beck.library.emory.edu/frenchrevolution/</xsl:element>
      </xsl:otherwise>
    </xsl:choose>


    <!--    <xsl:element name="dc:relation"> 
       FIXME: should we specify isPartOf?   
      <xsl:apply-templates/> 
    </xsl:element>-->
  </xsl:template>

  <xsl:template match="tei:sourceDesc/tei:bibl">
    <xsl:element name="dc:source">
      <!-- process all elements, in this order. -->
      <xsl:apply-templates select="tei:author"/>
      <xsl:apply-templates select="tei:title"/>
      <xsl:apply-templates select="tei:editor"/>
      <xsl:apply-templates select="tei:pubPlace"/>
      <xsl:apply-templates select="tei:publisher"/>
      <xsl:apply-templates select="tei:date"/>
      <!-- in case source is in plain text, without tags -->
      <xsl:apply-templates select="text()"/>
    </xsl:element>
  </xsl:template>

  <!-- formatting for bibl elements, to generate a nice citation. -->
  <xsl:template match="tei:bibl/tei:author"><xsl:apply-templates/>. </xsl:template>
  <xsl:template match="tei:bibl/tei:title">
    <xsl:apply-templates/>
    <xsl:if test="not(contains(., '.'))"><xsl:text>.</xsl:text></xsl:if>	<!-- hack; add period? -->
    <xsl:text> </xsl:text>
  </xsl:template>  

   <xsl:template match="tei:bibl/tei:editor">
    <xsl:text>Ed. </xsl:text><xsl:apply-templates/><xsl:text>. </xsl:text> 
  </xsl:template> 
  <xsl:template match="tei:bibl/tei:pubPlace">
    <xsl:if test=". != ''">
      <xsl:apply-templates/>
      <xsl:text>: </xsl:text>
    </xsl:if>
  </xsl:template> 
  <xsl:template match="tei:bibl/tei:publisher"> 
    <xsl:if test=". != ''"><xsl:apply-templates/>, </xsl:if>
  </xsl:template> 
  <xsl:template match="tei:bibl/tei:date"><xsl:apply-templates/>.</xsl:template>


  <!-- generic description, same on all records - don't include -->
  <xsl:template match="tei:encodingDesc/tei:projectDesc"/>


  <xsl:template match="tei:profileDesc/tei:creation/tei:date">
    <xsl:choose>
      <xsl:when test="$qualified = 'true'">
        <xsl:element name="dcterms:created">
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="dc:date">
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="tei:profileDesc/tei:creation/tei:rs[@type='geography']">
   <xsl:element name="dc:coverage">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <!-- ark identifier -->
  <xsl:template match="tei:idno[@type='ark']">
    <xsl:element name="dc:identifier">
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <!-- ignore other rs types for now -->
  <xsl:template match="tei:profileDesc/tei:creation/tei:rs[@type!='geography']"/>

  <!-- ignore these: encoding specific information -->
  <xsl:template match="tei:encodingDesc/tei:tagsDecl"/>
  <xsl:template match="tei:encodingDesc/tei:refsDecl"/>
  <xsl:template match="tei:encodingDesc/tei:editorialDecl"/>
  <xsl:template match="tei:revisionDesc"/>


  <!-- ignore bibls within the text for now -->
  <xsl:template match="tei:text//tei:bibl"/>

  <!-- normalize space for all text nodes -->
  <xsl:template match="text()">
    <xsl:value-of select="normalize-space(.)"/>
  </xsl:template>


</xsl:stylesheet>
