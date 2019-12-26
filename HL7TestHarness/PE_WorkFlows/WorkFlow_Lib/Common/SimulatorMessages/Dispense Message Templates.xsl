<?xml version="1.0" encoding="ISO-8859-1"?>
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="urn:hl7-org:v3" xmlns:hl7="urn:hl7-org:v3" version="1.0">
    <xsl:include href="../Lib/MsgCreation_Lib.xsl"/>



    <!-- Dispense Messages -->
    <xsl:template name="DispenseRequest">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>
        <xsl:param name="inferedRx"/>
        <xsl:param name="supervisor-description"/>
        <xsl:param name="author-description"/>
        <xsl:param name="location-description"/>
        <xsl:param name="fill-code"/>
        <xsl:param name="useOverRide"/>
        

        <xsl:param name="dispense-description"/>
        <xsl:param name="IssueList-description"/>

        <xsl:variable name="msgType">clientMsg</xsl:variable>
        <xsl:variable name="msgAction">addRequest</xsl:variable>

        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][not($patient-description) or patient/@description = $patient-description]"/>
        <xsl:variable name="DispenseData" select="$ProfileData/descendant::items/dispense[@description=$dispense-description]"/>

        <PORX_IN020190CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">PORX_IN020190CA</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <controlActEvent classCode="CACT" moodCode="EVN">
                <xsl:choose>
                    <xsl:when test="$author-description and $location-description">
                        <xsl:call-template name="controlActStart">
                            <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                            <xsl:with-param name="supervisor-description" select="$supervisor-description"/>
                            <xsl:with-param name="author-description" select="$author-description"/>
                            <xsl:with-param name="location-description" select="$location-description"/>
                            <xsl:with-param name="TriggerEventCode">PORX_TE020220UV</xsl:with-param>
                            <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="msgAction" select="$msgAction"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="controlActStart">
                            <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                            <xsl:with-param name="supervisor-description" select="$DispenseData/supervisor/@description"/>
                            <xsl:with-param name="author-description" select="$DispenseData/author/@description"/>
                            <xsl:with-param name="location-description" select="$DispenseData/location/@description"/>
                            <xsl:with-param name="author-time" select="$DispenseData/author/@time"/>
                            <xsl:with-param name="ParticipationMode" select="$DispenseData/author/@ParticipationMode"/>
                            <xsl:with-param name="TriggerEventCode">PORX_TE020220UV</xsl:with-param>
                            <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="msgAction" select="$msgAction"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
                

                <subject contextConductionInd="false">
                    <xsl:call-template name="Dispense">
                        <xsl:with-param name="description" select="$dispense-description"/>
                        <xsl:with-param name="ProfileData" select="$ProfileData"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                        <xsl:with-param name="msgAction" select="$msgAction"/>
                        <xsl:with-param name="inferedRx" select="$inferedRx"/>
                        <xsl:with-param name="fillCode" select="$fill-code"/>
                    </xsl:call-template>
                </subject>

                <xsl:call-template name="IssueList">
                    <xsl:with-param name="IssueList-description" select="$IssueList-description"/>
                    <xsl:with-param name="repeatingElementName">subjectOf1</xsl:with-param>
                    <xsl:with-param name="ProfileData" select="$ProfileData"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                </xsl:call-template>

                <!-- consent event -->
                <xsl:choose>
                    <xsl:when test="$author-description and $location-description">
                        <xsl:call-template name="consentEvent">
                            <xsl:with-param name="ProfileData" select="$ProfileData"/>
                            <xsl:with-param name="SubjectOfElementName">subjectOf2</xsl:with-param>
                            <xsl:with-param name="author-description" select="$author-description"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="useOverRide" select="$useOverRide"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="consentEvent">
                            <xsl:with-param name="ProfileData" select="$ProfileData"/>
                            <xsl:with-param name="SubjectOfElementName">subjectOf2</xsl:with-param>
                            <xsl:with-param name="author-description" select="$DispenseData/author/@description"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="useOverRide" select="$useOverRide"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
                

            </controlActEvent>

            <xsl:call-template name="transmissionWrapperEnd">
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

        </PORX_IN020190CA>

    </xsl:template>
    <xsl:template name="DispenseAcceptedResponse">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>
        <xsl:param name="dispense-description"/>
        <xsl:param name="IssueList-description"/>

        <xsl:variable name="msgType">serverMsg</xsl:variable>
        <xsl:variable name="msgAction">addResponse</xsl:variable>

        <xsl:variable name="patient_description">
            <xsl:call-template name="getPatientNameByID">
                <xsl:with-param name="node" select="descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:*/hl7:subject/hl7:patient1/hl7:id"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][patient/@description = $patient_description]"/>

        <xsl:variable name="description">
            <xsl:choose>
                <xsl:when test="$dispense-description and not($dispense-description = '')">
                    <xsl:value-of select="$dispense-description"/>
                </xsl:when>
                <xsl:otherwise>Dispense(NEW_ITEM)</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <PORX_IN020130CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="AcceptDispenseMessage">
                <xsl:with-param name="ProfileData" select="$ProfileData"/>
                <xsl:with-param name="dispense-description" select="$description"/>
                <xsl:with-param name="interactionId">PORX_IN020130CA</xsl:with-param>
                <xsl:with-param name="TriggerEventCode">PORX_TE020190UV</xsl:with-param>
                <xsl:with-param name="IssueList-description" select="$IssueList-description"/>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </PORX_IN020130CA>
    </xsl:template>
    <xsl:template name="DispenseRejectedResponse">
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

        <PORX_IN020140CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="RejectMessage">
                <xsl:with-param name="ProfileData" select="$ProfileData"/>
                <xsl:with-param name="interactionId">PORX_IN020140CA</xsl:with-param>
                <xsl:with-param name="TriggerEventCode">PORX_TE020270UV</xsl:with-param>
                <xsl:with-param name="IssueList-description" select="$IssueList-description"/>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </PORX_IN020140CA>
    </xsl:template>


    <!-- Dispense Pickup Messages -->
    <xsl:template name="DispensePickupRequest">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>
        <xsl:param name="supervisor-description"/>
        <xsl:param name="author-description"/>
        <xsl:param name="location-description"/>
        <xsl:param name="useOverRide"/>

        <xsl:param name="dispense-description"/>
        <xsl:param name="IssueList-description"/>

        <xsl:variable name="msgType">clientMsg</xsl:variable>
        <xsl:variable name="msgAction">addRequest</xsl:variable>

        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][not($patient-description) or patient/@description = $patient-description]"/>
        <xsl:variable name="PickupData" select="$ProfileData/items/dispense[@description=$dispense-description]/pickup"/>

        <PORX_IN020080CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">PORX_IN020080CA</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <controlActEvent classCode="CACT" moodCode="EVN">
                <xsl:choose>
                    <xsl:when test="$author-description and $location-description">
                        <xsl:call-template name="controlActStart">
                            <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                            <xsl:with-param name="supervisor-description" select="$supervisor-description"/>
                            <xsl:with-param name="author-description" select="$author-description"/>
                            <xsl:with-param name="location-description" select="$location-description"/>
                            <xsl:with-param name="TriggerEventCode">PORX_TE020170UV</xsl:with-param>
                            <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="msgAction" select="$msgAction"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                <xsl:call-template name="controlActStart">
                    <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                    <xsl:with-param name="supervisor-description" select="$PickupData/supervisor/@description"/>
                    <xsl:with-param name="author-description" select="$PickupData/author/@description"/>
                    <xsl:with-param name="location-description" select="$PickupData/location/@description"/>
                    <xsl:with-param name="author-time" select="$PickupData/author/@time"/>
                    <xsl:with-param name="ParticipationMode" select="$PickupData/author/@ParticipationMode"/>
                    <xsl:with-param name="TriggerEventCode">PORX_TE020170UV</xsl:with-param>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="msgAction" select="$msgAction"/>
                </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>


                <subject contextConductionInd="false">
                    <xsl:call-template name="DispensePickup">
                        <xsl:with-param name="dispense-description" select="$dispense-description"/>
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
                <xsl:choose>
                    <xsl:when test="$author-description and $location-description">
                        <xsl:call-template name="consentEvent">
                            <xsl:with-param name="ProfileData" select="$ProfileData"/>
                            <xsl:with-param name="SubjectOfElementName">subjectOf2</xsl:with-param>
                            <xsl:with-param name="author-description" select="$author-description"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="useOverRide" select="$useOverRide"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="consentEvent">
                            <xsl:with-param name="ProfileData" select="$ProfileData"/>
                            <xsl:with-param name="SubjectOfElementName">subjectOf2</xsl:with-param>
                            <xsl:with-param name="author-description" select="$PickupData/author/@description"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="useOverRide" select="$useOverRide"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
                
            </controlActEvent>

            <xsl:call-template name="transmissionWrapperEnd">
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

        </PORX_IN020080CA>

    </xsl:template>
    <xsl:template name="DispensePickupAcceptedResponse">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>
        <xsl:param name="dispense-description"/>
        <xsl:param name="IssueList-description"/>

        <xsl:variable name="msgType">serverMsg</xsl:variable>
        <xsl:variable name="msgAction">addResponse</xsl:variable>

        <xsl:variable name="patient_description">
            <xsl:call-template name="getPatientNameByID">
                <xsl:with-param name="node" select="descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:*/hl7:subject/hl7:patient/hl7:id"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][patient/@description = $patient_description]"/>

        <xsl:variable name="id" select="descendant-or-self::hl7:supplyEvent/hl7:id/@extension"/>
        <xsl:variable name="record-id" select="$ProfileData/items/dispense/record-id[@server = $id]"/>

        <PORX_IN020090CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="AcceptMessage">
                <xsl:with-param name="ProfileData" select="$ProfileData"/>
                <xsl:with-param name="record-id" select="$record-id"/>
                <xsl:with-param name="interactionId">PORX_IN020090CA</xsl:with-param>
                <xsl:with-param name="TriggerEventCode">PORX_TE020100UV</xsl:with-param>
                <xsl:with-param name="IssueList-description" select="$IssueList-description"/>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </PORX_IN020090CA>
    </xsl:template>
    <xsl:template name="DispensePickupRejectedResponse">
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

        <PORX_IN020100CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="RejectMessage">
                <xsl:with-param name="ProfileData" select="$ProfileData"/>
                <xsl:with-param name="interactionId">PORX_IN020100CA</xsl:with-param>
                <xsl:with-param name="TriggerEventCode">PORX_TE020140UV</xsl:with-param>
                <xsl:with-param name="IssueList-description" select="$IssueList-description"/>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </PORX_IN020100CA>
    </xsl:template>

    <!-- Dispense Reversal Messages -->
    <xsl:template name="DispenseReversalRequest">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>

        <xsl:param name="dispense-description"/>
        <xsl:param name="IssueList-description"/>

        <xsl:variable name="msgType">clientMsg</xsl:variable>
        <xsl:variable name="msgAction">reversalRequest</xsl:variable>

        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][not($patient-description) or patient/@description = $patient-description]"/>
        <xsl:variable name="DispenseData" select="$ProfileData/items/dispense[@description=$dispense-description]"/>

        <PORX_IN020370CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">PORX_IN020370CA</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <controlActEvent classCode="CACT" moodCode="EVN">
                <xsl:call-template name="controlActStart">
                    <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                    <xsl:with-param name="supervisor-description" select="$DispenseData/supervisor/@description"/>
                    <xsl:with-param name="author-description" select="$DispenseData/author/@description"/>
                    <xsl:with-param name="location-description" select="$DispenseData/location/@description"/>
                    <xsl:with-param name="author-time" select="$DispenseData/author/@time"/>
                    <xsl:with-param name="ParticipationMode" select="$DispenseData/author/@ParticipationMode"/>
                    <xsl:with-param name="TriggerEventCode">PORX_TE020280UV</xsl:with-param>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="msgAction" select="$msgAction"/>
                </xsl:call-template>

                <subject contextConductionInd="false">
                    <xsl:call-template name="Dispense">
                        <xsl:with-param name="description" select="$dispense-description"/>
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
                    <xsl:with-param name="author-description" select="$DispenseData/author/@description"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                </xsl:call-template>
            </controlActEvent>

            <xsl:call-template name="transmissionWrapperEnd">
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

        </PORX_IN020370CA>

    </xsl:template>
    <xsl:template name="DispenseReversalAcceptedResponse">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>
        <xsl:param name="dispense-description"/>
        <xsl:param name="IssueList-description"/>

        <xsl:variable name="msgType">serverMsg</xsl:variable>
        <xsl:variable name="msgAction">addResponse</xsl:variable>

        <xsl:variable name="patient_description">
            <xsl:call-template name="getPatientNameByID">
                <xsl:with-param name="node" select="descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:*/hl7:recordTarget/hl7:patient/hl7:id"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][patient/@description = $patient_description]"/>

        <xsl:variable name="id" select="descendant-or-self::hl7:actEvent/hl7:id/@extension"/>
        <xsl:variable name="record-id" select="$ProfileData/items/dispense/record-id[@server = $id]"/>

        <PORX_IN020380CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="AcceptMessage">
                <xsl:with-param name="ProfileData" select="$ProfileData"/>
                <xsl:with-param name="record-id" select="$record-id"/>
                <xsl:with-param name="interactionId">PORX_IN020380CA</xsl:with-param>
                <xsl:with-param name="TriggerEventCode">PORX_TE020090UV</xsl:with-param>
                <xsl:with-param name="IssueList-description" select="$IssueList-description"/>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </PORX_IN020380CA>

    </xsl:template>
    <xsl:template name="DispenseReversalRejectedResponse">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>
        <xsl:param name="IssueList-description"/>

        <xsl:variable name="msgType">serverMsg</xsl:variable>
        <xsl:variable name="msgAction">addResponse</xsl:variable>

        <xsl:variable name="patient_description">
            <xsl:call-template name="getPatientNameByID">
                <xsl:with-param name="node" select="descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:*/hl7:recordTarget/hl7:patient/hl7:id"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][patient/@description = $patient_description]"/>

        <PORX_IN020390CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="RejectMessage">
                <xsl:with-param name="ProfileData" select="$ProfileData"/>
                <xsl:with-param name="interactionId">PORX_IN020390CA</xsl:with-param>
                <xsl:with-param name="TriggerEventCode">PORX_TE020290UV</xsl:with-param>
                <xsl:with-param name="IssueList-description" select="$IssueList-description"/>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </PORX_IN020390CA>
    </xsl:template>

</xsl:stylesheet>
