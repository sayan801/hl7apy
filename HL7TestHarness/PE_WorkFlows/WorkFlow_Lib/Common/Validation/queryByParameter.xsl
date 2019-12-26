<?xml version="1.0" encoding="UTF-8"?>
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->  <xsl:stylesheet xmlns:hl7="urn:hl7-org:v3"  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:import href="..\Lib\Report_Lib.xsl"/>
    <xsl:import href="..\Lib\TestData_Lib.xsl"/>
    
    <xsl:output omit-xml-declaration="yes"/>
    
    <xsl:param name="mapping"/>
    
    
    <xsl:template match="hl7:queryByParameter">
        <!-- check  that queryByParameter has the 2 required elements queryId and parameterList -->
        <xsl:choose>
            <xsl:when test="./hl7:queryId"/>
            <xsl:otherwise>
                <xsl:call-template name="ReportError">
                    <xsl:with-param name="ErrorText">Missing queryId element in queryByParameter</xsl:with-param>
                    <xsl:with-param name="elementName">queryByParameter/queryId</xsl:with-param>
                    <xsl:with-param name="expectedValue"/>
                    <xsl:with-param name="actualValue"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>

        <xsl:choose>
            <xsl:when test="./hl7:parameterList"/>
            <xsl:otherwise>
                <xsl:call-template name="ReportError">
                    <xsl:with-param name="ErrorText">Missing parameterList element in queryByParameter</xsl:with-param>
                    <xsl:with-param name="elementName">queryByParameter/parameterList</xsl:with-param>
                    <xsl:with-param name="expectedValue"/>
                    <xsl:with-param name="actualValue"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>

        <xsl:if test="$mapping = 'toClient'">
            <!-- validate that the queryByParameter data is the same as the data supplied in the request. -->
            <!-- queryId -->
            <xsl:if test="./hl7:queryId/@root != $lastClientRequest/hl7:controlActEvent/hl7:queryByParameter/hl7:queryId/@root">
                <xsl:call-template name="ReportError">
                    <xsl:with-param name="ErrorText">queryByParameter response queryId root attribute does not match request</xsl:with-param>
                    <xsl:with-param name="elementName">queryByParameter/queryId/@root</xsl:with-param>
                    <xsl:with-param name="expectedValue" select="$lastClientRequest/hl7:controlActEvent/hl7:queryByParameter/hl7:queryId/@root"/>
                    <xsl:with-param name="actualValue" select="./hl7:queryId/@root"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="./hl7:queryId/@extension != $lastClientRequest/hl7:controlActEvent/hl7:queryByParameter/hl7:queryId/@extension">
                <xsl:call-template name="ReportError">
                    <xsl:with-param name="ErrorText">queryByParameter response queryId extension attribute does not match request</xsl:with-param>
                    <xsl:with-param name="elementName">queryByParameter/queryId/@extension</xsl:with-param>
                    <xsl:with-param name="expectedValue" select="$lastClientRequest/hl7:controlActEvent/hl7:queryByParameter/hl7:queryId/@extension"/>
                    <xsl:with-param name="actualValue" select="./hl7:queryId/@extension"/>
                </xsl:call-template>
            </xsl:if>
            <!-- TODO: add check of  parameterList values in response.-->
        </xsl:if>
        
            
        <xsl:apply-templates/>
        
            <xsl:apply-templates/>     </xsl:template>

    <xsl:template match="hl7:parameterList">
        <!-- check parameterList has all required elements -->
        <xsl:choose>
            <xsl:when test="hl7:patientID/hl7:value"></xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="ReportError">
                    <xsl:with-param name="ErrorText">Missing patientID/value element in parameterList</xsl:with-param>
                    <xsl:with-param name="elementName">parameterList/patientID/value</xsl:with-param>
                    <xsl:with-param name="expectedValue"/>
                    <xsl:with-param name="actualValue"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="hl7:patientBirthDate/hl7:value"></xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="ReportError">
                    <xsl:with-param name="ErrorText">Missing patientBirthDate/value element in parameterList</xsl:with-param>
                    <xsl:with-param name="elementName">parameterList/patientBirthDate/value</xsl:with-param>
                    <xsl:with-param name="expectedValue"/>
                    <xsl:with-param name="actualValue"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="hl7:patientGender/hl7:value"></xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="ReportError">
                    <xsl:with-param name="ErrorText">Missing patientGender/value element in parameterList</xsl:with-param>
                    <xsl:with-param name="elementName">parameterList/patientGender/value</xsl:with-param>
                    <xsl:with-param name="expectedValue"/>
                    <xsl:with-param name="actualValue"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="hl7:patientName/hl7:value"></xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="ReportError">
                    <xsl:with-param name="ErrorText">Missing patientName/value element in parameterList</xsl:with-param>
                    <xsl:with-param name="elementName">parameterList/patientName/value</xsl:with-param>
                    <xsl:with-param name="expectedValue"/>
                    <xsl:with-param name="actualValue"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
        
        <xsl:apply-templates/>
            <xsl:apply-templates/>     </xsl:template>
    
    
    <!-- following elements are not required so we only check them if the are present. 
           we are checking for structure and static/lists values -->
    <xsl:template match="hl7:parameterList/hl7:administrationEffectivePeriod">
        
            <xsl:apply-templates/>     </xsl:template>

    <xsl:template match="hl7:parameterList/hl7:issueFilterCode">
            <xsl:choose>
                <xsl:when test="hl7:value/@code = 'A'"/>
                <xsl:when test="hl7:value/@code = 'I'"/>
                <xsl:when test="hl7:value/@code = 'U'"/>
                <xsl:otherwise>
                    <xsl:call-template name="ReportError">
                        <xsl:with-param name="ErrorText">element issueFilterCode/value/@code incorrect</xsl:with-param>
                        <xsl:with-param name="elementName">parameterList/issueFilterCode/value/@code</xsl:with-param>
                        <xsl:with-param name="expectedValue">A, I, or U</xsl:with-param>
                        <xsl:with-param name="actualValue" select="hl7:value/@code"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates/>     </xsl:template>

    <xsl:template match="hl7:parameterList/hl7:mostRecentByDrugIndicator">
        
            <xsl:apply-templates/>     </xsl:template>
    
</xsl:stylesheet>
