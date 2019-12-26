<?xml version="1.0" encoding="UTF-8"?>
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->  <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:include href="../Common/SimulatorMessages/Annotation Message Templates.xsl"/>
    <xsl:param name="profile-description"/>
    <xsl:param name="profile-sequence"/>     <xsl:param name="patient-description"/>         <xsl:param name="msg-effective-time"/>
    <xsl:param name="IssueList-description"/>
    
    <xsl:template match="/">         <xsl:call-template name="SoapWapper"/>     </xsl:template>          <xsl:template match="/" mode="message"> 
        
        <xsl:call-template name="recordAnnotationAddRejectedResponse">
            <xsl:with-param name="profile-description" select="$profile-description"/>
            <xsl:with-param name="profile-sequence" select="$profile-sequence"/>             <xsl:with-param name="patient-description" select="$patient-description"/>             <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
            <xsl:with-param name="IssueList-description" select="$IssueList-description"/>
        </xsl:call-template>
    </xsl:template>
        
</xsl:stylesheet>
