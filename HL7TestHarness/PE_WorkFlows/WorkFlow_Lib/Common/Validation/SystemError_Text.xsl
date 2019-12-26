<?xml version="1.0" encoding="UTF-8"?>
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->
<xsl:stylesheet xmlns:hl7="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:import href="..\Lib\Validation_Lib.xsl"/>

    <xsl:output omit-xml-declaration="yes"/>

    <xsl:param name="SystemErrorsExpected">false</xsl:param>
    <xsl:param name="SystemErrorText"/>

    <xsl:variable name="System_Error">System Error: </xsl:variable>

    <xsl:template match="hl7:MCCI_IN000002UV01">
        <xsl:choose>
            <xsl:when test="$SystemErrorsExpected = 'true' ">
                <xsl:if test="$SystemErrorText and not(descendant-or-self::hl7:originalText = $SystemErrorText)">
                        <xsl:call-template name="ReportError">
                            <xsl:with-param name="ErrorText"><xsl:value-of select="$System_Error"/><xsl:value-of select="descendant-or-self::hl7:originalText"/></xsl:with-param>
                            <xsl:with-param name="currentNode" select="."/>
                            <xsl:with-param name="expectedValue"><xsl:value-of select="$SystemErrorText"/></xsl:with-param>
                            <xsl:with-param name="actualValue"><xsl:value-of select="descendant-or-self::hl7:originalText"/></xsl:with-param>
                        </xsl:call-template>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                        <xsl:call-template name="ReportError">
                            <xsl:with-param name="ErrorText"><xsl:value-of select="$System_Error"/><xsl:value-of select="descendant-or-self::hl7:originalText"/></xsl:with-param>
                            <xsl:with-param name="currentNode" select="."/>
                            <xsl:with-param name="expectedValue"></xsl:with-param>
                            <xsl:with-param name="actualValue"><xsl:value-of select="descendant-or-self::hl7:originalText"/></xsl:with-param>
                        </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
        
        <xsl:apply-templates/>
    </xsl:template>

</xsl:stylesheet>
