<?xml version="1.0" encoding="UTF-8"?>
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->
<xsl:stylesheet xmlns:hl7="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:import href="../Lib/Report_Lib.xsl"/>
    <xsl:import href="../Lib/TestData_Lib.xsl"/>
    <!-- 
    <xsl:import href="../Lib/MsgCreation_Lib.xsl"/>
    -->
    <xsl:param name="WorkingDirectory"/>

    <xsl:output omit-xml-declaration="yes"/>

    <xsl:variable name="MessageList" select="document('messageData.xml')"/>

    <xsl:variable name="ValidationMsgType">
        <xsl:choose>
            <xsl:when test="$mapping = 'toClient' ">serverMsg</xsl:when>
            <xsl:otherwise>clientMsg</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="codeSystemsFileName"><xsl:value-of select="$WorkingDirectory"/>\CodeSystems.xml</xsl:variable>
    <xsl:variable name="ListFile" select="document($codeSystemsFileName)"/>
    <xsl:variable name="CodeSet" select="$ListFile/descendant-or-self::codeSystems"/>
    <xsl:variable name="OIDSet" select="$ListFile/descendant-or-self::OIDSets"/>

    <xsl:variable name="valid_nullFlavor">NI</xsl:variable>


    <xsl:variable name="NullFlavor_with_other_attr_ErrorMsg">Elements that are null flavored can not have other attributes</xsl:variable>
    <xsl:variable name="Root_ID_not_valid_ErrorMsg">root attr identifier is invalid for this position</xsl:variable>
    <xsl:variable name="Extension_ID_not_valid_ErrorMsg">extension attr must be present if element is not null flavored.</xsl:variable>
    <xsl:variable name="non_Nullable_element_ErrorMsg">Non nullable element contains a nullFlavor attr.</xsl:variable>
    <xsl:variable name="CodeSystem_not_valid_ErrorMsg">Code System not found in validation code list.</xsl:variable>
    <xsl:variable name="Code_not_valid_ErrorMsg">Code not found in validation code list for the given code system.</xsl:variable>
    <xsl:variable name="Unit_not_valid_ErrorMsg">Unit not found in validation code list.</xsl:variable>
    <xsl:variable name="Person_family_name_missing_ErrorMsg">Missing Element. Person name must contain a family name element</xsl:variable>
    <xsl:variable name="Person_name_extra_elements_ErrorMsg">Extra elements found. Person name can only contain a family and given elements</xsl:variable>
    <xsl:variable name="ID_not_unique_in_history_ErrorMsg">id not unique within history</xsl:variable>
    <xsl:variable name="Required_Attr_Missing_ErrorMsg">Required Attr Missing</xsl:variable>
    <xsl:variable name="Required_ChildElement_Missing_ErrorMsg">Required Child Element Missing</xsl:variable>
    <xsl:variable name="CodeSystem_Missing_ErrorMsg">Element requires a CodeSystem</xsl:variable>
    <xsl:variable name="Element_Missing_Required_Child_Nodes_ErrorMsg">Element requires sub elements or text to be present.</xsl:variable>
    <xsl:variable name="Extra_elements_ErrorMsg">Extra elements found</xsl:variable>
    <xsl:variable name="Incorrect_NullFlavor_Value_ErrorMsg">Element is nullFlavored with the incorrect nullFlavor value</xsl:variable>
    <xsl:variable name="DisAllowed_ChildElement_Present_ErrorMsg">Element contains a child element that is not allowed in this context.</xsl:variable>
    <xsl:variable name="Min_ChildElement_Not_Reached_ErrorMsg">Element contains to few child element.</xsl:variable>
    <xsl:variable name="Max_ChildElement_Exceded_ErrorMsg">Element contains to many child element.</xsl:variable>
    <xsl:variable name="Response_Patient_not_same_as_request_ErrorMsg">Response Patient elements do not match Requested Patient elements</xsl:variable>
    <xsl:variable name="Response_ID_not_same_as_request_ErrorMsg">Response ID elements do not match Requested Message ID</xsl:variable>
    <xsl:variable name="ClassCode_attribute_missing_ErrorMsg">Required 'classCode' attribute is missing</xsl:variable>

    <!-- when going from lower to upper wild card character is also removed. -->
    <xsl:variable name="lowerCase">abcdefghijklmnopqrstuvwxyz%</xsl:variable>
    <xsl:variable name="upperCase">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>

    <!-- Template to verify that current id is unique with in all history -->
    <xsl:template name="Unique_ID_Test">
        <xsl:param name="node"/>

        <xsl:if test="count($historyData[position()&lt; last()]/descendant::hl7:id[@root=$node/@root and @extension=$node/@extension]) > 1">
            <xsl:call-template name="ReportError">
                <xsl:with-param name="ErrorText" select="$ID_not_unique_in_history_ErrorMsg"/>
                <xsl:with-param name="currentNode" select="$node"/>
                <xsl:with-param name="expectedValue">
                    <xsl:text>History Data found at following locations:</xsl:text>
                    <xsl:for-each select="$historyData[position()&lt; last()]/descendant::hl7:id[@root=$node/@root and @extension=$node/@extension]">
                        <xsl:call-template name="xpath"/>
                    </xsl:for-each>
                </xsl:with-param>
                <xsl:with-param name="actualValue">root:<xsl:value-of select="$node/@root"/> extension:<xsl:value-of select="$node/@extension"/></xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- Template to test nodes that have a required attribute -->
    <xsl:template name="Required_Attr_Test">
        <xsl:param name="node"/>
        <xsl:param name="nullable">true</xsl:param>
        <xsl:param name="attr_name"/>

        <xsl:choose>
            <xsl:when test="$node/@nullFlavor">
                <xsl:call-template name="Nullable_Element_Test">
                    <xsl:with-param name="node" select="$node"/>
                    <xsl:with-param name="nullable" select="$nullable"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="not($node/@*[local-name() = $attr_name])">
                <xsl:call-template name="ReportError">
                    <xsl:with-param name="ErrorText" select="$Required_Attr_Missing_ErrorMsg"/>
                    <xsl:with-param name="currentNode" select="$node"/>
                    <xsl:with-param name="elementName" select="$attr_name"/>
                    <xsl:with-param name="expectedValue"/>
                    <xsl:with-param name="actualValue"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- Template to test nodes that have a required element -->
    <xsl:template name="Required_ChildElement_Test">
        <xsl:param name="node"/>
        <xsl:param name="nullable">true</xsl:param>
        <xsl:param name="child_element_name"/>

        <xsl:variable name="ChildElement" select="$node/child::node()[local-name() = $child_element_name]"/>
        <xsl:choose>
            <xsl:when test="not($ChildElement)">
                <xsl:call-template name="ReportError">
                    <xsl:with-param name="ErrorText" select="$Required_ChildElement_Missing_ErrorMsg"/>
                    <xsl:with-param name="currentNode" select="$node"/>
                    <xsl:with-param name="elementName"/>
                    <xsl:with-param name="expectedValue" select="$child_element_name"/>
                    <xsl:with-param name="actualValue"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$ChildElement/@nullFlavor">
                <xsl:call-template name="Nullable_Element_Test">
                    <xsl:with-param name="node" select="$node"/>
                    <xsl:with-param name="nullable" select="$nullable"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- Template to test that child element is not present -->
    <xsl:template name="DisAllowed_ChildElement_Test">
        <xsl:param name="node"/>
        <xsl:param name="child_element_name"/>

        <xsl:variable name="ChildElement" select="$node/child::node()[local-name() = $child_element_name]"/>
        <xsl:if test="$ChildElement">
            <xsl:call-template name="ReportError">
                <xsl:with-param name="ErrorText" select="$DisAllowed_ChildElement_Present_ErrorMsg"/>
                <xsl:with-param name="currentNode" select="$node"/>
                <xsl:with-param name="elementName"/>
                <xsl:with-param name="expectedValue"/>
                <xsl:with-param name="actualValue" select="$child_element_name"/>
            </xsl:call-template>
        </xsl:if>

    </xsl:template>

    <!-- Template to test that to many or too few child element are present -->
    <xsl:template name="MaxAllowed_ChildElement_Test">
        <xsl:param name="node"/>
        <xsl:param name="child_element_name"/>
        <xsl:param name="child_element_max" select="999"/>
        <xsl:param name="child_element_min" select="0"/>


        <xsl:variable name="ChildElementCount" select="count($node/child::node()[local-name() = $child_element_name])"/>
        <xsl:if test="$ChildElementCount &gt; $child_element_max">
            <xsl:call-template name="ReportError">
                <xsl:with-param name="ErrorText" select="$Max_ChildElement_Exceded_ErrorMsg"/>
                <xsl:with-param name="currentNode" select="$node"/>
                <xsl:with-param name="elementName"/>
                <xsl:with-param name="expectedValue">count(<xsl:value-of select="$child_element_name"/>) &lt;= <xsl:value-of select="$child_element_max"/></xsl:with-param>
                <xsl:with-param name="actualValue">count(<xsl:value-of select="$child_element_name"/>) = <xsl:value-of select="$ChildElementCount"/></xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="$ChildElementCount &lt; $child_element_min">
            <xsl:call-template name="ReportError">
                <xsl:with-param name="ErrorText" select="$Min_ChildElement_Not_Reached_ErrorMsg"/>
                <xsl:with-param name="currentNode" select="$node"/>
                <xsl:with-param name="elementName"/>
                <xsl:with-param name="expectedValue">count(<xsl:value-of select="$child_element_name"/>) &gt;= <xsl:value-of select="$child_element_min"/></xsl:with-param>
                <xsl:with-param name="actualValue">count(<xsl:value-of select="$child_element_name"/>) = <xsl:value-of select="$ChildElementCount"/></xsl:with-param>
            </xsl:call-template>
        </xsl:if>

    </xsl:template>

    <!-- Template to verify ID elements with roots and extensions that are nullable -->
    <xsl:template name="Identifier_Element_Test">
        <xsl:param name="node"/>
        <xsl:param name="nullable">true</xsl:param>
        <xsl:param name="expected_OID"/>
        <xsl:param name="expected_OID_List"/>
        <xsl:param name="extensionRequired">true</xsl:param>

        <xsl:variable name="root_value">
            <xsl:call-template name="getOIDRootByName">
                <xsl:with-param name="OID_Name" select="$expected_OID"/>
                <xsl:with-param name="msgType" select="$ValidationMsgType"/>
            </xsl:call-template>
        </xsl:variable>


        <xsl:choose>
            <xsl:when test="$node/@nullFlavor">
                <xsl:call-template name="Nullable_Element_Test">
                    <xsl:with-param name="nullable" select="$nullable"/>
                    <xsl:with-param name="node" select="$node"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <!-- if OID is defined verify the root attr is the correct value -->
                <xsl:if test="$expected_OID and not($node/@root = $root_value)">
                    <xsl:call-template name="ReportError">
                        <xsl:with-param name="ErrorText" select="$Root_ID_not_valid_ErrorMsg"/>
                        <xsl:with-param name="currentNode" select="$node"/>
                        <xsl:with-param name="elementName">@root</xsl:with-param>
                        <xsl:with-param name="expectedValue" select="$root_value"/>
                        <xsl:with-param name="actualValue" select="$node/@root"/>
                    </xsl:call-template>
                </xsl:if>

                <!-- if OID List is defined verify the root attr is the one of the values in the list -->
                <xsl:if test="$expected_OID_List">
                    <xsl:variable name="actual_OID_Name">
                        <xsl:call-template name="getOIDNameByRoot">
                            <xsl:with-param name="OID_Value">
                                <xsl:value-of select="$node/@root"/>
                            </xsl:with-param>
                            <xsl:with-param name="msgType" select="$ValidationMsgType"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:if test="not($expected_OID_List/descendant-or-self::node()[@OIDName=$actual_OID_Name])">
                        <xsl:call-template name="ReportError">
                            <xsl:with-param name="ErrorText" select="$Root_ID_not_valid_ErrorMsg"/>
                            <xsl:with-param name="currentNode" select="$node"/>
                            <xsl:with-param name="elementName">@root</xsl:with-param>
                            <xsl:with-param name="expectedValue">
                                <xsl:for-each select="$expected_OID_List/descendant-or-self::node()[local-name() = 'id']">
                                    <xsl:call-template name="getOIDRootByName">
                                        <xsl:with-param name="OID_Name">
                                            <xsl:value-of select="@OIDName"/>
                                        </xsl:with-param>
                                        <xsl:with-param name="msgType" select="$ValidationMsgType"/>
                                    </xsl:call-template>
                                    <xsl:if test="following-sibling::node()[local-name() = 'id']">
                                        <xsl:text>; </xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:with-param>
                            <xsl:with-param name="actualValue">
                                <xsl:value-of select="$node/@root"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:if>
                </xsl:if>
                <!-- extensions should alwasy be present if not nullflavored. -->
                <xsl:if test="($extensionRequired = 'true') and (not($node/@extension))">
                    <xsl:call-template name="ReportError">
                        <xsl:with-param name="ErrorText" select="$Extension_ID_not_valid_ErrorMsg"/>
                        <xsl:with-param name="currentNode" select="$node"/>
                        <xsl:with-param name="elementName">@extension</xsl:with-param>
                        <xsl:with-param name="expectedValue"/>
                        <xsl:with-param name="actualValue"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="Nullable_Element_Test">
        <xsl:param name="nullable">true</xsl:param>
        <xsl:param name="nullFlavor"><xsl:value-of select="$valid_nullFlavor"/></xsl:param>
        <xsl:param name="node"/>
        <xsl:if test="$node/@nullFlavor">
            <xsl:choose>
                <!-- nullflavor found check if it is allowed -->
                <xsl:when test="$nullable='false'">
                    <xsl:call-template name="ReportError">
                        <xsl:with-param name="ErrorText" select="$non_Nullable_element_ErrorMsg"/>
                        <xsl:with-param name="currentNode" select="$node"/>
                        <xsl:with-param name="elementName">@nullFlavor</xsl:with-param>
                        <xsl:with-param name="expectedValue"/>
                        <xsl:with-param name="actualValue"/>
                    </xsl:call-template>
                </xsl:when>
                <!-- test that the nullFlavor attr is the only one present -->
                <xsl:when test="count($node/@*) > 1">
                    <xsl:call-template name="ReportError">
                        <xsl:with-param name="ErrorText" select="$NullFlavor_with_other_attr_ErrorMsg"/>
                        <xsl:with-param name="currentNode" select="$node"/>
                        <xsl:with-param name="elementName">@nullFlavor</xsl:with-param>
                        <xsl:with-param name="expectedValue"/>
                        <xsl:with-param name="actualValue"/>
                    </xsl:call-template>
                </xsl:when>
                <!-- test that the nullFlavor attr is the correct value -->
                <xsl:when test="not($node/@nullFlavor = $nullFlavor)">
                    <xsl:call-template name="ReportError">
                        <xsl:with-param name="ErrorText" select="$Incorrect_NullFlavor_Value_ErrorMsg"/>
                        <xsl:with-param name="currentNode" select="$node"/>
                        <xsl:with-param name="elementName">@nullFlavor</xsl:with-param>
                        <xsl:with-param name="expectedValue">
                            <xsl:value-of select="$nullFlavor"/>
                        </xsl:with-param>
                        <xsl:with-param name="actualValue">
                            <xsl:value-of select="$node/@nullFlavor"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <!-- Template to test a coded value element.  -->
    <xsl:template name="Code_Element_Test">
        <xsl:param name="nullable">true</xsl:param>
        <xsl:param name="nullFlavor"><xsl:value-of select="$valid_nullFlavor"/></xsl:param>
        <xsl:param name="node"/>
        <xsl:param name="validCodeSet"/>
        <xsl:param name="codeSystemRequired">false</xsl:param>
        <xsl:param name="codeAttributeRequired">true</xsl:param>

        <xsl:choose>
            <xsl:when test="$node/@nullFlavor">
                <xsl:call-template name="Nullable_Element_Test">
                    <xsl:with-param name="nullable" select="$nullable"/>
                    <xsl:with-param name="nullFlavor" select="$nullFlavor"/>
                    <xsl:with-param name="node" select="$node"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$node/@code">
                <!-- @code is normally optional in schema, so test for it -->
                <xsl:if test="$validCodeSet">
                    <xsl:variable name="code" select="$node/@code"/>
                    <xsl:choose>
                        <xsl:when test="$codeSystemRequired='true' and not($node/@codeSystem)">
                            <xsl:call-template name="ReportError">
                                <xsl:with-param name="ErrorText" select="$CodeSystem_Missing_ErrorMsg"/>
                                <xsl:with-param name="currentNode" select="$node"/>
                                <xsl:with-param name="elementName">@codeSystem</xsl:with-param>
                                <xsl:with-param name="expectedValue"/>
                                <xsl:with-param name="actualValue"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="$node/@codeSystem">
                            <xsl:variable name="codeSystem">
                                <xsl:call-template name="getOIDNameByRoot">
                                    <xsl:with-param name="OID_Value">
                                        <xsl:value-of select="$node/@codeSystem"/>
                                    </xsl:with-param>
                                    <xsl:with-param name="msgType" select="$ValidationMsgType"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:choose>
                                <xsl:when test="not($validCodeSet/descendant-or-self::node()[@codeSystem=$codeSystem])">
                                    <xsl:call-template name="ReportError">
                                        <xsl:with-param name="ErrorText" select="$CodeSystem_not_valid_ErrorMsg"/>
                                        <xsl:with-param name="currentNode" select="$node"/>
                                        <xsl:with-param name="elementName">@codeSystem</xsl:with-param>
                                        <xsl:with-param name="expectedValue"/>
                                        <xsl:with-param name="actualValue" select="$node/@codeSystem"/>
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:when test="not($validCodeSet/descendant-or-self::node()[@codeSystem=$codeSystem][@code=$code or @code = '*' ])">
                                    <xsl:call-template name="ReportError">
                                        <xsl:with-param name="ErrorText" select="$Code_not_valid_ErrorMsg"/>
                                        <xsl:with-param name="currentNode" select="$node"/>
                                        <xsl:with-param name="elementName">@code</xsl:with-param>
                                        <xsl:with-param name="expectedValue">
                                            <xsl:for-each select="$validCodeSet/descendant-or-self::node()[@codeSystem=$codeSystem][@code]">
                                                <xsl:value-of select="@code"/>
                                                <xsl:if test="following-sibling::node()">
                                                    <xsl:text>; </xsl:text>
                                                </xsl:if>
                                            </xsl:for-each>
                                        </xsl:with-param>
                                        <xsl:with-param name="actualValue" select="$code"/>
                                    </xsl:call-template>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:if test="not($validCodeSet/descendant-or-self::node()[@code=$code or @code = '*' ])">
                                <xsl:call-template name="ReportError">
                                    <xsl:with-param name="ErrorText" select="$Code_not_valid_ErrorMsg"/>
                                    <xsl:with-param name="currentNode" select="$node"/>
                                    <xsl:with-param name="elementName">@code</xsl:with-param>
                                    <xsl:with-param name="expectedValue">
                                        <xsl:for-each select="$validCodeSet/descendant-or-self::node()[@code]">
                                            <xsl:value-of select="@code"/>
                                            <xsl:if test="following-sibling::node()">
                                                <xsl:text>; </xsl:text>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:with-param>
                                    <xsl:with-param name="actualValue" select="$code"/>
                                </xsl:call-template>
                            </xsl:if>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:when>
            <xsl:when test="$codeAttributeRequired='true' and not('$node/@code')">
                <!-- check for presence of required optional @code -->
                <xsl:call-template name="ReportError">
                    <xsl:with-param name="ErrorText" select="Code_attribute_missing_ErrorMsg"/>
                    <xsl:with-param name="currentNode" select="$node"/>
                    <xsl:with-param name="elementName">@code</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- Template to test a coded value element.  -->
    <xsl:template name="ClassCode_Element_Test">
        <xsl:param name="nullable">true</xsl:param>
        <xsl:param name="node"/>
        <xsl:param name="validCodeSet"/>
        <xsl:param name="codeAttributeRequired">true</xsl:param>

        <xsl:choose>
            <xsl:when test="$node/@nullFlavor">
                <xsl:call-template name="Nullable_Element_Test">
                    <xsl:with-param name="nullable" select="$nullable"/>
                    <xsl:with-param name="node" select="$node"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$node/@classCode">
                <!-- @code is normally optional in schema, so test for it -->
                <xsl:if test="$validCodeSet">
                    <xsl:variable name="code" select="$node/@classCode"/>

                    <xsl:if test="not($validCodeSet/descendant-or-self::node()[@code=$code or @code = '*' ])">
                        <xsl:call-template name="ReportError">
                            <xsl:with-param name="ErrorText" select="$Code_not_valid_ErrorMsg"/>
                            <xsl:with-param name="currentNode" select="$node"/>
                            <xsl:with-param name="elementName">@classCode</xsl:with-param>
                            <xsl:with-param name="expectedValue">
                                <xsl:for-each select="$validCodeSet/descendant-or-self::node()[@code]">
                                    <xsl:value-of select="@code"/>
                                    <xsl:if test="following-sibling::node()">
                                        <xsl:text>; </xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:with-param>
                            <xsl:with-param name="actualValue" select="$code"/>
                        </xsl:call-template>
                    </xsl:if>
                </xsl:if>
            </xsl:when>
            <xsl:when test="$codeAttributeRequired='true' and not('$node/@classCode')">
                <!-- check for presence of required optional @classCode -->
                <xsl:call-template name="ReportError">
                    <xsl:with-param name="ErrorText" select="$ClassCode_attribute_missing_ErrorMsg"/>
                    <xsl:with-param name="currentNode" select="$node"/>
                    <xsl:with-param name="elementName">@classCode</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- Template to test a coded value element.  -->
    <xsl:template name="Unit_Element_Test">
        <xsl:param name="nullable">true</xsl:param>
        <xsl:param name="node"/>
        <xsl:param name="value_required">true</xsl:param>
        <xsl:param name="unit_required">false</xsl:param>
        <xsl:param name="validCodeSet"/>


        <xsl:choose>
            <xsl:when test="$node/@nullFlavor">
                <xsl:call-template name="Nullable_Element_Test">
                    <xsl:with-param name="nullable" select="$nullable"/>
                    <xsl:with-param name="node" select="$node"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="$validCodeSet">
                    <xsl:variable name="unit" select="$node/@unit"/>
                    <xsl:if test="not($validCodeSet/descendant-or-self::node()[@code=$unit or @code = '*' or (not($unit) and @code='')])">
                        <xsl:call-template name="ReportError">
                            <xsl:with-param name="ErrorText" select="$Unit_not_valid_ErrorMsg"/>
                            <xsl:with-param name="currentNode" select="$node"/>
                            <xsl:with-param name="elementName">@unit</xsl:with-param>
                            <xsl:with-param name="expectedValue">
                                <xsl:for-each select="$validCodeSet/descendant-or-self::node()[@code]">
                                    <xsl:value-of select="@code"/>
                                    <xsl:if test="following-sibling::node()">
                                        <xsl:text>; </xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:with-param>
                            <xsl:with-param name="actualValue" select="$unit"/>
                        </xsl:call-template>
                    </xsl:if>
                </xsl:if>
                <xsl:if test="$unit_required = 'true' ">
                    <xsl:call-template name="Required_Attr_Test">
                        <xsl:with-param name="node" select="$node"/>
                        <xsl:with-param name="attr_name">unit</xsl:with-param>
                    </xsl:call-template>
                </xsl:if>
                <xsl:if test="$value_required = 'true' ">
                    <xsl:call-template name="Required_Attr_Test">
                        <xsl:with-param name="node" select="$node"/>
                        <xsl:with-param name="attr_name">value</xsl:with-param>
                    </xsl:call-template>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="NonNullable_optional_node">
        <xsl:call-template name="Nullable_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="Service_Location_Test">
        <xsl:param name="node"/>
        <xsl:call-template name="Identifier_Element_Test">
            <xsl:with-param name="node" select="$node/descendant-or-self::node()[local-name() = 'id']"/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="expected_OID_List" select="$OIDSet/serviceDeliveryLocation"/>
            <xsl:with-param name="msgType">clientMsg</xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="Assigned_Person_Test">
        <xsl:param name="node"/>
        <xsl:call-template name="Identifier_Element_Test">
            <xsl:with-param name="node" select="$node/descendant-or-self::node()[local-name() = 'id']"/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="expected_OID_List" select="$OIDSet/assignedPerson"/>
            <xsl:with-param name="msgType">clientMsg</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="Person_Name_Test">
            <xsl:with-param name="node" select="$node/descendant-or-self::node()[local-name() = 'name']"/>
            <xsl:with-param name="nullable">true</xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="Person_Name_Test">
        <xsl:param name="node"/>
        <xsl:param name="nullable">true</xsl:param>
        <xsl:param name="familyRequired">false</xsl:param>

        <xsl:choose>
            <xsl:when test="$node/@nullFlavor">
                <xsl:call-template name="Nullable_Element_Test">
                    <xsl:with-param name="node" select="$node"/>
                    <xsl:with-param name="nullable" select="$nullable"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <!-- we only accept family (required)and given(optional) sub elements -->
                <xsl:if test="$familyRequired='true' and not($node/hl7:family)">
                    <xsl:call-template name="ReportError">
                        <xsl:with-param name="ErrorText" select="$Person_family_name_missing_ErrorMsg"/>
                        <xsl:with-param name="currentNode" select="."/>
                        <xsl:with-param name="elementName"/>
                        <xsl:with-param name="expectedValue">family</xsl:with-param>
                    </xsl:call-template>
                </xsl:if>
                <!-- 
                <xsl:if test="count($node/*) > count($node/hl7:family) + count($node/hl7:given) ">
                    <xsl:call-template name="ReportError">
                        <xsl:with-param name="ErrorText" select="$Person_name_extra_elements_ErrorMsg"/>
                        <xsl:with-param name="currentNode" select="."/>
                        <xsl:with-param name="elementName"/>
                        <xsl:with-param name="expectedValue">family and/or given</xsl:with-param>
                        <xsl:with-param name="actualValue">
                            <xsl:for-each select="$node/*">
                                <xsl:value-of select="local-name()"/>
                                <xsl:if test="following-sibling::node()">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:if>
                -->
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="Child_Elements_Required_Test">
        <xsl:param name="node"/>
        <xsl:if test="not($node/child::node())">
            <xsl:call-template name="ReportError">
                <xsl:with-param name="ErrorText" select="$Element_Missing_Required_Child_Nodes_ErrorMsg"/>
                <xsl:with-param name="currentNode" select="."/>
                <xsl:with-param name="elementName"/>
                <xsl:with-param name="expectedValue"/>
                <xsl:with-param name="actualValue"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template name="Deceased_Elements_Test">
        <xsl:param name="node"/>
        <!-- deceasedInd node -->
        <xsl:param name="timeNodeName"/>
        <!-- associated deceasedTime node -->

        <xsl:call-template name="Required_Attr_Test">
            <xsl:with-param name="node" select="$node"/>
            <xsl:with-param name="attr_name">value</xsl:with-param>
            <xsl:with-param name="nullable">false</xsl:with-param>
        </xsl:call-template>

        <!-- if the person is deceased then there must be a deceased time as a sibling element -->
        <xsl:if test="$node/@value = 'true' ">
            <xsl:call-template name="Required_ChildElement_Test">
                <xsl:with-param name="node" select="$node/parent::node"/>
                <xsl:with-param name="child_element_name">
                    <xsl:value-of select="$timeNodeName"/>
                </xsl:with-param>
                <xsl:with-param name="nullable">false</xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>


    <xsl:template name="EffectiveTime_Element_Test">
        <xsl:param name="node"/>
        <xsl:param name="nullable">true</xsl:param>
        <xsl:param name="lowRequired">false</xsl:param>
        <xsl:param name="highRequired">false</xsl:param>
        <xsl:param name="widthRequired">false</xsl:param>
        <xsl:param name="centerRequired">false</xsl:param>
        <xsl:param name="lowAllowed">true</xsl:param>
        <xsl:param name="highAllowed">true</xsl:param>
        <xsl:param name="widthAllowed">true</xsl:param>
        <xsl:param name="centerAllowed">true</xsl:param>

        <xsl:call-template name="Nullable_Element_Test">
            <xsl:with-param name="node" select="$node"/>
            <xsl:with-param name="nullable" select="$nullable"/>
        </xsl:call-template>

        <xsl:if test="$lowRequired = 'true'">
            <xsl:call-template name="Required_ChildElement_Test">
                <xsl:with-param name="node" select="$node"/>
                <xsl:with-param name="child_element_name">low</xsl:with-param>
                <xsl:with-param name="nullable">false</xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="$highRequired = 'true'">
            <xsl:call-template name="Required_ChildElement_Test">
                <xsl:with-param name="node" select="$node"/>
                <xsl:with-param name="child_element_name">high</xsl:with-param>
                <xsl:with-param name="nullable">false</xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="$widthRequired = 'true'">
            <xsl:call-template name="Required_ChildElement_Test">
                <xsl:with-param name="node" select="$node"/>
                <xsl:with-param name="child_element_name">width</xsl:with-param>
                <xsl:with-param name="nullable">false</xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="$centerRequired = 'true'">
            <xsl:call-template name="Required_ChildElement_Test">
                <xsl:with-param name="node" select="$node"/>
                <xsl:with-param name="child_element_name">center</xsl:with-param>
                <xsl:with-param name="nullable">false</xsl:with-param>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="$lowAllowed = 'false'">
            <xsl:call-template name="DisAllowed_ChildElement_Test">
                <xsl:with-param name="node" select="."/>
                <xsl:with-param name="child_element_name">low</xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="$highAllowed = 'false'">
            <xsl:call-template name="DisAllowed_ChildElement_Test">
                <xsl:with-param name="node" select="."/>
                <xsl:with-param name="child_element_name">high</xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="$widthAllowed = 'false'">
            <xsl:call-template name="DisAllowed_ChildElement_Test">
                <xsl:with-param name="node" select="."/>
                <xsl:with-param name="child_element_name">width</xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="$centerAllowed = 'false'">
            <xsl:call-template name="DisAllowed_ChildElement_Test">
                <xsl:with-param name="node" select="."/>
                <xsl:with-param name="child_element_name">center</xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template name="Response_ID_Test">
        <!-- tests that ID for response is same as last message in history (request) -->
        <xsl:param name="node"/>
        <xsl:param name="requestNode"/>
        <xsl:if test="(not($requestNode/@root = $node/@root)) and (not($requestNode/@extension = $node/@extension))">
            <xsl:call-template name="ReportError">
                <xsl:with-param name="ErrorText" select="$Response_ID_not_same_as_request_ErrorMsg"/>
                <xsl:with-param name="currentNode" select="$node"/>
                <xsl:with-param name="expectedValue">
                    <xsl:call-template name="outputElementAttributes">
                        <xsl:with-param name="node" select="$requestNode"/>
                    </xsl:call-template>
                </xsl:with-param>
                <xsl:with-param name="actualValue">
                    <xsl:call-template name="outputElementAttributes">
                        <xsl:with-param name="node" select="$node"/>
                    </xsl:call-template>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template name="Requested_Patient_Test">
        <!-- compares response patient info returned to request patient info -->
        <xsl:param name="node"/>
        <!-- node is a 'patient' node -->

        <xsl:variable name="requestNode" select="$lastServerRequest//hl7:patient[1]"/>

        <xsl:if test="$requestNode/hl7:id">
            <!-- if request included patient id, check it -->
            <xsl:call-template name="Response_ID_Test">
                <xsl:with-param name="node" select="$node/hl7:id"/>
                <xsl:with-param name="requestNode" select="$requestNode/hl7:id"/>
            </xsl:call-template>
        </xsl:if>

        <!-- if request included telecom, check it against response -->
        <xsl:if test="$requestNode/hl7:telecom and not($requestNode/hl7:telecom/@nullFlavor) and $node/hl7:telecom and not($node/hl7:telecom/@nullFlavor) ">
            <xsl:if test="not($requestNode/hl7:telecom = $node/hl7:telecom)">
                <xsl:call-template name="ReportError">
                    <xsl:with-param name="ErrorText" select="$Response_Patient_not_same_as_request_ErrorMsg"/>
                    <xsl:with-param name="currentNode" select="$node/hl7:telecom"/>
                    <xsl:with-param name="expectedValue">
                        <xsl:call-template name="outputElementAttributes">
                            <xsl:with-param name="node" select="$requestNode/hl7:telecom"/>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="actualValue">
                        <xsl:call-template name="outputElementAttributes">
                            <xsl:with-param name="node" select="$node/hl7:telecom"/>
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:if>
        </xsl:if>

        <xsl:if test="$requestNode/hl7:patientPerson/hl7:name and not($requestNode/hl7:patientPerson/hl7:name/@nullFlavor) and $node/hl7:patientPerson/hl7:name and not($node/hl7:patientPerson/hl7:name/@nullFlavor) ">
            <xsl:if test=" not($requestNode/hl7:patientPerson/hl7:name/hl7:given = $node/hl7:patientPerson/hl7:name/hl7:given and $requestNode/hl7:patientPerson/hl7:name/hl7:family = $node/hl7:patientPerson/hl7:name/hl7:family )">
                <xsl:call-template name="ReportError">
                    <xsl:with-param name="ErrorText" select="$Response_Patient_not_same_as_request_ErrorMsg"/>
                    <xsl:with-param name="currentNode" select="$node/hl7:patientPerson/hl7:name"/>
                    <xsl:with-param name="expectedValue">
                        <xsl:call-template name="outputElementAttributes">
                            <xsl:with-param name="node" select="$requestNode/hl7:patientPerson/hl7:name"/>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="actualValue">
                        <xsl:call-template name="outputElementAttributes">
                            <xsl:with-param name="node" select="$node/hl7:patientPerson/hl7:name"/>
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:if>
        </xsl:if>

        <xsl:if test="$requestNode/hl7:patientPerson/hl7:birthTime and not($requestNode/hl7:patientPerson/hl7:birthTime/@nullFlavor) and $node/hl7:patientPerson/hl7:birthTime and not($node/hl7:patientPerson/hl7:birthTime/@nullFlavor) ">
            <xsl:if test="not($requestNode/hl7:patientPerson/hl7:birthTime/@value = $node/hl7:patientPerson/hl7:birthTime/@value)">
                <xsl:call-template name="ReportError">
                    <xsl:with-param name="ErrorText" select="$Response_Patient_not_same_as_request_ErrorMsg"/>
                    <xsl:with-param name="currentNode" select="$node/hl7:patientPerson/hl7:birthTime"/>
                    <xsl:with-param name="expectedValue">
                        <xsl:call-template name="outputElementAttributes">
                            <xsl:with-param name="node" select="$requestNode/hl7:patientPerson/hl7:birthTime"/>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="actualValue">
                        <xsl:call-template name="outputElementAttributes">
                            <xsl:with-param name="node" select="$node/hl7:patientPerson/hl7:birthTime"/>
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:if>
        </xsl:if>

        <xsl:if
            test="$requestNode/hl7:patientPerson/hl7:administrativeGenderCode and not($requestNode/hl7:patientPerson/hl7:administrativeGenderCode/@nullFlavor) and $node/hl7:patientPerson/hl7:administrativeGenderCode and not($node/hl7:patientPerson/hl7:administrativeGenderCode/@nullFlavor) ">
            <xsl:if test="not($requestNode/hl7:patientPerson/hl7:administrativeGenderCode = $node/hl7:patientPerson/hl7:administrativeGenderCode)">
                <xsl:call-template name="ReportError">
                    <xsl:with-param name="ErrorText" select="$Response_Patient_not_same_as_request_ErrorMsg"/>
                    <xsl:with-param name="currentNode" select="$node/hl7:patientPerson/hl7:administrativeGenderCode"/>
                    <xsl:with-param name="expectedValue">
                        <xsl:call-template name="outputElementAttributes">
                            <xsl:with-param name="node" select="$requestNode/hl7:patientPerson/hl7:administrativeGenderCode"/>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="actualValue">
                        <xsl:call-template name="outputElementAttributes">
                            <xsl:with-param name="node" select="$node/hl7:patientPerson/hl7:administrativeGenderCode"/>
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:if>
        </xsl:if>

    </xsl:template>

    <xsl:template name="outputElementAttributes">
        <xsl:param name="node"/>
        <xsl:choose>
            <xsl:when test="name($node) = ''">
                <xsl:value-of select="text()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>&lt;</xsl:text>
                <xsl:value-of select="name($node)"/>
                <xsl:text> </xsl:text>
                <xsl:for-each select="$node/@*">
                    <xsl:value-of select="name()"/>
                    <xsl:text>="</xsl:text>
                    <xsl:value-of select="."/>
                    <xsl:text>"  </xsl:text>
                </xsl:for-each>
                <xsl:text>&gt;</xsl:text>
                <xsl:for-each select="$node/child::node()">
                    <xsl:call-template name="outputElementAttributes">
                        <xsl:with-param name="node" select="."/>
                    </xsl:call-template>
                </xsl:for-each>
                <xsl:text>&lt;/</xsl:text>
                <xsl:value-of select="name($node)"/>
                <xsl:text>&gt;</xsl:text>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>


    <xsl:variable name="TestData_QueryResponse_MissMatch_MissingAttr_ErrorMsg">Data returned is missing an attribute that is present and required in the Test Data</xsl:variable>

    <xsl:template name="CompareAttributes">
        <xsl:param name="expectedNode"/>
        <xsl:param name="actualNode"/>

        <xsl:param name="attrRequired">true</xsl:param>
        <xsl:param name="attrEmptyAllowed">true</xsl:param>

        <xsl:for-each select="$expectedNode/@*">
            <xsl:variable name="expectedAttr" select="."/>
            <xsl:variable name="actualAttr" select="$actualNode/@*[name() = name($expectedAttr)]"/>
            <xsl:choose>
                <xsl:when test="not($actualAttr)">
                    <!-- Attribute missing-->
                    <xsl:if test="$attrRequired = 'true'">
                        <xsl:call-template name="ReportError">
                            <xsl:with-param name="ErrorText" select="$TestData_QueryResponse_MissMatch_MissingAttr_ErrorMsg"/>
                            <xsl:with-param name="currentNode" select="$actualNode"/>
                            <xsl:with-param name="elementName">
                                <xsl:value-of select="name($actualAttr)"/>
                            </xsl:with-param>
                            <xsl:with-param name="expectedValue"/>
                            <xsl:with-param name="actualValue"/>
                        </xsl:call-template>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="not($expectedAttr = '') and $actualAttr = '' ">
                    <!-- empty element -->
                </xsl:when>
                <xsl:when test="$expectedAttr = '' and not($actualAttr = '') ">
                    <!-- non-empty element -->
                </xsl:when>
                <xsl:when test="not($expectedAttr = $actualAttr)">
                    <!-- attr values differ -->
                </xsl:when>
            </xsl:choose>

        </xsl:for-each>

    </xsl:template>

</xsl:stylesheet>
