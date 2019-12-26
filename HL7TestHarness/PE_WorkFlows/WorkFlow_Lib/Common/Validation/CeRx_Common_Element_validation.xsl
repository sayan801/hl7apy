<?xml version="1.0" encoding="UTF-8"?>
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->
<xsl:stylesheet xmlns:hl7="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:import href="../Lib/Validation_Lib.xsl"/>
    <!-- Issue validation is included in the commone element validation -->
    <xsl:include href="CeRx_Issue_Validation.xsl"/>

    <xsl:variable name="Note_Text_empty_ErrorMsg">Annotation text element must contain text</xsl:variable>
    <xsl:variable name="Note_NotesIndicator_False_ErrorMsg">Annotation is present but the query specified notes should only be indicated not included in response. Only the annotationIndicator element is allowed</xsl:variable>
    <xsl:variable name="Note_NotesIndicator_True_ErrorMsg">AnnotationIndicator is present but the query specified that notes should be returned. Only the annotataion elements should be present</xsl:variable>

    <xsl:template match="text()|@*"/>

    <!-- all status code values need to meet the status code set. -->
    <xsl:template match="hl7:statusCode">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/statusCode"/>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="hl7:subject/hl7:patient">
        <xsl:call-template name="Identifier_Element_Test">
            <xsl:with-param name="node" select="./descendant-or-self::node()[local-name() = 'id']"/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="expected_OID_List" select="$OIDSet/patient"/>
            <xsl:with-param name="msgType" select="$ValidationMsgType"/>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>

    <!-- todo: agent/provider -->
    <xsl:template match="hl7:informant/hl7:patient">
        <xsl:call-template name="Identifier_Element_Test">
            <xsl:with-param name="node" select="./hl7:id"/>
            <xsl:with-param name="nullable">true</xsl:with-param>
            <xsl:with-param name="expected_OID_List" select="$OIDSet/informant"/>
            <xsl:with-param name="msgType" select="$ValidationMsgType"/>
        </xsl:call-template>
        <xsl:call-template name="Person_Name_Test">
            <xsl:with-param name="node" select="./descendant-or-self::name"/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="familyRequired">false</xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="hl7:severityObservation/hl7:value">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">true</xsl:with-param>
            <xsl:with-param name="nullFlavor">UNK</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/severityObservation"/>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="hl7:annotation">
        <xsl:if test="hl7:text = '' ">
            <xsl:call-template name="ReportError">
                <xsl:with-param name="ErrorText" select="$Note_Text_empty_ErrorMsg"/>
                <xsl:with-param name="currentNode" select="."/>
                <xsl:with-param name="expectedValue"/>
                <xsl:with-param name="actualValue"/>
            </xsl:call-template>
        </xsl:if>
        <!--
        <xsl:if test="/descendant-or-self::hl7:includeNotesIndicator/hl7:value/@value = 'false'">
            <xsl:call-template name="ReportError">
                <xsl:with-param name="ErrorText" select="$Note_NotesIndicator_False_ErrorMsg"/>
                <xsl:with-param name="currentNode" select="."/>
                <xsl:with-param name="expectedValue"/>
                <xsl:with-param name="actualValue"/>
            </xsl:call-template>
        </xsl:if>
        -->
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="hl7:annotationIndicator">
        <!--
        <xsl:if test="/descendant-or-self::hl7:includeNotesIndicator/hl7:value/@value = 'true'">
            <xsl:call-template name="ReportError">
                <xsl:with-param name="ErrorText" select="$Note_NotesIndicator_True_ErrorMsg"/>
                <xsl:with-param name="currentNode" select="."/>
                <xsl:with-param name="expectedValue"/>
                <xsl:with-param name="actualValue"/>
            </xsl:call-template>
        </xsl:if>
            -->
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="hl7:languageCode">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/languageCode"/>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="hl7:recordTarget/hl7:patient">
        <xsl:call-template name="Identifier_Element_Test">
            <xsl:with-param name="node" select="./hl7:id"/>
            <xsl:with-param name="nullable">true</xsl:with-param>
            <xsl:with-param name="expected_OID_List" select="$OIDSet/patient"/>
            <xsl:with-param name="msgType" select="$ValidationMsgType"/>
        </xsl:call-template>
        <!-- <xsl:call-template name="Person_Name_Test">
            <xsl:with-param name="node" select="./descendant-or-self::hl7:name"/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="familyRequired">false</xsl:with-param>
        </xsl:call-template>
            -->
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="hl7:annotatedAct/hl7:id">
        <xsl:call-template name="Identifier_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="expected_OID_List" select="$OIDSet/annotatedRecord"/>
            <xsl:with-param name="msgType" select="$ValidationMsgType"/>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>


    <xsl:template match="hl7:document/hl7:author">
        <!-- no test needed. -->
    </xsl:template>
    <xsl:template match="hl7:administrationGuideline"> </xsl:template>
    <xsl:template match="hl7:author">
        <xsl:call-template name="Assigned_Person_Test">
            <xsl:with-param name="node" select="./hl7:assignedPerson"/>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>

    <!-- medication validation -->
    <xsl:template match="hl7:player/hl7:code">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">true</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/medication"/>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:player/hl7:expirationTime">
        <xsl:call-template name="EffectiveTime_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="lowAllowed">true</xsl:with-param>
            <xsl:with-param name="highAllowed">true</xsl:with-param>
            <xsl:with-param name="widthAllowed">true</xsl:with-param>
            <xsl:with-param name="centerAllowed">true</xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:player/hl7:formCode">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/OrderableDrugForm"/>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:containerPackagedMedicine/hl7:formCode">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/CompliancePackageEntityType"/>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:player/hl7:asContent/hl7:quantity">
        <xsl:call-template name="Unit_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/x_drugUnitsOfMeasure"/>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:ingredient/hl7:id">
        <xsl:call-template name="Identifier_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="expected_OID_List" select="$OIDSet/ActiveIngredientDrugEntityType"/>
            <xsl:with-param name="msgType" select="$ValidationMsgType"/>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:ingredient/hl7:quantity">
        <xsl:call-template name="Unit_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/x_drugUnitsOfMeasure"/>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>

    <!-- exposure event validation -->
    <xsl:template match="hl7:startsAfterStartOf/hl7:exposureEvent">
        <!-- either ID or the other info but not both. (unless this is a response from the server) -->
        <xsl:choose>
            <xsl:when test="./hl7:id">
                <xsl:call-template name="Identifier_Element_Test">
                    <xsl:with-param name="node" select="./hl7:id"/>
                    <xsl:with-param name="nullable">false</xsl:with-param>
                    <xsl:with-param name="expected_OID_List" select="$OIDSet/exposureEvent"/>
                </xsl:call-template>
                <xsl:if test="not($ValidationMsgType = 'serverMsg') and count(./*) > 1">
                    <xsl:call-template name="ReportError">
                        <xsl:with-param name="ErrorText" select="$Extra_elements_ErrorMsg"/>
                        <xsl:with-param name="currentNode" select="."/>
                        <xsl:with-param name="elementName"/>
                        <xsl:with-param name="expectedValue">id</xsl:with-param>
                        <xsl:with-param name="actualValue">
                            <xsl:for-each select="./*">
                                <xsl:value-of select="local-name()"/>
                                <xsl:text>; </xsl:text>
                            </xsl:for-each>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="Required_ChildElement_Test">
                    <xsl:with-param name="node" select="."/>
                    <xsl:with-param name="nullable">false</xsl:with-param>
                    <xsl:with-param name="child_element_name">routeCode</xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="Required_ChildElement_Test">
                    <xsl:with-param name="node" select="."/>
                    <xsl:with-param name="nullable">false</xsl:with-param>
                    <xsl:with-param name="child_element_name">consumable</xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="./descendant-or-self::hl7:code">
            <xsl:call-template name="Code_Element_Test">
                <xsl:with-param name="node" select="./descendant-or-self::hl7:code[1]"/>
                <xsl:with-param name="nullable">false</xsl:with-param>
                <xsl:with-param name="validCodeSet" select="$CodeSet/ExposureAgentEntityType"/>
                <xsl:with-param name="codeSystemRequired">true</xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>

    <!-- dosage Instructions -->
    <xsl:template match="hl7:dosagenstruction/hl7:code">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/dosageCode"/>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:dosagenstruction/hl7:effectiveTime">
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
    <xsl:template match="hl7:dosagenstruction/hl7:routeCode">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/RouteOfAdministration"/>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:dosagenstruction/hl7:approachSiteCode">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/HumanSubstanceAdministrationSite"/>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:dosageInstruction/hl7:maxDoseQuantity/hl7:denominator">
        <xsl:call-template name="Unit_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/maxDosageDenominatorUnit"/>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:dosagenstruction/hl7:administrationUnitCode">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/AdministrableDrugForm"/>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>

    <!-- supplyEvent validation -->
    <xsl:template match="hl7:supplyEvent/hl7:id">
        <xsl:call-template name="Identifier_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="expected_OID_List" select="$OIDSet/supplyEvent"/>
            <xsl:with-param name="msgType" select="$ValidationMsgType"/>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:supplyEvent/hl7:code">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/ActPharmacySupplyType"/>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:supplyEvent/hl7:effectiveTime">
        <xsl:call-template name="EffectiveTime_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">true</xsl:with-param>
            <xsl:with-param name="lowAllowed">true</xsl:with-param>
            <xsl:with-param name="highAllowed">true</xsl:with-param>
            <xsl:with-param name="widthAllowed">false</xsl:with-param>
            <xsl:with-param name="centerAllowed">false</xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>

    <!-- NECST Messages -->
    <xsl:template match="hl7:queryAck/hl7:statusCode">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/NeCSTQueryAckStatusCode"/>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>


</xsl:stylesheet>
