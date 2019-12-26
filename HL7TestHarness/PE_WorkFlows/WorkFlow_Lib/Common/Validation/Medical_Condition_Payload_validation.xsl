<?xml version="1.0" encoding="UTF-8"?>
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->  <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:hl7="urn:hl7-org:v3" version="2.0">
    <xsl:import href="../Lib/Validation_Lib.xsl"/>
    
    <xsl:template match="text()|@*"/> <!-- override default output of text/attributes -->

    <!-- validate optional id element -->
    <xsl:template match="hl7:medicalCondition/hl7:id">
        <xsl:call-template name="Identifier_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="expected_OID">DIS_MEDICAL_CONDITION_ID</xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- validate required medicalCondition elements -->
    <xsl:template match="hl7:medicalCondition">
        <xsl:call-template name="Code_Element_Test"> <!-- check code element, fixed = "DX" -->
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="node" select="hl7:code"/>
            <xsl:with-param name="validCodeSet" select="$CodeSet/MedicalConditionCode"/>
        </xsl:call-template>
        
        <xsl:call-template name="Code_Element_Test">  <!-- check statusCode element,  = "ACTIVE" or "COMPLETE" -->
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="node" select="hl7:statusCode"/>
            <xsl:with-param name="validCodeSet" select="$CodeSet/statusCodeMedicalCondition"/>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- validate optional effectiveTime element -->
    <xsl:template match="hl7:medicalCondition/hl7:effectiveTime">
        <xsl:call-template name="EffectiveTime_Element_Test">
            <xsl:with-param name="widthAllowed">false</xsl:with-param>
            <xsl:with-param name="centerAllowed">false</xsl:with-param>
            <xsl:with-param name="node" select="."></xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- validate optional value element -->
    <xsl:template match="hl7:medicalCondition/hl7:value">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="codeSystemRequired">true</xsl:with-param>
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="validCodeSet" select="$CodeSet/MedicalConditionValue"/>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- validate optional chronicIndicator element -->
    <xsl:template match="hl7:chronicIndicator/hl7:code">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="validCodeSet" select="$CodeSet/chronicIndicator"/>
            <xsl:with-param name="nullable">false</xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    
</xsl:stylesheet>
