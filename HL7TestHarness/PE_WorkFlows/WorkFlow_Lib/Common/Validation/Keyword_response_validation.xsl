<?xml version="1.0" encoding="UTF-8"?>
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->
<xsl:stylesheet xmlns:hl7="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:import href="..\Lib\Validation_Lib.xsl"/>

    <xsl:output omit-xml-declaration="yes"/>

    <xsl:param name="KeywordValid">true</xsl:param>

    <xsl:variable name="Keyword_Invalid">Response Message indicates that an incorrect Keyword or OverRide was provided. (Workflow indicates that keyword or OverRide should be correct)</xsl:variable>
    <xsl:variable name="Keyword_valid">Response Message indicates that a correct Keyword or OverRide was provided. (Workflow indicates that keyword or OverRide should be incorrect)</xsl:variable>
    <xsl:variable name="Invalid_Content_Provided">Response Message includes client information that should not be provided with out keyword or OverRide</xsl:variable>

    <xsl:template match="/">
        <xsl:choose>
            
            <xsl:when test="descendant-or-self::hl7:detectedIssueEvent[hl7:text = 'Patient profile is keyword protected and provider does not have keyword override permission'] ">
                <xsl:if test="$KeywordValid = 'true' or $KeywordValid = 'TRUE'">
                    <xsl:call-template name="ReportError">
                        <xsl:with-param name="ErrorText" select="$Keyword_Invalid"/>
                        <xsl:with-param name="currentNode" select="."/>
                        <xsl:with-param name="elementName"/>
                        <xsl:with-param name="expectedValue"/>
                        <xsl:with-param name="actualValue">
                            <xsl:value-of select="descendant-or-self::hl7:detectedIssueEvent/hl7:text"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:if>
                <xsl:if test="descendant-or-self::hl7:controlActEvent/hl7:subject">
                    <xsl:call-template name="ReportError">
                        <xsl:with-param name="ErrorText" select="$Invalid_Content_Provided"/>
                        <xsl:with-param name="currentNode" select="."/>
                        <xsl:with-param name="elementName"/>
                        <xsl:with-param name="expectedValue"/>
                        <xsl:with-param name="actualValue"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:when>
            <xsl:when test="descendant-or-self::hl7:detectedIssueEvent[hl7:text = 'Patient profile is keyword protected'] ">
                <xsl:if test="$KeywordValid = 'true' or $KeywordValid = 'TRUE'">
                    <xsl:call-template name="ReportError">
                        <xsl:with-param name="ErrorText" select="$Keyword_Invalid"/>
                        <xsl:with-param name="currentNode" select="."/>
                        <xsl:with-param name="elementName"/>
                        <xsl:with-param name="expectedValue"/>
                        <xsl:with-param name="actualValue">
                            <xsl:value-of select="descendant-or-self::hl7:detectedIssueEvent/hl7:text"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:if>
                <xsl:if test="descendant-or-self::hl7:controlActEvent/hl7:subject">
                    <xsl:call-template name="ReportError">
                        <xsl:with-param name="ErrorText" select="$Invalid_Content_Provided"/>
                        <xsl:with-param name="currentNode" select="."/>
                        <xsl:with-param name="elementName"/>
                        <xsl:with-param name="expectedValue"/>
                        <xsl:with-param name="actualValue"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="$KeywordValid = 'false' or $KeywordValid = 'FALSE'">
                    <xsl:call-template name="ReportError">
                        <xsl:with-param name="ErrorText" select="$Keyword_valid"/>
                        <xsl:with-param name="currentNode" select="."/>
                        <xsl:with-param name="elementName"/>
                        <xsl:with-param name="expectedValue"></xsl:with-param>
                        <xsl:with-param name="actualValue"/>
                    </xsl:call-template>
                    <xsl:if test="descendant-or-self::hl7:controlActEvent/hl7:subject">
                        <xsl:call-template name="ReportError">
                            <xsl:with-param name="ErrorText" select="$Invalid_Content_Provided"/>
                            <xsl:with-param name="currentNode" select="."/>
                            <xsl:with-param name="elementName"/>
                            <xsl:with-param name="expectedValue"/>
                            <xsl:with-param name="actualValue"/>
                        </xsl:call-template>
                    </xsl:if>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates/>
    </xsl:template>

</xsl:stylesheet>
