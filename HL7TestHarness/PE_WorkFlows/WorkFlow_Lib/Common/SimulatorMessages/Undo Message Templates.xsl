<?xml version="1.0" encoding="UTF-8"?>
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->  <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="urn:hl7-org:v3" xmlns:hl7="urn:hl7-org:v3" version="1.0">
    <xsl:include href="../Lib/MsgCreation_Lib.xsl"/>

    <!-- Undo Messages -->
    <!-- requires author, etc because the person undoing the action may not be the person that did the action. -->
    <xsl:template name="undoItemRequest">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>     <xsl:param name="patient-description"/>         <xsl:param name="msg-effective-time"/>
       
        <xsl:param name="author-description"/>
        <xsl:param name="supervisor-description"/>
        <xsl:param name="location-description"/>
        <xsl:param name="ParticipationMode"/>
        <xsl:param name="author-time"/>
        <xsl:param name="IssueList-description"/>

        <xsl:variable name="msgType">clientMsg</xsl:variable>
        <xsl:variable name="msgAction">undoRequest</xsl:variable>

        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][not($patient-description) or patient/@description = $patient-description]"/>
        
        
        <COMT_IN600001CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">COMT_IN600001CA</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>



            <controlActEvent classCode="CACT" moodCode="EVN">
                <xsl:call-template name="controlActStart">                     <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                    <xsl:with-param name="supervisor-description" select="$supervisor-description"/>
                    <xsl:with-param name="author-description" select="$author-description"/>
                    <xsl:with-param name="location-description" select="$location-description"/>
                    <xsl:with-param name="author-time" select="$author-time"/>
                    <xsl:with-param name="ParticipationMode" select="$ParticipationMode"/>
                    <xsl:with-param name="TriggerEventCode">COMT_TE600003UV</xsl:with-param>
                    <xsl:with-param name="msgType" select="$msgType"/>
                    <xsl:with-param name="msgAction" select="$msgAction"/>
                </xsl:call-template>

                
                <subject  contextConductionInd="false">
                    <actEvent>
                        <!-- the id of the created reaction -->
                        <id root="" extension="">
                            <xsl:call-template name="getClientOIDByName">
                                <xsl:with-param name="OID_Name">PORTAL_CONTROL_ACT_ID</xsl:with-param>
                            </xsl:call-template>

                            <!-- THIS ID SHOULD BE UPDATED USING VAR's IN THE WORKFLOW -->

                            <!-- TODO: 
                                This does not seem to work correctly for some reason. 
                                This is not a big issue as the id should be gotten with the workflow so that we make sure we are undoing the correct message -->
                            <!-- 
                            <xsl:variable name="undoItemName" select="name($UndoData)"/>
                            <xsl:choose>
                                <xsl:when test="$undoItemName = 'allergy'">
                                    <xsl:variable name="message" select="$AllClientRequests/child::*[local-name() = 'REPC_IN000012CA'  or local-name() = 'REPC_IN000020CA'][position() = last()]/descendant-or-self::hl7:controlActEvent/hl7id"/>
                                    <xsl:attribute name="root"><xsl:value-of select="$message/@root"/></xsl:attribute>
                                    <xsl:attribute name="extension"><xsl:value-of select="$message/@extension"/></xsl:attribute>
                                </xsl:when>
                                <xsl:when test="$undoItemName = 'reaction'">
                                    <xsl:variable name="message" select="$AllClientRequests/child::node()[local-name() = 'REPC_IN000004CA'  or local-name() = 'REPC_IN000008CA'][position() = last()]/descendant-or-self::hl7:controlActEvent/hl7id"/>
                                    <xsl:attribute name="root"><xsl:value-of select="$message/@root"/></xsl:attribute>
                                    <xsl:attribute name="extension"><xsl:value-of select="$message/@extension"/></xsl:attribute>
                                </xsl:when>
                                <xsl:when test="$undoItemName = 'immunization'">
                                    <xsl:variable name="message" select="$AllClientRequests/child::node()[local-name() = 'POIZ_IN010020CA'  or local-name() = 'POIZ_IN010100CA' or local-name() = 'POIZ_IN010070CA'][position() = last()]/descendant-or-self::hl7:controlActEvent/hl7id"/>
                                    <xsl:attribute name="root"><xsl:value-of select="$message/@root"/></xsl:attribute>
                                    <xsl:attribute name="extension"><xsl:value-of select="$message/@extension"/></xsl:attribute>
                                </xsl:when>
                                <xsl:when test="$undoItemName = 'condition'">
                                    <xsl:variable name="message" select="$AllClientRequests/child::node()[local-name() = 'REPC_IN000028CA'  or local-name() = 'REPC_IN000032CA'][position() = last()]/descendant-or-self::hl7:controlActEvent/hl7id"/>
                                    <xsl:attribute name="root"><xsl:value-of select="$message/@root"/></xsl:attribute>
                                    <xsl:attribute name="extension"><xsl:value-of select="$message/@extension"/></xsl:attribute>
                                </xsl:when>
                                <xsl:when test="$undoItemName = 'observation'">
                                    <xsl:variable name="message" select="$AllClientRequests/child::node()[local-name() = 'REPC_IN000051CA'][position() = last()]/descendant-or-self::hl7:controlActEvent/hl7id"/>
                                    <xsl:attribute name="root"><xsl:value-of select="$message/@root"/></xsl:attribute>
                                    <xsl:attribute name="extension"><xsl:value-of select="$message/@extension"/></xsl:attribute>
                                </xsl:when>
                                <xsl:when test="$undoItemName = 'otherMedication'">
                                    <xsl:variable name="message" select="$AllClientRequests/child::node()[local-name() = 'PORX_IN040020CA' or local-name() = 'PORX_IN040070CA'][position() = last()]/descendant-or-self::hl7:controlActEvent/hl7id"/>
                                    <xsl:attribute name="root"><xsl:value-of select="$message/@root"/></xsl:attribute>
                                    <xsl:attribute name="extension"><xsl:value-of select="$message/@extension"/></xsl:attribute>
                                </xsl:when>
                                <xsl:when test="$undoItemName = 'prescription'">
                                </xsl:when>
                                <xsl:when test="$undoItemName = 'dispense'">
                                    <xsl:variable name="message" select="$AllClientRequests/child::node()[local-name() = 'PORX_IN020080CA' or local-name() = 'PORX_IN020190CA' or local-name()  ='PORX_IN020370CA' or local-name() = 'PORX_IN010100CA'][position() = last()]/descendant-or-self::hl7:controlActEvent/hl7id"/>
                                    <xsl:attribute name="root"><xsl:value-of select="$message/@root"/></xsl:attribute>
                                    <xsl:attribute name="extension"><xsl:value-of select="$message/@extension"/></xsl:attribute>
                                </xsl:when>
                                <xsl:when test="$undoItemName = 'note'">
                                    <xsl:variable name="message" select="$AllClientRequests/child::node()[local-name() = 'COMT_IN301001CA' or local-name() = 'COMT_IN300001CA' or local-name()  ='COMT_IN300101CA'][position() = last()]/descendant-or-self::hl7:controlActEvent/hl7id"/>
                                    <xsl:attribute name="root"><xsl:value-of select="$message/@root"/></xsl:attribute>
                                    <xsl:attribute name="extension"><xsl:value-of select="$message/@extension"/></xsl:attribute>
                                </xsl:when>
                                <xsl:when test="$undoItemName = 'refusalToFill'">
                                    <xsl:variable name="message" select="$AllClientRequests/child::node()[local-name() = 'PORX_IN020370CA'][position() = last()]/descendant-or-self::hl7:controlActEvent/hl7id"/>
                                    <xsl:attribute name="root"><xsl:value-of select="$message/@root"/></xsl:attribute>
                                    <xsl:attribute name="extension"><xsl:value-of select="$message/@extension"/></xsl:attribute>
                                </xsl:when>
                                <xsl:when test="$undoItemName = 'issue'">
                                    <xsl:variable name="message" select="$AllClientRequests/child::node()[local-name() = 'COMT_IN700001CA' ][position() = last()]/descendant-or-self::hl7:controlActEvent/hl7id"/>
                                    <xsl:attribute name="root"><xsl:value-of select="$message/@root"/></xsl:attribute>
                                    <xsl:attribute name="extension"><xsl:value-of select="$message/@extension"/></xsl:attribute>
                                </xsl:when>
                                </xsl:choose>
                            -->
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
        </COMT_IN600001CA>
    </xsl:template>
    
    <xsl:template name="undoItemAcceptedResponse">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>     <xsl:param name="patient-description"/>         <xsl:param name="msg-effective-time"/>
        <xsl:param name="IssueList-description"/>
        
        <xsl:variable name="msgType">serverMsg</xsl:variable>
        <xsl:variable name="msgAction">removeResponse</xsl:variable>

        <xsl:variable name="patient_description">
            <xsl:call-template name="getPatientNameByID">
                <xsl:with-param name="node" select="descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:*/hl7:recordTarget/hl7:patient/hl7:id"/>
            </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][patient/@description = $patient_description]"/>
        
        <COMT_IN600002CA xmlns="urn:hl7-org:v3"  ITSVersion="XML_1.0">
            <xsl:call-template name="AcceptMessage">
                <xsl:with-param name="ProfileData" select="$ProfileData"/>
                <xsl:with-param name="record-extension"><xsl:value-of select="descendant-or-self::hl7:subject/hl7:actEvent/hl7:id/@extension"/></xsl:with-param>
                <xsl:with-param name="record-root"><xsl:value-of select="descendant-or-self::hl7:subject/hl7:actEvent/hl7:id/@root"/></xsl:with-param>
                <xsl:with-param name="interactionId">COMT_IN600002CA</xsl:with-param>
                <xsl:with-param name="TriggerEventCode">COMT_TE600001UV</xsl:with-param>
                <xsl:with-param name="IssueList-description" select="$IssueList-description"/>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </COMT_IN600002CA>
        
    </xsl:template>
    <xsl:template name="undoItemRejectedResponse">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>     <xsl:param name="patient-description"/>         <xsl:param name="msg-effective-time"/>
        <xsl:param name="IssueList-description"/>
        
        <xsl:variable name="msgType">serverMsg</xsl:variable>
        <xsl:variable name="msgAction">removeResponse</xsl:variable>

        <xsl:variable name="patient_description">
            <xsl:call-template name="getPatientNameByID">
                <xsl:with-param name="node" select="descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:*/hl7:recordTarget/hl7:patient/hl7:id"/>
            </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][patient/@description = $patient_description]"/>
        
        <COMT_IN600003CA xmlns="urn:hl7-org:v3"  ITSVersion="XML_1.0">
            <xsl:call-template name="AcceptMessage">
                <xsl:with-param name="ProfileData" select="$ProfileData"/>
                <xsl:with-param name="record-extension"><xsl:value-of select="descendant-or-self::hl7:subject/hl7:actEvent/hl7:id/@extension"/></xsl:with-param>
                <xsl:with-param name="record-root"><xsl:value-of select="descendant-or-self::hl7:subject/hl7:actEvent/hl7:id/@root"/></xsl:with-param>
                <xsl:with-param name="interactionId">COMT_IN600003CA</xsl:with-param>
                <xsl:with-param name="TriggerEventCode">COMT_TE600002UV</xsl:with-param>
                <xsl:with-param name="IssueList-description" select="$IssueList-description"/>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </COMT_IN600003CA>
        
    </xsl:template>
    
</xsl:stylesheet>
