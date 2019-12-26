<?xml version="1.0" encoding="UTF-8"?>
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="urn:hl7-org:v3" xmlns:hl7="urn:hl7-org:v3" version="1.0">
    <xsl:include href="../Lib/MsgCreation_Lib.xsl"/>



    <!-- Add Messages -->
    <xsl:template name="IssueManagementRequest">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>

        <xsl:param name="item-description"/>
        <xsl:param name="issue-description"/>
        <xsl:param name="management-description"/>
                            <xsl:param name="useOverRide"/>

        <xsl:variable name="msgType">clientMsg</xsl:variable>
        <xsl:variable name="msgAction">addRequest</xsl:variable>

        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][not($patient-description) or patient/@description = $patient-description]"/>
        <xsl:variable name="IssueData" select="$ProfileData/items/*[@description=$item-description]/Issue[@description = $issue-description]"/>


        <COMT_IN700001CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">COMT_IN700001CA</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <controlActEvent classCode="CACT" moodCode="EVN">
                <xsl:call-template name="controlActStart">
                    <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                    <xsl:with-param name="supervisor-description" select="$IssueData/supervisor/@description"/>
                    <xsl:with-param name="author-description" select="$IssueData/author/@description"/>
                    <xsl:with-param name="location-description" select="$IssueData/location/@description"/>
                    <xsl:with-param name="author-time" select="$IssueData/author/@time"/>
                    <xsl:with-param name="ParticipationMode" select="$IssueData/author/@ParticipationMode"/>
                    <xsl:with-param name="TriggerEventCode">COMT_TE700001UV</xsl:with-param>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="msgAction" select="$msgAction"/>
                </xsl:call-template>

                <subject contextConductionInd="false">
                    <xsl:call-template name="Issue">
                        <xsl:with-param name="ProfileData" select="$ProfileData"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                        <xsl:with-param name="Issue-details" select="$IssueData[1]"/>
                        <xsl:with-param name="Issue-description" select="$issue-description"/>
                        <xsl:with-param name="IssueManagement-description" select="$management-description"/>
                    </xsl:call-template>
                </subject>

                <!-- consent event -->
                <xsl:call-template name="consentEvent">
                    <xsl:with-param name="ProfileData" select="$ProfileData"/>
                    <xsl:with-param name="SubjectOfElementName">subjectOf2</xsl:with-param>
                    <xsl:with-param name="author-description" select="$IssueData/author/@description"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="useOverRide" select="$useOverRide"/>
                </xsl:call-template>

            </controlActEvent>

            <xsl:call-template name="transmissionWrapperEnd">
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

        </COMT_IN700001CA>

    </xsl:template>
    <xsl:template name="IssueManagementAcceptedResponse">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>

        <xsl:variable name="msgType">serverMsg</xsl:variable>
        <xsl:variable name="msgAction">addResponse</xsl:variable>

        <xsl:variable name="patient_description">
            <xsl:call-template name="getPatientNameByID">
                <xsl:with-param name="node" select="descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:*/hl7:subject/hl7:patient/hl7:id"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][patient/@description = $patient_description]"/>

        <COMT_IN700002CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="AcceptMessage-NoPayload">
                <xsl:with-param name="ProfileData" select="$ProfileData"/>
                <xsl:with-param name="interactionId">COMT_IN700002CA</xsl:with-param>
                <xsl:with-param name="TriggerEventCode">COMT_TE700002UV</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </COMT_IN700002CA>
    </xsl:template>
    <xsl:template name="IssueManagementRejectedResponse">
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

        <COMT_IN700003CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="RejectMessage">
                <xsl:with-param name="ProfileData" select="$ProfileData"/>
                <xsl:with-param name="interactionId">COMT_IN700003CA</xsl:with-param>
                <xsl:with-param name="TriggerEventCode">COMT_TE700003UV</xsl:with-param>
                <xsl:with-param name="IssueList-description" select="$IssueList-description"/>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </COMT_IN700003CA>
    </xsl:template>


    <xsl:template name="ManagementLastIssueRequest">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>

        <xsl:param name="supervisor-description"/>
        <xsl:param name="author-description"/>
        <xsl:param name="author-time"/>
        <xsl:param name="ParticipationMode"/>
        <xsl:param name="location-description"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>

        <xsl:param name="previous-issue-text"/>

        <!--<xsl:param name="management-description"/>-->
        <xsl:param name="management-code"/>
        <xsl:param name="management-text"/>

        <!-- can use these to cause an rejection message -->
        <xsl:param name="change-issue-code"/>
        <xsl:param name="change-issue-text"/>
        

        <xsl:variable name="msgType">clientMsg</xsl:variable>
        <xsl:variable name="msgAction">addRequest</xsl:variable>

        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][not($patient-description) or patient/@description = $patient-description]"/>

        <xsl:variable name="IssueData" select="$lastClientResponse/descendant-or-self::hl7:detectedIssueEvent[hl7:text = $previous-issue-text][position() = last()]"/>


        <COMT_IN700001CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">COMT_IN700001CA</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <controlActEvent classCode="CACT" moodCode="EVN">
                <xsl:call-template name="controlActStart">
                    <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                    <xsl:with-param name="supervisor-description" select="$supervisor-description"/>
                    <xsl:with-param name="author-description" select="$author-description"/>
                    <xsl:with-param name="location-description" select="$location-description"/>
                    <xsl:with-param name="author-time" select="$author-time"/>
                    <xsl:with-param name="ParticipationMode" select="$ParticipationMode"/>
                    <xsl:with-param name="TriggerEventCode">COMT_TE700001UV</xsl:with-param>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="msgAction" select="$msgAction"/>
                </xsl:call-template>

                <subject contextConductionInd="false">
                    <xsl:call-template name="CopyIssue">
                        <xsl:with-param name="issue-node" select="$IssueData"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                        <xsl:with-param name="management-author" select="$author-description"/>
                        <xsl:with-param name="management-time" select="$author-time"/>
                        <xsl:with-param name="management-code" select="$management-code"/>
                        <xsl:with-param name="management-text" select="$management-text"/>
                        <xsl:with-param name="change-issue-code" select="$change-issue-code"/>
                        <xsl:with-param name="change-issue-text" select="$change-issue-text"/>
                    </xsl:call-template>
                </subject>

                <!-- consent event -->
                <xsl:call-template name="consentEvent">
                    <xsl:with-param name="ProfileData" select="$ProfileData"/>
                    <xsl:with-param name="SubjectOfElementName">subjectOf2</xsl:with-param>
                    <xsl:with-param name="author-description" select="$author-description"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                </xsl:call-template>

            </controlActEvent>

            <xsl:call-template name="transmissionWrapperEnd">
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

        </COMT_IN700001CA>

    </xsl:template>

    <xsl:template name="CopyIssue">
        <xsl:param name="issue-node"/>
        <xsl:param name="msgType"/>
        <xsl:param name="management-author"/>
        <xsl:param name="management-code"/>
        <xsl:param name="management-text"/>
        <xsl:param name="management-time"/>
                <xsl:param name="change-issue-code"/>
                <xsl:param name="change-issue-text"/>

        <detectedIssueEvent>
            <!-- ActDetectedIssueCode vocab: A coded value that is used to distinguish between different kinds of issues INT indicates intolerance alert-->
            <xsl:choose>
                <xsl:when test="$change-issue-code">
                    <code>
                        <xsl:attribute name="code"><xsl:value-of select="$change-issue-code"/></xsl:attribute>
                    </code>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="$issue-node/hl7:code"/>
                </xsl:otherwise>
            </xsl:choose>
            
            <!-- An optional free form textual description of a detected issue -->
            <xsl:choose>
                <xsl:when test="$change-issue-text">
                    <text><xsl:value-of select="$change-issue-text"/></text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="$issue-node/hl7:text"/>
                </xsl:otherwise>
            </xsl:choose>
            
            <!-- some fixed value: irrelevant -->
            <statusCode code="active"/>
            <!-- A coded value denoting the importance of a detectable issue. Valid codes are: I - for Information, E - for Error, and W - for Warning -->
            <xsl:copy-of select="$issue-node/hl7:priorityCode"/>

            <!-- 0..25 elements to indicate the event that trigger the issue -->
            <!-- active medication (prescription or non-prescription medication) that is recorded in the patient’s record and which contributed to triggering the issue -->
            <xsl:copy-of select="$issue-node/hl7:subject"/>
            <!-- optional element that is the decision support rule that triggered the issue: Provides detailed background for providers in evaluating the issue -->
            <xsl:copy-of select="$issue-node/hl7:instantiation"/>

            <!-- supplied management for the issue -->
            <xsl:call-template name="Management">
                <xsl:with-param name="msgType" select="$msgType"/>
                <xsl:with-param name="author-description" select="$management-author"/>
                <xsl:with-param name="code" select="$management-code"/>
                <xsl:with-param name="text" select="$management-text"/>
                <xsl:with-param name="time" select="$management-time"/>
            </xsl:call-template>

            <!-- severity of the issue -->
            <subjectOf>
                <severityObservation>
                    <!-- A coded value denoting a category of severity used for the detected issue. SEV is the fixed value -->
                    <xsl:copy-of select="$issue-node/hl7:*/hl7:severityObservation/hl7:code"/>
                    <!-- SeverityObservation vocab,  A coded value denoting the gravity of the detected issue -->
                    <xsl:copy-of select="$issue-node/hl7:*/hl7:severityObservation/hl7:value"/>
                </severityObservation>
                
            </subjectOf>
        </detectedIssueEvent>
    </xsl:template>


    <xsl:template name="Management">
        <xsl:param name="author-description"/>
        <xsl:param name="code"/>
        <xsl:param name="text"/>
        <xsl:param name="time"/>
        <xsl:param name="msgType"/>
        <mitigatedBy>
            <detectedIssueManagement>
                <!-- ActDetectedIssueManagementCode vocab,  Indicates the kinds of management actions that have been taken, depending on the issue type -->
                <code>
                    <xsl:choose>
                        <xsl:when test="$code">
                            <xsl:attribute name="code">
                                <xsl:value-of select="$code"/>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="nullFlavor"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </code>
                <!-- Additional free-text details describing the management of the issue -->
                <xsl:if test="$text">
                    <text>
                        <xsl:value-of select="$text"/>
                    </text>
                </xsl:if>
                <statusCode code="active"/>
                <author>
                    <time>
                        <xsl:choose>
                            <xsl:when test="$time">
                                <xsl:attribute name="value">
                                    <xsl:value-of select="$time"/>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="nullFlavor"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </time>
                    <xsl:call-template name="ProviderByDescription">
                        <xsl:with-param name="description" select="$author-description"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                        <xsl:with-param name="format">CeRx</xsl:with-param>
                    </xsl:call-template>
                </author>
            </detectedIssueManagement>
        </mitigatedBy>

    </xsl:template>

</xsl:stylesheet>
