<?xml version="1.0" encoding="UTF-8"?>
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->
<xsl:stylesheet xmlns:hl7="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:import href="..\Lib\Validation_Lib.xsl"/>

    <xsl:output omit-xml-declaration="yes"/>

    <xsl:param name="minCount"/>
    <xsl:param name="maxCount"/>

    <xsl:variable name="min_count_not_reached">The minimum number of subject element has not been reached.</xsl:variable>
    <xsl:variable name="max_count_not_exceeded">The maximum number of subject element has not been exceeded.</xsl:variable>

    <xsl:template match="/">
        <xsl:variable name="subject_count" select="count(descendant-or-self::hl7:controlActEvent/hl7:subject) + count(descendant-or-self::hl7:controlActProcess/hl7:subject)"/>
        <xsl:if test="$minCount and $subject_count &lt; $minCount">
                        <xsl:call-template name="ReportError">
                            <xsl:with-param name="ErrorText"><xsl:value-of select="$min_count_not_reached"/></xsl:with-param>
                            <xsl:with-param name="currentNode" select="."/>
                            <xsl:with-param name="attributeName"/>
                            <xsl:with-param name="expectedValue">count = <xsl:value-of select="$minCount"/></xsl:with-param>
                            <xsl:with-param name="actualValue">count = <xsl:value-of select="$subject_count"/></xsl:with-param>
                        </xsl:call-template>
        </xsl:if>
        <xsl:if test="$maxCount and $subject_count &gt; $maxCount">
                        <xsl:call-template name="ReportError">
                            <xsl:with-param name="ErrorText"><xsl:value-of select="$max_count_not_exceeded"/></xsl:with-param>
                            <xsl:with-param name="currentNode" select="."/>
                            <xsl:with-param name="attributeName"/>
                            <xsl:with-param name="expectedValue">count = <xsl:value-of select="$maxCount"/></xsl:with-param>
                            <xsl:with-param name="actualValue">count = <xsl:value-of select="$subject_count"/></xsl:with-param>
                        </xsl:call-template>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>

</xsl:stylesheet>
