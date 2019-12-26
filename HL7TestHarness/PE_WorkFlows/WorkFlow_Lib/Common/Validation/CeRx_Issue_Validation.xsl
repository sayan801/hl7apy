<?xml version="1.0" encoding="UTF-8"?>
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->  <xsl:stylesheet xmlns:hl7="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:import href="../Lib/Validation_Lib.xsl"/>
    
    <xsl:template match="text()|@*"/>
    
    <xsl:template match="hl7:detectedIssueEvent/hl7:code">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/ActDetectedIssueCode"/>
        </xsl:call-template>
            <xsl:apply-templates/>     </xsl:template>
    
    <xsl:template match="hl7:detectedIssueEvent/hl7:statusCode">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/statusCodeIssues"/>
        </xsl:call-template>
            <xsl:apply-templates/>     </xsl:template>
    
    <xsl:template match="hl7:detectedIssueEvent/hl7:priorityCode">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/priorityCode"/>
        </xsl:call-template>
            <xsl:apply-templates/>     </xsl:template>
    
    <!-- substanceAdministration templates (these may be moved into the common element validation file) -->
    <xsl:template match="hl7:substanceAdministration/hl7:id">
        <xsl:call-template name="Identifier_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="expected_OID_List" select="$OIDSet/exposureEvent"/>
            <xsl:with-param name="msgType" select="$ValidationMsgType"/>
        </xsl:call-template>
            <xsl:apply-templates/>     </xsl:template>
    <xsl:template match="hl7:substanceAdministration/hl7:code">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/InteractionType"/>
        </xsl:call-template>
            <xsl:apply-templates/>     </xsl:template>
    <xsl:template match="hl7:substanceAdministration/hl7:statusCode">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/statusCode"/>
        </xsl:call-template>
            <xsl:apply-templates/>     </xsl:template>
    <xsl:template match="hl7:substanceAdministration/hl7:effectiveTime">
        <xsl:call-template name="EffectiveTime_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="lowAllowed">true</xsl:with-param>
            <xsl:with-param name="highAllowed">true</xsl:with-param>
            <xsl:with-param name="widthAllowed">false</xsl:with-param>
            <xsl:with-param name="centerAllowed">false</xsl:with-param>
        </xsl:call-template>
            <xsl:apply-templates/>     </xsl:template>
    
    <!-- supplyEvent special validation -->
    <xsl:template match="hl7:detectedIssueEvent/hl7:subject/hl7:supplyEvent/hl7:effectiveTime">
        <xsl:call-template name="EffectiveTime_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="highRequired">true</xsl:with-param>
            <xsl:with-param name="lowAllowed">false</xsl:with-param>
            <xsl:with-param name="highAllowed">true</xsl:with-param>
            <xsl:with-param name="widthAllowed">false</xsl:with-param>
            <xsl:with-param name="centerAllowed">false</xsl:with-param>
        </xsl:call-template>
            <xsl:apply-templates/>     </xsl:template>
    
    <!-- observationCodedEvent templates (these may be moved into the common element validation file) -->
    <xsl:template match="hl7:observationCodedEvent/hl7:id">
        <xsl:call-template name="Identifier_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="expected_OID_List" select="$OIDSet/observationCodedEvent"/>
            <xsl:with-param name="msgType" select="$ValidationMsgType"/>
        </xsl:call-template>
            <xsl:apply-templates/>     </xsl:template>
    <xsl:template match="hl7:observationCodedEvent/hl7:code">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/ObservationIssueTriggerCodedObservationType"/>
        </xsl:call-template>
            <xsl:apply-templates/>     </xsl:template>
    <xsl:template match="hl7:observationCodedEvent/hl7:value">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/ObservationCodedEvent"/>
        </xsl:call-template>
            <xsl:apply-templates/>     </xsl:template>
    
    <!-- observationMeasurableEvent templates (these may be moved into the common element validation file) -->
    <xsl:template match="hl7:observationMeasurableEvent/hl7:id">
        <xsl:call-template name="Identifier_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="expected_OID_List" select="$OIDSet/observationMeasurableEvent"/>
            <xsl:with-param name="msgType" select="$ValidationMsgType"/>
        </xsl:call-template>
            <xsl:apply-templates/>     </xsl:template>
    <xsl:template match="hl7:observationCodedEvent/hl7:code">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/ObservationMeasurableCode"/>
        </xsl:call-template>
            <xsl:apply-templates/>     </xsl:template>
    
    <!-- Knowledgebase -->
    <xsl:template match="hl7:detectedIssueDefinition/hl7:id">
        <xsl:call-template name="Identifier_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="expected_OID_List" select="$OIDSet/detectedIssueDefinition"/>
            <xsl:with-param name="msgType" select="$ValidationMsgType"/>
        </xsl:call-template>
            <xsl:apply-templates/>     </xsl:template>
    
    <!-- Issue Management -->
    <xsl:template match="hl7:detectedIssueManagement/hl7:code">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/ActDetectedIssueManagementCode"/>
        </xsl:call-template>
            <xsl:apply-templates/>     </xsl:template>
    <xsl:template match="hl7:detectedIssueManagement/hl7:statusCode">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/statusCodeIssues"/>
        </xsl:call-template>
            <xsl:apply-templates/>     </xsl:template>
    
</xsl:stylesheet>
