<?xml version="1.0" encoding="UTF-8"?>
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->  <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:hl7="urn:hl7-org:v3" version="1.0">
    <xsl:import href="..\Lib\TestData_Lib.xsl"/>
    <xsl:param name="profile-description"/>
    <xsl:param name="profile-sequence"/>     <xsl:param name="patient-description"/>         <xsl:param name="msg-effective-time"/>
    <xsl:param name="messageType">server</xsl:param>
    <xsl:param name="recordName"/>


    <xsl:template match="text()|@*"/>

    <xsl:template match="/">
        
        <xsl:choose>
            
            <xsl:when test="descendant-or-self::hl7:supplyEvent/hl7:id/@extension">
                <xsl:call-template name="updateID">
                    <xsl:with-param name="node" select="$TestDataXml"/>
                    <xsl:with-param name="NewItem_name" select="descendant-or-self::hl7:supplyEvent/hl7:id/@extension"/>
                    <xsl:with-param name="InferredItem_name" select="descendant-or-self::hl7:supplyEvent/hl7:inFulfillmentOf/hl7:actRequest/hl7:id/@extension"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="descendant-or-self::hl7:actRequest/hl7:id/@extension">
                <xsl:call-template name="updateID">
                    <xsl:with-param name="node" select="$TestDataXml"/>
                    <xsl:with-param name="NewItem_name" select="descendant-or-self::hl7:actRequest/hl7:id/@extension"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="hl7:FICR_IN610102">
                <!-- Invoice -->
                <xsl:call-template name="updateID">
                    <xsl:with-param name="node" select="$TestDataXml"/>
                    <xsl:with-param name="NewItem_name" select="descendant-or-self::hl7:paymentIntent/hl7:reasonOf/hl7:adjudicatedInvoiceElementGroup/hl7:id/@extension"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="updateID">
                    <xsl:with-param name="node" select="$TestDataXml"/>
                    <xsl:with-param name="NewItem_name" select="descendant-or-self::hl7:actEvent/hl7:id/@extension"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="updateID">
        <xsl:param name="node"/>
        <xsl:param name="NewItem_name"/>
        <xsl:param name="InferredItem_name"/>

        <xsl:for-each select="$node/*">
            <xsl:choose>
                <xsl:when test="contains(@description,'NEW_ITEM')">
                    <xsl:if test="$NewItem_name">
                        <xsl:comment>generated item</xsl:comment>
                        <xsl:element name="{name()}">
                            <xsl:for-each select="@*">
                                <xsl:attribute name="{name()}">
                                    <xsl:value-of select="."/>
                                </xsl:attribute>
                            </xsl:for-each>
                            <!-- over write the description attrubute with the new ID -->
                            <xsl:attribute name="description">
                                <xsl:choose>
                                    <xsl:when test="$recordName and not($recordName = '')">
                                        <xsl:value-of select="$recordName"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="substring-before(@description,'NEW_ITEM')"/>
                                        <xsl:value-of select="$NewItem_name"/>
                                         <xsl:value-of select="substring-after(@description,'NEW_ITEM')"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                            <xsl:if test="text()"><xsl:value-of select="text()"/></xsl:if>
                            <xsl:call-template name="updateID">
                                <xsl:with-param name="node" select="."/>
                                <xsl:with-param name="NewItem_name" select="$NewItem_name"/>
                                <xsl:with-param name="InferredItem_name" select="$InferredItem_name"/>
                            </xsl:call-template>
                        </xsl:element>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="contains(@description,'INFERRED_ITEM')">
                    <xsl:if test="$InferredItem_name">
                        <xsl:comment>generated item</xsl:comment>
                        <xsl:element name="{name()}">
                            <xsl:for-each select="@*">
                                <xsl:attribute name="{name()}">
                                    <xsl:value-of select="."/>
                                </xsl:attribute>
                            </xsl:for-each>
                            <!-- over write the description attrubute with the new ID -->
                            <xsl:attribute name="description">
                                <xsl:choose>
                                    <xsl:when test="$recordName and not($recordName = '')">
                                        <xsl:value-of select="$recordName"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="substring-before(@description,'INFERRED_ITEM')"/>
                                        <xsl:value-of select="$InferredItem_name"/>
                                         <xsl:value-of select="substring-after(@description,'INFERRED_ITEM')"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                            <xsl:if test="text()"><xsl:value-of select="text()"/></xsl:if>
                            <xsl:call-template name="updateID">
                                <xsl:with-param name="node" select="."/>
                                <xsl:with-param name="NewItem_name" select="$NewItem_name"/>
                                <xsl:with-param name="InferredItem_name" select="$InferredItem_name"/>
                            </xsl:call-template>
                        </xsl:element>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="local-name() = 'record-id' and contains(parent::node()/@description, 'NEW_ITEM') and $NewItem_name">
                    <xsl:element name="record-id">
                        <xsl:for-each select="@*">
                            <xsl:attribute name="{name()}">
                                <xsl:value-of select="."/>
                            </xsl:attribute>
                            <xsl:attribute name="server"><xsl:value-of select="$NewItem_name"/></xsl:attribute>
                        </xsl:for-each>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="local-name() = 'record-id' and contains(parent::node()/@description, 'INFERRED_ITEM') and $InferredItem_name">
                    <xsl:element name="record-id">
                        <xsl:for-each select="@*">
                            <xsl:attribute name="{name()}">
                                <xsl:value-of select="."/>
                            </xsl:attribute>
                            <xsl:attribute name="server"><xsl:value-of select="$InferredItem_name"/></xsl:attribute>
                        </xsl:for-each>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="{name()}">
                        <xsl:for-each select="@*">
                            <xsl:attribute name="{name()}">
                                <xsl:value-of select="."/>
                            </xsl:attribute>
                        </xsl:for-each>
                        <xsl:if test="text()"><xsl:value-of select="text()"/></xsl:if>
                        <xsl:call-template name="updateID">
                            <xsl:with-param name="node" select="."/>
                            <xsl:with-param name="NewItem_name" select="$NewItem_name"/>
                            <xsl:with-param name="InferredItem_name" select="$InferredItem_name"/>
                        </xsl:call-template>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>

    </xsl:template>

</xsl:stylesheet>
