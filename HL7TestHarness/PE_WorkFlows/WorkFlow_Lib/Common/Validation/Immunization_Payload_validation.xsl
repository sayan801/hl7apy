<?xml version="1.0" encoding="UTF-8"?>
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->  <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:hl7="urn:hl7-org:v3" version="2.0">
    <xsl:import href="../Lib/Validation_Lib.xsl"/>
    
    <xsl:template match="text()|@*"/> <!-- override default output of text/attributes -->

    <xsl:template match="hl7:immunization/hl7:id">
        <!-- validate required id element -->
        <xsl:call-template name="Identifier_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="expected_OID">DIS_IMMUNIZATION_ID</xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="hl7:immunization">
            
            <!-- validate required code attribute -->
            <xsl:call-template name="Code_Element_Test"> 
                <xsl:with-param name="nullable">false</xsl:with-param>
                <xsl:with-param name="node" select="hl7:code"/>
                <xsl:with-param name="validCodeSet" select="$CodeSet/codeImmunize"/>
            </xsl:call-template>
                   
        <!-- validate required statusCode, fixed = "COMPLETED" -->
        <xsl:call-template name="Code_Element_Test"> 
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="node" select="hl7:statusCode"/>
            <xsl:with-param name="validCodeSet" select="$CodeSet/statusCodeCompleted"/>
        </xsl:call-template>
        
        <!-- validate required doseQuantity -->
        <xsl:call-template name="Unit_Element_Test">
            <xsl:with-param name="nullable">true</xsl:with-param>
            <xsl:with-param name="node" select="hl7:doseQuantity"/>
            <xsl:with-param name="validCodeSet" select="$CodeSet/x_drugUnitsOfMeasure"/>
        </xsl:call-template>
        
        <xsl:apply-templates/>
        </xsl:template>
    
    <!-- validate optional reasonCode element -->
    <xsl:template match="hl7:immunization/hl7:reasonCode">
        <xsl:value-of select="."/>
        <xsl:call-template name="Code_Element_Test">  
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="validCodeSet"  select="$CodeSet/actNoAdministrationReason"/>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- validate optional routeCode element -->
    <xsl:template match="//hl7:immunization/hl7:routeCode">
        <xsl:call-template name="Code_Element_Test">  
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="validCodeSet"  select="$CodeSet/RouteOfAdministration"/>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- validate optional approachSiteCode element -->
    <xsl:template match="//hl7:immunization/hl7:approachSiteCode">
        <xsl:call-template name="Code_Element_Test">  
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="validCodeSet"  select="$CodeSet/HumanSubstanceAdministrationSite"/>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- validate optional informant element -->
    <xsl:template match="//hl7:immunization/hl7:informant">
        <xsl:call-template name="ClassCode_Element_Test">  
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="node" select="./hl7:informationSourceRole"/>
            <xsl:with-param name="validCodeSet"  select="$CodeSet/x_InformationSource"/>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- validate elements within optional immunizationPlan -->
    <xsl:template match="//hl7:inFulfillmentOf/hl7:immunizationPlan">
        <xsl:call-template name="Code_Element_Test"> <!-- check required immunizationPlan/code -->
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="node" select="hl7:code"/>
            <xsl:with-param name="validCodeSet" select="$CodeSet/codeImmunize"/>
        </xsl:call-template>
        
        <xsl:call-template name="Code_Element_Test"> <!-- check required immunizationPlan/statusCode -->
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="node" select="hl7:statusCode"/>
            <xsl:with-param name="validCodeSet" select="$CodeSet/statusCodeActive"/>
        </xsl:call-template>
        
        <!-- check elements in optional fulfillment element -->
        <xsl:if test="hl7:fulfillment">
            <xsl:call-template name="Code_Element_Test"> <!-- check required immunizationPlan/fulfillment/code -->
                <xsl:with-param name="nullable">false</xsl:with-param>
                <xsl:with-param name="node" select="hl7:fulfillment/hl7:nextPlannedImmunization/hl7:code"/>
                <xsl:with-param name="validCodeSet" select="$CodeSet/codeImmunize"/>
            </xsl:call-template>
            <xsl:call-template name="Code_Element_Test"> <!-- check required immunizationPlan/fulfillment/statusCode -->
                <xsl:with-param name="nullable">false</xsl:with-param>
                <xsl:with-param name="node" select="hl7:fulfillment/hl7:nextPlannedImmunization/hl7:statusCode"/>
                <xsl:with-param name="validCodeSet" select="$CodeSet/statusCodeActive"/>
            </xsl:call-template>
        </xsl:if>
        
        <!-- check elements in optional successor element -->
        <xsl:if test="hl7:successor">
            <xsl:call-template name="Code_Element_Test"> <!-- check required immunizationPlan/successor/nextImmunizationPlan/code -->
                <xsl:with-param name="nullable">false</xsl:with-param>
                <xsl:with-param name="node" select="hl7:successor/hl7:nextImmunizationPlan/hl7:code"/>
                <xsl:with-param name="validCodeSet" select="$CodeSet/codeImmunize"/>
            </xsl:call-template>
            <xsl:call-template name="Code_Element_Test"> <!-- check required immunizationPlan/successor/nextImmunizationPlan/statusCode -->
                <xsl:with-param name="nullable">false</xsl:with-param>
                <xsl:with-param name="node" select="hl7:successor/hl7:nextImmunizationPlan/hl7:statusCode"/>
                <xsl:with-param name="validCodeSet" select="$CodeSet/statusCodeActive"/>
            </xsl:call-template>
        </xsl:if>
        
        <xsl:apply-templates/>
    </xsl:template>
</xsl:stylesheet>
