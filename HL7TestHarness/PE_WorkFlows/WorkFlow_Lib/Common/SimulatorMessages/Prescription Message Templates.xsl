<?xml version="1.0" encoding="UTF-8"?>
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:hl7="urn:hl7-org:v3" version="1.0">
    <xsl:include href="../Lib/MsgCreation_Lib.xsl"/>

    <!-- Add Messages -->
    <xsl:template name="RxAddRequest">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>
        <xsl:param name="supervisor-description"/>
        <xsl:param name="author-description"/>
        <xsl:param name="location-description"/>
        <xsl:param name="useOverRide"/>

        <xsl:param name="prescription-description"/>
        <xsl:param name="IssueList-description"/>

        <xsl:variable name="msgType">clientMsg</xsl:variable>
        <xsl:variable name="msgAction">addRequest</xsl:variable>

        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][not($patient-description) or patient/@description = $patient-description]"/>
        <xsl:variable name="PrescriptionData" select="$ProfileData/items/prescription[@description=$prescription-description]"/>

        <PORX_IN010380CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">PORX_IN010380CA</xsl:with-param>
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
                            <xsl:with-param name="TriggerEventCode">PORX_TE010730UV</xsl:with-param>
                            <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="msgAction" select="$msgAction"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                <xsl:call-template name="controlActStart">
                    <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                    <xsl:with-param name="supervisor-description" select="$PrescriptionData/supervisor/@description"/>
                    <xsl:with-param name="author-description" select="$PrescriptionData/author/@description"/>
                    <xsl:with-param name="location-description" select="$PrescriptionData/location/@description"/>
                    <xsl:with-param name="author-time" select="$PrescriptionData/author/@time"/>
                    <xsl:with-param name="ParticipationMode" select="$PrescriptionData/author/@ParticipationMode"/>
                    <xsl:with-param name="TriggerEventCode">PORX_TE010730UV</xsl:with-param>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="msgAction" select="$msgAction"/>
                </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>

                

                <subject contextConductionInd="false">
                    <xsl:call-template name="Prescription">
                        <xsl:with-param name="description" select="$prescription-description"/>
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
                            <xsl:with-param name="author-description" select="$PrescriptionData/author/@description"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                            <xsl:with-param name="useOverRide" select="$useOverRide"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>

            </controlActEvent>

            <xsl:call-template name="transmissionWrapperEnd">
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

        </PORX_IN010380CA>

    </xsl:template>
    <xsl:template name="RxAddAcceptedResponse">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>
        <xsl:param name="prescription-description"/>
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
                <xsl:when test="$prescription-description and not($prescription-description = '')">
                    <xsl:value-of select="$prescription-description"/>
                </xsl:when>
                <xsl:otherwise>Prescription(NEW_ITEM)</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <PORX_IN010390CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="AcceptMessage-ActRequest">
                <xsl:with-param name="ProfileData" select="$ProfileData"/>
                <xsl:with-param name="record-id">
                    <xsl:call-template name="record-id">
                        <xsl:with-param name="Record" select="$ProfileData/items/prescription[@description=$description]/record-id"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </xsl:with-param>
                <xsl:with-param name="record-OID">DIS_PRESCRIPTION_ID</xsl:with-param>
                <xsl:with-param name="interactionId">PORX_IN010390CA</xsl:with-param>
                <xsl:with-param name="TriggerEventCode">PORX_TE010660UV</xsl:with-param>
                <xsl:with-param name="IssueList-description" select="$IssueList-description"/>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </PORX_IN010390CA>
    </xsl:template>
    <xsl:template name="RxAddRejectedResponse">
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

        <PORX_IN010400CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="RejectMessage">
                <xsl:with-param name="ProfileData" select="$ProfileData"/>
                <xsl:with-param name="interactionId">PORX_IN010400CA</xsl:with-param>
                <xsl:with-param name="TriggerEventCode">PORX_TE010690UV</xsl:with-param>
                <xsl:with-param name="IssueList-description" select="$IssueList-description"/>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </PORX_IN010400CA>
    </xsl:template>

    <!-- PreDetermination -->
    <xsl:template name="PreDetermRxAddRequest">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>

        <xsl:param name="prescription-description"/>
        <xsl:param name="IssueList-description"/>

        <xsl:variable name="msgType">clientMsg</xsl:variable>
        <xsl:variable name="msgAction">addRequest</xsl:variable>

        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][not($patient-description) or patient/@description = $patient-description]"/>
        <xsl:variable name="PrescriptionData" select="$ProfileData/items/prescription[@description=$prescription-description]"/>

        <PORX_IN010420CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">PORX_IN010420CA</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <controlActEvent classCode="CACT" moodCode="EVN">
                <xsl:call-template name="controlActStart">
                    <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                    <xsl:with-param name="supervisor-description" select="$PrescriptionData/supervisor/@description"/>
                    <xsl:with-param name="author-description" select="$PrescriptionData/author/@description"/>
                    <xsl:with-param name="location-description" select="$PrescriptionData/location/@description"/>
                    <xsl:with-param name="author-time" select="$PrescriptionData/author/@time"/>
                    <xsl:with-param name="ParticipationMode" select="$PrescriptionData/author/@ParticipationMode"/>
                    <xsl:with-param name="TriggerEventCode">PORX_TE010720UV</xsl:with-param>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="msgAction" select="$msgAction"/>
                </xsl:call-template>

                <subject contextConductionInd="false">
                    <xsl:call-template name="Prescription">
                        <xsl:with-param name="description" select="$prescription-description"/>
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
                    <xsl:with-param name="author-description" select="$PrescriptionData/author/@description"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                </xsl:call-template>

            </controlActEvent>

            <xsl:call-template name="transmissionWrapperEnd">
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

        </PORX_IN010420CA>

    </xsl:template>
    <xsl:template name="PreDetermRxAddAcceptedResponse">
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

        <PORX_IN010390CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="AcceptMessage-NoPayload">
                <xsl:with-param name="ProfileData" select="$ProfileData"/>
                <xsl:with-param name="interactionId">PORX_IN010390CA</xsl:with-param>
                <xsl:with-param name="TriggerEventCode">PORX_TE010390CA</xsl:with-param>
                <xsl:with-param name="IssueList-description" select="$IssueList-description"/>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </PORX_IN010390CA>
    </xsl:template>
    <xsl:template name="PreDetermRxAddRejectedResponse">
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

        <PORX_IN010630CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="RejectMessage">
                <xsl:with-param name="ProfileData" select="$ProfileData"/>
                <xsl:with-param name="interactionId">PORX_IN010630CA</xsl:with-param>
                <xsl:with-param name="TriggerEventCode">PORX_TE010690UV</xsl:with-param>
                <xsl:with-param name="IssueList-description" select="$IssueList-description"/>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </PORX_IN010630CA>
    </xsl:template>

    <!-- Transfer Rx -->
    <xsl:template name="RxTransferRequest">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>

        <xsl:param name="prescription-description"/>
        <xsl:param name="newLocation-description"/>
        <xsl:param name="IssueList-description"/>

        <xsl:variable name="msgType">clientMsg</xsl:variable>
        <xsl:variable name="msgAction">transferRequest</xsl:variable>

        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][not($patient-description) or patient/@description = $patient-description]"/>
        <xsl:variable name="PrescriptionData" select="$ProfileData/items/prescription[@description=$prescription-description]"/>

        <PORX_IN010100CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">PORX_IN010100CA</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <controlActEvent classCode="CACT" moodCode="EVN">
                <xsl:call-template name="controlActStart">
                    <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                    <xsl:with-param name="supervisor-description" select="$PrescriptionData/supervisor/@description"/>
                    <xsl:with-param name="author-description" select="$PrescriptionData/author/@description"/>
                    <xsl:with-param name="location-description" select="$PrescriptionData/location/@description"/>
                    <xsl:with-param name="author-time" select="$PrescriptionData/author/@time"/>
                    <xsl:with-param name="ParticipationMode" select="$PrescriptionData/author/@ParticipationMode"/>
                    <xsl:with-param name="TriggerEventCode">PORX_TE010510UV</xsl:with-param>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="msgAction" select="$msgAction"/>
                </xsl:call-template>

                <subject contextConductionInd="false">
                    <xsl:call-template name="TransferPrescription">
                        <xsl:with-param name="description" select="$prescription-description"/>
                        <xsl:with-param name="newLocation-description" select="$newLocation-description"/>
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
                    <xsl:with-param name="author-description" select="$PrescriptionData/author/@description"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                </xsl:call-template>

            </controlActEvent>

            <xsl:call-template name="transmissionWrapperEnd">
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

        </PORX_IN010100CA>

    </xsl:template>
    <xsl:template name="RxTransferAcceptedResponse">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>
        <xsl:param name="prescription-description"/>
        <xsl:param name="IssueList-description"/>


        <xsl:variable name="msgType">serverMsg</xsl:variable>
        <!-- 
            This response is very weird 
            (it contains the Rx as an accept response just like a query response does) 
            to fudge the response we tell it is a query response so that it will create the correct format
        -->
        <xsl:variable name="msgAction">transferResponse</xsl:variable>


        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][not($patient-description) or patient/@description = $patient-description]"/>


        <xsl:variable name="prescriptionID" select="descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:supplyRequest/hl7:componentOf/hl7:actRequest/hl7:id/@extension"/>
        <xsl:variable name="PrescriptionData" select="$ProfileData/items/prescription[record-id/@server = $prescriptionID]"/>

        <PORX_IN010110CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">PORX_IN010110CA</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <controlActEvent classCode="CACT" moodCode="EVN">
                <xsl:call-template name="controlActStart">
                    <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                    <!-- This message does not have author data
                    <xsl:with-param name="supervisor-description" select="$PrescriptionData/supervisor/@description"/>
                    <xsl:with-param name="author-description" select="$PrescriptionData/author/@description"/>
                    <xsl:with-param name="location-description" select="$PrescriptionData/location/@description"/>
                    <xsl:with-param name="author-time" select="$PrescriptionData/author/@time"/>
                    <xsl:with-param name="ParticipationMode" select="$PrescriptionData/author/@ParticipationMode"/>
                    -->
                    <xsl:with-param name="TriggerEventCode">PORX_TE010330UV</xsl:with-param>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="msgAction" select="$msgAction"/>
                </xsl:call-template>

                <subject contextConductionInd="false">
                    <xsl:call-template name="Prescription">
                        <xsl:with-param name="description" select="$PrescriptionData/@description"/>
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

            </controlActEvent>

            <xsl:call-template name="transmissionWrapperEnd">
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

        </PORX_IN010110CA>
    </xsl:template>
    <xsl:template name="RxTransferRejectedResponse">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>
        <xsl:param name="IssueList-description"/>



        <xsl:variable name="msgType">serverMsg</xsl:variable>
        <xsl:variable name="msgAction">transgerResponse</xsl:variable>


        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][not($patient-description) or patient/@description = $patient-description]"/>

        <PORX_IN010120CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="RejectMessage">
                <xsl:with-param name="ProfileData" select="$ProfileData"/>
                <xsl:with-param name="interactionId">PORX_IN010120CA</xsl:with-param>
                <xsl:with-param name="TriggerEventCode">PORX_TE010150UV</xsl:with-param>
                <xsl:with-param name="IssueList-description" select="$IssueList-description"/>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </PORX_IN010120CA>
    </xsl:template>

    <!-- Stop Rx -->
    <xsl:template name="RxStopRequest">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>

        <xsl:param name="prescription-description"/>
        <xsl:param name="IssueList-description"/>

        <xsl:variable name="msgType">clientMsg</xsl:variable>
        <xsl:variable name="msgAction">transferRequest</xsl:variable>

        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][not($patient-description) or patient/@description = $patient-description]"/>
        <xsl:variable name="PrescriptionData" select="$ProfileData/items/prescription[@description=$prescription-description]"/>

        <PORX_IN010840CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">PORX_IN010840CA</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <controlActEvent classCode="CACT" moodCode="EVN">
                <xsl:call-template name="controlActStart">
                    <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                    <xsl:with-param name="supervisor-description" select="$PrescriptionData/supervisor/@description"/>
                    <xsl:with-param name="author-description" select="$PrescriptionData/author/@description"/>
                    <xsl:with-param name="location-description" select="$PrescriptionData/location/@description"/>
                    <xsl:with-param name="author-time" select="$PrescriptionData/author/@time"/>
                    <xsl:with-param name="ParticipationMode" select="$PrescriptionData/author/@ParticipationMode"/>
                    <xsl:with-param name="TriggerEventCode">PORX_TE010500UV</xsl:with-param>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="msgAction" select="$msgAction"/>
                </xsl:call-template>

                <subject contextConductionInd="false">
                    <xsl:call-template name="PrescriptionReferance">
                        <xsl:with-param name="description" select="$prescription-description"/>
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
                    <xsl:with-param name="author-description" select="$PrescriptionData/author/@description"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                </xsl:call-template>

            </controlActEvent>

            <xsl:call-template name="transmissionWrapperEnd">
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

        </PORX_IN010840CA>
        
        
    </xsl:template>
    <xsl:template name="RxStopAcceptedResponse">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>
        <xsl:param name="prescription-description"/>
        <xsl:param name="IssueList-description"/>


        <xsl:variable name="msgType">serverMsg</xsl:variable>
        <xsl:variable name="msgAction">addResponse</xsl:variable>


        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][not($patient-description) or patient/@description = $patient-description]"/>


        <PORX_IN010850CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="AcceptMessage-ActRequest">
                <xsl:with-param name="ProfileData" select="$ProfileData"/>
                <xsl:with-param name="record-id">
                    <xsl:call-template name="record-id">
                        <xsl:with-param name="Record" select="$ProfileData/items/prescription[@description=$prescription-description]/record-id"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </xsl:with-param>
                <xsl:with-param name="record-OID">DIS_PRESCRIPTION_ID</xsl:with-param>
                <xsl:with-param name="interactionId">PORX_IN010850CA</xsl:with-param>
                <xsl:with-param name="TriggerEventCode">PORX_TE010260UV</xsl:with-param>
                <xsl:with-param name="IssueList-description" select="$IssueList-description"/>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </PORX_IN010850CA>

    </xsl:template>
    <xsl:template name="RxStopRejectedResponse">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>
        <xsl:param name="prescription-description"/>
        <xsl:param name="IssueList-description"/>


        <xsl:variable name="msgType">serverMsg</xsl:variable>
        <xsl:variable name="msgAction">addResponse</xsl:variable>


        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][not($patient-description) or patient/@description = $patient-description]"/>


        <PORX_IN010860CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="AcceptMessage-ActRequest">
                <xsl:with-param name="ProfileData" select="$ProfileData"/>
                <xsl:with-param name="record-id">
                    <xsl:call-template name="record-id">
                        <xsl:with-param name="Record" select="$ProfileData/items/prescription[@description=$prescription-description]/record-id"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </xsl:with-param>
                <xsl:with-param name="record-OID">DIS_PRESCRIPTION_ID</xsl:with-param>
                <xsl:with-param name="interactionId">PORX_IN010860CA</xsl:with-param>
                <xsl:with-param name="TriggerEventCode">PORX_TE010040UV</xsl:with-param>
                <xsl:with-param name="IssueList-description" select="$IssueList-description"/>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </PORX_IN010860CA>

    </xsl:template>

    <!-- Hold Rx -->
    <xsl:template name="RxHoldRequest">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>

        <xsl:param name="prescription-description"/>
        <xsl:param name="IssueList-description"/>

        <xsl:variable name="msgType">clientMsg</xsl:variable>
        <xsl:variable name="msgAction">transferRequest</xsl:variable>

        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][not($patient-description) or patient/@description = $patient-description]"/>
        <xsl:variable name="PrescriptionData" select="$ProfileData/items/prescription[@description=$prescription-description]"/>

        <PORX_IN010440CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">PORX_IN010440CA</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <controlActEvent classCode="CACT" moodCode="EVN">
                <xsl:call-template name="controlActStart">
                    <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                    <xsl:with-param name="supervisor-description" select="$PrescriptionData/supervisor/@description"/>
                    <xsl:with-param name="author-description" select="$PrescriptionData/author/@description"/>
                    <xsl:with-param name="location-description" select="$PrescriptionData/location/@description"/>
                    <xsl:with-param name="author-time" select="$PrescriptionData/author/@time"/>
                    <xsl:with-param name="ParticipationMode" select="$PrescriptionData/author/@ParticipationMode"/>
                    <xsl:with-param name="TriggerEventCode">PORX_TE010420UV</xsl:with-param>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="msgAction" select="$msgAction"/>
                </xsl:call-template>

                <subject contextConductionInd="false">
                    <xsl:call-template name="PrescriptionReferance">
                        <xsl:with-param name="description" select="$prescription-description"/>
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
                    <xsl:with-param name="author-description" select="$PrescriptionData/author/@description"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                </xsl:call-template>

            </controlActEvent>

            <xsl:call-template name="transmissionWrapperEnd">
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

        </PORX_IN010440CA>
        
    </xsl:template>
    <xsl:template name="RxHoldAcceptedResponse">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>
        <xsl:param name="prescription-description"/>
        <xsl:param name="IssueList-description"/>


        <xsl:variable name="msgType">serverMsg</xsl:variable>
        <xsl:variable name="msgAction">addResponse</xsl:variable>


        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][not($patient-description) or patient/@description = $patient-description]"/>


        <PORX_IN010450CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="AcceptMessage-ActRequest">
                <xsl:with-param name="ProfileData" select="$ProfileData"/>
                <xsl:with-param name="record-id">
                    <xsl:call-template name="record-id">
                        <xsl:with-param name="Record" select="$ProfileData/items/prescription[@description=$prescription-description]/record-id"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </xsl:with-param>
                <xsl:with-param name="record-OID">DIS_PRESCRIPTION_ID</xsl:with-param>
                <xsl:with-param name="interactionId">PORX_IN010450CA</xsl:with-param>
                <xsl:with-param name="TriggerEventCode">PORX_TE010240UV</xsl:with-param>
                <xsl:with-param name="IssueList-description" select="$IssueList-description"/>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </PORX_IN010450CA>

    </xsl:template>
    <xsl:template name="RxHoldRejectedResponse">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>
        <xsl:param name="prescription-description"/>
        <xsl:param name="IssueList-description"/>


        <xsl:variable name="msgType">serverMsg</xsl:variable>
        <xsl:variable name="msgAction">addResponse</xsl:variable>


        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][not($patient-description) or patient/@description = $patient-description]"/>


        <PORX_IN010460CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="RejectMessage">
                <xsl:with-param name="ProfileData" select="$ProfileData"/>
                <xsl:with-param name="interactionId">PORX_IN010460CA</xsl:with-param>
                <xsl:with-param name="TriggerEventCode">PORX_TE010010UV</xsl:with-param>
                <xsl:with-param name="IssueList-description" select="$IssueList-description"/>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>            
        </PORX_IN010460CA>

    </xsl:template>

    <!-- Release Rx -->
    <xsl:template name="RxReleaseRequest">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>

        <xsl:param name="prescription-description"/>
        <xsl:param name="IssueList-description"/>

        <xsl:variable name="msgType">clientMsg</xsl:variable>
        <xsl:variable name="msgAction">transferRequest</xsl:variable>

        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][not($patient-description) or patient/@description = $patient-description]"/>
        <xsl:variable name="PrescriptionData" select="$ProfileData/items/prescription[@description=$prescription-description]"/>

        <PORX_IN010520CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">PORX_IN010520CA</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <controlActEvent classCode="CACT" moodCode="EVN">
                <xsl:call-template name="controlActStart">
                    <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                    <xsl:with-param name="supervisor-description" select="$PrescriptionData/supervisor/@description"/>
                    <xsl:with-param name="author-description" select="$PrescriptionData/author/@description"/>
                    <xsl:with-param name="location-description" select="$PrescriptionData/location/@description"/>
                    <xsl:with-param name="author-time" select="$PrescriptionData/author/@time"/>
                    <xsl:with-param name="ParticipationMode" select="$PrescriptionData/author/@ParticipationMode"/>
                    <xsl:with-param name="TriggerEventCode">PORX_TE010480UV</xsl:with-param>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="msgAction" select="$msgAction"/>
                </xsl:call-template>

                <subject contextConductionInd="false">
                    <xsl:call-template name="PrescriptionReferance">
                        <xsl:with-param name="description" select="$prescription-description"/>
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
                    <xsl:with-param name="author-description" select="$PrescriptionData/author/@description"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                </xsl:call-template>

            </controlActEvent>

            <xsl:call-template name="transmissionWrapperEnd">
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

        </PORX_IN010520CA>
        
        
    </xsl:template>
    <xsl:template name="RxReleaseAcceptedResponse">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>
        <xsl:param name="prescription-description"/>
        <xsl:param name="IssueList-description"/>


        <xsl:variable name="msgType">serverMsg</xsl:variable>
        <xsl:variable name="msgAction">addResponse</xsl:variable>


        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][not($patient-description) or patient/@description = $patient-description]"/>


        <PORX_IN010530CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="AcceptMessage-ActRequest">
                <xsl:with-param name="ProfileData" select="$ProfileData"/>
                <xsl:with-param name="record-id">
                    <xsl:call-template name="record-id">
                        <xsl:with-param name="Record" select="$ProfileData/items/prescription[@description=$prescription-description]/record-id"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </xsl:with-param>
                <xsl:with-param name="record-OID">DIS_PRESCRIPTION_ID</xsl:with-param>
                <xsl:with-param name="interactionId">PORX_IN010530CA</xsl:with-param>
                <xsl:with-param name="TriggerEventCode">PORX_TE010250UV</xsl:with-param>
                <xsl:with-param name="IssueList-description" select="$IssueList-description"/>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </PORX_IN010530CA>

    </xsl:template>
    <xsl:template name="RxReleaseRejectedResponse">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>
        <xsl:param name="prescription-description"/>
        <xsl:param name="IssueList-description"/>


        <xsl:variable name="msgType">serverMsg</xsl:variable>
        <xsl:variable name="msgAction">addResponse</xsl:variable>


        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][not($patient-description) or patient/@description = $patient-description]"/>


        <PORX_IN010540CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="AcceptMessage-ActRequest">
                <xsl:with-param name="ProfileData" select="$ProfileData"/>
                <xsl:with-param name="record-id">
                    <xsl:call-template name="record-id">
                        <xsl:with-param name="Record" select="$ProfileData/items/prescription[@description=$prescription-description]/record-id"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </xsl:with-param>
                <xsl:with-param name="record-OID">DIS_PRESCRIPTION_ID</xsl:with-param>
                <xsl:with-param name="interactionId">PORX_IN010540CA</xsl:with-param>
                <xsl:with-param name="TriggerEventCode">PORX_TE010030UV</xsl:with-param>
                <xsl:with-param name="IssueList-description" select="$IssueList-description"/>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </PORX_IN010540CA>

    </xsl:template>

    <!-- Abort Dispensing for Rx -->
    <xsl:template name="RxAbortDispensingRequest">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>

        <xsl:param name="prescription-description"/>
        <xsl:param name="IssueList-description"/>

        <xsl:variable name="msgType">clientMsg</xsl:variable>
        <xsl:variable name="msgAction">transferRequest</xsl:variable>

        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][not($patient-description) or patient/@description = $patient-description]"/>
        <xsl:variable name="PrescriptionData" select="$ProfileData/items/prescription[@description=$prescription-description]"/>

        <PORX_IN010560CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">PORX_IN010560CA</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <controlActEvent classCode="CACT" moodCode="EVN">
                <xsl:call-template name="controlActStart">
                    <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                    <xsl:with-param name="supervisor-description" select="$PrescriptionData/supervisor/@description"/>
                    <xsl:with-param name="author-description" select="$PrescriptionData/author/@description"/>
                    <xsl:with-param name="location-description" select="$PrescriptionData/location/@description"/>
                    <xsl:with-param name="author-time" select="$PrescriptionData/author/@time"/>
                    <xsl:with-param name="ParticipationMode" select="$PrescriptionData/author/@ParticipationMode"/>
                    <xsl:with-param name="TriggerEventCode">PORX_TE010490UV</xsl:with-param>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="msgAction" select="$msgAction"/>
                </xsl:call-template>

                <subject contextConductionInd="false">
                    <xsl:call-template name="PrescriptionReferance">
                        <xsl:with-param name="description" select="$prescription-description"/>
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
                    <xsl:with-param name="author-description" select="$PrescriptionData/author/@description"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                </xsl:call-template>

            </controlActEvent>

            <xsl:call-template name="transmissionWrapperEnd">
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

        </PORX_IN010560CA>
        
        
    </xsl:template>
    <xsl:template name="RxAbortDispensingAcceptedResponse">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>
        <xsl:param name="prescription-description"/>
        <xsl:param name="IssueList-description"/>


        <xsl:variable name="msgType">serverMsg</xsl:variable>
        <xsl:variable name="msgAction">addResponse</xsl:variable>


        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][not($patient-description) or patient/@description = $patient-description]"/>


        <PORX_IN010570CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="AcceptMessage-ActRequest">
                <xsl:with-param name="ProfileData" select="$ProfileData"/>
                <xsl:with-param name="record-id">
                    <xsl:call-template name="record-id">
                        <xsl:with-param name="Record" select="$ProfileData/items/prescription[@description=$prescription-description]/record-id"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </xsl:with-param>
                <xsl:with-param name="record-OID">DIS_PRESCRIPTION_ID</xsl:with-param>
                <xsl:with-param name="interactionId">PORX_IN010570CA</xsl:with-param>
                <xsl:with-param name="TriggerEventCode">PORX_TE010600UV</xsl:with-param>
                <xsl:with-param name="IssueList-description" select="$IssueList-description"/>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </PORX_IN010570CA>

    </xsl:template>
    <xsl:template name="RxAbortDispensingRejectedResponse">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>
        <xsl:param name="prescription-description"/>
        <xsl:param name="IssueList-description"/>


        <xsl:variable name="msgType">serverMsg</xsl:variable>
        <xsl:variable name="msgAction">addResponse</xsl:variable>


        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][not($patient-description) or patient/@description = $patient-description]"/>


        <PORX_IN010580CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="AcceptMessage-ActRequest">
                <xsl:with-param name="ProfileData" select="$ProfileData"/>
                <xsl:with-param name="record-id">
                    <xsl:call-template name="record-id">
                        <xsl:with-param name="Record" select="$ProfileData/items/prescription[@description=$prescription-description]/record-id"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </xsl:with-param>
                <xsl:with-param name="record-OID">DIS_PRESCRIPTION_ID</xsl:with-param>
                <xsl:with-param name="interactionId">PORX_IN010580CA</xsl:with-param>
                <xsl:with-param name="TriggerEventCode">PORX_TE010160UV</xsl:with-param>
                <xsl:with-param name="IssueList-description" select="$IssueList-description"/>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </PORX_IN010580CA>

    </xsl:template>
    
    
    <!-- Refusal to fill Rx -->
    <xsl:template name="RxRefusalToFillRequest">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>
        
        <xsl:param name="reason-code"/>
        <xsl:param name="reason-text"/>

        <xsl:param name="prescription-description"/>
        <xsl:param name="IssueList-description"/>

        <xsl:variable name="msgType">clientMsg</xsl:variable>
        <xsl:variable name="msgAction">transferRequest</xsl:variable>

        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][not($patient-description) or patient/@description = $patient-description]"/>
        <xsl:variable name="PrescriptionData" select="$ProfileData/items/prescription[@description=$prescription-description]"/>

        <PORX_IN010060CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">PORX_IN010060CA</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <controlActEvent classCode="CACT" moodCode="EVN">
                <xsl:call-template name="controlActStart">
                    <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                    <xsl:with-param name="supervisor-description" select="$PrescriptionData/supervisor/@description"/>
                    <xsl:with-param name="author-description" select="$PrescriptionData/author/@description"/>
                    <xsl:with-param name="location-description" select="$PrescriptionData/location/@description"/>
                    <xsl:with-param name="author-time" select="$PrescriptionData/author/@time"/>
                    <xsl:with-param name="ParticipationMode" select="$PrescriptionData/author/@ParticipationMode"/>
                    <xsl:with-param name="TriggerEventCode">PORX_TE010460UV</xsl:with-param>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="msgAction" select="$msgAction"/>
                    <xsl:with-param name="reason-code" select="$reason-code"/>
                    <xsl:with-param name="reason-text" select="$reason-text"/>
                </xsl:call-template>

                <subject contextConductionInd="false">
                    <xsl:call-template name="PrescriptionReferance">
                        <xsl:with-param name="description" select="$prescription-description"/>
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
                    <xsl:with-param name="author-description" select="$PrescriptionData/author/@description"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                </xsl:call-template>

            </controlActEvent>

            <xsl:call-template name="transmissionWrapperEnd">
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

        </PORX_IN010060CA>
        
        
    </xsl:template>
    <xsl:template name="RxRefusalToFillAcceptedResponse">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>
        <xsl:param name="prescription-description"/>
        <xsl:param name="IssueList-description"/>


        <xsl:variable name="msgType">serverMsg</xsl:variable>
        <xsl:variable name="msgAction">addResponse</xsl:variable>


        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][not($patient-description) or patient/@description = $patient-description]"/>


        <PORX_IN010070CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="AcceptMessage-ActRequest">
                <xsl:with-param name="ProfileData" select="$ProfileData"/>
                <xsl:with-param name="record-id">
                    <xsl:call-template name="record-id">
                        <xsl:with-param name="Record" select="$ProfileData/items/prescription[@description=$prescription-description]/record-id"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </xsl:with-param>
                <xsl:with-param name="record-OID">DIS_PRESCRIPTION_ID</xsl:with-param>
                <xsl:with-param name="interactionId">PORX_IN010070CA</xsl:with-param>
                <xsl:with-param name="TriggerEventCode">PORX_TE010340UV</xsl:with-param>
                <xsl:with-param name="IssueList-description" select="$IssueList-description"/>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </PORX_IN010070CA>

    </xsl:template>
    <xsl:template name="RxRefusalToFillRejectedResponse">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>
        <xsl:param name="prescription-description"/>
        <xsl:param name="IssueList-description"/>


        <xsl:variable name="msgType">serverMsg</xsl:variable>
        <xsl:variable name="msgAction">addResponse</xsl:variable>


        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][not($patient-description) or patient/@description = $patient-description]"/>


        <PORX_IN010080CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="AcceptMessage-ActRequest">
                <xsl:with-param name="ProfileData" select="$ProfileData"/>
                <xsl:with-param name="record-id">
                    <xsl:call-template name="record-id">
                        <xsl:with-param name="Record" select="$ProfileData/items/prescription[@description=$prescription-description]/record-id"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </xsl:with-param>
                <xsl:with-param name="record-OID">DIS_PRESCRIPTION_ID</xsl:with-param>
                <xsl:with-param name="interactionId">PORX_IN010080CA</xsl:with-param>
                <xsl:with-param name="TriggerEventCode">PORX_TE010020UV</xsl:with-param>
                <xsl:with-param name="IssueList-description" select="$IssueList-description"/>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </PORX_IN010080CA>

    </xsl:template>
    
</xsl:stylesheet>
