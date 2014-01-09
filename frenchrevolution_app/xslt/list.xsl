<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                version="1.0">

<xsl:param name="sort"/>
<xsl:param name="view"/>	<!-- digital editions or all -->


<xsl:variable name="img_url">http://beck.library.emory.edu/frenchrevolution/image-content/</xsl:variable>
<xsl:variable name="thumb_url"><xsl:value-of select="$img_url"/>thumbnails/</xsl:variable>

<xsl:output method="html"/>

<xsl:template match="/">
  <xsl:element name="div">
  <!-- get the count for currently displayed pamphlets, according to mode -->
  <xsl:variable name="count">
    <xsl:choose>
      <!-- digital editions only -->
      <xsl:when test="$view = 'digitaled'">
        <xsl:value-of select="count(//pamphlet[@id])"/>
      </xsl:when>
      <!-- all other modes display all pamphlets -->
      <xsl:otherwise>
        <xsl:value-of select="count(//pamphlet)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>


  <p>
  Displaying <xsl:value-of select="$count"/> pamphlets         
  sorted by <xsl:value-of select="$sort"/>.
  <xsl:if test="$view = 'digitaled'">
    (digital editions only)
  </xsl:if>

  <!-- links for sorting and filtering on digital edition 
       always retain sort or filter when changing the other option
       -->
  <xsl:variable name="viewopt">
    <xsl:if test="$view = 'digitaled'">&amp;view=digitaled</xsl:if>
  </xsl:variable>

  <br/>
  Sort by: 
  <xsl:choose>
    <xsl:when test="$sort = 'title'">
      title 
    </xsl:when>
    <xsl:otherwise>
    <a>
      <xsl:attribute name="href">{% url "pamphlet_list" %}<xsl:value-of select="$viewopt"/></xsl:attribute>
      title</a> 
    </xsl:otherwise>
  </xsl:choose>
|  
  <xsl:choose>
    <xsl:when test="$sort = 'author'">
      author 
    </xsl:when>
    <xsl:otherwise>
      <a>
        <xsl:attribute name="href">http:localhost:"<xsl:value-of select="$viewopt"/></xsl:attribute>
        author</a> 
    </xsl:otherwise>
  </xsl:choose>
| 
  <xsl:choose>
    <xsl:when test="$sort = 'date'">
      date 
    </xsl:when>
    <xsl:otherwise>
    <a>
      <xsl:attribute name="href">list.php?sort=date<xsl:value-of select="$viewopt"/></xsl:attribute>
      date</a> 
    </xsl:otherwise>
  </xsl:choose>
  <br/>
  View: 
  <xsl:choose>
    <xsl:when test="$view != 'digitaled'">
      all pamphlets
    </xsl:when>
    <xsl:otherwise>
      <a>
        <xsl:attribute name="href">list.php?sort=<xsl:value-of select="$sort"/></xsl:attribute>
        all pamphlets</a>
    </xsl:otherwise>
  </xsl:choose>
	| 
  <xsl:choose>
    <xsl:when test="$view = 'digitaled'">
      digital editions
    </xsl:when>
    <xsl:otherwise>
      <a>
        <xsl:attribute name="href">{{% url "pamphlet_list" %}}</xsl:attribute>
        digital editions
      </a>
    </xsl:otherwise>
  </xsl:choose>
  <br/>
</p>



  <xsl:choose>
    <!-- pamphlets with digital editions (id = link) -->
    <xsl:when test="$view = 'digitaled' and $sort = 'title'">
      <xsl:apply-templates select="//pamphlet[@id]">
        <xsl:sort select="title"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:when test="$view = 'digitaled' and $sort = 'author'">
      <xsl:apply-templates select="//pamphlet[@id]">
        <xsl:sort select="author"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:when test="$view = 'digitaled' and $sort = 'date'">
      <xsl:apply-templates select="//pamphlet[@id]">
        <xsl:sort select="date"/>
      </xsl:apply-templates>
    </xsl:when>
    <!-- all pamphlets -->
    <xsl:when test="$sort = 'title'">
      <xsl:apply-templates select="//pamphlet">
        <xsl:sort select="title"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:when test="$sort = 'author'">
      <xsl:apply-templates select="//pamphlet">
        <xsl:sort select="author"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:when test="$sort = 'date'">
      <xsl:apply-templates select="//pamphlet">
        <xsl:sort select="date"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <!-- shouldn't ever get here; just in case, display without any sorting -->
      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
  </xsl:element>
</xsl:template>

<xsl:template match="pamphlet">
  <div class="pamphlet">
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="title">
  <xsl:choose>
    <xsl:when test="../@id">
       <a>
        <xsl:attribute name="href">view.php?doc=<xsl:value-of select="../@id"/></xsl:attribute>
        <xsl:apply-templates/>
      </a>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="figure">
  <div class="pageimage">
     <a>
      <xsl:attribute name="href"><xsl:value-of select="concat($img_url, @entity, '.jpg')"/></xsl:attribute>
      <img>
        <xsl:attribute name="src"><xsl:value-of select="concat($thumb_url, @entity, '.jpg')"/></xsl:attribute>
      </img>
    </a>
  </div>
</xsl:template>

</xsl:stylesheet>
