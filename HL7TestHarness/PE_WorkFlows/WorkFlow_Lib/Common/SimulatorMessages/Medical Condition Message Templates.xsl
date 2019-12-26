<?xml version="1.0" encoding="UTF-8"?>
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="urn:hl7-org:v3" xmlns:hl7="urn:hl7-org:v3" version="1.0">
    <xsl:include href="../Lib/MsgCreation_Lib.xsl"/>

    <!-- Query Messages -->
    <xsl:template name="medicalConditionQueryResponse">
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

        <REPC_IN000024CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">

            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">REPC_IN000024CA</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <controlActEvent>
                <xsl:call-template name="controlActStart">
                    <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                    <xsl:with-param name="TriggerEventCode">REPC_TE000013UV</xsl:with-param>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="msgAction" select="$msgAction"/>
                </xsl:call-template>

                <xsl:variable name="includeNotes" select="descendant-or-self::hl7:includeNotesIndicator/hl7:value/@value"/>
                <xsl:variable name="includeIssues" select="descendant-or-self::hl7:includeIssuesIndicator/hl7:value/@value"/>

                <xsl:for-each select="$ProfileData/items/condition">
                    <subject contextConductionInd="false">
                        <xsl:call-template name="MedicalCondition">
                            <xsl:with-param name="description" select="@description"/>
                            <xsl:with-param name="ProfileData" select="$ProfileData"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="msgAction" select="$msgAction"/>
                            <xsl:with-param name="notesIndicator" select="$includeNotes"/>
                        </xsl:call-template>
                    </subject>
                </xsl:for-each>


                <xsl:if test="$IssueList-description">
                    <xsl:call-template name="IssueList">
                        <xsl:with-param name="ProfileData" select="$ProfileData"/>
                        <xsl:with-param name="repeatingElementName">subjectOf</xsl:with-param>
                        <xsl:with-param name="IssueList-description" select="$IssueList-description"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
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
                                    <xsl:value-of select="count($ProfileData/items/condition)"/>
                                </xsl:attribute>
                            </resultTotalQuantity>
                            <resultCurrentQuantity value="">
                                <xsl:attribute name="value">
                                    <xsl:value-of select="count($ProfileData/items/condition)"/>
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

        </REPC_IN000024CA>
    </xsl:template>

    <!-- TODO: need to add author, location, consent, etc. -->
    <xsl:template name="medicalConditionQueryRequest">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>

        <xsl:param name="author-description"/>
        <xsl:param name="supervisor-description"/>
        <xsl:param name="location-description"/>
        <xsl:param name="ParticipationMode"/>
        <xsl:param name="author-time"/>

        <xsl:param name="medicalConditionStatus"/>
        <xsl:param name="medicalConditionStartDate"/>
        <xsl:param name="medicalConditionEndDate"/>
        <xsl:param name="includeIssues"/>
        <xsl:param name="includeNotes"/>
        <xsl:param name="query-id"/>
        <xsl:param name="IssueList-description"/>
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


        <REPC_IN000023CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">REPC_IN000023CA</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <controlActEvent classCode="CACT" moodCode="EVN">
                <xsl:call-template name="controlActStart">
                    <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                    <xsl:with-param name="author-description" select="$author-description"/>
                    <xsl:with-param name="location-description" select="$location-description"/>
                    <xsl:with-param name="author-time" select="$author-time"/>
                    <xsl:with-param name="ParticipationMode" select="$ParticipationMode"/>
                    <xsl:with-param name="TriggerEventCode">REPC_TE000012UV</xsl:with-param>
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

                        <!-- required to indicate whether or not to include issues and notes: suggest that we always treat these as false and only return an indicator: we'll return the notes and issues 
                            on the history message.
                        -->

                        <includeIssuesIndicator>
                            <xsl:choose>
                                <xsl:when test="$includeIssues='true'">
                                    <value value="true"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <value value="false"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </includeIssuesIndicator>
                        <includeNotesIndicator>
                            <xsl:choose>
                                <xsl:when test="$includeNotes='true'">
                                    <value value="true"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <value value="false"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </includeNotesIndicator>

                        <!-- optionally filters the query response to only include medical conditions which have been created or modified within the date-range specified -->
                        <xsl:if test="$medicalConditionStartDate or $medicalConditionEndDate">
                            <medicalConditionChangePeriod>
                                <value>
                                    <low>
                                        <xsl:choose>
                                            <xsl:when test="$medicalConditionStartDate">
                                                <xsl:attribute name="value">
                                                    <xsl:value-of select="$medicalConditionStartDate"/>
                                                </xsl:attribute>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:call-template name="nullFlavor"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </low>
                                    <high>
                                        <xsl:choose>
                                            <xsl:when test="$medicalConditionEndDate">
                                                <xsl:attribute name="value">
                                                    <xsl:value-of select="$medicalConditionEndDate"/>
                                                </xsl:attribute>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:call-template name="nullFlavor"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </high>
                                </value>
                            </medicalConditionChangePeriod>
                        </xsl:if>

                        <!-- Indicates that the result set should be filtered to included only those medical condition records for the specified status.</mif:p>
                            Valid statuses include: ACTIVE or COMPLETE -->
                        <xsl:if test="$medicalConditionStatus">
                            <medicalConditionStatus>
                                <value code="">
                                    <xsl:attribute name="code">
                                        <xsl:value-of select="$medicalConditionStatus"/>
                                    </xsl:attribute>
                                </value>
                            </medicalConditionStatus>
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

        </REPC_IN000023CA>

    </xsl:template>

    <xsl:template name="medicalConditionHistoryQueryRequest">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>

        <xsl:param name="author-description"/>
        <xsl:param name="supervisor-description"/>
        <xsl:param name="location-description"/>
        <xsl:param name="ParticipationMode"/>
        <xsl:param name="author-time"/>

        <xsl:param name="medicalConditionStartDate"/>
        <xsl:param name="medicalConditionEndDate"/>
        <xsl:param name="query-id"/>
        <xsl:param name="record-id"/>

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


        <REPC_IN000025CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">REPC_IN000025CA</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <controlActEvent classCode="CACT" moodCode="EVN">
                <xsl:call-template name="controlActStart">
                    <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                    <xsl:with-param name="author-description" select="$author-description"/>
                    <xsl:with-param name="location-description" select="$location-description"/>
                    <xsl:with-param name="author-time" select="$author-time"/>
                    <xsl:with-param name="ParticipationMode" select="$ParticipationMode"/>
                    <xsl:with-param name="TriggerEventCode">REPC_TE000010UV</xsl:with-param>
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

	    <!-- Indicates that the returned records should be filtered to only include those which have been changed in some way (had status changed, been annotated, etc.) 
	        within the indicated time-period. This will commonly be used to "retrieve everything that has been changed since xxx" -->
                        <xsl:if test="$medicalConditionStartDate or $medicalConditionEndDate">
                            <amendedInTimeRange>
                                <value>
                                    <low>
                                        <xsl:choose>
                                            <xsl:when test="$medicalConditionStartDate">
                                                <xsl:attribute name="value">
                                                    <xsl:value-of select="$medicalConditionStartDate"/>
                                                </xsl:attribute>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:call-template name="nullFlavor"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </low>
                                    <high>
                                        <xsl:choose>
                                            <xsl:when test="$medicalConditionEndDate">
                                                <xsl:attribute name="value">
                                                    <xsl:value-of select="$medicalConditionEndDate"/>
                                                </xsl:attribute>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:call-template name="nullFlavor"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </high>
                                </value>
                            </amendedInTimeRange>
                        </xsl:if>                        
                 <!-- identifier for the medical condition -->
                        <conditionID>
                            <value>
                                <xsl:attribute name="root">
                                    <xsl:call-template name="getOIDRootByName">
                                        <xsl:with-param name="OID_Name">DIS_MEDICAL_CONDITION_ID</xsl:with-param>
                                        <xsl:with-param name="msgType" select="$msgType"/>
                                    </xsl:call-template>
                                </xsl:attribute>
                                <xsl:attribute name="extension">
                                    <xsl:value-of select="$record-id"/>
                                </xsl:attribute>
                            </value>
                        </conditionID>

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

        </REPC_IN000025CA>

    </xsl:template>
    
    
    <!-- Add Messages -->
    <xsl:template name="medicalConditionAddRequest">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>

        <xsl:param name="condition-description"/>
        <xsl:param name="IssueList-description"/>

        <xsl:variable name="msgType">clientMsg</xsl:variable>
        <xsl:variable name="msgAction">addRequest</xsl:variable>

        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][not($patient-description) or patient/@description = $patient-description]"/>
        <xsl:variable name="ConditionData" select="$ProfileData/items/condition[@description=$condition-description]"/>

        <REPC_IN000028CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">REPC_IN000028CA</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <controlActEvent classCode="CACT" moodCode="EVN">
                <xsl:call-template name="controlActStart">
                    <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                    <xsl:with-param name="supervisor-description" select="$ConditionData/supervisor/@description"/>
                    <xsl:with-param name="author-description" select="$ConditionData/author/@description"/>
                    <xsl:with-param name="location-description" select="$ConditionData/location/@description"/>
                    <xsl:with-param name="author-time" select="$ConditionData/author/@time"/>
                    <xsl:with-param name="ParticipationMode" select="$ConditionData/author/@ParticipationMode"/>
                    <xsl:with-param name="TriggerEventCode">REPC_TE000017UV</xsl:with-param>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="msgAction" select="$msgAction"/>
                </xsl:call-template>

                <subject contextConductionInd="false">
                    <xsl:call-template name="MedicalCondition">
                        <xsl:with-param name="description" select="$condition-description"/>
                        <xsl:with-param name="ProfileData" select="$ProfileData"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                        <xsl:with-param name="msgAction" select="$msgAction"/>
                    </xsl:call-template>
                </subject>

                <xsl:call-template name="IssueList">
                    <xsl:with-param name="IssueList-description" select="$IssueList-description"/>
                    <xsl:with-param name="repeatingElementName">subjectOf1</xsl:with-param>
                    <xsl:with-param name="ProfileData" select="$ProfileData"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                </xsl:call-template>

                <!-- consent event -->
                <xsl:call-template name="consentEvent">
                    <xsl:with-param name="ProfileData" select="$ProfileData"/>
                    <xsl:with-param name="SubjectOfElementName">subjectOf2</xsl:with-param>
                    <xsl:with-param name="author-description" select="$ConditionData/author/@description"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                </xsl:call-template>

            </controlActEvent>

            <xsl:call-template name="transmissionWrapperEnd">
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

        </REPC_IN000028CA>

    </xsl:template>
    <xsl:template name="medicalConditionAddAcceptedResponse">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>
        <xsl:param name="condition-description"/>
        <xsl:param name="IssueList-description"/>

        <xsl:variable name="msgType">serverMsg</xsl:variable>
        <xsl:variable name="msgAction">addResponse</xsl:variable>

        <xsl:variable name="patient_description">
            <xsl:call-template name="getPatientNameByID">
                <xsl:with-param name="node" select="descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:*/hl7:subject/hl7:patient/hl7:id"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][patient/@description = $patient_description]"/>

        <xsl:variable name="description">
            <xsl:choose>
                <xsl:when test="$condition-description and not($condition-description = '')">
                    <xsl:value-of select="$condition-description"/>
                </xsl:when>
                <xsl:otherwise>Condition(NEW_ITEM)</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>


        <REPC_IN000029CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="AcceptMessage">
                <xsl:with-param name="ProfileData" select="$ProfileData"/>
                <xsl:with-param name="record-id" select="$ProfileData/items/condition[@description=$description]/record-id"/>
                <xsl:with-param name="interactionId">REPC_IN000029CA</xsl:with-param>
                <xsl:with-param name="TriggerEventCode">REPC_TE000018UV</xsl:with-param>
                <xsl:with-param name="IssueList-description" select="$IssueList-description"/>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </REPC_IN000029CA>
    </xsl:template>
    <xsl:template name="medicalConditionAddRejectedResponse">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>
        <xsl:param name="IssueList-description"/>

        <xsl:variable name="msgType">serverMsg</xsl:variable>
        <xsl:variable name="msgAction">addResponse</xsl:variable>

        <xsl:variable name="patient_description">
            <xsl:call-template name="getPatientNameByID">
                <xsl:with-param name="node" select="descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:*/hl7:subject/hl7:patient/hl7:id"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][patient/@description = $patient_description]"/>

        <REPC_IN000030CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="RejectMessage">
                <xsl:with-param name="ProfileData" select="$ProfileData"/>
                <xsl:with-param name="interactionId">REPC_IN000030CA</xsl:with-param>
                <xsl:with-param name="TriggerEventCode">REPC_TE000019UV</xsl:with-param>
                <xsl:with-param name="IssueList-description" select="$IssueList-description"/>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </REPC_IN000030CA>
    </xsl:template>

    <!-- Update Messages -->
    <xsl:template name="medicalConditionUpdateRequest">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>

        <xsl:param name="condition-description"/>
        <xsl:param name="IssueList-description"/>

        <xsl:variable name="msgType">clientMsg</xsl:variable>
        <xsl:variable name="msgAction">updateRequest</xsl:variable>

        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][not($patient-description) or patient/@description = $patient-description]"/>
        <xsl:variable name="ConditionData" select="$ProfileData/items/condition[@description=$condition-description]"/>

        <REPC_IN000032CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">REPC_IN000032CA</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <controlActEvent classCode="CACT" moodCode="EVN">
                <xsl:call-template name="controlActStart">
                    <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                    <xsl:with-param name="supervisor-description" select="$ConditionData/supervisor/@description"/>
                    <xsl:with-param name="author-description" select="$ConditionData/author/@description"/>
                    <xsl:with-param name="location-description" select="$ConditionData/location/@description"/>
                    <xsl:with-param name="author-time" select="$ConditionData/author/@time"/>
                    <xsl:with-param name="ParticipationMode" select="$ConditionData/author/@ParticipationMode"/>
                    <xsl:with-param name="TriggerEventCode">REPC_TE000026UV</xsl:with-param>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="msgAction" select="$msgAction"/>
                </xsl:call-template>

                <subject contextConductionInd="false">
                    <xsl:call-template name="MedicalCondition">
                        <xsl:with-param name="description" select="$condition-description"/>
                        <xsl:with-param name="ProfileData" select="$ProfileData"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                        <xsl:with-param name="msgAction" select="$msgAction"/>
                    </xsl:call-template>
                </subject>

                <xsl:call-template name="IssueList">
                    <xsl:with-param name="IssueList-description" select="$IssueList-description"/>
                    <xsl:with-param name="repeatingElementName">subjectOf1</xsl:with-param>
                    <xsl:with-param name="ProfileData" select="$ProfileData"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                </xsl:call-template>

                <!-- consent event -->
                <xsl:call-template name="consentEvent">
                    <xsl:with-param name="ProfileData" select="$ProfileData"/>
                    <xsl:with-param name="SubjectOfElementName">subjectOf2</xsl:with-param>
                    <xsl:with-param name="author-description" select="$ConditionData/author/@description"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                </xsl:call-template>

            </controlActEvent>

            <xsl:call-template name="transmissionWrapperEnd">
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </REPC_IN000032CA>
    </xsl:template>
    <xsl:template name="medicalConditionUpdateAcceptedResponse">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>
        <xsl:param name="condition-description"/>
        <xsl:param name="IssueList-description"/>

        <xsl:variable name="msgType">serverMsg</xsl:variable>
        <xsl:variable name="msgAction">updateResponse</xsl:variable>

        <xsl:variable name="patient_description">
            <xsl:call-template name="getPatientNameByID">
                <xsl:with-param name="node" select="descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:*/hl7:subject/hl7:patient/hl7:id"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][patient/@description = $patient_description]"/>

        <xsl:variable name="id" select="descendant-or-self::hl7:medicalCondition/hl7:id/@extension"/>
        <xsl:variable name="record-id" select="$ProfileData/items/condition/record-id[@server = $id]"/>

        <REPC_IN000033CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="AcceptMessage">
                <xsl:with-param name="ProfileData" select="$ProfileData"/>
                <xsl:with-param name="record-id" select="$record-id"/>
                <xsl:with-param name="interactionId">REPC_IN000033CA</xsl:with-param>
                <xsl:with-param name="TriggerEventCode">REPC_TE000027UV</xsl:with-param>
                <xsl:with-param name="IssueList-description" select="$IssueList-description"/>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </REPC_IN000033CA>

    </xsl:template>
    <xsl:template name="medicalConditionUpdateRejectedResponse">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>
        <xsl:param name="IssueList-description"/>

        <xsl:variable name="msgType">serverMsg</xsl:variable>
        <xsl:variable name="msgAction">updateResponse</xsl:variable>

        <xsl:variable name="patient_description">
            <xsl:call-template name="getPatientNameByID">
                <xsl:with-param name="node" select="descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:*/hl7:subject/hl7:patient/hl7:id"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][patient/@description = $patient_description]"/>

        <REPC_IN000034CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="RejectMessage">
                <xsl:with-param name="ProfileData" select="$ProfileData"/>
                <xsl:with-param name="interactionId">REPC_IN000034CA</xsl:with-param>
                <xsl:with-param name="TriggerEventCode">REPC_TE000028UV</xsl:with-param>
                <xsl:with-param name="IssueList-description" select="$IssueList-description"/>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </REPC_IN000034CA>
    </xsl:template>

</xsl:stylesheet>
