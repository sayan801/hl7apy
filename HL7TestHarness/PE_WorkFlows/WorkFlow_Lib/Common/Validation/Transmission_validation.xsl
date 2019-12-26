<?xml version="1.0" encoding="UTF-8"?>
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->  <xsl:stylesheet xmlns:hl7="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" version="1.0">
    <xsl:import href="../Lib/Validation_Lib.xsl"/>

    <xsl:variable name="Interaction_Root_incorrect_ErrorMsg">Interaction root attribute contains an incorrect value</xsl:variable>
    <xsl:variable name="Interaction_Extension_wrong_value">Interaction extension must contain an incorrect value</xsl:variable>
    <xsl:variable name="Achnowledgement_of_wrong_message_ErrorMsg">Response message is actnowledging the wrong request message id</xsl:variable>


    <xsl:template match="text()|@*"/>
    <!-- override default text output -->

    
    <xsl:template match="/soap:Envelope/soap:Body/hl7:*/hl7:id">
        <xsl:call-template name="Transmission_ID"/>
            <xsl:apply-templates/>     </xsl:template>
    <xsl:template match="/hl7:*/hl7:id">
        <xsl:call-template name="Transmission_ID"/>
            <xsl:apply-templates/>     </xsl:template>
    <xsl:template name="Transmission_ID">
        <xsl:call-template name="Identifier_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="expected_OID">
                <xsl:choose>
                    <xsl:when test="$ValidationMsgType = 'serverMsg'">DIS_MESSAGE_ID</xsl:when>
                    <xsl:otherwise>PORTAL_MESSAGE_ID</xsl:otherwise>
                </xsl:choose>
            </xsl:with-param>
            <xsl:with-param name="nullable">false</xsl:with-param>
        </xsl:call-template>
            <xsl:apply-templates/>     </xsl:template>

    <xsl:template match="/soap:Envelope/soap:Body/hl7:*/hl7:interactionId">
        <xsl:call-template name="Transmission_InteractionID"/>
            <xsl:apply-templates/>     </xsl:template>
    <xsl:template match="/hl7:*/hl7:interactionId">
        <xsl:call-template name="Transmission_InteractionID"/>
            <xsl:apply-templates/>     </xsl:template>
    <xsl:template name="Transmission_InteractionID">
        <xsl:call-template name="Required_Attr_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="attr_name">root</xsl:with-param>
            <xsl:with-param name="nullable">false</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="Required_Attr_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="attr_name">extension</xsl:with-param>
            <xsl:with-param name="nullable">false</xsl:with-param>
        </xsl:call-template>

        <xsl:call-template name="Identifier_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="expected_OID">DIS_INTERACTION_ID</xsl:with-param>
        </xsl:call-template>
        
        <xsl:variable name="rootName">
            <xsl:value-of select="local-name(parent::node())"/>
        </xsl:variable>
        
        <xsl:if test="@extension and not(@extension = $rootName)">
            <xsl:call-template name="ReportError">
                <!-- @extension must equal message name -->
                <xsl:with-param name="ErrorText" select="Interaction_Extension_wrong_value"/>
                <xsl:with-param name="currentNode" select="."/>
                <xsl:with-param name="elementName">@extension</xsl:with-param>
                <xsl:with-param name="expectedValue">
                    <xsl:value-of select="$rootName"/>
                </xsl:with-param>
                <xsl:with-param name="actualValue">
                    <xsl:value-of select="@extension"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:if>
            <xsl:apply-templates/>     </xsl:template>

    <xsl:template match="/soap:Envelope/soap:Body/hl7:*/hl7:acceptAckCode">
        <xsl:call-template name="Transmission_AcceptAckCode"/>
            <xsl:apply-templates/>     </xsl:template>
    <xsl:template match="/hl7:*/hl7:acceptAckCode">
        <xsl:call-template name="Transmission_AcceptAckCode"/>
            <xsl:apply-templates/>     </xsl:template>
    <xsl:template name="Transmission_AcceptAckCode">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/acceptAckCode"/>
        </xsl:call-template>
            <xsl:apply-templates/>     </xsl:template>

    <xsl:template match="/soap:Envelope/soap:Body/hl7:*/hl7:acknowledgement">
        <xsl:call-template name="Transmission_Acknowledgement"/>
            <xsl:apply-templates/>     </xsl:template>
    <xsl:template match="/hl7:*/hl7:acknowledgement">
        <xsl:call-template name="Transmission_Acknowledgement"/>
            <xsl:apply-templates/>     </xsl:template>
    <xsl:template name="Transmission_Acknowledgement">
        <xsl:call-template name="Identifier_Element_Test">
            <xsl:with-param name="node" select="hl7:targetMessage/hl7:id"/>
            <xsl:with-param name="expected_OID">PORTAL_MESSAGE_ID</xsl:with-param>
            <xsl:with-param name="nullable">false</xsl:with-param>
        </xsl:call-template>
        <xsl:variable name="extension">
            <xsl:value-of select="hl7:targetMessage/hl7:id/@extension"/>
        </xsl:variable>
        <xsl:variable name="lastMsgId">
            <xsl:value-of select="$lastServerRequest/descendant-or-self::hl7:*[1]/hl7:id/@extension"/>
        </xsl:variable>
        <xsl:if test="not($extension = $lastMsgId)">
            <xsl:call-template name="ReportError">
                <xsl:with-param name="ErrorText" select="Achnowledgement_of_wrong_message_ErrorMsg"/>
                <xsl:with-param name="expectedValue">
                    <xsl:value-of select="$lastMsgId"/>
                </xsl:with-param>
                <xsl:with-param name="actualValue">
                    <xsl:value-of select="$extension"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:if>
            <xsl:apply-templates/>     </xsl:template>

    <xsl:template match="/soap:Envelope/soap:Body/hl7:*/hl7:receiver">
        <xsl:call-template name="receiverElement"/>
    </xsl:template>
    <xsl:template match="/hl7:*/hl7:receiver">
        <xsl:call-template name="receiverElement"/>
    </xsl:template>
    <xsl:template name="receiverElement">
        <!--
        <xsl:call-template name="Identifier_Element_Test">
            <xsl:with-param name="node" select="hl7:device/hl7:id"/>
            <xsl:with-param name="extensionRequired">false</xsl:with-param>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="expected_OID">
                <xsl:choose>
                    <xsl:when test="$ValidationMsgType = 'serverMsg'">PORTAL_APPLICATION</xsl:when>
                    <xsl:otherwise>DIS_APPLICATION</xsl:otherwise>
                </xsl:choose>
            </xsl:with-param>
        </xsl:call-template>
            -->
            <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="/soap:Envelope/soap:Body/hl7:*/hl7:sender">
        <xsl:call-template name="senderElement"/>
    </xsl:template>
    <xsl:template match="/hl7:*/hl7:sender">
        <xsl:call-template name="senderElement"/>
    </xsl:template>
    <xsl:template name="senderElement">
        <!-- 
        <xsl:call-template name="Identifier_Element_Test">
                    <xsl:with-param name="node" select="hl7:device/hl7:id"/>
                    <xsl:with-param name="extensionRequired">false</xsl:with-param>
                    <xsl:with-param name="nullable">false</xsl:with-param>
                    <xsl:with-param name="expected_OID">
                        <xsl:choose>
                            <xsl:when test="$ValidationMsgType = 'serverMsg'">DIS_APPLICATION</xsl:when>
                            <xsl:otherwise>PORTAL_APPLICATION</xsl:otherwise>
                        </xsl:choose>
                        </xsl:with-param>
                </xsl:call-template>
           -->
            <xsl:apply-templates/>
    </xsl:template>

</xsl:stylesheet>
