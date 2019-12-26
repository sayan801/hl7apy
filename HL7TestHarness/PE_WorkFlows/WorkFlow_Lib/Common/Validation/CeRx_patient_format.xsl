<?xml version="1.0" encoding="UTF-8"?>
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->  <xsl:stylesheet xmlns:hl7="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:import href="..\Lib\Report_Lib.xsl"/>
    <xsl:output omit-xml-declaration="yes"/>
    
    
    <xsl:template match="hl7:patient">
        <xsl:call-template name="patient"/>
            <xsl:apply-templates/>     </xsl:template>
    
    <xsl:template name="patient">
        <xsl:choose>
            <xsl:when test="hl7:id"/>
            <xsl:otherwise>
                <xsl:call-template name="ReportError">
                    <xsl:with-param name="ErrorText">Missing patient id element</xsl:with-param>
                    <xsl:with-param name="elementName">id</xsl:with-param>
                    <xsl:with-param name="expectedValue"/>
                    <xsl:with-param name="actualValue"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
        
        <xsl:choose>
            <xsl:when test="hl7:telecom"/>
            <xsl:otherwise>
                <xsl:call-template name="ReportError">
                    <xsl:with-param name="ErrorText">Missing patient telecom element</xsl:with-param>
                    <xsl:with-param name="elementName">telecom</xsl:with-param>
                    <xsl:with-param name="expectedValue"/>
                    <xsl:with-param name="actualValue"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
        
        
        <xsl:for-each select="hl7:id">
            <xsl:call-template name="type-II">
                <xsl:with-param name="path">patient/id</xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>
        
        <xsl:for-each select="hl7:telecom">
            <xsl:call-template name="type-telecom">
                <xsl:with-param name="path">patient/telecom</xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>
        
            <xsl:apply-templates/>     </xsl:template>
    

    <xsl:template name="type-telecom">
        <xsl:param name="path"/>
        <xsl:if test="@use!='H'">
        <xsl:call-template name="ReportError">
            <xsl:with-param name="ErrorText">Incorrect Fixed Attribute Value</xsl:with-param>
            <xsl:with-param name="elementName"><xsl:value-of select="$path"/>/@use</xsl:with-param>
            <xsl:with-param name="expectedValue">H</xsl:with-param>
            <xsl:with-param name="actualValue"><xsl:value-of select="@use"/></xsl:with-param>
        </xsl:call-template>
        </xsl:if>
            <xsl:apply-templates/>     </xsl:template>
    
    <xsl:template name="type-II">
        <xsl:param name="path"/>
        <xsl:choose>
            <xsl:when test="@root"/>
            <xsl:otherwise>
                <xsl:call-template name="ReportError">
                    <xsl:with-param name="ErrorText">Missing root attribute</xsl:with-param>
                    <xsl:with-param name="elementName"><xsl:value-of select="$path"/>/@root</xsl:with-param>
                    <xsl:with-param name="expectedValue"/>
                    <xsl:with-param name="actualValue"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="@extension"/>
            <xsl:otherwise>
                <xsl:call-template name="ReportError">
                    <xsl:with-param name="ErrorText">Missing extension attribute</xsl:with-param>
                    <xsl:with-param name="elementName"><xsl:value-of select="$path"/>/@extension</xsl:with-param>
                    <xsl:with-param name="expectedValue"/>
                    <xsl:with-param name="actualValue"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
            <xsl:apply-templates/>     </xsl:template>
    
</xsl:stylesheet>
