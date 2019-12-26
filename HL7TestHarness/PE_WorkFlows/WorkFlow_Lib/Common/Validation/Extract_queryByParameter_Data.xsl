<?xml version="1.0" encoding="UTF-8"?>
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->  <xsl:stylesheet xmlns:hl7="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:import href="..\Lib\Report_Lib.xsl"/>
    <xsl:import href="..\Lib\TestData_Lib.xsl"/>

    <xsl:output omit-xml-declaration="yes"/>

    <xsl:param name="mapping"/>

    <!-- Extract all static data in the queryByParameter
             This data can then be compared against an expected set of data elements depending on the message.
        Element such as phn, patient names, etc are checked against the test data file and the patient description is 
        retrived and placed in the expected results.
    -->
    <!--  TODO: add remander of optional fields.    -->
    <xsl:template match="hl7:queryByParameter">
        <xsl:element name="extractedData" namespace="">
            <xsl:element name="patient">
                <xsl:call-template name="PatientDescription">
                    <xsl:with-param name="parameterList" select="hl7:parameterList"/>
                </xsl:call-template>
            </xsl:element>
            <xsl:if test="hl7:parameterList/hl7:issueFilterCode">
                <xsl:element name="issueFilterCode">
                    <xsl:attribute name="code">
                        <xsl:value-of select="hl7:parameterList/hl7:issueFilterCode/hl7:value/@code"/>
                    </xsl:attribute>
                </xsl:element>
            </xsl:if>
            <xsl:if test="hl7:parameterList/hl7:mostRecentByDrugIndicator">
                <xsl:element name="mostRecentByDrugIndicator">
                    <xsl:attribute name="code">
                        <xsl:value-of select="hl7:parameterList/hl7:mostRecentByDrugIndicator/hl7:value/@value"/>
                    </xsl:attribute>
                </xsl:element>
            </xsl:if>
        </xsl:element>
            <xsl:apply-templates/>     </xsl:template>

    <xsl:template name="PatientDescription">
        <xsl:param name="parameterList"/>
        <xsl:variable name="root">
            <xsl:value-of select="$parameterList/hl7:patientID/hl7:value/@root"/>
        </xsl:variable>
        <xsl:variable name="phn">
            <xsl:value-of select="$parameterList/hl7:patientID/hl7:value/@extension"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$mapping = 'toClient'">
                <xsl:call-template name="_PatientDescription">
                    <xsl:with-param name="parameterList" select="$parameterList"/>
                    <xsl:with-param name="patientInfo" select="$TestData/patients/patient/client[id/@root=$root and phn=$phn][1]"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="_PatientDescription">
                    <xsl:with-param name="parameterList" select="$parameterList"/>
                    <xsl:with-param name="patientInfo" select="$TestData/patients/patient/server[id/@root=$root and phn=$phn][1]"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
            <xsl:apply-templates/>     </xsl:template>

    <xsl:template name="_PatientDescription">
        <xsl:param name="parameterList"/>
        <xsl:param name="patientInfo"/>
        <xsl:choose>
            <xsl:when test="$patientInfo">
                <xsl:attribute name="description">
                    <xsl:value-of select="$patientInfo/parent::node()/@description"/>
                </xsl:attribute>
                <xsl:if test="$parameterList/hl7:patientName/hl7:value/hl7:given != $patientInfo/given">
                    <xsl:element name="error">Incorrect Given Name</xsl:element>
                </xsl:if>
                <xsl:if test="$parameterList/hl7:patientName/hl7:value/hl7:family != $patientInfo/family">
                    <xsl:element name="error">Incorrect Family Name</xsl:element>
                </xsl:if>
                <xsl:if test="$parameterList/hl7:patientGender/hl7:value/@code != $patientInfo/gender">
                    <xsl:element name="error">Incorrect patient Gender</xsl:element>
                </xsl:if>
                <xsl:if test="$parameterList/hl7:patientBirthDate/hl7:value/@value != $patientInfo/dob">
                    <xsl:element name="error">Incorrect patient Date of Birth</xsl:element>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>No Patient Found</xsl:otherwise>
        </xsl:choose>

            <xsl:apply-templates/>     </xsl:template>

</xsl:stylesheet>
