<?xml version="1.0" encoding="UTF-8"?>
<!--
 Module Header

  $Header:   L:/pvcsrep65/HL7TestHarness/archives/Source Code/xsl/TreeView.xsl-arc   1.8   18 Jan 2007 14:20:30   mwicks  $

  Copyright © 1996-2006 by DeltaWare Systems Inc. 

  Company:          DeltaWare Systems Inc.
                    90 University Avenue, Suite 300
                    Charlottetown
                    Prince Edward Island
                    C1A 4K9
                    Phone   (902) 368-8122
                    FAX     (902) 628-4660
                    E-Mail  dsi@deltaware.com

  Development:      DeltaWare Systems Inc.
                    90 University Avenue, Suite 300
                    Charlottetown
                    Prince Edward Island
                    C1A 4K9
                    Phone   (902) 368-8122
                    FAX     (902) 628-4660
                    E-Mail  dsi@deltaware.com

The GNU General Public License (GPL)

This program is free software; you can redistribute it and/or modify it 
under the terms of the GNU General Public License as published by the 
Free Software Foundation; either version 2 of the License, or (at your
option) any later version.
This program is distributed in the hope that it will be useful, but 
WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
Public License for more details.
You should have received a copy of the GNU General Public License along
with this program; if not, write to the Free Software Foundation, Inc., 
59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  Project:          HL7 Test Harness
  Programmer:       Matthew Wicks
  Created:          March 17, 2006

  History:
  Action      Who     Date            Comments
  <<Action>>  xxx     yyyy-mm-dd      <<Comments here>>


  Application notes:
  <<Place notes on usages, known problems, etc>>

-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">


    <xsl:template match="*">
        <xsl:choose>
            <xsl:when test="name()='workflows'">
                <workflows>
                    <xsl:apply-templates/>
                </workflows>
            </xsl:when>
            <xsl:when test="name()='workflow'">
                <xsl:element name="workflow">
                    <xsl:call-template name="createElement"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="name()='message'">
                <xsl:element name="message">
                    <xsl:call-template name="createElement"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="name()='request'">
                <xsl:element name="request">
                    <xsl:call-template name="createElement"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="name()='response'">
                <xsl:element name="response">
                    <xsl:call-template name="createElement"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="name()='messageProxy'">
                    <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="name()='validation'">
                <xsl:element name="validation">
                    <xsl:call-template name="createElement"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="name()='rule' and name(parent::node()) = 'validation'">
                <xsl:element name="rule">
                    <xsl:call-template name="createElement"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="name()='error' and name(parent::node()/parent::node()) = 'validation'">
                <xsl:element name="error">
                    <xsl:attribute name="status">FAIL</xsl:attribute>
                    <xsl:for-each select="error">
                        <xsl:element name="error">
                            <xsl:attribute name="description"><xsl:value-of select="@description"/> [<xsl:value-of select="@element"/>]</xsl:attribute>
                            <xsl:attribute name="status">FAIL</xsl:attribute>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:when>
            <xsl:when test="name()='exception' and name(parent::node()/parent::node()) = 'validation'">
                <xsl:element name="exception">
                    <xsl:attribute name="status">FAIL</xsl:attribute>
                        <xsl:element name="error">
                            <xsl:attribute name="description"><xsl:value-of select="."/></xsl:attribute>
                            <xsl:attribute name="status">FAIL</xsl:attribute>
                        </xsl:element>
                </xsl:element>
            </xsl:when>
            
        </xsl:choose>
    </xsl:template>

    <xsl:template match="request/Simulator">
        <xsl:if test="descendant::exception">
            <xsl:element name="SimulatorError">
                <xsl:attribute name="status">FAIL</xsl:attribute>
                <xsl:attribute name="description">Client Simulator Error</xsl:attribute>
                <xsl:for-each select="descendant::exception">
                    <xsl:element name="error">
                        <xsl:attribute name="status">FAIL</xsl:attribute>
                        <xsl:attribute name="description"><xsl:value-of select="."/></xsl:attribute>
                    </xsl:element>
                </xsl:for-each>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template match="response/Simulator">
        <xsl:if test="descendant::exception">
            <xsl:element name="SimulatorError">
                <xsl:attribute name="status">FAIL</xsl:attribute>
                <xsl:attribute name="description">Server Simulator Error</xsl:attribute>
                <xsl:for-each select="descendant::exception">
                    <xsl:element name="error">
                        <xsl:attribute name="status">FAIL</xsl:attribute>
                        <xsl:attribute name="description"><xsl:value-of select="."/></xsl:attribute>
                    </xsl:element>
                </xsl:for-each>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="messageProxy/construction">
        <xsl:if test="descendant::exception">
            <xsl:element name="exception">
                <xsl:attribute name="status">FAIL</xsl:attribute>
                <xsl:attribute name="description">Message Construction Error</xsl:attribute>
                <xsl:for-each select="descendant::exception">
                    <xsl:element name="error">
                        <xsl:attribute name="status">FAIL</xsl:attribute>
                        <xsl:attribute name="description"><xsl:value-of select="."/></xsl:attribute>
                    </xsl:element>
                </xsl:for-each>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    

    <xsl:template name="createElement">
        <xsl:if test="@id">
            <xsl:attribute name="id">
                <xsl:value-of select="@id"/>
            </xsl:attribute>
        </xsl:if>
        
        <xsl:if test="@description">
            <xsl:attribute name="description">
                <xsl:value-of select="@description"/>
            </xsl:attribute>
        </xsl:if>
        
        <xsl:attribute name="status">
            <xsl:choose>
                <xsl:when test="@status='PASS'">PASS</xsl:when>
                <xsl:when test="@status='N/A'"></xsl:when>
                <xsl:when test="@status='FAIL'">FAIL</xsl:when>
                <xsl:when test="@status='EXCEPTION'">FAIL</xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="count(descendant::rule) = 0">INCOMPLETE</xsl:when>
                        <xsl:when test="count( descendant-or-self::validation/rule[@status='FAIL']) >= 1">FAIL</xsl:when>
                        <xsl:when test="count( descendant-or-self::validation/rule[@status='EXCEPTION']) >= 1">FAIL</xsl:when>
                        <xsl:when test="count(descendant-or-self::validation[not(@status = 'N/A')]/rule)=count(descendant-or-self::validation[not(@status = 'N/A')]/rule[@status='PASS'])">PASS</xsl:when>
                        <xsl:otherwise>INCOMPLETE</xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

    </xsl:template>



</xsl:stylesheet>
