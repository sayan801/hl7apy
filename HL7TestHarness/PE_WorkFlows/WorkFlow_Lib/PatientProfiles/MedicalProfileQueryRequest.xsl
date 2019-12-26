<?xml version="1.0" encoding="UTF-8"?>
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->  <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns="urn:hl7-org:v3" version="1.0">

    <xsl:include href="../Common/SimulatorMessages/Medical Profile Message Templates.xsl"/>
    
    <xsl:param name="profile-description"/>     <xsl:param name="useOverRide"/>
    <xsl:param name="profile-sequence"/>     <xsl:param name="patient-description"/>         <xsl:param name="msg-effective-time"/>
   
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
    
    <xsl:template match="/">         <xsl:call-template name="SoapWapper"/>     </xsl:template>         
    <xsl:template match="/" mode="message"> 
        <xsl:call-template name="MedicalProfileDetailQueryRequest">
            <xsl:with-param name="profile-description" select="$profile-description"/>
            <xsl:with-param name="profile-sequence" select="$profile-sequence"/>             <xsl:with-param name="patient-description" select="$patient-description"/>             <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
            
            <xsl:with-param name="author-description" select="$author-description"/>
            <xsl:with-param name="supervisor-description" select="$supervisor-description"/>
            <xsl:with-param name="location-description" select="$location-description"/>
            <xsl:with-param name="ParticipationMode" select="$ParticipationMode"/>
            <xsl:with-param name="author-time" select="$author-time"/>
            <xsl:with-param name="query-id" select="$query-id"/>
            <xsl:with-param name="administrationEffectiveStartDate" select="$administrationEffectiveStartDate"/>
            <xsl:with-param name="administrationEffectiveEndDate" select="$administrationEffectiveEndDate"/>
            <xsl:with-param name="eventEffectiveStartDate" select="$eventEffectiveStartDate"/>
            <xsl:with-param name="eventEffectiveEndDate" select="$eventEffectiveEndDate"/>
            <xsl:with-param name="mostRecentDrugIndicator" select="$mostRecentDrugIndicator"/>
            <xsl:with-param name="diagnosisCode" select="$diagnosisCode"/>
            <xsl:with-param name="diagnosisCodeSystem" select="$diagnosisCodeSystem"/>
            <xsl:with-param name="drugCode" select="$drugCode"/>
            <xsl:with-param name="drugCodeSystem" select="$drugCodeSystem"/>
            <xsl:with-param name="includeHistory" select="$includeHistory"/>
            <xsl:with-param name="includeIssues" select="$includeIssues"/>
            <xsl:with-param name="includeNotes" select="$includeNotes"/>
            <xsl:with-param name="includePendingChanges" select="$includePendingChanges"/>
            <xsl:with-param name="otherIndicationCode" select="$otherIndicationCode"/>
            <xsl:with-param name="otherIndicationCodeSystem" select="$otherIndicationCodeSystem"/>
            <xsl:with-param name="symptomCode" select="$symptomCode"/>
            <xsl:with-param name="symptomCodeSystem" select="$symptomCodeSystem"/>
            
        <xsl:with-param name="useOverRide" select="$useOverRide"/>         </xsl:call-template>
    </xsl:template>
    
        
    
</xsl:stylesheet>
