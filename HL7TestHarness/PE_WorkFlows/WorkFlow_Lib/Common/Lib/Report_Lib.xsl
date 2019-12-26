<?xml version="1.0" encoding="UTF-8"?>
<!-- $Header:   L:/pvcsrep65/HL7TestHarness/archives/PE_WorkFlows/WorkFlow_Lib/Common/Lib/Report_Lib.xsl-arc   1.2   13 Apr 2007 10:45:30   mwicks  $  -->
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->  <xsl:stylesheet xmlns:hl7="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <!-- This template remove the default to output all test in document -->
    <xsl:template match="text()|@*"/>


    <xsl:template name="ReportError">
        <xsl:param name="currentNode"/>
        <xsl:param name="elementName"/>
        <xsl:param name="ErrorText"/>
        <xsl:param name="expectedValue"/>
        <xsl:param name="actualValue"/>
        <error>
            <xsl:attribute name="description">
                <xsl:value-of select="$ErrorText"/>
            </xsl:attribute>
            <xsl:attribute name="element">
                <xsl:choose>
                    <xsl:when test="$currentNode">
                        <xsl:call-template name="nodeXpath">
                            <xsl:with-param name="node" select="$currentNode"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise><xsl:call-template name="xpath"/></xsl:otherwise>
                </xsl:choose>
                <xsl:if test="$elementName"> 
                    <xsl:text>/</xsl:text><xsl:value-of select="$elementName"/>
                </xsl:if>
            </xsl:attribute>
            <expected>
                <xsl:value-of select="$expectedValue"/>
            </expected>
            <actual>
                <xsl:value-of select="$actualValue"/>
            </actual>
        </error>
    </xsl:template>

    <!-- Template to return full path of a node -->
    <xsl:template name="xpath">
            <xsl:for-each select="ancestor-or-self::*">
                <xsl:text>/</xsl:text>
                <xsl:value-of select="name()"/>
                <xsl:text>[</xsl:text>
                <xsl:value-of select="count(preceding-sibling::*[name() = name(current())]) + 1"/>
                <xsl:text>]</xsl:text>
            </xsl:for-each>
    </xsl:template>

    <xsl:template name="nodeXpath">
        <xsl:param name="node"/>
        <xsl:for-each select="$node/ancestor-or-self::*">
            <xsl:text>/</xsl:text>
            <xsl:value-of select="name()"/>
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name() = name(current())]) + 1"/>
            <xsl:text>]</xsl:text>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>
