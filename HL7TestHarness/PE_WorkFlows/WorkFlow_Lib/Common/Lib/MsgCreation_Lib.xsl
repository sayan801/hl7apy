<?xml version="1.0" encoding="UTF-8"?>
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->  
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="urn:hl7-org:v3" xmlns:hl7="urn:hl7-org:v3" version="1.0">
    <xsl:import href="TestData_Lib.xsl"/>

    <!-- <xsl:variable name="BaseData" select="document('Data.xml')/TestData"/> -->
    <xsl:variable name="BaseData" select="$TestDataXml/configuration/testData"/>
    <xsl:variable name="SoapRequired" select="$Config/soap/@required"/>

    <xsl:template match="text()|@*" mode="message"/>

    <xsl:template name="SoapWapper" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
        <xsl:choose>
            <xsl:when test="$SoapRequired = 'true' ">
                <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:hl7="urn:hl7-org:v3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
                    <soap:Body>
                        <xsl:apply-templates select="." mode="message"/>
                    </soap:Body>
                </soap:Envelope>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="." mode="message"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="KeyWordByPatientDescription">
        <xsl:param name="description"/>
        <xsl:param name="msgType">clientMsg</xsl:param>
        <xsl:choose>
            <xsl:when test="$msgType='clientMsg'">
                <xsl:value-of select="$TestData/patients/patient[@description=$description]/client[1]/keyword"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$TestData/patients/patient[@description=$description]/server[1]/keyword"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="InformantByDescription">
        <xsl:param name="patient-description"/>
        <xsl:param name="description"/>
        <xsl:param name="format"/>
        <xsl:param name="msgType"/>
        <xsl:choose>
            <xsl:when test="$description = 'patient'">
                <xsl:call-template name="PatientByDescription">
                    <xsl:with-param name="description" select="$patient-description"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="format">CeRx</xsl:with-param>
                    <xsl:with-param name="use_phn">true</xsl:with-param>
                    <xsl:with-param name="use_name">true</xsl:with-param>
                    <xsl:with-param name="use_gender">true</xsl:with-param>
                    <xsl:with-param name="use_dob">true</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$TestData/providers/provider[@description=$description]">
                <xsl:call-template name="ProviderByDescription">
                    <xsl:with-param name="description" select="$description"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="format" select="$format"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <responsibleParty>
                    <agentPerson>
                        <name>
                            <xsl:value-of select="$description"/>
                        </name>
                    </agentPerson>
                </responsibleParty>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="InformantByDescriptionForImmunization">
        <xsl:param name="description"/>
        <xsl:param name="nodeName">informationSourceRole</xsl:param>

        <xsl:element name="{$nodeName}">
            <xsl:choose>
                <xsl:when test="$description = 'patient' ">
                    <xsl:attribute name="classCode">PAT</xsl:attribute>
                </xsl:when>
                <xsl:when test="$TestData/providers/provider[@description=$description]">
                    <xsl:attribute name="classCode">PROV</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="classCode">AGNT</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>

    <xsl:template name="PatientByPHN">
        <xsl:param name="root"/>
        <xsl:param name="phn"/>
        <xsl:param name="msgType">clientMsg</xsl:param>
        <xsl:param name="format"/>
        <xsl:param name="use_phn"/>
        <xsl:param name="use_name"/>
        <xsl:param name="use_gender"/>
        <xsl:param name="use_dob"/>
        <xsl:choose>
            <xsl:when test="msgType='clientMsg'">
                <xsl:call-template name="PatientOutput">
                    <xsl:with-param name="patientInfo" select="$TestData/patients/patient/client[id/@root=$root and phn=$phn][1]"/>
                    <xsl:with-param name="format" select="$format"/>
                    <xsl:with-param name="use_phn" select="$use_phn"/>
                    <xsl:with-param name="use_name" select="$use_name"/>
                    <xsl:with-param name="use_gender" select="$use_gender"/>
                    <xsl:with-param name="use_dob" select="$use_dob"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="PatientOutput">
                    <xsl:with-param name="patientInfo" select="$TestData/patients/patient/server[id/@root=$root and phn=$phn][1]"/>
                    <xsl:with-param name="format" select="$format"/>
                    <xsl:with-param name="use_phn" select="$use_phn"/>
                    <xsl:with-param name="use_name" select="$use_name"/>
                    <xsl:with-param name="use_gender" select="$use_gender"/>
                    <xsl:with-param name="use_dob" select="$use_dob"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="PatientByDescription">
        <xsl:param name="description"/>
        <xsl:param name="msgType"/>
        <xsl:param name="use_phn"/>
        <xsl:param name="use_name"/>
        <xsl:param name="use_gender"/>
        <xsl:param name="use_dob"/>
        <xsl:param name="use_telecom"/>
        <xsl:param name="format"/>
        <xsl:choose>
            <xsl:when test="$msgType='clientMsg'">
                <xsl:call-template name="PatientOutput">
                    <xsl:with-param name="patientInfo" select="$TestData/patients/patient[@description=$description]/client[1]"/>
                    <xsl:with-param name="format" select="$format"/>
                    <xsl:with-param name="use_phn" select="$use_phn"/>
                    <xsl:with-param name="use_name" select="$use_name"/>
                    <xsl:with-param name="use_gender" select="$use_gender"/>
                    <xsl:with-param name="use_dob" select="$use_dob"/>
                    <xsl:with-param name="use_telecom" select="$use_telecom"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="PatientOutput">
                    <xsl:with-param name="patientInfo" select="$TestData/patients/patient[@description=$description]/server[1]"/>
                    <xsl:with-param name="format" select="$format"/>
                    <xsl:with-param name="use_phn" select="$use_phn"/>
                    <xsl:with-param name="use_name" select="$use_name"/>
                    <xsl:with-param name="use_gender" select="$use_gender"/>
                    <xsl:with-param name="use_dob" select="$use_dob"/>
                    <xsl:with-param name="use_telecom" select="$use_telecom"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="ProviderByDescription">
        <xsl:param name="description"/>
        <xsl:param name="msgType"/>
        <xsl:param name="format"/>
        <xsl:choose>
            <xsl:when test="$msgType='clientMsg'">
                <xsl:call-template name="ProviderOutput">
                    <xsl:with-param name="providerInfo" select="$TestData/providers/provider[@description=$description]/client[1]"/>
                    <xsl:with-param name="format" select="$format"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="ProviderOutput">
                    <xsl:with-param name="providerInfo" select="$TestData/providers/provider[@description=$description]/server[1]"/>
                    <xsl:with-param name="format" select="$format"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="LocationByDescription">
        <xsl:param name="description"/>
        <xsl:param name="msgType">clientMsg</xsl:param>
        <xsl:param name="format"/>
        <xsl:choose>
            <xsl:when test="$msgType='clientMsg'">
                <xsl:call-template name="LocationOutput">
                    <xsl:with-param name="locationInfo" select="$TestData/serviceDeliveryLocations/location[@description=$description]/client[1]"/>
                    <xsl:with-param name="format" select="$format"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="LocationOutput">
                    <xsl:with-param name="locationInfo" select="$TestData/serviceDeliveryLocations/location[@description=$description]/server[1]"/>
                    <xsl:with-param name="format" select="$format"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="ProviderIDByDescription">
        <xsl:param name="description"/>
        <xsl:param name="msgType">clientMsg</xsl:param>
        <id root="" extension="">
            <xsl:choose>
                <xsl:when test="$msgType='clientMsg'">
                    <xsl:attribute name="root">
                        <xsl:value-of select="$TestData/providers/provider[@description=$description]/client[1]/id/@root"/>
                    </xsl:attribute>
                    <xsl:attribute name="extension">
                        <xsl:value-of select="$TestData/providers/provider[@description=$description]/client[1]/id/@extension"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="root">
                        <xsl:value-of select="$TestData/providers/provider[@description=$description]/server[1]/id/@root"/>
                    </xsl:attribute>
                    <xsl:attribute name="extension">
                        <xsl:value-of select="$TestData/providers/provider[@description=$description]/server[1]/id/@extension"/>
                    </xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
        </id>
    </xsl:template>

    <xsl:template name="getClientCodeSystem">
        <xsl:param name="OID_Name"/>
        <xsl:attribute name="codeSystem">
            <xsl:call-template name="getOIDRootByName">
                <xsl:with-param name="OID_Name" select="$OID_Name"/>
                <xsl:with-param name="msgType">clientMsg</xsl:with-param>
            </xsl:call-template>
        </xsl:attribute>
    </xsl:template>
    <xsl:template name="getServerCodeSystem">
        <xsl:param name="OID_Name"/>
        <xsl:attribute name="codeSystem">
            <xsl:call-template name="getOIDRootByName">
                <xsl:with-param name="OID_Name" select="$OID_Name"/>
                <xsl:with-param name="msgType">serverMsg</xsl:with-param>
            </xsl:call-template>
        </xsl:attribute>
    </xsl:template>
    <xsl:template name="getClientOIDByName">
        <xsl:param name="OID_Name"/>
        <xsl:attribute name="root">
            <xsl:call-template name="getOIDRootByName">
                <xsl:with-param name="OID_Name" select="$OID_Name"/>
                <xsl:with-param name="msgType">clientMsg</xsl:with-param>
            </xsl:call-template>
        </xsl:attribute>
    </xsl:template>
    <xsl:template name="getServerOIDByName">
        <xsl:param name="OID_Name"/>
        <xsl:attribute name="root">
            <xsl:call-template name="getOIDRootByName">
                <xsl:with-param name="OID_Name" select="$OID_Name"/>
                <xsl:with-param name="msgType">serverMsg</xsl:with-param>
            </xsl:call-template>
        </xsl:attribute>
    </xsl:template>

    <xsl:template name="getBaseDate">
        <xsl:variable name="DateTime" select="  $BaseData/@BaseDateTime"/>
        <xsl:value-of select="substring($DateTime,1,8)"/>
    </xsl:template>

    <xsl:template name="getBaseDateTime">
        <xsl:value-of select="$BaseData/@BaseDateTime"/>
    </xsl:template>

    <xsl:template name="effectiveTime">
        <xsl:param name="effectiveTime"/>
        <xsl:param name="valueOnly">false</xsl:param>
        <xsl:choose>
            <xsl:when test="$effectiveTime/@date">
                <xsl:attribute name="value">
                    <xsl:value-of select="$effectiveTime/@date"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:when test="$effectiveTime/@value">
                <xsl:attribute name="value">
                    <xsl:value-of select="$effectiveTime/@value"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:when test="$effectiveTime/low or $effectiveTime/high or $effectiveTime/width">
                <xsl:choose>
                    <xsl:when test="$valueOnly='true'">
                        <xsl:choose>
                            <xsl:when test="$effectiveTime/low/@value">
                                <xsl:attribute name="value">
                                    <xsl:value-of select="$effectiveTime/low/@value"/>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:when test="$effectiveTime/high/@value">
                                <xsl:attribute name="value">
                                    <xsl:value-of select="$effectiveTime/high/@value"/>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="nullFlavor"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:if test="$effectiveTime/low">
                            <xsl:element name="low">
                                <xsl:if test="$effectiveTime/low/@value">
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="$effectiveTime/low/@value"/>
                                    </xsl:attribute>
                                </xsl:if>
                                <xsl:if test="$effectiveTime/low/@nullFlavor">
                                    <xsl:attribute name="nullFlavor">
                                        <xsl:value-of select="$effectiveTime/low/@nullFlavor"/>
                                    </xsl:attribute>
                                </xsl:if>
                            </xsl:element>
                        </xsl:if>
                        <xsl:if test="$effectiveTime/high">
                            <xsl:element name="high">
                                <xsl:if test="$effectiveTime/high/@value">
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="$effectiveTime/high/@value"/>
                                    </xsl:attribute>
                                </xsl:if>
                                <xsl:if test="$effectiveTime/high/@nullFlavor">
                                    <xsl:attribute name="nullFlavor">
                                        <xsl:value-of select="$effectiveTime/high/@nullFlavor"/>
                                    </xsl:attribute>
                                </xsl:if>
                            </xsl:element>
                        </xsl:if>
                        <xsl:if test="$effectiveTime/width">
                            <xsl:element name="width">
                                <xsl:attribute name="value">
                                    <xsl:value-of select="$effectiveTime/width/@value"/>
                                </xsl:attribute>
                                <xsl:attribute name="unit">
                                    <xsl:value-of select="$effectiveTime/width/@unit"/>
                                </xsl:attribute>
                            </xsl:element>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="nullFlavor"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="codeSystem">
        <xsl:param name="codeElement"/>
        <xsl:param name="msgType"/>
        <xsl:attribute name="code">
            <xsl:value-of select="$codeElement/@code"/>
        </xsl:attribute>
        <xsl:if test="$codeElement/@codeSystem">
            <xsl:attribute name="codeSystem">
                <xsl:call-template name="getOIDRootByName">
                    <xsl:with-param name="OID_Name" select="$codeElement/@codeSystem"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                </xsl:call-template>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="$codeElement/@displayName">
            <xsl:element name="originalText">
                <xsl:value-of select="$codeElement/@displayName"/>
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <xsl:template name="valueAndUnit">
        <xsl:param name="valueElement"/>
        <xsl:param name="msgType"/>
        <xsl:attribute name="value">
            <xsl:value-of select="$valueElement/@value"/>
        </xsl:attribute>
        <xsl:if test="$valueElement/@unit">
            <xsl:attribute name="unit">
                <xsl:value-of select="$valueElement/@unit"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>

    <xsl:template name="annotation">
        <xsl:param name="author-description"/>
        <xsl:param name="msgType"/>
        <annotation>
            <!-- Free text comments. Additional textual instructions entered about the dispense event. -->
            <text>
                <xsl:value-of select="text"/>
            </text>
            <!-- required element with default value - status code is now everywhere -->
            <statusCode code="active"/>
            <!-- required element - A coded value denoting the language in which the note is written : HumanLanguage vocab -->
            <languageCode code="EN">
                <xsl:if test="text/@languageCode">
                    <xsl:attribute name="code">
                        <xsl:value-of select="text/@languageCode"/>
                    </xsl:attribute>
                </xsl:if>
            </languageCode>

            <author>
                <!--  date and time on which the comment was added -->
                <time>
                    <xsl:call-template name="effectiveTime">
                        <xsl:with-param name="effectiveTime" select="author"/>
                    </xsl:call-template>
                </time>

                <xsl:choose>
                    <xsl:when test="author">
                        <xsl:call-template name="ProviderByDescription">
                            <xsl:with-param name="description" select="author/@description"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="format">CeRx</xsl:with-param>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="ProviderByDescription">
                            <xsl:with-param name="description" select="$author-description"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="format">CeRx</xsl:with-param>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </author>
        </annotation>
    </xsl:template>

    <xsl:template name="record-annotation">
        <xsl:param name="note-description"/>
        <xsl:param name="record-description"/>
        <xsl:param name="ProfileData"/>
        <xsl:param name="msgType"/>

        <xsl:variable name="RecordProfileData" select="$ProfileData/items/child::*[@description=$record-description]"/>
        <xsl:variable name="NoteProfileData" select="$RecordProfileData/note[@description=$note-description]"/>

        <annotation>
            <!-- Free text comments. Additional textual instructions entered about the dispense event. -->
            <text>
                <xsl:value-of select="$NoteProfileData/text"/>
            </text>
            <!-- required element with default value - status code is now everywhere -->
            <!-- <statusCode code="active"/> -->
            <!-- required element - A coded value denoting the language in which the note is written : HumanLanguage vocab -->
            <!-- 
            <languageCode code="EN">
                <xsl:if test="$NoteProfileData/text/@languageCode">
                    <xsl:attribute name="code">
                        <xsl:value-of select="$NoteProfileData/text/@languageCode"/>
                    </xsl:attribute>
                </xsl:if>
            </languageCode>
            -->
            <subject>
                <annotatedAct>
                    <!-- The identifier assigned by the central system (EHR) to the record item being annotated. eg. the id of an allergy -->
                    <id>
                        <xsl:call-template name="ID_Element">
                            <xsl:with-param name="Record" select="$RecordProfileData/record-id"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="Default_OID">
                                <xsl:call-template name="OIDNameFromType">
                                    <xsl:with-param name="recordName" select="local-name($RecordProfileData)"/>
                                </xsl:call-template>
                            </xsl:with-param>
                        </xsl:call-template>
                    </id>

                    <subject>
                        <xsl:call-template name="PatientByDescription">
                            <xsl:with-param name="description" select="$ProfileData/patient/@description"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="format">patient_note</xsl:with-param>
                            <xsl:with-param name="use_phn">true</xsl:with-param>
                            <xsl:with-param name="use_name">true</xsl:with-param>
                            <xsl:with-param name="use_gender">true</xsl:with-param>
                            <xsl:with-param name="use_dob">true</xsl:with-param>
                        </xsl:call-template>
                    </subject>

                </annotatedAct>
            </subject>
        </annotation>
    </xsl:template>

    <xsl:template name="patient-annotation">
        <xsl:param name="description"/>
        <xsl:param name="ProfileData"/>
        <xsl:param name="msgAction"/>
        <xsl:param name="msgType"/>
        <!-- addRequest|removeRequest|queryResponse -->



        <xsl:variable name="NoteProfileData" select="$ProfileData/items/note[@description=$description]"/>

        <xsl:choose>
            <xsl:when test="$msgAction='removeRequest'">
                <actEvent>
                    <!-- The identifier assigned by the central system (EHR) to the patient note - this identifies the patient note to deprecate -->
                    <id>
                        <xsl:call-template name="ID_Element">
                            <xsl:with-param name="Record" select="$NoteProfileData/record-id"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="Default_OID">DIS_PATIENT_NOTE_ID</xsl:with-param>
                        </xsl:call-template>
                    </id>

                    <!-- the patient to whom the note was assigned -->
                    <recordTarget>
                        <!-- the patient to whom the allergy applies -->
                        <xsl:call-template name="PatientByDescription">
                            <xsl:with-param name="description" select="$ProfileData/patient/@description"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="format">CeRx</xsl:with-param>
                            <xsl:with-param name="use_phn">true</xsl:with-param>
                            <xsl:with-param name="use_name">true</xsl:with-param>
                            <xsl:with-param name="use_gender">true</xsl:with-param>
                            <xsl:with-param name="use_dob">true</xsl:with-param>
                        </xsl:call-template>
                    </recordTarget>
                </actEvent>
            </xsl:when>
            <xsl:otherwise>
                <annotation>
                    <xsl:if test="$msgAction='queryResponse'">
                        <id>
                            <xsl:call-template name="ID_Element">
                                <xsl:with-param name="Record" select="$NoteProfileData/record-id"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                                <xsl:with-param name="Default_OID">DIS_PATIENT_NOTE_ID</xsl:with-param>
                            </xsl:call-template>
                        </id>
                    </xsl:if>

                    <code code="GENERAL">
                        <xsl:if test="$NoteProfileData/type/@code">
                            <xsl:attribute name="code">
                                <xsl:value-of select="$NoteProfileData/type/@code"/>
                            </xsl:attribute>
                        </xsl:if>
                    </code>
                    <!-- Free text comments. Additional textual instructions entered about the dispense event. -->
                    <text>
                        <xsl:value-of select="$NoteProfileData/text"/>
                    </text>
                    <!-- required element with default value -->
                    <statusCode code="completed"/>
                    <!-- required element - A coded value denoting the language in which the note is written : HumanLanguage vocab -->
                    <!-- this is not included in the schema, it should be but it is not. 
                    <languageCode code="EN">
                        <xsl:if test="$NoteProfileData/text/@languageCode">
                            <xsl:attribute name="code">
                                <xsl:value-of select="$NoteProfileData/text/@languageCode"/>
                            </xsl:attribute>
                        </xsl:if>
                    </languageCode>
                    -->
                    <recordTarget>
                        <!-- the patient to whom the allergy applies -->
                        <xsl:choose>
                            <xsl:when test="$msgAction='queryResponse'">
                                <xsl:call-template name="PatientByDescription">
                                    <xsl:with-param name="description" select="$ProfileData/patient/@description"/>
                                    <xsl:with-param name="msgType" select="$msgType"/>
                                    <xsl:with-param name="format">patient_note</xsl:with-param>
                                    <xsl:with-param name="use_phn">true</xsl:with-param>
                                    <xsl:with-param name="use_name">true</xsl:with-param>
                                    <xsl:with-param name="use_gender">true</xsl:with-param>
                                    <xsl:with-param name="use_dob">true</xsl:with-param>
                                    <xsl:with-param name="use_telecom">true</xsl:with-param>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="PatientByDescription">
                                    <xsl:with-param name="description" select="$ProfileData/patient/@description"/>
                                    <xsl:with-param name="msgType" select="$msgType"/>
                                    <xsl:with-param name="format">patient_note</xsl:with-param>
                                    <xsl:with-param name="use_phn">true</xsl:with-param>
                                    <xsl:with-param name="use_name">true</xsl:with-param>
                                    <xsl:with-param name="use_gender">true</xsl:with-param>
                                    <xsl:with-param name="use_dob">true</xsl:with-param>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>

                    </recordTarget>

                    <xsl:if test="$msgAction='queryResponse' and $NoteProfileData/supervisor">
                        <responsibleParty>
                            <xsl:call-template name="ProviderByDescription">
                                <xsl:with-param name="description" select="$NoteProfileData/supervisor/@description"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                                <xsl:with-param name="format">CeRx</xsl:with-param>
                            </xsl:call-template>
                        </responsibleParty>
                    </xsl:if>

                    <!-- person responsible for the event that caused this message - the pharmacist, doctor, or most likely a public health nurse -->
                    <xsl:if test="$msgAction='queryResponse' and $NoteProfileData/author">
                        <author typeCode="AUT">
                            <time>
                                <xsl:call-template name="effectiveTime">
                                    <xsl:with-param name="effectiveTime" select="$NoteProfileData/author"/>
                                </xsl:call-template>
                            </time>
                            <xsl:call-template name="ProviderByDescription">
                                <xsl:with-param name="description" select="$NoteProfileData/author/@description"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                                <xsl:with-param name="format">CeRx</xsl:with-param>
                            </xsl:call-template>
                        </author>
                    </xsl:if>
                    <!--   optional element to identify the source of the recorded information - a patient, patient's agent, or a provider x_InformationSource vocab-->
                    <xsl:if test="$NoteProfileData/informant">
                        <informant>
                            <time value="20050101102001"/>
                            <!-- choice between patient, patient's agent, or a provider -->
                            <xsl:call-template name="InformantByDescription">
                                <xsl:with-param name="patient-description" select="$ProfileData/patient/@description"/>
                                <xsl:with-param name="description" select="$NoteProfileData/informant/@description"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                                <xsl:with-param name="format">CeRx</xsl:with-param>
                            </xsl:call-template>
                        </informant>
                    </xsl:if>

                    <!-- Indicates the service delivery location where the allergy was recorded -->
                    <xsl:if test="$msgAction='queryResponse' and $NoteProfileData/location">
                        <location>
                            <xsl:call-template name="LocationByDescription">
                                <xsl:with-param name="description" select="$NoteProfileData/location/@description"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                                <xsl:with-param name="format">CeRx</xsl:with-param>
                            </xsl:call-template>
                        </location>
                    </xsl:if>
                </annotation>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template name="causalityAssessment">
        <xsl:param name="msgType"/>
        <xsl:param name="msgAction"/>
        <xsl:param name="ProfileData"/>

        <causalityAssessment>
            <!-- For SNOMED this will include the actual assessment.  For non-SNOMED, this should be fixed to RXNASSES -->
            <code code="RXNASSES"/>
            <!-- fixed value for completed -->
            <statusCode code="completed"/>
            <!-- Indicates whether the reaction is deemed to be related to the exposure : This attribute will not be populated if using SNOMED.  Otherwise it should have a fixed value of "RELATED" -->
            <value code="RELATED"/>
            <xsl:if test="reaction">
                <xsl:variable name="reaction-description" select="reaction/@description"/>
                <xsl:variable name="reaction" select="$ProfileData/items/reaction[@description = $reaction-description]"/>
                <xsl:variable name="reactionData" select="$BaseData/reactions/reaction[@description = $reaction-description]"/>
                <subject>
                    <observationEvent negationInd="false">
                        <!-- An optional identifier assigned to the record of the adverse reaction - you woud use either id or value - i.e tie the allergy into an existing reaction or associate with a new reaction -->
                        <xsl:if test="not($reaction/@infered='true') or $msgAction='queryResponse' ">
                            <id>
                                <xsl:call-template name="ID_Element">
                                    <xsl:with-param name="Record" select="$reaction/record-id"/>
                                    <xsl:with-param name="msgType" select="$msgType"/>
                                </xsl:call-template>
                            </id>
                        </xsl:if>
                        <!-- If using SNOMED, this will contain the diagnosis. Otherwise it will be a fixed value of 'DX'. -->
                        <code code="DX"/>
                        <!-- optional element for a free form description of the reaction. -->
                        <xsl:if test="$reactionData/text">
                            <text>
                                <xsl:value-of select="$reactionData/text"/>
                            </text>
                        </xsl:if>
                        <statusCode code="active">
                            <xsl:if test="$reaction/statusCode">
                                <xsl:attribute name="code">
                                    <xsl:value-of select="$reaction/statusCode/@code"/>
                                </xsl:attribute>
                            </xsl:if>
                        </statusCode>

                        <!-- optional element for the time period/date on which the reaction began IVL.LOW - only start date is specified -->
                        <xsl:if test="$reaction/effectiveTime">
                            <!-- optional element for the date on which the allergy test was performed -->
                            <effectiveTime>
                                <xsl:call-template name="effectiveTime">
                                    <xsl:with-param name="effectiveTime" select="$reaction/effectiveTime"/>
                                </xsl:call-template>
                            </effectiveTime>
                        </xsl:if>
                        <!-- Specifies the kind of reaction, as experienced by the patient -->
                        <value>
                            <xsl:call-template name="codeSystem">
                                <xsl:with-param name="codeElement" select="$reactionData/value"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                            </xsl:call-template>
                        </value>

                        <!-- severity -->
                        <xsl:call-template name="severityObservation">
                            <xsl:with-param name="severityData" select="$reaction/severity"/>
                            <xsl:with-param name="elementName">subjectOf</xsl:with-param>
                        </xsl:call-template>
                    </observationEvent>
                </subject>
            </xsl:if>
            <xsl:if test="cause">
                <startsAfterStartOf>
                    <exposureEvent>
                        <!-- optional Identifier of the exposure event that caused the adverse reaction. This could be an identifier for a prescription, immunization, or other active medication record -->
                        <xsl:if test="cause/@description">
                            <id>
                                <xsl:variable name="description" select="cause/@description"/>
                                <xsl:call-template name="ID_Element">
                                    <xsl:with-param name="Record" select="$ProfileData/items/child::*[@description=$description]/record-id"/>
                                    <xsl:with-param name="msgType" select="$msgType"/>
                                    <xsl:with-param name="Default_OID">
                                        <xsl:choose>
                                            <xsl:when test="cause/@type = 'prescription'">DIS_PRESCRIPTION_ID</xsl:when>
                                            <xsl:when test="cause/@type = 'immunization'">DIS_IMMUNIZATION_ID</xsl:when>
                                            <xsl:when test="cause/@type = 'otherMedication'">DIS_OTHER_ACTIVE_MED_ID</xsl:when>
                                        </xsl:choose>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </id>
                        </xsl:if>


                        <!-- optional element to give the method by which the patient was exposed to the substance. RouteOfAdministration vocab -->
                        <xsl:if test="cause/routeCode/@code">
                            <routeCode code="">
                                <xsl:call-template name="codeSystem">
                                    <xsl:with-param name="codeElement" select="cause/routeCode"/>
                                    <xsl:with-param name="msgType" select="$msgType"/>
                                </xsl:call-template>
                            </routeCode>
                        </xsl:if>

                        <consumable>
                            <!-- note that this element is called administrableMaterial in the allergy -->
                            <administrableMaterial>
                                <administerableMaterialKind>
                                    <!-- Indicates the type of agent that the patient was exposed to which caused the adverse reaction. This includes Drug, Food, Latex, Dust, etc. ExposureAgentEntityType vocab CWE not found -->
                                    <code code="">
                                        <xsl:call-template name="codeSystem">
                                            <xsl:with-param name="codeElement" select="cause/code"/>
                                            <xsl:with-param name="msgType" select="$msgType"/>
                                        </xsl:call-template>
                                    </code>
                                </administerableMaterialKind>
                            </administrableMaterial>
                        </consumable>
                    </exposureEvent>
                </startsAfterStartOf>
            </xsl:if>
        </causalityAssessment>
    </xsl:template>

    <xsl:template name="allergyTestEvent">
        <xsl:param name="msgType"/>

        <allergyTestEvent>
            <!--  Optional element for an identifier for a specific instance of an allergy/intolerance test : At least one of Id or value must be specified 
                this would be an id assigned by the system performing the test: we will need to store root and extension -->
            <xsl:if test="record-id">
                <id>
                    <xsl:call-template name="ID_Element">
                        <xsl:with-param name="Record" select="record-id"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                        <xsl:with-param name="Default_OID">DIS_ALLERGY_TEST_ID</xsl:with-param>
                    </xsl:call-template>
                </id>
            </xsl:if>

            <!-- required element for a coded value denoting the type of allergy test conducted. ObservationAllergyTestType vocab -->
            <code>
                <xsl:call-template name="codeSystem">
                    <xsl:with-param name="codeElement" select="code"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                </xsl:call-template>
            </code>
            <!-- required element with default value - status code is now everywhere -->
            <statusCode code="completed"/>

            <xsl:if test="effectiveTime">
                <!-- optional element for the date on which the allergy test was performed -->
                <effectiveTime>
                    <xsl:call-template name="effectiveTime">
                        <xsl:with-param name="effectiveTime" select="effectiveTime"/>
                    </xsl:call-template>
                </effectiveTime>
            </xsl:if>
            <xsl:if test="value">
                <!-- optional element for a coded value denoting the result of the allergy test - AllergyTestValue vocab. -->
                <value code="A1">
                    <xsl:call-template name="codeSystem">
                        <xsl:with-param name="codeElement" select="value"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </value>
            </xsl:if>
        </allergyTestEvent>
    </xsl:template>

    <xsl:template name="detectedIssueManagement">
        <xsl:param name="msgType"/>
        <detectedIssueManagement>
            <!-- ActDetectedIssueManagementCode vocab,  Indicates the kinds of management actions that have been taken, depending on the issue type -->
            <code>
                <xsl:call-template name="codeSystem">
                    <xsl:with-param name="codeElement" select="code"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                </xsl:call-template>
            </code>
            <!-- Additional free-text details describing the management of the issue -->
            <xsl:if test="text">
                <text>
                    <xsl:value-of select="text"/>
                </text>
            </xsl:if>
            <author>
                <time>
                    <xsl:call-template name="effectiveTime">
                        <xsl:with-param name="effectiveTime" select="time"/>
                    </xsl:call-template>
                </time>
                <xsl:call-template name="ProviderByDescription">
                    <xsl:with-param name="description" select="author/@description"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="format">CeRx</xsl:with-param>
                </xsl:call-template>
            </author>
        </detectedIssueManagement>
    </xsl:template>

    <xsl:template name="dosageInstruction">
        <xsl:param name="description"/>
        <xsl:param name="msgType"/>

        <xsl:variable name="InstructionData" select="$BaseData/dosageInstructions/dosageInstruction[@description=$description]"/>
        <xsl:choose>
            <xsl:when test="$description and not($description ='')">
                <xsl:call-template name="private_dosageInstruction">
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="InstructionData" select="$BaseData/dosageInstructions/dosageInstruction[@description=$description]"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="private_dosageInstruction">
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="InstructionData" select="."/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="private_dosageInstruction">
        <xsl:param name="InstructionData"/>
        <xsl:param name="msgType"/>

        <dosageInstruction moodCode="EVN">
            <!-- Distinguishes types of dosage : For SNOMED this will pre-coordinate route, body site and potentially drug.  For non-SNOMED, this will be a fixed value of DRUG. -->
            <code code="DRUG"/>
            <!-- required value free form textual specification made up of either an 'Ad-hoc dosage instruction' or 'Textual rendition of the structured dosage lines', plus route, 
                dosage unit, and other pertinent administration information specified by the provider -->
            <text>
                <xsl:value-of select="$InstructionData/text"/>
            </text>

            <!-- rest of elements are optional -->
            <!-- Administration Period : The time period (begin and end dates) within which the dispensed medication is to be completely administered to/by the patient. May differ from date prescription was issued. 
                Frequently only the duration (width) component is specified. E.g. 100mg tid for 10 days.  In that case, the start date is presumed to be the date the prescription was written.
            -->
            <xsl:if test="$InstructionData/effectiveTime">
                <effectiveTime>
                    <xsl:call-template name="effectiveTime">
                        <xsl:with-param name="effectiveTime" select="$InstructionData/effectiveTime"/>
                    </xsl:call-template>
                </effectiveTime>
            </xsl:if>

            <!-- This is the means by which the dispensed drug is to be administered to the patient : RouteOfAdministration vocab -->
            <xsl:if test="$InstructionData/routeCode">
                <routeCode code="">
                    <xsl:call-template name="codeSystem">
                        <xsl:with-param name="codeElement" select="$InstructionData/routeCode"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </routeCode>
            </xsl:if>

            <!-- 0..5 of these HumanSubstanceAdministrationSite code - site on human body where drug should be administered - in this case, up the pooper -->
            <xsl:for-each select="$InstructionData/approachSiteCode">
                <approachSiteCode code="">
                    <xsl:call-template name="codeSystem">
                        <xsl:with-param name="codeElement" select="."/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </approachSiteCode>
            </xsl:for-each>

            <!-- The maximum amount of the dispensed medication to be administered to the patient in a 24-hr period (doses per day) or in a 7 day period (doses per week) -->
            <xsl:if test="$InstructionData/maxDoseQuantity">
                <maxDoseQuantity>
                    <numerator>
                        <xsl:call-template name="valueAndUnit">
                            <xsl:with-param name="valueElement" select="$InstructionData/maxDoseQuantity/numerator"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                        </xsl:call-template>
                    </numerator>
                    <denominator>
                        <xsl:call-template name="valueAndUnit">
                            <xsl:with-param name="valueElement" select="$InstructionData/maxDoseQuantity/denominator"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                        </xsl:call-template>
                    </denominator>
                </maxDoseQuantity>
            </xsl:if>

            <!-- Identifies how the drug is measured for administration.  Specified when not implicit from the drug form  (e.g. puff, inhalation, drops, etc.). AdministrableDrugForm vocab -->
            <xsl:if test="$InstructionData/administrationUnitCode">
                <administrationUnitCode code="">
                    <xsl:call-template name="codeSystem">
                        <xsl:with-param name="codeElement" select="$InstructionData/administrationUnitCode"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </administrationUnitCode>
            </xsl:if>

            <!-- Identification of drug product that the instruction pertains to. The drug only needs to be specified if the administration instruction corresponds to one part of the overall product.  
                For example, referring to the administration of a particular product from a combo-pack -->
            <consumable>
                <!--  has to be medication 3 on the dispense   -->
                <medication3>
                    <xsl:call-template name="Drug">
                        <xsl:with-param name="description" select="$InstructionData/drug/@description"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </medication3>
            </consumable>
            <!-- An optional  free form textual description of extended instruction regarding the administration of the drug 
                Allows for expression of non-codable qualifiers such as: 'on an empty stomach', 'add water' etc; which do not affect calculations of frequencies or quantity.  
            -->
            <xsl:if test="$InstructionData/instruction">
                <component1>
                    <supplementalInstruction moodCode="EVN">
                        <text>
                            <xsl:value-of select="$InstructionData/instruction"/>
                        </text>
                    </supplementalInstruction>
                </component1>
            </xsl:if>

            <!-- 0..20 elements for dosage lines. This information, along with the order/sequence of the dosage lines,  constitutes the details of a structured dosage instruction 
                Enables SIG instructions to be discretely specified - we will store the entire structure verabatim.
            -->
            <xsl:for-each select="$InstructionData/dosageLine">
                <component2>
                    <!-- Indicates the order in which dosage lines should be performed.  -->
                    <sequenceNumber value="">
                        <xsl:attribute name="value">
                            <xsl:value-of select="$InstructionData/dosageLine/@sequenceNumber"/>
                        </xsl:attribute>
                    </sequenceNumber>
                    <dosageLine moodCode="EVN">
                        <!-- TODO: We can't really just copy this, we need to add the items so that the name space is currect. -->
                        <!-- <xsl:copy-of select="$InstructionData/dosageLine/*"/> -->
                        <text>
                            <xsl:value-of select="text"/>
                        </text>
                        <!-- more elements - but who cares as we're not going to try to parse this and break it apart , but just store the entire xml structure -->
                    </dosageLine>
                </component2>
            </xsl:for-each>

        </dosageInstruction>

    </xsl:template>

    <xsl:template name="IssueItems">
        <xsl:param name="msgType"/>
        <xsl:param name="ProfileData"/>
        <xsl:param name="repeatingElementName"/>
        <xsl:choose>
            <xsl:when test="local-name()='prescription'">
                <xsl:element name="{$repeatingElementName}">
                    <!-- substanceAdministration -->
                    <xsl:call-template name="IssueItem-substanceAdministration">
                        <xsl:with-param name="description" select="@description"/>
                        <xsl:with-param name="Item-name">
                            <xsl:value-of select="local-name()"/>
                        </xsl:with-param>
                        <xsl:with-param name="ProfileData" select="$ProfileData"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </xsl:element>
            </xsl:when>
            <xsl:when test="local-name()='otherMedication'">
                <xsl:element name="{$repeatingElementName}">
                    <!-- substanceAdministration -->
                    <xsl:call-template name="IssueItem-substanceAdministration">
                        <xsl:with-param name="description" select="@description"/>
                        <xsl:with-param name="Item-name">
                            <xsl:value-of select="local-name()"/>
                        </xsl:with-param>
                        <xsl:with-param name="ProfileData" select="$ProfileData"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </xsl:element>
            </xsl:when>
            <xsl:when test="local-name()='immunization'">
                <xsl:element name="{$repeatingElementName}">
                    <!-- substanceAdministration -->
                    <xsl:call-template name="IssueItem-substanceAdministration">
                        <xsl:with-param name="description" select="@description"/>
                        <xsl:with-param name="Item-name">
                            <xsl:value-of select="local-name()"/>
                        </xsl:with-param>
                        <xsl:with-param name="ProfileData" select="$ProfileData"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </xsl:element>
            </xsl:when>
            <xsl:when test="local-name()='dispense'">
                <xsl:element name="{$repeatingElementName}">
                    <!-- supplyEvent -->
                    <xsl:call-template name="IssueItem-dispense">
                        <xsl:with-param name="description" select="@description"/>
                        <xsl:with-param name="ProfileData" select="$ProfileData"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </xsl:element>
            </xsl:when>
            <xsl:when test="local-name()='allergy'">
                <xsl:element name="{$repeatingElementName}">
                    <!-- observationCodedEvent -->
                    <xsl:call-template name="IssueItem-observationCodedEvent">
                        <xsl:with-param name="description" select="@description"/>
                        <xsl:with-param name="Item-name">
                            <xsl:value-of select="local-name()"/>
                        </xsl:with-param>
                        <xsl:with-param name="ProfileData" select="$ProfileData"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </xsl:element>
            </xsl:when>
            <xsl:when test="local-name()='condition'">
                <xsl:element name="{$repeatingElementName}">
                    <!-- observationCodedEvent -->
                    <xsl:call-template name="IssueItem-observationCodedEvent">
                        <xsl:with-param name="description" select="@description"/>
                        <xsl:with-param name="Item-name">
                            <xsl:value-of select="local-name()"/>
                        </xsl:with-param>
                        <xsl:with-param name="ProfileData" select="$ProfileData"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </xsl:element>
            </xsl:when>
            <xsl:when test="local-name()='observation'">
                <xsl:element name="{$repeatingElementName}">
                    <!-- observationMeasurableEvent -->
                    <xsl:call-template name="IssueItem-observationMeasurableEvent">
                        <xsl:with-param name="description" select="@description"/>
                        <xsl:with-param name="Item-name">
                            <xsl:value-of select="local-name()"/>
                        </xsl:with-param>
                        <xsl:with-param name="ProfileData" select="$ProfileData"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </xsl:element>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="IssueItem-dispense">
        <xsl:param name="description"/>
        <xsl:param name="ProfileData"/>
        <xsl:param name="msgType"/>

        <xsl:variable name="DispenseData" select="$BaseData/dispenses/dispense[@description=$description]"/>

        <supplyEvent>
            <id>
                <xsl:call-template name="ID_Element">
                    <xsl:with-param name="Record" select="$ProfileData/items/dispense[@description=$description]/record-id"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="Default_OID">DIS_DISPENSE_ID</xsl:with-param>
                </xsl:call-template>
            </id>

            <statusCode code="">
                <xsl:call-template name="codeSystem">
                    <xsl:with-param name="codeElement" select="$DispenseData/supplyEvent/statusCode"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                </xsl:call-template>
            </statusCode>

            <!-- Dispense Processing and Pickup Date Represents the date the dispense product was prepared and when the product was picked up by or delivered to the patient. 
                    The dispense processing date and pickup date can be back dated to reflect when the actual processing and pickup occurred. 
                    The lower-bound of the period signifies the dispense-processing date whereas the upper-bound signifies the dispense-pickup date. Since we don't know
                    the pickup date at this point, only the low value should be used.
                -->
            <effectiveTime>
                <xsl:call-template name="effectiveTime">
                    <xsl:with-param name="effectiveTime" select="$DispenseData/supplyEvent/effectiveTime"/>
                </xsl:call-template>
            </effectiveTime>

            <!-- the drug -->
            <product>
                <medication>
                    <xsl:call-template name="Drug">
                        <xsl:with-param name="description" select="$DispenseData/supplyEvent/drug/@description"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </medication>
            </product>

            <location>
                <xsl:call-template name="LocationByDescription">
                    <!-- TODO: not sure if this should be setup this way -->
                    <xsl:with-param name="description" select="$DispenseData/location/@description"/>
                    <!-- <xsl:with-param name="description" select="$ProfileData/items/dispense[@description=$description]/location/@description"/> -->
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="format">CeRx</xsl:with-param>
                </xsl:call-template>
            </location>

        </supplyEvent>

    </xsl:template>

    <xsl:template name="IssueItem-substanceAdministration">
        <xsl:param name="description"/>
        <xsl:param name="Item-name"/>
        <xsl:param name="ProfileData"/>
        <xsl:param name="msgType"/>

        <xsl:variable name="SubstanceData" select="$BaseData/child::node()/child::node()[name()=$Item-name][@description=$description]"/>
        <xsl:variable name="SubstanceProfileData" select="$ProfileData/items/child::node()[name()=$Item-name][@description=$description]"/>

        <substanceAdministration moodCode="EVN">
            <!-- Unique identifier of the prescription, immunization, or non-prescription drug record that triggered the issue - i.e. Interacting Prescription Number identifier-->
            <id>
                <xsl:call-template name="ID_Element">
                    <xsl:with-param name="Record" select="$SubstanceProfileData/record-id"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                </xsl:call-template>
            </id>
            <!-- Identifies whether the interaction is with a drug or a vaccine : ActSubstanceAdministrationCode: DRUG or IMMUNIZ-->
            <xsl:choose>
                <xsl:when test="$Item-name = 'immunization'">
                    <code code="IMMUNIZ"/>
                </xsl:when>
                <xsl:otherwise>
                    <code code="DRUG"/>
                </xsl:otherwise>
            </xsl:choose>

            <!-- ActStatus: Indicates the status of the medication record at the time of the issue 
                Used to determine the relevance of the issue and the need to manage it.   For example, if the medication is on hold, it may be less of an issue than if it is being actively taken
            -->
            <statusCode code="active">
                <xsl:call-template name="codeSystem">
                    <xsl:with-param name="codeElement" select="$SubstanceProfileData/statusCode"/>
                </xsl:call-template>
            </statusCode>
            <!-- optional element for the date and time during which the patient is expected to be taking the drug which triggered the issue. -->
            <xsl:if test="$SubstanceProfileData/effectiveTime">
                <effectiveTime>
                    <xsl:call-template name="effectiveTime">
                        <xsl:with-param name="effectiveTime" select="$SubstanceProfileData/effectiveTime"/>
                    </xsl:call-template>
                </effectiveTime>
            </xsl:if>

            <!-- The amount of medication administered to the patient -->
            <xsl:if test="$SubstanceData/doseQuantity">
                <doseQuantity value="1" unit="mg">
                    <xsl:call-template name="valueAndUnit">
                        <xsl:with-param name="valueElement" select="$SubstanceData/doseQuantity"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </doseQuantity>
            </xsl:if>

            <xsl:if test="$SubstanceData/drug">
                <!-- optional element to identify the medication -->
                <consumable>
                    <!-- A pharmaceutical product to be supplied and/or administered to a patient.  
                    Encompasses manufactured drug products, generic classifications, prescription medications, over-the-counter medications and recreational drugs.
                -->
                    <medication>
                        <xsl:call-template name="Drug">
                            <xsl:with-param name="description" select="$SubstanceData/drug/@description"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                        </xsl:call-template>
                    </medication>
                </consumable>
            </xsl:if>
        </substanceAdministration>
    </xsl:template>

    <xsl:template name="IssueItem-observationCodedEvent">
        <xsl:param name="description"/>
        <xsl:param name="Item-name"/>
        <xsl:param name="ProfileData"/>
        <xsl:param name="msgType"/>

        <xsl:variable name="ObservationData" select="$BaseData/child::node()/child::node()[name()=$Item-name][@description=$description]"/>
        <xsl:variable name="ObservationProfileData" select="$ProfileData/items/child::node()[name()=$Item-name][@description=$description]"/>

        <observationCodedEvent>
            <!-- Unique identifier for the record of the coded observation (e.g. allergy, medical condition, pregnancy status, etc.) that contributed to the issue.  -->
            <id>
                <xsl:call-template name="ID_Element">
                    <xsl:with-param name="Record" select="$ObservationProfileData/record-id"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                </xsl:call-template>
            </id>
            <!-- Distinguishes the kinds of coded observation that could be the trigger for clinical issue detection. Coded Observation types include: 
            Allergy, Intolerance, Medical Condition, Indication, Pregnancy status, Lactation status and other observable information about a person that 
            may be deemed as a possible trigger for clinical issue detection. Use ObservationIssueTriggerCodedObservationType -->

            <code>
                <xsl:attribute name="code">
                    <xsl:choose>
                        <xsl:when test="$ObservationData/type">
                            <xsl:value-of select="$ObservationData/type/@code"/>
                        </xsl:when>
                        <xsl:when test="$Item-name = 'allergy'">ALLERGY</xsl:when>
                        <xsl:otherwise>MEDICAL CONDITION</xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
            </code>


            <statusCode code="active">
                <xsl:call-template name="codeSystem">
                    <xsl:with-param name="codeElement" select="$ObservationProfileData/statusCode"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                </xsl:call-template>
            </statusCode>
            <!-- Denotes a specific coded observation made about a person that might have trigger the clinical issue detection -->
            <value code="PeanutButter">
                <xsl:call-template name="codeSystem">
                    <xsl:with-param name="codeElement" select="$ObservationData/value"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                </xsl:call-template>
            </value>
        </observationCodedEvent>

    </xsl:template>

    <xsl:template name="IssueItem-observationMeasurableEvent">
        <xsl:param name="description"/>
        <xsl:param name="Item-name"/>
        <xsl:param name="ProfileData"/>
        <xsl:param name="msgType"/>

        <xsl:variable name="ObservationData" select="$BaseData/child::node()/child::node()[name()=$Item-name][@description=$description]"/>
        <xsl:variable name="ObservationProfileData" select="$ProfileData/items/child::node()[name()=$Item-name][@description=$description]"/>

        <observationMeasurableEvent>
            <!-- Unique identifier for the record of the observation (e.g. height, weight or lab test/result) that contributed to the issue -->
            <id>
                <xsl:call-template name="ID_Element">
                    <xsl:with-param name="Record" select="$ObservationProfileData/record-id"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                </xsl:call-template>
            </id>
            <!-- ObservationIssueTriggerMeasuredObservationType: Distinguishes between the kinds of measurable observation that could be the trigger 
                for clinical issue detection. Measurable observation types include: Lab Result, Height, Weight, and other measurable information about a person 
                that may be deemed as a possible trigger for clinical issue detection.  -->
            <code code="3137-7">
                <xsl:call-template name="codeSystem">
                    <xsl:with-param name="codeElement" select="$ObservationData/code"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                </xsl:call-template>
            </code>
            <statusCode code="active">
                <xsl:call-template name="codeSystem">
                    <xsl:with-param name="codeElement" select="$ObservationProfileData/statusCode"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                </xsl:call-template>
            </statusCode>
            <xsl:if test="$ObservationData/value">
                <value>
                    <xsl:call-template name="valueAndUnit">
                        <xsl:with-param name="valueElement" select="$ObservationData/value"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </value>
            </xsl:if>
        </observationMeasurableEvent>

    </xsl:template>

    <xsl:template name="supplyEvent">
        <xsl:param name="id"/>
        <xsl:param name="msgType"/>
        <xsl:param name="fillCode"/>
        <xsl:param name="includeCode">true</xsl:param>

        <supplyEvent>
            <xsl:if test="$id">
                <id>
                    <xsl:call-template name="ID_Element">
                        <xsl:with-param name="msgType" select="$msgType"/>
                        <xsl:with-param name="Record" select="$id"/>
                        <xsl:with-param name="Default_OID">DIS_DISPENSE_ID</xsl:with-param>
                    </xsl:call-template>
                </id>
            </xsl:if>
            <!-- Indicates the type of dispensing event that is performed. Examples include: Trial Fill, Completion of Trial, Partial Fill, Emergency Fill, Samples, etc. ActPharmacySupplyType vocab -->
            <xsl:if test="$includeCode = 'true'">
            <code code="">
                <xsl:choose>
                    <xsl:when test="$fillCode">
                        <xsl:attribute name="code"><xsl:value-of select="$fillCode"/></xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="codeSystem">
                            <xsl:with-param name="codeElement" select="code"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </code>
            </xsl:if>
            
            <!-- Dispense Processing and Pickup Date Represents the date the dispense product was prepared and when the product was picked up by or delivered to the patient. 
            The dispense processing date and pickup date can be back dated to reflect when the actual processing and pickup occurred. 
            The lower-bound of the period signifies the dispense-processing date whereas the upper-bound signifies the dispense-pickup date. Since we don't know
            the pickup date at this point, only the low value should be used.
        -->
            <effectiveTime>
                <xsl:call-template name="effectiveTime">
                    <xsl:with-param name="effectiveTime" select="effectiveTime"/>
                </xsl:call-template>
            </effectiveTime>

            <!-- The amount of medication that has been dispensed. Includes unit of measure. -->
            <quantity>
                <xsl:choose>
                    <xsl:when test="quantity">
                        <xsl:call-template name="valueAndUnit">
                            <xsl:with-param name="valueElement" select="quantity"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="nullFlavor"/>
                    </xsl:otherwise>
                </xsl:choose>
            </quantity>
            <!-- The number of days that the dispensed quantity is expected to last 
                        useful in determining and managing certain contraindications ('Fill-Too-Soon', 'Fill-Too-Late', and 'Duration of Therapy')
                    -->
            <expectedUseTime>
                <xsl:call-template name="effectiveTime">
                    <xsl:with-param name="effectiveTime" select="expectedUseTime"/>
                </xsl:call-template>
            </expectedUseTime>

            <!-- the drug -->
            <product>
                <medication>
                    <xsl:call-template name="Drug">
                        <xsl:with-param name="description" select="drug/@description"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </medication>
            </product>

        </supplyEvent>
    </xsl:template>

    <xsl:template name="Drug">
        <xsl:param name="description"/>
        <xsl:param name="msgType"/>

        <xsl:variable name="drugData" select="$BaseData/drugs/drug[@description=$description]"/>
        <player>
            <!-- An identifier for a type of drug. Depending on where the drug is being referenced, the drug may be identified at different levels of abstraction. 
                E.g. Manufactured drug (including vaccine). -->
            <code>
                <xsl:choose>
                    <xsl:when test="$drugData/code">
                        <xsl:call-template name="codeSystem">
                            <xsl:with-param name="codeElement" select="$drugData/code"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="nullFlavor"/>
                    </xsl:otherwise>
                </xsl:choose>
            </code>
            <name>
                <xsl:value-of select="$drugData/name"/>
            </name>

            <!-- rest of elements are optional -->
            <!-- A free form textual description of a drug. This usually is only populated for custom compounds, providing instructions on the composition and creation of the compound. -->
            <xsl:if test="$drugData/desc">
                <desc>
                    <xsl:value-of select="$drugData/desc"/>
                </desc>
            </xsl:if>
            <!-- Indicates the form in which the drug product must be, or has been manufactured or custom prepared. OrderableDrugForm vocab -->
            <xsl:if test="$drugData/formCode/@code">
                <formCode code="">
                    <xsl:call-template name="codeSystem">
                        <xsl:with-param name="codeElement" select="$drugData/formCode"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </formCode>
            </xsl:if>

            <!-- optional identification of manufacturer -->
            <xsl:if test="$drugData/manufacturer">
                <asManufacturedProduct>
                    <manufacturer>
                        <name>
                            <xsl:value-of select="$drugData/manufacturer"/>
                        </name>
                    </manufacturer>
                </asManufacturedProduct>
            </xsl:if>

            <!-- Information about how the dispensed drug is or should be contained -->
            <asContent>
                <xsl:if test="$drugData/quantity">
                    <quantity>
                        <xsl:attribute name="value">
                            <xsl:value-of select="$drugData/quantity/@value"/>
                        </xsl:attribute>
                        <xsl:if test="$drugData/quantity/@unit">
                            <xsl:attribute name="unit">
                                <xsl:value-of select="$drugData/quantity/@unit"/>
                            </xsl:attribute>
                        </xsl:if>
                    </quantity>
                </xsl:if>

                <xsl:if test="$drugData/packageformCode/@code">
                    <containerPackagedMedicine>
                        <!-- A coded value denoting a specific kind of a container. Used to identify a requirement for a particular type of compliance packaging: CompliancePackageEntityType vocab -->
                        <formCode>
                            <xsl:attribute name="code">
                                <xsl:value-of select="$drugData/packageformCode/@code"/>
                            </xsl:attribute>
                        </formCode>
                    </containerPackagedMedicine>
                </xsl:if>

            </asContent>
            <xsl:for-each select="$drugData/ingredient">
                <ingredient negationInd="false">
                    <xsl:if test="@negation">
                        <xsl:attribute name="negationInd">
                            <xsl:value-of select="@negation"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="quantity">
                        <quantity>
                            <xsl:call-template name="valueAndUnit">
                                <xsl:with-param name="valueElement" select="quantity"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                            </xsl:call-template>
                        </quantity>
                    </xsl:if>
                    <ingredient>
                        <!-- The unique identifier for the drug or chemical.  ActiveIngredientDrugEntityType -->
                        <code>
                            <xsl:call-template name="codeSystem">
                                <xsl:with-param name="codeElement" select="code"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                            </xsl:call-template>
                        </code>
                        <name>
                            <xsl:value-of select="name"/>
                        </name>
                    </ingredient>
                </ingredient>
            </xsl:for-each>

        </player>
    </xsl:template>

    <xsl:template name="ProfService">
        <xsl:param name="description"/>
        <xsl:param name="ProfileData"/>
        <xsl:param name="notesIndicator"/>
        <xsl:param name="msgAction"/>
        <xsl:param name="msgType"/>
        <!-- addRequest|queryResponse -->

        <xsl:variable name="ProfServiceProfileData" select="$ProfileData/items/profService[@description=$description]"/>


        <procedureEvent>
            <xsl:if test="$msgAction='queryResponse'">
                <id>
                    <xsl:call-template name="ID_Element">
                        <xsl:with-param name="Record" select="$ProfServiceProfileData/record-id"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                        <xsl:with-param name="Default_OID">DIS_PROF_SERVICE_ID</xsl:with-param>
                    </xsl:call-template>
                </id>
            </xsl:if>
            <code>
                <xsl:call-template name="codeSystem">
                    <xsl:with-param name="codeElement" select="$ProfServiceProfileData/code"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                </xsl:call-template>
            </code>
            <statusCode>
                <xsl:call-template name="codeSystem">
                    <xsl:with-param name="codeElement" select="$ProfServiceProfileData/statusCode"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                </xsl:call-template>
            </statusCode>
            <effectiveTime>
                <xsl:choose>
                    <xsl:when test="$ProfServiceProfileData/effectiveTime">
                        <xsl:call-template name="effectiveTime">
                            <xsl:with-param name="effectiveTime" select="$ProfServiceProfileData/effectiveTime"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="nullFlavor"/>
                    </xsl:otherwise>
                </xsl:choose>
            </effectiveTime>
            <!-- patient -->
            <subject>
                <xsl:call-template name="PatientByDescription">
                    <xsl:with-param name="description" select="$ProfileData/patient/@description"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="format">CeRx</xsl:with-param>
                    <xsl:with-param name="use_phn">true</xsl:with-param>
                    <xsl:with-param name="use_name">true</xsl:with-param>
                    <xsl:with-param name="use_gender">true</xsl:with-param>
                    <xsl:with-param name="use_dob">true</xsl:with-param>
                    <xsl:with-param name="use_telecom">true</xsl:with-param>
                </xsl:call-template>
            </subject>

            <xsl:if test="$msgAction='queryResponse'">
                <xsl:if test="$ProfServiceProfileData/supervisor">
                    <responsibleParty>
                        <xsl:call-template name="ProviderByDescription">
                            <xsl:with-param name="description" select="$ProfServiceProfileData/supervisor/@description"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="format">CeRx</xsl:with-param>
                        </xsl:call-template>
                    </responsibleParty>
                </xsl:if>
                <performer>
                    <xsl:call-template name="ProviderByDescription">
                        <xsl:with-param name="description" select="$ProfServiceProfileData/author/@description"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                        <xsl:with-param name="format">CeRx</xsl:with-param>
                    </xsl:call-template>
                </performer>
                <location>
                    <xsl:call-template name="LocationByDescription">
                        <xsl:with-param name="description" select="$ProfServiceProfileData/location/@description"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                        <xsl:with-param name="format">CeRx</xsl:with-param>
                    </xsl:call-template>
                </location>
            </xsl:if>


            <!-- optionally Identifies the provider who requested the service -->
            <xsl:if test="$ProfServiceProfileData/requestedBy">
                <inFulfillmentOf>
                    <actRequest>
                        <author>
                            <xsl:call-template name="ProviderByDescription">
                                <xsl:with-param name="description" select="$ProfServiceProfileData/requestedBy/@description"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                                <xsl:with-param name="format">CeRx</xsl:with-param>
                            </xsl:call-template>
                        </author>
                    </actRequest>
                </inFulfillmentOf>
            </xsl:if>

            <!-- if the return notes flag was off on the query instead of returning the notes, we willl simply use the presence or absence of this
                element to comunicate whether notes are attached or not -->
            <xsl:choose>
                <xsl:when test="$msgAction='addRequest'">
                    <xsl:for-each select="$ProfServiceProfileData/note[1]">
                        <subjectOf>
                            <xsl:call-template name="annotation">
                                <xsl:with-param name="msgType" select="$msgType"/>
                                <xsl:with-param name="author-description" select="$ProfServiceProfileData/author/@description"/>
                            </xsl:call-template>
                        </subjectOf>
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test="$msgAction='queryResponse'">

                    <!-- if the return notes flag was off on the query instead of returning the notes, we willl simply use the presence or absence of this
                        element to comunicate whether notes are attached or not -->
                    <xsl:if test="$notesIndicator and $notesIndicator = 'false' and $ProfServiceProfileData/note">
                        <subjectOf1>
                            <subsetCode code="SUM"/>
                            <annotationIndicator>
                                <statusCode code="completed"/>
                            </annotationIndicator>
                        </subjectOf1>
                    </xsl:if>

                    <xsl:if test="$notesIndicator and $notesIndicator != 'false'">
                        <xsl:for-each select="$ProfServiceProfileData/note">
                            <subjectOf2>
                                <xsl:call-template name="annotation">
                                    <xsl:with-param name="msgType" select="$msgType"/>
                                    <xsl:with-param name="author-description" select="author/@description"/>
                                </xsl:call-template>
                            </subjectOf2>
                        </xsl:for-each>
                    </xsl:if>

                </xsl:when>
            </xsl:choose>

        </procedureEvent>

    </xsl:template>

    <xsl:template name="Reaction">
        <xsl:param name="description"/>
        <xsl:param name="ProfileData"/>
        <xsl:param name="notesIndicator"/>
        <xsl:param name="msgAction"/>
        <xsl:param name="msgType"/>
        <!-- addRequest|removeRequest|queryResponse -->

        <xsl:variable name="ReactionData" select="$BaseData/reactions/reaction[@description=$description]"/>
        <xsl:variable name="ReactionProfileData" select="$ProfileData/items/reaction[@description=$description]"/>

        <reactionObservationEvent>
            <xsl:if test="$msgAction='updateRequest' or $msgAction='queryResponse'">
                <!-- An identifier assigned to the record of the adverse reaction -->
                <id>
                    <xsl:call-template name="ID_Element">
                        <xsl:with-param name="Record" select="$ReactionProfileData/record-id"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                        <xsl:with-param name="Default_OID">DIS_REACTION_ID</xsl:with-param>
                    </xsl:call-template>
                </id>
            </xsl:if>

            <!-- Indicates the type of diagnosis being captured. If using SNOMED, this will contain the diagnosis.  Otherwise it will be a fixed value of 'DX' -->
            <code code="DX"/>
            <!-- optional free form description of the reaction. This is a specific description of the reaction, as oppossed to annotations on the reaction. -->
            <xsl:if test="$ReactionData/text">
                <text>
                    <xsl:value-of select="$ReactionData/text"/>
                </text>
            </xsl:if>
            <!-- fixed value of completed -->
            <statusCode code="completed"/>


            <!-- optional field for the date on which the reaction occurrence began : IVL.LOW-->
            <xsl:if test="$ReactionProfileData/effectiveTime">
                <effectiveTime>
                    <xsl:call-template name="effectiveTime">
                        <xsl:with-param name="effectiveTime" select="$ReactionProfileData/effectiveTime"/>
                    </xsl:call-template>
                </effectiveTime>
            </xsl:if>


            <xsl:if test="$ReactionData/value/@code">
                <!-- optional field that specifies the kind of reaction, as experienced by the patient - optional because not used by SNOWMED : SubjectReaction vocab but is CWE so any value can be used -->
                <value code="">
                    <xsl:call-template name="codeSystem">
                        <xsl:with-param name="codeElement" select="$ReactionData/value"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </value>
            </xsl:if>

            <!-- identity of patient to whom reaction is attached -->
            <subject>
                <xsl:call-template name="PatientByDescription">
                    <xsl:with-param name="description" select="$ProfileData/patient/@description"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="format">CeRx</xsl:with-param>
                    <xsl:with-param name="use_phn">true</xsl:with-param>
                    <xsl:with-param name="use_name">true</xsl:with-param>
                    <xsl:with-param name="use_gender">true</xsl:with-param>
                    <xsl:with-param name="use_dob">true</xsl:with-param>
                    <xsl:with-param name="use_telecom">true</xsl:with-param>
                </xsl:call-template>
            </subject>

            <xsl:if test="$msgAction='queryResponse' and $ReactionProfileData/supervisor">
                <responsibleParty>
                    <xsl:call-template name="ProviderByDescription">
                        <xsl:with-param name="description" select="$ReactionProfileData/supervisor/@description"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                        <xsl:with-param name="format">CeRx</xsl:with-param>
                    </xsl:call-template>
                </responsibleParty>
            </xsl:if>

            <!-- person responsible for the event that caused this message - the pharmacist, doctor, or most likely a public health nurse -->
            <xsl:if test="$msgAction='queryResponse' ">
                <author typeCode="AUT">
                    <time>
                        <xsl:call-template name="effectiveTime">
                            <xsl:with-param name="effectiveTime" select="$ReactionProfileData/author"/>
                        </xsl:call-template>
                    </time>
                    <xsl:call-template name="ProviderByDescription">
                        <xsl:with-param name="description" select="$ReactionProfileData/author/@description"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                        <xsl:with-param name="format">CeRx</xsl:with-param>
                    </xsl:call-template>
                </author>
            </xsl:if>
            <!--   optional element to identify the source of the recorded information - a patient, patient's agent, or a provider x_InformationSource vocab-->
            <xsl:if test="$ReactionProfileData/informant">
                <informant>
                    <time>
                        <xsl:call-template name="nullFlavor"/>
                    </time>
                    <!-- choice between patient, patient's agent, or a provider -->
                    <xsl:call-template name="InformantByDescription">
                        <xsl:with-param name="patient-description" select="$ProfileData/patient/@description"/>
                        <xsl:with-param name="description" select="$ReactionProfileData/informant/@description"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                        <xsl:with-param name="format">CeRx</xsl:with-param>
                    </xsl:call-template>
                </informant>
            </xsl:if>

            <!-- Indicates the service delivery location where the allergy was recorded -->
            <xsl:if test="$msgAction='queryResponse' and $ReactionProfileData/location">
                <location>
                    <xsl:call-template name="LocationByDescription">
                        <xsl:with-param name="description" select="$ReactionProfileData/location/@description"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                        <xsl:with-param name="format">CeRx</xsl:with-param>
                    </xsl:call-template>
                </location>
            </xsl:if>

            <xsl:choose>
                <xsl:when test="$msgAction='addRequest'">
                    <xsl:for-each select="$ReactionProfileData/note[1]">
                        <subjectOf1>
                            <xsl:call-template name="annotation">
                                <xsl:with-param name="msgType" select="$msgType"/>
                                <xsl:with-param name="author-description" select="$ReactionProfileData/author/@description"/>
                            </xsl:call-template>
                        </subjectOf1>
                    </xsl:for-each>
                    <!-- severity of the reaction -->
                    <xsl:call-template name="severityObservation">
                        <xsl:with-param name="severityData" select="$ReactionProfileData/severity"/>
                        <xsl:with-param name="elementName">subjectOf2</xsl:with-param>
                    </xsl:call-template>
                    <!-- 0..10 elements for a recording of the exposures and causality assessment deemed to be related to the reaction -->
                    <xsl:for-each select="$ReactionProfileData/exposure">
                        <subjectOf3>
                            <xsl:call-template name="causalityAssessment">
                                <xsl:with-param name="msgAction" select="$msgAction"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                                <xsl:with-param name="ProfileData" select="$ProfileData"/>
                            </xsl:call-template>
                        </subjectOf3>
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test="$msgAction='updateRequest'">
                    <!-- severity of the reaction -->
                    <xsl:call-template name="severityObservation">
                        <xsl:with-param name="severityData" select="$ReactionProfileData/severity"/>
                        <xsl:with-param name="elementName">subjectOf1</xsl:with-param>
                    </xsl:call-template>
                    <!-- 0..10 elements for a recording of the exposures and causality assessment deemed to be related to the reaction -->
                    <xsl:for-each select="$ReactionProfileData/exposure">
                        <subjectOf2>
                            <xsl:call-template name="causalityAssessment">
                                <xsl:with-param name="msgAction" select="$msgAction"/>
                                <xsl:with-param name="ProfileData" select="$ProfileData"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                            </xsl:call-template>
                        </subjectOf2>
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test="$msgAction='queryResponse'">
                    <xsl:if test="$notesIndicator and $notesIndicator != 'false'">
                        <xsl:for-each select="$ReactionProfileData/note">
                            <subjectOf1>
                                <xsl:call-template name="annotation">
                                    <xsl:with-param name="msgType" select="$msgType"/>
                                    <xsl:with-param name="author-description" select="author/@description"/>
                                </xsl:call-template>
                            </subjectOf1>
                        </xsl:for-each>
                    </xsl:if>

                    <!-- 0..10 elements for a recording of the exposures and causality assessment deemed to be related to the reaction -->
                    <xsl:for-each select="$ReactionProfileData/exposure">
                        <subjectOf2>
                            <xsl:call-template name="causalityAssessment">
                                <xsl:with-param name="msgAction" select="$msgAction"/>
                                <xsl:with-param name="ProfileData" select="$ProfileData"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                            </xsl:call-template>
                        </subjectOf2>
                    </xsl:for-each>

                    <!-- severity of the reaction -->
                    <xsl:call-template name="severityObservation">
                        <xsl:with-param name="severityData" select="$ReactionProfileData/severity"/>
                        <xsl:with-param name="elementName">subjectOf3</xsl:with-param>
                    </xsl:call-template>

                    <!-- if the return notes flag was off on the query instead of returning the notes, we willl simply use the presence or absence of this
                        element to comunicate whether notes are attached or not -->
                    <xsl:if test="$msgAction='queryResponse' and $notesIndicator and $notesIndicator = 'false' and $ReactionProfileData/note">
                        <subjectOf4>
                            <subsetCode code="SUM"/>
                            <annotationIndicator>
                                <statusCode code="completed"/>
                            </annotationIndicator>
                        </subjectOf4>
                    </xsl:if>
                </xsl:when>
            </xsl:choose>

        </reactionObservationEvent>

    </xsl:template>

    <xsl:template name="Allergy">
        <xsl:param name="description"/>
        <xsl:param name="ProfileData"/>
        <xsl:param name="notesIndicator"/>
        <xsl:param name="msgAction"/>
        <xsl:param name="msgType"/>

        <!-- addRequest|removeRequest|queryResponse -->

        <xsl:variable name="AllergyData" select="$BaseData/allergies/allergy[@description=$description]"/>
        <xsl:variable name="AllergyProfileData" select="$ProfileData/items/allergy[@description=$description]"/>

        <intoleranceCondition negationInd="false">
            <xsl:if test="$AllergyData/negation">
                <xsl:attribute name="negationInd">
                    <xsl:value-of select="$AllergyData/negation"/>
                </xsl:attribute>
            </xsl:if>

            <xsl:if test="$msgAction='updateRequest' or $msgAction='queryResponse'">
                <!-- id of the allergy -->
                <id>
                    <xsl:call-template name="ID_Element">
                        <xsl:with-param name="Record" select="$AllergyProfileData/record-id"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                        <xsl:with-param name="Default_OID">DIS_ALLERGY_ID</xsl:with-param>
                    </xsl:call-template>
                </id>
            </xsl:if>


            <!-- required element for a coded value denoting whether the record pertains to an intolerance or a true allergy.  
                (Allergies result from immunologic reactions.  Intolerances do not.). ObservationIntoleranceType Vocab -->
            <code>
                <xsl:call-template name="codeSystem">
                    <xsl:with-param name="codeElement" select="$AllergyData/code"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                </xsl:call-template>
            </code>
            <!-- required element to give a coded value that indicates whether an allergy/intolerance is 'ACTIVE' or 'COMPLETE' (indicating no longer active). 
                The system should always default the status of an allergy/intolerance record to 'ACTIVE'. -->
            <statusCode code="active">
                <xsl:if test="$AllergyProfileData/statusCode">
                    <xsl:call-template name="codeSystem">
                        <xsl:with-param name="codeElement" select="$AllergyProfileData/statusCode"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </xsl:if>
            </statusCode>

            <xsl:if test="$AllergyProfileData/effectiveTime">
                <!-- an optional element to give the date on which the recorded allergy is considered active -->
                <effectiveTime>
                    <xsl:call-template name="effectiveTime">
                        <xsl:with-param name="effectiveTime" select="$AllergyProfileData/effectiveTime"/>
                    </xsl:call-template>
                </effectiveTime>
            </xsl:if>

            <!-- ActUncertainty vocab - N: stated with no assertion of uncertainty  U: stated with uncertainty   -->
            <uncertaintyCode code="U">
                <xsl:attribute name="code">
                    <xsl:value-of select="$AllergyProfileData/uncertaintyCode/@code"/>
                </xsl:attribute>
            </uncertaintyCode>
            <!-- Indicates the drug or other material to which the patient is allergic or has an intolerance ,  IntoleranceValue Vocab CWE as not all allergens have coded values-->
            <xsl:if test="$msgAction='addRequest' or $msgAction='queryResponse'">
                <value>
                    <xsl:call-template name="codeSystem">
                        <xsl:with-param name="codeElement" select="$AllergyData/value"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </value>
            </xsl:if>

            <!-- the patient to whom the allergy applies -->
            <subject>
                <xsl:call-template name="PatientByDescription">
                    <xsl:with-param name="description" select="$ProfileData/patient/@description"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="format">CeRx</xsl:with-param>
                    <xsl:with-param name="use_phn">true</xsl:with-param>
                    <xsl:with-param name="use_name">true</xsl:with-param>
                    <xsl:with-param name="use_gender">true</xsl:with-param>
                    <xsl:with-param name="use_dob">true</xsl:with-param>
                </xsl:call-template>
            </subject>

            <xsl:if test="$msgAction='queryResponse' and $AllergyProfileData/supervisor">
                <responsibleParty>
                    <xsl:call-template name="ProviderByDescription">
                        <xsl:with-param name="description" select="$AllergyProfileData/supervisor/@description"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                        <xsl:with-param name="format">CeRx</xsl:with-param>
                    </xsl:call-template>
                </responsibleParty>
            </xsl:if>

            <!-- person responsible for the event that caused this message - the pharmacist, doctor, or most likely a public health nurse -->
            <xsl:if test="$msgAction='queryResponse' and $AllergyProfileData/author">
                <author typeCode="AUT">
                    <time>
                        <xsl:call-template name="effectiveTime">
                            <xsl:with-param name="effectiveTime" select="$AllergyProfileData/author"/>
                        </xsl:call-template>
                    </time>
                    <xsl:call-template name="ProviderByDescription">
                        <xsl:with-param name="description" select="$AllergyProfileData/author/@description"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                        <xsl:with-param name="format">CeRx</xsl:with-param>
                    </xsl:call-template>
                </author>
            </xsl:if>
            <!--   optional element to identify the source of the recorded information - a patient, patient's agent, or a provider x_InformationSource vocab-->
            <xsl:if test="$AllergyProfileData/informant">
                <informant>
                    <time>
                        <xsl:call-template name="nullFlavor"/>
                    </time>
                    <!-- choice between patient, patient's agent, or a provider -->
                    <xsl:call-template name="InformantByDescription">
                        <xsl:with-param name="patient-description" select="$ProfileData/patient/@description"/>
                        <xsl:with-param name="description" select="$AllergyProfileData/informant/@description"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                        <xsl:with-param name="format">CeRx</xsl:with-param>
                    </xsl:call-template>
                </informant>
            </xsl:if>

            <!-- Indicates the service delivery location where the allergy was recorded -->
            <xsl:if test="$msgAction='queryResponse' and $AllergyProfileData/location">
                <location>
                    <xsl:call-template name="LocationByDescription">
                        <xsl:with-param name="description" select="$AllergyProfileData/location/@description"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                        <xsl:with-param name="format">CeRx</xsl:with-param>
                    </xsl:call-template>
                </location>
            </xsl:if>


            <!--  can have 0-20 support elements that can either be a reaction or allergy test that confirms the allergy -->
            <!-- is a recording of a patient reaction that is believed to be associated with the allergy/intolerance -->
            <!-- 0..10 elements for a recording of the exposures and causality assessment deemed to be related to the reaction -->
            <xsl:for-each select="$AllergyProfileData/exposure">
                <support>
                    <xsl:call-template name="causalityAssessment">
                        <xsl:with-param name="msgAction" select="$msgAction"/>
                        <xsl:with-param name="ProfileData" select="$ProfileData"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </support>
            </xsl:for-each>


            <!-- is a recording of a patient test that confirms allergy/intolerance -->
            <xsl:for-each select="$AllergyProfileData/allergytest">
                <support>
                    <xsl:call-template name="allergyTestEvent">
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </support>
            </xsl:for-each>

            <xsl:if test="$msgAction='queryResponse'">
                <xsl:choose>
                    <xsl:when test="$notesIndicator = 'true' or $notesIndicator = 'TRUE'">
                        <xsl:for-each select="$AllergyProfileData/note">
                            <subjectOf1>
                                <xsl:call-template name="annotation">
                                    <xsl:with-param name="msgType" select="$msgType"/>
                                    <xsl:with-param name="author-description" select="author/@description"/>
                                </xsl:call-template>
                            </subjectOf1>
                        </xsl:for-each>
                    </xsl:when>
                </xsl:choose>
            </xsl:if>

            <xsl:if test="$msgAction='addRequest'">
                <xsl:for-each select="$AllergyProfileData/note[1]">
                    <subjectOf1>
                        <xsl:call-template name="annotation">
                            <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="author-description" select="$AllergyProfileData/author/@description"/>
                        </xsl:call-template>
                    </subjectOf1>
                </xsl:for-each>
            </xsl:if>

            <!-- severity of the allergy -->
            <xsl:choose>
                <xsl:when test="$msgAction='updateRequest'">
                    <xsl:call-template name="severityObservation">
                        <xsl:with-param name="severityData" select="$AllergyProfileData/severity"/>
                        <xsl:with-param name="elementName">subjectOf</xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="severityObservation">
                        <xsl:with-param name="severityData" select="$AllergyProfileData/severity"/>
                        <xsl:with-param name="elementName">subjectOf2</xsl:with-param>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>


            <!-- if the return notes flag was off on the query instead of returning the notes, we willl simply use the presence or absence of this
                element to comunicate whether notes are attached or not -->
            <xsl:if test="$msgAction='queryResponse' and not($notesIndicator = 'true' or $notesIndicator = 'TRUE') and $AllergyProfileData/note">
                <subjectOf3>
                    <subsetCode code="SUM"/>
                    <annotationIndicator>
                        <statusCode code="completed"/>
                    </annotationIndicator>
                </subjectOf3>
            </xsl:if>

        </intoleranceCondition>



    </xsl:template>

    <xsl:template name="Immunization">
        <xsl:param name="description"/>
        <xsl:param name="ProfileData"/>
        <xsl:param name="IssueIndicator"/>
        <xsl:param name="notesIndicator"/>
        <xsl:param name="msgAction"/>
        <xsl:param name="msgType"/>

        <!-- addRequest|removeRequest|queryResponse -->


        <xsl:variable name="ImmunizationData" select="$BaseData/immunizations/immunization[@description=$description]"/>
        <xsl:variable name="ImmunizationProfileData" select="$ProfileData/items/immunization[@description=$description]"/>

        <immunization negationInd="false">
            <xsl:if test="$ImmunizationProfileData/@refused">
                <xsl:attribute name="negationInd"><xsl:value-of select="$ImmunizationProfileData/@refused"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="$msgAction='updateRequest' or $msgAction='queryResponse'">
                <!--  immunization id -->
                <id>
                    <xsl:call-template name="ID_Element">
                        <xsl:with-param name="Record" select="$ImmunizationProfileData/record-id"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                        <xsl:with-param name="Default_OID">DIS_IMMUNIZATION_ID</xsl:with-param>
                    </xsl:call-template>
                </id>
            </xsl:if>

            <!-- Indicates that the type of administration is an administration, and for SNOMED, also indicates the specific type of administration.  Thus the attribute is mandatory. 
                      Fixed value of IMMUNIZ unless using snowmed in which case it is?
                 -->
            <code code="IMMUNIZ"/>
            <!-- fixed value -->
            <statusCode code="completed"/>
            <!-- The date vaccination(s) was administered to the patient. -->
            <effectiveTime>
                <xsl:call-template name="effectiveTime">
                    <xsl:with-param name="effectiveTime" select="$ImmunizationProfileData/effectiveTime"/>
                </xsl:call-template>
            </effectiveTime>

            <!-- optional element which if present, indicates a patient's reason for refusing to be immunized, ActNoAdministrationReason  -->
            <xsl:if test="$ImmunizationData/reasonCode">
                <reasonCode code="">
                    <xsl:call-template name="codeSystem">
                        <xsl:with-param name="codeElement" select="$ImmunizationData/reasonCode"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </reasonCode>
            </xsl:if>

            <!-- the means by which the drug was administered to the patient, RouteOfAdministration vocab -->
            <xsl:if test="$ImmunizationData/routeCode">
                <routeCode code="">
                    <xsl:call-template name="codeSystem">
                        <xsl:with-param name="codeElement" select="$ImmunizationData/routeCode"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </routeCode>
            </xsl:if>

            <!-- A coded value denoting the body area where the immunization was administered, HumanSubstanceAdministrationSite vocab -->
            <xsl:if test="$ImmunizationData/approachSiteCode">
                <approachSiteCode code="">
                    <xsl:call-template name="codeSystem">
                        <xsl:with-param name="codeElement" select="$ImmunizationData/approachSiteCode"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </approachSiteCode>
            </xsl:if>

            <!-- The amount of the vaccine administered to/by the patient -->
            <doseQuantity>
                <xsl:choose>
                    <xsl:when test="$ImmunizationData/doseQuantity">
                        <xsl:call-template name="valueAndUnit">
                            <xsl:with-param name="valueElement" select="$ImmunizationData/doseQuantity"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="nullFlavor"/>
                    </xsl:otherwise>
                </xsl:choose>
            </doseQuantity>

            <!-- identity of patient to whom immunization is attached -->
            <subject>
                <xsl:call-template name="PatientByDescription">
                    <xsl:with-param name="description" select="$ProfileData/patient/@description"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="format">CeRx</xsl:with-param>
                    <xsl:with-param name="use_phn">true</xsl:with-param>
                    <xsl:with-param name="use_name">true</xsl:with-param>
                    <xsl:with-param name="use_gender">true</xsl:with-param>
                    <xsl:with-param name="use_dob">true</xsl:with-param>
                </xsl:call-template>
            </subject>

            <!-- medication for immunization -->
            <consumable>
                <medication>
                    <xsl:call-template name="Drug">
                        <xsl:with-param name="description" select="$ImmunizationData/drug/@description"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </medication>
            </consumable>


            <xsl:if test="$msgAction='queryResponse' and $ImmunizationProfileData/supervisor">
                <responsibleParty>
                    <xsl:call-template name="ProviderByDescription">
                        <xsl:with-param name="description" select="$ImmunizationProfileData/supervisor/@description"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                        <xsl:with-param name="format">CeRx</xsl:with-param>
                    </xsl:call-template>
                </responsibleParty>
            </xsl:if>

            <!-- person responsible for the event that caused this message - the pharmacist, doctor, or most likely a public health nurse -->
            <xsl:if test="$msgAction='queryResponse' and $ImmunizationProfileData/author">
                <author typeCode="AUT">
                    <xsl:call-template name="ProviderByDescription">
                        <xsl:with-param name="description" select="$ImmunizationProfileData/author/@description"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                        <xsl:with-param name="format">CeRx</xsl:with-param>
                    </xsl:call-template>
                </author>
            </xsl:if>
            <!--   optional element to identify the source of the recorded information - a patient, patient's agent, or a provider x_InformationSource vocab-->
            <xsl:if test="$ImmunizationProfileData/informant">
                <informant>
                    <xsl:choose>
                        <xsl:when test="$msgAction='updateRequest' or $msgAction='queryResponse'">
                            <!-- choice between patient, patient's agent, or a provider -->
                            <xsl:call-template name="InformantByDescriptionForImmunization">
                                <xsl:with-param name="description" select="$ImmunizationProfileData/informant/@description"/>
                                <xsl:with-param name="nodeName">informationSourceRole</xsl:with-param>
                            </xsl:call-template>

                        </xsl:when>
                        <xsl:otherwise>
                            <!-- choice between patient, patient's agent, or a provider -->
                            <xsl:call-template name="InformantByDescriptionForImmunization">
                                <xsl:with-param name="patient-description" select="$ProfileData/patient/@description"/>
                                <xsl:with-param name="description" select="$ImmunizationProfileData/informant/@description"/>
                                <xsl:with-param name="nodeName">informantionSourceRole</xsl:with-param>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </informant>
            </xsl:if>

            <!-- Indicates the service delivery location where the immunization was recorded -->
            <xsl:if test="$msgAction='queryResponse' and $ImmunizationProfileData/location">
                <location>
                    <xsl:call-template name="LocationByDescription">
                        <xsl:with-param name="description" select="$ImmunizationProfileData/location/@description"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                        <xsl:with-param name="format">CeRx</xsl:with-param>
                    </xsl:call-template>
                </location>
            </xsl:if>


            <!-- optional element to specify whether there is more that 1 dose in the course of immunizations -->
            <xsl:if test="$ImmunizationProfileData/immunizationPlan">
                <inFulfillmentOf>
                    <!-- Indicates whether this is the initial immunization (Dose Number = 1) or a specific booster (Dose Number = 2 means first booster, 3 means 2nd booster, etc.) -->
                    <sequenceNumber value="1">
                        <xsl:attribute name="value">
                            <xsl:value-of select="$ImmunizationProfileData/immunizationPlan/sequenceNumber/@value"/>
                        </xsl:attribute>
                    </sequenceNumber>
                    <!-- Required element that specifies whether there is more than 1 dose in the course of immunizations.
                          Allows the system to record a specific immunization event as  one of several within a course of immunizations.  
                          Allows tracking whether immunization plans have been completed
                     -->
                    <immunizationPlan>
                        <!-- fixed value -->
                        <code code="IMMUNIZ"/>
                        <!-- fixed value -->
                        <statusCode code="active"/>
                        <xsl:choose>
                            <xsl:when test="$ImmunizationProfileData/immunizationPlan/@type = 'fulfillment'">
                                <!-- optional element to indicate the date on which the overall immunization therapy is to be repeated - i.e. in 1 years time, you will need another flu shot -->
                                <fulfillment>
                                    <xsl:if test="$msgAction='addRequest'">
                                        <subsetCode code="NEXT">
                                            <xsl:if test="$ImmunizationProfileData/immunizationPlan/subsetCode">
                                                <xsl:call-template name="codeSystem">
                                                    <xsl:with-param name="codeElement" select="$ImmunizationProfileData/immunizationPlan/subsetCode"/>
                                                    <xsl:with-param name="msgType" select="$msgType"/>
                                                </xsl:call-template>
                                            </xsl:if>
                                        </subsetCode>
                                    </xsl:if>
                                    <nextPlannedImmunization>
                                        <!-- fixed value -->
                                        <code code="IMMUNIZ"/>
                                        <!-- fixed value -->
                                        <statusCode code="active"/>
                                        <!-- Indicates the date on which the next course of immunization is to be undertaken -->
                                        <effectiveTime>
                                            <xsl:call-template name="effectiveTime">
                                                <xsl:with-param name="effectiveTime" select="$ImmunizationProfileData/immunizationPlan/effectiveTime"/>
                                            </xsl:call-template>
                                        </effectiveTime>
                                    </nextPlannedImmunization>
                                </fulfillment>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- optional element to indicate the date on which the next sequential dose for the immunization course is to be given 
                                - i.e. in two months time you will need a 2nd booster shot for blah blah blah. You would only use one of fulfillment or successor, not both -->
                                <successor>
                                    <nextImmunizationPlan>
                                        <code code="IMMUNIZ"/>
                                        <!-- fixed value -->
                                        <statusCode code="active"/>
                                        <effectiveTime>
                                            <xsl:call-template name="effectiveTime">
                                                <xsl:with-param name="effectiveTime" select="$ImmunizationProfileData/immunizationPlan/effectiveTime"/>
                                            </xsl:call-template>
                                        </effectiveTime>
                                    </nextImmunizationPlan>
                                </successor>
                            </xsl:otherwise>
                        </xsl:choose>
                    </immunizationPlan>
                </inFulfillmentOf>
            </xsl:if>

            <xsl:choose>
                <xsl:when test="$msgAction='queryResponse'">
                    <!-- 0..25 elements for all the issues attached to the immunization  (if the return issues flag was on in the query) -->
                    <!-- TODO: Add Issue control -->
                    <xsl:call-template name="IssueElements">
                        <xsl:with-param name="repeatingElementName">subjectOf1</xsl:with-param>
                        <xsl:with-param name="IssueIndicator" select="$IssueIndicator"/>
                        <xsl:with-param name="ItemProfileData" select="$ImmunizationProfileData"/>
                        <xsl:with-param name="ItemData" select="$ImmunizationData"/>
                        <xsl:with-param name="ProfileData" select="$ProfileData"/>
                        <xsl:with-param name="msgAction" select="$msgAction"/>
                    </xsl:call-template>


                    <!-- 0..99 element for all the notes - if notes indicator flag is off, don't return -->
                    <xsl:if test="$notesIndicator and $notesIndicator != 'false'">
                        <xsl:for-each select="$ImmunizationProfileData/note">
                            <subjectOf2>
                                <xsl:call-template name="annotation">
                                    <xsl:with-param name="msgType" select="$msgType"/>
                                    <xsl:with-param name="author-description" select="author/@description"/>
                                </xsl:call-template>
                            </subjectOf2>
                        </xsl:for-each>
                    </xsl:if>


                    <!-- if the return issues flag was off on the query - we will use this element to communicate whether there are any issues
                        if present Indicates  there are issues 
                    -->
                    <xsl:call-template name="IssueIndicatorElements">
                        <xsl:with-param name="ElementName">subjectOf3</xsl:with-param>
                        <xsl:with-param name="IssueIndicator" select="$IssueIndicator"/>
                        <xsl:with-param name="ItemProfileData" select="$ImmunizationProfileData"/>
                        <xsl:with-param name="ItemData" select="$ImmunizationData"/>
                    </xsl:call-template>

                    <!-- if the return notes flag was off on the query instead of returning the notes, we willl simply use the presence or absence of this
                        element to comunicate whether notes are attached or not -->
                    <xsl:if test="$notesIndicator and $notesIndicator = 'false' and $ImmunizationProfileData/note">
                        <subjectOf4>
                            <subsetCode code="SUM"/>
                            <annotationIndicator>
                                <statusCode code="completed"/>
                            </annotationIndicator>
                        </subjectOf4>
                    </xsl:if>
                </xsl:when>

                <xsl:when test="$msgAction='addRequest'">
                    <!-- 0..1 element for all the notes - add message-->
                    <xsl:for-each select="$ImmunizationProfileData/note[1]">
                        <subjectOf>
                            <xsl:call-template name="annotation">
                                <xsl:with-param name="msgType" select="$msgType"/>
                                <xsl:with-param name="author-description" select="$ImmunizationProfileData/author/@description"/>
                            </xsl:call-template>
                        </subjectOf>
                    </xsl:for-each>
                </xsl:when>
            </xsl:choose>


            <!-- optional element that allows for Indicating whether there was an adverse event associated with the immunization -->
            <xsl:if test="$ImmunizationProfileData/reaction">
                <cause>
                    <adverseReactionObservationEvent>
                        <code code="ADVERSE_REACTION"/>
                        <statusCode code="completed"/>
                    </adverseReactionObservationEvent>
                </cause>
            </xsl:if>
        </immunization>
    </xsl:template>

    <xsl:template name="Observation">
        <xsl:param name="description"/>
        <xsl:param name="ProfileData"/>
        <xsl:param name="notesIndicator"/>
        <xsl:param name="msgAction"/>
        <xsl:param name="msgType"/>

        <!-- addRequest|removeRequest|queryResponse -->



        <xsl:variable name="observationData" select="$BaseData/observations/observation[@description=$description]"/>
        <xsl:variable name="observationProfileData" select="$ProfileData/items/observation[@description=$description]"/>

        <commonObservationEvent>
            <!-- id of the observation -->
            <xsl:if test="$msgAction='updateRequest' or $msgAction='queryResponse'">
                <id>
                    <xsl:call-template name="ID_Element">
                        <xsl:with-param name="Record" select="$observationProfileData/record-id"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                        <xsl:with-param name="Default_OID">DIS_OBSERVATION_ID</xsl:with-param>
                    </xsl:call-template>
                </id>
            </xsl:if>

            <!-- Identification of the type of measurement/observation that was made about the patient. Observation types include: height, weight, blood pressure, body mass, etc 
                CommonClinicalObservationType vocab
            -->
            <code>
                <xsl:choose>
                    <xsl:when test="$observationProfileData/code">
                        <xsl:call-template name="codeSystem">
                            <xsl:with-param name="codeElement" select="$observationProfileData/code"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="codeSystem">
                            <xsl:with-param name="codeElement" select="$observationData/code"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </code>

            <statusCode code="completed"/>

            <!-- The date and time at which the observation applies. -->
            <effectiveTime>
                <xsl:call-template name="effectiveTime">
                    <xsl:with-param name="effectiveTime" select="$observationProfileData/effectiveTime"/>
                </xsl:call-template>
            </effectiveTime>

            <!-- The amount (quantity and unit) that has been recorded for the specific type of observation. E.g. height in centimeters, weight in kilograms, etc.
                Valid observation unit types are: kg, cm, mmHg, mmol/mL, L/min, C, 1/min, etc 
            -->
            <xsl:if test="$observationProfileData/value or $observationData/value ">
                <value>
                    <xsl:choose>
                        <xsl:when test="$observationProfileData/value">
                            <xsl:call-template name="valueAndUnit">
                                <xsl:with-param name="valueElement" select="$observationProfileData/value"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="valueAndUnit">
                                <xsl:with-param name="valueElement" select="$observationData/value"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </value>
            </xsl:if>

            <!-- identity of patient to whom observation is attached -->
            <subject>
                <xsl:call-template name="PatientByDescription">
                    <xsl:with-param name="description" select="$ProfileData/patient/@description"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="format">CeRx</xsl:with-param>
                    <xsl:with-param name="use_phn">true</xsl:with-param>
                    <xsl:with-param name="use_name">true</xsl:with-param>
                    <xsl:with-param name="use_gender">true</xsl:with-param>
                    <xsl:with-param name="use_dob">true</xsl:with-param>
                </xsl:call-template>
            </subject>

            <!-- optionally the represented person - the supervisor -->
            <xsl:if test="$msgAction='queryResponse' and $observationProfileData/supervisor">
                <responsibleParty>
                    <xsl:call-template name="ProviderByDescription">
                        <xsl:with-param name="description" select="$observationProfileData/supervisor/@description"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                        <xsl:with-param name="format">CeRx</xsl:with-param>
                    </xsl:call-template>
                </responsibleParty>
            </xsl:if>

            <!-- person responsible for the event that caused this message - the pharmacist, doctor, or most likely a public health nurse -->
            <xsl:if test="$msgAction='queryResponse'">
                <author typeCode="AUT">
                    <time>
                        <xsl:call-template name="effectiveTime">
                            <xsl:with-param name="effectiveTime" select="$observationProfileData/author"/>
                        </xsl:call-template>
                    </time>
                    <xsl:call-template name="ProviderByDescription">
                        <xsl:with-param name="description" select="$observationProfileData/author/@description"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                        <xsl:with-param name="format">CeRx</xsl:with-param>
                    </xsl:call-template>
                </author>
            </xsl:if>

            <!-- Indicates the service delivery location where the allergy was recorded -->
            <xsl:if test="$msgAction='queryResponse' and $observationProfileData/location/@description">
                <location>
                    <xsl:call-template name="LocationByDescription">
                        <xsl:with-param name="description" select="$observationProfileData/location/@description"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                        <xsl:with-param name="format">CeRx</xsl:with-param>
                    </xsl:call-template>
                </location>
            </xsl:if>

            <!-- 0..2 Represents one of the two components (systolic and diastolic) of a blood pressure measurement
                Allows both parts to be captured as part of a single measurement.
            -->
            <xsl:if test="$observationProfileData/subObservation[1]">
                <component>
                    <subObservationEvent>
                        <!-- Distinguishes between the two type of blood measurement. This can either be code for SYSTOLIC or DYSTOLIC - CommonClinicalObservationType  -->
                        <code>
                            <xsl:call-template name="codeSystem">
                                <xsl:with-param name="codeElement" select="$observationProfileData/subObservation[1]/code"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                            </xsl:call-template>
                        </code>
                        <statusCode code="completed"/>
                        <!-- blood pressure measurement -->
                        <value>
                            <xsl:call-template name="valueAndUnit">
                                <xsl:with-param name="valueElement" select="$observationProfileData/subObservation[1]/value"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                            </xsl:call-template>
                        </value>
                    </subObservationEvent>
                </component>
            </xsl:if>
            <xsl:if test="$observationProfileData/subObservation[2]">
                <component>
                    <subObservationEvent>
                        <!-- Distinguishes between the two type of blood measurement. This can either be code for SYSTOLIC or DYSTOLIC - CommonClinicalObservationType  -->
                        <code>
                            <xsl:call-template name="codeSystem">
                                <xsl:with-param name="codeElement" select="$observationProfileData/subObservation[2]/code"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                            </xsl:call-template>
                        </code>
                        <statusCode code="completed"/>
                        <!-- blood pressure measurement -->
                        <value>
                            <xsl:call-template name="valueAndUnit">
                                <xsl:with-param name="valueElement" select="$observationProfileData/subObservation[2]/value"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                            </xsl:call-template>
                        </value>
                    </subObservationEvent>
                </component>
            </xsl:if>
            <!-- only use the observationData subObservations if we did not have them all in the observationProfileData -->
            <xsl:if test="not($observationProfileData/subObservation[2]) and $observationData/subObservation[1]">
                <component>
                    <subObservationEvent>
                        <!-- Distinguishes between the two type of blood measurement. This can either be code for SYSTOLIC or DYSTOLIC - CommonClinicalObservationType  -->
                        <code>
                            <xsl:call-template name="codeSystem">
                                <xsl:with-param name="codeElement" select="$observationData/subObservation[1]/code"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                            </xsl:call-template>
                        </code>
                        <statusCode code="completed"/>
                        <!-- blood pressure measurement -->
                        <value>
                            <xsl:call-template name="valueAndUnit">
                                <xsl:with-param name="valueElement" select="$observationData/subObservation[1]/value"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                            </xsl:call-template>
                        </value>
                    </subObservationEvent>
                </component>
            </xsl:if>
            <xsl:if test="not($observationProfileData/subObservation[1]) and $observationData/subObservation[2]">
                <component>
                    <subObservationEvent>
                        <!-- Distinguishes between the two type of blood measurement. This can either be code for SYSTOLIC or DYSTOLIC - CommonClinicalObservationType  -->
                        <code>
                            <xsl:call-template name="codeSystem">
                                <xsl:with-param name="codeElement" select="$observationData/subObservation[2]/code"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                            </xsl:call-template>
                        </code>
                        <statusCode code="completed"/>
                        <!-- blood pressure measurement -->
                        <value>
                            <xsl:call-template name="valueAndUnit">
                                <xsl:with-param name="valueElement" select="$observationData/subObservation[2]/value"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                            </xsl:call-template>
                        </value>
                    </subObservationEvent>
                </component>
            </xsl:if>

            <!-- optional element for a note attached to the allergy: notes now have language code, but have dropped code to indicate note type -->
            <xsl:choose>
                <xsl:when test="$msgAction='queryResponse' ">
                    <!-- if the return notes flag was off on the query instead of returning the notes, we willl simply use the presence or absence of this
                        element to comunicate whether notes are attached or not -->
                    <xsl:if test="$notesIndicator and $notesIndicator = 'false' and $observationProfileData/note">
                        <subjectOf1>
                            <subsetCode code="SUM"/>
                            <annotationIndicator>
                                <statusCode code="completed"/>
                            </annotationIndicator>
                        </subjectOf1>
                    </xsl:if>
                    <xsl:if test="$notesIndicator and $notesIndicator != 'false'">
                        <xsl:for-each select="$observationProfileData/note">
                            <subjectOf2>
                                <xsl:call-template name="annotation">
                                    <xsl:with-param name="msgType" select="$msgType"/>
                                    <xsl:with-param name="author-description" select="author/@description"/>
                                </xsl:call-template>
                            </subjectOf2>
                        </xsl:for-each>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="$msgAction='addRequest' ">
                    <xsl:for-each select="$observationProfileData/note[1]">
                        <subjectOf>
                            <xsl:call-template name="annotation">
                                <xsl:with-param name="msgType" select="$msgType"/>
                                <xsl:with-param name="author-description" select="$observationProfileData/author/@description"/>
                            </xsl:call-template>
                        </subjectOf>
                    </xsl:for-each>
                </xsl:when>
            </xsl:choose>
        </commonObservationEvent>

    </xsl:template>

    <xsl:template name="MedicalCondition">
        <xsl:param name="description"/>
        <xsl:param name="ProfileData"/>
        <xsl:param name="notesIndicator"/>
        <xsl:param name="msgAction"/>
        <xsl:param name="msgType"/>

        <!-- addRequest|updateRequest|queryResponse -->


        <xsl:variable name="conditionData" select="$BaseData/conditions/condition[@description=$description]"/>
        <xsl:variable name="conditionProfileData" select="$ProfileData/items/condition[@description=$description]"/>


        <medicalCondition>
            <!-- id of medical condition -->
            <xsl:if test="$msgAction='removeRequest' or $msgAction='updateRequest' or $msgAction='queryResponse'">
                <id>
                    <xsl:call-template name="ID_Element">
                        <xsl:with-param name="Record" select="$conditionProfileData/record-id"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                        <xsl:with-param name="Default_OID">DIS_MEDICAL_CONDITION_ID</xsl:with-param>
                    </xsl:call-template>
                </id>
            </xsl:if>


            <!-- If SNOMED is used, the diagnosis will appear here.  Otherwise, a fixed value of "DX" should be sent -->
            <code code="DX"/>
            <!-- A coded value that indicates whether the condition is still impacting the patient.  'ACTIVE' means the condition is still affecting the patient.  'COMPLETE' means the condition no longer holds -->
            <statusCode code="active">
                <xsl:attribute name="code">
                    <xsl:value-of select="$conditionProfileData/statusCode/@code"/>
                </xsl:attribute>
            </statusCode>
            <!-- Optional:  The date on which the condition first began and when it ended. For ongoing conditions such as chronic diseases, the upper boundary may be unknown.
                For transient conditions such as pregnancy, lactation, etc; the upper boundary of the period would usually be specified to signify the end of the condition. -->
            <effectiveTime>
                <xsl:call-template name="effectiveTime">
                    <xsl:with-param name="effectiveTime" select="$conditionProfileData/effectiveTime"/>
                </xsl:call-template>
            </effectiveTime>
            <!-- A code indicating the specific condition. E.g. Hypertension, Pregnancy  when using SNOMED the actual diagnosis will be sent in the 'code' attribute -->
            <value>
                <xsl:call-template name="codeSystem">
                    <xsl:with-param name="codeElement" select="$conditionData/value"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                </xsl:call-template>
            </value>

            <!-- identity of patient to whom allergy is attached -->
            <subject>
                <xsl:call-template name="PatientByDescription">
                    <xsl:with-param name="description" select="$ProfileData/patient/@description"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="format">CeRx</xsl:with-param>
                    <xsl:with-param name="use_phn">true</xsl:with-param>
                    <xsl:with-param name="use_name">true</xsl:with-param>
                    <xsl:with-param name="use_gender">true</xsl:with-param>
                    <xsl:with-param name="use_dob">true</xsl:with-param>
                </xsl:call-template>
            </subject>

            <!-- optionally the represented person - the supervisor -->
            <xsl:if test="$msgAction='queryResponse' and $conditionProfileData/supervisor">
                <responsibleParty>
                    <xsl:call-template name="ProviderByDescription">
                        <xsl:with-param name="description" select="$conditionProfileData/supervisor/@description"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                        <xsl:with-param name="format">CeRx</xsl:with-param>
                    </xsl:call-template>
                </responsibleParty>
            </xsl:if>

            <!-- person responsible for the event that caused this message - the pharmacist, doctor, or most likely a public health nurse -->
            <xsl:if test="$msgAction='queryResponse'">
                <author typeCode="AUT">
                    <time>
                        <xsl:call-template name="effectiveTime">
                            <xsl:with-param name="effectiveTime" select="$conditionProfileData/author"/>
                        </xsl:call-template>
                    </time>
                    <xsl:call-template name="ProviderByDescription">
                        <xsl:with-param name="description" select="$conditionProfileData/author/@description"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                        <xsl:with-param name="format">CeRx</xsl:with-param>
                    </xsl:call-template>
                </author>
            </xsl:if>

            <!--   optional element to identify the source of the recorded information - a patient, patient's agent, or a provider x_InformationSource vocab-->
            <xsl:if test="$conditionProfileData/informant">
                <informant>
                    <!-- choice between patient, patient's agent, or a provider -->
                    <xsl:call-template name="InformantByDescription">
                        <xsl:with-param name="patient-description" select="$ProfileData/patient/@description"/>
                        <xsl:with-param name="description" select="$conditionProfileData/informant/@description"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                        <xsl:with-param name="format">CeRx</xsl:with-param>
                    </xsl:call-template>
                </informant>
            </xsl:if>

            <!-- Indicates the service delivery location where the allergy was recorded -->
            <xsl:if test="$msgAction='queryResponse' and $conditionProfileData/location">
                <location>
                    <xsl:call-template name="LocationByDescription">
                        <xsl:with-param name="description" select="$conditionProfileData/location/@description"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                        <xsl:with-param name="format">CeRx</xsl:with-param>
                    </xsl:call-template>
                </location>
            </xsl:if>



            <!-- if the return notes flag was off on the query instead of returning the notes, we willl simply use the presence or absence of this
                element to comunicate whether notes are attached or not -->
            <xsl:if test="$msgAction='queryResponse' and $notesIndicator and $notesIndicator = 'false' and $conditionProfileData/note">
                <subjectOf1>
                    <subsetCode code="SUM"/>
                    <annotationIndicator>
                        <statusCode code="completed"/>
                    </annotationIndicator>
                </subjectOf1>
            </xsl:if>

            <xsl:choose>
                <!-- Query Response format spicific -->
                <xsl:when test="$msgAction='queryResponse'">
                    <xsl:if test="$notesIndicator and $notesIndicator != 'false'">
                        <xsl:for-each select="$conditionProfileData/note">
                            <subjectOf2>
                                <xsl:call-template name="annotation">
                                    <xsl:with-param name="msgType" select="$msgType"/>
                                    <xsl:with-param name="author-description" select="author/@description"/>
                                </xsl:call-template>
                            </subjectOf2>
                        </xsl:for-each>
                    </xsl:if>
                    <!-- If present, indicates that the recorded medical condition is deemed to be chronic -->
                    <xsl:if test="$conditionData/chronic or $conditionProfileData/chronic">
                        <subjectOf3>
                            <chronicIndicator>
                                <code code="CHRON"/>
                            </chronicIndicator>
                        </subjectOf3>
                    </xsl:if>
                </xsl:when>
                <!-- Add Request format spicific -->
                <xsl:when test="$msgAction='addRequest'">
                    <!-- If present, indicates that the recorded medical condition is deemed to be chronic -->
                    <xsl:if test="$conditionData/chronic or $conditionProfileData/chronic">
                        <subjectOf1>
                            <chronicIndicator>
                                <code code="CHRON"/>
                            </chronicIndicator>
                        </subjectOf1>
                    </xsl:if>
                    <!-- 0..1 elements for all the notes attached to the med condition Add message-->
                    <xsl:for-each select="$conditionProfileData/note[1]">
                        <subjectOf2>
                            <xsl:call-template name="annotation">
                                <xsl:with-param name="msgType" select="$msgType"/>
                                <xsl:with-param name="author-description" select="$conditionProfileData/author/@description"/>
                            </xsl:call-template>
                        </subjectOf2>
                    </xsl:for-each>
                </xsl:when>
                <!-- Update Request format spicific -->
                <xsl:when test="$msgAction='updateRequest'">
                    <!-- If present, indicates that the recorded medical condition is deemed to be chronic -->
                    <xsl:if test="$conditionData/chronic or $conditionProfileData/chronic">
                        <subjectOf>
                            <chronicIndicator>
                                <code code="CHRON"/>
                            </chronicIndicator>
                        </subjectOf>
                    </xsl:if>
                </xsl:when>
            </xsl:choose>

        </medicalCondition>

    </xsl:template>

    <xsl:template name="IssueList">
        <xsl:param name="ProfileData"/>
        <xsl:param name="IssueList-description"/>
        <xsl:param name="repeatingElementName"/>
        <xsl:param name="msgType"/>

        <xsl:variable name="IssueListData" select="$BaseData/issueLists/issueList[@description=$IssueList-description]"/>
        <xsl:for-each select="$IssueListData/issue">
            <xsl:element name="{$repeatingElementName}">
                <xsl:call-template name="Issue">
                    <xsl:with-param name="Issue-description" select="@description"/>
                    <xsl:with-param name="Issue-details" select="node()"/>
                    <xsl:with-param name="ProfileData" select="$ProfileData"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                </xsl:call-template>
            </xsl:element>
        </xsl:for-each>

    </xsl:template>

    <xsl:template name="Issue">
        <xsl:param name="Issue-description"/>
        <xsl:param name="Issue-details"/>
        <xsl:param name="IssueManagement-description"/>
        <xsl:param name="ProfileData"/>
        <xsl:param name="msgType"/>

        <xsl:variable name="IssueData" select="$BaseData/issues/issue[@description=$Issue-description]"/>

        <detectedIssueEvent>
            <!-- ActDetectedIssueCode vocab: A coded value that is used to distinguish between different kinds of issues INT indicates intolerance alert-->
            <code code="">
                <xsl:call-template name="codeSystem">
                    <xsl:with-param name="codeElement" select="$IssueData/code"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                </xsl:call-template>
            </code>
            <!-- An optional free form textual description of a detected issue -->
            <xsl:if test="$IssueData/text">
                <text>
                    <xsl:value-of select="$IssueData/text"/>
                </text>
            </xsl:if>
            <!-- some fixed value: irrelevant -->
            <statusCode code="active"/>
            <!-- A coded value denoting the importance of a detectable issue. Valid codes are: I - for Information, E - for Error, and W - for Warning -->
            <priorityCode code="I">
                <xsl:call-template name="codeSystem">
                    <xsl:with-param name="codeElement" select="$IssueData/priorityCode"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                </xsl:call-template>
            </priorityCode>

            <!-- 0..25 elements to indicate the event that trigger the issue -->
            <!-- get the list of Indicators from both the IssueData and IssueListData -->
            <!-- substanceAdministration -->
            <!-- active medication (prescription or non-prescription medication) that is recorded in the patient’s record and which contributed to triggering the issue -->
            <!-- supplyEvent -->
            <!-- Indicates a particular dispense event that resulted in the issue -->
            <!-- observationCodedEvent -->
            <!-- This is the recorded observation (e.g. allergy, medical condition, lab result, pregnancy status, etc.) of the patient that contributed to the issue being raised.  -->
            <!-- observationMeasurableEvent -->
            <!-- This is the recorded observation (e.g. height, weight, lab result, etc.) of the patient that contributed to the issue being raised.  -->
            <xsl:for-each select="$IssueData/causes/child::node()">
                <xsl:call-template name="IssueItems">
                    <xsl:with-param name="repeatingElementName">subject</xsl:with-param>
                    <xsl:with-param name="ProfileData" select="$ProfileData"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$Issue-details/causes/child::node()">
                <xsl:call-template name="IssueItems">
                    <xsl:with-param name="repeatingElementName">subject</xsl:with-param>
                    <xsl:with-param name="ProfileData" select="$ProfileData"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                </xsl:call-template>
            </xsl:for-each>


            <!-- optional element that is the decision support rule that triggered the issue: Provides detailed background for providers in evaluating the issue -->
            <xsl:if test="$IssueData/detectedIssueDefinition">
                <instantiation>
                    <detectedIssueDefinition>
                        <!--  issue id: Knowledgebase organization specific identifier for the issue definition: we return the id of the monograph here allowing them to provide 
                        this in a future query where we will return the monograph text -->
                        <id>
                            <xsl:attribute name="root">
                                <xsl:call-template name="getOIDRootByName">
                                    <xsl:with-param name="OID_Name" select="$IssueData/detectedIssueDefinition/id/@root"/>
                                    <xsl:with-param name="msgType" select="$msgType"/>
                                </xsl:call-template>
                            </xsl:attribute>
                            <xsl:attribute name="extension">
                                <xsl:value-of select="$IssueData/detectedIssueDefinition/id/@extension"/>
                            </xsl:attribute>
                        </id>
                        <author>
                            <assignedEntity>
                                <assignedOrganization>
                                    <name>
                                        <xsl:value-of select="$IssueData/detectedIssueDefinition/name"/>
                                    </name>
                                </assignedOrganization>
                            </assignedEntity>
                        </author>
                    </detectedIssueDefinition>
                </instantiation>
            </xsl:if>


            <!-- supplied management for the issue -->
            <!-- managment can be defined both in the issue or the issue list. -->
            <!-- if an issue management description is given then that is the only one we use. -->
            <xsl:choose>
                <xsl:when test="$IssueManagement-description">
                    <xsl:choose>
                        <xsl:when test="$Issue-details/managment[@description = $IssueManagement-description]">
                            <xsl:for-each select="$Issue-details/managment[@description = $IssueManagement-description][1]">
                                <mitigatedBy>
                                    <xsl:call-template name="detectedIssueManagement">
                                        <xsl:with-param name="msgType" select="$msgType"/>
                                    </xsl:call-template>
                                </mitigatedBy>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="$IssueData/managment[@description = $IssueManagement-description]">
                            <xsl:for-each select="$IssueData/managment[@description = $IssueManagement-description][1]">
                                <mitigatedBy>
                                    <xsl:call-template name="detectedIssueManagement">
                                        <xsl:with-param name="msgType" select="$msgType"/>
                                    </xsl:call-template>
                                </mitigatedBy>
                            </xsl:for-each>
                        </xsl:when>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:for-each select="$IssueData/managment">
                        <mitigatedBy>
                            <xsl:call-template name="detectedIssueManagement">
                                <xsl:with-param name="msgType" select="$msgType"/>
                            </xsl:call-template>
                        </mitigatedBy>
                    </xsl:for-each>
                    <xsl:for-each select="$Issue-details/managment">
                        <mitigatedBy>
                            <xsl:call-template name="detectedIssueManagement">
                                <xsl:with-param name="msgType" select="$msgType"/>
                            </xsl:call-template>
                        </mitigatedBy>
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>

            <!-- severity of the issue -->
            <xsl:call-template name="severityObservation">
                <xsl:with-param name="severityData" select="$IssueData/severity"/>
                <xsl:with-param name="elementName">subjectOf1</xsl:with-param>
            </xsl:call-template>
        </detectedIssueEvent>

    </xsl:template>

    <xsl:template name="ProfileIssueList">
        <xsl:param name="ProfileData"/>
        <xsl:param name="IssueData"/>
        <xsl:param name="msgType"/>

        <detectedIssueEvent>
            <!-- ActDetectedIssueCode vocab: A coded value that is used to distinguish between different kinds of issues INT indicates intolerance alert-->
            <code code="">
                <xsl:call-template name="codeSystem">
                    <xsl:with-param name="codeElement" select="$IssueData/code"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                </xsl:call-template>
            </code>
            <!-- An optional free form textual description of a detected issue -->
            <xsl:if test="$IssueData/text">
                <text>
                    <xsl:value-of select="$IssueData/text"/>
                </text>
            </xsl:if>
            <!-- some fixed value: irrelevant -->
            <statusCode code="active"/>
            <!-- A coded value denoting the importance of a detectable issue. Valid codes are: I - for Information, E - for Error, and W - for Warning -->
            <priorityCode code="I">
                <xsl:call-template name="codeSystem">
                    <xsl:with-param name="codeElement" select="$IssueData/priorityCode"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                </xsl:call-template>
            </priorityCode>

            <!-- 0..25 elements to indicate the event that trigger the issue -->
            <!-- get the list of Indicators from both the IssueData and IssueListData -->
            <!-- substanceAdministration -->
            <!-- active medication (prescription or non-prescription medication) that is recorded in the patient’s record and which contributed to triggering the issue -->
            <!-- supplyEvent -->
            <!-- Indicates a particular dispense event that resulted in the issue -->
            <!-- observationCodedEvent -->
            <!-- This is the recorded observation (e.g. allergy, medical condition, lab result, pregnancy status, etc.) of the patient that contributed to the issue being raised.  -->
            <!-- observationMeasurableEvent -->
            <!-- This is the recorded observation (e.g. height, weight, lab result, etc.) of the patient that contributed to the issue being raised.  -->
            <xsl:for-each select="$IssueData/causes/child::node()">
                <xsl:call-template name="IssueItems">
                    <xsl:with-param name="repeatingElementName">subject</xsl:with-param>
                    <xsl:with-param name="ProfileData" select="$ProfileData"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                </xsl:call-template>
            </xsl:for-each>


            <!-- optional element that is the decision support rule that triggered the issue: Provides detailed background for providers in evaluating the issue -->
            <xsl:if test="$IssueData/detectedIssueDefinition">
                <instantiation>
                    <detectedIssueDefinition>
                        <!--  issue id: Knowledgebase organization specific identifier for the issue definition: we return the id of the monograph here allowing them to provide 
                        this in a future query where we will return the monograph text -->
                        <id>
                            <xsl:attribute name="root">
                                <xsl:call-template name="getOIDRootByName">
                                    <xsl:with-param name="OID_Name" select="$IssueData/detectedIssueDefinition/id/@root"/>
                                    <xsl:with-param name="msgType" select="$msgType"/>
                                </xsl:call-template>
                            </xsl:attribute>
                            <xsl:attribute name="extension">
                                <xsl:value-of select="$IssueData/detectedIssueDefinition/id/@extension"/>
                            </xsl:attribute>
                        </id>
                        <author>
                            <assignedEntity>
                                <assignedOrganization>
                                    <name>
                                        <xsl:value-of select="$IssueData/detectedIssueDefinition/name"/>
                                    </name>
                                </assignedOrganization>
                            </assignedEntity>
                        </author>
                    </detectedIssueDefinition>
                </instantiation>
            </xsl:if>


            <!-- supplied management for the issue -->
            <!-- managment can be defined both in the issue or the issue list. -->
            <!-- if an issue management description is given then that is the only one we use. -->
            <xsl:for-each select="$IssueData/managment">
                <mitigatedBy>
                    <xsl:call-template name="detectedIssueManagement">
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </mitigatedBy>
            </xsl:for-each>

            <!-- severity of the issue -->
            <xsl:call-template name="severityObservation">
                <xsl:with-param name="severityData" select="$IssueData/severity"/>
                <xsl:with-param name="elementName">subjectOf1</xsl:with-param>
            </xsl:call-template>
        </detectedIssueEvent>

    </xsl:template>

    <xsl:template name="Dispense">
        <xsl:param name="description"/>
        <xsl:param name="ProfileData"/>
        <xsl:param name="IssueIndicator"/>
        <xsl:param name="notesIndicator"/>
        <xsl:param name="msgAction"/>
        <xsl:param name="msgType"/>
        <xsl:param name="authorElement">author</xsl:param>
        <xsl:param name="inferedRx">false</xsl:param>
        <xsl:param name="fillCode"/>

        <!-- addRequest|queryResponse -->

        <xsl:variable name="DispenseData" select="$BaseData/dispenses/dispense[@description=$description]"/>
        <xsl:variable name="DispenseProfileData" select="$ProfileData/items/dispense[@description=$description]"/>

        <xsl:choose>
            <xsl:when test="$msgAction='queryResponse'">
                <medicationDispense>
                    <!-- The Prescription Dispense Number is a globally unique number assigned to a dispense (single fill) by the EHR/DIS irrespective of the source of the dispense. 
                              It is created by the EHR/DIS once the dispense has passed all edits and validation 
            -->
                    <id>
                        <xsl:call-template name="ID_Element">
                            <xsl:with-param name="Record" select="$DispenseProfileData/record-id"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="Default_OID">DIS_DISPENSE_ID</xsl:with-param>
                        </xsl:call-template>
                    </id>

                    <!-- Indicates the status of the dispense record created on the EHR/DIS. If 'Active' it means that the dispense has been processed but not yet given to the patient.
                             If 'Complete', it indicates that the medication has been delivered to the patient -->
                    <statusCode code="active">
                        <xsl:if test="$DispenseProfileData/pickup">
                            <xsl:attribute name="code">completed</xsl:attribute>
                        </xsl:if>
                    </statusCode>


                    <!-- optionally the represented person - the supervisor pharmacist -->
                    <xsl:if test="$DispenseProfileData/supervisor">
                        <responsibleParty>
                            <xsl:call-template name="ProviderByDescription">
                                <xsl:with-param name="description" select="$DispenseProfileData/supervisor/@description"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                                <xsl:with-param name="format">CeRx</xsl:with-param>
                            </xsl:call-template>
                        </responsibleParty>
                    </xsl:if>

                    <!--  the pharmacist or pharm tech: person who dispensed -->
                    <xsl:if test="$DispenseProfileData/author">
                        <xsl:element name="{$authorElement}">
                            <!-- <xsl:attribute name="typeCode">AUT</xsl:attribute> -->
                            <!-- 
                            <time>
                                <xsl:call-template name="effectiveTime">
                                    <xsl:with-param name="effectiveTime" select="$DispenseProfileData/author"/>
                                </xsl:call-template>
                            </time>
                                 -->
                            <xsl:call-template name="ProviderByDescription">
                                <xsl:with-param name="description" select="$DispenseProfileData/author/@description"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                                <xsl:with-param name="format">CeRx</xsl:with-param>
                            </xsl:call-template>
                        </xsl:element>
                    </xsl:if>


                    <!-- Indicates the facility/location where the dispensing was performed. -->
                    <xsl:if test="$DispenseProfileData/location">
                        <location>
                            <xsl:call-template name="LocationByDescription">
                                <xsl:with-param name="description" select="$DispenseProfileData/location/@description"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                                <xsl:with-param name="format">CeRx</xsl:with-param>
                            </xsl:call-template>
                        </location>
                    </xsl:if>

                    <!-- required element with dispensing info -->
                    <component1>
                        <xsl:for-each select="$DispenseData/supplyEvent[1]">
                            <xsl:call-template name="supplyEvent">
                                <xsl:with-param name="msgType" select="$msgType"/>
                            </xsl:call-template>
                        </xsl:for-each>
                    </component1>

                    <!-- 1..10 elements for the dosage instructions (these are the admin instructions from old dispense message) -->
                    <xsl:for-each select="$DispenseData/dosageInstruction">
                        <component2>
                            <xsl:call-template name="dosageInstruction">
                                <xsl:with-param name="description" select="@description"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                            </xsl:call-template>
                        </component2>
                    </xsl:for-each>

                    <!-- optional element for substitution details -->
                    <xsl:if test="$DispenseProfileData/substitutionMade">
                        <component3>
                            <substitutionMade>
                                <!-- required : A code signifying whether a different drug was dispensed from what was prescribed : Indicates that substitution was done (or not).  ActSubstanceAdminSubstitutionCode vocab -->
                                <code code="N">
                                    <xsl:call-template name="codeSystem">
                                        <xsl:with-param name="codeElement" select="$DispenseProfileData/substitutionMade/code"/>
                                        <xsl:with-param name="msgType" select="$msgType"/>
                                    </xsl:call-template>
                                </code>
                                <!-- eg n - no sub was done -->
                                <!-- required : fixed value of completed -->
                                <statusCode code="completed"/>

                                <!--optional value to indicate the reason for the substitution of (or lack of substitution) from what was prescribed : SubstanceAdminSubstitutionReason -->
                                <xsl:if test="$DispenseProfileData/substitutionMade/reasonCode">
                                    <reasonCode code="OS">
                                        <xsl:call-template name="codeSystem">
                                            <xsl:with-param name="codeElement" select="$DispenseProfileData/substitutionMade/reasonCode"/>
                                            <xsl:with-param name="msgType" select="$msgType"/>
                                        </xsl:call-template>
                                    </reasonCode>
                                </xsl:if>
                                <!-- OS - indicates out of stock -->
                                <!-- optionally identifies who did the substitution -->
                                <xsl:if test="$DispenseProfileData/substitutionMade/author">
                                    <responsibleParty>
                                        <agent>
                                            <xsl:call-template name="ProviderIDByDescription">
                                                <xsl:with-param name="description" select="$DispenseProfileData/substitutionMade/author/@description"/>
                                                <xsl:with-param name="msgType" select="$msgType"/>
                                                <xsl:with-param name="format">CeRx</xsl:with-param>
                                            </xsl:call-template>
                                        </agent>
                                    </responsibleParty>
                                </xsl:if>
                            </substitutionMade>
                        </component3>
                    </xsl:if>
                    <!-- 0..20 elements to show how the status of the dispense has changed over time 
							  i.e. one element for every controlActEvent of every message that updated this entity
                -->
                    <xsl:for-each select="$DispenseProfileData/history/item">
                        <subjectOf1>
                            <xsl:call-template name="historyItems">
                                <xsl:with-param name="item" select="."/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                            </xsl:call-template>
                        </subjectOf1>
                    </xsl:for-each>

                    <!-- if the return notes flag was off on the query instead of returning the notes, we willl simply use the presence or absence of this
							 element to comunicate whether notes are attached or not -->
                    <xsl:if test="$notesIndicator and $notesIndicator = 'false' and $DispenseProfileData/note">
                        <subjectOf2>
                            <subsetCode code="SUM"/>
                            <annotationIndicator>
                                <statusCode code="completed"/>
                            </annotationIndicator>
                        </subjectOf2>
                    </xsl:if>

                    <!-- if the return issues flag was off on the query - we will use this element to communicate whether there are any issues
							   if present Indicates  there are issues 
						-->
                    <xsl:call-template name="IssueIndicatorElements">
                        <xsl:with-param name="ElementName">subjectOf3</xsl:with-param>
                        <xsl:with-param name="IssueIndicator" select="$IssueIndicator"/>
                        <xsl:with-param name="ItemProfileData" select="$DispenseProfileData"/>
                        <xsl:with-param name="ItemData" select="$DispenseData"/>
                    </xsl:call-template>

                    <!-- 0..99 optional element for a note attached to the dispense: notes now have language code, but have dropped code to indicate note type -->
                    <xsl:if test="$notesIndicator and $notesIndicator != 'false'">
                        <xsl:for-each select="$DispenseProfileData/note">
                            <subjectOf4>
                                <xsl:call-template name="annotation">
                                    <xsl:with-param name="msgType" select="$msgType"/>
                                    <xsl:with-param name="author-description" select="author/@description"/>
                                </xsl:call-template>
                            </subjectOf4>
                        </xsl:for-each>
                    </xsl:if>

                    <xsl:call-template name="IssueElements">
                        <xsl:with-param name="repeatingElementName">subjectOf1</xsl:with-param>
                        <xsl:with-param name="IssueIndicator" select="$IssueIndicator"/>
                        <xsl:with-param name="ItemProfileData" select="$DispenseProfileData"/>
                        <xsl:with-param name="ItemData" select="$DispenseData"/>
                        <xsl:with-param name="ProfileData" select="$ProfileData"/>
                        <xsl:with-param name="msgAction" select="$msgAction"/>
                    </xsl:call-template>


                </medicationDispense>
            </xsl:when>
            <xsl:when test="$msgAction='addRequest'">
                <medicationDispense>
                    <!-- this is the only case were the ID is the local id of the dispense. but we need this so that we can send in invoice msg's -->
                    <id>
                        <xsl:call-template name="ID_Element">
                            <xsl:with-param name="Record" select="$DispenseProfileData/local-id"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="Default_OID">PORTAL_DISPENSE_ID</xsl:with-param>
                        </xsl:call-template>
                    </id>

                    <!-- the patient -->

                    <subject>
                        <xsl:call-template name="PatientByDescription">
                            <xsl:with-param name="description" select="$ProfileData/patient/@description"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="format">patient1</xsl:with-param>
                            <xsl:with-param name="use_phn">true</xsl:with-param>
                            <xsl:with-param name="use_name">true</xsl:with-param>
                            <xsl:with-param name="use_gender">true</xsl:with-param>
                            <xsl:with-param name="use_dob">true</xsl:with-param>
                        </xsl:call-template>
                    </subject>


                    <!-- optionally Indicates the prescription that is being dispensed against -->
                    <xsl:if test="$DispenseProfileData/prescription">
                        <xsl:variable name="Rx-description" select="$DispenseProfileData/prescription/@description"/>
                        <xsl:variable name="PrescriptionData" select="$ProfileData/items/prescription[@description=$Rx-description]"/>
                        <xsl:if test="$PrescriptionData">
                            <inFulfillmentOf>
                                <!-- Information pertaining to the prescription for which a dispense is being created -->
                                <substanceAdministrationRequest>

                                    <!-- The identifier of the prescription for which a dispense is being created. The ID is only 'populated' because in some cases the prescription will not yet exist electronically  -->
                                    <!--  schema does give option to not have an id element so if we want to infer the rx we just nullflavor the id -->
                                    <id>
                                        <xsl:choose>
                                            <xsl:when test="$PrescriptionData/@infered = 'true' or $inferedRx = 'true'">
                                                <xsl:call-template name="nullFlavor"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:call-template name="ID_Element">
                                                    <xsl:with-param name="Record" select="$PrescriptionData/record-id"/>
                                                    <xsl:with-param name="msgType" select="$msgType"/>
                                                    <xsl:with-param name="Default_OID">DIS_PRESCRIPTION_ID</xsl:with-param>
                                                </xsl:call-template>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </id>
                                    <!--  schema does give option to not have an id element so if we want to infer the rx we just nullflavor the id
                                <xsl:if test="$PrescriptionData/@infered != 'true'">
                                    <id>
                                        <xsl:call-template name="ID_Element">
                                            <xsl:with-param name="Record" select="$PrescriptionData/record-id"/>
                                            <xsl:with-param name="msgType" select="$msgType"/>
                                            <xsl:with-param name="Default_OID">DIS_PRESCRIPTION_ID</xsl:with-param>
                                        </xsl:call-template>
                                    </id>
                                </xsl:if>
                                -->

                                    <!-- fixed value of drug -->
                                    <code code="DRUG"/>
                                    <xsl:if test="$PrescriptionData/@infered = 'true'  or $inferedRx = 'true'">
                                        <!-- optional identification of the supervising prescriber -->
                                        <xsl:if test="$PrescriptionData/supervisor">
                                            <responsibleParty>
                                                <xsl:call-template name="ProviderByDescription">
                                                    <xsl:with-param name="description" select="$PrescriptionData/supervisor/@description"/>
                                                    <xsl:with-param name="msgType" select="$msgType"/>
                                                    <xsl:with-param name="format">CeRx</xsl:with-param>
                                                </xsl:call-template>
                                            </responsibleParty>
                                        </xsl:if>
                                        <!-- optional identification of the prescriber -->
                                        <xsl:if test="$PrescriptionData/author">
                                            <author>
                                                <time>
                                                    <xsl:call-template name="effectiveTime">
                                                        <xsl:with-param name="effectiveTime" select="$PrescriptionData/author"/>
                                                    </xsl:call-template>
                                                </time>
                                                <xsl:call-template name="ProviderByDescription">
                                                    <xsl:with-param name="description" select="$PrescriptionData/author/@description"/>
                                                    <xsl:with-param name="msgType" select="$msgType"/>
                                                    <xsl:with-param name="format">CeRx</xsl:with-param>
                                                </xsl:call-template>
                                            </author>
                                        </xsl:if>
                                    </xsl:if>
                                </substanceAdministrationRequest>
                            </inFulfillmentOf>
                        </xsl:if>
                    </xsl:if>

                    <!-- optional element for substitution details -->
                    <xsl:if test="$DispenseProfileData/substitutionMade">
                        <component1>
                            <substitutionMade>
                                <!-- required : A code signifying whether a different drug was dispensed from what was prescribed : Indicates that substitution was done (or not).  ActSubstanceAdminSubstitutionCode vocab -->
                                <code code="N">
                                    <xsl:call-template name="codeSystem">
                                        <xsl:with-param name="codeElement" select="$DispenseProfileData/substitutionMade/code"/>
                                        <xsl:with-param name="msgType" select="$msgType"/>
                                    </xsl:call-template>
                                </code>
                                <!-- eg n - no sub was done -->
                                <!-- required : fixed value of completed -->
                                <statusCode code="completed"/>

                                <!--optional value to indicate the reason for the substitution of (or lack of substitution) from what was prescribed : SubstanceAdminSubstitutionReason -->
                                <xsl:if test="$DispenseProfileData/substitutionMade/reasonCode">
                                    <reasonCode code="OS">
                                        <xsl:call-template name="codeSystem">
                                            <xsl:with-param name="codeElement" select="$DispenseProfileData/substitutionMade/reasonCode"/>
                                            <xsl:with-param name="msgType" select="$msgType"/>
                                        </xsl:call-template>
                                    </reasonCode>
                                </xsl:if>
                                <!-- OS - indicates out of stock -->
                                <!-- optionally identifies who did the substitution -->
                                <xsl:if test="$DispenseProfileData/author">
                                    <responsibleParty>
                                        <agent>
                                            <xsl:call-template name="ProviderIDByDescription">
                                                <xsl:with-param name="description" select="$DispenseProfileData/author/@description"/>
                                                <xsl:with-param name="msgType" select="$msgType"/>
                                                <xsl:with-param name="format">CeRx</xsl:with-param>
                                            </xsl:call-template>
                                        </agent>
                                    </responsibleParty>
                                </xsl:if>
                            </substitutionMade>
                        </component1>
                    </xsl:if>

                    <!-- 1..10 elements for the dosage instructions (these are the admin instructions from old dispense message) -->
                    <xsl:for-each select="$DispenseData/dosageInstruction">
                        <component2>
                            <xsl:call-template name="dosageInstruction">
                                <xsl:with-param name="description" select="@description"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                            </xsl:call-template>
                        </component2>
                    </xsl:for-each>


                    <component3>
                        <xsl:for-each select="$DispenseData/supplyEvent[1]">
                            <xsl:call-template name="supplyEvent">
                                <xsl:with-param name="msgType" select="$msgType"/>
                                <xsl:with-param name="fillCode" select="$fillCode"/>
                            </xsl:call-template>
                        </xsl:for-each>
                    </component3>

                    <!-- optional element for a note attached to the dispense: notes now have language code, but have dropped code to indicate note type -->
                    <xsl:for-each select="$DispenseProfileData/note[1]">
                        <subjectOf>
                            <xsl:call-template name="annotation">
                                <xsl:with-param name="author-description" select="author/@description"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                            </xsl:call-template>
                        </subjectOf>
                    </xsl:for-each>

                </medicationDispense>
            </xsl:when>
            <xsl:when test="$msgAction='reversalRequest'">
                <actEvent>
                    <!-- identification of the dispense that is being reversed  -->
                    <id>
                        <xsl:call-template name="ID_Element">
                            <xsl:with-param name="Record" select="$DispenseProfileData/record-id"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="Default_OID">DIS_DISPENSE_ID</xsl:with-param>
                        </xsl:call-template>
                    </id>

                    <!-- patient for whom the dispense belongs -->
                    <recordTarget>
                        <xsl:call-template name="PatientByDescription">
                            <xsl:with-param name="description" select="$ProfileData/patient/@description"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="format">CeRx</xsl:with-param>
                            <xsl:with-param name="use_phn">true</xsl:with-param>
                            <xsl:with-param name="use_name">true</xsl:with-param>
                            <xsl:with-param name="use_gender">true</xsl:with-param>
                            <xsl:with-param name="use_dob">true</xsl:with-param>
                        </xsl:call-template>
                    </recordTarget>
                </actEvent>
            </xsl:when>
        </xsl:choose>

    </xsl:template>

    <xsl:template name="DispenseSummary">
        <xsl:param name="description"/>
        <xsl:param name="ProfileData"/>
        <xsl:param name="IssueIndicator"/>
        <xsl:param name="notesIndicator"/>
        <xsl:param name="msgAction"/>
        <xsl:param name="msgType"/>
        <xsl:param name="authorElement">performer</xsl:param>
        <xsl:param name="inferedRx">false</xsl:param>
        <xsl:param name="fillCode"/>

        <!-- addRequest|queryResponse -->

        <xsl:variable name="DispenseData" select="$BaseData/dispenses/dispense[@description=$description]"/>
        <xsl:variable name="DispenseProfileData" select="$ProfileData/items/dispense[@description=$description]"/>

                <medicationDispense>
                    <!-- The Prescription Dispense Number is a globally unique number assigned to a dispense (single fill) by the EHR/DIS irrespective of the source of the dispense. 
                              It is created by the EHR/DIS once the dispense has passed all edits and validation 
            -->
                    <id>
                        <xsl:call-template name="ID_Element">
                            <xsl:with-param name="Record" select="$DispenseProfileData/record-id"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="Default_OID">DIS_DISPENSE_ID</xsl:with-param>
                        </xsl:call-template>
                    </id>

                    <!-- Indicates the status of the dispense record created on the EHR/DIS. If 'Active' it means that the dispense has been processed but not yet given to the patient.
                             If 'Complete', it indicates that the medication has been delivered to the patient -->
                    <statusCode code="active">
                        <xsl:if test="$DispenseProfileData/pickup">
                            <xsl:attribute name="code">completed</xsl:attribute>
                        </xsl:if>
                    </statusCode>


                    <!-- optionally the represented person - the supervisor pharmacist -->
                    <xsl:if test="$DispenseProfileData/supervisor">
                        <responsibleParty>
                            <xsl:call-template name="ProviderByDescription">
                                <xsl:with-param name="description" select="$DispenseProfileData/supervisor/@description"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                                <xsl:with-param name="format">CeRx</xsl:with-param>
                            </xsl:call-template>
                        </responsibleParty>
                    </xsl:if>

                    <!--  the pharmacist or pharm tech: person who dispensed -->
                    <xsl:if test="$DispenseProfileData/author">
                        <xsl:element name="{$authorElement}">
                            <!-- <xsl:attribute name="typeCode">AUT</xsl:attribute> -->
                            <!-- 
                            <time>
                                <xsl:call-template name="effectiveTime">
                                    <xsl:with-param name="effectiveTime" select="$DispenseProfileData/author"/>
                                </xsl:call-template>
                            </time>
                                 -->
                            <xsl:call-template name="ProviderByDescription">
                                <xsl:with-param name="description" select="$DispenseProfileData/author/@description"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                                <xsl:with-param name="format">CeRx</xsl:with-param>
                            </xsl:call-template>
                        </xsl:element>
                    </xsl:if>


                    <!-- Indicates the facility/location where the dispensing was performed. -->
                    <xsl:if test="$DispenseProfileData/location">
                        <location>
                            <xsl:call-template name="LocationByDescription">
                                <xsl:with-param name="description" select="$DispenseProfileData/location/@description"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                                <xsl:with-param name="format">CeRx</xsl:with-param>
                            </xsl:call-template>
                        </location>
                    </xsl:if>

                    <!-- required element with dispensing info -->
                    <component1>
                        <xsl:for-each select="$DispenseData/supplyEvent[1]">
                            <xsl:call-template name="supplyEvent">
                                <xsl:with-param name="msgType" select="$msgType"/>
                                <xsl:with-param name="includeCode">false</xsl:with-param>
                            </xsl:call-template>
                        </xsl:for-each>
                    </component1>

                    <component2>
                        <xsl:for-each select="$DispenseData/dosageInstruction[1]">
                            <administrationInstructions>
                            <code>
                                <xsl:attribute name="code"><xsl:value-of select="code/@code"/></xsl:attribute>
                            </code>
                            <text><xsl:value-of select="text"/></text>
                                </administrationInstructions>
                        </xsl:for-each>
                    </component2>
                    <!-- if the return issues flag was off on the query - we will use this element to communicate whether there are any issues
							   if present Indicates  there are issues 
						-->
                    <xsl:call-template name="IssueIndicatorElements">
                        <xsl:with-param name="ElementName">subjectOf1</xsl:with-param>
                        <xsl:with-param name="IssueIndicator">true</xsl:with-param>
                        <xsl:with-param name="ItemProfileData" select="$DispenseProfileData"/>
                        <xsl:with-param name="ItemData" select="$DispenseData"/>
                    </xsl:call-template>

                    <!-- if the return notes flag was off on the query instead of returning the notes, we willl simply use the presence or absence of this
							 element to comunicate whether notes are attached or not -->
                    <xsl:if test="$DispenseProfileData/note">
                        <subjectOf2>
                            <subsetCode code="SUM"/>
                            <annotationIndicator>
                                <statusCode code="completed"/>
                            </annotationIndicator>
                        </subjectOf2>
                    </xsl:if>


                </medicationDispense>
    </xsl:template>
    
    <xsl:template name="DispensePickup">
        <xsl:param name="dispense-description"/>
        <xsl:param name="ProfileData"/>
        <xsl:param name="msgAction"/>
        <xsl:param name="msgType"/>

        <!-- addRequest|queryResponse -->

        <xsl:variable name="DispenseProfileData" select="$ProfileData/items/dispense[@description=$dispense-description]"/>

        <xsl:choose>
            <xsl:when test="$msgAction='addRequest'">
                <supplyEvent>
                    <!-- identification of the dispense that is being picked up -->
                    <id>
                        <xsl:call-template name="ID_Element">
                            <xsl:with-param name="Record" select="$DispenseProfileData/record-id"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="Default_OID">DIS_DISPENSE_ID</xsl:with-param>
                        </xsl:call-template>
                    </id>
                    <!-- the patient -->

                    <subject>
                        <xsl:call-template name="PatientByDescription">
                            <xsl:with-param name="description" select="$ProfileData/patient/@description"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="format">CeRx</xsl:with-param>
                            <xsl:with-param name="use_phn">true</xsl:with-param>
                            <xsl:with-param name="use_name">true</xsl:with-param>
                            <xsl:with-param name="use_gender">true</xsl:with-param>
                            <xsl:with-param name="use_dob">true</xsl:with-param>
                        </xsl:call-template>
                    </subject>

                    <!-- optional receiver to indicate someone other than the patient who has received the drug -->
                    <xsl:for-each select="$DispenseProfileData/pickup/receiver[1]">
                        <xsl:call-template name="responsibleParty">
                            <xsl:with-param name="msgType" select="$msgType"/>
                        </xsl:call-template>
                    </xsl:for-each>
                </supplyEvent>
            </xsl:when>
        </xsl:choose>

    </xsl:template>

    <xsl:template name="otherMedication">
        <xsl:param name="description"/>
        <xsl:param name="ProfileData"/>
        <xsl:param name="IssueIndicator"/>
        <xsl:param name="notesIndicator"/>
        <xsl:param name="msgAction"/>
        <xsl:param name="msgType"/>

        <!-- addRequest|updateRequest|queryResponse -->

        <xsl:variable name="otherMedicationData" select="$BaseData/otherMedications/otherMedication[@description=$description]"/>
        <xsl:variable name="otherMedicationProfileData" select="$ProfileData/items/otherMedication[@description=$description]"/>

        <otherMedication>
            <!-- This is an identifier assigned to a unique instance of an other medication record -->
            <xsl:if test="$msgAction='updateRequest' or $msgAction='queryResponse' ">
                <id>
                    <xsl:call-template name="ID_Element">
                        <xsl:with-param name="Record" select="$otherMedicationProfileData/record-id"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                        <xsl:with-param name="Default_OID">DIS_OTHER_ACTIVE_MED_ID</xsl:with-param>
                    </xsl:call-template>
                </id>
            </xsl:if>

            <code code="DRUG"/>
            <!-- fixed value -->
            <!-- Indicates the status of the other  medication record created on the EHR/DIS. Valid statuses for other medication records are: ACTIVE, COMPLETE. -->
            <statusCode code="active">
                <xsl:if test="$otherMedicationProfileData/statusCode">
                    <xsl:call-template name="codeSystem">
                        <xsl:with-param name="codeElement" select="$otherMedicationProfileData/statusCode"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </xsl:if>
            </statusCode>
            <!-- Indicates the time-period in which the patient has been taking or is expected to be taking the other medication. -->
            <effectiveTime>
                <xsl:call-template name="effectiveTime">
                    <xsl:with-param name="effectiveTime" select="$otherMedicationProfileData/effectiveTime"/>
                </xsl:call-template>
            </effectiveTime>
            <!-- optionally indicates the means by which the patient is taking the medication : RouteOfAdministration vocab -->
            <xsl:if test="$otherMedicationData/routeCode">
                <routeCode code="">
                    <xsl:call-template name="codeSystem">
                        <xsl:with-param name="codeElement" select="$otherMedicationData/routeCode"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </routeCode>
            </xsl:if>

            <!-- required element to identify patinet -->
            <subject>
                <xsl:call-template name="PatientByDescription">
                    <xsl:with-param name="description" select="$ProfileData/patient/@description"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="format">CeRx</xsl:with-param>
                    <xsl:with-param name="use_phn">true</xsl:with-param>
                    <xsl:with-param name="use_name">true</xsl:with-param>
                    <xsl:with-param name="use_gender">true</xsl:with-param>
                    <xsl:with-param name="use_dob">true</xsl:with-param>
                </xsl:call-template>
            </subject>

            <xsl:if test="not($msgAction='updateRequest' )">
                <!-- identification of the drug -->
                <consumable>
                    <medication>
                        <xsl:call-template name="Drug">
                            <xsl:with-param name="description" select="$otherMedicationData/drug/@description"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                        </xsl:call-template>
                    </medication>
                </consumable>
            </xsl:if>

            <!-- optionally the represented person - the supervisor -->
            <xsl:if test="$msgAction='queryResponse' and $otherMedicationProfileData/supervisor">
                <responsibleParty>
                    <xsl:call-template name="ProviderByDescription">
                        <xsl:with-param name="description" select="$otherMedicationProfileData/supervisor/@description"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                        <xsl:with-param name="format">CeRx</xsl:with-param>
                    </xsl:call-template>
                </responsibleParty>
            </xsl:if>

            <!-- person responsible for the event that caused this message - the pharmacist, doctor, or most likely a public health nurse -->
            <xsl:if test="$msgAction='queryResponse' and $otherMedicationProfileData/author">
                <author typeCode="AUT">
                    <xsl:call-template name="ProviderByDescription">
                        <xsl:with-param name="description" select="$otherMedicationProfileData/author/@description"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                        <xsl:with-param name="format">CeRx</xsl:with-param>
                    </xsl:call-template>
                </author>
            </xsl:if>

            <!-- An identification of a service location (or facility) where health service has been or can be delivered.  E.g. Pharmacy -->
            <xsl:if test="$msgAction='queryResponse' and $otherMedicationProfileData/location">
                <location>
                    <xsl:call-template name="LocationByDescription">
                        <xsl:with-param name="description" select="$otherMedicationProfileData/location/@description"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                        <xsl:with-param name="format">CeRx</xsl:with-param>
                    </xsl:call-template>
                </location>
            </xsl:if>

            <!-- 1..10 elements for the dosage instructions (these are the admin instructions from old dispense message) -->
            <xsl:if test="$msgAction='addRequest' or $msgAction='queryResponse'">
                <xsl:for-each select="$otherMedicationData/dosageInstruction">
                    <component>
                        <xsl:call-template name="dosageInstruction">
                            <xsl:with-param name="description" select="@description"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                        </xsl:call-template>
                    </component>
                </xsl:for-each>
            </xsl:if>

            <!-- 0..20 elements to show how the status of the other med has changed over time 
                      i.e. one element for every controlActEvent of every message that updated this entity
            -->
            <xsl:if test="$msgAction='queryResponse'">
                <xsl:for-each select="$otherMedicationProfileData/history/item">
                    <subjectOf1>
                        <xsl:call-template name="historyItems">
                            <xsl:with-param name="item" select="."/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                        </xsl:call-template>
                    </subjectOf1>
                </xsl:for-each>
            </xsl:if>

            <xsl:choose>
                <xsl:when test="$msgAction='addRequest'">
                    <xsl:if test="$notesIndicator and $notesIndicator != 'false'">
                        <xsl:for-each select="$otherMedicationProfileData/note[1]">
                            <subjectOf>
                                <xsl:call-template name="annotation">
                                    <xsl:with-param name="msgType" select="$msgType"/>
                                    <xsl:with-param name="author-description" select="author/@description"/>
                                </xsl:call-template>
                            </subjectOf>
                        </xsl:for-each>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="$msgAction='queryResponse'">


                    <!-- if the return issues flag was off on the query - we will use this element to communicate whether there are any issues
                       if present Indicates  there are issues 
            -->
                    <xsl:if test="$notesIndicator and $notesIndicator = 'false' and $otherMedicationProfileData/note">
                        <subjectOf2>
                            <subsetCode code="SUM"/>
                            <detectedIssueIndicator>
                                <statusCode code="completed"/>
                            </detectedIssueIndicator>
                        </subjectOf2>
                    </xsl:if>


                    <!-- 0..99 optional element for a note attached to the other med: notes now have language code, but have dropped code to indicate note type -->
                    <xsl:if test="$notesIndicator and $notesIndicator != 'false'">
                        <xsl:for-each select="$otherMedicationProfileData/note">
                            <subjectOf3>
                                <xsl:call-template name="annotation">
                                    <xsl:with-param name="msgType" select="$msgType"/>
                                    <xsl:with-param name="author-description" select="author/@description"/>
                                </xsl:call-template>
                            </subjectOf3>
                        </xsl:for-each>
                    </xsl:if>

                    <xsl:call-template name="IssueIndicatorElements">
                        <xsl:with-param name="ElementName">subjectOf4</xsl:with-param>
                        <xsl:with-param name="IssueIndicator" select="$IssueIndicator"/>
                        <xsl:with-param name="ItemProfileData" select="$otherMedicationProfileData"/>
                        <xsl:with-param name="ItemData" select="$otherMedicationData"/>
                    </xsl:call-template>

                    <xsl:call-template name="IssueElements">
                        <xsl:with-param name="repeatingElementName">subjectOf5</xsl:with-param>
                        <xsl:with-param name="IssueIndicator" select="$IssueIndicator"/>
                        <xsl:with-param name="ItemProfileData" select="$otherMedicationProfileData"/>
                        <xsl:with-param name="ItemData" select="$otherMedicationData"/>
                        <xsl:with-param name="ProfileData" select="$ProfileData"/>
                        <xsl:with-param name="msgAction" select="$msgAction"/>
                    </xsl:call-template>

                </xsl:when>
            </xsl:choose>
        </otherMedication>

    </xsl:template>

    <xsl:template name="Prescription">
        <xsl:param name="description"/>
        <xsl:param name="ProfileData"/>
        <xsl:param name="IssueIndicator"/>
        <xsl:param name="notesIndicator"/>
        <xsl:param name="msgAction"/>
        <xsl:param name="msgType"/>
        <xsl:param name="minFills"/>

        <!-- preDeterminRequest|addRequest|queryResponse|transferResponse -->

        <xsl:variable name="prescriptionData" select="$BaseData/prescriptions/prescription[@description=$description]"/>
        <xsl:variable name="prescriptionProfileData" select="$ProfileData/items/prescription[@description=$description]"/>
        <xsl:variable name="dispenseProfileData" select="$ProfileData/items/dispense[prescription[@description=$description]]"/>

        <combinedMedicationRequest>
            <xsl:if test="$msgAction='queryResponse' or $msgAction='transferResponse'  or $msgAction='preDeterminResponse'">
                <id>
                    <xsl:call-template name="ID_Element">
                        <xsl:with-param name="Record" select="$prescriptionProfileData/record-id"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                        <xsl:with-param name="Default_OID">DIS_PRESCRIPTION_ID</xsl:with-param>
                    </xsl:call-template>
                </id>
            </xsl:if>

            <code code="DRUG"/>

            <statusCode>
                <xsl:attribute name="code">
                    <xsl:choose>
                        <xsl:when test="$msgAction='addRequest'">active</xsl:when>
                        <xsl:when test="$msgAction='preDeterminRequest'">new</xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$prescriptionData/statusCode/@code"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
            </statusCode>

            <xsl:call-template name="confidentialityCode">
                <xsl:with-param name="codeElement" select="$prescriptionData/confidentialityCode"/>
            </xsl:call-template>

            <directTarget>
                <medication>
                    <xsl:call-template name="Drug">
                        <xsl:with-param name="description" select="$prescriptionData/drug/@description"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </medication>
            </directTarget>

            <subject>
                <xsl:call-template name="PatientByDescription">
                    <xsl:with-param name="description" select="$ProfileData/patient/@description"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="format">CeRx</xsl:with-param>
                    <xsl:with-param name="use_phn">true</xsl:with-param>
                    <xsl:with-param name="use_name">true</xsl:with-param>
                    <xsl:with-param name="use_gender">true</xsl:with-param>
                    <xsl:with-param name="use_dob">true</xsl:with-param>
                </xsl:call-template>
            </subject>

            <xsl:if test="$msgAction='queryResponse' or $msgAction='transferResponse'  or $msgAction='preDeterminResponse' ">
                <!-- optionally the represented person - the supervisor pharmacist -->
                <xsl:if test="$prescriptionProfileData/supervisor">
                    <responsibleParty>
                        <xsl:call-template name="ProviderByDescription">
                            <xsl:with-param name="description" select="$prescriptionProfileData/supervisor/@description"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="format">CeRx</xsl:with-param>
                        </xsl:call-template>
                    </responsibleParty>
                </xsl:if>

                <!--  the pharmacist or pharm tech: person who dispensed -->
                <xsl:if test="$prescriptionProfileData/author">
                    <author typeCode="AUT">
                        <time>
                            <xsl:call-template name="effectiveTime">
                                <xsl:with-param name="effectiveTime" select="$prescriptionProfileData/author"/>
                            </xsl:call-template>
                        </time>
                        <xsl:call-template name="ProviderByDescription">
                            <xsl:with-param name="description" select="$prescriptionProfileData/author/@description"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="format">CeRx</xsl:with-param>
                        </xsl:call-template>
                    </author>
                </xsl:if>

                <!-- Indicates the facility/location where the dispensing was performed. -->
                <xsl:if test="$prescriptionProfileData/location">
                    <location>
                        <xsl:call-template name="LocationByDescription">
                            <xsl:with-param name="description" select="$prescriptionProfileData/location/@description"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="format">CeRx</xsl:with-param>
                        </xsl:call-template>
                    </location>
                </xsl:if>
            </xsl:if>

            <xsl:for-each select="$prescriptionData/substanceAdministrationDefinition">
                <definition>
                    <substanceAdministrationDefinition classCode="SBADM" moodCode="DEF">
                        <id>
                            <xsl:call-template name="ID_Element">
                                <xsl:with-param name="Record" select="record-id"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                            </xsl:call-template>
                        </id>
                        <code code="DRUG"/>
                    </substanceAdministrationDefinition>
                </definition>
            </xsl:for-each>

            <xsl:if test="$prescriptionProfileData/priorPrescription">
                <predecessor>
                    <priorCombinedMedicationRequest>
                        <id>
                            <xsl:variable name="Rx-description" select="$prescriptionProfileData/priorPrescription/@description"/>
                            <xsl:call-template name="ID_Element">
                                <xsl:with-param name="Record" select="$ProfileData/items/prescription[@description=$Rx-description]/record-id"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                                <xsl:with-param name="Default_OID">DIS_PRESCRIPTION_ID</xsl:with-param>
                            </xsl:call-template>
                        </id>
                        <code code="DRUG"/>
                    </priorCombinedMedicationRequest>
                </predecessor>
            </xsl:if>

            <xsl:for-each select="$prescriptionData/reason">
                <!-- 1..5 nillable PORX_MT010120CA.Reason2 -->
                <reason>
                    <xsl:if test="priorityNumber">
                        <priorityNumber value="">
                            <xsl:attribute name="value">
                                <xsl:value-of select="priorityNumber/@value"/>
                            </xsl:attribute>
                        </priorityNumber>
                    </xsl:if>
                    <xsl:choose>
                        <xsl:when test="@type='observationDiagnosis'">
                            <observationDiagnosis classCode="OBS">
                                <code code="DX"/>
                                <xsl:if test="text">
                                    <text>
                                        <xsl:value-of select="text"/>
                                    </text>
                                </xsl:if>
                                <statusCode>
                                    <xsl:choose>
                                        <xsl:when test="statusCode">
                                            <xsl:call-template name="codeSystem">
                                                <xsl:with-param name="codeElement" select="statusCode"/>
                                                <xsl:with-param name="msgType" select="$msgType"/>
                                            </xsl:call-template>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="code">active</xsl:attribute>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </statusCode>
                                <xsl:if test="value">
                                    <value>
                                        <xsl:call-template name="codeSystem">
                                            <xsl:with-param name="codeElement" select="value"/>
                                            <xsl:with-param name="msgType" select="$msgType"/>
                                        </xsl:call-template>
                                    </value>
                                </xsl:if>
                            </observationDiagnosis>
                        </xsl:when>
                        <xsl:when test="@type='observationSymptom'">
                            <observationSymptom classCode="OBS">
                                <code code="SYMPT"/>
                                <xsl:if test="text">
                                    <text>
                                        <xsl:value-of select="text"/>
                                    </text>
                                </xsl:if>
                                <statusCode code="">
                                    <xsl:call-template name="codeSystem">
                                        <xsl:with-param name="codeElement" select="statusCode"/>
                                        <xsl:with-param name="msgType" select="$msgType"/>
                                    </xsl:call-template>
                                </statusCode>
                                <xsl:if test="value">
                                    <value>
                                        <xsl:call-template name="codeSystem">
                                            <xsl:with-param name="codeElement" select="value"/>
                                            <xsl:with-param name="msgType" select="$msgType"/>
                                        </xsl:call-template>
                                    </value>
                                </xsl:if>
                            </observationSymptom>
                        </xsl:when>
                        <xsl:when test="@type='otherIndication'">
                            <otherIndication classCode="ACT">
                                <xsl:if test="value">
                                    <code>
                                        <xsl:call-template name="codeSystem">
                                            <xsl:with-param name="codeElement" select="value"/>
                                            <xsl:with-param name="msgType" select="$msgType"/>
                                        </xsl:call-template>
                                    </code>
                                </xsl:if>
                                <xsl:if test="text">
                                    <text>
                                        <xsl:value-of select="text"/>
                                    </text>
                                </xsl:if>
                                <statusCode>
                                    <xsl:choose>
                                        <xsl:when test="statusCode">
                                            <xsl:call-template name="codeSystem">
                                                <xsl:with-param name="codeElement" select="statusCode"/>
                                                <xsl:with-param name="msgType" select="$msgType"/>
                                            </xsl:call-template>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="code">completed</xsl:attribute>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </statusCode>
                            </otherIndication>
                        </xsl:when>
                    </xsl:choose>
                </reason>
            </xsl:for-each>
            <xsl:if test="not($prescriptionData/reason)">
                <reason>
                    <otherIndication classCode="ACT">
                        <xsl:call-template name="nullFlavor"/>
                        <statusCode code="completed"/>
                    </otherIndication>
                </reason>
            </xsl:if>

            <xsl:if test="$prescriptionData/non-authoritative">
                <precondition>
                    <verificationEventCriterion>
                        <code>
                            <xsl:call-template name="codeSystem">
                                <xsl:with-param name="codeElement" select="$prescriptionData/non-authoritative"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                            </xsl:call-template>
                        </code>
                    </verificationEventCriterion>
                </precondition>
            </xsl:if>

            <xsl:for-each select="$prescriptionData/observation">
                <pertinentInformation>
                    <xsl:choose>
                        <xsl:when test="code">
                            <quantityObservationEvent>
                                <!-- Identification of the type of observation that was made about the patient. The only two allowable types are height and weight. x_ActObservationHeightOrWeight vocab -->
                                <code>
                                    <xsl:call-template name="codeSystem">
                                        <xsl:with-param name="codeElement" select="code"/>
                                    </xsl:call-template>
                                </code>
                                <statusCode code="completed"/>
                                <!-- The date on which the measurement was made -->
                                <effectiveTime value="20050101">
                                    <xsl:call-template name="effectiveTime">
                                        <xsl:with-param name="effectiveTime" select="effectiveTime"/>
                                    </xsl:call-template>
                                </effectiveTime>
                                <!-- The amount (quantity and unit) that has been recorded for the patient's height and/or weight. E.g. height in meters, weight in kilograms, etc -->
                                <value>
                                    <xsl:call-template name="valueAndUnit">
                                        <xsl:with-param name="valueElement" select="value"/>
                                        <xsl:with-param name="msgType" select="$msgType"/>
                                    </xsl:call-template>
                                </value>
                            </quantityObservationEvent>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="quantityObservationEvent">
                                <xsl:with-param name="description" select="$prescriptionData/observation/@description"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </pertinentInformation>
            </xsl:for-each>

            <xsl:if test="not($msgAction='addRequest') ">
                <xsl:if test="$prescriptionProfileData/@infered = 'true' or $prescriptionProfileData/@infered = 'TRUE' ">
                    <derivedFrom>
                        <sourceDispense>
                            <!--<statusCode code="completed"/>-->
                        </sourceDispense>
                    </derivedFrom>
                </xsl:if>
            </xsl:if>

            <xsl:for-each select="$prescriptionProfileData/coverage">
                <coverage>
                    <xsl:call-template name="coverage">
                        <xsl:with-param name="description" select="$prescriptionProfileData/coverage/@description"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </coverage>
            </xsl:for-each>

            <!-- 1..10 PORX_MT010120CA.Component1 -->
            <xsl:for-each select="$prescriptionData/dosageInstruction">
                <component1>
                    <xsl:call-template name="dosageInstruction">
                        <xsl:with-param name="description" select="@description"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </component1>
            </xsl:for-each>
            <xsl:for-each select="$prescriptionProfileData/dosageInstruction">
                <component1>
                    <xsl:call-template name="dosageInstruction">
                        <xsl:with-param name="description" select="@description"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </component1>
            </xsl:for-each>


            <component2 negationInd="false">
                <xsl:if test="$prescriptionData/trialSupplycode">
                    <xsl:attribute name="negationInd">true</xsl:attribute>
                </xsl:if>
                <trialSupplyPermission>
                    <code code="TF"/>
                </trialSupplyPermission>
            </component2>

            <component3>
                <!-- 1..1 nillable  PORX_MT010120CA.SupplyRequest -->
                <supplyRequest>

                    <xsl:if test="not($msgAction='addRequest')">
                        <statusCode>
                            <xsl:attribute name="code">
                                <xsl:choose>
                                    <xsl:when test="$msgAction='addRequest'">active</xsl:when>
                                    <xsl:when test="$msgAction='preDeterminRequest'">new</xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$prescriptionData/statusCode/@code"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                        </statusCode>
                    </xsl:if>
                    <!-- 0..1 IVL_TS -->
                    <xsl:choose>
                        <xsl:when test="$prescriptionProfileData/effectiveTime">
                            <effectiveTime>
                                <xsl:call-template name="effectiveTime">
                                    <xsl:with-param name="effectiveTime" select="$prescriptionProfileData/effectiveTime"/>
                                </xsl:call-template>
                            </effectiveTime>
                        </xsl:when>
                        <xsl:when test="$prescriptionData/effectiveTime">
                            <effectiveTime>
                                <xsl:call-template name="effectiveTime">
                                    <xsl:with-param name="effectiveTime" select="$prescriptionData/effectiveTime"/>
                                </xsl:call-template>
                            </effectiveTime>
                        </xsl:when>
                    </xsl:choose>

                    <xsl:for-each select="$prescriptionProfileData/responsibleParty">
                        <receiver>
                            <xsl:call-template name="responsibleParty">
                                <xsl:with-param name="msgType" select="$msgType"/>
                            </xsl:call-template>
                        </receiver>
                    </xsl:for-each>

                    <location>
                        <time>
                            <xsl:call-template name="effectiveTime">
                                <xsl:with-param name="effectiveTime" select="$prescriptionProfileData/pharmacylocation"/>
                            </xsl:call-template>
                        </time>
                        <xsl:if test="$prescriptionProfileData/pharmacylocation/@code">
                            <substitutionConditionCode>
                                <xsl:call-template name="codeSystem">
                                    <xsl:with-param name="codeElement" select="$prescriptionProfileData/pharmacylocation"/>
                                    <xsl:with-param name="msgType" select="$msgType"/>
                                </xsl:call-template>
                            </substitutionConditionCode>
                        </xsl:if>

                        <xsl:call-template name="LocationByDescription">
                            <xsl:with-param name="description" select="$prescriptionProfileData/pharmacylocation/@description"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="format">CeRx</xsl:with-param>
                        </xsl:call-template>
                    </location>

                    <!-- 1..5  PORX_MT010120CA.Component -->
                    <xsl:for-each select="$prescriptionData/supplyRequestItem">
                        <component>
                            <supplyRequestItem>
                                <xsl:if test="quantity">
                                    <quantity>
                                        <!-- First fill + Refills -->
                                        <xsl:choose>
                                            <xsl:when test="$minFills and $minFills > quantity/@value">
                                                <xsl:attribute name="value"><xsl:value-of select="$minFills"/></xsl:attribute>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:call-template name="valueAndUnit">
                                                    <xsl:with-param name="valueElement" select="quantity"/>
                                                    <xsl:with-param name="msgType" select="$msgType"/>
                                                </xsl:call-template>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </quantity>
                                </xsl:if>
                                <expectedUseTime>
                                    <xsl:call-template name="effectiveTime">
                                        <xsl:with-param name="effectiveTime" select="expectedUseTime"/>
                                    </xsl:call-template>
                                </expectedUseTime>
                                <!-- 0..1 PORX_MT010120CA.Product1 -->
                                <!-- Identifies the drug to be dispensed. -->
                                <!-- Allows for multiple drugs of the same generic with different strengths to be dispensed to form a single therapy.
                                    For example, “Dispense 100 x Drug A (5mg) and 200 x Drug B (10mg)”. -->
                                <xsl:if test="drug">
                                    <product>
                                        <medication>
                                            <xsl:call-template name="Drug">
                                                <xsl:with-param name="description" select="drug/@description"/>
                                                <xsl:with-param name="msgType" select="$msgType"/>
                                            </xsl:call-template>
                                        </medication>
                                    </product>
                                </xsl:if>

                                <xsl:choose>
                                    <xsl:when test="$msgAction='queryResponse'">
                                        <component1>
                                            <sequenceNumber value="1"/>
                                            <initialSupplyRequest>
                                                <xsl:if test="initialSupplyRequest/effectiveTime">
                                                    <effectiveTime>
                                                        <xsl:call-template name="effectiveTime">
                                                            <xsl:with-param name="effectiveTime" select="initialSupplyRequest/effectiveTime"/>
                                                        </xsl:call-template>
                                                    </effectiveTime>
                                                </xsl:if>

                                                <!--
                                                <xsl:if test="initialSupplyRequest/repeatNumber">
                                                    <repeatNumber value="1">
                                                        <xsl:call-template name="valueAndUnit">
                                                            <xsl:with-param name="valueElement" select="initialSupplyRequest/repeatNumber"/>
                                                            <xsl:with-param name="msgType" select="$msgType"/>
                                                        </xsl:call-template>
                                                    </repeatNumber>
                                                </xsl:if>
                                                -->

                                                <xsl:if test="initialSupplyRequest/quantity">
                                                    <quantity value="">
                                                        <xsl:call-template name="valueAndUnit">
                                                            <xsl:with-param name="valueElement" select="initialSupplyRequest/quantity"/>
                                                            <xsl:with-param name="msgType" select="$msgType"/>
                                                        </xsl:call-template>
                                                    </quantity>
                                                </xsl:if>

                                                <xsl:if test="initialSupplyRequest/expectedUseTime">
                                                    <expectedUseTime>
                                                        <xsl:call-template name="effectiveTime">
                                                            <xsl:with-param name="effectiveTime" select="initialSupplyRequest/expectedUseTime"/>
                                                        </xsl:call-template>
                                                    </expectedUseTime>
                                                </xsl:if>
                                            </initialSupplyRequest>
                                        </component1>
                                        <!--                                        <xsl:if test="subsequentSupplyRequest">-->
                                        <component2>
                                            <sequenceNumber value="2"/>
                                            <subsequentSupplyRequest>

                                                <xsl:if test="subsequentSupplyRequest/effectiveTime">
                                                    <effectiveTime>
                                                        <xsl:call-template name="effectiveTime">
                                                            <xsl:with-param name="effectiveTime" select="subsequentSupplyRequest/effectiveTime"/>
                                                        </xsl:call-template>
                                                    </effectiveTime>
                                                </xsl:if>

                                                <repeatNumber value="1">
                                                    <xsl:if test="subsequentSupplyRequest/repeatNumber">
                                                        <xsl:call-template name="valueAndUnit">
                                                            <xsl:with-param name="valueElement" select="subsequentSupplyRequest/repeatNumber"/>
                                                            <xsl:with-param name="msgType" select="$msgType"/>
                                                        </xsl:call-template>
                                                    </xsl:if>
                                                </repeatNumber>

                                                <xsl:if test="subsequentSupplyRequest/quantity">
                                                    <quantity value="">
                                                        <xsl:call-template name="valueAndUnit">
                                                            <xsl:with-param name="valueElement" select="subsequentSupplyRequest/quantity"/>
                                                            <xsl:with-param name="msgType" select="$msgType"/>
                                                        </xsl:call-template>
                                                    </quantity>
                                                </xsl:if>

                                                <xsl:if test="subsequentSupplyRequest/expectedUseTime">
                                                    <expectedUseTime>
                                                        <xsl:call-template name="effectiveTime">
                                                            <xsl:with-param name="effectiveTime" select="subsequentSupplyRequest/expectedUseTime"/>
                                                        </xsl:call-template>
                                                    </expectedUseTime>
                                                </xsl:if>
                                            </subsequentSupplyRequest>
                                        </component2>
                                        <!--                                        </xsl:if>-->
                                        <!-- optional element that provides summary information about what dispenses remain to be performed against the prescription -->
                                        <xsl:if test="supplyEventFutureSummary">
                                            <fulfillment1>
                                                <subsetCode code="FUTSUM"/>
                                                <supplyEventFutureSummary>
                                                    <repeatNumber value="5">
                                                        <xsl:call-template name="valueAndUnit">
                                                            <xsl:with-param name="valueElement" select="supplyEventFutureSummary/repeatNumber"/>
                                                            <xsl:with-param name="msgType" select="$msgType"/>
                                                        </xsl:call-template>
                                                    </repeatNumber>
                                                    <!-- optional element that indicates the total remaining undispensed quantity authorized against the prescription -->
                                                    <xsl:if test="supplyEventFutureSummary/quantity">
                                                        <quantity>
                                                            <xsl:call-template name="valueAndUnit">
                                                                <xsl:with-param name="valueElement" select="supplyEventFutureSummary/quantity"/>
                                                                <xsl:with-param name="msgType" select="$msgType"/>
                                                            </xsl:call-template>
                                                        </quantity>
                                                    </xsl:if>
                                                </supplyEventFutureSummary>
                                            </fulfillment1>
                                        </xsl:if>

                                        <!-- optional element to provide summary information about the first dispense made on the prescription -->
                                        <xsl:if test="supplyEventFirstSummary">
                                            <fulfillment2>
                                                <subsetCode code="FIRST"/>
                                                <supplyEventFirstSummary>
                                                    <xsl:if test="supplyEventFirstSummary/effectiveTime">
                                                        <effectiveTime>
                                                            <xsl:call-template name="effectiveTime">
                                                                <xsl:with-param name="effectiveTime" select="supplyEventFirstSummary/effectiveTime"/>
                                                            </xsl:call-template>
                                                            <high value="20060101"/>
                                                        </effectiveTime>
                                                    </xsl:if>
                                                    <quantity>
                                                        <xsl:call-template name="valueAndUnit">
                                                            <xsl:with-param name="valueElement" select="supplyEventFirstSummary/quantity"/>
                                                            <xsl:with-param name="msgType" select="$msgType"/>
                                                        </xsl:call-template>
                                                    </quantity>
                                                </supplyEventFirstSummary>
                                            </fulfillment2>
                                        </xsl:if>


                                        <!-- optional element to provide summary information about the most recent dispense on the prescription -->
                                        <xsl:if test="supplyEventLastSummary">
                                            <fulfillment3>
                                                <subsetCode code="FIRST"/>
                                                <supplyEventLastSummary>
                                                    <effectiveTime>
                                                        <xsl:call-template name="effectiveTime">
                                                            <xsl:with-param name="effectiveTime" select="supplyEventLastSummary/effectiveTime"/>
                                                        </xsl:call-template>
                                                        <high value="20060101"/>
                                                    </effectiveTime>
                                                    <quantity>
                                                        <xsl:call-template name="valueAndUnit">
                                                            <xsl:with-param name="valueElement" select="supplyEventLastSummary/quantity"/>
                                                            <xsl:with-param name="msgType" select="$msgType"/>
                                                        </xsl:call-template>
                                                    </quantity>
                                                </supplyEventLastSummary>
                                            </fulfillment3>
                                        </xsl:if>

                                        <!-- optional element summarizes the dispenses that have happened against the prescription to date  -->
                                        <xsl:if test="supplyEventPastSummary">
                                            <fulfillment4>
                                                <subsetCode code="FUTSUM"/>
                                                <supplyEventPastSummary>
                                                    <repeatNumber value="5">
                                                        <xsl:call-template name="valueAndUnit">
                                                            <xsl:with-param name="valueElement" select="supplyEventPastSummary/repeatNumber"/>
                                                            <xsl:with-param name="msgType" select="$msgType"/>
                                                        </xsl:call-template>
                                                    </repeatNumber>
                                                    <quantity>
                                                        <xsl:call-template name="valueAndUnit">
                                                            <xsl:with-param name="valueElement" select="supplyEventPastSummary/quantity"/>
                                                            <xsl:with-param name="msgType" select="$msgType"/>
                                                        </xsl:call-template>
                                                    </quantity>
                                                </supplyEventPastSummary>
                                            </fulfillment4>
                                        </xsl:if>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <component1>
                                            <sequenceNumber value="1"/>
                                            <subsequentSupplyRequest>

                                                <xsl:if test="subsequentSupplyRequest/effectiveTime">
                                                    <effectiveTime>
                                                        <xsl:call-template name="effectiveTime">
                                                            <xsl:with-param name="effectiveTime" select="subsequentSupplyRequest/effectiveTime"/>
                                                        </xsl:call-template>
                                                    </effectiveTime>
                                                </xsl:if>

                                                <repeatNumber value="1">
                                                    <xsl:if test="subsequentSupplyRequest/repeatNumber">
                                                        <xsl:call-template name="valueAndUnit">
                                                            <xsl:with-param name="valueElement" select="subsequentSupplyRequest/repeatNumber"/>
                                                            <xsl:with-param name="msgType" select="$msgType"/>
                                                        </xsl:call-template>
                                                    </xsl:if>
                                                </repeatNumber>

                                                <xsl:if test="subsequentSupplyRequest/quantity">
                                                    <quantity value="">
                                                        <xsl:call-template name="valueAndUnit">
                                                            <xsl:with-param name="valueElement" select="subsequentSupplyRequest/quantity"/>
                                                            <xsl:with-param name="msgType" select="$msgType"/>
                                                        </xsl:call-template>
                                                    </quantity>
                                                </xsl:if>

                                                <xsl:if test="subsequentSupplyRequest/expectedUseTime">
                                                    <expectedUseTime>
                                                        <xsl:call-template name="effectiveTime">
                                                            <xsl:with-param name="effectiveTime" select="subsequentSupplyRequest/expectedUseTime"/>
                                                        </xsl:call-template>
                                                    </expectedUseTime>
                                                </xsl:if>
                                            </subsequentSupplyRequest>
                                        </component1>
                                        <xsl:if test="initialSupplyRequest">
                                            <component2>
                                                <sequenceNumber value="2"/>
                                                <initialSupplyRequest>
                                                    <xsl:if test="initialSupplyRequest/effectiveTime">
                                                        <effectiveTime>
                                                            <xsl:call-template name="effectiveTime">
                                                                <xsl:with-param name="effectiveTime" select="initialSupplyRequest/effectiveTime"/>
                                                            </xsl:call-template>
                                                        </effectiveTime>
                                                    </xsl:if>

                                                    <!--<repeatNumber value="">
                                                        <xsl:if test="initialSupplyRequest/repeatNumber">
                                                            <xsl:call-template name="valueAndUnit">
                                                                <xsl:with-param name="valueElement" select="initialSupplyRequest/repeatNumber"/>
                                                                <xsl:with-param name="msgType" select="$msgType"/>
                                                            </xsl:call-template>
                                                        </xsl:if>
                                                    </repeatNumber>-->

                                                    <xsl:if test="initialSupplyRequest/quantity">
                                                        <quantity value="">
                                                            <xsl:call-template name="valueAndUnit">
                                                                <xsl:with-param name="valueElement" select="initialSupplyRequest/quantity"/>
                                                                <xsl:with-param name="msgType" select="$msgType"/>
                                                            </xsl:call-template>
                                                        </quantity>
                                                    </xsl:if>

                                                    <xsl:if test="initialSupplyRequest/expectedUseTime">
                                                        <expectedUseTime>
                                                            <xsl:call-template name="effectiveTime">
                                                                <xsl:with-param name="effectiveTime" select="initialSupplyRequest/expectedUseTime"/>
                                                            </xsl:call-template>
                                                        </expectedUseTime>
                                                    </xsl:if>
                                                </initialSupplyRequest>
                                            </component2>
                                        </xsl:if>
                                    </xsl:otherwise>
                                </xsl:choose>

                            </supplyRequestItem>
                        </component>
                    </xsl:for-each>
                </supplyRequest>
            </component3>

            <xsl:choose>
                <xsl:when test="$msgAction='queryResponse' ">
                    <xsl:for-each select="$dispenseProfileData">
                        <fulfillment>
                            <xsl:call-template name="Dispense">
                                <xsl:with-param name="description" select="@description"/>
                                <xsl:with-param name="ProfileData" select="$ProfileData"/>
                                <xsl:with-param name="IssueIndicator" select="$IssueIndicator"/>
                                <xsl:with-param name="notesIndicator" select="$notesIndicator"/>
                                <xsl:with-param name="msgAction" select="$msgAction"/>
                                <xsl:with-param name="authorElement">performer</xsl:with-param>
                                <!-- TODO: check on Immunization-drug-description parameter -->
                            </xsl:call-template>
                        </fulfillment>
                    </xsl:for-each>

                    <xsl:call-template name="IssueElements">
                        <xsl:with-param name="repeatingElementName">subjectOf1</xsl:with-param>
                        <xsl:with-param name="IssueIndicator" select="$IssueIndicator"/>
                        <xsl:with-param name="ItemProfileData" select="$prescriptionProfileData"/>
                        <xsl:with-param name="ItemData" select="$prescriptionData"/>
                        <xsl:with-param name="ProfileData" select="$ProfileData"/>
                        <xsl:with-param name="msgAction" select="$msgAction"/>
                    </xsl:call-template>

                    <xsl:call-template name="IssueIndicatorElements">
                        <xsl:with-param name="ElementName">subjectOf2</xsl:with-param>
                        <xsl:with-param name="IssueIndicator" select="$IssueIndicator"/>
                        <xsl:with-param name="ItemProfileData" select="$prescriptionProfileData"/>
                        <xsl:with-param name="ItemData" select="$prescriptionData"/>
                    </xsl:call-template>

                    <xsl:if test="$notesIndicator and $notesIndicator != 'false' ">
                        <xsl:for-each select="$prescriptionProfileData/note">
                            <subjectOf3>
                                <xsl:call-template name="annotation">
                                    <xsl:with-param name="msgType" select="$msgType"/>
                                    <xsl:with-param name="author-description" select="author/@description"/>
                                </xsl:call-template>
                            </subjectOf3>
                        </xsl:for-each>
                    </xsl:if>

                    <xsl:if test="$notesIndicator and $notesIndicator = 'false' and $prescriptionProfileData/note">
                        <subjectOf3>
                            <subsetCode code="SUM"/>
                            <annotationIndicator>
                                <statusCode code="completed"/>
                            </annotationIndicator>
                        </subjectOf3>
                    </xsl:if>


                    <xsl:if test="$prescriptionData/substitutionPermission">
                        <subjectOf5>
                            <substitutionPermission>
                                <code code="G">
                                    <xsl:if test="$prescriptionData/substitutionPermission/code">
                                        <xsl:call-template name="codeSystem">
                                            <xsl:with-param name="codeElement" select="$prescriptionData/substitutionPermission/code"/>
                                            <xsl:with-param name="msgType" select="$msgType"/>
                                        </xsl:call-template>
                                    </xsl:if>
                                </code>
                                <!-- fixed value -->
                                <!-- The reason why the prescriber has indicated that substitution is not allowed by the dispensing pharmacy: SubstanceAdminSubstitutionNotAllowedReason vocab -->
                                <reasonCode>
                                    <xsl:call-template name="codeSystem">
                                        <xsl:with-param name="codeElement" select="$prescriptionData/substitutionPermission/reasonCode"/>
                                        <xsl:with-param name="msgType" select="$msgType"/>
                                    </xsl:call-template>
                                </reasonCode>
                                <!-- allergy/intolerance -->
                            </substitutionPermission>
                        </subjectOf5>
                    </xsl:if>


                    <xsl:for-each select="$prescriptionProfileData/refusalToFill">
                        <subjectOf6>
                            <xsl:call-template name="refusalToFill">
                                <xsl:with-param name="description" select="@description"/>
                                <xsl:with-param name="ProfileData" select="$ProfileData"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                            </xsl:call-template>
                        </subjectOf6>
                    </xsl:for-each>

                    <xsl:for-each select="$prescriptionProfileData/history/item">
                        <subjectOf7>
                            <xsl:call-template name="historyItems">
                                <xsl:with-param name="item" select="."/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                            </xsl:call-template>
                        </subjectOf7>
                    </xsl:for-each>

                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="$prescriptionData/substitutionPermission">
                        <subjectOf1>
                            <substitutionPermission>
                                <code code="G"/>
                                <!-- fixed value -->
                                <!-- The reason why the prescriber has indicated that substitution is not allowed by the dispensing pharmacy: SubstanceAdminSubstitutionNotAllowedReason vocab -->
                                <reasonCode code="ALGALT">
                                    <xsl:call-template name="codeSystem">
                                        <xsl:with-param name="codeElement" select="$prescriptionData/substitutionPermission/reasonCode"/>
                                        <xsl:with-param name="msgType" select="$msgType"/>
                                    </xsl:call-template>
                                </reasonCode>
                                <!-- allergy/intolerance -->
                            </substitutionPermission>
                        </subjectOf1>
                    </xsl:if>

                    <xsl:for-each select="$prescriptionProfileData/note[1]">
                        <subjectOf2>
                            <xsl:call-template name="annotation">
                                <xsl:with-param name="msgType" select="$msgType"/>
                                <xsl:with-param name="author-description" select="author/@description"/>
                            </xsl:call-template>
                        </subjectOf2>
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>

            <!-- Indicates the clinical use category in which the prescription has been put -->
            <componentOf>
                <workingListEvent>
                    <code>
                        <xsl:choose>
                            <xsl:when test="not($prescriptionData/category)">
                                <xsl:call-template name="nullFlavor"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="codeSystem">
                                    <xsl:with-param name="codeElement" select="$prescriptionData/category"/>
                                    <xsl:with-param name="msgType" select="$msgType"/>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </code>
                </workingListEvent>
            </componentOf>

        </combinedMedicationRequest>

    </xsl:template>

    
    <xsl:template name="PrescriptionProfileSummary">
        <xsl:param name="description"/>
        <xsl:param name="ProfileData"/>
        <xsl:param name="IssueIndicator"/>
        <xsl:param name="notesIndicator"/>
        <xsl:param name="msgAction"/>
        <xsl:param name="msgType"/>
        <xsl:param name="minFills"/>

        <!-- preDeterminRequest|addRequest|queryResponse|transferResponse -->

        <xsl:variable name="prescriptionData" select="$BaseData/prescriptions/prescription[@description=$description]"/>
        <xsl:variable name="prescriptionProfileData" select="$ProfileData/items/prescription[@description=$description]"/>
        <xsl:variable name="dispenseProfileData" select="$ProfileData/items/dispense[prescription[@description=$description]]"/>

        <combinedMedicationRequest>
            <xsl:if test="$msgAction='queryResponse' or $msgAction='transferResponse'  or $msgAction='preDeterminResponse'">
                <id>
                    <xsl:call-template name="ID_Element">
                        <xsl:with-param name="Record" select="$prescriptionProfileData/record-id"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                        <xsl:with-param name="Default_OID">DIS_PRESCRIPTION_ID</xsl:with-param>
                    </xsl:call-template>
                </id>
            </xsl:if>

            <code code="DRUG"/>

            <statusCode>
                <xsl:attribute name="code">
                    <xsl:choose>
                        <xsl:when test="$msgAction='addRequest'">active</xsl:when>
                        <xsl:when test="$msgAction='preDeterminRequest'">new</xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$prescriptionData/statusCode/@code"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
            </statusCode>

            <xsl:call-template name="confidentialityCode">
                <xsl:with-param name="codeElement" select="$prescriptionData/confidentialityCode"/>
            </xsl:call-template>

            <directTarget>
                <medication>
                    <xsl:call-template name="Drug">
                        <xsl:with-param name="description" select="$prescriptionData/drug/@description"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </medication>
            </directTarget>

            <subject>
                <xsl:call-template name="PatientByDescription">
                    <xsl:with-param name="description" select="$ProfileData/patient/@description"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="format">CeRx</xsl:with-param>
                    <xsl:with-param name="use_phn">true</xsl:with-param>
                    <xsl:with-param name="use_name">true</xsl:with-param>
                    <xsl:with-param name="use_gender">true</xsl:with-param>
                    <xsl:with-param name="use_dob">true</xsl:with-param>
                </xsl:call-template>
            </subject>

            <xsl:if test="$msgAction='queryResponse' or $msgAction='transferResponse'  or $msgAction='preDeterminResponse' ">
                <!-- optionally the represented person - the supervisor pharmacist -->
                <xsl:if test="$prescriptionProfileData/supervisor">
                    <responsibleParty>
                        <xsl:call-template name="ProviderByDescription">
                            <xsl:with-param name="description" select="$prescriptionProfileData/supervisor/@description"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="format">CeRx</xsl:with-param>
                        </xsl:call-template>
                    </responsibleParty>
                </xsl:if>

                <!--  the pharmacist or pharm tech: person who dispensed -->
                <xsl:if test="$prescriptionProfileData/author">
                    <author typeCode="AUT">
                        <time>
                            <xsl:call-template name="effectiveTime">
                                <xsl:with-param name="effectiveTime" select="$prescriptionProfileData/author"/>
                            </xsl:call-template>
                        </time>
                        <xsl:call-template name="ProviderByDescription">
                            <xsl:with-param name="description" select="$prescriptionProfileData/author/@description"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="format">CeRx</xsl:with-param>
                        </xsl:call-template>
                    </author>
                </xsl:if>

            </xsl:if>

            <xsl:for-each select="$prescriptionData/substanceAdministrationDefinition">
                <definition>
                    <substanceAdministrationDefinition classCode="SBADM" moodCode="DEF">
                        <id>
                            <xsl:call-template name="ID_Element">
                                <xsl:with-param name="Record" select="record-id"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                            </xsl:call-template>
                        </id>
                        <code code="DRUG"/>
                    </substanceAdministrationDefinition>
                </definition>
            </xsl:for-each>

            <xsl:if test="$prescriptionProfileData/priorPrescription">
                <predecessor>
                    <priorCombinedMedicationRequest>
                        <id>
                            <xsl:variable name="Rx-description" select="$prescriptionProfileData/priorPrescription/@description"/>
                            <xsl:call-template name="ID_Element">
                                <xsl:with-param name="Record" select="$ProfileData/items/prescription[@description=$Rx-description]/record-id"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                                <xsl:with-param name="Default_OID">DIS_PRESCRIPTION_ID</xsl:with-param>
                            </xsl:call-template>
                        </id>
                        <code code="DRUG"/>
                    </priorCombinedMedicationRequest>
                </predecessor>
            </xsl:if>

            <xsl:for-each select="$prescriptionData/reason">
                <!-- 1..5 nillable PORX_MT010120CA.Reason2 -->
                <reason>
                    <xsl:if test="priorityNumber">
                        <priorityNumber value="">
                            <xsl:attribute name="value">
                                <xsl:value-of select="priorityNumber/@value"/>
                            </xsl:attribute>
                        </priorityNumber>
                    </xsl:if>
                    <xsl:choose>
                        <xsl:when test="@type='observationDiagnosis'">
                            <observationDiagnosis classCode="OBS">
                                <code code="DX"/>
                                <xsl:if test="text">
                                    <text>
                                        <xsl:value-of select="text"/>
                                    </text>
                                </xsl:if>
                                <statusCode>
                                    <xsl:choose>
                                        <xsl:when test="statusCode">
                                            <xsl:call-template name="codeSystem">
                                                <xsl:with-param name="codeElement" select="statusCode"/>
                                                <xsl:with-param name="msgType" select="$msgType"/>
                                            </xsl:call-template>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="code">active</xsl:attribute>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </statusCode>
                                <xsl:if test="value">
                                    <value>
                                        <xsl:call-template name="codeSystem">
                                            <xsl:with-param name="codeElement" select="value"/>
                                            <xsl:with-param name="msgType" select="$msgType"/>
                                        </xsl:call-template>
                                    </value>
                                </xsl:if>
                            </observationDiagnosis>
                        </xsl:when>
                        <xsl:when test="@type='observationSymptom'">
                            <observationSymptom classCode="OBS">
                                <code code="SYMPT"/>
                                <xsl:if test="text">
                                    <text>
                                        <xsl:value-of select="text"/>
                                    </text>
                                </xsl:if>
                                <statusCode code="">
                                    <xsl:call-template name="codeSystem">
                                        <xsl:with-param name="codeElement" select="statusCode"/>
                                        <xsl:with-param name="msgType" select="$msgType"/>
                                    </xsl:call-template>
                                </statusCode>
                                <xsl:if test="value">
                                    <value>
                                        <xsl:call-template name="codeSystem">
                                            <xsl:with-param name="codeElement" select="value"/>
                                            <xsl:with-param name="msgType" select="$msgType"/>
                                        </xsl:call-template>
                                    </value>
                                </xsl:if>
                            </observationSymptom>
                        </xsl:when>
                        <xsl:when test="@type='otherIndication'">
                            <otherIndication classCode="ACT">
                                <xsl:if test="value">
                                    <code>
                                        <xsl:call-template name="codeSystem">
                                            <xsl:with-param name="codeElement" select="value"/>
                                            <xsl:with-param name="msgType" select="$msgType"/>
                                        </xsl:call-template>
                                    </code>
                                </xsl:if>
                                <xsl:if test="text">
                                    <text>
                                        <xsl:value-of select="text"/>
                                    </text>
                                </xsl:if>
                                <statusCode>
                                    <xsl:choose>
                                        <xsl:when test="statusCode">
                                            <xsl:call-template name="codeSystem">
                                                <xsl:with-param name="codeElement" select="statusCode"/>
                                                <xsl:with-param name="msgType" select="$msgType"/>
                                            </xsl:call-template>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="code">completed</xsl:attribute>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </statusCode>
                            </otherIndication>
                        </xsl:when>
                    </xsl:choose>
                </reason>
            </xsl:for-each>
            <xsl:if test="not($prescriptionData/reason)">
                <reason>
                    <otherIndication classCode="ACT">
                        <xsl:call-template name="nullFlavor"/>
                        <statusCode code="completed"/>
                    </otherIndication>
                </reason>
            </xsl:if>

            <xsl:if test="$prescriptionData/non-authoritative">
                <precondition>
                    <verificationEventCriterion>
                        <code>
                            <xsl:call-template name="codeSystem">
                                <xsl:with-param name="codeElement" select="$prescriptionData/non-authoritative"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                            </xsl:call-template>
                        </code>
                    </verificationEventCriterion>
                </precondition>
            </xsl:if>

            <xsl:for-each select="$prescriptionData/observation">
                <pertinentInformation>
                    <xsl:choose>
                        <xsl:when test="code">
                            <quantityObservationEvent>
                                <!-- Identification of the type of observation that was made about the patient. The only two allowable types are height and weight. x_ActObservationHeightOrWeight vocab -->
                                <code>
                                    <xsl:call-template name="codeSystem">
                                        <xsl:with-param name="codeElement" select="code"/>
                                    </xsl:call-template>
                                </code>
                                <statusCode code="completed"/>
                                <!-- The date on which the measurement was made -->
                                <effectiveTime value="20050101">
                                    <xsl:call-template name="effectiveTime">
                                        <xsl:with-param name="effectiveTime" select="effectiveTime"/>
                                    </xsl:call-template>
                                </effectiveTime>
                                <!-- The amount (quantity and unit) that has been recorded for the patient's height and/or weight. E.g. height in meters, weight in kilograms, etc -->
                                <value>
                                    <xsl:call-template name="valueAndUnit">
                                        <xsl:with-param name="valueElement" select="value"/>
                                        <xsl:with-param name="msgType" select="$msgType"/>
                                    </xsl:call-template>
                                </value>
                            </quantityObservationEvent>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="quantityObservationEvent">
                                <xsl:with-param name="description" select="$prescriptionData/observation/@description"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </pertinentInformation>
            </xsl:for-each>

            <xsl:if test="not($msgAction='addRequest') ">
                <xsl:if test="$prescriptionProfileData/@infered = 'true' or $prescriptionProfileData/@infered = 'TRUE' ">
                    <derivedFrom>
                        <sourceDispense>
                            <statusCode code="completed"/>
                        </sourceDispense>
                    </derivedFrom>
                </xsl:if>
            </xsl:if>

            <xsl:for-each select="$prescriptionProfileData/coverage">
                <coverage>
                    <xsl:call-template name="coverage">
                        <xsl:with-param name="description" select="$prescriptionProfileData/coverage/@description"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </coverage>
            </xsl:for-each>

            <xsl:for-each select="$prescriptionData/dosageInstruction[1]">
                <component1>
                    <!-- This seems to be an old type of instruction -->
                    <administrationInstructions>
                        <code>
                            <xsl:attribute name="code"><xsl:value-of select="@code"/></xsl:attribute>
                        </code>
                        <text><xsl:value-of select="text"/></text>
                    </administrationInstructions>
                </component1>
            </xsl:for-each>

            <component2>
                <!-- 1..1 nillable  PORX_MT010120CA.SupplyRequest -->
                <supplyRequest>

                    <xsl:if test="not($msgAction='addRequest')">
                        <statusCode>
                            <xsl:attribute name="code">
                                <xsl:choose>
                                    <xsl:when test="$msgAction='addRequest'">active</xsl:when>
                                    <xsl:when test="$msgAction='preDeterminRequest'">new</xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$prescriptionData/statusCode/@code"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                        </statusCode>
                    </xsl:if>

                    <location>
                        <xsl:if test="$prescriptionProfileData/pharmacylocation/@code">
                            <substitutionConditionCode>
                                <xsl:call-template name="codeSystem">
                                    <xsl:with-param name="codeElement" select="$prescriptionProfileData/pharmacylocation"/>
                                    <xsl:with-param name="msgType" select="$msgType"/>
                                </xsl:call-template>
                            </substitutionConditionCode>
                        </xsl:if>

                        <xsl:call-template name="LocationByDescription">
                            <xsl:with-param name="description" select="$prescriptionProfileData/pharmacylocation/@description"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="format">CeRx</xsl:with-param>
                        </xsl:call-template>
                    </location>

                </supplyRequest>
            </component2>

                    <xsl:if test="$notesIndicator and $notesIndicator != 'false' ">
                        <xsl:for-each select="$prescriptionProfileData/note">
                            <subjectOf1>
                                <xsl:call-template name="annotation">
                                    <xsl:with-param name="msgType" select="$msgType"/>
                                    <xsl:with-param name="author-description" select="author/@description"/>
                                </xsl:call-template>
                            </subjectOf1>
                        </xsl:for-each>
                    </xsl:if>

                    <xsl:if test="$notesIndicator and $notesIndicator = 'false' and $prescriptionProfileData/note">
                        <subjectOf2>
                            <subsetCode code="SUM"/>
                            <annotationIndicator>
                                <statusCode code="completed"/>
                            </annotationIndicator>
                        </subjectOf2>
                    </xsl:if>

                    <xsl:for-each select="$prescriptionProfileData/refusalToFill">
                        <subjectOf3>
                            <xsl:call-template name="refusalToFill">
                                <xsl:with-param name="description" select="@description"/>
                                <xsl:with-param name="ProfileData" select="$ProfileData"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                            </xsl:call-template>
                        </subjectOf3>
                    </xsl:for-each>
            
            <!-- Indicates the clinical use category in which the prescription has been put -->
            <componentOf>
                <workingListEvent>
                    <code>
                        <xsl:choose>
                            <xsl:when test="not($prescriptionData/category)">
                                <xsl:call-template name="nullFlavor"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="codeSystem">
                                    <xsl:with-param name="codeElement" select="$prescriptionData/category"/>
                                    <xsl:with-param name="msgType" select="$msgType"/>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </code>
                </workingListEvent>
            </componentOf>

        </combinedMedicationRequest>

    </xsl:template>
    
    <xsl:template name="TransferPrescription">
        <xsl:param name="description"/>
        <xsl:param name="newLocation-description"/>
        <xsl:param name="ProfileData"/>
        <xsl:param name="IssueIndicator"/>
        <xsl:param name="notesIndicator"/>
        <xsl:param name="msgAction"/>
        <xsl:param name="msgType"/>

        <!-- addRequest|queryResponse -->

        <xsl:variable name="PrescriptionData" select="$BaseData/prescriptions/prescription[@description=$description]"/>
        <xsl:variable name="PrescriptionProfileData" select="$ProfileData/items/prescription[@description=$description]"/>

        <supplyRequest>
            <!-- Indicates the pharmacy to whom the prescription is to be assigned -->
            <location>
                <xsl:call-template name="LocationByDescription">
                    <xsl:with-param name="description" select="$newLocation-description"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="format">CeRx</xsl:with-param>
                </xsl:call-template>
            </location>

            <componentOf>
                <actRequest>
                    <!-- prescription identifier assigned to a specific medication order -->
                    <id>
                        <xsl:call-template name="ID_Element">
                            <xsl:with-param name="Record" select="$PrescriptionProfileData/record-id"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="Default_OID">DIS_PRESCRIPTION_ID</xsl:with-param>
                        </xsl:call-template>
                    </id>

                    <!-- optional element which If true (element present), indicates that the prescription is non-authoritative.  I.e. A paper copy must be viewed before the prescription can be dispensed. -->
                    <precondition>
                        <verificationEventCriterion>
                            <code code="VFPAPER"/>
                        </verificationEventCriterion>
                    </precondition>
                </actRequest>
            </componentOf>

        </supplyRequest>

    </xsl:template>

    <xsl:template name="PrescriptionReferance">
        <xsl:param name="description"/>
        <xsl:param name="ProfileData"/>
        <xsl:param name="msgAction"/>
        <xsl:param name="msgType"/>

        <!-- addRequest|queryResponse -->

        <xsl:variable name="PrescriptionData" select="$ProfileData/descendant-or-self::prescription[@description=$description]"/>

                <actRequest>
                    <!-- identification of the dispense that is being picked up -->
                    <id>
                        <xsl:call-template name="ID_Element">
                            <xsl:with-param name="Record" select="$PrescriptionData/record-id"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="Default_OID">DIS_PRESCRIPTION_ID</xsl:with-param>
                        </xsl:call-template>
                    </id>
                    <!-- the patient -->

                    <subject>
                        <xsl:call-template name="PatientByDescription">
                            <xsl:with-param name="description" select="$ProfileData/patient/@description"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="format">CeRx</xsl:with-param>
                            <xsl:with-param name="use_phn">true</xsl:with-param>
                            <xsl:with-param name="use_name">true</xsl:with-param>
                            <xsl:with-param name="use_gender">true</xsl:with-param>
                            <xsl:with-param name="use_dob">true</xsl:with-param>
                        </xsl:call-template>
                    </subject>

                </actRequest>

    </xsl:template>

    <xsl:template name="confidentialityCode">
        <xsl:param name="codeElement"/>
        <xsl:if test="$codeElement/@code">
            <confidentialityCode code="">
                <xsl:attribute name="code">
                    <xsl:value-of select="$codeElement/@code"/>
                </xsl:attribute>
            </confidentialityCode>
        </xsl:if>
    </xsl:template>

    <xsl:template name="coverage">
        <xsl:param name="description"/>
        <xsl:param name="msgType"/>

        <xsl:variable name="coverageData" select="$BaseData/coverages/coverage[@description=$description]"/>
        <coverage moodCode="EVN">
            <!-- Unique identification for a specific coverage extension Allows for referencing of a specific coverage extension.
                    This identifier may be needed on claims against the coverage.
                    At times the ID will not be available (such as when the request has just been submitted), the attribute is 'populated' -->
            <id>
                <xsl:call-template name="ID_Element">
                    <xsl:with-param name="Record" select="$coverageData/record-id"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="Default_OID"/>
                </xsl:call-template>
            </id>
            <author>
                <carrierRole>
                    <!-- A unique identifier for the payor organization responsible for the coverage extension -->
                    <id>
                        <xsl:call-template name="ID_Element">
                            <xsl:with-param name="Record" select="$coverageData/underwriter/record-id"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="Default_OID"/>
                        </xsl:call-template>
                    </id>
                    <underwritingCarrierOrganization>
                        <!-- name of payor -->
                        <name>
                            <xsl:value-of select="$coverageData/underwriter/name"/>
                        </name>
                    </underwritingCarrierOrganization>
                </carrierRole>
            </author>
        </coverage>
    </xsl:template>

    <xsl:template name="quantityObservationEvent">
        <xsl:param name="description"/>
        <xsl:param name="msgType"/>

        <xsl:variable name="observationData" select="$BaseData/observations/observation[@description=$description]"/>
        <quantityObservationEvent classCode="OBS" moodCode="EVN">
            <!-- 1..1 CV -->
            <!-- Identification of the type of measurement/observation that was made about the patient. The only two allowable types are height and weight. -->
            <!-- Distinguishes what kind of information is being specified. Code is mandatory to ensure that measurements/observations are distinguishable. -->
            <!-- domainName="x_ActObservationHeightOrWeight" -->
            <!-- Check: this vocabulary must have changed since last time, since it is now possible to send known values. -->
            <code code="">
                <xsl:call-template name="codeSystem">
                    <xsl:with-param name="codeElement" select="$observationData/code"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                </xsl:call-template>
            </code>
            <statusCode code="completed"/>
            <!-- 1..1 TS.FULLDATE -->
            <!-- The date on which the measurement was made -->
            <!-- Allows providers to evaluate currency of the information.
                Because the date of measurement determines the relevance of the information, this attribute is defined as 'populated'. -->
            <effectiveTime>
                <xsl:call-template name="effectiveTime">
                    <xsl:with-param name="effectiveTime" select="$observationData/effectiveTime"/>
                </xsl:call-template>
            </effectiveTime>
            <!-- 1..1 PQ.HEIGHTWEIGHT -->
            <!-- The amount (quantity and unit) that has been recorded for the specific type of observation. E.g. height in meters, weight in kilograms. -->
            <!-- Provides comparable representation of the measurement. May be used in calculations.
                Attribute is deined as 'mandatory' to ensure that a value is supplied, if there is a measurement. -->
            <value>
                <xsl:call-template name="valueAndUnit">
                    <xsl:with-param name="valueElement" select="$observationData/value"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                </xsl:call-template>
            </value>
        </quantityObservationEvent>
    </xsl:template>

    <xsl:template name="refusalToFill">
        <xsl:param name="description"/>
        <xsl:param name="ProfileData"/>
        <xsl:param name="msgType"/>

        <xsl:variable name="refusalToFillData" select="$BaseData/refusalToFills/refusalToFill[@description=description]"/>
        <xsl:variable name="refusalToFillProfileData" select="$ProfileData/items/refusalToFill[@description=description]"/>

        <refusalToFill>
            <xsl:choose>
                <xsl:when test="$refusalToFillProfileData/code">
                    <code code="">
                        <xsl:call-template name="codeSystem">
                            <xsl:with-param name="codeElement" select="$refusalToFillProfileData/code"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                        </xsl:call-template>
                    </code>
                </xsl:when>
                <xsl:otherwise>
                    <code code="">
                        <xsl:call-template name="codeSystem">
                            <xsl:with-param name="codeElement" select="$refusalToFillData/code"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                        </xsl:call-template>
                    </code>
                </xsl:otherwise>
            </xsl:choose>

            <statusCode code="completed"/>
            <!-- Supports capture of reasons such as 'moral objection' which are not tied to specific issues.  Set to CWE to allow non-coded reasons: ActSupplyFulfillmentRefusalReason vocab -->
            <xsl:choose>
                <xsl:when test="$refusalToFillProfileData/code">
                    <reasonCode code="">
                        <xsl:call-template name="codeSystem">
                            <xsl:with-param name="codeElement" select="$refusalToFillProfileData/reasonCode"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                        </xsl:call-template>
                    </reasonCode>
                </xsl:when>
                <xsl:otherwise>
                    <reasonCode code="">
                        <xsl:call-template name="codeSystem">
                            <xsl:with-param name="codeElement" select="$refusalToFillData/reasonCode"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                        </xsl:call-template>
                    </reasonCode>
                </xsl:otherwise>
            </xsl:choose>
            <!-- Indicates who refused to fulfill the prescription -->
            <author>
                <!-- pharmacist or prescriber id  -->
                <xsl:call-template name="ProviderByDescription">
                    <xsl:with-param name="description" select="$refusalToFillProfileData/author/@description"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="format">CeRx</xsl:with-param>
                </xsl:call-template>
            </author>
            <location>
                <xsl:call-template name="LocationByDescription">
                    <xsl:with-param name="description" select="$refusalToFillProfileData/location/@description"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="format">CeRx</xsl:with-param>
                </xsl:call-template>
            </location>
            <!-- 0..5 elements for any detected issues associated with a prescription that resulted in a dispenser refusing to fill it -->
            <!-- Issues can be pass in or placed with in the refusal to fill element as an IssueList or just an Issue -->

            <xsl:call-template name="IssueElements">
                <xsl:with-param name="repeatingElementName">reason</xsl:with-param>
                <xsl:with-param name="IssueIndicator">true</xsl:with-param>
                <xsl:with-param name="ItemProfileData" select="$refusalToFillProfileData"/>
                <xsl:with-param name="ItemData" select="$refusalToFillData"/>
                <xsl:with-param name="ProfileData" select="$ProfileData"/>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

        </refusalToFill>

    </xsl:template>

    <xsl:template name="historyItems">
        <xsl:param name="item"/>
        <xsl:param name="msgType"/>
        <controlActEvent>
            <code>
                <xsl:call-template name="codeSystem">
                    <xsl:with-param name="codeElement" select="$item/code"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                </xsl:call-template>
            </code>
            <statusCode>
                <xsl:call-template name="codeSystem">
                    <xsl:with-param name="codeElement" select="$item/statusCode"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                </xsl:call-template>
            </statusCode>
            <effectiveTime>
                <xsl:call-template name="effectiveTime">
                    <xsl:with-param name="effectiveTime" select="$item/effectiveTime"/>
                </xsl:call-template>
            </effectiveTime>
            <author>
                <time>
                    <xsl:call-template name="effectiveTime">
                        <xsl:with-param name="effectiveTime" select="$item/author"/>
                    </xsl:call-template>
                </time>
                <xsl:call-template name="ProviderByDescription">
                    <xsl:with-param name="description" select="$item/author/@description"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="format">CeRx</xsl:with-param>
                </xsl:call-template>
            </author>
        </controlActEvent>

    </xsl:template>

    <xsl:template name="severityObservation">
        <xsl:param name="severityData"/>
        <xsl:param name="elementName"/>
        <xsl:if test="$severityData/@code">
            <xsl:element name="{$elementName}">
                <severityObservation>
                    <!-- fixed value SEV -->
                    <code code="SEV"/>
                    <!-- some fixed value: irrelevant -->
                    <statusCode code="active"/>
                    <!-- Indicates the gravity of the allergy, intolerance or reaction in terms of its actual or potential impact on the patient. SeverityObservation vocab -->
                    <value code="">
                        <xsl:attribute name="code">
                            <xsl:value-of select="$severityData/@code"/>
                        </xsl:attribute>
                    </value>
                </severityObservation>
            </xsl:element>
        </xsl:if>

    </xsl:template>

    <xsl:template name="responsibleParty">
        <xsl:param name="msgType"/>

        <responsibleParty>
            <!-- optional id for person -->
            <xsl:if test="phn">
                <id>
                    <xsl:call-template name="ID_Element">
                        <xsl:with-param name="Record" select="phn"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                        <xsl:with-param name="Default_OID">
                            <xsl:choose>
                                <xsl:when test="phn/@root">
                                    <xsl:value-of select="phn/@root"/>
                                </xsl:when>
                                <xsl:otherwise>PE_PHN</xsl:otherwise>
                            </xsl:choose>
                        </xsl:with-param>
                    </xsl:call-template>
                </id>
            </xsl:if>
            <!-- optional responsible Person Type.  x_SimplePersonalRelationship -->
            <xsl:if test="relationship">
                <code code="">
                    <xsl:call-template name="codeSystem">
                        <xsl:with-param name="codeElement" select="relationship"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </code>
            </xsl:if>
            <xsl:if test="telecom">
                <telecom use="WP" value="">
                    <xsl:attribute name="value">
                        <xsl:value-of select="telecom"/>
                    </xsl:attribute>
                </telecom>
            </xsl:if>
            <agentPerson>
                <name>
                    <xsl:value-of select="name"/>
                </name>
            </agentPerson>
        </responsibleParty>

    </xsl:template>

    <xsl:template name="IssueIndicatorElements">
        <xsl:param name="ElementName"/>
        <xsl:param name="IssueIndicator"/>
        <xsl:param name="ItemProfileData"/>
        <xsl:param name="ItemData"/>

        <xsl:if test="$IssueIndicator and $IssueIndicator = 'false'">
            <xsl:if test="$ItemData/issue or $ItemData/issueList or $ItemProfileData/issue or $ItemProfileData/issueList">
                <xsl:element name="{$ElementName}">
                    <subsetCode code="SUM"/>
                    <detectedIssueIndicator>
                        <statusCode code="completed"/>
                    </detectedIssueIndicator>
                </xsl:element>
            </xsl:if>

        </xsl:if>
    </xsl:template>

    <xsl:template name="IssueElements">
        <xsl:param name="repeatingElementName"/>
        <xsl:param name="ProfileData"/>
        <xsl:param name="IssueIndicator"/>
        <xsl:param name="ItemProfileData"/>
        <xsl:param name="ItemData"/>
        <xsl:param name="msgType"/>

        <xsl:if test="$IssueIndicator and $IssueIndicator !='false' ">
            <xsl:for-each select="$ProfileData/Items/issue[causes/*/@description = $ItemData/@description]">
                <xsl:call-template name="ProfileIssueList">
                    <xsl:with-param name="IssueData" select="."/>
                    <xsl:with-param name="ProfileData" select="$ProfileData"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                </xsl:call-template>
            </xsl:for-each>

            <xsl:for-each select="$ItemProfileData/IssueList">
                <xsl:call-template name="IssueList">
                    <xsl:with-param name="IssueList-description" select="@description"/>
                    <xsl:with-param name="ProfileData" select="$ProfileData"/>
                    <xsl:with-param name="repeatingElementName">
                        <xsl:value-of select="$repeatingElementName"/>
                    </xsl:with-param>
                    <xsl:with-param name="msgType" select="$msgType"/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$ItemData/IssueList">
                <xsl:call-template name="IssueList">
                    <xsl:with-param name="IssueList-description" select="@description"/>
                    <xsl:with-param name="ProfileData" select="$ProfileData"/>
                    <xsl:with-param name="repeatingElementName">
                        <xsl:value-of select="$repeatingElementName"/>
                    </xsl:with-param>
                    <xsl:with-param name="msgType" select="$msgType"/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$ItemProfileData/Issue">
                <xsl:element name="{$repeatingElementName}">
                    <xsl:call-template name="Issue">
                        <xsl:with-param name="Issue-description" select="@description"/>
                        <xsl:with-param name="Issue-details" select="node()"/>
                        <xsl:with-param name="ProfileData" select="$ProfileData"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </xsl:element>
            </xsl:for-each>
            <xsl:for-each select="$ItemData/Issue">
                <xsl:element name="{$repeatingElementName}">
                    <xsl:call-template name="Issue">
                        <xsl:with-param name="Issue-description" select="@description"/>
                        <xsl:with-param name="Issue-details" select="node()"/>
                        <xsl:with-param name="ProfileData" select="$ProfileData"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </xsl:element>
            </xsl:for-each>
        </xsl:if>

    </xsl:template>


    <xsl:template name="consentEvent">
        <xsl:param name="ProfileData"/>
        <xsl:param name="SubjectOfElementName"/>
        <xsl:param name="author-description"/>
        <xsl:param name="msgType"/>
        <xsl:param name="useOverRide">false</xsl:param> <!-- optional, used to tell template to use override not keyword if both are present -->

        <xsl:variable name="consentElement" select="$ProfileData/consent"/>
        <xsl:if test="$consentElement">
            <xsl:element name="{$SubjectOfElementName}">
                <consentEvent>
                    <!-- fixed value inf -->
                    <code code="INF"/>
                    <!-- optional value for time that patient consent will expire  'Low' is effective time and 'High' is end time. -->
                    <xsl:if test="$consentElement/effectiveTime">
                        <effectiveTime>
                            <xsl:call-template name="effectiveTime">
                                <xsl:with-param name="effectiveTime" select="$consentElement/effectiveTime"/>
                            </xsl:call-template>
                        </effectiveTime>
                    </xsl:if>
                    <!-- optional value that indicates a reason for overriding a patient's consent rules: ActConsentInformationAccessReason - vocab  -->
                    <xsl:if test="$consentElement/OverRideCode and not($consentElement/keyword and $useOverRide = 'false')">
                            <reasonCode>
                                <xsl:call-template name="codeSystem">
                                    <xsl:with-param name="codeElement" select="$consentElement/OverRideCode"/>
                                    <xsl:with-param name="msgType" select="$msgType"/>
                                </xsl:call-template>
                            </reasonCode>
                    </xsl:if>

                    
                    
                    <!-- The patient's record the consent is associated with  -->
                    <subject1>
                        <xsl:call-template name="PatientByDescription">
                            <xsl:with-param name="description" select="$ProfileData/patient/@description"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="format">patient_note</xsl:with-param>
                            <xsl:with-param name="use_phn">true</xsl:with-param>
                            <xsl:with-param name="use_name">true</xsl:with-param>
                            <xsl:with-param name="use_gender">true</xsl:with-param>
                            <xsl:with-param name="use_dob">true</xsl:with-param>
                        </xsl:call-template>
                    </subject1>




                    <!--optionally indicate that information access was approved by provider rather than the patient
                        I.e. This is an override rather than an actual consent, and is used for the purposes of  “breaking the glass” only	
                        Clinical circumstances may demand that a patient's information be accessed without consent to ensure patient safety.
                    -->
                    <xsl:choose>
                        <xsl:when test="$consentElement/OverRideCode and not($consentElement/keyword and $useOverRide = 'false')">
                            <author1>
                                <xsl:call-template name="ProviderByDescription">
                                    <xsl:with-param name="description" select="$author-description"/>
                                    <xsl:with-param name="msgType" select="$msgType"/>
                                    <xsl:with-param name="format">CeRx</xsl:with-param>
                                </xsl:call-template>
                            </author1>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- Indicates that the consent was provided by the patient or representative -->
                            <author2>
                                <!-- optional: x_PhysicalVerbalParticipationMode vocab : Indicates whether the patient's consent is written or verbal -->
                                <modeCode code="V">
                                    <xsl:if test="$consentElement/modeCode">
                                        <xsl:call-template name="codeSystem">
                                            <xsl:with-param name="codeElement" select="$consentElement/modeCode"/>
                                            <xsl:with-param name="msgType" select="$msgType"/>
                                        </xsl:call-template>
                                    </xsl:if>
                                </modeCode>
                                <!-- optional:  Indicates the keyword appropriate to the action being performed by the message -->
                                <xsl:if test="$consentElement/keyword">
                                    <signatureText>
                                        <xsl:value-of select="$consentElement/keyword"/>
                                    </signatureText>
                                </xsl:if>
                                <!-- Consent can be provided by the patient or representative or the provider: next element is a choice which indicates who provided consent -->
                                <!--<patient/>-->
                                <!-- patient is simply an empty tag - the actual patient identification is in the participant3 element -->
                                <!-- indicate consent was by patient rep -->
                                <xsl:choose>
                                    <xsl:when test="$consentElement/ProvidedBy">
                                        <responsibleParty>
                                            <agentPerson>
                                                <name>
                                                    <xsl:value-of select="$consentElement/ProvidedBy"/>
                                                </name>
                                            </agentPerson>
                                        </responsibleParty>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <patient/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </author2>
                        </xsl:otherwise>
                    </xsl:choose>

                    <!-- Defines the types of information permission is being granted to access -->
                    <subject2>
                        <informDefinition>
                            <!-- Identifies the beneficiary of the consent as being a Provider or Service Location -->
                            <receiver>
                                <xsl:call-template name="ProviderByDescription">
                                    <xsl:with-param name="description" select="$author-description"/>
                                    <xsl:with-param name="msgType" select="$msgType"/>
                                    <xsl:with-param name="format">CeRx</xsl:with-param>
                                </xsl:call-template>
                            </receiver>
                            <!-- mandatory at least once - can occur up to 10 times: The type of patient information that can be accessed or modified -->
                            <subject>
                                <actDefinition>
                                    <!-- ActInformationAccessTypeCode vocab - The type of patient information that can be accessed or modified.
                                        COMMENT: Maybe for everyone else: not us, we're going to use a keyword for access to everything.
                                    -->
                                    <!-- using 2.5 vocab - Release of Information/MR / Authorization to Disclosure Protected Health Information: basically anything can be seen -->
                                    <code code="1">
                                        <xsl:if test="$consentElement/AccessLevel[1]">
                                            <xsl:call-template name="codeSystem">
                                                <xsl:with-param name="codeElement" select="$consentElement/AccessLevel[1]"/>
                                                <xsl:with-param name="msgType" select="$msgType"/>
                                            </xsl:call-template>
                                        </xsl:if>
                                    </code>
                                </actDefinition>
                            </subject>
                            <xsl:for-each select="$consentElement/AccessLevel[position() > 1]">
                                <subject>
                                    <actDefinition>
                                        <!-- ActInformationAccessTypeCode vocab - The type of patient information that can be accessed or modified.
                                        COMMENT: Maybe for everyone else: not us, we're going to use a keyword for access to everything.
                                    -->
                                        <!-- using 2.5 vocab - Release of Information/MR / Authorization to Disclosure Protected Health Information: basically anything can be seen -->
                                        <code>
                                            <xsl:call-template name="codeSystem">
                                                <xsl:with-param name="codeElement" select="."/>
                                                <xsl:with-param name="msgType" select="$msgType"/>
                                            </xsl:call-template>
                                        </code>
                                    </actDefinition>
                                </subject>
                            </xsl:for-each>

                        </informDefinition>
                    </subject2>
                </consentEvent>
            </xsl:element>
        </xsl:if>

    </xsl:template>

    <xsl:template name="transmissionWrapperStart">
        <xsl:param name="interactionId"/>
        <xsl:param name="msgType"/>


        <!-- A unique identifier for the message -->
        <id root="" extension="">
            <xsl:attribute name="root">
                <xsl:choose>
                    <xsl:when test="$msgType = 'serverMsg' or $msgType = 'CRserverMsg'  or $msgType='NECSTserverMsg' ">
                        <xsl:call-template name="getOIDRootByName">
                            <xsl:with-param name="OID_Name">DIS_MESSAGE_ID</xsl:with-param>
                            <xsl:with-param name="msgType" select="$msgType"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="getOIDRootByName">
                            <xsl:with-param name="OID_Name">PORTAL_MESSAGE_ID</xsl:with-param>
                            <xsl:with-param name="msgType" select="$msgType"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="extension">
                <xsl:value-of select="$OID"/>
            </xsl:attribute>
        </id>
        <creationTime value="20050101102001">
            <xsl:attribute name="value">
                <xsl:call-template name="getBaseDateTime"/>
            </xsl:attribute>
        </creationTime>
        <versionCode code="V3-2005-05"/>
        <interactionId root="2.16.840.1.113883.1.6" extension="">
            <xsl:attribute name="root">
                <xsl:call-template name="getOIDRootByName">
                    <xsl:with-param name="OID_Name">DIS_INTERACTION_ID</xsl:with-param>
                    <xsl:with-param name="msgType" select="$msgType"/>
                </xsl:call-template>
            </xsl:attribute>
            <xsl:attribute name="extension">
                <xsl:value-of select="$interactionId"/>
            </xsl:attribute>
        </interactionId>
        <processingCode code="P"/>
        <processingModeCode code="T"/>
        <acceptAckCode code="ER"/>

        <xsl:choose>
            <xsl:when test="$msgType='clientMsg'">
                <!-- identify sender of the message - DIS -->
                <receiver>
                    <xsl:call-template name="serverSystem">
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </receiver>
                <!-- identify receiver of the message - portal -->
                <sender>
                    <xsl:call-template name="clientSystem">
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </sender>
            </xsl:when>
            <xsl:otherwise>
                <!-- identify receiver of the message - portal -->
                <receiver>
                    <xsl:call-template name="clientSystem"/>
                </receiver>
                <!-- identify sender of the message - DIS -->
                <sender>
                    <xsl:call-template name="serverSystem"/>
                </sender>
            </xsl:otherwise>
        </xsl:choose>

        <!-- server messages have an acknowledgement set of nodes. -->
        <xsl:if test="$msgType = 'serverMsg'">
            <acknowledgement>
                <typeCode code="AA"/>
                <!-- AcknowledgementType vocab, AA means Receiving application successfully processed message -->
                <!-- required single element to identify the message that this one is acknowledging -->
                <targetMessage>
                    <!-- References the identifier of the message this current message is acknowledging -->
                    <xsl:choose>
                        <xsl:when test="$lastServerRequest/descendant-or-self::hl7:*[1]/child::node()[local-name() = 'id']">
                            <xsl:copy-of select="$lastServerRequest/descendant-or-self::hl7:*[1]/child::node()[local-name() = 'id']"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="nullFlavor"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </targetMessage>
            </acknowledgement>
        </xsl:if>
    </xsl:template>

    <xsl:template name="transmissionWrapperEnd">
        <xsl:param name="msgType"/>
        <!-- 
        <xsl:choose>
            <xsl:when test="$msgType='clientMsg'">
                <receiver>
                    <xsl:call-template name="serverSystem">
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </receiver>
                <sender>
                    <xsl:call-template name="clientSystem">
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </sender>
            </xsl:when>
            <xsl:otherwise>
                <receiver>
                    <xsl:call-template name="clientSystem"/>
                </receiver>
                <sender>
                    <xsl:call-template name="serverSystem"/>
                </sender>
            </xsl:otherwise>
        </xsl:choose>
        -->

    </xsl:template>

    <xsl:template name="controlActStart">
        <xsl:param name="msg-effective-time"/>
        <xsl:param name="author-description"/>
        <xsl:param name="location-description"/>
        <xsl:param name="author-time"/>
        <xsl:param name="ParticipationMode"/>
        <xsl:param name="TriggerEventCode"/>
        <xsl:param name="msgType"/>
        <xsl:param name="msgAction"/>
        <xsl:param name="reason-code"/>
        <xsl:param name="reason-text"/>

        <!-- identifier should be stored for use in ‘undos’.  They should be stored in such a way that they are associated with the item that was modified by this event.  For example, a system should be able to show the list of trigger event identifiers for the actions that have been recorded against a particular prescription. -->
        <id root="" extension="">
            <xsl:attribute name="root">
                <xsl:choose>
                    <xsl:when test="$msgType = 'serverMsg' ">
                        <xsl:call-template name="getOIDRootByName">
                            <xsl:with-param name="OID_Name">DIS_CONTROL_ACT_ID</xsl:with-param>
                            <xsl:with-param name="msgType" select="$msgType"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="getOIDRootByName">
                            <xsl:with-param name="OID_Name">PORTAL_CONTROL_ACT_ID</xsl:with-param>
                            <xsl:with-param name="msgType" select="$msgType"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="extension">
                <xsl:value-of select="$OID"/>
            </xsl:attribute>
        </id>
        <!-- HL7TriggerEventCode - Identifies the trigger event that occurred -->
        <code>
            <xsl:attribute name="code">
                <xsl:value-of select="$TriggerEventCode"/>
            </xsl:attribute>
        </code>
        <!-- don't know what status code is for -->
        <statusCode code="completed"/>

        <!-- effective time is only used in non query messages. -->
        <xsl:if test="not(starts-with($msgAction,'query'))">
            <effectiveTime>
                <xsl:attribute name="value">
                    <xsl:choose>
                        <xsl:when test="$msg-effective-time">
                            <xsl:value-of select="$msg-effective-time"/>
                        </xsl:when>
                        <xsl:when test="$author-time">
                            <xsl:value-of select="$author-time"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="getBaseDateTime"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
            </effectiveTime>
        </xsl:if>

        <xsl:if test="$reason-code">
            <reasonCode>
                <xsl:attribute name="code">
                    <xsl:value-of select="$reason-code"/>
                </xsl:attribute>
                <xsl:if test="$reason-text">
                    <originalText>
                        <xsl:value-of select="$reason-text"/>
                    </originalText>
                </xsl:if>
            </reasonCode>
        </xsl:if>

        <!-- need supervisor -->
        <!-- person responsible for the event that caused this message - the pharmacist, doctor, or most likely a public health nurse -->
        <xsl:if test="$author-description">
            <author typeCode="AUT">
                <time>
                    <xsl:choose>
                        <xsl:when test="$author-time">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$author-time"/>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="nullFlavor"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </time>
                <!--ParticipationMode -  Indicates how the person who recorded the event became aware of it -->
                <modeCode>
                    <xsl:choose>
                        <xsl:when test="$ParticipationMode">
                            <xsl:attribute name="code">
                                <xsl:value-of select="$ParticipationMode"/>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="nullFlavor"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </modeCode>
                <xsl:call-template name="ProviderByDescription">
                    <xsl:with-param name="description" select="$author-description"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="format">CeRx</xsl:with-param>
                </xsl:call-template>
            </author>
        </xsl:if>

        <!-- An identification of a service location (or facility) where health service has been or can be delivered.  E.g. Pharmacy -->
        <xsl:if test="$location-description">
            <location>
                <xsl:call-template name="LocationByDescription">
                    <xsl:with-param name="description" select="$location-description"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="format">CeRx</xsl:with-param>
                </xsl:call-template>
            </location>
        </xsl:if>

    </xsl:template>

    <xsl:template name="actEvent_Elements">
        <xsl:param name="ProfileData"/>
        <xsl:param name="record-id"/>
        <xsl:param name="msgType"/>

        <actEvent>
            <!-- the id of the created reaction -->
            <id>
                <xsl:call-template name="ID_Element">
                    <xsl:with-param name="Record" select="$record-id"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                </xsl:call-template>
            </id>

            <!-- patient to whom the reaction is attached -->
            <recordTarget>
                <xsl:call-template name="PatientByDescription">
                    <xsl:with-param name="description" select="$ProfileData/patient/@description"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="format">CeRx</xsl:with-param>
                    <xsl:with-param name="use_phn">true</xsl:with-param>
                    <xsl:with-param name="use_name">true</xsl:with-param>
                    <xsl:with-param name="use_gender">true</xsl:with-param>
                    <xsl:with-param name="use_dob">true</xsl:with-param>
                    <xsl:with-param name="use_telecom">true</xsl:with-param>
                </xsl:call-template>
            </recordTarget>
        </actEvent>
    </xsl:template>

    <xsl:template name="AcceptMessage">
        <xsl:param name="ProfileData"/>
        <xsl:param name="record-id"/>
        <xsl:param name="record-extension"/>
        <xsl:param name="record-root"/>
        <xsl:param name="interactionId"/>
        <xsl:param name="TriggerEventCode"/>
        <xsl:param name="msgType"/>
        <xsl:param name="IssueList-description"/>


        <xsl:call-template name="transmissionWrapperStart">
            <xsl:with-param name="interactionId" select="$interactionId"/>
            <xsl:with-param name="msgType" select="$msgType"/>
        </xsl:call-template>

        <controlActEvent>
            <xsl:call-template name="controlActStart">
                <xsl:with-param name="TriggerEventCode" select="$TriggerEventCode"/>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <subject>
                <actEvent>
                    <!-- the id of the created reaction -->
                    <id>
                        <xsl:choose>
                            <xsl:when test="$record-id">
                                <xsl:call-template name="ID_Element">
                                    <xsl:with-param name="Record" select="$record-id"/>
                                    <xsl:with-param name="msgType" select="$msgType"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="root">
                                    <xsl:value-of select="$record-root"/>
                                </xsl:attribute>
                                <xsl:attribute name="extension">
                                    <xsl:value-of select="$record-extension"/>
                                </xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </id>

                    <!-- patient to whom the reaction is attached -->
                    <recordTarget>
                        <xsl:call-template name="PatientByDescription">
                            <xsl:with-param name="description" select="$ProfileData/patient/@description"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="format">CeRx</xsl:with-param>
                            <xsl:with-param name="use_phn">true</xsl:with-param>
                            <xsl:with-param name="use_name">true</xsl:with-param>
                            <xsl:with-param name="use_gender">true</xsl:with-param>
                            <xsl:with-param name="use_dob">true</xsl:with-param>
                            <xsl:with-param name="use_telecom">true</xsl:with-param>
                        </xsl:call-template>
                    </recordTarget>
                </actEvent>
            </subject>

            <xsl:call-template name="IssueList">
                <xsl:with-param name="IssueList-description" select="$IssueList-description"/>
                <xsl:with-param name="repeatingElementName">subjectOf1</xsl:with-param>
                <xsl:with-param name="ProfileData" select="$ProfileData"/>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

        </controlActEvent>

        <xsl:call-template name="transmissionWrapperEnd">
            <xsl:with-param name="msgType" select="$msgType"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="AcceptMessage-ActRequest">
        <xsl:param name="ProfileData"/>
        <xsl:param name="record-id"/>
        <xsl:param name="record-OID"/>
        <xsl:param name="interactionId"/>
        <xsl:param name="TriggerEventCode"/>
        <xsl:param name="msgType"/>
        <xsl:param name="IssueList-description"/>


        <xsl:call-template name="transmissionWrapperStart">
            <xsl:with-param name="interactionId" select="$interactionId"/>
            <xsl:with-param name="msgType" select="$msgType"/>
        </xsl:call-template>

        <controlActEvent>
            <xsl:call-template name="controlActStart">
                <xsl:with-param name="TriggerEventCode" select="$TriggerEventCode"/>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <subject>
                <actRequest>
                    <!-- the id of the created reaction -->
                    <id>
                        <xsl:attribute name="root">
                            <xsl:call-template name="getOIDRootByName">
                                <xsl:with-param name="OID_Name" select="$record-OID"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                            </xsl:call-template>
                        </xsl:attribute>
                        <xsl:attribute name="extension">
                            <xsl:value-of select="$record-id"/>
                        </xsl:attribute>
                    </id>

                    <!-- patient to whom the reaction is attached -->
                    <subject>
                        <xsl:call-template name="PatientByDescription">
                            <xsl:with-param name="description" select="$ProfileData/patient/@description"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="format">CeRx</xsl:with-param>
                            <xsl:with-param name="use_phn">true</xsl:with-param>
                            <xsl:with-param name="use_name">true</xsl:with-param>
                            <xsl:with-param name="use_gender">true</xsl:with-param>
                            <xsl:with-param name="use_dob">true</xsl:with-param>
                            <xsl:with-param name="use_telecom">true</xsl:with-param>
                        </xsl:call-template>
                    </subject>
                </actRequest>
            </subject>

            <xsl:call-template name="IssueList">
                <xsl:with-param name="IssueList-description" select="$IssueList-description"/>
                <xsl:with-param name="repeatingElementName">subjectOf1</xsl:with-param>
                <xsl:with-param name="ProfileData" select="$ProfileData"/>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

        </controlActEvent>

        <xsl:call-template name="transmissionWrapperEnd">
            <xsl:with-param name="msgType" select="$msgType"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="AcceptMessage-NoPayload">
        <xsl:param name="ProfileData"/>
        <xsl:param name="interactionId"/>
        <xsl:param name="TriggerEventCode"/>
        <xsl:param name="msgType"/>
        <xsl:param name="IssueList-description"/>


        <xsl:call-template name="transmissionWrapperStart">
            <xsl:with-param name="interactionId" select="$interactionId"/>
            <xsl:with-param name="msgType" select="$msgType"/>
        </xsl:call-template>

        <controlActEvent>
            <xsl:call-template name="controlActStart">
                <xsl:with-param name="TriggerEventCode" select="$TriggerEventCode"/>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <xsl:call-template name="IssueList">
                <xsl:with-param name="IssueList-description" select="$IssueList-description"/>
                <xsl:with-param name="repeatingElementName">subjectOf1</xsl:with-param>
                <xsl:with-param name="ProfileData" select="$ProfileData"/>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

        </controlActEvent>

        <xsl:call-template name="transmissionWrapperEnd">
            <xsl:with-param name="msgType" select="$msgType"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="AcceptDispenseMessage">
        <xsl:param name="ProfileData"/>
        <xsl:param name="dispense-description"/>
        <xsl:param name="interactionId"/>
        <xsl:param name="TriggerEventCode"/>
        <xsl:param name="msgType"/>
        <xsl:param name="IssueList-description"/>

        <xsl:variable name="DispenseProfileData" select="$ProfileData/items/dispense[@description=$dispense-description]"/>
        <xsl:variable name="Rx-description" select="$DispenseProfileData/prescription/@description"/>
        <xsl:variable name="PrescriptionData" select="$ProfileData/items/prescription[@description=$Rx-description]"/>

        <xsl:call-template name="transmissionWrapperStart">
            <xsl:with-param name="interactionId" select="$interactionId"/>
            <xsl:with-param name="msgType" select="$msgType"/>
        </xsl:call-template>

        <controlActEvent>
            <xsl:call-template name="controlActStart">
                <xsl:with-param name="TriggerEventCode" select="$TriggerEventCode"/>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <subject>
                <supplyEvent>
                    <!-- the id of the created reaction -->
                    <id>
                        <xsl:call-template name="ID_Element">
                            <xsl:with-param name="Record" select="$DispenseProfileData/record-id"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="Default_OID">DIS_DISPENSE_ID</xsl:with-param>
                        </xsl:call-template>
                    </id>

                    <!-- prescription being filled -->
                    <inFulfillmentOf>
                        <actRequest>
                            <!-- This is an identifier assigned to a specific medication order. the prescription id that is being filled -->
                            <id>
                                <xsl:call-template name="ID_Element">
                                    <xsl:with-param name="Record" select="$PrescriptionData/record-id"/>
                                    <xsl:with-param name="msgType" select="$msgType"/>
                                    <xsl:with-param name="Default_OID">DIS_PRESCRIPTION_ID</xsl:with-param>
                                </xsl:call-template>
                            </id>
                        </actRequest>
                    </inFulfillmentOf>
                </supplyEvent>
            </subject>

            <xsl:call-template name="IssueList">
                <xsl:with-param name="IssueList-description" select="$IssueList-description"/>
                <xsl:with-param name="repeatingElementName">subjectOf1</xsl:with-param>
                <xsl:with-param name="ProfileData" select="$ProfileData"/>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

        </controlActEvent>

        <xsl:call-template name="transmissionWrapperEnd">
            <xsl:with-param name="msgType" select="$msgType"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="RejectMessage">
        <xsl:param name="ProfileData"/>
        <xsl:param name="interactionId"/>
        <xsl:param name="TriggerEventCode"/>
        <xsl:param name="msgType"/>
        <xsl:param name="IssueList-description"/>


        <xsl:call-template name="transmissionWrapperStart">
            <xsl:with-param name="interactionId" select="$interactionId"/>
            <xsl:with-param name="msgType" select="$msgType"/>
        </xsl:call-template>

        <controlActEvent>
            <xsl:call-template name="controlActStart">
                <xsl:with-param name="TriggerEventCode" select="$TriggerEventCode"/>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <xsl:call-template name="IssueList">
                <xsl:with-param name="IssueList-description" select="$IssueList-description"/>
                <xsl:with-param name="repeatingElementName">subjectOf</xsl:with-param>
                <xsl:with-param name="ProfileData" select="$ProfileData"/>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

        </controlActEvent>

        <xsl:call-template name="transmissionWrapperEnd">
            <xsl:with-param name="msgType" select="$msgType"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="DateQueryElement">
        <xsl:param name="elementName"/>
        <xsl:param name="startDate"/>
        <xsl:param name="endDate"/>
        <xsl:if test="$startDate or $endDate">
            <xsl:element name="{$elementName}">
                <value>
                    <low>
                        <xsl:choose>
                            <xsl:when test="$startDate">
                                <xsl:attribute name="value">
                                    <xsl:value-of select="$startDate"/>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="nullFlavor"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </low>
                    <high>
                        <xsl:choose>
                            <xsl:when test="$endDate">
                                <xsl:attribute name="value">
                                    <xsl:value-of select="$endDate"/>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="nullFlavor"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </high>
                </value>
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <xsl:template name="OIDNameFromType">
        <xsl:param name="recordName"/>
        <xsl:choose>
            <xsl:when test="$recordName='allergy' ">DIS_ALLERGY_ID</xsl:when>
            <xsl:when test="$recordName='reaction' ">DIS_REACTION_ID</xsl:when>
            <xsl:when test="$recordName='immunization' ">DIS_IMMUNIZATION_ID</xsl:when>
            <xsl:when test="$recordName='observation' ">DIS_OBSERVATION_ID</xsl:when>
            <xsl:when test="$recordName='condition' ">DIS_MEDICAL_CONDITION_ID</xsl:when>
            <xsl:when test="$recordName='prescription' ">DIS_PRESCRIPTION_ID</xsl:when>
            <xsl:when test="$recordName='otherMedication' ">DIS_OTHER_ACTIVE_MED_ID</xsl:when>
            <xsl:when test="$recordName='dispense' ">DIS_DISPENSE_ID</xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="ID_Element">
        <xsl:param name="Record"/>
        <xsl:param name="Default_OID"/>
        <xsl:param name="msgType"/>
        <xsl:variable name="OID_Value">
            <xsl:choose>
                <xsl:when test="$Record/@root_OID">
                    <xsl:value-of select="$Record/@root_OID"/>
                </xsl:when>
                <xsl:when test="$Default_OID">
                    <xsl:value-of select="$Default_OID"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>

        <xsl:if test="$OID_Value and not($OID_Value = '')">
            <xsl:attribute name="root">
                <xsl:call-template name="getOIDRootByName">
                    <xsl:with-param name="OID_Name" select="$OID_Value"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                </xsl:call-template>
            </xsl:attribute>
        </xsl:if>

        <xsl:attribute name="extension">
            <xsl:call-template name="record-id">
                <xsl:with-param name="Record" select="$Record"/>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </xsl:attribute>
    </xsl:template>

    <xsl:template name="record-id">
        <xsl:param name="Record"/>
        <xsl:param name="msgType"/>

        <xsl:choose>
            <xsl:when test="$msgType = 'clientMsg'">
                <xsl:value-of select="$Record/@client"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$Record/@server"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

</xsl:stylesheet>
