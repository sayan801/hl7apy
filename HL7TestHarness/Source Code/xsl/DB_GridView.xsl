<?xml version="1.0" encoding="UTF-8"?>
<!--
 Module Header

  $Header:   L:/pvcsrep65/HL7TestHarness/archives/Source Code/xsl/DB_GridView.xsl-arc   1.8   18 Jan 2007 14:20:28   mwicks  $

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
  <xsl:template match="/">
    <tests>
            <xsl:apply-templates/>
        </tests>
    </xsl:template>
 
    <xsl:template match="//Simulator/exception">
        <rule>
            <xsl:attribute name="Message">
                <xsl:choose>
                    <xsl:when test="parent::node()/parent::request">Client Simulator Error</xsl:when>
                    <xsl:otherwise>Server Simulator Error</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="Catagory"></xsl:attribute>
            <xsl:attribute name="Test_Case">Exception</xsl:attribute>
            <xsl:attribute name="Result">
                <xsl:value-of select="."/>
            </xsl:attribute>
        </rule>
    </xsl:template>
    
    <xsl:template match="//validation/rule">
            <rule>
                <xsl:attribute name="Message">
                    <xsl:value-of select="../../../@description"/>
                    <!-- 
                    <xsl:choose>
                        <xsl:when test="parent::node()/preceding-sibling::validation"></xsl:when>
                        <xsl:when test="preceding-sibling::*"></xsl:when>
                        <xsl:otherwise><xsl:value-of select="../../../@description"/></xsl:otherwise>
                    </xsl:choose>
                    -->
                </xsl:attribute>
                <xsl:attribute name="Catagory">
                    <xsl:value-of select="../@description"/>
                    <!-- 
                    <xsl:choose>
                        <xsl:when test="preceding-sibling::*"></xsl:when>
                        <xsl:otherwise><xsl:value-of select="../@description"/></xsl:otherwise>
                    </xsl:choose>
                    -->
                </xsl:attribute>
                <xsl:attribute name="Test_Case">
                    <xsl:value-of select="@description"/>
                </xsl:attribute>
                <xsl:attribute name="Result">
                    <xsl:choose>
                        <xsl:when test="@status">
                            <xsl:value-of select="@status"/>
                            <xsl:for-each select="error[1]/error[1]">
                                <xsl:text> - </xsl:text><xsl:value-of select="@description"/><xsl:text> (</xsl:text><xsl:value-of select="@element"/><xsl:text>)</xsl:text>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="ancestor-or-self::validation/@status = 'N/A'">N/A</xsl:when>
                        <xsl:otherwise>---</xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
            </rule>
    </xsl:template>

</xsl:stylesheet>
