<?xml version="1.0" encoding="UTF-8"?>
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->
<xsl:stylesheet xmlns:hl7="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:import href="..\Lib\Validation_Lib.xsl"/>
    <xsl:output omit-xml-declaration="yes"/>

    <xsl:param name="ResponseType">unknown</xsl:param>
    <!-- response type will be passed in: either accept, reject, error, or unknown (default) -->

    <xsl:variable name="wrong_message_type_error_msg">Actual message type does not match expected message type</xsl:variable>
    <xsl:variable name="wrong_OID_name_error_msg">Record OID name not valid for this accept message</xsl:variable>
    <xsl:variable name="message_not_knowen_error_msg">Message name is not present in message List</xsl:variable>

    <xsl:template match="text()|@*"/>

    <xsl:template match="/">
        <!-- some accept messages use "actEvent"element, some use "actResponse" in same place -->

        <xsl:variable name="messageName">
            <xsl:value-of select=" local-name(//descendant-or-self::hl7:*[1])"/>
        </xsl:variable>
        <xsl:variable name="messageData" select="$MessageList/messages/*[name()=$messageName]"/>

        <xsl:if test="not($ResponseType = 'unknown')">
            <xsl:if test="($ResponseType != $messageData/recordType[1]/@type)">
                <!-- compare ResponseType parameter with expected response type for message name from messageData.xml -->
                <xsl:call-template name="ReportError">
                    <xsl:with-param name="ErrorText" select="$wrong_message_type_error_msg"/>
                    <xsl:with-param name="actualValue" select="$messageData/recordType[1]/@type"/>
                    <xsl:with-param name="expectedValue" select="$ResponseType"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:if>
        <xsl:if test="not($messageData)">
                <xsl:call-template name="ReportError">
                    <xsl:with-param name="ErrorText" select="$message_not_knowen_error_msg"/>
                    <xsl:with-param name="actualValue" select="$messageName"/>
                    <xsl:with-param name="expectedValue"/>
                </xsl:call-template>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>
    <!-- end validating 'accept' message -->


    <xsl:template match="hl7:controlActEvent/hl7:subject/hl7:id">
        <xsl:variable name="messageName">
            <xsl:value-of select=" local-name(//descendant-or-self::hl7:*[1])"/>
        </xsl:variable>
        <xsl:variable name="messageData" select="$MessageList/messages/*[name()=$messageName]"/>

        <xsl:call-template name="Identifier_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="expected_OID_List" select="$OIDSet/*[name() = $messageData/recordType/@OIDSet]"/>
            <xsl:with-param name="nullable">false</xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>

    <!-- some accept messages use "actEvent"element, some use "actRequest" in same place -->
    <xsl:template match="hl7:controlActEvent[1]/hl7:subject/hl7:actEvent">
        <xsl:call-template name="Check_Accept_Elements">
            <xsl:with-param name="node" select="."/>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:controlActEvent[1]/hl7:subject/hl7:actRequest">
        <xsl:call-template name="Check_Accept_Elements">
            <xsl:with-param name="node" select="."/>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="hl7:recordTarget/hl7:patient">
        <xsl:call-template name="Requested_Patient_Test">
            <xsl:with-param name="node" select="."/>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>


    <xsl:template name="Check_Accept_Elements">
        <xsl:param name="node"/>

        <xsl:variable name="messageName">
            <xsl:value-of select=" local-name(//descendant-or-self::hl7:*[1])"/>
        </xsl:variable>
        <xsl:variable name="ExpectedAction" select="$MessageList/messages/*[name()=$messageName]/recordType[1]/@action"/>
        <xsl:variable name="MessageStatus" select="$MessageList/messages/*[name()=$messageName]/recordType[1]/@type"/>

        <xsl:if test="$MessageStatus='accept'">
            <xsl:if test="$ExpectedAction ='add'">
                <!-- if 'add' , check for new @extension attribute (not in history)-->
                <xsl:call-template name="Unique_ID_Test">
                    <xsl:with-param name="node" select="$node/hl7:id"/>
                </xsl:call-template>
            </xsl:if>

            <xsl:if test="$ExpectedAction = 'update'">
                <!-- if "update", check that id same as request id (last message) -->
                <xsl:call-template name="Response_ID_Test">
                    <xsl:with-param name="node" select="$node/hl7:id[1]"/>
                    <xsl:with-param name="requestNode" select="$lastServerRequest/descendant::hl7:controlActEvent[1]/hl7:subject/descendant::hl7:id[1]"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
