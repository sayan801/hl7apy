<?xml version="1.0" encoding="UTF-8"?>
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->
<xsl:stylesheet xmlns:hl7="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:import href="../Lib/Validation_Lib.xsl"/>

    <xsl:template match="text()|@*"/>

    <xsl:template match="node()">
        <xsl:apply-templates/>
    </xsl:template>


    <xsl:template match="hl7:PORX_IN010380CA/hl7:controlActEvent/hl7:author/hl7:assignedPerson">
        <!-- 
            validate that the add prescription message author is a valid prescriber, if a pharmacy enters the rx
            they must enter the prescriber as the author.
        -->

        <xsl:call-template name="Identifier_Element_Test">
            <xsl:with-param name="node" select="hl7:id"/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="expected_OID_List" select="$OIDSet/prescribers"/>
        </xsl:call-template>

    </xsl:template>

    <xsl:template match="hl7:combinedMedicationRequest">

        <xsl:call-template name="Required_ChildElement_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="child_element_name">precondition</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="MaxAllowed_ChildElement_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="child_element_name">pertinentInformation</xsl:with-param>
            <xsl:with-param name="child_element_min">0</xsl:with-param>
            <xsl:with-param name="child_element_max">2</xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="hl7:combinedMedicationRequest/hl7:code">

        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/prescriptionCode"/>
            <xsl:with-param name="codeSystemRequired">false</xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:combinedMedicationRequest/hl7:statusCode">
        <xsl:choose>
            <xsl:when test="$mapping='toServer'">
                <xsl:call-template name="Code_Element_Test">
                    <xsl:with-param name="node" select="."/>
                    <xsl:with-param name="nullable">false</xsl:with-param>
                    <xsl:with-param name="validCodeSet" select="$CodeSet/statusCodePrescription"/>
                    <xsl:with-param name="codeSystemRequired">false</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="Code_Element_Test">
                    <xsl:with-param name="node" select="."/>
                    <xsl:with-param name="nullable">false</xsl:with-param>
                    <xsl:with-param name="validCodeSet" select="$CodeSet/statusCode"/>
                    <xsl:with-param name="codeSystemRequired">false</xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="hl7:observationDiagnosis">
        <xsl:call-template name="Required_ChildElement_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="child_element_name">value</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="hl7:code"/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/observationDiagnosisCode"/>
            <xsl:with-param name="codeSystemRequired">false</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="hl7:statusCode"/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/statusCodeCompleted"/>
            <xsl:with-param name="codeSystemRequired">false</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="hl7:value"/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/ObservationDiagnosisValue"/>
            <xsl:with-param name="codeSystemRequired">true</xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:observationSymptom">
        <xsl:call-template name="Required_ChildElement_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="child_element_name">value</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="hl7:code"/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/observationSymptomCode"/>
            <xsl:with-param name="codeSystemRequired">false</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="hl7:statusCode"/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/statusCodeCompleted"/>
            <xsl:with-param name="codeSystemRequired">false</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="hl7:value"/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/ObservationSymptomValue"/>
            <xsl:with-param name="codeSystemRequired">true</xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates/>

    </xsl:template>
    <xsl:template match="hl7:otherIndication">
        <xsl:if test="not(@nullFlavor)">
            <xsl:call-template name="Required_ChildElement_Test">
                <xsl:with-param name="node" select="."/>
                <xsl:with-param name="nullable">true</xsl:with-param>
                <xsl:with-param name="child_element_name">code</xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="hl7:code"/>
            <xsl:with-param name="nullable">true</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/ActNonConditionIndicationCode"/>
            <xsl:with-param name="codeSystemRequired">true</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="hl7:statusCode"/>
            <xsl:with-param name="nullable">true</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/statusCodeCompleted"/>
            <xsl:with-param name="codeSystemRequired">false</xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:precondition/hl7:verificationEventCriterion/hl7:code">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/PrescriptionAuthoritativeCode"/>
            <xsl:with-param name="codeSystemRequired">false</xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:pertinentInformation/hl7:quantityObservationEvent">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="hl7:code"/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/x_ActObservationHeightOrWeight"/>
            <xsl:with-param name="codeSystemRequired">true</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="Unit_Element_Test">
            <xsl:with-param name="node" select="hl7:value"/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="unit_required">false</xsl:with-param>
            <xsl:with-param name="value_required">true</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/x_ActObservationHeightOrWeightUnits"/>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:trialSupplyPermission/hl7:code">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/trialSupplyPermission"/>
            <xsl:with-param name="codeSystemRequired">false</xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:supplyRequest/hl7:effectiveTime">
        <xsl:call-template name="EffectiveTime_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="lowAllowed">true</xsl:with-param>
            <xsl:with-param name="highAllowed">true</xsl:with-param>
            <xsl:with-param name="widthAllowed">false</xsl:with-param>
            <xsl:with-param name="centerAllowed">false</xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:supplyRequestItem/hl7:quantity">
        <xsl:call-template name="Unit_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="unit_required">false</xsl:with-param>
            <xsl:with-param name="value_required">true</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/x_drugUnitsOfMeasure"/>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:supplyRequestItem/hl7:expectedUseTime">
        <xsl:call-template name="EffectiveTime_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="widthRequired">true</xsl:with-param>
            <xsl:with-param name="lowAllowed">false</xsl:with-param>
            <xsl:with-param name="highAllowed">false</xsl:with-param>
            <xsl:with-param name="widthAllowed">true</xsl:with-param>
            <xsl:with-param name="centerAllowed">false</xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:subsequentSupplyRequest/hl7:effectiveTime">
        <xsl:call-template name="EffectiveTime_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="widthRequired">true</xsl:with-param>
            <xsl:with-param name="lowAllowed">false</xsl:with-param>
            <xsl:with-param name="highAllowed">false</xsl:with-param>
            <xsl:with-param name="widthAllowed">true</xsl:with-param>
            <xsl:with-param name="centerAllowed">false</xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:subsequentSupplyRequest/hl7:expectedUseTime">
        <xsl:call-template name="EffectiveTime_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="widthRequired">true</xsl:with-param>
            <xsl:with-param name="lowAllowed">false</xsl:with-param>
            <xsl:with-param name="highAllowed">false</xsl:with-param>
            <xsl:with-param name="widthAllowed">true</xsl:with-param>
            <xsl:with-param name="centerAllowed">false</xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:subsequentSupplyRequest/hl7:quantity">
        <xsl:call-template name="Unit_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="unit_required">false</xsl:with-param>
            <xsl:with-param name="value_required">true</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/x_drugUnitsOfMeasure"/>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:subsequentSupplyRequest">
        <xsl:call-template name="Required_ChildElement_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="child_element_name">repeatNumber</xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:initialSupplyRequest/hl7:effectiveTime">
        <xsl:call-template name="EffectiveTime_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="lowAllowed">true</xsl:with-param>
            <xsl:with-param name="highAllowed">true</xsl:with-param>
            <xsl:with-param name="widthAllowed">true</xsl:with-param>
            <xsl:with-param name="centerAllowed">false</xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:initialSupplyRequest/hl7:expectedUseTime">
        <xsl:call-template name="EffectiveTime_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="widthRequired">true</xsl:with-param>
            <xsl:with-param name="lowAllowed">false</xsl:with-param>
            <xsl:with-param name="highAllowed">false</xsl:with-param>
            <xsl:with-param name="widthAllowed">true</xsl:with-param>
            <xsl:with-param name="centerAllowed">false</xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:initialSupplyRequest/hl7:quantity">
        <xsl:call-template name="Unit_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="unit_required">false</xsl:with-param>
            <xsl:with-param name="value_required">true</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/x_drugUnitsOfMeasure"/>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:substitutionPermission">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="hl7:code"/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/ActSubstanceAdminSubstitutionCode"/>
            <xsl:with-param name="codeSystemRequired">false</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="hl7:reasonCode"/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/SubstanceAdminSubstitutionNotAllowedReason"/>
            <xsl:with-param name="codeSystemRequired">false</xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:workingListEvent/hl7:code">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">true</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/ActTherapyDurationWorkingListCode"/>
            <xsl:with-param name="codeSystemRequired">false</xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>


</xsl:stylesheet>
