<?xml version="1.0" encoding="UTF-8"?>
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->
<xsl:stylesheet xmlns:hl7="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:import href="..\Lib\Validation_Lib.xsl"/>
    <xsl:output omit-xml-declaration="yes"/>

    <xsl:param name="ResponseType">unknown</xsl:param>
    <!-- response type will be passed in: either accept, reject, error, or unknown (default) -->

    <xsl:variable name="wrong_message_type_error_msg">Actual message type does not match expected message type</xsl:variable>
    <xsl:variable name="message_not_knowen_error_msg">Message name is not present in message List</xsl:variable>
    <xsl:variable name="messagetype_not_knowen_error_msg">Message type is not defined in message List</xsl:variable>

    <xsl:template match="text()|@*"/>

    <xsl:template match="/">
        <!-- some accept messages use "actEvent"element, some use "actResponse" in same place -->

        <xsl:variable name="messageName">
            <xsl:value-of select=" local-name(//descendant-or-self::hl7:*[1])"/>
        </xsl:variable>
        <xsl:variable name="messageData" select="$MessageList/messages/*[name()=$messageName]"/>

        <xsl:if test="not($ResponseType = 'unknown')">
            <xsl:if test="not($ResponseType = $messageData/recordType[1]/@type)">
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
        <xsl:if test="not($messageData/recordType[1]/@type)">
                <xsl:call-template name="ReportError">
                    <xsl:with-param name="ErrorText" select="$messagetype_not_knowen_error_msg"/>
                    <xsl:with-param name="actualValue" select="$messageName"/>
                    <xsl:with-param name="expectedValue"/>
                </xsl:call-template>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>

    

</xsl:stylesheet>
