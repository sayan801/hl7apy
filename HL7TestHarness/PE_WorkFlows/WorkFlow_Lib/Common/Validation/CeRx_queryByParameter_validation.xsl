<?xml version="1.0" encoding="UTF-8"?>
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->  <xsl:stylesheet xmlns:hl7="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:import href="..\Lib\Validation_Lib.xsl"/>

    <xsl:output omit-xml-declaration="yes"/>


    <xsl:template match="hl7:queryByParameter/hl7:queryId">
        <xsl:call-template name="Identifier_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">true</xsl:with-param>
            <xsl:with-param name="expected_OID">PORTAL_QUERY_ID</xsl:with-param>
        </xsl:call-template>
            <xsl:apply-templates/>     </xsl:template>

    <xsl:template match="hl7:queryByParameter/hl7:parameterList/hl7:includeIssueIndicator/hl7:value">
        <xsl:call-template name="Nullable_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
        </xsl:call-template>
            <xsl:apply-templates/>     </xsl:template>
    <xsl:template match="hl7:queryByParameter/hl7:parameterList/hl7:includeNotesIndicator/hl7:value">
        <xsl:call-template name="Nullable_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
        </xsl:call-template>
            <xsl:apply-templates/>     </xsl:template>

    <xsl:template match="hl7:queryByParameter/hl7:parameterList/hl7:patientBirthDate/hl7:value">
        <xsl:call-template name="Nullable_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">true</xsl:with-param>
        </xsl:call-template>
            <xsl:apply-templates/>     </xsl:template>

    <xsl:template match="hl7:queryByParameter/hl7:parameterList/hl7:patientGender/hl7:value">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">true</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/administrativeGenderCode"/>
        </xsl:call-template>
            <xsl:apply-templates/>     </xsl:template>

    <xsl:template match="hl7:queryByParameter/hl7:parameterList/hl7:patientID/hl7:value">
        <xsl:call-template name="Identifier_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="expected_OID_List" select="$OIDSet/patient"/>
        </xsl:call-template>
            <xsl:apply-templates/>     </xsl:template>

    <xsl:template match="hl7:queryByParameter/hl7:parameterList/hl7:patientName/hl7:value">
        <xsl:call-template name="Person_Name_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">true</xsl:with-param>
        </xsl:call-template>
            <xsl:apply-templates/>     </xsl:template>

    
    
</xsl:stylesheet>
