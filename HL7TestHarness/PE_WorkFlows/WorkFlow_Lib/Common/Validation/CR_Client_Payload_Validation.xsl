<?xml version="1.0" encoding="UTF-8"?>
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:hl7="urn:hl7-org:v3" version="1.0">
    <xsl:import href="../Lib/Validation_Lib.xsl"/>

    <xsl:param name="patient-description"/>
    <!-- you can also just use value in the by-* parameters. -->
    <xsl:param name="by-phn"/>
    <xsl:param name="by-birthdate"/>
    <xsl:param name="by-gender"/>
    <xsl:param name="by-given-name"/>
    <xsl:param name="by-family-name"/>
    <xsl:param name="query-id"/> <!-- TODO: add testing of this. -->

        <xsl:variable name="phn_ErrorMsg">PHN does not match requested phn value</xsl:variable>
        <xsl:variable name="dob_ErrorMsg">Birth Date does not match requested birth date value</xsl:variable>
        <xsl:variable name="gender_ErrorMsg">Gender code does not match requested gender code value</xsl:variable>
        <xsl:variable name="family_ErrorMsg">Family name does not match requested family name value</xsl:variable>
        <xsl:variable name="given_ErrorMsg">Given name does not match requested given name value</xsl:variable>
        <xsl:variable name="queryID_ErrorMsg">Query ID does not match request query ID value</xsl:variable>


    <!-- validate subject/registrationEvent/id -->
    <xsl:template match="hl7:registrationEvent/hl7:id">
        <xsl:call-template name="Identifier_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">true</xsl:with-param>
        </xsl:call-template>
        

        <xsl:apply-templates/>
    </xsl:template>

    <!-- validate subject/registrationEvent/statusCode  -->
    <xsl:template match="hl7:statusCode">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/statusCode"/>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>

    <!-- validate identifiedEntity/id element-->
    <xsl:template match="hl7:identifiedEntity/hl7:id">
        <xsl:call-template name="Identifier_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">true</xsl:with-param>
            <xsl:with-param name="expected_OID_List" select="$OIDSet/patient"/>
        </xsl:call-template>
        <xsl:if test="$by-phn and not($by-phn = 'false')">
            <xsl:variable name="phn">
                <xsl:choose>
                    <xsl:when test="$patient-description and $ValidationMsgType = 'serverMsg' ">
                        <xsl:value-of select="$TestData/patients/patient[@description = $patient-description]/server/phn"/>
                    </xsl:when>
                    <xsl:when test="$patient-description and $ValidationMsgType = 'clientMsg' ">
                        <xsl:value-of select="$TestData/patients/patient[@description = $patient-description]/client/phn"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$by-phn"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:if test="not($phn = 'true')">
            <xsl:if test="not(@extension = $phn)">
                <xsl:call-template name="ReportError">
                    <xsl:with-param name="ErrorText" select="$phn_ErrorMsg"/>
                    <xsl:with-param name="currentNode" select="."/>
                    <xsl:with-param name="expectedValue"><xsl:value-of select="$phn"/></xsl:with-param>
                    <xsl:with-param name="actualValue"><xsl:value-of select="@extension"/></xsl:with-param>
                </xsl:call-template>
                </xsl:if>
            </xsl:if>
        </xsl:if>
        
        <xsl:apply-templates/>
    </xsl:template>

    <!-- validate identifiedPerson/name element -->
    <xsl:template match="hl7:identifiedPerson/hl7:name">
        <xsl:call-template name="Person_Name_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="familyRequired">false</xsl:with-param>
        </xsl:call-template>

        <xsl:if test="$by-family-name and not($by-family-name = 'false')">
            <xsl:variable name="family-name">
                <xsl:choose>
                    <xsl:when test="$patient-description and $ValidationMsgType = 'serverMsg' ">
                        <xsl:value-of select="$TestData/patients/patient[@description = $patient-description]/server/family"/>
                    </xsl:when>
                    <xsl:when test="$patient-description  and $ValidationMsgType = 'clientMsg'">
                        <xsl:value-of select="$TestData/patients/patient[@description = $patient-description]/client/family"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$by-family-name"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:if test="not($family-name = 'true')">
            <xsl:if test="not(contains( translate(hl7:family, $lowerCase, $upperCase), translate($family-name, $lowerCase, $upperCase)))">
                <xsl:call-template name="ReportError">
                    <xsl:with-param name="ErrorText" select="$family_ErrorMsg"/>
                    <xsl:with-param name="currentNode" select="."/>
                    <xsl:with-param name="expectedValue"><xsl:value-of select="$patient-description"/>:<xsl:value-of select="$family-name"/></xsl:with-param>
                    <xsl:with-param name="actualValue"><xsl:value-of select="hl7:family"/></xsl:with-param>
                </xsl:call-template>
            </xsl:if>
            </xsl:if>
        </xsl:if>        

        <xsl:if test="$by-given-name and not($by-given-name = 'false')">
            <xsl:variable name="given-name">
                <xsl:choose>
                    <xsl:when test="$patient-description and $ValidationMsgType = 'serverMsg' ">
                        <xsl:value-of select="$TestData/patients/patient[@description = $patient-description]/server/given"/>
                    </xsl:when>
                    <xsl:when test="$patient-description and $ValidationMsgType = 'clientMsg' ">
                        <xsl:value-of select="$TestData/patients/patient[@description = $patient-description]/client/given"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$by-given-name"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:if test="not($given-name = 'true')">
            <xsl:if test="not(contains( translate(hl7:given, $lowerCase, $upperCase), translate($given-name, $lowerCase, $upperCase)))">
                <xsl:call-template name="ReportError">
                    <xsl:with-param name="ErrorText" select="$given_ErrorMsg"/>
                    <xsl:with-param name="currentNode" select="."/>
                    <xsl:with-param name="expectedValue"><xsl:value-of select="$given-name"/></xsl:with-param>
                    <xsl:with-param name="actualValue"><xsl:value-of select="hl7:given"/></xsl:with-param>
                </xsl:call-template>
            </xsl:if>
            </xsl:if>
        </xsl:if>        
        <xsl:apply-templates/>
    </xsl:template>

    <!-- validate identifiedPerson/administrativeGenderCode -->
    <xsl:template match="hl7:identifiedPerson/hl7:administrativeGenderCode">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/administrativeGenderCode"/>
        </xsl:call-template>
        <xsl:if test="$by-gender and not($by-gender = 'false')">
            <xsl:variable name="gender">
                <xsl:choose>
                    <xsl:when test="$patient-description and $ValidationMsgType = 'serverMsg' ">
                        <xsl:value-of select="$TestData/patients/patient[@description = $patient-description]/server/gender"/>
                    </xsl:when>
                    <xsl:when test="$patient-description and $ValidationMsgType = 'clientMsg' ">
                        <xsl:value-of select="$TestData/patients/patient[@description = $patient-description]/client/gender"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$by-gender"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:if test="not($gender = 'true')">
            <xsl:if test="not(@code =  $gender)">
                <xsl:call-template name="ReportError">
                    <xsl:with-param name="ErrorText" select="$gender_ErrorMsg"/>
                    <xsl:with-param name="currentNode" select="."/>
                    <xsl:with-param name="expectedValue"><xsl:value-of select="$gender"/></xsl:with-param>
                    <xsl:with-param name="actualValue"><xsl:value-of select="@code"/></xsl:with-param>
                </xsl:call-template>
            </xsl:if>
            </xsl:if>
        </xsl:if>               
        <xsl:apply-templates/>
    </xsl:template>

    <!-- validate custodian/assignedEntity/id -->
    <xsl:template match="hl7:custodian/hl7:assignedEntity/hl7:id">
        <xsl:call-template name="Identifier_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="expected_OID">DEPT_HEALTH</xsl:with-param>
            <xsl:with-param name="extensionRequired">false</xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>

    <!-- validate identifiedPerson/deceasedInd -->
    <xsl:template match="hl7:identifiedPerson/hl7:deceasedInd">
        <xsl:call-template name="Deceased_Elements_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="timeNodeName">deceasedTime</xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:identifiedPerson/hl7:deceasedTime">
        <xsl:call-template name="Required_Attr_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="attr_name">value</xsl:with-param>
            <xsl:with-param name="nullable">false</xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>

    <!-- validate parentClient/code (PersonalRelationshipRoleType) -->
    <xsl:template match="hl7:parentClient/hl7:code">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">true</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/PersonalRelationshipRoleType"/>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>

    <!-- validate parentClient/relationshipHolder/name -->
    <xsl:template match="hl7:parentClient/hl7:relationshipHolder/hl7:name">
        <xsl:call-template name="Person_Name_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="familyRequired">false</xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
</xsl:stylesheet>
