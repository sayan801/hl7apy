<?xml version="1.0" encoding="UTF-8"?>
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->
<xsl:stylesheet xmlns:hl7="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:import href="../Lib/Validation_Lib.xsl"/>

    <xsl:variable name="DIS_Dispense_ID_ErrorMsg">Invoice Dispense ID does not match the DIS supplied Dispense ID of the last Dispense message sent</xsl:variable>
    <xsl:variable name="Local_Dispense_ID_ErrorMsg">Invoice local Dispense ID does not match the Local Dispense ID of the last Dispense message sent</xsl:variable>

    <xsl:template match="text()|@*"/>

    <xsl:template match="hl7:paymentRequest">
        <xsl:choose>
            <xsl:when test="hl7:id/@nullFlavor">
                <xsl:call-template name="Nullable_Element_Test">
                    <xsl:with-param name="node" select="hl7:id"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <!-- verify that the DIS ID is correct -->
                <xsl:variable name="DISDispenseID" select="$historyData/response/client/descendant-or-self::hl7:PORX_IN020130CA[position()=last()]/hl7:controlActEvent/hl7:subject/hl7:supplyEvent/hl7:id"/>
                <xsl:if test="not(hl7:id/@root = $DISDispenseID/@root)">
                    <xsl:call-template name="ReportError">
                        <xsl:with-param name="ErrorText" select="$DIS_Dispense_ID_ErrorMsg"/>
                        <xsl:with-param name="currentNode" select="hl7:id"/>
                        <xsl:with-param name="elementName">@root</xsl:with-param>
                        <xsl:with-param name="expectedValue">
                            <xsl:value-of select="$DISDispenseID/@root"/>
                        </xsl:with-param>
                        <xsl:with-param name="actualValue">
                            <xsl:value-of select="hl7:id/@root"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:if>
                <xsl:if test="not(hl7:id/@extension = $DISDispenseID/@extension)">
                    <xsl:call-template name="ReportError">
                        <xsl:with-param name="ErrorText" select="$DIS_Dispense_ID_ErrorMsg"/>
                        <xsl:with-param name="currentNode" select="hl7:id"/>
                        <xsl:with-param name="elementName">@extension</xsl:with-param>
                        <xsl:with-param name="expectedValue">
                            <xsl:value-of select="$DISDispenseID/@extension"/>
                        </xsl:with-param>
                        <xsl:with-param name="actualValue">
                            <xsl:value-of select="hl7:id/@extension"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:if>

                <!-- verify that the Local Client ID is correct -->
                <xsl:variable name="LocalDispenseID" select="$historyData/request/client/descendant-or-self::hl7:PORX_IN020190CA[position()=last()]/hl7:controlActEvent/hl7:subject/hl7:medicationDispense/hl7:id"/>
                <xsl:if test="not(hl7:reasonOf/hl7:invoiceElementGroup/hl7:id/@root = $LocalDispenseID/@root)">
                    <xsl:call-template name="ReportError">
                        <xsl:with-param name="ErrorText" select="$Local_Dispense_ID_ErrorMsg"/>
                        <xsl:with-param name="currentNode" select="hl7:reasonOf/hl7:invoiceElementGroup/hl7:id"/>
                        <xsl:with-param name="elementName">@root</xsl:with-param>
                        <xsl:with-param name="expectedValue">
                            <xsl:value-of select="$LocalDispenseID/@root"/>
                        </xsl:with-param>
                        <xsl:with-param name="actualValue">
                            <xsl:value-of select="hl7:reasonOf/hl7:invoiceElementGroup/hl7:id/@root"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:if>
                <xsl:if test="not(hl7:reasonOf/hl7:invoiceElementGroup/hl7:id/@extension = $LocalDispenseID/@extension)">
                    <xsl:call-template name="ReportError">
                        <xsl:with-param name="ErrorText" select="$Local_Dispense_ID_ErrorMsg"/>
                        <xsl:with-param name="currentNode" select="hl7:reasonOf/hl7:invoiceElementGroup/hl7:id"/>
                        <xsl:with-param name="elementName">@extension</xsl:with-param>
                        <xsl:with-param name="expectedValue">
                            <xsl:value-of select="$LocalDispenseID/@extension"/>
                        </xsl:with-param>
                        <xsl:with-param name="actualValue">
                            <xsl:value-of select="hl7:reasonOf/hl7:invoiceElementGroup/hl7:id/@extension"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>

        <xsl:apply-templates/>
    </xsl:template>

</xsl:stylesheet>
