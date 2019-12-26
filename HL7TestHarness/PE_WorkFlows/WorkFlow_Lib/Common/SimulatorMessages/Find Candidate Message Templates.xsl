<?xml version="1.0" encoding="UTF-8"?>
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="urn:hl7-org:v3" xmlns:hl7="urn:hl7-org:v3" version="1.0">
    <xsl:include href="../Lib/MsgCreation_Lib.xsl"/>

    <!-- Query Messages -->
    <xsl:template name="findCandidateQueryResponse">
        <!-- 
        
        <xsl:param name="by-phn"/>
        <xsl:param name="by-birthdate"/>
        <xsl:param name="by-gender"/>
        <xsl:param name="by-given-name"/>
        <xsl:param name="by-family-name"/>
        -->
        <xsl:param name="query-id"/>
        <xsl:param name="query-status">OK</xsl:param>

        <xsl:variable name="msgType">serverMsg</xsl:variable>
        <xsl:variable name="msgAction">queryResponse</xsl:variable>

        <!-- This could be changed to get the search data from the request message, for now it just looks at the data supplied by the workflow -->
        <!-- <xsl:variable name="patientProfile" select="$TestData/patients/patient[@description=$patient-description]/server[1]"/> -->

        <!-- <xsl:variable name="PatientList" select="$TestData/patients/patient[(not($by-phn) or (server/phn=$patientProfile/phn and server/id/@root=$patientProfile/id/@root)) and (not($by-birthdate) or server/dob=$patientProfile/dob) and (not($by-gender) or server/gender=$patientProfile/gender) and (not($by-given-name) or server/given=$patientProfile/given) and (not($by-family-name) or server/family=$patientProfile/family)]"></xsl:variable> -->

        <xsl:variable name="clientID" select="descendant-or-self::hl7:client.id/hl7:value"/>
        <xsl:variable name="birthdate" select="descendant-or-self::hl7:person.birthTime/hl7:value/@value"/>
        <xsl:variable name="gender" select="descendant-or-self::hl7:person.gender/hl7:value/@code"/>
        <xsl:variable name="givenName" select="descendant-or-self::hl7:person.name/hl7:value/hl7:given"/>
        <xsl:variable name="familyName" select="descendant-or-self::hl7:person.name/hl7:value/hl7:family"/>
        <xsl:variable name="PatientList"
            select="$TestData/patients/patient[(not($clientID) or (server/phn=$clientID/@extension and server/id/@root=$clientID/@root)) and (not($birthdate) or server/dob=$birthdate) and (not($gender) or server/gender=$gender) and  (not($givenName) or contains(server/given,$givenName)) and (not($familyName) or contains(server/family,$familyName))]"/>

        <QUPA_IN101104CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">

            <!-- msgType = CRserverMsg so that transmission wrapper does not include act elements -->
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">QUPA_IN101104CA</xsl:with-param>
                <xsl:with-param name="msgType">CRserverMsg</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="transmissionWrapperEnd">
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <controlActProcess moodCode="EVN">
                <!-- DIS control act event id -->
                <id root="" extension="">
                    <xsl:attribute name="root">
                        <xsl:call-template name="getOIDRootByName">
                            <xsl:with-param name="OID_Name">DIS_CONTROL_ACT_ID</xsl:with-param>
                            <xsl:with-param name="msgType" select="$msgType"/>
                        </xsl:call-template>
                    </xsl:attribute>
                    <xsl:attribute name="extension">
                        <xsl:value-of select="$OID"/>
                    </xsl:attribute>
                </id>
                <!-- HL7TriggerEventCode - Identifies the trigger event that occurred -->
                <code code="QUPA_TE101104"/>

                <xsl:for-each select="$PatientList/server">
                    <subject>
                        <registrationEvent>
                            <id>
                                <xsl:call-template name="nullFlavor"/>
                            </id>
                            <!-- fixed value -->
                            <statusCode code="active"/>
                            <subject1>
                                <xsl:call-template name="PatientOutput">
                                    <xsl:with-param name="patientInfo" select="self::node()"/>
                                    <xsl:with-param name="format">clientreg_response</xsl:with-param>
                                </xsl:call-template>
                            </subject1>
                            <custodian>
                                <assignedEntity>
                                    <!-- OID for dept of Health -->
                                    <id root="2.16.124.9.101.1">
                                        <xsl:attribute name="root">
                                            <xsl:call-template name="getOIDRootByName">
                                                <xsl:with-param name="OID_Name">DEPT_HEALTH</xsl:with-param>
                                                <xsl:with-param name="msgType" select="$msgType"/>
                                            </xsl:call-template>
                                        </xsl:attribute>
                                    </id>
                                </assignedEntity>
                            </custodian>
                        </registrationEvent>
                    </subject>
                </xsl:for-each>

                <queryAck>
                    <xsl:choose>
                        <xsl:when test="descendant-or-self::queryByParameter/queryId">
                            <xsl:copy-of select="descendant-or-self::queryByParameter/queryId"/>
                        </xsl:when>
                        <xsl:when test="$query-id">
                            <queryId root="" extension="">
                                <xsl:attribute name="root">
                                    <xsl:call-template name="getOIDRootByName">
                                        <xsl:with-param name="OID_Name">PORTAL_QUERY_ID</xsl:with-param>
                                        <xsl:with-param name="msgType" select="$msgType"/>
                                    </xsl:call-template>
                                </xsl:attribute>

                                <xsl:attribute name="extension">
                                    <xsl:value-of select="$query-id"/>
                                </xsl:attribute>
                            </queryId>
                        </xsl:when>
                        <xsl:otherwise>
                            <queryId>
                                <xsl:call-template name="nullFlavor"/>
                            </queryId>
                        </xsl:otherwise>
                    </xsl:choose>

                    <queryResponseCode code="">
                        <xsl:attribute name="code">
                            <xsl:value-of select="$query-status"/>
                        </xsl:attribute>
                    </queryResponseCode>

                    <resultTotalQuantity value="">
                        <xsl:attribute name="value">
                            <xsl:value-of select="count($PatientList)"/>
                        </xsl:attribute>
                    </resultTotalQuantity>
                    <resultCurrentQuantity value="">
                        <xsl:attribute name="value">
                            <xsl:value-of select="count($PatientList)"/>
                        </xsl:attribute>
                    </resultCurrentQuantity>
                    <resultRemainingQuantity value="">
                        <xsl:attribute name="value">
                            <xsl:value-of select="0"/>
                        </xsl:attribute>
                    </resultRemainingQuantity>
                </queryAck>

                <!-- Copy the requested queryByParameter Request -->
                <queryByParameter>
                    <xsl:copy-of select="descendant-or-self::hl7:queryByParameterPayload/child::node()"/>
                </queryByParameter>
            </controlActProcess>

        </QUPA_IN101104CA>
    </xsl:template>

    <!-- TODO: need to add author, location, consent, etc. -->
    <xsl:template name="findCandidateQueryRequest">
        <xsl:param name="patient-description"/>
        <xsl:param name="by-phn"/>
        <xsl:param name="by-birthdate"/>
        <xsl:param name="by-gender"/>
        <xsl:param name="by-given-name"/>
        <xsl:param name="by-family-name"/>
        <xsl:param name="query-id"/>

        <xsl:variable name="msgType">clientMsg</xsl:variable>
        <xsl:variable name="msgAction">queryRequest</xsl:variable>




        <QUPA_IN101103CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">QUPA_IN101103CA</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <xsl:call-template name="transmissionWrapperEnd">
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <controlActProcess moodCode="EVN">
                <!-- identifier should be stored for use in ‘undos’.  They should be stored in such a way that they are associated with the item that was modified by this event.  For example, a system should be able to show the list of trigger event identifiers for the actions that have been recorded against a particular prescription. -->
                <id root="" extension="">
                    <xsl:attribute name="root">
                        <xsl:call-template name="getOIDRootByName">
                            <xsl:with-param name="OID_Name">PORTAL_CONTROL_ACT_ID</xsl:with-param>
                            <xsl:with-param name="msgType" select="$msgType"/>
                        </xsl:call-template>
                    </xsl:attribute>
                    <xsl:attribute name="extension">
                        <xsl:value-of select="$OID"/>
                    </xsl:attribute>
                </id>
                <!-- HL7TriggerEventCode - Identifies the trigger event that occurred -->
                <code code="QUPA_TE101103"/>

                <!-- time of query execution -->
                <effectiveTime value="">
                    <xsl:attribute name="value">
                        <xsl:call-template name="getBaseDateTime"/>
                    </xsl:attribute>
                </effectiveTime>

                <queryByParameterPayload>
                    <xsl:choose>
                        <xsl:when test="$query-id">
                            <queryId>
                                <xsl:attribute name="root">
                                    <xsl:call-template name="getOIDRootByName">
                                        <xsl:with-param name="OID_Name">PORTAL_QUERY_ID</xsl:with-param>
                                        <xsl:with-param name="msgType" select="$msgType"/>
                                    </xsl:call-template>
                                </xsl:attribute>
                                <xsl:attribute name="extension">
                                    <xsl:value-of select="$query-id"/>
                                </xsl:attribute>
                            </queryId>
                        </xsl:when>
                        <xsl:otherwise>
                            <queryId>
                                <xsl:call-template name="nullFlavor"/>
                            </queryId>
                        </xsl:otherwise>
                    </xsl:choose>

                    <statusCode code="active"/>
                    <!-- optionally a phn - phn is the only value we support here -->
                    <xsl:choose>
                        <xsl:when test="$patient-description and not($patient-description = '')">
                            <xsl:variable name="patientProfile" select="$TestData/patients/patient[@description=$patient-description]/client[1]"/>
                            
                            <xsl:if test="$by-phn">
                                <client.id>
                                    <value>
                                        <xsl:attribute name="root">
                                            <xsl:value-of select="$patientProfile/id/@root"/>
                                        </xsl:attribute>
                                        <xsl:attribute name="extension">
                                            <xsl:value-of select="$by-phn"/>
                                        </xsl:attribute>
                                    </value>
                                </client.id>
                            </xsl:if>
                            <!-- optionally a person date of birth -->
                            <xsl:if test="$by-birthdate">
                                <person.birthTime>
                                    <value value="">
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="$patientProfile/dob"/>
                                        </xsl:attribute>
                                    </value>
                                </person.birthTime>
                            </xsl:if>
                            <!-- optionally a person gender represented by HL7 AdministrativeGenderCode -->
                            <xsl:if test="$by-gender">
                                <person.gender>
                                    <value code="M">
                                        <xsl:attribute name="code">
                                            <xsl:value-of select="$patientProfile/gender"/>
                                        </xsl:attribute>
                                    </value>
                                </person.gender>
                            </xsl:if>
<!--                            <xsl:if test="$by-given-name or $by-family-name">-->
                                <person.name>
                                    <value>
                                        <xsl:if test="$by-given-name">
                                            <given>
                                                <xsl:value-of select="$patientProfile/given"/>
                                            </given>
                                        </xsl:if>
                                        <xsl:if test="$by-family-name">
                                            <family>
                                                <xsl:value-of select="$patientProfile/family"/>
                                            </family>
                                        </xsl:if>
                                    </value>
                                </person.name>
<!--                            </xsl:if>-->
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- optionally a person date of birth -->
                            <xsl:if test="$by-birthdate">
                                <person.birthTime>
                                    <value value="">
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="$by-birthdate"/>
                                        </xsl:attribute>
                                    </value>
                                </person.birthTime>
                            </xsl:if>
                            <!-- optionally a person gender represented by HL7 AdministrativeGenderCode -->
                            <xsl:if test="$by-gender">
                                <person.gender>
                                    <value code="M">
                                        <xsl:attribute name="code">
                                            <xsl:value-of select="$by-gender"/>
                                        </xsl:attribute>
                                    </value>
                                </person.gender>
                            </xsl:if>
<!--                            <xsl:if test="$by-given-name or $by-family-name">-->
                                <person.name>
                                    <value>
                                        <xsl:if test="$by-given-name">
                                            <given>
                                                <xsl:value-of select="$by-given-name"/>
                                            </given>
                                        </xsl:if>
                                        <xsl:if test="$by-family-name">
                                            <family>
                                                <xsl:value-of select="$by-family-name"/>
                                            </family>
                                        </xsl:if>
                                    </value>
                                </person.name>
<!--                            </xsl:if>-->
                        </xsl:otherwise>
                    </xsl:choose>
                </queryByParameterPayload>

            </controlActProcess>

        </QUPA_IN101103CA>

    </xsl:template>


    <xsl:template name="getClientDemographicsQueryRequest">

        <xsl:param name="patient-description"/>
        <xsl:param name="query-id"/>

        <xsl:variable name="msgType">clientMsg</xsl:variable>
        <xsl:variable name="msgAction">queryRequest</xsl:variable>

        <xsl:variable name="patientProfile" select="$TestData/patients/patient[@description=$patient-description]/client[1]"/>

        <QUPA_IN101101CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">QUPA_IN101101CA</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <xsl:call-template name="transmissionWrapperEnd">
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <controlActProcess moodCode="EVN">
                <!-- identifier should be stored for use in ‘undos’.  They should be stored in such a way that they are associated with the item that was modified by this event.  For example, a system should be able to show the list of trigger event identifiers for the actions that have been recorded against a particular prescription. -->
                <id root="" extension="">
                    <xsl:attribute name="root">
                        <xsl:call-template name="getOIDRootByName">
                            <xsl:with-param name="OID_Name">PORTAL_CONTROL_ACT_ID</xsl:with-param>
                            <xsl:with-param name="msgType" select="$msgType"/>
                        </xsl:call-template>
                    </xsl:attribute>
                    <xsl:attribute name="extension">
                        <xsl:value-of select="$OID"/>
                    </xsl:attribute>
                </id>
                <!-- HL7TriggerEventCode - Identifies the trigger event that occurred -->
                <code code="QUPA_TE101101"/>

                <!-- time of query execution -->
                <effectiveTime value="">
                    <xsl:attribute name="value">
                        <xsl:call-template name="getBaseDateTime"/>
                    </xsl:attribute>
                </effectiveTime>

                <queryByParameterPayload>
                    <xsl:choose>
                        <xsl:when test="$query-id">
                            <queryId>
                                <xsl:attribute name="root">
                                    <xsl:call-template name="getOIDRootByName">
                                        <xsl:with-param name="OID_Name">PORTAL_QUERY_ID</xsl:with-param>
                                        <xsl:with-param name="msgType" select="$msgType"/>
                                    </xsl:call-template>
                                </xsl:attribute>
                                <xsl:attribute name="extension">
                                    <xsl:value-of select="$query-id"/>
                                </xsl:attribute>
                            </queryId>
                        </xsl:when>
                        <xsl:otherwise>
                            <queryId>
                                <xsl:call-template name="nullFlavor"/>
                            </queryId>
                        </xsl:otherwise>
                    </xsl:choose>

                    <statusCode code="active"/>
                    <!-- optionally a phn - phn is the only value we support here -->
                    <clientID>
                        <value root="" extension="">
                            <xsl:attribute name="root">
                                <xsl:value-of select="$patientProfile/id/@root"/>
                            </xsl:attribute>
                            <xsl:attribute name="extension">
                                <xsl:value-of select="$patientProfile/phn"/>
                            </xsl:attribute>
                        </value>
                    </clientID>

                    <sortControl>
                        <xsl:call-template name="nullFlavor"/>
                    </sortControl>

                </queryByParameterPayload>

            </controlActProcess>

        </QUPA_IN101101CA>

    </xsl:template>

    <xsl:template name="getClientDemographicsQueryResponse">
        <!-- -->
        <xsl:param name="query-id"/>
        <xsl:param name="query-status">OK</xsl:param>

        <xsl:variable name="msgType">serverMsg</xsl:variable>
        <xsl:variable name="msgAction">queryResponse</xsl:variable>

        <!-- This could be changed to get the search data from the request message, for now it just looks at the data supplied by the workflow -->
        <!-- <xsl:variable name="patientProfile" select="$TestData/patients/patient[@description=$patient-description]/server[1]"/> -->
        <!-- <xsl:variable name="PatientList" select="$TestData/patients/patient[server/phn=$patientProfile/phn and server/id/@root=$patientProfile/id/@root]"/> -->
        <xsl:variable name="clientID" select="descendant-or-self::hl7:clientID/hl7:value"/>
        <xsl:variable name="PatientList" select="$TestData/patients/patient[server/phn=$clientID/@extension and server/id/@root=$clientID/@root]"/>

        <QUPA_IN101102CA xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">

            <!-- msgType = CRserverMsg so that transmission wrapper does not include act elements -->
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">QUPA_IN101102CA</xsl:with-param>
                <xsl:with-param name="msgType">CRserverMsg</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="transmissionWrapperEnd">
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <controlActProcess moodCode="EVN">
                <!-- DIS control act event id -->
                <id root="" extension="">
                    <xsl:attribute name="root">
                        <xsl:call-template name="getOIDRootByName">
                            <xsl:with-param name="OID_Name">DIS_CONTROL_ACT_ID</xsl:with-param>
                            <xsl:with-param name="msgType" select="$msgType"/>
                        </xsl:call-template>
                    </xsl:attribute>
                    <xsl:attribute name="extension">
                        <xsl:value-of select="$OID"/>
                    </xsl:attribute>
                </id>
                <!-- HL7TriggerEventCode - Identifies the trigger event that occurred -->
                <code code="QUPA_TE101104"/>

                <xsl:for-each select="$PatientList/server">
                    <subject>
                        <registrationEvent>
                            <id>
                                <xsl:call-template name="nullFlavor"/>
                            </id>
                            <!-- fixed value -->
                            <statusCode code="active"/>
                            <subject1>
                                <xsl:call-template name="PatientOutput">
                                    <xsl:with-param name="patientInfo" select="."/>
                                    <xsl:with-param name="use_phn" select="."/>
                                    <xsl:with-param name="use_name" select="."/>
                                    <xsl:with-param name="use_gender" select="."/>
                                    <xsl:with-param name="use_dob" select="."/>
                                    <xsl:with-param name="use_dod" select="."/>
                                    <xsl:with-param name="use_telecom" select="."/>
                                    <xsl:with-param name="use_addr" select="."/>
                                    <xsl:with-param name="use_city" select="."/>
                                    <xsl:with-param name="use_state" select="."/>
                                    <xsl:with-param name="use_postalcode" select="."/>
                                    <xsl:with-param name="use_country" select="."/>
                                    <xsl:with-param name="use_nextofKin" select="."/>
                                    <xsl:with-param name="format">clientreg_demographics</xsl:with-param>
                                </xsl:call-template>
                            </subject1>
                            <custodian>
                                <assignedEntity>
                                    <!-- OID for dept of Health -->
                                    <id root="2.16.124.9.101.1">
                                        <xsl:attribute name="root">
                                            <xsl:call-template name="getOIDRootByName">
                                                <xsl:with-param name="OID_Name">DEPT_HEALTH</xsl:with-param>
                                                <xsl:with-param name="msgType" select="$msgType"/>
                                            </xsl:call-template>
                                        </xsl:attribute>
                                    </id>
                                </assignedEntity>
                            </custodian>
                        </registrationEvent>
                    </subject>
                </xsl:for-each>

                <queryAck>
                    <xsl:choose>
                        <xsl:when test="descendant-or-self::queryByParameter/queryId">
                            <xsl:copy-of select="descendant-or-self::queryByParameter/queryId"/>
                        </xsl:when>
                        <xsl:when test="$query-id">
                            <queryId root="" extension="">
                                <xsl:attribute name="root">
                                    <xsl:call-template name="getOIDRootByName">
                                        <xsl:with-param name="OID_Name">PORTAL_QUERY_ID</xsl:with-param>
                                        <xsl:with-param name="msgType" select="$msgType"/>
                                    </xsl:call-template>
                                </xsl:attribute>

                                <xsl:attribute name="extension">
                                    <xsl:value-of select="$query-id"/>
                                </xsl:attribute>
                            </queryId>
                        </xsl:when>
                        <xsl:otherwise>
                            <queryId>
                                <xsl:call-template name="nullFlavor"/>
                            </queryId>
                        </xsl:otherwise>
                    </xsl:choose>

                    <queryResponseCode code="">
                        <xsl:attribute name="code">
                            <xsl:value-of select="$query-status"/>
                        </xsl:attribute>
                    </queryResponseCode>

                    <resultTotalQuantity value="">
                        <xsl:attribute name="value">
                            <xsl:value-of select="count($PatientList)"/>
                        </xsl:attribute>
                    </resultTotalQuantity>
                    <resultCurrentQuantity value="">
                        <xsl:attribute name="value">
                            <xsl:value-of select="count($PatientList)"/>
                        </xsl:attribute>
                    </resultCurrentQuantity>
                    <resultRemainingQuantity value="">
                        <xsl:attribute name="value">
                            <xsl:value-of select="0"/>
                        </xsl:attribute>
                    </resultRemainingQuantity>
                </queryAck>

                <!-- Copy the requested queryByParameter Request -->
                <queryByParameter>
                    <xsl:copy-of select="descendant-or-self::hl7:queryByParameterPayload/child::node()"/>
                </queryByParameter>
            </controlActProcess>

        </QUPA_IN101102CA>
    </xsl:template>

</xsl:stylesheet>
