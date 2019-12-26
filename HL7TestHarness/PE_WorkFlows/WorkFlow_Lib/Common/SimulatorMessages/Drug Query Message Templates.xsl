<?xml version="1.0" encoding="UTF-8"?>
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="urn:hl7-org:v3" xmlns:hl7="urn:hl7-org:v3" version="1.0">
    <xsl:include href="../Lib/MsgCreation_Lib.xsl"/>

    <!-- Query Request Messages -->
    <!-- TODO: create response messages -->
    <!-- drug search query  -->
    <xsl:template name="drugSearchQueryRequest">
        <xsl:param name="msg-effective-time"/>
        <xsl:param name="author-description"/>
        <xsl:param name="supervisor-description"/>
        <xsl:param name="location-description"/>
        <xsl:param name="ParticipationMode"/>
        <xsl:param name="author-time"/>

        <xsl:param name="characteristic-01-value"/>
        <xsl:param name="characteristic-01-code"/>
        <xsl:param name="characteristic-01-codeSystem"/>
        <xsl:param name="characteristic-02-value"/>
        <xsl:param name="characteristic-02-code"/>
        <xsl:param name="characteristic-02-codeSystem"/>
        <xsl:param name="characteristic-03-value"/>
        <xsl:param name="characteristic-03-code"/>
        <xsl:param name="characteristic-03-codeSystem"/>
        <xsl:param name="characteristic-04-value"/>
        <xsl:param name="characteristic-04-code"/>
        <xsl:param name="characteristic-04-codeSystem"/>
        <xsl:param name="characteristic-05-value"/>
        <xsl:param name="characteristic-05-code"/>
        <xsl:param name="characteristic-05-codeSystem"/>
        <xsl:param name="drug-code"/>
        <xsl:param name="drug-codeSystem"/>
        <xsl:param name="drug-form"/>
        <xsl:param name="drug-formSystem"/>
        <xsl:param name="manufacturer"/>
        <xsl:param name="drug-name"/>
        <xsl:param name="drug-route"/>
        <xsl:param name="drug-routeSystem"/>

        <xsl:param name="query-id"/>

        <xsl:variable name="msgType">clientMsg</xsl:variable>
        <xsl:variable name="msgAction">queryRequest</xsl:variable>

        <POME_IN010070CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">POME_IN010070CA</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <controlActEvent classCode="CACT" moodCode="EVN">
                <xsl:call-template name="controlActStart">
                    <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                    <xsl:with-param name="author-description" select="$author-description"/>
                    <xsl:with-param name="location-description" select="$location-description"/>
                    <xsl:with-param name="author-time" select="$author-time"/>
                    <xsl:with-param name="ParticipationMode" select="$ParticipationMode"/>
                    <xsl:with-param name="TriggerEventCode">POME_TE010100UV</xsl:with-param>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="msgAction" select="$msgAction"/>
                </xsl:call-template>

                <queryByParameter>
                    <xsl:choose>
                        <xsl:when test="$query-id">
                            <queryId>
                                <xsl:attribute name="root">
                                    <xsl:call-template name="getOIDRootByName">
                                        <xsl:with-param name="OID_Name">PORTAL_QUERY_ID</xsl:with-param>
                                        <xsl:with-param name="msgType" select="$msgType"/>
                                    </xsl:call-template>
                                </xsl:attribute>
                                <xsl:attribute name="extension">
                                    <xsl:value-of select="$query-id"/>
                                </xsl:attribute>
                            </queryId>
                        </xsl:when>
                        <xsl:otherwise>
                            <queryId>
                                <xsl:call-template name="nullFlavor"/>
                            </queryId>
                        </xsl:otherwise>
                    </xsl:choose>
                    <parameterList>
                        <!-- 0..5 elements Used to hold characteristic type and value pair as one set of query parameter item -->
                        <xsl:if test="$characteristic-01-value and $characteristic-01-code">
                            <xsl:call-template name="drugCharacteristics">
                                <xsl:with-param name="value" select="$characteristic-01-value"/>
                                <xsl:with-param name="code" select="$characteristic-01-code"/>
                                <xsl:with-param name="codeSystem" select=" $characteristic-01-codeSystem"/>
                                        <xsl:with-param name="msgType" select="$msgType"/>
                            </xsl:call-template>
                        </xsl:if>
                        <xsl:if test="$characteristic-02-value and $characteristic-02-code">
                            <xsl:call-template name="drugCharacteristics">
                                <xsl:with-param name="value" select="$characteristic-02-value"/>
                                <xsl:with-param name="code" select="$characteristic-02-code"/>
                                <xsl:with-param name="codeSystem" select=" $characteristic-02-codeSystem"/>
                                        <xsl:with-param name="msgType" select="$msgType"/>
                            </xsl:call-template>
                        </xsl:if>
                        <xsl:if test="$characteristic-03-value and $characteristic-03-code">
                            <xsl:call-template name="drugCharacteristics">
                                <xsl:with-param name="value" select="$characteristic-03-value"/>
                                <xsl:with-param name="code" select="$characteristic-03-code"/>
                                <xsl:with-param name="codeSystem" select=" $characteristic-03-codeSystem"/>
                                        <xsl:with-param name="msgType" select="$msgType"/>
                            </xsl:call-template>
                        </xsl:if>
                        <xsl:if test="$characteristic-04-value and $characteristic-04-code">
                            <xsl:call-template name="drugCharacteristics">
                                <xsl:with-param name="value" select="$characteristic-04-value"/>
                                <xsl:with-param name="code" select="$characteristic-04-code"/>
                                <xsl:with-param name="codeSystem" select=" $characteristic-04-codeSystem"/>
                                        <xsl:with-param name="msgType" select="$msgType"/>
                            </xsl:call-template>
                        </xsl:if>
                        <xsl:if test="$characteristic-05-value and $characteristic-05-code">
                            <xsl:call-template name="drugCharacteristics">
                                <xsl:with-param name="value" select="$characteristic-05-value"/>
                                <xsl:with-param name="code" select="$characteristic-05-code"/>
                                <xsl:with-param name="codeSystem" select=" $characteristic-05-codeSystem"/>
                                        <xsl:with-param name="msgType" select="$msgType"/>
                            </xsl:call-template>
                        </xsl:if>

                        <!-- optional identifier for a type of drug. Types of drugs include: Manufactured drug, generic formulation, generic, therapeutic class, etc -->
                        <xsl:if test="$drug-code">
                            <xsl:call-template name="drugCode">
                                <xsl:with-param name="code" select="$drug-code"/>
                                <xsl:with-param name="codeSystem" select="$drug-codeSystem"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                            </xsl:call-template>
                        </xsl:if>


                        <!-- optional element to indicates the form in which the drug product must is manufactured. -->
                        <xsl:if test="$drug-form">
                            <drugForm>
                                <value>
                                    <xsl:attribute name="code">
                                        <xsl:value-of select="$drug-form"/>
                                    </xsl:attribute>
                                    <xsl:if test="$drug-formSystem">
                                        <xsl:attribute name="codeSystem">
                                    <xsl:call-template name="getOIDRootByName">
                                        <xsl:with-param name="OID_Name"> <xsl:value-of select="$drug-formSystem"/></xsl:with-param>
                                        <xsl:with-param name="msgType" select="$msgType"/>
                                    </xsl:call-template>
                                        </xsl:attribute>
                                    </xsl:if>
                                </value>
                            </drugForm>
                        </xsl:if>
                        <!-- optional element to search by manufacturer name - Manufacturer name search will be 'Starts with ..' type of a search -->
                        <xsl:if test="$manufacturer">
                            <drugManufacturerName>
                                <value>
                                    <xsl:value-of select="$manufacturer"/>
                                </value>
                            </drugManufacturerName>
                        </xsl:if>
                        <!-- optional element to search by the name assigned to a drug. -->
                        <xsl:if test="$drug-name">
                            <drugName>
                                <value>
                                    <xsl:value-of select="$drug-name"/>
                                </value>
                            </drugName>
                        </xsl:if>
                        <!-- optional element for a filter based on how the drug should be introduced into the patient's body (e.g. Oral, topical, etc.) - RouteOfAdministration -->
                        <xsl:if test="$drug-route">
                            <drugRoute>
                                <value>
                                    <xsl:attribute name="code">
                                        <xsl:value-of select="$drug-route"/>
                                    </xsl:attribute>
                                    <xsl:if test="$drug-routeSystem">
                                        <xsl:attribute name="codeSystem">
                                    <xsl:call-template name="getOIDRootByName">
                                        <xsl:with-param name="OID_Name"> <xsl:value-of select="$drug-routeSystem"/></xsl:with-param>
                                        <xsl:with-param name="msgType" select="$msgType"/>
                                    </xsl:call-template>
                                        </xsl:attribute>
                                    </xsl:if>
                                </value>
                            </drugRoute>
                        </xsl:if>
                    </parameterList>
                </queryByParameter>

            </controlActEvent>


            <xsl:call-template name="transmissionWrapperEnd">
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

        </POME_IN010070CA>


    </xsl:template>
    <!-- drug detail query  -->
    <xsl:template name="drugDetailQueryRequest">
        <xsl:param name="msg-effective-time"/>
        <xsl:param name="author-description"/>
        <xsl:param name="supervisor-description"/>
        <xsl:param name="location-description"/>
        <xsl:param name="ParticipationMode"/>
        <xsl:param name="author-time"/>
        <xsl:param name="drug-code"/>
        <xsl:param name="drug-codeSystem"/>
        <xsl:param name="query-id"/>

        <xsl:variable name="msgType">clientMsg</xsl:variable>
        <xsl:variable name="msgAction">queryRequest</xsl:variable>

        <POME_IN010050CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">POME_IN010050CA</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <controlActEvent classCode="CACT" moodCode="EVN">
                <xsl:call-template name="controlActStart">
                    <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                    <xsl:with-param name="author-description" select="$author-description"/>
                    <xsl:with-param name="location-description" select="$location-description"/>
                    <xsl:with-param name="author-time" select="$author-time"/>
                    <xsl:with-param name="ParticipationMode" select="$ParticipationMode"/>
                    <xsl:with-param name="TriggerEventCode">POME_TE010070UV</xsl:with-param>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="msgAction" select="$msgAction"/>
                </xsl:call-template>

                <queryByParameter>
                    <xsl:choose>
                        <xsl:when test="$query-id">
                            <queryId>
                                <xsl:attribute name="root">
                                    <xsl:call-template name="getOIDRootByName">
                                        <xsl:with-param name="OID_Name">PORTAL_QUERY_ID</xsl:with-param>
                                        <xsl:with-param name="msgType" select="$msgType"/>
                                    </xsl:call-template>
                                </xsl:attribute>
                                <xsl:attribute name="extension">
                                    <xsl:value-of select="$query-id"/>
                                </xsl:attribute>
                            </queryId>
                        </xsl:when>
                        <xsl:otherwise>
                            <queryId>
                                <xsl:call-template name="nullFlavor"/>
                            </queryId>
                        </xsl:otherwise>
                    </xsl:choose>
                    <parameterList>
                        <!-- An identifier for a specific drug product. Types of drugs identified by drug code include: Manufactured drug, generic formulation, generic, therapeutic class, etc. -->
                            <xsl:call-template name="drugCode">
                                <xsl:with-param name="code" select="$drug-code"/>
                                <xsl:with-param name="codeSystem" select="$drug-codeSystem"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                            </xsl:call-template>
                   </parameterList>
                </queryByParameter>

            </controlActEvent>


            <xsl:call-template name="transmissionWrapperEnd">
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

        </POME_IN010050CA>


    </xsl:template>
    <!-- drug document search query  -->
    <xsl:template name="drugDocumentQueryRequest">
        <xsl:param name="msg-effective-time"/>
        <xsl:param name="author-description"/>
        <xsl:param name="supervisor-description"/>
        <xsl:param name="location-description"/>
        <xsl:param name="ParticipationMode"/>
        <xsl:param name="author-time"/>
        <xsl:param name="drug-code"/>
        <xsl:param name="drug-codeSystem"/>
        <xsl:param name="symptom-code"/>
        <xsl:param name="symptom-codeSystem"/>
        <xsl:param name="diagnosis-code"/>
        <xsl:param name="diagnosis-codeSystem"/>
        <xsl:param name="document-type"/>
        <xsl:param name="document-typeSystem"/>
        <xsl:param name="document-id"/>
        <xsl:param name="document-OID"/>

        <xsl:param name="query-id"/>

        <xsl:variable name="msgType">clientMsg</xsl:variable>
        <xsl:variable name="msgAction">queryRequest</xsl:variable>

        <POME_IN010010CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">POME_IN010010CA</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <controlActEvent classCode="CACT" moodCode="EVN">
                <xsl:call-template name="controlActStart">
                    <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                    <xsl:with-param name="author-description" select="$author-description"/>
                    <xsl:with-param name="location-description" select="$location-description"/>
                    <xsl:with-param name="author-time" select="$author-time"/>
                    <xsl:with-param name="ParticipationMode" select="$ParticipationMode"/>
                    <xsl:with-param name="TriggerEventCode">POME_TE010090UV</xsl:with-param>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="msgAction" select="$msgAction"/>
                </xsl:call-template>

                <queryByParameter>
                    <xsl:choose>
                        <xsl:when test="$query-id">
                            <queryId>
                                <xsl:attribute name="root">
                                    <xsl:call-template name="getOIDRootByName">
                                        <xsl:with-param name="OID_Name">PORTAL_QUERY_ID</xsl:with-param>
                                        <xsl:with-param name="msgType" select="$msgType"/>
                                    </xsl:call-template>
                                </xsl:attribute>
                                <xsl:attribute name="extension">
                                    <xsl:value-of select="$query-id"/>
                                </xsl:attribute>
                            </queryId>
                        </xsl:when>
                        <xsl:otherwise>
                            <queryId>
                                <xsl:call-template name="nullFlavor"/>
                            </queryId>
                        </xsl:otherwise>
                    </xsl:choose>
                    <parameterList>
                        <!-- all params are optional: One and only one of Drug Code, Prescribing Indication Code, or Medication Document ID must be specified -->

                        <!-- An identifier for a type of drug. Types of drugs include: Manufactured drug, generic formulation, generic, therapeutic class, etc  -->
                        <xsl:if test="$drug-code">
                            <xsl:call-template name="drugCode">
                                <xsl:with-param name="code" select="$drug-code"/>
                                <xsl:with-param name="codeSystem" select="$drug-codeSystem"/>
                                 <xsl:with-param name="msgType" select="$msgType"/>
                           </xsl:call-template>
                        </xsl:if>


                        <!-- Unique identifier for a particular medication document. This will reference a specific kind of documentation
                     (e.g. DDI Monograph, Patient Education Monograph, Allergy Monograph, etc) created by a specific author organization (e.g. Health Canada, FDB, WHO, etc) -->
                        <!-- root identifies our knowledge base identifier -->
                        <xsl:if test="$document-id and $document-OID">
                            <medicationDocumentID>
                                <value>
                                    <xsl:attribute name="root">
                                        <xsl:call-template name="getOIDRootByName">
                                            <xsl:with-param name="OID_Name">
                                                <xsl:value-of select="$document-OID"/>
                                            </xsl:with-param>
                                            <xsl:with-param name="msgType" select="$msgType"/>
                                        </xsl:call-template>
                                    </xsl:attribute>
                                    <xsl:attribute name="extension">
                                        <xsl:value-of select="$document-id"/>
                                    </xsl:attribute>
                                </value>
                            </medicationDocumentID>
                        </xsl:if>

                        <!-- Indicates that the result set is to be filtered to include only those medication documents pertaining to the specified document category.
				    Valid medication document categories include: Drug Monograph, Contraindication Monograph, Indication Protocol,  etc  ActMedicationDocumentCode vocab -->
                        <xsl:if test="$document-type">
                            <medicationDocumentType>
                                <value>
                                    <xsl:attribute name="code">
                                        <xsl:value-of select="$document-type"/>
                                    </xsl:attribute>
                                    <xsl:if test="$document-typeSystem">
                                        <xsl:attribute name="codeSystem">
                                    <xsl:call-template name="getOIDRootByName">
                                        <xsl:with-param name="OID_Name"> <xsl:value-of select="$document-typeSystem"/></xsl:with-param>
                                        <xsl:with-param name="msgType" select="$msgType"/>
                                    </xsl:call-template>
                                        </xsl:attribute>
                                    </xsl:if>
                                </value>
                            </medicationDocumentType>
                        </xsl:if>

                        <!-- Returns documents which relate to a particular diagnosis code : IndicationValue vocab -->
                        <!-- i.e. an ICD10 code - need OIDs for ICD10 -->
                        <xsl:if test="$diagnosis-code">
                            <prescribingDiagnosisCode>
                                <value>
                                    <xsl:attribute name="code">
                                        <xsl:value-of select="$diagnosis-code"/>
                                    </xsl:attribute>
                                    <xsl:if test="$diagnosis-codeSystem">
                                        <xsl:attribute name="codeSystem">
                                    <xsl:call-template name="getOIDRootByName">
                                        <xsl:with-param name="OID_Name"> <xsl:value-of select="$diagnosis-codeSystem"/></xsl:with-param>
                                        <xsl:with-param name="msgType" select="$msgType"/>
                                    </xsl:call-template>
                                        </xsl:attribute>
                                    </xsl:if>
                                </value>
                            </prescribingDiagnosisCode>
                        </xsl:if>

                        <!-- Returns documents which relate to a particular symptom code code : Encode FM or SNOMED vocab -->
                        <!-- need OIDs for Encode FM and SNOMED -->
                        <xsl:if test="$symptom-code">
                            <prescribingSymptomCode>
                                <value>
                                    <xsl:attribute name="code">
                                        <xsl:value-of select="$symptom-code"/>
                                    </xsl:attribute>
                                    <xsl:if test="$symptom-codeSystem">
                                        <xsl:attribute name="codeSystem">
                                    <xsl:call-template name="getOIDRootByName">
                                        <xsl:with-param name="OID_Name"> <xsl:value-of select="$symptom-codeSystem"/></xsl:with-param>
                                        <xsl:with-param name="msgType" select="$msgType"/>
                                    </xsl:call-template>
                                        </xsl:attribute>
                                    </xsl:if>
                                </value>
                            </prescribingSymptomCode>
                        </xsl:if>

                    </parameterList>

                </queryByParameter>

            </controlActEvent>


            <xsl:call-template name="transmissionWrapperEnd">
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

        </POME_IN010010CA>


    </xsl:template>
    <!-- drug contraindications query -->
    <xsl:template name="drugContrainDicationsQueryRequest">
        <xsl:param name="msg-effective-time"/>
        <xsl:param name="author-description"/>
        <xsl:param name="supervisor-description"/>
        <xsl:param name="location-description"/>
        <xsl:param name="ParticipationMode"/>
        <xsl:param name="author-time"/>

        <xsl:param name="drug-01-code"/>
        <xsl:param name="drug-01-codeSystem"/>
        <xsl:param name="drug-02-code"/>
        <xsl:param name="drug-02-codeSystem"/>
        <xsl:param name="drug-03-code"/>
        <xsl:param name="drug-03-codeSystem"/>
        <xsl:param name="drug-04-code"/>
        <xsl:param name="drug-04-codeSystem"/>
        <xsl:param name="drug-05-code"/>
        <xsl:param name="drug-05-codeSystem"/>
        <xsl:param name="drug-06-code"/>
        <xsl:param name="drug-06-codeSystem"/>
        <xsl:param name="drug-07-code"/>
        <xsl:param name="drug-07-codeSystem"/>
        <xsl:param name="drug-08-code"/>
        <xsl:param name="drug-08-codeSystem"/>
        <xsl:param name="drug-09-code"/>
        <xsl:param name="drug-09-codeSystem"/>
        <xsl:param name="drug-10-code"/>
        <xsl:param name="drug-10-codeSystem"/>
        <xsl:param name="drug-11-code"/>
        <xsl:param name="drug-11-codeSystem"/>
        <xsl:param name="drug-12-code"/>
        <xsl:param name="drug-12-codeSystem"/>
        <xsl:param name="drug-13-code"/>
        <xsl:param name="drug-13-codeSystem"/>
        <xsl:param name="drug-14-code"/>
        <xsl:param name="drug-14-codeSystem"/>
        <xsl:param name="drug-15-code"/>
        <xsl:param name="drug-15-codeSystem"/>
        <xsl:param name="drug-16-code"/>
        <xsl:param name="drug-16-codeSystem"/>
        <xsl:param name="drug-17-code"/>
        <xsl:param name="drug-17-codeSystem"/>
        <xsl:param name="drug-18-code"/>
        <xsl:param name="drug-18-codeSystem"/>
        <xsl:param name="drug-19-code"/>
        <xsl:param name="drug-19-codeSystem"/>
        <xsl:param name="drug-20-code"/>
        <xsl:param name="drug-20-codeSystem"/>

        <xsl:param name="query-id"/>

        <xsl:variable name="msgType">clientMsg</xsl:variable>
        <xsl:variable name="msgAction">queryRequest</xsl:variable>

        <PORX_IN050010CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">PORX_IN050010CA</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <controlActEvent classCode="CACT" moodCode="EVN">
                <xsl:call-template name="controlActStart">
                    <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                    <xsl:with-param name="author-description" select="$author-description"/>
                    <xsl:with-param name="location-description" select="$location-description"/>
                    <xsl:with-param name="author-time" select="$author-time"/>
                    <xsl:with-param name="ParticipationMode" select="$ParticipationMode"/>
                    <xsl:with-param name="TriggerEventCode">PORX_TE050080UV</xsl:with-param>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="msgAction" select="$msgAction"/>
                </xsl:call-template>

                <queryByParameter>
                    <xsl:choose>
                        <xsl:when test="$query-id">
                            <queryId>
                                <xsl:attribute name="root">
                                    <xsl:call-template name="getOIDRootByName">
                                        <xsl:with-param name="OID_Name">PORTAL_QUERY_ID</xsl:with-param>
                                        <xsl:with-param name="msgType" select="$msgType"/>
                                    </xsl:call-template>
                                </xsl:attribute>
                                <xsl:attribute name="extension">
                                    <xsl:value-of select="$query-id"/>
                                </xsl:attribute>
                            </queryId>
                        </xsl:when>
                        <xsl:otherwise>
                            <queryId>
                                <xsl:call-template name="nullFlavor"/>
                            </queryId>
                        </xsl:otherwise>
                    </xsl:choose>
                    <parameterList>
                        <!-- An identifier for a specific drug product. Types of drugs identified by drug code include: Manufactured drug, generic formulation, generic, therapeutic class, etc. -->
                        <xsl:call-template name="drugCode">
                            <xsl:with-param name="code" select="$drug-01-code"/>
                            <xsl:with-param name="codeSystem" select="$drug-01-codeSystem"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                        </xsl:call-template>
                        <xsl:call-template name="drugCode">
                            <xsl:with-param name="code" select="$drug-02-code"/>
                            <xsl:with-param name="codeSystem" select="$drug-02-codeSystem"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                        </xsl:call-template>
                        <xsl:call-template name="drugCode">
                            <xsl:with-param name="code" select="$drug-03-code"/>
                            <xsl:with-param name="codeSystem" select="$drug-03-codeSystem"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                        </xsl:call-template>
                        <xsl:call-template name="drugCode">
                            <xsl:with-param name="code" select="$drug-04-code"/>
                            <xsl:with-param name="codeSystem" select="$drug-04-codeSystem"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                        </xsl:call-template>
                        <xsl:call-template name="drugCode">
                            <xsl:with-param name="code" select="$drug-05-code"/>
                            <xsl:with-param name="codeSystem" select="$drug-05-codeSystem"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                        </xsl:call-template>
                        <xsl:call-template name="drugCode">
                            <xsl:with-param name="code" select="$drug-06-code"/>
                            <xsl:with-param name="codeSystem" select="$drug-06-codeSystem"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                        </xsl:call-template>
                        <xsl:call-template name="drugCode">
                            <xsl:with-param name="code" select="$drug-07-code"/>
                            <xsl:with-param name="codeSystem" select="$drug-07-codeSystem"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                        </xsl:call-template>
                        <xsl:call-template name="drugCode">
                            <xsl:with-param name="code" select="$drug-08-code"/>
                            <xsl:with-param name="codeSystem" select="$drug-08-codeSystem"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                        </xsl:call-template>
                        <xsl:call-template name="drugCode">
                            <xsl:with-param name="code" select="$drug-09-code"/>
                            <xsl:with-param name="codeSystem" select="$drug-09-codeSystem"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                        </xsl:call-template>
                        <xsl:call-template name="drugCode">
                            <xsl:with-param name="code" select="$drug-10-code"/>
                            <xsl:with-param name="codeSystem" select="$drug-10-codeSystem"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                        </xsl:call-template>
                        <xsl:call-template name="drugCode">
                            <xsl:with-param name="code" select="$drug-11-code"/>
                            <xsl:with-param name="codeSystem" select="$drug-11-codeSystem"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                        </xsl:call-template>
                        <xsl:call-template name="drugCode">
                            <xsl:with-param name="code" select="$drug-12-code"/>
                            <xsl:with-param name="codeSystem" select="$drug-12-codeSystem"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                        </xsl:call-template>
                        <xsl:call-template name="drugCode">
                            <xsl:with-param name="code" select="$drug-13-code"/>
                            <xsl:with-param name="codeSystem" select="$drug-13-codeSystem"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                        </xsl:call-template>
                        <xsl:call-template name="drugCode">
                            <xsl:with-param name="code" select="$drug-14-code"/>
                            <xsl:with-param name="codeSystem" select="$drug-14-codeSystem"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                        </xsl:call-template>
                        <xsl:call-template name="drugCode">
                            <xsl:with-param name="code" select="$drug-15-code"/>
                            <xsl:with-param name="codeSystem" select="$drug-15-codeSystem"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                        </xsl:call-template>
                        <xsl:call-template name="drugCode">
                            <xsl:with-param name="code" select="$drug-16-code"/>
                            <xsl:with-param name="codeSystem" select="$drug-16-codeSystem"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                        </xsl:call-template>
                        <xsl:call-template name="drugCode">
                            <xsl:with-param name="code" select="$drug-17-code"/>
                            <xsl:with-param name="codeSystem" select="$drug-17-codeSystem"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                        </xsl:call-template>
                        <xsl:call-template name="drugCode">
                            <xsl:with-param name="code" select="$drug-18-code"/>
                            <xsl:with-param name="codeSystem" select="$drug-18-codeSystem"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                        </xsl:call-template>
                        <xsl:call-template name="drugCode">
                            <xsl:with-param name="code" select="$drug-19-code"/>
                            <xsl:with-param name="codeSystem" select="$drug-19-codeSystem"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                        </xsl:call-template>
                        <xsl:call-template name="drugCode">
                            <xsl:with-param name="code" select="$drug-20-code"/>
                            <xsl:with-param name="codeSystem" select="$drug-20-codeSystem"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                        </xsl:call-template>
                    </parameterList>
                </queryByParameter>

            </controlActEvent>


            <xsl:call-template name="transmissionWrapperEnd">
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

        </PORX_IN050010CA>
    </xsl:template>
    <!-- patient drug contraindications query -->
    <xsl:template name="patientDrugContrainDicationsQueryRequest">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>
        <xsl:param name="author-description"/>
        <xsl:param name="supervisor-description"/>
        <xsl:param name="location-description"/>
        <xsl:param name="ParticipationMode"/>
        <xsl:param name="author-time"/>
        
        <xsl:param name="drug-code"/>
        <xsl:param name="drug-codeSystem"/>
        
        <xsl:param name="query-id"/>

        <xsl:variable name="msgType">clientMsg</xsl:variable>
        <xsl:variable name="msgAction">queryRequest</xsl:variable>

        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][not($patient-description) or patient/@description = $patient-description]"/>

        <xsl:variable name="patient_description">
            <xsl:choose>
                <xsl:when test="$patient-description">
                    <xsl:value-of select="$patient-description"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$ProfileData/patient/@description"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        
        <PORX_IN050030CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">PORX_IN050030CA</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <controlActEvent classCode="CACT" moodCode="EVN">
                <xsl:call-template name="controlActStart">
                    <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                    <xsl:with-param name="author-description" select="$author-description"/>
                    <xsl:with-param name="location-description" select="$location-description"/>
                    <xsl:with-param name="author-time" select="$author-time"/>
                    <xsl:with-param name="ParticipationMode" select="$ParticipationMode"/>
                    <xsl:with-param name="TriggerEventCode">PORX_TE050040UV</xsl:with-param>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="msgAction" select="$msgAction"/>
                </xsl:call-template>

                <queryByParameter>
                    <xsl:choose>
                        <xsl:when test="$query-id">
                            <queryId>
                                <xsl:attribute name="root">
                                    <xsl:call-template name="getOIDRootByName">
                                        <xsl:with-param name="OID_Name">PORTAL_QUERY_ID</xsl:with-param>
                                        <xsl:with-param name="msgType" select="$msgType"/>
                                    </xsl:call-template>
                                </xsl:attribute>
                                <xsl:attribute name="extension">
                                    <xsl:value-of select="$query-id"/>
                                </xsl:attribute>
                            </queryId>
                        </xsl:when>
                        <xsl:otherwise>
                            <queryId>
                                <xsl:call-template name="nullFlavor"/>
                            </queryId>
                        </xsl:otherwise>
                    </xsl:choose>
                    <parameterList>
                        <!-- An identifier for a specific drug product. Types of drugs identified by drug code include: Manufactured drug, generic formulation, generic, therapeutic class, etc. -->
                            <xsl:call-template name="drugCode">
                                <xsl:with-param name="code" select="$drug-code"/>
                                <xsl:with-param name="codeSystem" select="$drug-codeSystem"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                            </xsl:call-template>

                        <xsl:call-template name="PatientByDescription">
                            <xsl:with-param name="description" select="$patient_description"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="use_phn">true</xsl:with-param>
                            <xsl:with-param name="format">query</xsl:with-param>
                        </xsl:call-template>
                        
                    </parameterList>
                </queryByParameter>

            </controlActEvent>


            <xsl:call-template name="transmissionWrapperEnd">
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

        </PORX_IN050030CA>


    </xsl:template>

   
    <xsl:template name="drugCharacteristics">
        <xsl:param name="value"/>
        <xsl:param name="code"/>
        <xsl:param name="codeSystem"/>
        <xsl:param name="msgType"/>

        <drugCharacteristics>
            <drugCharacteristic>
                <value>
                    <xsl:value-of select="$value"/>
                </value>
            </drugCharacteristic>
            <!-- A coded value denoting the type of physical characteristic of a drug. Characteristics include: Color, Shape, Markings, Size. -->
            <drugCharacteristicType>
                <value>
                    <xsl:attribute name="code">
                        <xsl:value-of select="$code"/>
                    </xsl:attribute>
                    <xsl:if test="$codeSystem">
                        <xsl:attribute name="codeSystem">
                                                                <xsl:call-template name="getOIDRootByName">
                                        <xsl:with-param name="OID_Name"> <xsl:value-of select="$codeSystem"/></xsl:with-param>
                                        <xsl:with-param name="msgType" select="$msgType"/>
                                    </xsl:call-template>
                        </xsl:attribute>
                    </xsl:if>
                </value>
            </drugCharacteristicType>
        </drugCharacteristics>

    </xsl:template>
    <xsl:template name="drugCode">
        <xsl:param name="code"/>
        <xsl:param name="codeSystem"/>
        <xsl:param name="msgType"/>
        <xsl:if test="$code">
            <drugCode>
                <value>
                    <xsl:attribute name="code">
                        <xsl:value-of select="$code"/>
                    </xsl:attribute>
                    <xsl:if test="$codeSystem">
                        <xsl:attribute name="codeSystem">
                                    <xsl:call-template name="getOIDRootByName">
                                        <xsl:with-param name="OID_Name"> <xsl:value-of select="$codeSystem"/></xsl:with-param>
                                        <xsl:with-param name="msgType" select="$msgType"/>
                                    </xsl:call-template>
                        </xsl:attribute>
                    </xsl:if>
                </value>
            </drugCode>
        </xsl:if>
    </xsl:template>


</xsl:stylesheet>
