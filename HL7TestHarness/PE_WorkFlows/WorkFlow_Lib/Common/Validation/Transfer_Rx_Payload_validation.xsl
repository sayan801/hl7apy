<?xml version="1.0" encoding="UTF-8"?>
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->  <xsl:stylesheet xmlns:hl7="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:import href="../Lib/Validation_Lib.xsl"/>

    <xsl:template match="text()|@*"/>

    <xsl:template match="hl7:supplyRequest/hl7:location/hl7:serviceDeliveryLocation/hl7:id">
        <xsl:call-template name="Identifier_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">true</xsl:with-param>
            <xsl:with-param name="expected_OID_List" select="$OIDSet/serviceDeliveryLocation"/>
            <xsl:with-param name="msgType" select="$ValidationMsgType"/>
        </xsl:call-template>
            <xsl:apply-templates/>     </xsl:template>
    <xsl:template match="hl7:supplyRequest">
        <xsl:call-template name="MaxAllowed_ChildElement_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="child_element_name">fulfillment</xsl:with-param>
            <xsl:with-param name="child_element_max" select="1"/>
            <xsl:with-param name="child_element_min" select="0"/>
        </xsl:call-template>
            <xsl:apply-templates/>     </xsl:template>
    <xsl:template match="hl7:supplyRequest/hl7:fulfillment/hl7:subsetCode">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/fulfillmentSubsetCode"/>
        </xsl:call-template>
            <xsl:apply-templates/>     </xsl:template>
    <xsl:template match="hl7:supplyRequest/hl7:fulfillment/hl7:supplyEvent/hl7:quantity">
        <xsl:call-template name="Required_Attr_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="attr_name">value</xsl:with-param>
        </xsl:call-template>
            <xsl:apply-templates/>     </xsl:template>
    <xsl:template match="hl7:supplyRequest/hl7:componentOf/hl7:actRequest/hl7:id">
        <xsl:call-template name="Identifier_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="expected_OID">DIS_PRESCRIPTION_ID</xsl:with-param>
            <xsl:with-param name="msgType" select="$ValidationMsgType"/>
        </xsl:call-template>
            <xsl:apply-templates/>     </xsl:template>

</xsl:stylesheet>
