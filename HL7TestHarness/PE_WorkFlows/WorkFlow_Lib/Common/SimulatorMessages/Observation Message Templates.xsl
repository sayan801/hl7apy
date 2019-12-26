<?xml version="1.0" encoding="UTF-8"?>
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->  <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="urn:hl7-org:v3" xmlns:hl7="urn:hl7-org:v3" version="1.0">
    <xsl:include href="../Lib/MsgCreation_Lib.xsl"/>

    <!-- Query Messages -->
    <xsl:template name="observationQueryResponse">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>     <xsl:param name="patient-description"/>         <xsl:param name="msg-effective-time"/>
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

        <REPC_IN000055CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">

            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">REPC_IN000055CA</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <controlActEvent>
                <xsl:call-template name="controlActStart">                     <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                    <xsl:with-param name="TriggerEventCode">REPC_TE000055UV</xsl:with-param>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="msgAction" select="$msgAction"/>
                </xsl:call-template>

                 <xsl:variable name="includeNotes"  select="descendant-or-self::hl7:includeNotesIndicator/hl7:value/@value"/>
                <xsl:variable name="includeIssues"  select="descendant-or-self::hl7:includeIssuesIndicator/hl7:value/@value"/>

                <xsl:for-each select="$ProfileData/items/observation">
                    <subject contextConductionInd="false">
                        <xsl:call-template name="Observation">
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
                            <queryId ><xsl:call-template name="nullFlavor"/></queryId>
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
                                    <xsl:value-of select="count($ProfileData/items/observation)"/>
                                </xsl:attribute>
                            </resultTotalQuantity>
                            <resultCurrentQuantity value="">
                                <xsl:attribute name="value">
                                    <xsl:value-of select="count($ProfileData/items/observation)"/>
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

        </REPC_IN000055CA>
    </xsl:template>

    <!-- TODO: need to add author, location, consent, etc. -->
    <xsl:template name="observationQueryRequest">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>     <xsl:param name="patient-description"/>         <xsl:param name="msg-effective-time"/>
       
        <xsl:param name="author-description"/>
        <xsl:param name="supervisor-description"/>
        <xsl:param name="location-description"/>
        <xsl:param name="ParticipationMode"/>
        <xsl:param name="author-time"/>

        <xsl:param name="measurementCode"/>
        <xsl:param name="measurementCodeSystem"/>
        <xsl:param name="measurementEffectiveEndDate"/>
        <xsl:param name="measurementEffectiveStartDate"/>
        <xsl:param name="includeIssues"/>
        <xsl:param name="includeNotes"/>
        <xsl:param name="query-id"/>
                            <xsl:param name="useOverRide"/>

        <xsl:variable name="msgType">clientMsg</xsl:variable>
        <xsl:variable name="msgAction">queryRequest</xsl:variable>

        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][not($patient-description) or patient/@description = $patient-description]"/>

        <xsl:variable name="patient_description">
            <xsl:choose>
                <xsl:when test="$patient-description"><xsl:value-of select="$patient-description"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="$ProfileData/patient/@description"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <REPC_IN000054CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">REPC_IN000054CA</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <controlActEvent classCode="CACT" moodCode="EVN">
                <xsl:call-template name="controlActStart">                     <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                    <xsl:with-param name="author-description" select="$author-description"/>
                    <xsl:with-param name="location-description" select="$location-description"/>
                    <xsl:with-param name="author-time" select="$author-time"/>
                    <xsl:with-param name="ParticipationMode" select="$ParticipationMode"/>
                    <xsl:with-param name="TriggerEventCode">REPC_TE000054UV</xsl:with-param>
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
                            <queryId ><xsl:call-template name="nullFlavor"/></queryId>
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

                        <!-- optional value for period -->
                        <xsl:call-template name="DateQueryElement">
                            <xsl:with-param name="elementName">measurementEffectivePeriod</xsl:with-param>
                            <xsl:with-param name="endDate" select="$measurementEffectiveEndDate"/>
                            <xsl:with-param name="startDate" select="$measurementEffectiveStartDate"/>
                        </xsl:call-template>

                        <!-- optional value for measurement type -->
                        <xsl:if test="$measurementCode">
                        <measurementType>
                            <value>
                                <xsl:attribute name="code"><xsl:value-of select="$measurementCode"/></xsl:attribute>
                                <xsl:if test="$measurementCodeSystem">
                                    <xsl:attribute name="codeSystem">
                                        <xsl:call-template name="getOIDRootByName">
                                            <xsl:with-param name="OID_Name" select="$measurementCodeSystem"/>
                                            <xsl:with-param name="msgType" select="$msgType"/>
                                        </xsl:call-template>
                                    </xsl:attribute>
                                </xsl:if>
                              </value>
                        </measurementType>
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

        </REPC_IN000054CA>

    </xsl:template>

    <!-- Add Messages -->
    <xsl:template name="observationAddResquest">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>     <xsl:param name="patient-description"/>         <xsl:param name="msg-effective-time"/>
       
        <xsl:param name="observation-description"/>
        <xsl:param name="IssueList-description"/>

        <xsl:variable name="msgType">clientMsg</xsl:variable>
        <xsl:variable name="msgAction">addRequest</xsl:variable>

        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][not($patient-description) or patient/@description = $patient-description]"/>
        <xsl:variable name="ObservationData" select="$ProfileData/items/observation[@description=$observation-description]"/>
        
        <REPC_IN000051CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">REPC_IN000051CA</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <controlActEvent classCode="CACT" moodCode="EVN">
                <xsl:call-template name="controlActStart">                     <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                    <xsl:with-param name="supervisor-description" select="$ObservationData/supervisor/@description"/>
                    <xsl:with-param name="author-description" select="$ObservationData/author/@description"/>
                    <xsl:with-param name="location-description" select="$ObservationData/location/@description"/>
                    <xsl:with-param name="author-time" select="$ObservationData/author/@time"/>
                    <xsl:with-param name="ParticipationMode" select="$ObservationData/author/@ParticipationMode"/>
                    <xsl:with-param name="TriggerEventCode">REPC_TE000051UV</xsl:with-param>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="msgAction" select="$msgAction"/>
                </xsl:call-template>

                <subject contextConductionInd="false">
                    <xsl:call-template name="Observation">
                        <xsl:with-param name="description" select="$observation-description"/>
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
                    <xsl:with-param name="author-description" select="$ObservationData/author/@description"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                </xsl:call-template>
                
            </controlActEvent>

            <xsl:call-template name="transmissionWrapperEnd">
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

        </REPC_IN000051CA>

    </xsl:template>
    <xsl:template name="observationAddAcceptedResponse">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>     <xsl:param name="patient-description"/>         <xsl:param name="msg-effective-time"/>
        <xsl:param name="observation-description"/>
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
                <xsl:when test="$observation-description and not($observation-description = '')"><xsl:value-of select="$observation-description"/></xsl:when>
                <xsl:otherwise>Observation(NEW_ITEM)</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <REPC_IN000052CA xmlns="urn:hl7-org:v3"  ITSVersion="XML_1.0">
            <xsl:call-template name="AcceptMessage">
                <xsl:with-param name="ProfileData" select="$ProfileData"/>
                <xsl:with-param name="record-id" select="$ProfileData/items/reaction[@description=$description]/record-id"/>
                <xsl:with-param name="interactionId">REPC_IN000052CA</xsl:with-param>
                <xsl:with-param name="TriggerEventCode">REPC_TE000052UV</xsl:with-param>
                <xsl:with-param name="IssueList-description" select="$IssueList-description"/>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </REPC_IN000052CA>
    </xsl:template>
    <xsl:template name="observationAddRejectedResponse">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>     <xsl:param name="patient-description"/>         <xsl:param name="msg-effective-time"/>
        <xsl:param name="IssueList-description"/>
        
        <xsl:variable name="msgType">serverMsg</xsl:variable>
        <xsl:variable name="msgAction">addResponse</xsl:variable>

        <xsl:variable name="patient_description">
            <xsl:call-template name="getPatientNameByID">
                <xsl:with-param name="node" select="descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:*/hl7:subject/hl7:patient/hl7:id"/>
            </xsl:call-template>
        </xsl:variable>
                
        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][patient/@description = $patient_description]"/>
        
        <REPC_IN000053CA xmlns="urn:hl7-org:v3"  ITSVersion="XML_1.0">
            <xsl:call-template name="RejectMessage">
                <xsl:with-param name="ProfileData" select="$ProfileData"/>
                <xsl:with-param name="interactionId">REPC_IN000053CA</xsl:with-param>
                <xsl:with-param name="TriggerEventCode">REPC_TE000053UV</xsl:with-param>
                <xsl:with-param name="IssueList-description" select="$IssueList-description"/>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </REPC_IN000053CA>
    </xsl:template>

</xsl:stylesheet>
