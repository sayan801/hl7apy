<?xml version="1.0" encoding="UTF-8"?>
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->
<xsl:stylesheet xmlns:hl7="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:import href="..\Lib\Validation_Lib.xsl"/>

    <xsl:output omit-xml-declaration="yes"/>

    <xsl:param name="maxIssueCount"/>
    <xsl:param name="minIssueCount"/>
    <xsl:param name="IssueText"/>

    <!-- Strick validation means all issues with text must have the Issue code, priority and severity levels, nonStrick validation means only one must have it -->
    <xsl:param name="StrickIssueValidation"/>
    <xsl:param name="IssueCode"/>
    <xsl:param name="IssuePriority"/>
    <xsl:param name="IssueSeverity"/>

    <xsl:variable name="Expected_Issue_Not_Present">The expected Issue Text was not present in the response message.</xsl:variable>
    <xsl:variable name="Issue_start_text">The issue (</xsl:variable>
    <xsl:variable name="Issue_is_incorrect_code">) are not the correct coded type.</xsl:variable>
    <xsl:variable name="Issue_is_incorrect_priority">) are not the correct priority code.</xsl:variable>
    <xsl:variable name="Issue_is_incorrect_severity">) are not of the correct severity code.</xsl:variable>

    <xsl:variable name="Max_Issue_Count_Exceeded">The Maximum number of issues has been exceeded.</xsl:variable>
    <xsl:variable name="Min_Issue_Count_Not_Reached">The Minimum number of issues has been been reached.</xsl:variable>

    <xsl:template match="/">
        <xsl:if test="$IssueText">
            <xsl:choose>
                <xsl:when test="descendant-or-self::hl7:detectedIssueEvent[hl7:text = $IssueText]">
                    <xsl:choose>
                        <xsl:when test="$StrickIssueValidation and not($StrickIssueValidation = 'false')">
                            <xsl:for-each select="descendant-or-self::hl7:detectedIssueEvent[hl7:text = $IssueText]">
                                <xsl:if test="$IssueCode and not(hl7:code/@code = $IssueCode)">
                                    <xsl:call-template name="ReportError">
                                        <xsl:with-param name="ErrorText">
                                            <xsl:value-of select="$Issue_start_text"/>
                                            <xsl:value-of select="$IssueText"/>
                                            <xsl:value-of select="$Issue_is_incorrect_code"/>
                                        </xsl:with-param>
                                        <xsl:with-param name="currentNode" select="hl7:code"/>
                                        <xsl:with-param name="attributeName">code</xsl:with-param>
                                        <xsl:with-param name="expectedValue">
                                            <xsl:value-of select="$IssueCode"/>
                                        </xsl:with-param>
                                        <xsl:with-param name="actualValue">
                                            <xsl:value-of select="hl7:code/@code"/>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </xsl:if>
                                <xsl:if test="$IssuePriority and not(hl7:priorityCode/@code = $IssuePriority)">
                                    <xsl:call-template name="ReportError">
                                        <xsl:with-param name="ErrorText">
                                            <xsl:value-of select="$Issue_start_text"/>
                                            <xsl:value-of select="$IssueText"/>
                                            <xsl:value-of select="$Issue_is_incorrect_priority"/>
                                        </xsl:with-param>
                                        <xsl:with-param name="currentNode" select="hl7:priorityCode"/>
                                        <xsl:with-param name="attributeName">code</xsl:with-param>
                                        <xsl:with-param name="expectedValue">
                                            <xsl:value-of select="$IssuePriority"/>
                                        </xsl:with-param>
                                        <xsl:with-param name="actualValue">
                                            <xsl:value-of select="hl7:priorityCode/@code"/>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </xsl:if>
                                <xsl:if test="$IssueSeverity and not(descendant-or-self::hl7:severityObservation/hl7:value/@code = $IssueSeverity)">
                                    <xsl:call-template name="ReportError">
                                        <xsl:with-param name="ErrorText">
                                            <xsl:value-of select="$Issue_start_text"/>
                                            <xsl:value-of select="$IssueText"/>
                                            <xsl:value-of select="$Issue_is_incorrect_severity"/>
                                        </xsl:with-param>
                                        <xsl:with-param name="currentNode" select="descendant-or-self::hl7:severityObservation/hl7:value"/>
                                        <xsl:with-param name="attributeName">code</xsl:with-param>
                                        <xsl:with-param name="expectedValue">
                                            <xsl:value-of select="$IssueSeverity"/>
                                        </xsl:with-param>
                                        <xsl:with-param name="actualValue">
                                            <xsl:value-of select="descendant-or-self::hl7:severityObservation/hl7:value/@code"/>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:if test="$IssueCode and not(descendant-or-self::hl7:detectedIssueEvent[hl7:text = $IssueText][hl7:code/@code = $IssueCode])">
                                <xsl:call-template name="ReportError">
                                    <xsl:with-param name="ErrorText">
                                        <xsl:value-of select="$Issue_start_text"/>
                                        <xsl:value-of select="$IssueText"/>
                                        <xsl:value-of select="$Issue_is_incorrect_code"/>
                                    </xsl:with-param>
                                    <xsl:with-param name="currentNode" select="hl7:code"/>
                                    <xsl:with-param name="attributeName">code</xsl:with-param>
                                    <xsl:with-param name="expectedValue">
                                        <xsl:value-of select="$IssueCode"/>
                                    </xsl:with-param>
                                    <xsl:with-param name="actualValue">
                                        <xsl:text>Issues Codes Present: </xsl:text>
                                        <xsl:for-each select="descendant-or-self::hl7:detectedIssueEvent[hl7:text = $IssueText]">
                                            <xsl:value-of select="hl7:code/@code"/><xsl:text>; </xsl:text>
                                        </xsl:for-each>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:if>
                            <xsl:if test="$IssuePriority and not(descendant-or-self::hl7:detectedIssueEvent[hl7:text = $IssueText][hl7:priorityCode/@code = $IssuePriority])">
                                <xsl:call-template name="ReportError">
                                    <xsl:with-param name="ErrorText">
                                        <xsl:value-of select="$Issue_start_text"/>
                                        <xsl:value-of select="$IssueText"/>
                                        <xsl:value-of select="$Issue_is_incorrect_priority"/>
                                    </xsl:with-param>
                                    <xsl:with-param name="currentNode" select="hl7:priorityCode"/>
                                    <xsl:with-param name="attributeName">code</xsl:with-param>
                                    <xsl:with-param name="expectedValue">
                                        <xsl:value-of select="$IssuePriority"/>
                                    </xsl:with-param>
                                    <xsl:with-param name="actualValue">
                                        <xsl:text>Issues Priority Codes Present: </xsl:text>
                                        <xsl:for-each select="descendant-or-self::hl7:detectedIssueEvent[hl7:text = $IssueText]">
                                            <xsl:value-of select="hl7:priorityCode/@code"/><xsl:text>; </xsl:text>
                                        </xsl:for-each>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:if>
                            <xsl:if test="$IssueSeverity and not(descendant-or-self::hl7:detectedIssueEvent[hl7:text = $IssueText][descendant-or-self::hl7:severityObservation/hl7:value/@code = $IssueSeverity])">
                                <xsl:call-template name="ReportError">
                                    <xsl:with-param name="ErrorText">
                                        <xsl:value-of select="$Issue_start_text"/>
                                        <xsl:value-of select="$IssueText"/>
                                        <xsl:value-of select="$Issue_is_incorrect_severity"/>
                                    </xsl:with-param>
                                    <xsl:with-param name="currentNode" select="descendant-or-self::hl7:severityObservation/hl7:value"/>
                                    <xsl:with-param name="attributeName">code</xsl:with-param>
                                    <xsl:with-param name="expectedValue">
                                        <xsl:value-of select="$IssueSeverity"/>
                                    </xsl:with-param>
                                    <xsl:with-param name="actualValue">
                                        <xsl:text>Issues Severity Codes Present: </xsl:text>
                                        <xsl:for-each select="descendant-or-self::hl7:detectedIssueEvent[hl7:text = $IssueText]">
                                            <xsl:value-of select="descendant-or-self::hl7:severityObservation/hl7:value/@code"/><xsl:text>; </xsl:text>
                                        </xsl:for-each>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:if>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="ReportError">
                        <xsl:with-param name="ErrorText" select="$Expected_Issue_Not_Present"/>
                        <xsl:with-param name="currentNode" select="/hl7:*"/>
                        <xsl:with-param name="elementName"/>
                        <xsl:with-param name="expectedValue">
                            <xsl:value-of select="$IssueText"/>
                        </xsl:with-param>
                        <xsl:with-param name="actualValue">
                            <xsl:text>Issues Present:  </xsl:text>
                            <xsl:for-each select="descendant-or-self::hl7:detectedIssueEvent">
                                <xsl:value-of select="descendant-or-self::hl7:text"/>
                                <xsl:text>; </xsl:text>
                            </xsl:for-each>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$maxIssueCount and count(descendant-or-self::hl7:detectedIssueEvent) &gt; $maxIssueCount">
            <xsl:call-template name="ReportError">
                <xsl:with-param name="ErrorText" select="$Max_Issue_Count_Exceeded"/>
                <xsl:with-param name="currentNode"/>
                <xsl:with-param name="elementName"/>
                <xsl:with-param name="expectedValue">Count: <xsl:value-of select="$maxIssueCount"/></xsl:with-param>
                <xsl:with-param name="actualValue">Count: <xsl:value-of select="count(descendant-or-self::hl7:detectedIssueEvent)"/>
                    <xsl:text>
                            </xsl:text>
                    <xsl:text>Issues Present:  </xsl:text>
                    <xsl:for-each select="descendant-or-self::hl7:detectedIssueEvent">
                        <xsl:value-of select="descendant-or-self::hl7:text"/>
                        <xsl:text>; </xsl:text>
                    </xsl:for-each>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="$minIssueCount and count(descendant-or-self::hl7:detectedIssueEvent) &lt; $minIssueCount">
            <xsl:call-template name="ReportError">
                <xsl:with-param name="ErrorText" select="$Min_Issue_Count_Not_Reached"/>
                <xsl:with-param name="currentNode"/>
                <xsl:with-param name="elementName"/>
                <xsl:with-param name="expectedValue">Count: <xsl:value-of select="$minIssueCount"/></xsl:with-param>
                <xsl:with-param name="actualValue">Count: <xsl:value-of select="count(descendant-or-self::hl7:detectedIssueEvent)"/></xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>

</xsl:stylesheet>
