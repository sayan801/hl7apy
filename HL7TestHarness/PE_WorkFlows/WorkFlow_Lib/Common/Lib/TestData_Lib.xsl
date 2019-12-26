<?xml version="1.0" encoding="ISO-8859-1"?>
<!-- $Header:   L:/pvcsrep65/HL7TestHarness/archives/PE_WorkFlows/WorkFlow_Lib/Common/Lib/TestData_Lib.xsl-arc   1.14   30 Jul 2007 14:01:06   mwicks  $  -->
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->
<xsl:stylesheet xmlns="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" version="1.0">

    <!--
        Required Parameters:
            mapping = toServer | toClient
            OID = unique identifier for each call to the xsl
            now = current time in YYYYMMDDhhmmss format
            TestDataXml = Test Data Xml document.
    -->
    <xsl:param name="mapping"/>
    <xsl:param name="TestDataXml" select="document('..\..\TestData.xml')"/>

    <xsl:param name="WorkingDirectory"/>

    <!-- 
        Provides unique ids
        <xsl:variable name="OID">1.2.3.4.5.6.7.8.9</xsl:variable>
    -->
    <!-- 
        <xsl:variable name="OID_request" select="document('http://xobjex.com/service/id-generator.xsl')"/>
        <xsl:variable name="OID" select="$OID_request/generated-id/unique"/>
    -->
    <!-- an unique OID will be passed as a param form calling device -->
    <xsl:param name="OID">000000000000</xsl:param>

    <!-- 
      Connection to service providing current time 
    -->
    <!-- 
    <xsl:variable name="datetime" select="document('http://xobjex.com/service/date.xsl?offset=-04:00')/date/zone"/>
    -->
    <!-- 
        now
        Formats the current time in the HL7 standard method (YYYYMMDDhhmmss)
        <xsl:variable name="now">YYYYMMDDHHmmss</xsl:variable>
    -->
    <!-- 
        <xsl:variable name="now">
        <xsl:value-of select="$datetime/year"/>
        <xsl:value-of select="$datetime/month"/>
        <xsl:value-of select="$datetime/day"/>
        <xsl:value-of select="$datetime/hour"/>
        <xsl:value-of select="$datetime/minute"/>
        <xsl:value-of select="$datetime/second"/>
    </xsl:variable>
    -->
    <!-- current time will be passed as a param form calling device -->
    <xsl:param name="now">20060101120000</xsl:param>
    <!-- 
        date
        Formats the current time in the HL7 standard method (YYYYMMDD)
        <xsl:variable name="date">YYYYMMDD</xsl:variable>
    -->
    <!-- 
        <xsl:variable name="date">
        <xsl:value-of select="$datetime/year"/>
        <xsl:value-of select="$datetime/month"/>
        <xsl:value-of select="$datetime/day"/>
    </xsl:variable>
    -->
    <xsl:variable name="date" select="substring($now,1,8)"/>

    <!-- copy of the Staged Test data document -->
    <xsl:variable name="TestData" select="$TestDataXml/configuration/testData"/>
    <!-- copy of the System configuration -->
    <xsl:variable name="Config" select="$TestDataXml/configuration/system"/>
    <!--
        OID_root_*
        Mapping of the OID root values in the test data xml file.
    -->
    <xsl:variable name="OID_root" select="$Config/OIDs"/>
    <!--
        CodeSystems*
        Mapping of the CodeSystems OID values in the test data xml file.
    -->
    <xsl:variable name="CodeSystems" select="$Config/CodeSystems"/>
    <!--
        historyData
        Connection to the history xml file that is created by the test harness. 
        (contains all messages send during current workflow) 
    -->
    <xsl:variable name="historyFileName"><xsl:value-of select="$WorkingDirectory"/>\history.xml</xsl:variable>
<!--    <xsl:param name="historyXml" select="document($historyFileName)"/>-->
    <xsl:param name="historyXml"/>
    <xsl:variable name="historyData" select="$historyXml/historyData"/>
    <xsl:variable name="threadID"></xsl:variable>
    <!--
        lastClientRequest/Response & lastServerRequest/Response
        Views with in the history of the last request or response send by either the client
        or server applications.
    -->
    <xsl:variable name="lastClientRequest" select="$historyData/request[position()=last()]/client"/>
    <xsl:variable name="lastClientResponse" select="$historyData/response[position()=last()]/client"/>
    <xsl:variable name="lastServerRequest" select="$historyData/request[position()=last()]/server"/>
    <xsl:variable name="lastServerResponse" select="$historyData/response[position()=last()]/server"/>

    <xsl:variable name="AllClientRequests" select="$historyData/request/client"/>
    <xsl:variable name="AllClientResponses" select="$historyData/response/client"/>
    <xsl:variable name="AllServerRequests" select="$historyData/request/server"/>
    <xsl:variable name="AllServerResponses" select="$historyData/response/server"/>


    <!--
        getOIDRoot
        maps the OID roots between the client and server systems.
    -->
    <xsl:template name="getOIDRoot">
        <xsl:param name="root"/>
        <xsl:choose>
            <xsl:when test="$mapping='toServer'">
                <xsl:value-of select="$OID_root/child::node()[@client=$root]/@server"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$OID_root/child::node()[@server=$root]/@client"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="getOIDRootByName">
        <xsl:param name="OID_Name"/>
        <xsl:param name="msgType">clientMsg</xsl:param>

        <xsl:variable name="OID">
            <xsl:choose>
                <xsl:when test="$msgType='clientMsg'">
                    <xsl:value-of select="$OID_root/child::node()[local-name()=$OID_Name]/@client"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$OID_root/child::node()[local-name()=$OID_Name]/@server"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$OID">
                <xsl:value-of select="$OID"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$OID_Name"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template name="getOIDNameByRoot">
        <xsl:param name="OID_Value"/>
        <xsl:param name="msgType">clientMsg</xsl:param>
        <xsl:variable name="OIDName">
            <xsl:choose>
                <xsl:when test="$msgType='clientMsg'">
                    <xsl:value-of select="local-name($OID_root/descendant-or-self::node()[@client=$OID_Value][1])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="local-name($OID_root/descendant-or-self::node()[@server=$OID_Value][1])"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$OIDName">
                <xsl:value-of select="$OIDName"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$OID_Value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--
        getRecordExtension
        maps the extensions of items that are present in the testdata between client and server values
    -->

    <xsl:template name="getRecordExtension">
        <xsl:param name="root"/>
        <xsl:param name="extension"/>
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>

        <xsl:variable name="OID_Name">
            <xsl:call-template name="getOIDNameByRoot">
                <xsl:with-param name="OID_Value" select="$root"/>
                <xsl:with-param name="msgType">
                    <xsl:choose>
                        <xsl:when test="$mapping='toClient'">serverMsg</xsl:when>
                        <xsl:otherwise>clientMsg</xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$mapping='toClient'">
                <xsl:variable name="ItemRecord" select="$TestData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence]/items/descendant-or-self::node()[@root_OID = $OID_Name][@server=$extension]/@client"/>
                <xsl:choose>
                    <xsl:when test="$ItemRecord">
                        <xsl:value-of select="$ItemRecord"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$extension"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="ItemRecord" select="$TestData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence]/items/descendant::node()[@root_OID = $OID_Name][@client=$extension]/@server"/>
                <xsl:choose>
                    <xsl:when test="$ItemRecord">
                        <xsl:value-of select="$ItemRecord"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$extension"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template name="getProviderOrLocationExtension">
        <xsl:param name="root"/>
        <xsl:param name="extension"/>

        <xsl:variable name="OID_Name">
            <xsl:call-template name="getOIDNameByRoot">
                <xsl:with-param name="OID_Value" select="$root"/>
                <xsl:with-param name="msgType">
                    <xsl:choose>
                        <xsl:when test="$mapping='toClient'">serverMsg</xsl:when>
                        <xsl:otherwise>clientMsg</xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$mapping='toClient'">
                <xsl:variable name="ItemRecord" select="$TestData/descendant::node()[@OID = $OID_Name][server/id/@extension = $extension]/client/id/@extension"/>
                <xsl:choose>
                    <xsl:when test="$ItemRecord">
                        <xsl:value-of select="$ItemRecord"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$extension"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="ItemRecord" select="$TestData/descendant::node()[@OID = $OID_Name][client/id/@extension = $extension]/server/id/@extension"/>
                <xsl:choose>
                    <xsl:when test="$ItemRecord">
                        <xsl:value-of select="$ItemRecord"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$extension"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>
    <!--
        getKeyWord
        maps the keyword between client and server systems based on the patient ID and keyword value.
    -->
    <xsl:template name="getKeyword">
        <xsl:param name="keyword"/>
        <xsl:param name="root"/>
        <xsl:param name="phn"/>

        <xsl:variable name="patientInfo" select="$TestData/patients/patient/server[../client/id/@root=$root and ../client/phn=$phn][1]"/>

        <xsl:choose>
            <xsl:when test="$mapping='toServer'">
                <xsl:call-template name="keywordValue">
                    <xsl:with-param name="patientInfo" select="$TestData/patients/patient/server[../client/id/@root=$root and ../client/phn=$phn and ../client/keyword=$keyword][1]"/>
                    <xsl:with-param name="keyword" select="$keyword"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="keywordValue">
                    <xsl:with-param name="patientInfo" select="$TestData/patients/patient/client[ ../server/id/@root=$root and ../server/phn=$phn and ../server/keyword=$keyword][1]"/>
                    <xsl:with-param name="keyword" select="$keyword"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="keywordValue">
        <xsl:param name="patientInfo"/>
        <xsl:param name="keyword"/>
        <xsl:choose>
            <xsl:when test="$patientInfo/keyword">
                <xsl:value-of select="$patientInfo/keyword"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$keyword"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <!--
        sender
        deturmines who should be the sender and receiver.
    -->
    <xsl:template name="sender">
        <sender>
            <xsl:choose>
                <xsl:when test="$mapping='toServer'">
                    <xsl:call-template name="clientSystem">
                        <xsl:with-param name="msgType">serverMsg</xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="serverSystem">
                        <xsl:with-param name="msgType">clientMsg</xsl:with-param>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </sender>
    </xsl:template>
    <!--
        receiver
        deturmines who should be the sender and receiver.
    -->
    <xsl:template name="receiver">
        <receiver>
            <xsl:choose>
                <xsl:when test="$mapping='toServer'">
                    <xsl:call-template name="serverSystem">
                        <xsl:with-param name="msgType">serverMsg</xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="clientSystem">
                        <xsl:with-param name="msgType">clientMsg</xsl:with-param>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </receiver>
    </xsl:template>
    <!--
        clientSystem
        Gets the client system application data that is placed in the transmision wrapper sender
        or reciever tags.
    -->
    <xsl:template name="clientSystem">
        <xsl:param name="msgType"/>
        <telecom>
            <xsl:choose>
                <xsl:when test="$Config/client/uri">
                    <xsl:attribute name="use">WP</xsl:attribute>
                    <xsl:attribute name="value">uri:<xsl:value-of select="$Config/client/uri"/></xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="nullFlavor"/>
                </xsl:otherwise>
            </xsl:choose>
        </telecom>
        <device>
            <id root="">
                <xsl:attribute name="root">
                    <xsl:call-template name="getOIDRootByName">
                        <xsl:with-param name="OID_Name">PORTAL_APPLICATION</xsl:with-param>
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </xsl:attribute>
            </id>
        </device>
    </xsl:template>
    <!--
        serverSystem
        Gets the server system application data that is placed in the transmision wrapper sender
        or reciever tags.
    -->
    <xsl:template name="serverSystem">
        <xsl:param name="msgType"/>

        <telecom>
            <xsl:choose>
                <xsl:when test="$Config/server/uri">
                    <xsl:attribute name="use">WP</xsl:attribute>
                    <xsl:attribute name="value">uri:<xsl:value-of select="$Config/server/uri"/></xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="nullFlavor"/>
                </xsl:otherwise>
            </xsl:choose>
        </telecom>
        <device>
            <id root="">
                <xsl:attribute name="root">
                    <xsl:call-template name="getOIDRootByName">
                        <xsl:with-param name="OID_Name">DIS_APPLICATION</xsl:with-param>
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </xsl:attribute>
            </id>
        </device>
    </xsl:template>

    <!--
        Patient
        Gets the patient data depending on the root and phn passed to the function
    -->
    <xsl:template name="Patient">
        <xsl:param name="root"/>
        <xsl:param name="phn"/>
        <xsl:param name="format"/>
        <xsl:param name="use_phn"/>
        <xsl:param name="use_name"/>
        <xsl:param name="use_telecom"/>
        <xsl:param name="use_gender"/>
        <xsl:param name="use_dob"/>
        <xsl:param name="use_addr"/>
        <xsl:param name="use_city"/>
        <xsl:param name="use_state"/>
        <xsl:param name="use_postalcode"/>
        <xsl:param name="use_country"/>
        <xsl:param name="copy_source"/>
        <xsl:choose>
            <xsl:when test="$mapping='toServer'">
                <xsl:call-template name="PatientOutput">
                    <xsl:with-param name="patientInfo" select="$TestData/patients/patient/server[../client/id/@root=$root and ../client/phn=$phn][1]"/>
                    <xsl:with-param name="format" select="$format"/>
                    <xsl:with-param name="use_phn" select="$use_phn"/>
                    <xsl:with-param name="use_name" select="$use_name"/>
                    <xsl:with-param name="use_gender" select="$use_gender"/>
                    <xsl:with-param name="use_telecom" select="$use_telecom"/>
                    <xsl:with-param name="use_dob" select="$use_dob"/>
                    <xsl:with-param name="use_addr" select="$use_addr"/>
                    <xsl:with-param name="use_city" select="$use_city"/>
                    <xsl:with-param name="use_state" select="$use_state"/>
                    <xsl:with-param name="use_postalcode" select="$use_postalcode"/>
                    <xsl:with-param name="use_country" select="$use_country"/>
                    <xsl:with-param name="copy_source" select="$copy_source"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="PatientOutput">
                    <xsl:with-param name="patientInfo" select="$TestData/patients/patient/client[ ../server/id/@root=$root and ../server/phn=$phn][1]"/>
                    <xsl:with-param name="format" select="$format"/>
                    <xsl:with-param name="use_phn" select="$use_phn"/>
                    <xsl:with-param name="use_name" select="$use_name"/>
                    <xsl:with-param name="use_gender" select="$use_gender"/>
                    <xsl:with-param name="use_telecom" select="$use_telecom"/>
                    <xsl:with-param name="use_dob" select="$use_dob"/>
                    <xsl:with-param name="use_addr" select="$use_addr"/>
                    <xsl:with-param name="use_city" select="$use_city"/>
                    <xsl:with-param name="use_state" select="$use_state"/>
                    <xsl:with-param name="use_postalcode" select="$use_postalcode"/>
                    <xsl:with-param name="use_country" select="$use_country"/>
                    <xsl:with-param name="copy_source" select="$copy_source"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!--
        Provider
        Gets the provider data depending on the root and id and role passed to the function
    -->
    <xsl:template name="Provider">
        <xsl:param name="root"/>
        <xsl:param name="id"/>
        <xsl:param name="copy_source"/>
        <xsl:param name="format"/>
        <xsl:choose>
            <xsl:when test="$mapping='toServer'">
                <xsl:call-template name="ProviderOutput">
                    <xsl:with-param name="providerInfo" select="$TestData/providers/provider/server[../client/id/@root=$root and ../client/id/@extension=$id][1]"/>
                    <xsl:with-param name="format" select="$format"/>
                    <xsl:with-param name="copy_source" select="$copy_source"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="ProviderOutput">
                    <xsl:with-param name="providerInfo" select="$TestData/providers/provider/client[../server/id/@root=$root and ../server/id/@extension=$id][1]"/>
                    <xsl:with-param name="format" select="$format"/>
                    <xsl:with-param name="copy_source" select="$copy_source"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!--
        ServiceDeliveryLocation
        Gets the service Location depending on the root and id and name passed to the function
    -->
    <xsl:template name="serviceDeliveryLocation">
        <xsl:param name="root"/>
        <xsl:param name="id"/>
        <xsl:param name="format"/>
        <xsl:param name="copy_source"/>
        <xsl:choose>
            <xsl:when test="$mapping='toServer'">
                <xsl:call-template name="LocationOutput">
                    <xsl:with-param name="locationInfo" select="$TestData/serviceDeliveryLocations/location/server[../client/id/@root=$root and ../client/id/@extension=$id][1]"/>
                    <xsl:with-param name="format" select="$format"/>
                    <xsl:with-param name="copy_source" select="$copy_source"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="LocationOutput">
                    <xsl:with-param name="locationInfo" select="$TestData/serviceDeliveryLocations/location/client[../server/id/@root=$root and ../server/id/@extension=$id][1]"/>
                    <xsl:with-param name="format" select="$format"/>
                    <xsl:with-param name="copy_source" select="$copy_source"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- 
        PatientOutput
        Produces the correctly formated xml for the patient data in the testdata file.
        patientInfo - points to the xml in the test data file for the patient to be created
        format - type of output to create (query|clientreg|standard)
    -->
    <xsl:template name="PatientOutput">
        <xsl:param name="patientInfo"/>
        <xsl:param name="format"/>
        <xsl:param name="use_phn"/>
        <xsl:param name="use_name"/>
        <xsl:param name="use_gender"/>
        <xsl:param name="use_dob"/>
        <xsl:param name="use_dod"/>
        <xsl:param name="use_addr"/>
        <xsl:param name="use_city"/>
        <xsl:param name="use_state"/>
        <xsl:param name="use_postalcode"/>
        <xsl:param name="use_country"/>
        <xsl:param name="use_telecom"/>
        <xsl:param name="use_nextofKin"/>
        <xsl:param name="copy_source"/>

        <xsl:choose>
            <xsl:when test="not($patientInfo) and $copy_source">
                <xsl:copy-of select="$copy_source"/>
            </xsl:when>
            <xsl:when test="$format='query'">
                <!-- query message Output -->
                <patientBirthDate>
                    <value>
                        <xsl:choose>
                            <xsl:when test="$use_dob">
                                <xsl:attribute name="value">
                                    <xsl:value-of select="$patientInfo/dob"/>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="nullFlavor"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </value>
                </patientBirthDate>

                <patientGender>
                    <value>
                        <xsl:choose>
                            <xsl:when test="$use_gender">
                                <xsl:attribute name="code">
                                    <xsl:value-of select="$patientInfo/gender"/>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="nullFlavor"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </value>
                </patientGender>

                <patientID>
                    <value>
                        <xsl:choose>
                            <xsl:when test="$use_phn">
                                <xsl:attribute name="root">
                                    <xsl:value-of select="$patientInfo/id/@root"/>
                                </xsl:attribute>
                                <xsl:attribute name="extension">
                                    <xsl:value-of select="$patientInfo/phn"/>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="nullFlavor"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </value>
                </patientID>

                <patientName>
                    <value>
                        <xsl:choose>
                            <xsl:when test="$use_name">
                                <given>
                                    <xsl:value-of select="$patientInfo/given"/>
                                </given>
                                <family>
                                    <xsl:value-of select="$patientInfo/family"/>
                                </family>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="nullFlavor"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </value>
                </patientName>

            </xsl:when>
            <xsl:when test="$format='clientreg_demographics_queryParam'">
                <!-- Client Reg Output -->
                <clientID>
                    <value>
                        <xsl:attribute name="root">
                            <xsl:value-of select="$patientInfo/id/@root"/>
                        </xsl:attribute>
                        <xsl:attribute name="extension">
                            <xsl:value-of select="$patientInfo/phn"/>
                        </xsl:attribute>
                    </value>
                </clientID>
            </xsl:when>
            <xsl:when test="$format='clientreg'">
                <!-- Client Reg Output -->
                <xsl:if test="$use_phn">
                    <client.id>
                        <value>
                            <xsl:attribute name="root">
                                <xsl:value-of select="$patientInfo/id/@root"/>
                            </xsl:attribute>
                            <xsl:attribute name="extension">
                                <xsl:value-of select="$patientInfo/phn"/>
                            </xsl:attribute>
                        </value>
                    </client.id>
                </xsl:if>
                <xsl:if test="$use_addr">
                    <person.addr>
                        <xsl:if test="$use_city">
                            <city>
                                <xsl:value-of select="$patientInfo/addr/city"/>
                            </city>
                        </xsl:if>
                        <xsl:if test="$use_state">
                            <state>
                                <xsl:value-of select="$patientInfo/addr/state"/>
                            </state>
                        </xsl:if>
                        <xsl:if test="$use_postalcode">
                            <postalcode>
                                <xsl:value-of select="$patientInfo/addr/postalcode"/>
                            </postalcode>
                        </xsl:if>
                        <xsl:if test="$use_country">
                            <country>
                                <xsl:value-of select="$patientInfo/addr/country"/>
                            </country>
                        </xsl:if>
                    </person.addr>
                </xsl:if>
                <xsl:if test="$use_dob">
                    <person.birthTime>
                        <value value="">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$patientInfo/dob"/>
                            </xsl:attribute>
                        </value>
                    </person.birthTime>
                </xsl:if>
                <xsl:if test="$use_gender">
                    <person.gender>
                        <value>
                            <xsl:attribute name="code">
                                <xsl:value-of select="$patientInfo/gender"/>
                            </xsl:attribute>
                        </value>
                    </person.gender>
                </xsl:if>
                <xsl:if test="$use_name">
                    <person.name>
                        <value>
                            <given>
                                <xsl:value-of select="$patientInfo/given"/>
                            </given>
                            <family>
                                <xsl:value-of select="$patientInfo/family"/>
                            </family>
                        </value>
                    </person.name>
                </xsl:if>

            </xsl:when>
            <xsl:when test="$format='clientreg_demographics'">
                <identifiedEntity>
                    <xsl:if test="$use_phn">
                        <id root="" extension="">
                            <xsl:attribute name="root">
                                <xsl:value-of select="$patientInfo/id/@root"/>
                            </xsl:attribute>
                            <xsl:attribute name="extension">
                                <xsl:value-of select="$patientInfo/phn"/>
                            </xsl:attribute>
                        </id>
                    </xsl:if>
                    <statusCode code="active"/>
                    <identifiedPerson>
                        <xsl:if test="$use_name">
                            <name use="L">
                                <family>
                                    <xsl:value-of select="$patientInfo/family"/>
                                </family>
                                <given>
                                    <xsl:value-of select="$patientInfo/given"/>
                                </given>
                            </name>
                        </xsl:if>

                        <xsl:if test="$use_telecom">
                            <xsl:choose>
                                <xsl:when test="$patientInfo/telecom">
                                    <xsl:for-each select="$patientInfo/telecom">
                                        <telecom>
                                            <xsl:attribute name="value">
                                                <xsl:text>tel:</xsl:text>
                                                <xsl:value-of select="."/>
                                            </xsl:attribute>
                                        </telecom>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:otherwise>
                                    <telecom>
                                        <xsl:call-template name="nullFlavor"/>
                                    </telecom>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>

                        <xsl:if test="$use_gender">
                            <administrativeGenderCode code="">
                                <xsl:attribute name="code">
                                    <xsl:value-of select="$patientInfo/gender"/>
                                </xsl:attribute>
                            </administrativeGenderCode>
                        </xsl:if>
                        <xsl:if test="$use_dob">
                            <birthTime value="">
                                <xsl:attribute name="value">
                                    <xsl:value-of select="$patientInfo/dob"/>
                                </xsl:attribute>
                            </birthTime>
                        </xsl:if>

                        <xsl:if test="$use_dod">
                            <xsl:if test="$patientInfo/deceasedDate">
                                <deceasedInd value="true"/>
                                <deceasedTime>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="$patientInfo/deceasedDate"/>
                                    </xsl:attribute>
                                </deceasedTime>
                            </xsl:if>
                        </xsl:if>

                        <xsl:if test="$use_addr">
                            <xsl:for-each select="$patientInfo/addr">
                                <addr use="PST">
                                    <streetAddressLine>
                                        <xsl:value-of select="line1"/>
                                    </streetAddressLine>
                                    <xsl:if test="line2">
                                        <streetAddressLine>
                                            <xsl:value-of select="line2"/>
                                        </streetAddressLine>
                                    </xsl:if>
                                    <xsl:if test="line3">
                                        <streetAddressLine>
                                            <xsl:value-of select="line3"/>
                                        </streetAddressLine>
                                    </xsl:if>
                                    <xsl:if test="$use_city">
                                        <city>
                                            <xsl:value-of select="city"/>
                                        </city>
                                    </xsl:if>
                                    <xsl:if test="$use_state">
                                        <state>
                                            <xsl:value-of select="state"/>
                                        </state>
                                    </xsl:if>
                                    <xsl:if test="$use_postalcode">
                                        <postalCode>
                                            <xsl:value-of select="postalcode"/>
                                        </postalCode>
                                    </xsl:if>
                                    <xsl:if test="$use_country">
                                        <country>
                                            <xsl:value-of select="country"/>
                                        </country>
                                    </xsl:if>
                                </addr>
                            </xsl:for-each>
                        </xsl:if>

                        <xsl:if test="$use_nextofKin">
                            <xsl:for-each select="$patientInfo/nextOfKin">
                                <!-- next of kin -->
                                <parentClient>
                                    <!-- optionally an identifier for the next of kin -->
                                    <xsl:if test="phn">
                                        <id root="" extension="">
                                            <xsl:attribute name="root">
                                                <xsl:value-of select="id/@root"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="extension">
                                                <xsl:value-of select="phn"/>
                                            </xsl:attribute>
                                        </id>
                                    </xsl:if>
                                    <!-- relationship type: see PersonalRelationshipRoleType vocab  -->
                                    <code code="FAMMEMB">
                                        <xsl:attribute name="code">
                                            <xsl:value-of select="relationship"/>
                                        </xsl:attribute>
                                    </code>
                                    <relationshipHolder>
                                        <name use="L">
                                            <family>
                                                <xsl:value-of select="family"/>
                                            </family>
                                            <given>
                                                <xsl:value-of select="given"/>
                                            </given>
                                        </name>
                                    </relationshipHolder>
                                </parentClient>
                            </xsl:for-each>
                        </xsl:if>

                    </identifiedPerson>
                </identifiedEntity>
            </xsl:when>
            <xsl:when test="$format='clientreg_response'">
                <!-- Client Reg Output -->
                <identifiedEntity>
                    <id root="" extension="">
                        <xsl:attribute name="root">
                            <xsl:value-of select="$patientInfo/id/@root"/>
                        </xsl:attribute>
                        <xsl:attribute name="extension">
                            <xsl:value-of select="$patientInfo/phn"/>
                        </xsl:attribute>
                    </id>
                    <statusCode code="active"/>
                    <identifiedPerson>
                        <name use="L">
                            <family>
                                <xsl:value-of select="$patientInfo/family"/>
                            </family>
                            <given>
                                <xsl:value-of select="$patientInfo/given"/>
                            </given>
                        </name>
                        <administrativeGenderCode code="">
                            <xsl:attribute name="code">
                                <xsl:value-of select="$patientInfo/gender"/>
                            </xsl:attribute>
                        </administrativeGenderCode>
                        <birthTime value="">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$patientInfo/dob"/>
                            </xsl:attribute>
                        </birthTime>
                    </identifiedPerson>
                </identifiedEntity>
            </xsl:when>
            <xsl:when test="$format='necst_beneficiary'">
                <beneficiary typeCode="BEN">
                    <coveredPartyAsPatient classCode="COVPTY">
                        <id>
                            <xsl:attribute name="root">
                                <xsl:value-of select="$patientInfo/id/@root"/>
                            </xsl:attribute>
                            <xsl:attribute name="extension">
                                <xsl:value-of select="$patientInfo/phn"/>
                            </xsl:attribute>
                        </id>
                        <code code="SELF"/>
                        <coveredPartyAsPatientPerson classCode="PSN" determinerCode="INSTANCE">
                            <name use="L">
                                <given>
                                    <xsl:value-of select="$patientInfo/given"/>
                                </given>
                                <family>
                                    <xsl:value-of select="$patientInfo/family"/>
                                </family>
                            </name>
                            <administrativeGenderCode code="">
                                <xsl:attribute name="code">
                                    <xsl:value-of select="$patientInfo/gender"/>
                                </xsl:attribute>
                            </administrativeGenderCode>
                            <birthTime value="">
                                <xsl:attribute name="value">
                                    <xsl:value-of select="$patientInfo/dob"/>
                                </xsl:attribute>
                            </birthTime>
                        </coveredPartyAsPatientPerson>
                    </coveredPartyAsPatient>
                </beneficiary>
            </xsl:when>
            <xsl:when test="$format='necst_beneficiary_response'">
                <beneficiary typeCode="BEN">
                    <coveredPartyAsPatient classCode="COVPTY">
                        <id>
                            <xsl:attribute name="root">
                                <xsl:value-of select="$patientInfo/id/@root"/>
                            </xsl:attribute>
                            <xsl:attribute name="extension">
                                <xsl:value-of select="$patientInfo/phn"/>
                            </xsl:attribute>
                        </id>
                        <code code="SELF"/>
                    </coveredPartyAsPatient>
                </beneficiary>
            </xsl:when>
            <xsl:when test="$format='patient1'">
                <!-- Standard Output -->
                <patient1>
                    <id>
                        <xsl:attribute name="root">
                            <xsl:value-of select="$patientInfo/id/@root"/>
                        </xsl:attribute>
                        <xsl:attribute name="extension">
                            <xsl:value-of select="$patientInfo/phn"/>
                        </xsl:attribute>
                    </id>
                    <xsl:choose>
                        <xsl:when test="$use_telecom and $patientInfo/telecom">
                            <telecom>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="$patientInfo/telecom"/>
                                </xsl:attribute>
                            </telecom>
                        </xsl:when>
                        <xsl:otherwise>
                            <telecom>
                                <xsl:call-template name="nullFlavor"/>
                            </telecom>
                        </xsl:otherwise>
                    </xsl:choose>

                    <patientPerson>
                        <!-- The name by which the patient is known and which apply to a particular clinical action that has been reported or recorded -->
                        <name use="L">
                            <given>
                                <xsl:value-of select="$patientInfo/given"/>
                            </given>
                            <family>
                                <xsl:value-of select="$patientInfo/family"/>
                            </family>
                        </name>
                        <!-- Indicates the gender (sex) of the patient. -->
                        <administrativeGenderCode code="">
                            <xsl:attribute name="code">
                                <xsl:value-of select="$patientInfo/gender"/>
                            </xsl:attribute>
                        </administrativeGenderCode>
                        <birthTime value="">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$patientInfo/dob"/>
                            </xsl:attribute>
                        </birthTime>
                    </patientPerson>
                </patient1>
            </xsl:when>
            <xsl:when test="$format='patient_note'">
                <!-- Standard Output -->
                <patient>
                    <id>
                        <xsl:attribute name="root">
                            <xsl:value-of select="$patientInfo/id/@root"/>
                        </xsl:attribute>
                        <xsl:attribute name="extension">
                            <xsl:value-of select="$patientInfo/phn"/>
                        </xsl:attribute>
                    </id>
                    <xsl:if test="$use_telecom = 'true'">
                        <xsl:choose>
                            <xsl:when test="$patientInfo/telecom">
                                <telecom>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="$patientInfo/telecom"/>
                                    </xsl:attribute>
                                </telecom>
                            </xsl:when>
                            <xsl:otherwise>
                                <telecom>
                                    <xsl:call-template name="nullFlavor"/>
                                </telecom>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                    <patientPerson>
                        <!-- The name by which the patient is known and which apply to a particular clinical action that has been reported or recorded -->
                        <name use="L">
                            <given>
                                <xsl:value-of select="$patientInfo/given"/>
                            </given>
                            <family>
                                <xsl:value-of select="$patientInfo/family"/>
                            </family>
                        </name>
                        <!-- Indicates the gender (sex) of the patient. -->
                        <administrativeGenderCode code="">
                            <xsl:attribute name="code">
                                <xsl:value-of select="$patientInfo/gender"/>
                            </xsl:attribute>
                        </administrativeGenderCode>
                        <birthTime value="">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$patientInfo/dob"/>
                            </xsl:attribute>
                        </birthTime>
                    </patientPerson>
                </patient>
            </xsl:when>
            <xsl:otherwise>
                <!-- Standard Output -->
                <patient>
                    <id>
                        <xsl:attribute name="root">
                            <xsl:value-of select="$patientInfo/id/@root"/>
                        </xsl:attribute>
                        <xsl:attribute name="extension">
                            <xsl:value-of select="$patientInfo/phn"/>
                        </xsl:attribute>
                    </id>
                    <xsl:choose>
                        <xsl:when test="$use_telecom and $patientInfo/telecom">
                            <telecom>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="$patientInfo/telecom"/>
                                </xsl:attribute>
                            </telecom>
                        </xsl:when>
                        <xsl:otherwise>
                            <telecom>
                                <xsl:call-template name="nullFlavor"/>
                            </telecom>
                        </xsl:otherwise>
                    </xsl:choose>
                    <patientPerson>
                        <!-- The name by which the patient is known and which apply to a particular clinical action that has been reported or recorded -->
                        <name use="L">
                            <given>
                                <xsl:value-of select="$patientInfo/given"/>
                            </given>
                            <family>
                                <xsl:value-of select="$patientInfo/family"/>
                            </family>
                        </name>
                        <!-- Indicates the gender (sex) of the patient. -->
                        <administrativeGenderCode code="">
                            <xsl:attribute name="code">
                                <xsl:value-of select="$patientInfo/gender"/>
                            </xsl:attribute>
                        </administrativeGenderCode>
                        <birthTime value="">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$patientInfo/dob"/>
                            </xsl:attribute>
                        </birthTime>
                    </patientPerson>
                </patient>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- 
        ProviderOutput
        Produces the correctly formated xml for the provider data in the testdata file.
        providerInfo - points to the xml in the test data file for the provider to be created 
        format - type of output to create (query|clientreg|standard)
    -->
    <xsl:template name="ProviderOutput">
        <xsl:param name="providerInfo"/>
        <xsl:param name="format"/>
        <xsl:param name="copy_source"/>
        <xsl:choose>
            <xsl:when test="not($providerInfo) and $copy_source">
                <xsl:copy-of select="$copy_source"/>
            </xsl:when>     
            <xsl:when test="$format='ID-ONLY'">
                        <xsl:attribute name="root">
                            <xsl:value-of select="$providerInfo/id/@root"/>
                        </xsl:attribute>
                        <xsl:attribute name="extension">
                            <xsl:value-of select="$providerInfo/id/@extension"/>
                        </xsl:attribute>
            </xsl:when>
            <xsl:when test="$format='query'">
                <!-- Standard Output -->
            </xsl:when>
            <xsl:when test="$format='clientreg'">
                <!-- Client Reg Output -->
            </xsl:when>
            <xsl:when test="$format='necst'">
                <assignedPerson>
                    <!-- pharmacist or prescriber id  -->
                    <id root="" extension="">
                        <xsl:attribute name="root">
                            <xsl:value-of select="$providerInfo/id/@root"/>
                        </xsl:attribute>
                        <xsl:attribute name="extension">
                            <xsl:value-of select="$providerInfo/id/@extension"/>
                        </xsl:attribute>
                    </id>
                    <!--  HealthcareProviderRoleType -->
                    <xsl:if test="$providerInfo/role">
                        <code >
                            <xsl:attribute name="code">
                                <xsl:value-of select="$providerInfo/role"/>
                            </xsl:attribute>
                        </code>
                    </xsl:if>
                    <assignedPerson>
                        <name use="L">
                            <given>
                                <xsl:value-of select="$providerInfo/given"/>
                            </given>
                            <family>
                                <xsl:value-of select="$providerInfo/family"/>
                            </family>
                        </name>
                    </assignedPerson>
                </assignedPerson>
            </xsl:when>
            <xsl:otherwise>
                <!-- Standard Output -->
                <assignedPerson>
                    <!-- pharmacist or prescriber id  -->
                    <id root="" extension="">
                        <xsl:attribute name="root">
                            <xsl:value-of select="$providerInfo/id/@root"/>
                        </xsl:attribute>
                        <xsl:attribute name="extension">
                            <xsl:value-of select="$providerInfo/id/@extension"/>
                        </xsl:attribute>
                    </id>
                    <!--  HealthcareProviderRoleType -->
                    <xsl:if test="$providerInfo/role">
                    <code code="">
                        <xsl:attribute name="code">
                            <xsl:value-of select="$providerInfo/role"/>
                        </xsl:attribute>
                    </code>
                        </xsl:if>
                    <representedPerson>
                        <name use="L">
                            <given>
                                <xsl:value-of select="$providerInfo/given"/>
                            </given>
                            <family>
                                <xsl:value-of select="$providerInfo/family"/>
                            </family>
                        </name>
                    </representedPerson>
                </assignedPerson>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- 
        LocationOutput
        Produces the correctly formated xml for the provider data in the testdata file.
        locationInfo - points to the xml in the test data file for the location to be created 
        format - type of output to create (query|clientreg|standard)
    -->
    <xsl:template name="LocationOutput">
        <xsl:param name="locationInfo"/>
        <xsl:param name="format"/>
        <xsl:param name="copy_source"/>
        <xsl:choose>
            <xsl:when test="not($locationInfo) and $copy_source">
                <xsl:copy-of select="$copy_source"/>
            </xsl:when>            
            <xsl:when test="$format='query'">
                <!-- query Output -->
            </xsl:when>
            <xsl:when test="$format='clientreg'">
                <!-- Client Reg Output -->
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$locationInfo">
                        <!-- Standard Output -->
                        <serviceDeliveryLocation>
                            <!-- a pharmacy id -->
                            <id>
                                <xsl:attribute name="root">
                                    <xsl:value-of select="$locationInfo/id/@root"/>
                                </xsl:attribute>
                                <xsl:attribute name="extension">
                                    <xsl:value-of select="$locationInfo/id/@extension"/>
                                </xsl:attribute>
                            </id>
                            <addr>
                                <city>
                                    <xsl:value-of select="$locationInfo/addr/city"/>
                                </city>
                                <state>
                                    <xsl:value-of select="$locationInfo/addr/state"/>
                                </state>
                                <postalCode>
                                    <xsl:value-of select="$locationInfo/addr/postalCode"/>
                                </postalCode>
                                <country>
                                    <xsl:value-of select="$locationInfo/addr/country"/>
                                </country>
                            </addr>
                            <telecom use="H" value="">
                                <xsl:attribute name="value">tel:<xsl:value-of select="$locationInfo/telecom"/></xsl:attribute>
                            </telecom>
                            <location>
                                <name>
                                    <xsl:value-of select="$locationInfo/name"/>
                                </name>
                            </location>
                        </serviceDeliveryLocation>
                    </xsl:when>
                    <xsl:otherwise>
                        <serviceDeliveryLocation>
                            <!-- a pharmacy id -->
                            <id>
                                <xsl:call-template name="nullFlavor"/>
                            </id>
                            <addr>
                                <xsl:call-template name="nullFlavor"/>
                            </addr>
                            <telecom>
                                <xsl:call-template name="nullFlavor"/>
                            </telecom>
                            <location>
                                <name>
                                    <xsl:call-template name="nullFlavor"/>
                                </name>
                            </location>

                        </serviceDeliveryLocation>

                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="getPatientNameByID">
        <xsl:param name="node"/>
        <xsl:param name="messageType">server</xsl:param>
        <xsl:variable name="ID" select="$node/@root"/>
        <xsl:variable name="Extension" select="$node/@extension"/>

        <xsl:choose>
            <xsl:when test="$messageType = 'server'">
                <xsl:variable name="patientType" select="name($OID_root/*[@server = $ID])"/>
                <xsl:value-of select="$TestData/patients/patient[@OID = $patientType][server/phn = $Extension]/@description"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="patientType" select="name($OID_root/*[@client = $ID])"/>
                <xsl:value-of select="$TestData/patients/patient[@OID = $patientType][client/phn = $Extension]/@description"/>
            </xsl:otherwise>
        </xsl:choose>


    </xsl:template>





    <xsl:template name="convertDate">
        <xsl:param name="CurrentDate"/>
        <xsl:param name="MsgBaseDate"/>
        <xsl:param name="MsgModDate"/>

        <xsl:variable name="Current">
            <xsl:call-template name="convertDatetoNum">
                <xsl:with-param name="date" select="$CurrentDate"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="Base">
            <xsl:call-template name="convertDatetoNum">
                <xsl:with-param name="date" select="$MsgBaseDate"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="ModDate">
            <xsl:call-template name="convertDatetoNum">
                <xsl:with-param name="date" select="$MsgModDate"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:call-template name="convertNumtoDate">
            <xsl:with-param name="number">
                <xsl:value-of select="$Current + ($ModDate - $Base)"/>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:if test="string-length($MsgModDate) > 8">
            <xsl:call-template name="convertTime">
                <xsl:with-param name="CurrentTime" select="substring($CurrentDate,9)"/>
                <xsl:with-param name="MsgBaseTime" select="substring($MsgBaseDate,9)"/>
                <xsl:with-param name="MsgModTime" select="substring($MsgModDate,9)"/>
            </xsl:call-template>
        </xsl:if>

    </xsl:template>

    <xsl:template name="convertTime">
        <xsl:param name="CurrentTime"/>
        <!-- current now time -->
        <xsl:param name="MsgBaseTime"/>
        <!-- base time of message -->
        <xsl:param name="MsgModTime"/>
        <!-- Time to be converted based on base and current time -->

        <xsl:variable name="Current">
            <xsl:call-template name="convertTimetoNum">
                <xsl:with-param name="time" select="$CurrentTime"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="Base">
            <xsl:call-template name="convertTimetoNum">
                <xsl:with-param name="time" select="$MsgBaseTime"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="ModDate">
            <xsl:call-template name="convertTimetoNum">
                <xsl:with-param name="time" select="$MsgModTime"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:call-template name="convertNumtoTime">
            <xsl:with-param name="number">
                <xsl:value-of select="$Current + ($ModDate - $Base)"/>
            </xsl:with-param>
        </xsl:call-template>

    </xsl:template>

    <xsl:template name="convertTimetoNum">
        <xsl:param name="time"/>
        <xsl:variable name="HH" select="substring($time,1,2)"/>
        <xsl:variable name="MM" select="substring($time,3,2)"/>
        <xsl:variable name="SS" select="substring($time,5,2)"/>

        <xsl:value-of select="(((($HH * 60) + $MM) * 60) + $SS)"/>

    </xsl:template>

    <xsl:template name="convertNumtoTime">
        <xsl:param name="number"/>
        <xsl:variable name="HH" select="floor($number div 3600)"/>
        <xsl:variable name="MM" select="floor(($number - ($HH *3600)) div 60)"/>
        <xsl:variable name="SS" select="floor($number - ($HH *3600) - ($MM *60))"/>

        <xsl:if test="$HH &gt;= 24"/>

        <xsl:if test="string-length($HH) != 2">0</xsl:if>
        <!-- This is a work around to prevent the hours from getting larger then 24hrs -->
        <xsl:choose>
            <xsl:when test="$HH &lt; 24">
                <xsl:value-of select="$HH"/>
            </xsl:when>
            <xsl:otherwise>23</xsl:otherwise>
        </xsl:choose>
        <xsl:if test="string-length($MM) != 2">0</xsl:if>
        <xsl:value-of select="$MM"/>
        <xsl:if test="string-length($SS) != 2">0</xsl:if>
        <xsl:value-of select="$SS"/>
    </xsl:template>


    <xsl:template name="convertDatetoNum">
        <xsl:param name="date"/>
        <xsl:variable name="YYYY" select="substring($date,1,4)"/>
        <xsl:variable name="MM" select="substring($date,5,2)"/>
        <xsl:variable name="DD" select="substring($date,7,2)"/>
        <xsl:variable name="epoc" select="'1800'"/>

        <xsl:variable name="Year" select="($YYYY - $epoc) * 365"/>
        <xsl:variable name="Month">
            <xsl:call-template name="DaysByMonth">
                <xsl:with-param name="MM" select="$MM"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="Days" select="$DD"/>

        <!-- return the number of days the given date is from epoc -->
        <xsl:value-of select="$Year + $Month + $Days"/>
    </xsl:template>

    <xsl:template name="convertNumtoDate">
        <xsl:param name="number"/>
        <xsl:variable name="epoc" select="'1800'"/>

        <xsl:variable name="YYYY" select="$number div 365 + $epoc"/>
        <xsl:variable name="Year" select="substring($YYYY,1,4)"/>


        <xsl:variable name="MM" select="$number - (($Year - $epoc)*365) "/>

        <xsl:variable name="Month">
            <xsl:call-template name="MonthByDays">
                <xsl:with-param name="MM" select="$MM"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="DaysUsedByMonth">
            <xsl:call-template name="DaysByMonth">
                <xsl:with-param name="MM" select="$Month"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="Day" select="$MM - $DaysUsedByMonth"/>
        <xsl:variable name="Days">
            <xsl:if test="string-length($Day) = 1">0</xsl:if>
            <xsl:value-of select="$Day"/>
        </xsl:variable>

        <!-- return the Date in YYYYMMDD format -->
        <xsl:choose>
            <xsl:when test="$Days = '00'">
                <xsl:choose>
                    <xsl:when test="$Month = '01' ">
                        <xsl:value-of select="$Year - 1"/>
                        <xsl:text>12</xsl:text>
                        <xsl:text>31</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$Year"/>
                        <xsl:value-of select="$Month - 1"/>
                        <xsl:value-of select="$Days"/>
                        <xsl:variable name="D1">
                            <xsl:call-template name="DaysByMonth">
                                <xsl:with-param name="MM" select="$Month"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="D2">
                            <xsl:call-template name="DaysByMonth">
                                <xsl:with-param name="MM" select="$Month -1"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="D3" select="$D1 - $D2"/>
                        <xsl:if test="string-length($D3) = 1">0</xsl:if>
                        <xsl:value-of select="$D3"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$Year"/>
                <xsl:value-of select="$Month"/>
                <xsl:value-of select="$Days"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template name="DaysByMonth">
        <xsl:param name="MM"/>
        <xsl:choose>
            <xsl:when test="$MM = '01'">00</xsl:when>
            <xsl:when test="$MM = '02'">31</xsl:when>
            <xsl:when test="$MM = '03'">59</xsl:when>
            <xsl:when test="$MM = '04'">90</xsl:when>
            <xsl:when test="$MM = '05'">120</xsl:when>
            <xsl:when test="$MM = '06'">151</xsl:when>
            <xsl:when test="$MM = '07'">181</xsl:when>
            <xsl:when test="$MM = '08'">212</xsl:when>
            <xsl:when test="$MM = '09'">243</xsl:when>
            <xsl:when test="$MM = '10'">273</xsl:when>
            <xsl:when test="$MM = '11'">304</xsl:when>
            <xsl:when test="$MM = '12'">334</xsl:when>
            <xsl:otherwise>334</xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="MonthByDays">
        <xsl:param name="MM"/>
        <xsl:choose>
            <xsl:when test="$MM &lt;= 31">01</xsl:when>
            <xsl:when test="$MM &lt;= 59">02</xsl:when>
            <xsl:when test="$MM &lt;= 90">03</xsl:when>
            <xsl:when test="$MM &lt;= 120">04</xsl:when>
            <xsl:when test="$MM &lt;= 151">05</xsl:when>
            <xsl:when test="$MM &lt;= 181">06</xsl:when>
            <xsl:when test="$MM &lt;= 212">07</xsl:when>
            <xsl:when test="$MM &lt;= 243">08</xsl:when>
            <xsl:when test="$MM &lt;= 273">09</xsl:when>
            <xsl:when test="$MM &lt;= 304">10</xsl:when>
            <xsl:when test="$MM &lt;= 334">11</xsl:when>
            <xsl:when test="$MM &lt;= 365">12</xsl:when>
            <xsl:otherwise>12</xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="nullFlavor">
        <xsl:attribute name="nullFlavor">NI</xsl:attribute>
    </xsl:template>
</xsl:stylesheet>
