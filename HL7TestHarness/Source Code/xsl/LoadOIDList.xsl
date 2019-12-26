<?xml version="1.0" encoding="UTF-8"?>
<!--
 Module Header

  $Header:   L:/pvcsrep65/HL7TestHarness/archives/Source Code/xsl/LoadOIDList.xsl-arc   1.5   18 Jan 2007 14:20:28   mwicks  $

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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:param name="OtherSystemOIDs"/>
    <xsl:param name="System">server</xsl:param>
    
    <xsl:variable name="OtherSystem">
        <xsl:choose>
            <xsl:when test="$System='server'">client</xsl:when>
            <xsl:otherwise>server</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <!-- This template remove the default to output all test in document -->
    <xsl:template match="text()|@*" mode="ROWDATA"/> 
    <xsl:template match="text()|@*" mode="TESTDATA"/> 
    <xsl:template match="text()|@*"/> 
    
    
    <xsl:template match="ROWDATA">
                <xsl:element name="OIDs">
                    <xsl:apply-templates mode="ROWDATA"/>
                </xsl:element>
    </xsl:template>

    <xsl:template match="configuration">
                <xsl:element name="OIDs">
                    <xsl:apply-templates mode="TESTDATA"/>
                </xsl:element>
    </xsl:template>

    
    
    
    <xsl:template match="ROW" mode="ROWDATA">
        <xsl:if test="child::CODE">
            <xsl:variable name="OID_code">
                <xsl:value-of select="child::CODE"/>
            </xsl:variable>
            <xsl:element name="{$OID_code}">
                <xsl:attribute name="{$System}">
                    <xsl:call-template name="OID_value">
                        <xsl:with-param name="SystemOIDs" select="ancestor-or-self::node()"/>
                        <xsl:with-param name="OID_code" select="$OID_code"/>
                        <xsl:with-param name="system_code"><xsl:value-of select="$System"/></xsl:with-param>
                    </xsl:call-template>
                </xsl:attribute>
                <xsl:attribute name="{$OtherSystem}">
                    <xsl:call-template name="OID_value">
                        <xsl:with-param name="SystemOIDs" select="$OtherSystemOIDs"/>
                        <xsl:with-param name="OID_code" select="$OID_code"/>
                        <xsl:with-param name="system_code"><xsl:value-of select="$OtherSystem"/></xsl:with-param>
                    </xsl:call-template>
                </xsl:attribute>
                <xsl:attribute name="description">
                    <xsl:value-of select="child::DESCRIPTION"/>
                </xsl:attribute>
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <xsl:template match="OIDs" mode="TESTDATA">
        <xsl:for-each select="child::node()">
          <xsl:variable name="OID_code">
              <xsl:value-of select="name()"/>
          </xsl:variable>
        
            <xsl:element name="{$OID_code}">
                <xsl:attribute name="{$System}">
                    <xsl:call-template name="OID_value">
                        <xsl:with-param name="SystemOIDs" select="ancestor-or-self::node()"/>
                        <xsl:with-param name="OID_code" select="$OID_code"/>
                        <xsl:with-param name="system_code"><xsl:value-of select="$System"/></xsl:with-param>
                    </xsl:call-template>
                </xsl:attribute>
                <xsl:attribute name="{$OtherSystem}">
                    <xsl:call-template name="OID_value">
                        <xsl:with-param name="SystemOIDs" select="$OtherSystemOIDs"/>
                        <xsl:with-param name="OID_code" select="$OID_code"/>
                        <xsl:with-param name="system_code"><xsl:value-of select="$OtherSystem"/></xsl:with-param>
                    </xsl:call-template>
                </xsl:attribute>
                <xsl:attribute name="description">
                    <xsl:value-of select="@description"/>
                </xsl:attribute>
            </xsl:element>
            
        </xsl:for-each>
        
    </xsl:template>
    
    
<xsl:template name="OID_value">
    <xsl:param name="SystemOIDs"/>
    <xsl:param name="OID_code"/>
    <xsl:param name="system_code"/>
    <xsl:choose>
        <xsl:when test="$SystemOIDs">
            <xsl:choose>
                <xsl:when test="$SystemOIDs/ROWDATA/ROW/CODE[text()=$OID_code]/parent::node()/OID">
                    <xsl:value-of select="$SystemOIDs/ROWDATA/ROW/CODE[text()=$OID_code]/parent::node()/OID"/>
                </xsl:when>
                <xsl:when test="$SystemOIDs/descendant-or-self::OIDs/node()[name()=$OID_code]">
                    <xsl:choose>
                        <xsl:when test="$system_code = 'server'">
                            <xsl:value-of select="$SystemOIDs/descendant-or-self::OIDs/node()[name()=$OID_code]/@server"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$SystemOIDs/descendant-or-self::OIDs/node()[name()=$OID_code]/@client"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>OID_NOT_DEFINED</xsl:otherwise>
            </xsl:choose>
        </xsl:when>
        <xsl:otherwise>OID_NOT_DEFINED</xsl:otherwise>
    </xsl:choose>
</xsl:template>
</xsl:stylesheet>
