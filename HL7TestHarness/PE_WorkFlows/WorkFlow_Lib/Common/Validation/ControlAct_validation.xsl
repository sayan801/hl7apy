<?xml version="1.0" encoding="UTF-8"?>
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->  <xsl:stylesheet xmlns:hl7="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:import href="../Lib/Validation_Lib.xsl"/>

    <xsl:variable name="Incorrect_Trigger_Event_ErrorMsg">Incorrect trigger event for message type</xsl:variable>
    <xsl:variable name="Missing_Trigger_Event_ErrorMsg">Message Name does not have a known trigger Event name</xsl:variable>
    <xsl:variable name="Missing_Effective_Time_ErrorMsg">effectiveTime element must be provided</xsl:variable>

    <xsl:template match="text()|@*"/>

    <!-- validate id root/extension (unique and correct) -->
    <xsl:template match="hl7:controlActEvent/hl7:id">
        <!-- make sure this is the top level control act  -->
        <xsl:if test="not(../ancestor::hl7:controlActEvent)">
            <xsl:call-template name="Identifier_Element_Test">
                <!-- test for correct value -->
                <xsl:with-param name="node" select="."/>
                <xsl:with-param name="nullable">false</xsl:with-param>
                <xsl:with-param name="expected_OID">
                    <xsl:choose>
                        <xsl:when test="$ValidationMsgType='serverMsg' ">DIS_CONTROL_ACT_ID</xsl:when>
                        <xsl:otherwise>PORTAL_CONTROL_ACT_ID</xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
            </xsl:call-template>

            <xsl:call-template name="Unique_ID_Test">
                <xsl:with-param name="node" select="."/>
            </xsl:call-template>
        </xsl:if>
            <xsl:apply-templates/>     </xsl:template>


    <!-- validate trigger event code against xml file with message / triggerEvent sets-->

    <xsl:template match="hl7:controlActEvent/hl7:code">
        <!-- make sure this is the top level control act  -->
        <xsl:if test="not(../ancestor::hl7:controlActEvent)">
            <xsl:variable name="rootName">
                <xsl:value-of select=" local-name(//descendant-or-self::hl7:*[1])"/>
            </xsl:variable>
            <xsl:variable name="MessageData" select="$MessageList/descendant-or-self::node()[local-name() = $rootName]"/>
            <xsl:choose>
                <xsl:when test="$MessageData">
                    <xsl:variable name="codeEventName" select="@code"/>
                    <xsl:variable name="checkEventName">
                        <xsl:value-of select="$MessageData/triggerEvent/@value"/>
                    </xsl:variable>
                    <xsl:choose>
                        <xsl:when test="not($checkEventName = $codeEventName)">
                            <xsl:call-template name="ReportError">
                                <xsl:with-param name="ErrorText" select="$Incorrect_Trigger_Event_ErrorMsg"/>
                                <xsl:with-param name="expectedValue" select="$checkEventName"/>
                                <xsl:with-param name="actualValue" select="$codeEventName"/>
                            </xsl:call-template>
                        </xsl:when>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="ReportError">
                        <xsl:with-param name="ErrorText" select="$Missing_Trigger_Event_ErrorMsg"/>
                        <xsl:with-param name="expectedValue"/>
                        <xsl:with-param name="actualValue" select="$rootName"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
            <xsl:apply-templates/>     </xsl:template>

    <!-- validate effectiveTime element-->
    <xsl:template match="hl7:controlActEvent">
        <!-- make sure this is the top level control act  -->
        <xsl:if test="not(ancestor::hl7:controlActEvent)">
            <xsl:if test="not(hl7:queryByParameter) and ValidationMsgType='clientMsg' ">
                <!-- if NOT a query, then effectiveTime required in controlActEvent -->
                <xsl:choose>
                    <xsl:when test="hl7:effectiveTime">
                        <xsl:call-template name="Nullable_Element_Test">
                            <xsl:with-param name="node" select="hl7:effectiveTime"/>
                            <xsl:with-param name="nullable">false</xsl:with-param>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="ReportError">
                            <xsl:with-param name="ErrorText" select="$Missing_Effective_Time_ErrorMsg"/>
                            <xsl:with-param name="expectedValue"/>
                            <xsl:with-param name="actualValue"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:if>
            <xsl:apply-templates/>     </xsl:template>

    <!-- validate author element -->
    <xsl:template match="hl7:controlActEvent/hl7:author/hl7:time">
        <!-- make sure this is the top level control act  -->
        <xsl:if test="not(../ancestor::hl7:controlActEvent)">
            <xsl:call-template name="Nullable_Element_Test">
                <xsl:with-param name="node" select="."/>
                <xsl:with-param name="nullable">true</xsl:with-param>
            </xsl:call-template>
        </xsl:if>
            <xsl:apply-templates/>     </xsl:template>

    <!-- validate assignedPerson for both supervisor and author element -->
    <xsl:template match="hl7:controlActEvent/node()/hl7:assignedPerson">
        <!-- make sure this is the top level control act  -->
        <xsl:if test="not(../ancestor::hl7:controlActEvent)">
            <xsl:call-template name="Assigned_Person_Test">
                <xsl:with-param name="node" select="."/>
            </xsl:call-template>
        </xsl:if>
            <xsl:apply-templates/>     </xsl:template>

    <!-- validate location element -->
    <xsl:template match="hl7:controlActEvent/hl7:location/hl7:serviceDeliveryLocation">
        <!-- make sure this is the top level control act  -->
        <xsl:if test="not(../ancestor::hl7:controlActEvent)">
            <xsl:call-template name="Service_Location_Test">
                <xsl:with-param name="node" select="."/>
            </xsl:call-template>
        </xsl:if>
            <xsl:apply-templates/>     </xsl:template>

</xsl:stylesheet>
