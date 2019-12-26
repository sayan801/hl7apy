<?xml version="1.0" encoding="UTF-8"?>
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->  <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:include href="../Common/SimulatorMessages/Find Candidate Message Templates.xsl"/>

    <!-- define patient with either the profile or the description -->
    <xsl:param name="profile-description"/>
    <xsl:param name="profile-sequence" />
    <!-- OR  -->
   
    
    <xsl:param name="patient-description"/>
    <xsl:param name="by-phn"/>
    <xsl:param name="by-birthdate"/>
    <xsl:param name="by-gender"/>
    <xsl:param name="by-given-name"/>
    <xsl:param name="by-family-name"/>
    <xsl:param name="query-id"/>
    
    <xsl:template match="/">         <xsl:call-template name="SoapWapper"/>     </xsl:template>          <xsl:template match="/" mode="message"> 

        <xsl:variable name="patient">
        <xsl:choose>
            <xsl:when test="$patient-description"><xsl:value-of select="$patient-description"/></xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence]/patient/@description"/>
            </xsl:otherwise>
        </xsl:choose>
        </xsl:variable>
        
        <xsl:call-template name="findCandidateQueryRequest">
            <xsl:with-param name="patient-description" select="$patient"/>
            <xsl:with-param name="by-given-name" select="$by-given-name"/>
            <xsl:with-param name="by-family-name" select="$by-family-name"/>
            <xsl:with-param name="by-phn" select="$by-phn"/>
            <xsl:with-param name="by-birthdate" select="$by-birthdate"/>
            <xsl:with-param name="by-gender" select="$by-gender"/>
            <xsl:with-param name="query-id" select="$query-id"/>
        </xsl:call-template>
        
            
    </xsl:template>
    
</xsl:stylesheet>
