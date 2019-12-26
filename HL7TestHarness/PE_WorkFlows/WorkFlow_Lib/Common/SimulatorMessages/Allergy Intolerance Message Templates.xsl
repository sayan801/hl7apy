<?xml version="1.0" encoding="UTF-8"?>
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="urn:hl7-org:v3" xmlns:hl7="urn:hl7-org:v3" version="1.0">
    <xsl:include href="../Lib/MsgCreation_Lib.xsl"/>

    <!-- Query Messages -->
    <xsl:template name="allergyIntoleranceQueryResponse">
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

        <REPC_IN000016CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">

            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">REPC_IN000016CA</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <controlActEvent>
                <xsl:call-template name="controlActStart">
                    <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                    <xsl:with-param name="TriggerEventCode">REPC_TE000007UV</xsl:with-param>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="msgAction" select="$msgAction"/>
                </xsl:call-template>

                <xsl:variable name="includeNotes" select="descendant-or-self::hl7:includeNotesIndicator/hl7:value/@value"/>
                <xsl:for-each select="$ProfileData/descendant::items/allergy">
                    <subject contextConductionInd="false">
                        <xsl:call-template name="Allergy">
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
                        <xsl:when test="descendant-or-self::hl7:queryByParameter/hl7:queryId">
                            <xsl:copy-of select="descendant-or-self::hl7:queryByParameter/hl7:queryId"/>
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
                                    <xsl:value-of select="count($ProfileData/items/allergy)"/>
                                </xsl:attribute>
                            </resultTotalQuantity>
                            <resultCurrentQuantity value="">
                                <xsl:attribute name="value">
                                    <xsl:value-of select="count($ProfileData/items/allergy)"/>
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

        </REPC_IN000016CA>
    </xsl:template>
    <xsl:template name="allergyIntoleranceQueryRequest">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>

        <xsl:param name="author-description"/>
        <xsl:param name="supervisor-description"/>
        <xsl:param name="location-description"/>
        <xsl:param name="ParticipationMode"/>
        <xsl:param name="author-time"/>

        <xsl:param name="allergyIntoleranceStatus"/>
        <xsl:param name="allergyIntoleranceType"/>
        <xsl:param name="alleryIntoleranceStartDate"/>
        <xsl:param name="alleryIntoleranceEndDate"/>
        <xsl:param name="reactionCode"/>
        <xsl:param name="reactionCodeSystem"/>
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


        <REPC_IN000015CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">REPC_IN000015CA</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <controlActEvent classCode="CACT" moodCode="EVN">
                <xsl:call-template name="controlActStart">
                    <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                    <xsl:with-param name="author-description" select="$author-description"/>
                    <xsl:with-param name="location-description" select="$location-description"/>
                    <xsl:with-param name="author-time" select="$author-time"/>
                    <xsl:with-param name="ParticipationMode" select="$ParticipationMode"/>
                    <xsl:with-param name="TriggerEventCode">REPC_TE000006UV</xsl:with-param>
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

                        <!-- optional parameters -->
                        <xsl:if test="$allergyIntoleranceStatus">
                            <allergyIntoleranceStatus>
                                <value code="">
                                    <xsl:attribute name="code">
                                        <xsl:value-of select="$allergyIntoleranceStatus"/>
                                    </xsl:attribute>
                                </value>
                            </allergyIntoleranceStatus>
                        </xsl:if>
                        <!-- optional element for a coded value indicating whether to return an allergy record or an intolerance record. 
                            The result set will be filtered to include only allergy records or intolerance records accordingly - ObservationIntoleranceCode vocab -->
                        <xsl:if test="$allergyIntoleranceType">
                            <allergyIntoleranceType>
                                <value code="">
                                    <xsl:attribute name="code">
                                        <xsl:value-of select="$allergyIntoleranceType"/>
                                    </xsl:attribute>
                                </value>
                            </allergyIntoleranceType>
                        </xsl:if>
                        <!-- optional element to filter the query response to only include allergy/intolerance records which have been created or modified within the date-range specified-->
                        <xsl:if test="$alleryIntoleranceStartDate or $alleryIntoleranceEndDate">
                            <alllergyIntoleranceChangePeriod>
                                <value>
                                    <low>
                                        <xsl:choose>
                                            <xsl:when test="$alleryIntoleranceStartDate">
                                                <xsl:attribute name="value">
                                                    <xsl:value-of select="$alleryIntoleranceStartDate"/>
                                                </xsl:attribute>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:call-template name="nullFlavor"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </low>
                                    <high>
                                        <xsl:choose>
                                            <xsl:when test="$alleryIntoleranceEndDate">
                                                <xsl:attribute name="value">
                                                    <xsl:value-of select="$alleryIntoleranceEndDate"/>
                                                </xsl:attribute>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:call-template name="nullFlavor"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </high>
                                </value>
                            </alllergyIntoleranceChangePeriod>
                        </xsl:if>



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


                        <!-- required values to identify the patient -->
                        <xsl:call-template name="PatientByDescription">
                            <xsl:with-param name="description" select="$patient_description"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="use_phn">true</xsl:with-param>
                            <xsl:with-param name="format">query</xsl:with-param>
                        </xsl:call-template>

                        <!-- optional element to indicate a coded value denoting a specific reaction. E.g. Code for 'rash'. The result set will be
                            filtered to include only those allergy records or intolerance records pertaining to the specified reaction : SubjectReaction vocab -->
                        <xsl:if test="$reactionCode">
                            <reactionType>
                                <value>
                                    <xsl:attribute name="code">
                                        <xsl:value-of select="$reactionCode"/>
                                    </xsl:attribute>
                                    <xsl:if test="$reactionCodeSystem">
                                        <xsl:attribute name="codeSystem">
                                            <xsl:call-template name="getOIDRootByName">
                                                <xsl:with-param name="OID_Name" select="$reactionCodeSystem"/>
                                                <xsl:with-param name="msgType" select="$msgType"/>
                                            </xsl:call-template>
                                        </xsl:attribute>
                                    </xsl:if>
                                </value>
                            </reactionType>
                        </xsl:if>

                    </parameterList>
                </queryByParameter>

            </controlActEvent>


            <xsl:call-template name="transmissionWrapperEnd">
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

        </REPC_IN000015CA>

    </xsl:template>

    <xsl:template name="allergyIntoleranceHistoryQueryRequest">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>

        <xsl:param name="author-description"/>
        <xsl:param name="supervisor-description"/>
        <xsl:param name="location-description"/>
        <xsl:param name="ParticipationMode"/>
        <xsl:param name="author-time"/>

        <xsl:param name="alleryIntoleranceStartDate"/>
        <xsl:param name="alleryIntoleranceEndDate"/>
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


        <REPC_IN000017CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">REPC_IN000017CA</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <controlActEvent classCode="CACT" moodCode="EVN">
                <xsl:call-template name="controlActStart">
                    <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                    <xsl:with-param name="author-description" select="$author-description"/>
                    <xsl:with-param name="location-description" select="$location-description"/>
                    <xsl:with-param name="author-time" select="$author-time"/>
                    <xsl:with-param name="ParticipationMode" select="$ParticipationMode"/>
                    <xsl:with-param name="TriggerEventCode">REPC_TE000008UV</xsl:with-param>
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
                        <xsl:if test="$alleryIntoleranceStartDate or $alleryIntoleranceEndDate">
                            <amendedInTimeRange>
                                <value>
                                    <low>
                                        <xsl:choose>
                                            <xsl:when test="$alleryIntoleranceStartDate">
                                                <xsl:attribute name="value">
                                                    <xsl:value-of select="$alleryIntoleranceStartDate"/>
                                                </xsl:attribute>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:call-template name="nullFlavor"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </low>
                                    <high>
                                        <xsl:choose>
                                            <xsl:when test="$alleryIntoleranceEndDate">
                                                <xsl:attribute name="value">
                                                    <xsl:value-of select="$alleryIntoleranceEndDate"/>
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
                 <!-- identifier for the allergy -->
                        <conditionID>
                            <value>
                                <xsl:attribute name="root">
                                    <xsl:call-template name="getOIDRootByName">
                                        <xsl:with-param name="OID_Name">DIS_ALLERGY_ID</xsl:with-param>
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

        </REPC_IN000017CA>

    </xsl:template>
    
    <!-- Add Messages -->
    <xsl:template name="allergyIntoleranceAddRequest">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>

        <xsl:param name="allergy-description"/>
        <xsl:param name="IssueList-description"/>

        <xsl:variable name="msgType">clientMsg</xsl:variable>
        <xsl:variable name="msgAction">addRequest</xsl:variable>

        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][not($patient-description) or patient/@description = $patient-description]"/>
        <xsl:variable name="AllergyData" select="$ProfileData/descendant::items/allergy[@description=$allergy-description]"/>

        <REPC_IN000012CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">REPC_IN000012CA</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <controlActEvent classCode="CACT" moodCode="EVN">
                <xsl:call-template name="controlActStart">
                    <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                    <xsl:with-param name="supervisor-description" select="$AllergyData/supervisor/@description"/>
                    <xsl:with-param name="author-description" select="$AllergyData/author/@description"/>
                    <xsl:with-param name="location-description" select="$AllergyData/location/@description"/>
                    <xsl:with-param name="author-time" select="$AllergyData/author/@time"/>
                    <xsl:with-param name="ParticipationMode" select="$AllergyData/author/@ParticipationMode"/>
                    <xsl:with-param name="TriggerEventCode">REPC_TE000001UV</xsl:with-param>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="msgAction" select="$msgAction"/>
                </xsl:call-template>

                <subject contextConductionInd="false">
                    <xsl:call-template name="Allergy">
                        <xsl:with-param name="description" select="$allergy-description"/>
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
                    <xsl:with-param name="author-description" select="$AllergyData/author/@description"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                </xsl:call-template>

            </controlActEvent>

            <xsl:call-template name="transmissionWrapperEnd">
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

        </REPC_IN000012CA>

    </xsl:template>
    <xsl:template name="allergyIntoleranceAddAcceptedResponse">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>
        <xsl:param name="allergy-description"/>
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
                <xsl:when test="$allergy-description and not($allergy-description = '')">
                    <xsl:value-of select="$allergy-description"/>
                </xsl:when>
                <xsl:otherwise>Allergy(NEW_ITEM)</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <REPC_IN000013CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="AcceptMessage">
                <xsl:with-param name="ProfileData" select="$ProfileData"/>
                <xsl:with-param name="record-id" select="$ProfileData/descendant::items/allergy[@description=$description]/record-id"/>
                <xsl:with-param name="interactionId">REPC_IN000013CA</xsl:with-param>
                <xsl:with-param name="TriggerEventCode">REPC_TE000002UV</xsl:with-param>
                <xsl:with-param name="IssueList-description" select="$IssueList-description"/>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </REPC_IN000013CA>
    </xsl:template>
    <xsl:template name="allergyIntoleranceAddRejectedResponse">
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

        <REPC_IN000014CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="RejectMessage">
                <xsl:with-param name="ProfileData" select="$ProfileData"/>
                <xsl:with-param name="interactionId">REPC_IN000014CA</xsl:with-param>
                <xsl:with-param name="TriggerEventCode">REPC_TE000003UV</xsl:with-param>
                <xsl:with-param name="IssueList-description" select="$IssueList-description"/>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </REPC_IN000014CA>
    </xsl:template>

    <!-- Update Messages -->
    <xsl:template name="allergyIntoleranceUpdateRequest">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>

        <xsl:param name="allergy-description"/>
        <xsl:param name="IssueList-description"/>

        <xsl:variable name="msgType">clientMsg</xsl:variable>
        <xsl:variable name="msgAction">updateRequest</xsl:variable>

        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][not($patient-description) or patient/@description = $patient-description]"/>
        <xsl:variable name="AllergyData" select="$ProfileData/descendant::items/allergy[@description=$allergy-description]"/>

        <REPC_IN000020CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">REPC_IN000020CA</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <controlActEvent classCode="CACT" moodCode="EVN">
                <xsl:call-template name="controlActStart">
                    <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                    <xsl:with-param name="supervisor-description" select="$AllergyData/supervisor/@description"/>
                    <xsl:with-param name="author-description" select="$AllergyData/author/@description"/>
                    <xsl:with-param name="location-description" select="$AllergyData/location/@description"/>
                    <xsl:with-param name="author-time" select="$AllergyData/author/@time"/>
                    <xsl:with-param name="ParticipationMode" select="$AllergyData/author/@ParticipationMode"/>
                    <xsl:with-param name="TriggerEventCode">REPC_TE000023UV</xsl:with-param>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="msgAction" select="$msgAction"/>
                </xsl:call-template>

                <subject contextConductionInd="false">
                    <xsl:call-template name="Allergy">
                        <xsl:with-param name="description" select="$allergy-description"/>
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
                    <xsl:with-param name="author-description" select="$AllergyData/author/@description"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                </xsl:call-template>

            </controlActEvent>

            <xsl:call-template name="transmissionWrapperEnd">
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </REPC_IN000020CA>
    </xsl:template>
    <xsl:template name="allergyIntoleranceUpdateAcceptedResponse">
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

        <xsl:variable name="id" select="descendant-or-self::hl7:intoleranceCondition/hl7:id/@extension"/>
        <xsl:variable name="record-id" select="$ProfileData/items/allergy/record-id[@server = $id]"/>



        <REPC_IN000021CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="AcceptMessage">
                <xsl:with-param name="ProfileData" select="$ProfileData"/>
                <xsl:with-param name="record-id" select="$record-id"/>
                <xsl:with-param name="interactionId">REPC_IN000021CA</xsl:with-param>
                <xsl:with-param name="TriggerEventCode">REPC_TE000024UV</xsl:with-param>
                <xsl:with-param name="IssueList-description" select="$IssueList-description"/>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </REPC_IN000021CA>

    </xsl:template>
    <xsl:template name="allergyIntoleranceUpdateRejectedResponse">
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

        <REPC_IN000022CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="RejectMessage">
                <xsl:with-param name="ProfileData" select="$ProfileData"/>
                <xsl:with-param name="interactionId">REPC_IN000022CA</xsl:with-param>
                <xsl:with-param name="TriggerEventCode">REPC_TE000025UV</xsl:with-param>
                <xsl:with-param name="IssueList-description" select="$IssueList-description"/>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </REPC_IN000022CA>
    </xsl:template>

</xsl:stylesheet>
