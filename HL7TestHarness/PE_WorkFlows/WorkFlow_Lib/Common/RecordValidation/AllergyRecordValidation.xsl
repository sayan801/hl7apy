<?xml version="1.0" encoding="UTF-8"?>
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->  <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:hl7="urn:hl7-org:v3">
    <xsl:import href="../Lib/Validation_Lib.xsl"/>

    <xsl:param name="profile-description"/>
    <xsl:param name="profile-sequence"/>     <xsl:param name="patient-description"/>         <xsl:param name="msg-effective-time"/>

    <xsl:template match="text()|@*"/>

        <xsl:variable name="wrong_negationInd_ErrorMsg">Negation Indicator does not match data supplied</xsl:variable>


    <xsl:template match="hl7:intoleranceCondition">

        <xsl:variable name="record-id" select="hl7:id/@extension"/>
        <xsl:variable name="record-OID" select="local-name($OID_root/*[@server = hl7:id/@root])"/>
        <xsl:variable name="Profile"
            select="$TestData/medicalProfiles/medicalProfile[@description = $profile-description][@sequence = $profile-sequence]"/>

        <!-- check if we have both an allergy ID and a profile -->
        <xsl:if test="$record-id and not($record-id = '') and $Profile">
            <xsl:variable name="Item" select="$Profile/descendant-or-self::item/*[record-id/@server = $record-id][record-id/@root_OID = $record-OID]"/>
            <xsl:if test="$Item">
                <xsl:variable name="ItemData" select="$TestData/*/*[@description=$Item/@description]"/>

                <xsl:if test="$ItemData/negation and (@negationInd='true')">
                    <xsl:call-template name="ReportError">
                        <xsl:with-param name="ErrorText" select="$wrong_negationInd_ErrorMsg"/>
                        <xsl:with-param name="currentNode" select="."/>
                        <xsl:with-param name="elementName">@negationInd</xsl:with-param>
                        <xsl:with-param name="expectedValue">true</xsl:with-param>
                        <xsl:with-param name="actualValue"><xsl:value-of select="@negationInd"/></xsl:with-param>
                    </xsl:call-template>
                </xsl:if>

            </xsl:if>
        </xsl:if>

    </xsl:template>


</xsl:stylesheet>
