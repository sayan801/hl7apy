<?xml version="1.0" encoding="UTF-8"?>
<!--
 Module Header

  $Header:   L:/pvcsrep65/HL7TestHarness/archives/Source Code/xsl/CreateStagedData.xsl-arc   1.6   18 Jan 2007 14:20:28   mwicks  $

  Copyright © 1996-2006 by DeltaWare Systems Inc. 

  Company:          DeltaWare Systems Inc.
                    90 University Avenue, Suite 300
                    Charlottetown
                    Prince Edward Island
                    C1A 4K9
                    Phone   (902) 368-8122
                    FAX     (902) 628-4660
                    E-Mail  dsi@deltaware.com

  Development:      DeltaWare Systems Inc.
                    90 University Avenue, Suite 300
                    Charlottetown
                    Prince Edward Island
                    C1A 4K9
                    Phone   (902) 368-8122
                    FAX     (902) 628-4660
                    E-Mail  dsi@deltaware.com

The GNU General Public License (GPL)

This program is free software; you can redistribute it and/or modify it 
under the terms of the GNU General Public License as published by the 
Free Software Foundation; either version 2 of the License, or (at your
option) any later version.
This program is distributed in the hope that it will be useful, but 
WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
Public License for more details.
You should have received a copy of the GNU General Public License along
with this program; if not, write to the Free Software Foundation, Inc., 
59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  Project:          HL7 Test Harness
  Programmer:       Matthew Wicks
  Created:          March 17, 2006

  History:
  Action      Who     Date            Comments
  <<Action>>  xxx     yyyy-mm-dd      <<Comments here>>


  Application notes:
  <<Place notes on usages, known problems, etc>>

-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:date="http://local/dates-and-times">
  <xsl:include href="template_date.xsl"/>
    
    <!-- The Stage Data parameter tells what side is having the data updated -->
    <xsl:param name="StageClientData">true</xsl:param>
    <xsl:param name="StageServerData">true</xsl:param>
    
    <xsl:param name="DateTime" select="'2005-01-01T00:00:00Z'" />

  <!-- copy of the System configuration -->
  <xsl:param name="OIDDataXml"/>
    <xsl:variable name="OIDs" select="$OIDDataXml/OIDs"/>
    
    
<xsl:template match="*">
    <xsl:choose>
        <xsl:when test="name() = 'dob'">
            <xsl:call-template name="dob"/>
        </xsl:when>
        <xsl:when test="name() = 'id'">
            <xsl:call-template name="Id"/>
        </xsl:when>
        <xsl:when test="name() = 'OIDs'">
            <xsl:copy-of select="$OIDs"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:call-template name="createElement">
                <xsl:with-param name="name"><xsl:value-of select="name()"/></xsl:with-param>
            </xsl:call-template>
        </xsl:otherwise>
    </xsl:choose>
    
</xsl:template>
    
<xsl:template name="createElement">
        <xsl:param name="name"/>
        <xsl:element name="{$name}">
            <xsl:for-each select="@*">
                <xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
            </xsl:for-each>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <!-- 
    <xsl:template name="dob">
        <xsl:element name="dob">
            <xsl:choose>
                <xsl:when test="name(parent::node()) = $StageData and parent::node()/parent::node()/@age">
                    <xsl:variable name="age"><xsl:value-of select="../../@age"/></xsl:variable>
                    <xsl:variable name="date" select="date:date-time()"/>
                    <xsl:variable name="formated-date">P<xsl:value-of select="date:format-date($date,'yyyy')"/>Y<xsl:value-of select="date:format-date($date,'MM')"/>M<xsl:value-of select="date:format-date($date,'dd')"/>D</xsl:variable>
                    <xsl:variable name="new-date"><xsl:value-of select="date:add-duration($formated-date, $age)"/></xsl:variable>
                    <xsl:variable name="foramated-new-date"><xsl:value-of select="substring($new-date, 2, 4)"/><xsl:value-of select="substring($new-date, 7, 2)"/><xsl:value-of select="substring($new-date, 10, 2)"/></xsl:variable>
                    <xsl:value-of select="$foramated-new-date"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    -->
    <xsl:template name="dob">
        <xsl:element name="dob">
            <xsl:choose>
                <xsl:when test="(($StageClientData = 'true' and name(parent::node()) = 'client') or ($StageServerData = 'true' and name(parent::node()) = 'server'))  and parent::node()/parent::node()/@age">
                    <xsl:variable name="age"><xsl:value-of select="../../@age"/></xsl:variable>
                    <xsl:variable name="date"><xsl:call-template name="date:date"><xsl:with-param name="date-time" select="$DateTime"></xsl:with-param></xsl:call-template></xsl:variable>
                    <xsl:comment><xsl:value-of select="$date"/></xsl:comment>
                    <xsl:variable name="formated-date">P<xsl:value-of select="substring($date, 1, 4)"/>Y<xsl:value-of select="substring($date,6, 2)"/>M<xsl:value-of select="substring($date, 9, 2)"/>D</xsl:variable>
                    <xsl:variable name="new-date"><xsl:call-template name="date:add-duration"><xsl:with-param name="duration1" select="$formated-date"/><xsl:with-param name="duration2" select="$age"/></xsl:call-template></xsl:variable>
                    <xsl:comment><xsl:value-of select="$new-date"/></xsl:comment>
                    <xsl:variable name="formated-new-date"><xsl:value-of select="substring($new-date, 2, 4)"/><xsl:value-of select="substring($new-date, 7, 2)"/><xsl:value-of select="substring($new-date, 10, 2)"/></xsl:variable>
                    <xsl:value-of select="$formated-new-date"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    
    
<xsl:template name="Id">
    <xsl:element name="id">
        <xsl:if test="@root">
            <xsl:variable name="OID_name">
                <xsl:choose>
                    <xsl:when test="parent::node()/@OID"><xsl:value-of select="parent::node()/@OID"/></xsl:when>
                    <xsl:when test="parent::node()/parent::node()/@OID"><xsl:value-of select="parent::node()/parent::node()/@OID"/></xsl:when>
                    <xsl:otherwise>OID_NOT_DEFINED</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:attribute name="root">
            <xsl:choose>
                <xsl:when test="name(parent::node()) = 'client'">
                    <xsl:for-each select="$OIDs/descendant-or-self::node()[name() = $OID_name]">
                        <xsl:call-template name="OID-client">
                            <xsl:with-param name="OID-Element" select="."/>
                        </xsl:call-template>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:for-each select="$OIDs/descendant-or-self::node()[name() = $OID_name]">
                        <xsl:call-template name="OID-server">
                            <xsl:with-param name="OID-Element" select="."/>
                        </xsl:call-template>
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="@extension">
            <xsl:attribute name="extension"><xsl:value-of select="@extension"/></xsl:attribute>
        </xsl:if>
    </xsl:element>
</xsl:template>    
    
    <xsl:template name="OID-client">
        <xsl:param name="OID-Element"/>
        <xsl:value-of select="$OID-Element/@client"/>
    </xsl:template>
    <xsl:template name="OID-server">
        <xsl:param name="OID-Element"/>
        <xsl:value-of select="$OID-Element/@server"/>
    </xsl:template>
</xsl:stylesheet>
