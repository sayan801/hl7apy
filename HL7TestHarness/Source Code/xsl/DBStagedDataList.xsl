<?xml version="1.0" encoding="UTF-8"?>
<!--
 Module Header

  $Header:   L:/pvcsrep65/HL7TestHarness/archives/Source Code/xsl/DBStagedDataList.xsl-arc   1.6   18 Jan 2007 14:20:28   mwicks  $

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


  <!-- This template remove the default to output all test in document -->
    <xsl:template match="text()|@*" mode="ClientData"/> 
    <xsl:template match="text()|@*" mode="ServerData"/> 
    <xsl:template match="text()|@*"/> 
    

    <xsl:template match="/">
        <xsl:element name="stagedData">
                <xsl:element name="client">
                    <xsl:apply-templates mode="ClientData"/>
                </xsl:element>
                <xsl:element name="server">
                    <xsl:apply-templates mode="ServerData"/>
                </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="client" mode="ClientData">
        <xsl:call-template name="createElement"/>
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="server" mode="ServerData">
        <xsl:call-template name="createElement"/>
        <xsl:apply-templates/>
    </xsl:template>
    
    
    <xsl:template name="createElement">
                <xsl:variable name="element-name" select="name(parent::node())"/>
                <xsl:element name="{$element-name}">
                    <xsl:for-each select="descendant::node()">
                        <xsl:if test="name()">
                        <xsl:call-template name="createAttributeFromElement">
                            <xsl:with-param name="name"><xsl:value-of select="name()"/></xsl:with-param>
                        </xsl:call-template>
                            </xsl:if>
                    </xsl:for-each>
                </xsl:element>
    </xsl:template>
    
    <xsl:template name="createAttributeFromElement">
        <xsl:param name="name"/>
        <xsl:choose>
            <xsl:when test="@*">
                <xsl:for-each select="@*">
                    <xsl:attribute name="{$name}-{name()}"><xsl:value-of select="."/></xsl:attribute>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="name() = 'addr'"></xsl:when>
            <xsl:otherwise>
                <xsl:if test="text()">
                    <xsl:attribute name="{$name}"><xsl:value-of select="text()"/></xsl:attribute>
                    </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
</xsl:stylesheet>
