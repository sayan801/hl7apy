<?xml version="1.0" encoding="UTF-8"?>
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="urn:hl7-org:v3" xmlns:hl7="urn:hl7-org:v3" version="1.0">
    <xsl:include href="../Lib/MsgCreation_Lib.xsl"/>



    <xsl:template name="MedicalProfileDetailQueryResponse">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>
        <xsl:param name="query-id"/>
        <xsl:param name="query-status">OK</xsl:param>
        <xsl:param name="IssueList-description"/>

        <xsl:variable name="msgType">serverMsg</xsl:variable>
        <xsl:variable name="msgAction">queryResponse</xsl:variable>

        <xsl:variable name="patient_description">
            <xsl:call-template name="getPatientNameByID">
                <xsl:with-param name="node" select="descendant-or-self::hl7:controlActEvent/hl7:queryByParameter/hl7:parameterList/hl7:patientID/hl7:value"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][patient/@description = $patient_description]"/>

        <PORX_IN060380CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">PORX_IN060380CA</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>


            <controlActEvent>
                <xsl:call-template name="controlActStart">
                    <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                    <xsl:with-param name="TriggerEventCode">PORX_TE060290UV</xsl:with-param>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="msgAction" select="$msgAction"/>

                </xsl:call-template>

                <xsl:variable name="includeNotes" select="descendant-or-self::hl7:includeNotesIndicator/hl7:value/@value"/>
                <xsl:variable name="includeIssues" select="descendant-or-self::hl7:includeIssuesIndicator/hl7:value/@value"/>

                <!-- 0..999 elements that can either be a combinedMedicationRequest or an otherMedication -->
                <xsl:for-each select="$ProfileData/items/child::*[self::prescription or self::otherMedication]">
                    <xsl:choose>
                        <xsl:when test="local-name()='prescription'">
                            <!-- <combinedMedicationRequest> -->
                            <subject>
                                <xsl:call-template name="Prescription">
                                    <xsl:with-param name="description" select="@description"/>
                                    <xsl:with-param name="ProfileData" select="$ProfileData"/>
                                    <xsl:with-param name="msgType" select="$msgType"/>
                                    <xsl:with-param name="msgAction" select="$msgAction"/>
                                    <xsl:with-param name="notesIndicator" select="$includeNotes"/>
                                    <xsl:with-param name="IssueIndicator" select="$includeIssues"/>
                                </xsl:call-template>
                            </subject>
                        </xsl:when>
                        <xsl:when test="local-name()='otherMedication'">
                            <!-- <otherMedication> -->
                            <subject>
                                <xsl:call-template name="otherMedication">
                                    <xsl:with-param name="description" select="@description"/>
                                    <xsl:with-param name="ProfileData" select="$ProfileData"/>
                                    <xsl:with-param name="msgType" select="$msgType"/>
                                    <xsl:with-param name="msgAction" select="$msgAction"/>
                                    <xsl:with-param name="notesIndicator" select="$includeNotes"/>
                                    <xsl:with-param name="IssueIndicator" select="$includeIssues"/>
                                </xsl:call-template>
                            </subject>
                        </xsl:when>
                    </xsl:choose>
                </xsl:for-each>

                <!-- issues element to communicate any problems with the query - i.e. lack of access to a keyword protected profile - not DUR issues in this case -->
                <xsl:if test="$IssueList-description">
                    <xsl:call-template name="IssueList">
                        <xsl:with-param name="ProfileData" select="$ProfileData"/>
                        <xsl:with-param name="repeatingElementName">subjectOf</xsl:with-param>
                        <xsl:with-param name="IssueList-description" select="$IssueList-description"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                        <xsl:with-param name="msgAction" select="$msgAction"/>
                    </xsl:call-template>
                </xsl:if>

                <queryAck>
                    <xsl:choose>
                        <xsl:when test="descendant-or-self::queryByParameter/queryId">
                            <xsl:copy-of select="descendant-or-self::queryByParameter/queryId"/>
                        </xsl:when>
                        <xsl:when test="$query-id">
                            <queryId root="" extension="">
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

                    <queryResponseCode code="">
                        <xsl:attribute name="code">
                            <xsl:value-of select="$query-status"/>
                        </xsl:attribute>
                    </queryResponseCode>

                    <xsl:choose>
                        <xsl:when test="$ProfileData/items/@total">
                            <resultTotalQuantity value="">
                                <xsl:attribute name="value">
                                    <xsl:value-of select="$ProfileData/items/@total"/>
                                </xsl:attribute>
                            </resultTotalQuantity>
                            <resultCurrentQuantity value="">
                                <xsl:attribute name="value">
                                    <xsl:value-of select="$ProfileData/items/@current"/>
                                </xsl:attribute>
                            </resultCurrentQuantity>
                            <resultRemainingQuantity value="">
                                <xsl:attribute name="value">
                                    <xsl:value-of select="$ProfileData/items/@remaining"/>
                                </xsl:attribute>
                            </resultRemainingQuantity>
                        </xsl:when>
                        <xsl:otherwise>
                            <resultTotalQuantity value="">
                                <xsl:attribute name="value">
                                    <xsl:value-of select="count($ProfileData/items/prescription) + count($ProfileData/items/otherMedication)"/>
                                </xsl:attribute>
                            </resultTotalQuantity>
                            <resultCurrentQuantity value="">
                                <xsl:attribute name="value">
                                    <xsl:value-of select="count($ProfileData/items/prescription) + count($ProfileData/items/otherMedication)"/>
                                </xsl:attribute>
                            </resultCurrentQuantity>
                            <resultRemainingQuantity value="0"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </queryAck>

                <!-- Copy the requested queryByParameter Request -->
                <xsl:copy-of select="descendant-or-self::hl7:queryByParameter"/>

            </controlActEvent>

            <xsl:call-template name="transmissionWrapperEnd">
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </PORX_IN060380CA>

    </xsl:template>
    <xsl:template name="MedicalProfileDetailQueryRequest">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>

        <xsl:param name="author-description"/>
        <xsl:param name="supervisor-description"/>
        <xsl:param name="location-description"/>
        <xsl:param name="ParticipationMode"/>
        <xsl:param name="author-time"/>
        <xsl:param name="query-id"/>

        <xsl:param name="administrationEffectiveStartDate"/>
        <xsl:param name="administrationEffectiveEndDate"/>
        <xsl:param name="eventEffectiveStartDate"/>
        <xsl:param name="eventEffectiveEndDate"/>
        <xsl:param name="mostRecentDrugIndicator"/>
        <xsl:param name="diagnosisCode"/>
        <xsl:param name="diagnosisCodeSystem"/>
        <xsl:param name="drugCode"/>
        <xsl:param name="drugCodeSystem"/>
        <xsl:param name="includeHistory"/>
        <xsl:param name="includeIssues"/>
        <xsl:param name="includeNotes"/>
        <xsl:param name="includePendingChanges"/>
        <xsl:param name="otherIndicationCode"/>
        <xsl:param name="otherIndicationCodeSystem"/>
        <xsl:param name="symptomCode"/>
        <xsl:param name="symptomCodeSystem"/>
                            <xsl:param name="useOverRide"/>


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

        <PORX_IN060370CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">PORX_IN060370CA</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <controlActEvent classCode="CACT" moodCode="EVN">
                <xsl:call-template name="controlActStart">
                    <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                    <xsl:with-param name="author-description" select="$author-description"/>
                    <xsl:with-param name="location-description" select="$location-description"/>
                    <xsl:with-param name="author-time" select="$author-time"/>
                    <xsl:with-param name="ParticipationMode" select="$ParticipationMode"/>
                    <xsl:with-param name="TriggerEventCode">PORX_TE060280UV</xsl:with-param>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="msgAction" select="$msgAction"/>
                </xsl:call-template>


                <!--
                    Indicates the consent or keyword used to authorize this access or update.
                    May also be used to override access to the information (“break the glass”) on a message by message basis
                -->
                <!-- consent event -->
                <xsl:call-template name="consentEvent">
                    <xsl:with-param name="ProfileData" select="$ProfileData"/>
                    <xsl:with-param name="SubjectOfElementName">subjectOf2</xsl:with-param>
                    <xsl:with-param name="author-description" select="$author-description"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="useOverRide" select="$useOverRide"/>
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
                        <!--Optional: Indicates the administration period for which the request/query applies.
                            Filter the result set to include only those medication records (prescription order, prescription dispense and other active medication) 
                            for which the patient was deemed to be taking the drug within the specified period 
                        -->
                        <xsl:call-template name="DateQueryElement">
                            <xsl:with-param name="elementName">administrationEffectivePeriod</xsl:with-param>
                            <xsl:with-param name="endDate" select="$administrationEffectiveEndDate"/>
                            <xsl:with-param name="startDate" select="$administrationEffectiveStartDate"/>
                        </xsl:call-template>

                        <xsl:if test="$diagnosisCode">
                            <diagnosisCode>
                                <value>
                                    <xsl:attribute name="code">
                                        <xsl:value-of select="$diagnosisCode"/>
                                    </xsl:attribute>
                                    <xsl:if test="$diagnosisCodeSystem">
                                        <xsl:attribute name="codeSystem">
                                            <xsl:call-template name="getOIDRootByName">
                                                <xsl:with-param name="OID_Name" select="$diagnosisCodeSystem"/>
                                                <xsl:with-param name="msgType" select="$msgType"/>
                                            </xsl:call-template>
                                        </xsl:attribute>
                                    </xsl:if>
                                </value>
                            </diagnosisCode>
                        </xsl:if>
                        <!-- optional: Indicates that the result set is to be filtered to include only those records pertaining to the specified drug. 
                            The code may refer to an orderable medication  or a higher level drug classification  -->
                        <xsl:if test="$drugCode">
                            <drugCode>
                                <value>
                                    <xsl:attribute name="code">
                                        <xsl:value-of select="$drugCode"/>
                                    </xsl:attribute>
                                    <xsl:if test="$drugCodeSystem">
                                        <xsl:attribute name="codeSystem">
                                            <xsl:call-template name="getOIDRootByName">
                                                <xsl:with-param name="OID_Name" select="$drugCodeSystem"/>
                                                <xsl:with-param name="msgType" select="$msgType"/>
                                            </xsl:call-template>
                                        </xsl:attribute>
                                    </xsl:if>
                                </value>
                            </drugCode>
                        </xsl:if>

                        <!-- Optional: Indicates that the returned records should be filtered to only include those which have been changed in some way (had status changed, been annotated, 
                            prescription was dispensed, etc.) within the indicated time-period.  This will commonly be used to 'retrieve everything that has been changed since xxx' -->
                        <xsl:call-template name="DateQueryElement">
                            <xsl:with-param name="elementName">amendedInTimeRange</xsl:with-param>
                            <xsl:with-param name="endDate" select="$eventEffectiveEndDate"/>
                            <xsl:with-param name="startDate" select="$eventEffectiveStartDate"/>
                        </xsl:call-template>

                        <!-- Indicates whether or not history events associated with a prescription order, prescription dispense and/or active medications are to be returned along with the detailed information. -->
                        <includeEventHistoryIndicator>
                            <value value="false">
                                <xsl:if test="$includeHistory">
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="$includeHistory"/>
                                    </xsl:attribute>
                                </xsl:if>
                            </value>
                        </includeEventHistoryIndicator>

                        <!-- Indicates whether or not Issues (detected and/or managed)  attached to the prescriptions, dispenses and other active medication records are to be returned along with the detailed information. -->
                        <includeIssuesIndicator>
                            <value value="false">
                                <xsl:if test="$includeIssues">
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="$includeIssues"/>
                                    </xsl:attribute>
                                </xsl:if>
                            </value>
                        </includeIssuesIndicator>

                        <!-- Indicates whether or not notes attached to the prescription, dispenses and other active medication records are to be returned along with the detailed information -->
                        <includeNotesIndicator>
                            <value value="false">
                                <xsl:if test="$includeNotes">
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="$includeNotes"/>
                                    </xsl:attribute>
                                </xsl:if>
                            </value>
                        </includeNotesIndicator>

                        <!-- Indicates whether to include future changes (e.g. status changes that aren't effective yet)  associated with a prescription order, prescription dispense 
                            and/or active medications are to be returned along with the detailed information. -->
                        <includePendingChangesIndicator>
                            <value value="false">
                                <xsl:if test="$includePendingChanges">
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="$includePendingChanges"/>
                                    </xsl:attribute>
                                </xsl:if>
                            </value>
                        </includePendingChangesIndicator>

                        <!-- Indicates whether or not a prescription dispenses returned on a query should be limited to only the most recent dispense for a prescription.
                            Allows the returning of at most one prescription dispense record per a prescription.
                            The default is 'TRUE' indicating that retrieval should be for only the most recent dispense for a prescription is to be included in a query result -->
                        <mostRecentDispenseForEachRxIndicator>
                            <value value="false">
                                <xsl:if test="$mostRecentDrugIndicator">
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="$mostRecentDrugIndicator"/>
                                    </xsl:attribute>
                                </xsl:if>
                            </value>
                        </mostRecentDispenseForEachRxIndicator>

                        <!-- optional: Indicates that the result set is to be filtered to include only those records pertaining to the specified non-condition-related indication code 
                            ActNonConditionIndicationCode vocab
                        -->
                        <xsl:if test="$otherIndicationCode">
                            <otherIndicationCode>
                                <value>
                                    <xsl:attribute name="code">
                                        <xsl:value-of select="$otherIndicationCode"/>
                                    </xsl:attribute>
                                    <xsl:if test="$otherIndicationCodeSystem">
                                        <xsl:attribute name="codeSystem">
                                            <xsl:call-template name="getOIDRootByName">
                                                <xsl:with-param name="OID_Name" select="$otherIndicationCodeSystem"/>
                                                <xsl:with-param name="msgType" select="$msgType"/>
                                            </xsl:call-template>
                                        </xsl:attribute>
                                    </xsl:if>
                                </value>
                            </otherIndicationCode>
                        </xsl:if>

                        <!-- required values to identify the patient -->
                        <xsl:call-template name="PatientByDescription">
                            <xsl:with-param name="description" select="$patient_description"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="use_phn">true</xsl:with-param>
                            <xsl:with-param name="format">query</xsl:with-param>
                        </xsl:call-template>

                        <xsl:if test="$symptomCode">
                            <symptomCode>
                                <value>
                                    <xsl:attribute name="code">
                                        <xsl:value-of select="$symptomCode"/>
                                    </xsl:attribute>
                                    <xsl:if test="$symptomCodeSystem">
                                        <xsl:attribute name="codeSystem">
                                            <xsl:call-template name="getOIDRootByName">
                                                <xsl:with-param name="OID_Name" select="$symptomCodeSystem"/>
                                                <xsl:with-param name="msgType" select="$msgType"/>
                                            </xsl:call-template>
                                        </xsl:attribute>
                                    </xsl:if>
                                </value>
                            </symptomCode>
                        </xsl:if>

                    </parameterList>
                </queryByParameter>

            </controlActEvent>

            <xsl:call-template name="transmissionWrapperEnd">
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </PORX_IN060370CA>

    </xsl:template>


    
    <xsl:template name="MedicalPrescriptionProfileHistoryRequest">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>

        <xsl:param name="author-description"/>
        <xsl:param name="supervisor-description"/>
        <xsl:param name="location-description"/>
        <xsl:param name="ParticipationMode"/>
        <xsl:param name="author-time"/>
        <xsl:param name="query-id"/>

        <xsl:param name="record-id"/> 
        <xsl:param name="eventEffectiveEndDate"/>
        <xsl:param name="eventEffectiveStartDate"/>
        <xsl:param name="historyIndicator"/>
        <xsl:param name="includeIssues"/>
        <xsl:param name="includeNotes"/>
        <xsl:param name="includePendingChanges"/>
                            <xsl:param name="useOverRide"/>
        
        
        
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

        
        <PORX_IN060170CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">PORX_IN060170CA</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <controlActEvent classCode="CACT" moodCode="EVN">
                <xsl:call-template name="controlActStart">
                    <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                    <xsl:with-param name="author-description" select="$author-description"/>
                    <xsl:with-param name="location-description" select="$location-description"/>
                    <xsl:with-param name="author-time" select="$author-time"/>
                    <xsl:with-param name="ParticipationMode" select="$ParticipationMode"/>
                    <xsl:with-param name="TriggerEventCode">PORX_TE060180UV</xsl:with-param>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="msgAction" select="$msgAction"/>
                </xsl:call-template>


                <!--
                    Indicates the consent or keyword used to authorize this access or update.
                    May also be used to override access to the information (“break the glass”) on a message by message basis
                -->
                <!-- consent event -->
                <xsl:call-template name="consentEvent">
                    <xsl:with-param name="ProfileData" select="$ProfileData"/>
                    <xsl:with-param name="SubjectOfElementName">subjectOf2</xsl:with-param>
                    <xsl:with-param name="author-description" select="$author-description"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="useOverRide" select="$useOverRide"/>
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
                        <!--Optional: Indicates that the returned records should be filtered to only include those which have been changed in some way 
                            (had status changed, been annotated, prescription was dispensed, etc.) within the indicated time-period.  
                            This will commonly be used to "retrieve everything that has been changed since xxx 
                        -->
                        <xsl:call-template name="DateQueryElement">
                            <xsl:with-param name="elementName">amendedInTimeRange</xsl:with-param>
                            <xsl:with-param name="endDate" select="$eventEffectiveEndDate"/>
                            <xsl:with-param name="startDate" select="$eventEffectiveStartDate"/>
                        </xsl:call-template>

                    	<!-- required element that indicates whether or not history of selected medication records are to be returned along with the detailed information. -->
                    	<includeEventHistoryIndicator>
                    		<value value="false">
                    		    <xsl:if test="$historyIndicator">
                    		        <xsl:attribute name="value"><xsl:value-of select="$historyIndicator"/></xsl:attribute>
                    		    </xsl:if>
                    		</value>
                    	</includeEventHistoryIndicator>                        

                        <!-- Indicates whether or not Issues (detected and/or managed)  attached to the prescriptions, dispenses and other active medication records are to be returned along with the detailed information. -->
                        <includeIssuesIndicator>
                            <value value="false">
                                <xsl:if test="$includeIssues">
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="$includeIssues"/>
                                    </xsl:attribute>
                                </xsl:if>
                            </value>
                        </includeIssuesIndicator>

                        <!-- Indicates whether or not notes attached to the prescription, dispenses and other active medication records are to be returned along with the detailed information -->
                        <includeNotesIndicator>
                            <value value="false">
                                <xsl:if test="$includeNotes">
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="$includeNotes"/>
                                    </xsl:attribute>
                                </xsl:if>
                            </value>
                        </includeNotesIndicator>
                        <includePendingChangesIndicator>
                            <value value="false">
                                <xsl:if test="$includePendingChanges">
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="$includePendingChanges"/>
                                    </xsl:attribute>
                                </xsl:if>
                            </value>
                        </includePendingChangesIndicator>

                        <!-- required values to identify the patient -->
                        <xsl:call-template name="PatientByDescription">
                            <xsl:with-param name="description" select="$patient_description"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="use_phn">true</xsl:with-param>
                            <xsl:with-param name="format">query</xsl:with-param>
                        </xsl:call-template>

                        <!-- required attribute to identify  the prescription for which detailed information is required. The result set will be filtered to only the specific prescription -->
                        <prescriptionOrderNumber>
                            <value>
                                <xsl:attribute name="root">
                                    <xsl:call-template name="getOIDRootByName">
                                        <xsl:with-param name="OID_Name">DIS_PRESCRIPTION_ID</xsl:with-param>
                                        <xsl:with-param name="msgType" select="$msgType"/>
                                    </xsl:call-template>
                                </xsl:attribute>
                                <xsl:attribute name="extension">
                                    <xsl:value-of select="$record-id"/>
                                </xsl:attribute>
                            </value>
                        </prescriptionOrderNumber>                        
                    </parameterList>
                    
                </queryByParameter>

            </controlActEvent>

            <xsl:call-template name="transmissionWrapperEnd">
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </PORX_IN060170CA>
        
    </xsl:template>
    <xsl:template name="MedicalDispenseProfileDetailRequest">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>

        <xsl:param name="author-description"/>
        <xsl:param name="supervisor-description"/>
        <xsl:param name="location-description"/>
        <xsl:param name="ParticipationMode"/>
        <xsl:param name="author-time"/>
        <xsl:param name="query-id"/>

        <xsl:param name="record-id"/>
        <xsl:param name="includeIssues"/>
        <xsl:param name="includeNotes"/>
                            <xsl:param name="useOverRide"/>
        
        
        
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

        
        <PORX_IN060210CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">PORX_IN060210CA</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <controlActEvent classCode="CACT" moodCode="EVN">
                <xsl:call-template name="controlActStart">
                    <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                    <xsl:with-param name="author-description" select="$author-description"/>
                    <xsl:with-param name="location-description" select="$location-description"/>
                    <xsl:with-param name="author-time" select="$author-time"/>
                    <xsl:with-param name="ParticipationMode" select="$ParticipationMode"/>
                    <xsl:with-param name="TriggerEventCode">PORX_TE060010UV</xsl:with-param>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="msgAction" select="$msgAction"/>
                </xsl:call-template>


                <!--
                    Indicates the consent or keyword used to authorize this access or update.
                    May also be used to override access to the information (“break the glass”) on a message by message basis
                -->
                <!-- consent event -->
                <xsl:call-template name="consentEvent">
                    <xsl:with-param name="ProfileData" select="$ProfileData"/>
                    <xsl:with-param name="SubjectOfElementName">subjectOf2</xsl:with-param>
                    <xsl:with-param name="author-description" select="$author-description"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                              <xsl:with-param name="useOverRide" select="$useOverRide"/>
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

                        <!-- Indicates whether or not Issues (detected and/or managed)  attached to the prescriptions, dispenses and other active medication records are to be returned along with the detailed information. -->
                        <includeIssuesIndicator>
                            <value value="false">
                                <xsl:if test="$includeIssues">
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="$includeIssues"/>
                                    </xsl:attribute>
                                </xsl:if>
                            </value>
                        </includeIssuesIndicator>

                        <!-- Indicates whether or not notes attached to the prescription, dispenses and other active medication records are to be returned along with the detailed information -->
                        <includeNotesIndicator>
                            <value value="false">
                                <xsl:if test="$includeNotes">
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="$includeNotes"/>
                                    </xsl:attribute>
                                </xsl:if>
                            </value>
                        </includeNotesIndicator>

                        <!-- required values to identify the patient -->
                        <xsl:call-template name="PatientByDescription">
                            <xsl:with-param name="description" select="$patient_description"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="use_phn">true</xsl:with-param>
                            <xsl:with-param name="format">query</xsl:with-param>
                        </xsl:call-template>
                        
                        <!-- Identifies which  dispense record should be retrieved -->
                        <prescriptionDispenseNumber>
                            <value>
                                <xsl:attribute name="root">
                                    <xsl:call-template name="getOIDRootByName">
                                        <xsl:with-param name="OID_Name">DIS_DISPENSE_ID</xsl:with-param>
                                        <xsl:with-param name="msgType" select="$msgType"/>
                                    </xsl:call-template>
                                </xsl:attribute>
                                <xsl:attribute name="extension">
                                    <xsl:value-of select="$record-id"/>
                                </xsl:attribute>
                            </value>
                        </prescriptionDispenseNumber>                        
                    </parameterList>
                </queryByParameter>

            </controlActEvent>

            <xsl:call-template name="transmissionWrapperEnd">
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </PORX_IN060210CA>
        
    </xsl:template>
    <xsl:template name="MedicalDispenseProfileSummaryRequest">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>

        <xsl:param name="author-description"/>
        <xsl:param name="supervisor-description"/>
        <xsl:param name="location-description"/>
        <xsl:param name="ParticipationMode"/>
        <xsl:param name="author-time"/>
        <xsl:param name="query-id"/>

        <xsl:param name="eventEffectiveEndDate"/>
        <xsl:param name="eventEffectiveStartDate"/>
        <xsl:param name="mostRecentDispenses"/>
        <xsl:param name="mostRecentDrug"/>
        <xsl:param name="issueFilterCode"/>
                            <xsl:param name="useOverRide"/>
        
        
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

        
        <PORX_IN060230CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">PORX_IN060230CA</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <controlActEvent classCode="CACT" moodCode="EVN">
                <xsl:call-template name="controlActStart">
                    <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                    <xsl:with-param name="author-description" select="$author-description"/>
                    <xsl:with-param name="location-description" select="$location-description"/>
                    <xsl:with-param name="author-time" select="$author-time"/>
                    <xsl:with-param name="ParticipationMode" select="$ParticipationMode"/>
                    <xsl:with-param name="TriggerEventCode">PORX_TE060050UV</xsl:with-param>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="msgAction" select="$msgAction"/>
                </xsl:call-template>


                <!--
                    Indicates the consent or keyword used to authorize this access or update.
                    May also be used to override access to the information (“break the glass”) on a message by message basis
                -->
                <!-- consent event -->
                <xsl:call-template name="consentEvent">
                    <xsl:with-param name="ProfileData" select="$ProfileData"/>
                    <xsl:with-param name="SubjectOfElementName">subjectOf2</xsl:with-param>
                    <xsl:with-param name="author-description" select="$author-description"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                             <xsl:with-param name="useOverRide" select="$useOverRide"/>
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
                        <!--Optional: Indicates that the returned records should be filtered to only include those which have been changed in some way 
                            (had status changed, been annotated, prescription was dispensed, etc.) within the indicated time-period.  
                            This will commonly be used to "retrieve everything that has been changed since xxx 
                        -->
                        <xsl:call-template name="DateQueryElement">
                            <xsl:with-param name="elementName">administrationEffectivePeriod</xsl:with-param>
                            <xsl:with-param name="endDate" select="$eventEffectiveEndDate"/>
                            <xsl:with-param name="startDate" select="$eventEffectiveStartDate"/>
                        </xsl:call-template>

                        <!-- Indicates whether records to be returned (e.g. prescription order, prescription dispense and/or other medication) should be filtered to those 
                            with at least one persistent un-managed issue (against the record), with at least one persistent issues or should return all records, independent of 
                            the presence of persistent issues. IssueFilterCode vocab: A - all,I - with issues, U - with unmanaged issues -->
                        <issueFilterCode>
                            <value code="">
                                <xsl:attribute name="code">
                                    <xsl:choose>
                                        <xsl:when test="$issueFilterCode">
                                            <xsl:value-of select="$issueFilterCode"/>
                                        </xsl:when>
                                        <xsl:otherwise>A</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:attribute>
                            </value>
                        </issueFilterCode>
                <!-- Indicates whether or not the medication records are to retrieved based on the most recent by Drug Code.  
                      If true, only the most recent  dispense for a particular drug generic classification will be returned. 
                      The default is 'FALSE' indicating that retrieval of dispense records should not be limited to one per drug  -->  
				<mostRecentByDrugIndicator>
					<value value="false">
					    <xsl:if test="$mostRecentDrug">
					        <xsl:attribute name="value"><xsl:value-of select="$mostRecentDrug"/></xsl:attribute>
					    </xsl:if>
					</value>
				</mostRecentByDrugIndicator>
				<!-- Indicates whether or not  prescription dispenses returned on a query should be limited to only the most recent dispense for a prescription order.
                      Allows for the returning of at most one prescription dispense record per a prescription.
                      The default is 'TRUE' indicating that retrieval should be for only the most recent dispense for a prescription is to be included in a query result. -->
				<mostRecentDispenseForEachRxIndicator>
					<value value="true">
					    <xsl:if test="$mostRecentDispenses">
					        <xsl:attribute name="value"><xsl:value-of select="$mostRecentDispenses"/></xsl:attribute>
					    </xsl:if>
					</value>
				</mostRecentDispenseForEachRxIndicator>                        
                        
                        <!-- required values to identify the patient -->
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
        </PORX_IN060230CA>
        
    </xsl:template>
    <xsl:template name="MedicalDispenseProfileSummaryResponse">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>
        <xsl:param name="query-id"/>
        <xsl:param name="query-status">OK</xsl:param>
        <xsl:param name="IssueList-description"/>

        <xsl:variable name="msgType">serverMsg</xsl:variable>
        <xsl:variable name="msgAction">queryResponse</xsl:variable>

        <xsl:variable name="patient_description">
            <xsl:call-template name="getPatientNameByID">
                <xsl:with-param name="node" select="descendant-or-self::hl7:controlActEvent/hl7:queryByParameter/hl7:parameterList/hl7:patientID/hl7:value"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][patient/@description = $patient_description]"/>

        <PORX_IN060240CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">PORX_IN060240CA</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>


            <controlActEvent>
                <xsl:call-template name="controlActStart">
                    <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                    <xsl:with-param name="TriggerEventCode">PORX_TE060070UV</xsl:with-param>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="msgAction" select="$msgAction"/>

                </xsl:call-template>

                <xsl:variable name="includeNotes" select="descendant-or-self::hl7:includeNotesIndicator/hl7:value/@value"/>
                <xsl:variable name="includeIssues" select="descendant-or-self::hl7:includeIssuesIndicator/hl7:value/@value"/>

                <!-- 0..999 elements that can either be a combinedMedicationRequest or an otherMedication -->
                <xsl:for-each select="$ProfileData/items/child::dispense">
                            <!-- <combinedMedicationRequest> -->
                            <subject>
                                <xsl:call-template name="DispenseSummary">
                                    <xsl:with-param name="description" select="@description"/>
                                    <xsl:with-param name="ProfileData" select="$ProfileData"/>
                                    <xsl:with-param name="msgType" select="$msgType"/>
                                    <xsl:with-param name="msgAction" select="$msgAction"/>
                                    <xsl:with-param name="notesIndicator" select="$includeNotes"/>
                                    <xsl:with-param name="IssueIndicator" select="$includeIssues"/>
                                </xsl:call-template>
                            </subject>
                </xsl:for-each>

                <!-- issues element to communicate any problems with the query - i.e. lack of access to a keyword protected profile - not DUR issues in this case -->
                <xsl:if test="$IssueList-description">
                    <xsl:call-template name="IssueList">
                        <xsl:with-param name="ProfileData" select="$ProfileData"/>
                        <xsl:with-param name="repeatingElementName">subjectOf</xsl:with-param>
                        <xsl:with-param name="IssueList-description" select="$IssueList-description"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                        <xsl:with-param name="msgAction" select="$msgAction"/>
                    </xsl:call-template>
                </xsl:if>

                <queryAck>
                    <xsl:choose>
                        <xsl:when test="descendant-or-self::queryByParameter/queryId">
                            <xsl:copy-of select="descendant-or-self::queryByParameter/queryId"/>
                        </xsl:when>
                        <xsl:when test="$query-id">
                            <queryId root="" extension="">
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

                    <queryResponseCode code="">
                        <xsl:attribute name="code">
                            <xsl:value-of select="$query-status"/>
                        </xsl:attribute>
                    </queryResponseCode>

                    <xsl:choose>
                        <xsl:when test="$ProfileData/items/@total">
                            <resultTotalQuantity value="">
                                <xsl:attribute name="value">
                                    <xsl:value-of select="$ProfileData/items/@total"/>
                                </xsl:attribute>
                            </resultTotalQuantity>
                            <resultCurrentQuantity value="">
                                <xsl:attribute name="value">
                                    <xsl:value-of select="$ProfileData/items/@current"/>
                                </xsl:attribute>
                            </resultCurrentQuantity>
                            <resultRemainingQuantity value="">
                                <xsl:attribute name="value">
                                    <xsl:value-of select="$ProfileData/items/@remaining"/>
                                </xsl:attribute>
                            </resultRemainingQuantity>
                        </xsl:when>
                        <xsl:otherwise>
                            <resultTotalQuantity value="">
                                <xsl:attribute name="value">
                                    <xsl:value-of select="count($ProfileData/items/prescription) + count($ProfileData/items/otherMedication)"/>
                                </xsl:attribute>
                            </resultTotalQuantity>
                            <resultCurrentQuantity value="">
                                <xsl:attribute name="value">
                                    <xsl:value-of select="count($ProfileData/items/prescription) + count($ProfileData/items/otherMedication)"/>
                                </xsl:attribute>
                            </resultCurrentQuantity>
                            <resultRemainingQuantity value="0"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </queryAck>

                <!-- Copy the requested queryByParameter Request -->
                <xsl:copy-of select="descendant-or-self::hl7:queryByParameter"/>

            </controlActEvent>

            <xsl:call-template name="transmissionWrapperEnd">
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </PORX_IN060240CA>
    </xsl:template>

    <xsl:template name="MedicalPrescriptionProfileDetailRequest">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>

        <xsl:param name="author-description"/>
        <xsl:param name="supervisor-description"/>
        <xsl:param name="location-description"/>
        <xsl:param name="ParticipationMode"/>
        <xsl:param name="author-time"/>
        <xsl:param name="query-id"/>

        <xsl:param name="record-id"/>
        <xsl:param name="eventEffectiveEndDate"/>
        <xsl:param name="eventEffectiveStartDate"/>
        <xsl:param name="historyIndicator"/>
        <xsl:param name="includePendingChanges"/>
        <xsl:param name="includeIssues"/>
        <xsl:param name="includeNotes"/>
                                    <xsl:param name="useOverRide" />

        
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

        
        <PORX_IN060250CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">PORX_IN060250CA</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <controlActEvent classCode="CACT" moodCode="EVN">
                <xsl:call-template name="controlActStart">
                    <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                    <xsl:with-param name="author-description" select="$author-description"/>
                    <xsl:with-param name="location-description" select="$location-description"/>
                    <xsl:with-param name="author-time" select="$author-time"/>
                    <xsl:with-param name="ParticipationMode" select="$ParticipationMode"/>
                    <xsl:with-param name="TriggerEventCode">PORX_TE060200UV</xsl:with-param>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="msgAction" select="$msgAction"/>
                </xsl:call-template>


                <!--
                    Indicates the consent or keyword used to authorize this access or update.
                    May also be used to override access to the information (“break the glass”) on a message by message basis
                -->
                <!-- consent event -->
                <xsl:call-template name="consentEvent">
                    <xsl:with-param name="ProfileData" select="$ProfileData"/>
                    <xsl:with-param name="SubjectOfElementName">subjectOf2</xsl:with-param>
                    <xsl:with-param name="author-description" select="$author-description"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="useOverRide" select="$useOverRide"/>
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

                        <!--Optional: Indicates that the returned records should be filtered to only include those which have been changed in some way 
                            (had status changed, been annotated, prescription was dispensed, etc.) within the indicated time-period.  
                            This will commonly be used to "retrieve everything that has been changed since xxx 
                        -->
                        <xsl:call-template name="DateQueryElement">
                            <xsl:with-param name="elementName">amendedInTimeRange</xsl:with-param>
                            <xsl:with-param name="endDate" select="$eventEffectiveEndDate"/>
                            <xsl:with-param name="startDate" select="$eventEffectiveStartDate"/>
                        </xsl:call-template>

                    	<!-- required element that indicates whether or not history of selected medication records are to be returned along with the detailed information. -->
                    	<includeEventHistoryIndicator>
                    		<value value="false">
                    		    <xsl:if test="$historyIndicator">
                    		        <xsl:attribute name="value"><xsl:value-of select="$historyIndicator"/></xsl:attribute>
                    		    </xsl:if>
                    		</value>
                    	</includeEventHistoryIndicator>                         
                        
                        <!-- Indicates whether or not Issues (detected and/or managed)  attached to the prescriptions, dispenses and other active medication records are to be returned along with the detailed information. -->
                        <includeIssuesIndicator>
                            <value value="false">
                                <xsl:if test="$includeIssues">
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="$includeIssues"/>
                                    </xsl:attribute>
                                </xsl:if>
                            </value>
                        </includeIssuesIndicator>

                        <!-- Indicates whether or not notes attached to the prescription, dispenses and other active medication records are to be returned along with the detailed information -->
                        <includeNotesIndicator>
                            <value value="false">
                                <xsl:if test="$includeNotes">
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="$includeNotes"/>
                                    </xsl:attribute>
                                </xsl:if>
                            </value>
                        </includeNotesIndicator>

				<!-- Indicates whether to include future changes (e.g. status changes that aren't effective yet)  associated with a prescription 
                      order and/or prescription dispense are to be returned along with the detailed information  -->
				<includePendingChangesIndicator>
                            <value value="false">
                                <xsl:if test="$includePendingChanges">
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="$includePendingChanges"/>
                                    </xsl:attribute>
                                </xsl:if>
                            </value>
				</includePendingChangesIndicator>                        
                        <!-- required values to identify the patient -->
                        <xsl:call-template name="PatientByDescription">
                            <xsl:with-param name="description" select="$patient_description"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="use_phn">true</xsl:with-param>
                            <xsl:with-param name="format">query</xsl:with-param>
                        </xsl:call-template>
                        
                        <!-- Identifies which  dispense record should be retrieved -->
                        <prescriptionOrderNumber>
                            <value>
                                <xsl:attribute name="root">
                                    <xsl:call-template name="getOIDRootByName">
                                        <xsl:with-param name="OID_Name">DIS_PRESCRIPTION_ID</xsl:with-param>
                                        <xsl:with-param name="msgType" select="$msgType"/>
                                    </xsl:call-template>
                                </xsl:attribute>
                                <xsl:attribute name="extension">
                                    <xsl:value-of select="$record-id"/>
                                </xsl:attribute>
                            </value>
                        </prescriptionOrderNumber>                        
                    </parameterList>
                </queryByParameter>

            </controlActEvent>

            <xsl:call-template name="transmissionWrapperEnd">
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </PORX_IN060250CA>
        
    </xsl:template>
    <xsl:template name="MedicalPrescriptionProfileFillsRequest">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>

        <xsl:param name="author-description"/>
        <xsl:param name="supervisor-description"/>
        <xsl:param name="location-description"/>
        <xsl:param name="ParticipationMode"/>
        <xsl:param name="author-time"/>
        <xsl:param name="query-id"/>
                            <xsl:param name="useOverRide" />

        <xsl:param name="record-id"/>
        <xsl:param name="issueFilterCode"/>
        
        
        
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

        
        <PORX_IN060270CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">PORX_IN060270CA</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <controlActEvent classCode="CACT" moodCode="EVN">
                <xsl:call-template name="controlActStart">
                    <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                    <xsl:with-param name="author-description" select="$author-description"/>
                    <xsl:with-param name="location-description" select="$location-description"/>
                    <xsl:with-param name="author-time" select="$author-time"/>
                    <xsl:with-param name="ParticipationMode" select="$ParticipationMode"/>
                    <xsl:with-param name="TriggerEventCode">PORX_TE060320UV</xsl:with-param>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="msgAction" select="$msgAction"/>
                </xsl:call-template>


                <!--
                    Indicates the consent or keyword used to authorize this access or update.
                    May also be used to override access to the information (“break the glass”) on a message by message basis
                -->
                <!-- consent event -->
                <xsl:call-template name="consentEvent">
                    <xsl:with-param name="ProfileData" select="$ProfileData"/>
                    <xsl:with-param name="SubjectOfElementName">subjectOf2</xsl:with-param>
                    <xsl:with-param name="author-description" select="$author-description"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                               <xsl:with-param name="useOverRide" select="$useOverRide"/>
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
                        <!-- Indicates whether records to be returned (e.g. prescription order, prescription dispense and/or other medication) should be filtered to those 
                            with at least one persistent un-managed issue (against the record), with at least one persistent issues or should return all records, independent of 
                            the presence of persistent issues. IssueFilterCode vocab: A - all,I - with issues, U - with unmanaged issues -->
                        <issueFilterCode>
                            <value code="">
                                <xsl:attribute name="code">
                                    <xsl:choose>
                                        <xsl:when test="$issueFilterCode">
                                            <xsl:value-of select="$issueFilterCode"/>
                                        </xsl:when>
                                        <xsl:otherwise>A</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:attribute>
                            </value>
                        </issueFilterCode>
                        
                        <!-- required values to identify the patient -->
                        <xsl:call-template name="PatientByDescription">
                            <xsl:with-param name="description" select="$patient_description"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="use_phn">true</xsl:with-param>
                            <xsl:with-param name="format">query</xsl:with-param>
                        </xsl:call-template>

                        <!-- required attribute to identify  the prescription for which detailed information is required. The result set will be filtered to only the specific prescription -->
                        <prescriptionOrderNumber>
                            <value>
                                <xsl:attribute name="root">
                                    <xsl:call-template name="getOIDRootByName">
                                        <xsl:with-param name="OID_Name">DIS_PRESCRIPTION_ID</xsl:with-param>
                                        <xsl:with-param name="msgType" select="$msgType"/>
                                    </xsl:call-template>
                                </xsl:attribute>
                                <xsl:attribute name="extension">
                                    <xsl:value-of select="$record-id"/>
                                </xsl:attribute>
                            </value>
                        </prescriptionOrderNumber>                        
                    </parameterList>
                    
                </queryByParameter>

            </controlActEvent>

            <xsl:call-template name="transmissionWrapperEnd">
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </PORX_IN060270CA>
        
    </xsl:template>
    <xsl:template name="MedicalPrescriptionProfileSummaryRequest">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>

        <xsl:param name="author-description"/>
        <xsl:param name="supervisor-description"/>
        <xsl:param name="location-description"/>
        <xsl:param name="ParticipationMode"/>
        <xsl:param name="author-time"/>
        <xsl:param name="query-id"/>

        <xsl:param name="administrationEffectiveStartDate"/>
        <xsl:param name="administrationEffectiveEndDate"/>
        <xsl:param name="eventEffectiveStartDate"/>
        <xsl:param name="eventEffectiveEndDate"/>
        <xsl:param name="mostRecentDrug"/>
        <xsl:param name="issueFilterCode"/>
        <xsl:param name="dispenseIndicator"/>
                            <xsl:param name="useOverRide"/>

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

        <PORX_IN060290CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">PORX_IN060290CA</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <controlActEvent classCode="CACT" moodCode="EVN">
                <xsl:call-template name="controlActStart">
                    <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                    <xsl:with-param name="author-description" select="$author-description"/>
                    <xsl:with-param name="location-description" select="$location-description"/>
                    <xsl:with-param name="author-time" select="$author-time"/>
                    <xsl:with-param name="ParticipationMode" select="$ParticipationMode"/>
                    <xsl:with-param name="TriggerEventCode">PORX_TE060460UV</xsl:with-param>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="msgAction" select="$msgAction"/>
                </xsl:call-template>


                <!--
                    Indicates the consent or keyword used to authorize this access or update.
                    May also be used to override access to the information (“break the glass”) on a message by message basis
                -->
                <!-- consent event -->
                <xsl:call-template name="consentEvent">
                    <xsl:with-param name="ProfileData" select="$ProfileData"/>
                    <xsl:with-param name="SubjectOfElementName">subjectOf2</xsl:with-param>
                    <xsl:with-param name="author-description" select="$author-description"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="useOverRide" select="$useOverRide"/>
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

                        <!--Optional: Indicates the administration period for which the request/query applies.
                            Filter the result set to include only those medication records (prescription order, prescription dispense and other active medication) 
                            for which the patient was deemed to be taking the drug within the specified period 
                        -->
                        <xsl:call-template name="DateQueryElement">
                            <xsl:with-param name="elementName">administrationEffectivePeriod</xsl:with-param>
                            <xsl:with-param name="endDate" select="$administrationEffectiveEndDate"/>
                            <xsl:with-param name="startDate" select="$administrationEffectiveStartDate"/>
                        </xsl:call-template>

                        <!-- Optional: Indicates that the returned records should be filtered to only include those which have been changed in some way (had status changed, been annotated, 
                            prescription was dispensed, etc.) within the indicated time-period.  This will commonly be used to 'retrieve everything that has been changed since xxx' -->
                        <xsl:call-template name="DateQueryElement">
                            <xsl:with-param name="elementName">amendedInTimeRange</xsl:with-param>
                            <xsl:with-param name="endDate" select="$eventEffectiveEndDate"/>
                            <xsl:with-param name="startDate" select="$eventEffectiveStartDate"/>
                        </xsl:call-template>

                        <!-- Indicates whether records to be returned (e.g. prescription order, prescription dispense and/or other medication) should be filtered to those 
                            with at least one persistent un-managed issue (against the record), with at least one persistent issues or should return all records, independent of 
                            the presence of persistent issues. IssueFilterCode vocab: A - all,I - with issues, U - with unmanaged issues -->
                        <issueFilterCode>
                            <value code="">
                                <xsl:attribute name="code">
                                    <xsl:choose>
                                        <xsl:when test="$issueFilterCode">
                                            <xsl:value-of select="$issueFilterCode"/>
                                        </xsl:when>
                                        <xsl:otherwise>A</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:attribute>
                            </value>
                        </issueFilterCode>

                        
                        <!-- Indicates whether or not the medication records are to be retrieved based on the most recent by Drug Code. 
                      If true, only the most recent prescription, dispense or other active medication for a particular drug generic classification will be returned.  
                      The default is 'FALSE' indicating that retrieval of prescription, dispense and other active medication records should not be limited to one per drug -->
                        <mostRecentByDrugIndicator>
                            <value value="false">
                                <xsl:if test="$mostRecentDrug"><xsl:attribute name="value"><xsl:value-of select="$mostRecentDrug"/></xsl:attribute></xsl:if>
                            </value>
                        </mostRecentByDrugIndicator>
                        
                        <!-- required values to identify the patient -->
                        <xsl:call-template name="PatientByDescription">
                            <xsl:with-param name="description" select="$patient_description"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="use_phn">true</xsl:with-param>
                            <xsl:with-param name="format">query</xsl:with-param>
                        </xsl:call-template>

				<!-- optional coded value indicating the dispensing (fill) status of the prescription to be included in the result set. 
                     The repetition of 3 allows for retrieval based on all three Rx Dispense Indicators
                     Rx Dispense Indicators include:  PrescriptionDispenseFilterCode vocab
                    N	never dispensed
					R	dispensed with remaining fills
					C	completely dispensed

				-->
                        <xsl:if test="$dispenseIndicator">
				<rxDispenseIndicator>
					<value code="N">
					    <xsl:attribute name="code"><xsl:value-of select="$dispenseIndicator"/></xsl:attribute>
					</value>
				</rxDispenseIndicator>
                            </xsl:if>

                    </parameterList>
                </queryByParameter>

            </controlActEvent>

            <xsl:call-template name="transmissionWrapperEnd">
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </PORX_IN060290CA>

    </xsl:template>
    <xsl:template name="MedicalPrescriptionProfileSummaryResponse">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>
        <xsl:param name="query-id"/>
        <xsl:param name="query-status">OK</xsl:param>
        <xsl:param name="IssueList-description"/>

        <xsl:variable name="msgType">serverMsg</xsl:variable>
        <xsl:variable name="msgAction">queryResponse</xsl:variable>

        <xsl:variable name="patient_description">
            <xsl:call-template name="getPatientNameByID">
                <xsl:with-param name="node" select="descendant-or-self::hl7:controlActEvent/hl7:queryByParameter/hl7:parameterList/hl7:patientID/hl7:value"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][patient/@description = $patient_description]"/>

        <PORX_IN060300CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">PORX_IN060300CA</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>


            <controlActEvent>
                <xsl:call-template name="controlActStart">
                    <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                    <xsl:with-param name="TriggerEventCode">PORX_TE060480UV</xsl:with-param>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="msgAction" select="$msgAction"/>

                </xsl:call-template>

                <xsl:variable name="includeNotes" select="descendant-or-self::hl7:includeNotesIndicator/hl7:value/@value"/>
                <xsl:variable name="includeIssues" select="descendant-or-self::hl7:includeIssuesIndicator/hl7:value/@value"/>

                <!-- 0..999 elements that can either be a combinedMedicationRequest or an otherMedication -->
                <xsl:for-each select="$ProfileData/items/child::prescription">
                            <!-- <combinedMedicationRequest> -->
                            <subject>
                                <xsl:call-template name="PrescriptionProfileSummary">
                                    <xsl:with-param name="description" select="@description"/>
                                    <xsl:with-param name="ProfileData" select="$ProfileData"/>
                                    <xsl:with-param name="msgType" select="$msgType"/>
                                    <xsl:with-param name="msgAction" select="$msgAction"/>
                                    <xsl:with-param name="notesIndicator" select="$includeNotes"/>
                                    <xsl:with-param name="IssueIndicator" select="$includeIssues"/>
                                </xsl:call-template>
                            </subject>
                </xsl:for-each>

                <!-- issues element to communicate any problems with the query - i.e. lack of access to a keyword protected profile - not DUR issues in this case -->
                <xsl:if test="$IssueList-description">
                    <xsl:call-template name="IssueList">
                        <xsl:with-param name="ProfileData" select="$ProfileData"/>
                        <xsl:with-param name="repeatingElementName">subjectOf</xsl:with-param>
                        <xsl:with-param name="IssueList-description" select="$IssueList-description"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                        <xsl:with-param name="msgAction" select="$msgAction"/>
                    </xsl:call-template>
                </xsl:if>

                <queryAck>
                    <xsl:choose>
                        <xsl:when test="descendant-or-self::queryByParameter/queryId">
                            <xsl:copy-of select="descendant-or-self::queryByParameter/queryId"/>
                        </xsl:when>
                        <xsl:when test="$query-id">
                            <queryId root="" extension="">
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

                    <queryResponseCode code="">
                        <xsl:attribute name="code">
                            <xsl:value-of select="$query-status"/>
                        </xsl:attribute>
                    </queryResponseCode>

                    <xsl:choose>
                        <xsl:when test="$ProfileData/items/@total">
                            <resultTotalQuantity value="">
                                <xsl:attribute name="value">
                                    <xsl:value-of select="$ProfileData/items/@total"/>
                                </xsl:attribute>
                            </resultTotalQuantity>
                            <resultCurrentQuantity value="">
                                <xsl:attribute name="value">
                                    <xsl:value-of select="$ProfileData/items/@current"/>
                                </xsl:attribute>
                            </resultCurrentQuantity>
                            <resultRemainingQuantity value="">
                                <xsl:attribute name="value">
                                    <xsl:value-of select="$ProfileData/items/@remaining"/>
                                </xsl:attribute>
                            </resultRemainingQuantity>
                        </xsl:when>
                        <xsl:otherwise>
                            <resultTotalQuantity value="">
                                <xsl:attribute name="value">
                                    <xsl:value-of select="count($ProfileData/items/prescription) + count($ProfileData/items/otherMedication)"/>
                                </xsl:attribute>
                            </resultTotalQuantity>
                            <resultCurrentQuantity value="">
                                <xsl:attribute name="value">
                                    <xsl:value-of select="count($ProfileData/items/prescription) + count($ProfileData/items/otherMedication)"/>
                                </xsl:attribute>
                            </resultCurrentQuantity>
                            <resultRemainingQuantity value="0"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </queryAck>

                <!-- Copy the requested queryByParameter Request -->
                <xsl:copy-of select="descendant-or-self::hl7:queryByParameter"/>

            </controlActEvent>

            <xsl:call-template name="transmissionWrapperEnd">
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </PORX_IN060300CA>
    </xsl:template>

    <xsl:template name="MedicalProfileSummaryRequest">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>

        <xsl:param name="author-description"/>
        <xsl:param name="supervisor-description"/>
        <xsl:param name="location-description"/>
        <xsl:param name="ParticipationMode"/>
        <xsl:param name="author-time"/>
        <xsl:param name="query-id"/>
        
        <xsl:param name="issueFilterCode"/>
        <xsl:param name="administrationEffectiveStartDate"/>
        <xsl:param name="administrationEffectiveEndDate"/>
        <xsl:param name="eventEffectiveStartDate"/>
        <xsl:param name="eventEffectiveEndDate"/>
        <xsl:param name="mostRecentDrugIndicator"/>
                            <xsl:param name="useOverRide"/>


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

        <PORX_IN060390CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">PORX_IN060390CA</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <controlActEvent classCode="CACT" moodCode="EVN">
                <xsl:call-template name="controlActStart">
                    <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                    <xsl:with-param name="author-description" select="$author-description"/>
                    <xsl:with-param name="location-description" select="$location-description"/>
                    <xsl:with-param name="author-time" select="$author-time"/>
                    <xsl:with-param name="ParticipationMode" select="$ParticipationMode"/>
                    <xsl:with-param name="TriggerEventCode">PORX_TE060300UV</xsl:with-param>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="msgAction" select="$msgAction"/>
                </xsl:call-template>


                <!--
                    Indicates the consent or keyword used to authorize this access or update.
                    May also be used to override access to the information (“break the glass”) on a message by message basis
                -->
                <!-- consent event -->
                <xsl:call-template name="consentEvent">
                    <xsl:with-param name="ProfileData" select="$ProfileData"/>
                    <xsl:with-param name="SubjectOfElementName">subjectOf2</xsl:with-param>
                    <xsl:with-param name="author-description" select="$author-description"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                              <xsl:with-param name="useOverRide" select="$useOverRide"/>
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
                        <!--Optional: Indicates the administration period for which the request/query applies.
                            Filter the result set to include only those medication records (prescription order, prescription dispense and other active medication) 
                            for which the patient was deemed to be taking the drug within the specified period 
                        -->
                        <xsl:call-template name="DateQueryElement">
                            <xsl:with-param name="elementName">administrationEffectivePeriod</xsl:with-param>
                            <xsl:with-param name="endDate" select="$administrationEffectiveEndDate"/>
                            <xsl:with-param name="startDate" select="$administrationEffectiveStartDate"/>
                        </xsl:call-template>

                        <!--Optional: Indicates that the returned records should be filtered to only include those which have been changed in some way 
                            (had status changed, been annotated, prescription was dispensed, etc.) within the indicated time-period.  
                            This will commonly be used to "retrieve everything that has been changed since xxx 
                        -->
                        <xsl:call-template name="DateQueryElement">
                            <xsl:with-param name="elementName">amendedInTimeRange</xsl:with-param>
                            <xsl:with-param name="endDate" select="$eventEffectiveEndDate"/>
                            <xsl:with-param name="startDate" select="$eventEffectiveStartDate"/>
                        </xsl:call-template>

                        <!-- Indicates whether records to be returned (e.g. prescription order, prescription dispense and/or other medication) should be filtered to those 
                            with at least one persistent un-managed issue (against the record), with at least one persistent issues or should return all records, independent of 
                            the presence of persistent issues. IssueFilterCode vocab: A - all,I - with issues, U - with unmanaged issues -->
                        <issueFilterCode>
                            <value code="">
                                <xsl:attribute name="code">
                                    <xsl:choose>
                                        <xsl:when test="$issueFilterCode">
                                            <xsl:value-of select="$issueFilterCode"/>
                                        </xsl:when>
                                        <xsl:otherwise>A</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:attribute>
                            </value>
                        </issueFilterCode>

                        <!-- Indicates whether or not the medication records are to be retrieved based on the most recent by Drug Code. 
                            If true, only the most recent  prescription, dispense or other active medication for a particular drug generic classification will be returned.  
                            The default is 'FALSE' indicating that retrieval of prescription, dispense and other active medication records should not be limited to one per drug -->
                        <mostRecentByDrugIndicator>
                            <value value="false">
                                <xsl:if test="$mostRecentDrugIndicator">
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="$mostRecentDrugIndicator"/>
                                    </xsl:attribute>
                                </xsl:if>
                            </value>
                        </mostRecentByDrugIndicator>


                        <!-- required values to identify the patient -->
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
        </PORX_IN060390CA>

    </xsl:template>
    <xsl:template name="OtherMedicationProfileDetailRequest">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>

        <xsl:param name="author-description"/>
        <xsl:param name="supervisor-description"/>
        <xsl:param name="location-description"/>
        <xsl:param name="ParticipationMode"/>
        <xsl:param name="author-time"/>
        <xsl:param name="query-id"/>

        <xsl:param name="administrationEffectiveStartDate"/>
        <xsl:param name="administrationEffectiveEndDate"/>
        <xsl:param name="eventEffectiveStartDate"/>
        <xsl:param name="eventEffectiveEndDate"/>
        <xsl:param name="includeNotes"/>
        <xsl:param name="includeIssues"/>
        <xsl:param name="issueFilterCode"/>
        <xsl:param name="record-id"/>

                                    <xsl:param name="useOverRide"/>

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

        <PORX_IN060450CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">PORX_IN060450CA</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <controlActEvent classCode="CACT" moodCode="EVN">
                <xsl:call-template name="controlActStart">
                    <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                    <xsl:with-param name="author-description" select="$author-description"/>
                    <xsl:with-param name="location-description" select="$location-description"/>
                    <xsl:with-param name="author-time" select="$author-time"/>
                    <xsl:with-param name="ParticipationMode" select="$ParticipationMode"/>
                    <xsl:with-param name="TriggerEventCode">PORX_TE060440UV</xsl:with-param>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="msgAction" select="$msgAction"/>
                </xsl:call-template>


                <!--
                    Indicates the consent or keyword used to authorize this access or update.
                    May also be used to override access to the information (“break the glass”) on a message by message basis
                -->
                <!-- consent event -->
                <xsl:call-template name="consentEvent">
                    <xsl:with-param name="ProfileData" select="$ProfileData"/>
                    <xsl:with-param name="SubjectOfElementName">subjectOf2</xsl:with-param>
                    <xsl:with-param name="author-description" select="$author-description"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                                <xsl:with-param name="useOverRide" select="$useOverRide"/>
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

                        <!--Optional: Indicates the administration period for which the request/query applies.
                            Filter the result set to include only those medication records (prescription order, prescription dispense and other active medication) 
                            for which the patient was deemed to be taking the drug within the specified period 
                        -->
                        <xsl:call-template name="DateQueryElement">
                            <xsl:with-param name="elementName">administrationEffectivePeriod</xsl:with-param>
                            <xsl:with-param name="endDate" select="$administrationEffectiveEndDate"/>
                            <xsl:with-param name="startDate" select="$administrationEffectiveStartDate"/>
                        </xsl:call-template>

                        <!-- Optional: Indicates that the returned records should be filtered to only include those which have been changed in some way (had status changed, been annotated, 
                            prescription was dispensed, etc.) within the indicated time-period.  This will commonly be used to 'retrieve everything that has been changed since xxx' -->
                        <xsl:call-template name="DateQueryElement">
                            <xsl:with-param name="elementName">amendedInTimeRange</xsl:with-param>
                            <xsl:with-param name="endDate" select="$eventEffectiveEndDate"/>
                            <xsl:with-param name="startDate" select="$eventEffectiveStartDate"/>
                        </xsl:call-template>

                        <!-- Indicates whether or not Issues (detected and/or managed)  attached to the prescriptions, dispenses and other active medication records are to be returned along with the detailed information. -->
                        <includeIssuesIndicator>
                            <value value="false">
                                <xsl:if test="$includeIssues">
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="$includeIssues"/>
                                    </xsl:attribute>
                                </xsl:if>
                            </value>
                        </includeIssuesIndicator>

                        <!-- Indicates whether or not notes attached to the prescription, dispenses and other active medication records are to be returned along with the detailed information -->
                        <includeNotesIndicator>
                            <value value="false">
                                <xsl:if test="$includeNotes">
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="$includeNotes"/>
                                    </xsl:attribute>
                                </xsl:if>
                            </value>
                        </includeNotesIndicator>
                        
                        <!-- Indicates whether records to be returned (e.g. prescription order, prescription dispense and/or other medication) should be filtered to those 
                            with at least one persistent un-managed issue (against the record), with at least one persistent issues or should return all records, independent of 
                            the presence of persistent issues. IssueFilterCode vocab: A - all,I - with issues, U - with unmanaged issues -->
                        <issueFilterCode>
                            <value code="">
                                <xsl:attribute name="code">
                                    <xsl:choose>
                                        <xsl:when test="$issueFilterCode">
                                            <xsl:value-of select="$issueFilterCode"/>
                                        </xsl:when>
                                        <xsl:otherwise>A</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:attribute>
                            </value>
                        </issueFilterCode>
                        
				<!--optionale identifier of the other medication record for which detailed information is to be retrieved -->
                        <xsl:if test="$record-id">
                            <otherMedicationRecordId>
                                <value root="2.16.124.9.101.1.1.9" extension="1111111">
                                <xsl:attribute name="root">
                                    <xsl:call-template name="getOIDRootByName">
                                        <xsl:with-param name="OID_Name">DIS_OTHER_ACTIVE_MED_ID</xsl:with-param>
                                        <xsl:with-param name="msgType" select="$msgType"/>
                                    </xsl:call-template>
                                </xsl:attribute>
                                <xsl:attribute name="extension">
                                    <xsl:value-of select="$record-id"/>
                                </xsl:attribute>
                                </value>
                            </otherMedicationRecordId>
                        </xsl:if>
                        
                        <!-- required values to identify the patient -->
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
        </PORX_IN060450CA>

    </xsl:template>
    <xsl:template name="OtherMedicationProfileSummaryResponse">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>
        <xsl:param name="query-id"/>
        <xsl:param name="query-status">OK</xsl:param>
        <xsl:param name="IssueList-description"/>

        <xsl:variable name="msgType">serverMsg</xsl:variable>
        <xsl:variable name="msgAction">queryResponse</xsl:variable>

        <xsl:variable name="patient_description">
            <xsl:call-template name="getPatientNameByID">
                <xsl:with-param name="node" select="descendant-or-self::hl7:controlActEvent/hl7:queryByParameter/hl7:parameterList/hl7:patientID/hl7:value"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][patient/@description = $patient_description]"/>

        <PORX_IN060460CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">PORX_IN060460CA</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>


            <controlActEvent>
                <xsl:call-template name="controlActStart">
                    <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                    <xsl:with-param name="TriggerEventCode">PORX_TE060450UV</xsl:with-param>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="msgAction" select="$msgAction"/>

                </xsl:call-template>

                <xsl:variable name="includeNotes" select="descendant-or-self::hl7:includeNotesIndicator/hl7:value/@value"/>
                <xsl:variable name="includeIssues" select="descendant-or-self::hl7:includeIssuesIndicator/hl7:value/@value"/>

                <!-- 0..999 elements that can either be a combinedMedicationRequest or an otherMedication -->
                <xsl:for-each select="$ProfileData/items/child::otherMedication">
                            <!-- <combinedMedicationRequest> -->
                            <subject>
                                <xsl:call-template name="otherMedication">
                                    <xsl:with-param name="description" select="@description"/>
                                    <xsl:with-param name="ProfileData" select="$ProfileData"/>
                                    <xsl:with-param name="msgType" select="$msgType"/>
                                    <xsl:with-param name="msgAction" select="$msgAction"/>
                                    <xsl:with-param name="notesIndicator" select="$includeNotes"/>
                                    <xsl:with-param name="IssueIndicator" select="$includeIssues"/>
                                </xsl:call-template>
                            </subject>
                </xsl:for-each>

                <!-- issues element to communicate any problems with the query - i.e. lack of access to a keyword protected profile - not DUR issues in this case -->
                <xsl:if test="$IssueList-description">
                    <xsl:call-template name="IssueList">
                        <xsl:with-param name="ProfileData" select="$ProfileData"/>
                        <xsl:with-param name="repeatingElementName">subjectOf</xsl:with-param>
                        <xsl:with-param name="IssueList-description" select="$IssueList-description"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                        <xsl:with-param name="msgAction" select="$msgAction"/>
                    </xsl:call-template>
                </xsl:if>

                <queryAck>
                    <xsl:choose>
                        <xsl:when test="descendant-or-self::queryByParameter/queryId">
                            <xsl:copy-of select="descendant-or-self::queryByParameter/queryId"/>
                        </xsl:when>
                        <xsl:when test="$query-id">
                            <queryId root="" extension="">
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

                    <queryResponseCode code="">
                        <xsl:attribute name="code">
                            <xsl:value-of select="$query-status"/>
                        </xsl:attribute>
                    </queryResponseCode>

                    <xsl:choose>
                        <xsl:when test="$ProfileData/items/@total">
                            <resultTotalQuantity value="">
                                <xsl:attribute name="value">
                                    <xsl:value-of select="$ProfileData/items/@total"/>
                                </xsl:attribute>
                            </resultTotalQuantity>
                            <resultCurrentQuantity value="">
                                <xsl:attribute name="value">
                                    <xsl:value-of select="$ProfileData/items/@current"/>
                                </xsl:attribute>
                            </resultCurrentQuantity>
                            <resultRemainingQuantity value="">
                                <xsl:attribute name="value">
                                    <xsl:value-of select="$ProfileData/items/@remaining"/>
                                </xsl:attribute>
                            </resultRemainingQuantity>
                        </xsl:when>
                        <xsl:otherwise>
                            <resultTotalQuantity value="">
                                <xsl:attribute name="value">
                                    <xsl:value-of select="count($ProfileData/items/prescription) + count($ProfileData/items/otherMedication)"/>
                                </xsl:attribute>
                            </resultTotalQuantity>
                            <resultCurrentQuantity value="">
                                <xsl:attribute name="value">
                                    <xsl:value-of select="count($ProfileData/items/prescription) + count($ProfileData/items/otherMedication)"/>
                                </xsl:attribute>
                            </resultCurrentQuantity>
                            <resultRemainingQuantity value="0"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </queryAck>

                <!-- Copy the requested queryByParameter Request -->
                <xsl:copy-of select="descendant-or-self::hl7:queryByParameter"/>

            </controlActEvent>

            <xsl:call-template name="transmissionWrapperEnd">
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </PORX_IN060460CA>
    </xsl:template>

    <xsl:template name="UnfilledPrescriptionByProviderProfileRequest">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>

        <xsl:param name="author-description"/>
        <xsl:param name="supervisor-description"/>
        <xsl:param name="location-description"/>
        <xsl:param name="ParticipationMode"/>
        <xsl:param name="author-time"/>
        <xsl:param name="query-id"/>

        <xsl:param name="administrationEffectiveStartDate"/>
        <xsl:param name="administrationEffectiveEndDate"/>
        <xsl:param name="prescriber-description"/>
                            <xsl:param name="useOverRide" />

        
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

        <PORX_IN060470CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">PORX_IN060470CA</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <controlActEvent classCode="CACT" moodCode="EVN">
                <xsl:call-template name="controlActStart">
                    <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                    <xsl:with-param name="author-description" select="$author-description"/>
                    <xsl:with-param name="location-description" select="$location-description"/>
                    <xsl:with-param name="author-time" select="$author-time"/>
                    <xsl:with-param name="ParticipationMode" select="$ParticipationMode"/>
                    <xsl:with-param name="TriggerEventCode">PORX_TE060510UV</xsl:with-param>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="msgAction" select="$msgAction"/>
                </xsl:call-template>


                <!--
                    Indicates the consent or keyword used to authorize this access or update.
                    May also be used to override access to the information (“break the glass”) on a message by message basis
                -->
                <!-- consent event -->
                <xsl:call-template name="consentEvent">
                    <xsl:with-param name="ProfileData" select="$ProfileData"/>
                    <xsl:with-param name="SubjectOfElementName">subjectOf2</xsl:with-param>
                    <xsl:with-param name="author-description" select="$author-description"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                                <xsl:with-param name="useOverRide" select="$useOverRide"/>
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

                        <!--Optional: Indicates the administration period for which the request/query applies.
                            Filter the result set to include only those medication records (prescription order, prescription dispense and other active medication) 
                            for which the patient was deemed to be taking the drug within the specified period 
                        -->
                        <xsl:call-template name="DateQueryElement">
                            <xsl:with-param name="elementName">administrationEffectivePeriod</xsl:with-param>
                            <xsl:with-param name="endDate" select="$administrationEffectiveEndDate"/>
                            <xsl:with-param name="startDate" select="$administrationEffectiveStartDate"/>
                        </xsl:call-template>

                        <!-- required values to identify the patient -->
                        <xsl:call-template name="PatientByDescription">
                            <xsl:with-param name="description" select="$patient_description"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="use_phn">true</xsl:with-param>
                            <xsl:with-param name="format">query</xsl:with-param>
                        </xsl:call-template>
                        
                        <prescriberProviderID>
                            <value>
                                <xsl:call-template name="ProviderByDescription">
                                    <xsl:with-param name="description" select="$prescriber-description"/>
                                    <xsl:with-param name="msgType" select="$msgType"/>
                                    <xsl:with-param name="format">ID-ONLY</xsl:with-param>
                                </xsl:call-template>
                            </value>
                        </prescriberProviderID>                        
                    </parameterList>
                </queryByParameter>

            </controlActEvent>

            <xsl:call-template name="transmissionWrapperEnd">
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </PORX_IN060470CA>

    </xsl:template>
    <xsl:template name="UnfilledPrescriptionProfileRequest">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>

        <xsl:param name="author-description"/>
        <xsl:param name="supervisor-description"/>
        <xsl:param name="location-description"/>
        <xsl:param name="ParticipationMode"/>
        <xsl:param name="author-time"/>
        <xsl:param name="query-id"/>

        <xsl:param name="administrationEffectiveStartDate"/>
        <xsl:param name="administrationEffectiveEndDate"/>
        <xsl:param name="status-1"/>
        <xsl:param name="status-2"/>
        <xsl:param name="status-3"/>

                            <xsl:param name="useOverRide"/>
        
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

        <PORX_IN060490CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">PORX_IN060490CA</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <controlActEvent classCode="CACT" moodCode="EVN">
                <xsl:call-template name="controlActStart">
                    <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                    <xsl:with-param name="author-description" select="$author-description"/>
                    <xsl:with-param name="location-description" select="$location-description"/>
                    <xsl:with-param name="author-time" select="$author-time"/>
                    <xsl:with-param name="ParticipationMode" select="$ParticipationMode"/>
                    <xsl:with-param name="TriggerEventCode">PORX_TE060520UV</xsl:with-param>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="msgAction" select="$msgAction"/>
                </xsl:call-template>


                <!--
                    Indicates the consent or keyword used to authorize this access or update.
                    May also be used to override access to the information (“break the glass”) on a message by message basis
                -->
                <!-- consent event -->
                <xsl:call-template name="consentEvent">
                    <xsl:with-param name="ProfileData" select="$ProfileData"/>
                    <xsl:with-param name="SubjectOfElementName">subjectOf2</xsl:with-param>
                    <xsl:with-param name="author-description" select="$author-description"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                             <xsl:with-param name="useOverRide" select="$useOverRide"/>
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

                        <!--Optional: Indicates the administration period for which the request/query applies.
                            Filter the result set to include only those medication records (prescription order, prescription dispense and other active medication) 
                            for which the patient was deemed to be taking the drug within the specified period 
                        -->
                        <xsl:call-template name="DateQueryElement">
                            <xsl:with-param name="elementName">administrationEffectivePeriod</xsl:with-param>
                            <xsl:with-param name="endDate" select="$administrationEffectiveEndDate"/>
                            <xsl:with-param name="startDate" select="$administrationEffectiveStartDate"/>
                        </xsl:call-template>

                        <!-- required values to identify the patient -->
                        <xsl:call-template name="PatientByDescription">
                            <xsl:with-param name="description" select="$patient_description"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="use_phn">true</xsl:with-param>
                            <xsl:with-param name="format">query</xsl:with-param>
                        </xsl:call-template>
                        
	<!-- 0..3 elements to indicate that prescriptions of a specific statuses are to be included in the result set. 
                     Allowable prescription status codes are: 'ABORTED, ACTIVE', 'COMPLETED', and 'SUSPENDED'
	-->
                        <xsl:if test="$status-1">
                            <prescriptionStatus>
                                <value code="completed">
                                    <xsl:attribute name="code"><xsl:value-of select="$status-1"/></xsl:attribute>
                                </value>
                            </prescriptionStatus>
                        </xsl:if>
                        <xsl:if test="$status-2">
                            <prescriptionStatus>
                                <value code="completed">
                                    <xsl:attribute name="code"><xsl:value-of select="$status-2"/></xsl:attribute>
                                </value>
                            </prescriptionStatus>
                        </xsl:if>
                        <xsl:if test="$status-3">
                            <prescriptionStatus>
                                <value code="completed">
                                    <xsl:attribute name="code"><xsl:value-of select="$status-3"/></xsl:attribute>
                                </value>
                            </prescriptionStatus>
                        </xsl:if>
                    </parameterList>
                </queryByParameter>

            </controlActEvent>

            <xsl:call-template name="transmissionWrapperEnd">
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </PORX_IN060490CA>

    </xsl:template>
    

</xsl:stylesheet>
