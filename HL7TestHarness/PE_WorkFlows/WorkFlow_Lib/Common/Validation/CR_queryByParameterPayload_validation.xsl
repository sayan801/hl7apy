<?xml version="1.0" encoding="UTF-8"?>
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->
<xsl:stylesheet xmlns:hl7="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:import href="..\Lib\Validation_Lib.xsl"/>

    <xsl:output omit-xml-declaration="yes"/>

    <!-- CR error messages. -->
    <xsl:variable name="Person_family_name_missing_ErrorMsg">Missing Element. Person name must contain a family name element</xsl:variable>
    <xsl:variable name="Person_family_name_short_ErrorMsg">Family name must be a minimum of 3 characters</xsl:variable>
    <xsl:variable name="Person_name_extra_elements_ErrorMsg">Extra elements found. Person name can only contain a family and given elements</xsl:variable>


    <xsl:template match="hl7:queryByParameterPayload/hl7:queryId">
        <xsl:call-template name="Identifier_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">true</xsl:with-param>
            <xsl:with-param name="expected_OID">PORTAL_QUERY_ID</xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="hl7:queryByParameterPayload/hl7:statusCode">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/statusCode"/>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="hl7:queryByParameterPayload/hl7:client.id/hl7:value">
        <xsl:call-template name="Identifier_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="hl7:queryByParameterPayload/hl7:person.birthTime/hl7:value">
        <xsl:call-template name="NonNullable_optional_node"/>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="hl7:queryByParameterPayload/hl7:person.gender/hl7:value">
        <xsl:call-template name="NonNullable_optional_node"/>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="hl7:queryByParameterPayload/hl7:person.name/hl7:value">
        <!-- we only accept family (required)and given(optional) sub elements or a nullflavor on value.-->
        <xsl:if test="not(@nullFlavor)">
            <xsl:if test="not(hl7:family)">
                <xsl:call-template name="ReportError">
                    <xsl:with-param name="ErrorText" select="$Person_family_name_missing_ErrorMsg"/>
                    <xsl:with-param name="currentNode" select="."/>
                    <xsl:with-param name="elementName"/>
                    <xsl:with-param name="expectedValue">family</xsl:with-param>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="hl7:family and string-length(hl7:family) &lt; 3">
                <xsl:call-template name="ReportError">
                    <xsl:with-param name="ErrorText" select="$Person_family_name_short_ErrorMsg"/>
                    <xsl:with-param name="currentNode" select="."/>
                    <xsl:with-param name="elementName">family</xsl:with-param>
                    <xsl:with-param name="actualValue">
                        <xsl:value-of select="hl7:family"/>
                    </xsl:with-param>
                    <xsl:with-param name="expectedValue">(String must be 3 or more characters long)</xsl:with-param>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="count(*) > count(hl7:family) + count(hl7:given)">
                <xsl:call-template name="ReportError">
                    <xsl:with-param name="ErrorText" select="$Person_name_extra_elements_ErrorMsg"/>
                    <xsl:with-param name="currentNode" select="."/>
                    <xsl:with-param name="elementName"/>
                    <xsl:with-param name="expectedValue">family and/or given</xsl:with-param>
                    <xsl:with-param name="actualValue">
                        <xsl:for-each select="*">
                            <xsl:value-of select="name()"/>
                            <xsl:text>; </xsl:text>
                        </xsl:for-each>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:if>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>

    <!-- CR Find Client response uses a different queryByParameterPayload name so we have to repeat everything -->

    <xsl:template match="hl7:queryByParameter/hl7:queryId">
        <xsl:call-template name="Identifier_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">true</xsl:with-param>
            <xsl:with-param name="expected_OID">PORTAL_QUERY_ID</xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="hl7:queryByParameter/hl7:statusCode">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/statusCode"/>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="hl7:queryByParameter/hl7:client.id/hl7:value">
        <!-- if client.id is present is can not be nullflavored. -->
        <xsl:call-template name="Identifier_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="hl7:queryByParameter/hl7:person.birthTime/hl7:value">
        <!-- if client.id is present is can not be nullflavored. -->
        <xsl:call-template name="NonNullable_optional_node"/>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="hl7:queryByParameter/hl7:person.gender/hl7:value">
        <!-- if client.id is present is can not be nullflavored. -->
        <xsl:call-template name="NonNullable_optional_node"/>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="hl7:queryByParameter/hl7:person.name/hl7:value">
        <!-- we only accept family (required)and given(optional) sub elements -->
        <xsl:if test="not(@nullFlavor)">
                <xsl:if test="not(hl7:family)">
                    <xsl:call-template name="ReportError">
                        <xsl:with-param name="ErrorText" select="$Person_family_name_missing_ErrorMsg"/>
                        <xsl:with-param name="currentNode" select="."/>
                        <xsl:with-param name="elementName"/>
                        <xsl:with-param name="expectedValue">family</xsl:with-param>
                    </xsl:call-template>
                </xsl:if>
                <xsl:if test="count(*) > count(hl7:family) + count(hl7:given)">
                    <xsl:call-template name="ReportError">
                        <xsl:with-param name="ErrorText" select="$Person_name_extra_elements_ErrorMsg"/>
                        <xsl:with-param name="currentNode" select="."/>
                        <xsl:with-param name="elementName"/>
                        <xsl:with-param name="expectedValue">family and/or given</xsl:with-param>
                        <xsl:with-param name="actualValue">
                            <xsl:for-each select="*">
                                <xsl:value-of select="name()"/>
                                <xsl:text>; </xsl:text>
                            </xsl:for-each>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:if>
            </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>

</xsl:stylesheet>
