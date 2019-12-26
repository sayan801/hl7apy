<?xml version="1.0" encoding="UTF-8"?>
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->
<xsl:stylesheet xmlns="urn:hl7-org:v3" xmlns:hl7="urn:hl7-org:v3" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:import href="..\Lib\TestData_Lib.xsl"/>

    <xsl:param name="profile-description"/>
    <xsl:param name="profile-sequence"/>
    <xsl:param name="patient-description"/>
    <xsl:param name="msg-effective-time"/>


    <xsl:template match="hl7:targetMessage">
        <xsl:element name="{name()}">
            <xsl:for-each select="child::hl7:id">
                <xsl:element name="{name()}">
                    <xsl:for-each select="@*">
                        <xsl:attribute name="{name()}">
                            <xsl:choose>
                                <xsl:when test="name()='root'">
                                    <xsl:call-template name="getOIDRoot">
                                        <xsl:with-param name="root" select="."/>
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:when test="name()='extension'">
                                    <xsl:choose>
                                        <xsl:when test="$lastServerRequest/descendant-or-self::hl7:*[1]/child::node()[local-name() = 'id']/@extension">
                                            <xsl:value-of select="$lastServerRequest/descendant-or-self::hl7:*[1]/child::node()[local-name() = 'id']/@extension"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="."/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="."/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                    </xsl:for-each>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>

    <xsl:template match="hl7:creationTime">
        <xsl:element name="{name()}">
            <xsl:for-each select="@*">
                <xsl:attribute name="{name()}">
                    <xsl:choose>
                        <xsl:when test="name()='value'">
                            <xsl:value-of select="$now"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="."/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>

    <xsl:template match="hl7:signatureText">
        <xsl:element name="{name()}">
            <xsl:for-each select="@*">
                <xsl:attribute name="{name()}">
                    <xsl:value-of select="."/>
                </xsl:attribute>
            </xsl:for-each>
            <xsl:call-template name="getKeyword">
                <xsl:with-param name="keyword" select="."/>
                <xsl:with-param name="root" select="parent::node()/parent::node()/descendant-or-self::node()/hl7:patient/hl7:id/@root"/>
                <xsl:with-param name="phn" select="parent::node()/parent::node()/descendant-or-self::node()/hl7:patient/hl7:id/@extension"/>
            </xsl:call-template>
        </xsl:element>
    </xsl:template>

    <xsl:template match="hl7:effectiveTime">
        <xsl:element name="{name()}">
            <xsl:for-each select="@*">
                <xsl:attribute name="{name()}">
                    <xsl:choose>
                        <xsl:when test="name()='value' ">
                            <xsl:call-template name="convertDate">
                                <xsl:with-param name="CurrentDate" select="$now"/>
                                <xsl:with-param name="MsgBaseDate" select="/descendant-or-self::hl7:*[1]/hl7:creationTime/@value"/>
                                <xsl:with-param name="MsgModDate" select="."/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="."/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
            </xsl:for-each>
            <xsl:for-each select="child::node()">
                <xsl:element name="{name()}">
                    <xsl:for-each select="@*">
                        <xsl:attribute name="{name()}">
                            <xsl:choose>
                                <xsl:when test="name()='value' and name(parent::node()) = 'low'">
                                    <xsl:call-template name="convertDate">
                                        <xsl:with-param name="CurrentDate" select="$now"/>
                                        <xsl:with-param name="MsgBaseDate" select="/descendant-or-self::hl7:*[1]/hl7:creationTime/@value"/>
                                        <xsl:with-param name="MsgModDate" select="."/>
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:when test="name()='value' and name(parent::node()) = 'high'">
                                    <xsl:call-template name="convertDate">
                                        <xsl:with-param name="CurrentDate" select="$now"/>
                                        <xsl:with-param name="MsgBaseDate" select="/descendant-or-self::hl7:*[1]/hl7:creationTime/@value"/>
                                        <xsl:with-param name="MsgModDate" select="."/>
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:when test="name()='value' and name(parent::node()) = 'center'">
                                    <xsl:call-template name="convertDate">
                                        <xsl:with-param name="CurrentDate" select="$now"/>
                                        <xsl:with-param name="MsgBaseDate" select="/descendant-or-self::hl7:*[1]/hl7:creationTime/@value"/>
                                        <xsl:with-param name="MsgModDate" select="."/>
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="."/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                    </xsl:for-each>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>


    <xsl:template match="hl7:time">
        <xsl:element name="{name()}">
            <xsl:for-each select="@*">
                <xsl:attribute name="{name()}">
                    <xsl:choose>
                        <xsl:when test="name()='value'">
                            <xsl:call-template name="convertDate">
                                <xsl:with-param name="CurrentDate" select="$now"/>
                                <xsl:with-param name="MsgBaseDate" select="/child::node()/hl7:creationTime/@value"/>
                                <xsl:with-param name="MsgModDate" select="."/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="."/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>

    <xsl:template match="hl7:queryByParameter/hl7:parameterList/hl7:*/hl7:value/hl7:low[@value]">
        <xsl:element name="{name()}">
            <xsl:for-each select="@*">
                <xsl:attribute name="{name()}">
                    <xsl:choose>
                        <xsl:when test="name()='value'">
                            <xsl:call-template name="convertDate">
                                <xsl:with-param name="CurrentDate" select="$now"/>
                                <xsl:with-param name="MsgBaseDate" select="/child::node()/hl7:creationTime/@value"/>
                                <xsl:with-param name="MsgModDate" select="."/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="."/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>

    <xsl:template match="hl7:queryByParameter/hl7:parameterList/hl7:*/hl7:value/hl7:high[@value]">
        <xsl:element name="{name()}">
            <xsl:for-each select="@*">
                <xsl:attribute name="{name()}">
                    <xsl:choose>
                        <xsl:when test="name()='value'">
                            <xsl:call-template name="convertDate">
                                <xsl:with-param name="CurrentDate" select="$now"/>
                                <xsl:with-param name="MsgBaseDate" select="/child::node()/hl7:creationTime/@value"/>
                                <xsl:with-param name="MsgModDate" select="."/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="."/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>


    <xsl:template match="hl7:clientID">
        <xsl:call-template name="Patient">
            <xsl:with-param name="root" select="hl7:value/@root"/>
            <xsl:with-param name="phn" select="hl7:value/@extension"/>
            <xsl:with-param name="use_phn" select="hl7:value/@extension"/>
            <xsl:with-param name="format">clientreg_demographics_queryParam</xsl:with-param>
            <xsl:with-param name="copy_source" select="."></xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="hl7:identifiedEntity">
        <xsl:call-template name="Patient">
            <xsl:with-param name="root" select="hl7:id/@root"/>
            <xsl:with-param name="phn" select="hl7:id/@extension"/>
            <xsl:with-param name="use_phn" select="hl7:id"/>
            <xsl:with-param name="use_name" select="hl7:identifiedPerson/hl7:name/child::node()"/>
            <xsl:with-param name="use_gender" select="hl7:identifiedPerson/hl7:administrativeGenderCode[@code]"/>
            <xsl:with-param name="use_dob" select="hl7:identifiedPerson/hl7:birthTime[@value]"/>
            <xsl:with-param name="use_dod" select="hl7:identifiedPerson/hl7:deceasedInd[@value]"/>
            <xsl:with-param name="use_telecom" select="hl7:identifiedPerson/hl7:telecom[@value]"/>
            <xsl:with-param name="use_addr" select="hl7:identifiedPerson/hl7:addr/child::node()"/>
            <xsl:with-param name="use_city" select="hl7:identifiedPerson/hl7:addr/hl7:city"/>
            <xsl:with-param name="use_state" select="hl7:identifiedPerson/hl7:addr/hl7:state"/>
            <xsl:with-param name="use_postalcode" select="hl7:identifiedPerson/hl7:addr/hl7:postalCode"/>
            <xsl:with-param name="use_country" select="hl7:identifiedPerson/hl7:addr/hl7:country"/>
            <xsl:with-param name="use_nextofKin" select="hl7:identifiedPerson/hl7:parentClient"/>
            <xsl:with-param name="copy_source" select="."/>
            <xsl:with-param name="format">clientreg_demographics</xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="hl7:payee.Id | hl7:location.Id | provider.Id">
        <xsl:element name="{name()}">
            <xsl:for-each select="child::hl7:*">
                <xsl:element name="{name()}">
                    <xsl:for-each select="@*">
                        <xsl:attribute name="{name()}">
                            <xsl:choose>
                                <xsl:when test="local-name()='root'">
                                    <xsl:call-template name="getOIDRoot">
                                        <xsl:with-param name="root" select="."/>
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:when test="local-name()='extension'">
                                    <xsl:call-template name="getProviderOrLocationExtension">
                                        <xsl:with-param name="root">
                                            <xsl:value-of select="parent::node()/@root"/>
                                        </xsl:with-param>
                                        <xsl:with-param name="extension">
                                            <xsl:value-of select="."/>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="."/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                    </xsl:for-each>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>

    <xsl:template match="hl7:client.id | hl7:person.birthTime | hl7:person.gender | hl7:person.name">
        <xsl:choose>
            <xsl:when test="local-name() = 'client.id'">
                <xsl:call-template name="Patient">
                    <xsl:with-param name="root" select="hl7:value/@root"/>
                    <xsl:with-param name="phn" select="hl7:value/@extension"/>
                    <xsl:with-param name="use_phn" select="hl7:value/@extension"/>
                    <xsl:with-param name="use_name" select="parent::node()/hl7:person.name/hl7:value/child::node()"/>
                    <xsl:with-param name="use_gender" select="parent::node()/hl7:person.gender/hl7:value[@code]"/>
                    <xsl:with-param name="use_dob" select="parent::node()/hl7:person.birthTime/hl7:value[@value]"/>
                    <xsl:with-param name="copy_source" select="parent::node()/child::hl7:*[self::hl7:client.id | self::hl7:person.birthTime | self::hl7:person.gender | self::hl7:person.name]"/>
                    <xsl:with-param name="format">clientreg</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="parent::node()/hl7:client.id">
                <!-- do nothing if the client id is defined, the above will add all requried info. -->
            </xsl:when>
            <xsl:otherwise>
                <!-- just copy the element as is, we are not able to map this to a known client with an ID -->
                <xsl:element name="{name()}">
                    <xsl:for-each select="attribute::*">
                        <xsl:variable name="attrName">
                            <xsl:value-of select="name()"/>
                        </xsl:variable>
                        <xsl:attribute name="{name()}">
                            <xsl:value-of select="."/>
                        </xsl:attribute>
                    </xsl:for-each>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>


    </xsl:template>

    <xsl:template match="hl7:patientID | hl7:patientName | hl7:patientGender | hl7:patientBirthDate">
        <xsl:if test="local-name() = 'patientID'">
            <xsl:call-template name="Patient">
                <xsl:with-param name="root" select="hl7:value/@root"/>
                <xsl:with-param name="phn" select="hl7:value/@extension"/>
                <xsl:with-param name="use_phn" select="hl7:value/@extension"/>
                <xsl:with-param name="use_name" select="parent::node()/hl7:patientName/hl7:value/child::node()"/>
                <xsl:with-param name="use_gender" select="parent::node()/hl7:patientGender/hl7:value[@code]"/>
                <xsl:with-param name="use_dob" select="parent::node()/hl7:patientBirthDate/hl7:value[@value]"/>
                <xsl:with-param name="copy_source" select="parent::node()/child::hl7:*[self::hl7:patientID | self::hl7:patientName | self::hl7:patientGender | self::hl7:patientBirthDate]"/>
                <xsl:with-param name="format">query</xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template match="hl7:patient">
        <xsl:call-template name="Patient">
            <xsl:with-param name="root" select="hl7:id/@root"/>
            <xsl:with-param name="phn" select="hl7:id/@extension"/>
            <xsl:with-param name="copy_source" select="."/>
            <xsl:with-param name="format">standard</xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="hl7:patient1">
        <xsl:call-template name="Patient">
            <xsl:with-param name="root" select="hl7:id/@root"/>
            <xsl:with-param name="phn" select="hl7:id/@extension"/>
            <xsl:with-param name="copy_source" select="."/>
            <xsl:with-param name="format">patient1</xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="hl7:assignedPerson">
        <xsl:call-template name="Provider">
            <xsl:with-param name="root" select="hl7:id/@root"/>
            <xsl:with-param name="id" select="hl7:id/@extension"/>
            <xsl:with-param name="copy_source" select="."/>
            <xsl:with-param name="format">standard</xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="hl7:serviceDeliveryLocation">
        <xsl:call-template name="serviceDeliveryLocation">
            <xsl:with-param name="root" select="hl7:id/@root"/>
            <xsl:with-param name="id" select="hl7:id/@extension"/>
            <xsl:with-param name="copy_source" select="."/>
            <xsl:with-param name="format">standard</xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="/soap:Envelope/soap:Body/hl7:*/hl7:sender">
        <xsl:call-template name="sender"/>
    </xsl:template>
    <xsl:template match="/hl7:*/hl7:sender">
        <xsl:call-template name="sender"/>
    </xsl:template>
    <xsl:template match="/soap:Envelope/soap:Body/hl7:*/hl7:receiver">
        <xsl:call-template name="receiver"/>
    </xsl:template>
    <xsl:template match="/hl7:*/hl7:receiver">
        <xsl:call-template name="receiver"/>
    </xsl:template>

    <xsl:template match="hl7:*[@root or @codeSystem or @extension]">
        <xsl:element name="{name()}">
            <xsl:for-each select="@*">
                <xsl:attribute name="{name()}">
                    <xsl:choose>
                        <xsl:when test="local-name()='root'">
                            <xsl:call-template name="getOIDRoot">
                                <xsl:with-param name="root" select="."/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="local-name()='extension'">
                            <xsl:call-template name="getRecordExtension">
                                <xsl:with-param name="root" select="parent::node()/@root"/>
                                <xsl:with-param name="extension" select="."/>
                                <xsl:with-param name="profile-description" select="$profile-description"/>
                                <xsl:with-param name="profile-sequence" select="$profile-sequence"/>
                                <xsl:with-param name="patient-description" select="$patient-description"/>
                                <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="local-name()='codeSystem'">
                            <xsl:call-template name="getOIDRoot">
                                <xsl:with-param name="root" select="."/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="."/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
            </xsl:for-each>
            <xsl:apply-templates select="child::node()"/>
        </xsl:element>
    </xsl:template>
    

    <xsl:template match="*">
        <xsl:element name="{name()}">
            <xsl:for-each select="attribute::*">
                <xsl:variable name="attrName">
                    <xsl:value-of select="name()"/>
                </xsl:variable>
                <xsl:attribute name="{name()}">
                    <xsl:value-of select="."/>
                </xsl:attribute>
            </xsl:for-each>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>


</xsl:stylesheet>
