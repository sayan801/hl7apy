<?xml version="1.0" encoding="UTF-8"?>
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->  <xsl:stylesheet xmlns:hl7="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:import href="../Lib/Validation_Lib.xsl"/>

    <xsl:variable name="Net_Amount_Incorrect_ErrorMsg">Amount supplied does not match the sum of all descendant Detail invoice elements and payment intent elements</xsl:variable>
    <xsl:variable name="Net_Amount_History_miss_match_ErrorMsg">Amount supplied does not match the amount of the invoice found in History</xsl:variable>
    <xsl:variable name="Incorrect_Currency_Value_ErrorMsg">Incorrect Currency value supplied</xsl:variable>
    <xsl:variable name="PayeeRole_Incorrect_ErrorMsg">PayeeRole is an incorrect value</xsl:variable>
    
    <xsl:template match="text()|@*"/>
    
    <xsl:template match="hl7:netAmt">
        <xsl:variable name="totalAmt" select="sum(parent::node()/hl7:reference/hl7:adjudicatedInvoiceElementGroup/hl7:netAmt/@value) + sum(parent::node()/hl7:reason/hl7:paymentIntent/hl7:amt/@value)"/>

        <xsl:if test="not(@value = $totalAmt)">
            <xsl:call-template name="ReportError">
                <xsl:with-param name="ErrorText" select="$Net_Amount_Incorrect_ErrorMsg"/>
                <xsl:with-param name="currentNode" select="."/>
                <xsl:with-param name="expectedValue"><xsl:value-of select="$totalAmt"/></xsl:with-param>
                <xsl:with-param name="actualValue"><xsl:value-of select="@value"/></xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        <xsl:call-template name="currency_Test">
            <xsl:with-param name="node" select="."/>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="hl7:amt">
        <xsl:call-template name="currency_Test">
            <xsl:with-param name="node" select="."/>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="statusCode">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/statusCodeNullified"/>
            <xsl:with-param name="codeSystemRequired">false</xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="hl7:adjudicatedInvoiceElementGroup">
        <xsl:if test="hl7:id">
            <xsl:variable name="InvoiceRoot" select="hl7:id/@root"/>
            <xsl:variable name="InvoiceExtension" select="hl7:id/@extension"/>
            <xsl:variable name="AdjudicatedInvoice" select="$AllServerResponses/descendant-or-self::FICR_IN610102/descendant::hl7:adjudicatedInvoiceElementGroup[hl7:id/@root = $InvoiceRoot and hl7:id/@extension = $InvoiceExtension]"/>
            <xsl:if test="$AdjudicatedInvoice">
                <xsl:if test="not(hl7:netAmt/@value = $AdjudicatedInvoice/hl7:netAmt/@value )">
                    <xsl:call-template name="ReportError">
                        <xsl:with-param name="ErrorText" select="$Net_Amount_History_miss_match_ErrorMsg"/>
                        <xsl:with-param name="currentNode" select="hl7:netAmt"/>
                        <xsl:with-param name="expectedValue"><xsl:value-of select="$AdjudicatedInvoice/hl7:netAmt/@value"/></xsl:with-param>
                        <xsl:with-param name="actualValue"><xsl:value-of select="hl7:netAmt/@value"/></xsl:with-param>
                    </xsl:call-template>
                </xsl:if>
            </xsl:if>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- general invoice checks -->
    <xsl:template match="hl7:credit/hl7:account/hl7:holder/hl7:payeeRole">
        <xsl:if test="not(@classCode='PROV')">
            <xsl:call-template name="ReportError">
                <xsl:with-param name="ErrorText" select="$PayeeRole_Incorrect_ErrorMsg"/>
                <xsl:with-param name="currentNode" select="."/>
                <xsl:with-param name="expectedValue">PROV</xsl:with-param>
                <xsl:with-param name="actualValue"><xsl:value-of select="@classCode"/></xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>

    <!-- adjudicated results checks -->
    <xsl:template match="hl7:adjudicatedInvoiceElementGroup/hl7:id">
        <xsl:call-template name="Identifier_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">true</xsl:with-param>
            <xsl:with-param name="expected_OID">DIS_ADJUDICATED_INVOICE_GROUP_ID</xsl:with-param>
            <!--<xsl:with-param name="expected_OID">DIS_DISPENSE_ID</xsl:with-param>-->
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:adjudicatedInvoiceElementGroup/hl7:code">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/InvoiceReasonOfCode"/>
            <xsl:with-param name="codeSystemRequired">false</xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    <!-- named tempates -->
    <xsl:template name="currency_Test">
        <xsl:param name="node"/>
        <xsl:if test="not($node/@currency = 'CAD')">
            <xsl:call-template name="ReportError">
                <xsl:with-param name="ErrorText" select="$Incorrect_Currency_Value_ErrorMsg"/>
                <xsl:with-param name="currentNode" select="$node"/>
                <xsl:with-param name="expectedValue">CAD</xsl:with-param>
                <xsl:with-param name="actualValue">
                    <xsl:value-of select="$node/@currency"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
