<?xml version="1.0" encoding="UTF-8"?>
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->  <xsl:stylesheet xmlns:hl7="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:import href="../Lib/Validation_Lib.xsl"/>

    <xsl:template match="text()|@*"/>

    <xsl:template match="hl7:medicationDispense">
        <xsl:choose>
            <xsl:when test="$ValidationMsgType = 'clientMsg'">
                <xsl:call-template name="Identifier_Element_Test">
                    <xsl:with-param name="node" select="hl7:id"/>
                    <xsl:with-param name="nullable">false</xsl:with-param>
                    <xsl:with-param name="expected_OID_List" select="$OIDSet/ClientSystemDispense"/>
                    <xsl:with-param name="msgType" select="$ValidationMsgType"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="Identifier_Element_Test">
                    <xsl:with-param name="node" select="hl7:id"/>
                    <xsl:with-param name="nullable">false</xsl:with-param>
                    <xsl:with-param name="expected_OID_List" select="$OIDSet/ServerSystemDispense"/>
                    <xsl:with-param name="msgType" select="$ValidationMsgType"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
            <xsl:apply-templates/>     </xsl:template>
    
    <!-- inFulfillmentOf validation -->
    <xsl:template match="hl7:inFulfillmentOf/hl7:substanceAdministrationRequest/hl7:id">
        <xsl:call-template name="Identifier_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">true</xsl:with-param>
            <xsl:with-param name="expected_OID">DIS_PRESCRIPTION_ID</xsl:with-param>
            <xsl:with-param name="msgType" select="$ValidationMsgType"/>
        </xsl:call-template>
            <xsl:apply-templates/>     </xsl:template>
    <xsl:template match="hl7:inFulfillmentOf/hl7:substanceAdministrationRequest/hl7:author">
        <xsl:call-template name="Assigned_Person_Test">
            <xsl:with-param name="node" select="."/>
        </xsl:call-template>
            <xsl:apply-templates/>     </xsl:template>
    
    <!-- substitutionMade validation -->
    <xsl:template match="hl7:substitutionMade/hl7:code">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/ActSubstanceAdminSubstitutionCode"/>
        </xsl:call-template>
            <xsl:apply-templates/>     </xsl:template>
    <xsl:template match="hl7:substitutionMade/hl7:statusCode">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/statusCodeCompleted"/>
        </xsl:call-template>
            <xsl:apply-templates/>     </xsl:template>
    <xsl:template match="hl7:substitutionMade/hl7:reasonCode">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/SubstanceAdminSubstitutionReason"/>
        </xsl:call-template>
            <xsl:apply-templates/>     </xsl:template>

</xsl:stylesheet>
