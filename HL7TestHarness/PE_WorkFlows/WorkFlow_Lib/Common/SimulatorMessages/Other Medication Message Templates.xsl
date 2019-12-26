<?xml version="1.0" encoding="UTF-8"?>
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->  <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="urn:hl7-org:v3" xmlns:hl7="urn:hl7-org:v3" version="1.0">
    <xsl:include href="../Lib/MsgCreation_Lib.xsl"/>


    <!-- Add Messages -->
    <xsl:template name="otherMedicationAddRequest">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>     <xsl:param name="patient-description"/>         <xsl:param name="msg-effective-time"/>
       
        <xsl:param name="otherMedication-description"/>
        <xsl:param name="IssueList-description"/>

        <xsl:variable name="msgType">clientMsg</xsl:variable>
        <xsl:variable name="msgAction">addRequest</xsl:variable>

        
        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][not($patient-description) or patient/@description = $patient-description]"/>
        <xsl:variable name="otherMedicationData" select="$ProfileData/descendant::items/otherMedication[@description=$otherMedication-description]"/>
        
        <PORX_IN040020CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">PORX_IN040020CA</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <controlActEvent classCode="CACT" moodCode="EVN">
                <xsl:call-template name="controlActStart">                     <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                    <xsl:with-param name="supervisor-description" select="$otherMedicationData/supervisor/@description"/>
                    <xsl:with-param name="author-description" select="$otherMedicationData/author/@description"/>
                    <xsl:with-param name="location-description" select="$otherMedicationData/location/@description"/>
                    <xsl:with-param name="author-time" select="$otherMedicationData/author/@time"/>
                    <xsl:with-param name="ParticipationMode" select="$otherMedicationData/author/@ParticipationMode"/>
                    <xsl:with-param name="TriggerEventCode">PORX_TE040060UV</xsl:with-param>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="msgAction" select="$msgAction"/>
                </xsl:call-template>

                <subject contextConductionInd="false">
                    <xsl:call-template name="otherMedication">
                        <xsl:with-param name="description" select="$otherMedication-description"/>
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
                    <xsl:with-param name="author-description" select="$otherMedicationData/author/@description"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                </xsl:call-template>
            
            </controlActEvent>

            <xsl:call-template name="transmissionWrapperEnd">
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

        </PORX_IN040020CA>

    </xsl:template>
    <xsl:template name="otherMedicationAddAcceptedResponse">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>     <xsl:param name="patient-description"/>         <xsl:param name="msg-effective-time"/>
        <xsl:param name="otherMedication-description"/>
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
                <xsl:when test="$otherMedication-description and not($otherMedication-description = '')"><xsl:value-of select="$otherMedication-description"/></xsl:when>
                <xsl:otherwise>otherMedication(NEW_ITEM)</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <PORX_IN040030CA xmlns="urn:hl7-org:v3"  ITSVersion="XML_1.0">
            <xsl:call-template name="AcceptMessage">
                <xsl:with-param name="ProfileData" select="$ProfileData"/>
                <xsl:with-param name="record-id" select="$ProfileData/descendant::items/otherMedication[@description=$description]/record-id"/>
                <xsl:with-param name="interactionId">PORX_IN040030CA</xsl:with-param>
                <xsl:with-param name="TriggerEventCode">PORX_TE040030UV</xsl:with-param>
                <xsl:with-param name="IssueList-description" select="$IssueList-description"/>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </PORX_IN040030CA>
    </xsl:template>
    <xsl:template name="otherMedicationAddRejectedResponse">
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
        
        <PORX_IN040040CA xmlns="urn:hl7-org:v3"  ITSVersion="XML_1.0">
            <xsl:call-template name="RejectMessage">
                <xsl:with-param name="ProfileData" select="$ProfileData"/>
                <xsl:with-param name="interactionId">PORX_IN040040CA</xsl:with-param>
                <xsl:with-param name="TriggerEventCode">PORX_TE040010UV</xsl:with-param>
                <xsl:with-param name="IssueList-description" select="$IssueList-description"/>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </PORX_IN040040CA>
    </xsl:template>

    <!-- Update Messages -->
    <xsl:template name="otherMedicationUpdateRequest">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>     <xsl:param name="patient-description"/>         <xsl:param name="msg-effective-time"/>
       
        <xsl:param name="otherMedication-description"/>
        <xsl:param name="IssueList-description"/>

        <xsl:variable name="msgType">clientMsg</xsl:variable>
        <xsl:variable name="msgAction">updateRequest</xsl:variable>

        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][not($patient-description) or patient/@description = $patient-description]"/>
        <xsl:variable name="otherMedicationData" select="$ProfileData/descendant::items/otherMedication[@description=$otherMedication-description]"/>
        
        <PORX_IN040070CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">PORX_IN040070CA</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <controlActEvent classCode="CACT" moodCode="EVN">
                <xsl:call-template name="controlActStart">                     <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                    <xsl:with-param name="supervisor-description" select="$otherMedicationData/supervisor/@description"/>
                    <xsl:with-param name="author-description" select="$otherMedicationData/author/@description"/>
                    <xsl:with-param name="location-description" select="$otherMedicationData/location/@description"/>
                    <xsl:with-param name="author-time" select="$otherMedicationData/author/@time"/>
                    <xsl:with-param name="ParticipationMode" select="$otherMedicationData/author/@ParticipationMode"/>
                    <xsl:with-param name="TriggerEventCode">PORX_TE040070UV</xsl:with-param>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="msgAction" select="$msgAction"/>
                </xsl:call-template>

                <subject contextConductionInd="false">
                    <xsl:call-template name="otherMedication">
                        <xsl:with-param name="description" select="$otherMedication-description"/>
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
                    <xsl:with-param name="author-description" select="$otherMedicationData/author/@description"/>
                    <xsl:with-param name="msgType" select="$msgType"/>
                </xsl:call-template>
            
            </controlActEvent>

            <xsl:call-template name="transmissionWrapperEnd">
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </PORX_IN040070CA>
    </xsl:template>
    <xsl:template name="otherMedicationUpdateAcceptedResponse">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>     <xsl:param name="patient-description"/>         <xsl:param name="msg-effective-time"/>
        <xsl:param name="otherMedication-description"/>
        <xsl:param name="IssueList-description"/>
        
        <xsl:variable name="msgType">serverMsg</xsl:variable>
        <xsl:variable name="msgAction">updateResponse</xsl:variable>

        <xsl:variable name="patient_description">
            <xsl:call-template name="getPatientNameByID">
                <xsl:with-param name="node" select="descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:*/hl7:subject/hl7:patient/hl7:id"/>
            </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][patient/@description = $patient_description]"/>
        
        <xsl:variable name="id" select="descendant-or-self::hl7:otherMedication/hl7:id/@extension"/>
        <xsl:variable name="record-id" select="$ProfileData/items/otherMedication/record-id[@server = $id]"></xsl:variable>
        
        <PORX_IN040080CA xmlns="urn:hl7-org:v3"  ITSVersion="XML_1.0">
            <xsl:call-template name="AcceptMessage">
                <xsl:with-param name="ProfileData" select="$ProfileData"/>
                <xsl:with-param name="record-id" select="$record-id"/>
                <xsl:with-param name="interactionId">PORX_IN040080CA</xsl:with-param>
                <xsl:with-param name="TriggerEventCode">PORX_TE040040UV</xsl:with-param>
                <xsl:with-param name="IssueList-description" select="$IssueList-description"/>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </PORX_IN040080CA>
        
    </xsl:template>
    <xsl:template name="otherMedicationUpdateRejectedResponse">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>     <xsl:param name="patient-description"/>         <xsl:param name="msg-effective-time"/>
        <xsl:param name="IssueList-description"/>
        
        <xsl:variable name="msgType">serverMsg</xsl:variable>
        <xsl:variable name="msgAction">updateResponse</xsl:variable>

        <xsl:variable name="patient_description">
            <xsl:call-template name="getPatientNameByID">
                <xsl:with-param name="node" select="descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:*/hl7:subject/hl7:patient/hl7:id"/>
            </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][patient/@description = $patient_description]"/>
        
        <PORX_IN040090CA xmlns="urn:hl7-org:v3"  ITSVersion="XML_1.0">
            <xsl:call-template name="RejectMessage">
                <xsl:with-param name="ProfileData" select="$ProfileData"/>
                <xsl:with-param name="interactionId">PORX_IN040090CA</xsl:with-param>
                <xsl:with-param name="TriggerEventCode">PORX_TE040020UV</xsl:with-param>
                <xsl:with-param name="IssueList-description" select="$IssueList-description"/>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </PORX_IN040090CA>
    </xsl:template>

</xsl:stylesheet>
