<?xml version="1.0" encoding="UTF-8"?>
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->  <xsl:stylesheet xmlns:hl7="urn:hl7-org:v3" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:import href="..\Common\Lib\TestData_Lib.xsl"/>

    <xsl:template match="*[@root]">
        <xsl:element name="{name()}">
            <xsl:for-each select="@*">
                <xsl:attribute name="{name()}">
                    <xsl:choose>
                        <xsl:when test="local-name()='root'">
                            <xsl:call-template name="getOIDRoot">
                                <xsl:with-param name="root" select="."/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
            </xsl:for-each>
        </xsl:element>        
    </xsl:template>

    
    <xsl:template match="*">
        <xsl:element name="{name()}">
            <xsl:for-each select="attribute::*">
                <xsl:variable name="attrName"><xsl:value-of select="name()"/></xsl:variable>
                <xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
            </xsl:for-each>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    
</xsl:stylesheet>
