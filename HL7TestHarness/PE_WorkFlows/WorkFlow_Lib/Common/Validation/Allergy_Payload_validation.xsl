<?xml version="1.0" encoding="UTF-8"?>
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->  <xsl:stylesheet xmlns:hl7="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:import href="../Lib/Validation_Lib.xsl"/>

    <xsl:template match="text()|@*"/>


    <xsl:template match="*">
        <xsl:apply-templates/>
    </xsl:template>


    <xsl:template match="hl7:intoleranceCondition">

        <xsl:call-template name="Required_Attr_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="attr_name">negationInd</xsl:with-param>
        </xsl:call-template>

        <!--
        <xsl:call-template name="Required_ChildElement_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="child_element_name">effectiveTime</xsl:with-param>
        </xsl:call-template>
            -->

        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="hl7:intoleranceCondition/hl7:code">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/ObservationIntoleranceType"/>
            <xsl:with-param name="codeSystemRequired">true</xsl:with-param>
        </xsl:call-template>
         <xsl:apply-templates/> 
    </xsl:template>

    <!-- statusCode is tested by common validation, this only needs to be tested here is the statusCode is retricted
          beyond the statusCode code set.
    <xsl:template match="hl7:intoleranceCondition/hl7:statusCode">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/statusCode"/>
        </xsl:call-template>
            <xsl:apply-templates/>     </xsl:template>
    -->
    <xsl:template match="hl7:intoleranceCondition/hl7:effectiveTime">
        <xsl:call-template name="Required_Attr_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="attr_name">value</xsl:with-param>
        </xsl:call-template>
         <xsl:apply-templates/> 
    </xsl:template>

    <xsl:template match="hl7:intoleranceCondition/hl7:uncertaintyCode">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/uncertaintyCode"/>
        </xsl:call-template>
         <xsl:apply-templates/> 
    </xsl:template>

    <xsl:template match="hl7:intoleranceCondition/hl7:value">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/IntoleranceValue"/>
            <xsl:with-param name="codeSystemRequired">true</xsl:with-param>
        </xsl:call-template>
         <xsl:apply-templates/> 
    </xsl:template>


    <xsl:template match="hl7:intoleranceCondition/hl7:support/hl7:causalityAssessment/hl7:subject/hl7:observationEvent">
        <!-- either ID or the other info but not both. -->
        <xsl:choose>
            <xsl:when test="hl7:id">
                <xsl:call-template name="Identifier_Element_Test">
                    <xsl:with-param name="node" select="./hl7:id"/>
                    <xsl:with-param name="nullable">false</xsl:with-param>
                    <xsl:with-param name="expected_OID">DIS_REACTION_ID</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="Required_ChildElement_Test">
                    <xsl:with-param name="node" select="."/>
                    <xsl:with-param name="nullable">false</xsl:with-param>
                    <xsl:with-param name="child_element_name">value</xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="hl7:value">
            <xsl:call-template name="Code_Element_Test">
                <xsl:with-param name="node" select="./hl7:value"/>
                <xsl:with-param name="nullable">false</xsl:with-param>
                <xsl:with-param name="validCodeSet" select="$CodeSet/reactionValue"/>
                <xsl:with-param name="codeSystemRequired">true</xsl:with-param>
            </xsl:call-template>
        </xsl:if>
         <xsl:apply-templates/> 
    </xsl:template>

    <xsl:template match="hl7:intoleranceCondition/hl7:support/hl7:allergyTestEvent/hl7:code">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/ObservationAllergyTestType"/>
        </xsl:call-template>
         <xsl:apply-templates/> 
    </xsl:template>

    <xsl:template match="hl7:intoleranceCondition/hl7:support/hl7:allergyTestEvent/hl7:value">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/AllergyTestValue"/>
        </xsl:call-template>
         <xsl:apply-templates/> 
    </xsl:template>

</xsl:stylesheet>
