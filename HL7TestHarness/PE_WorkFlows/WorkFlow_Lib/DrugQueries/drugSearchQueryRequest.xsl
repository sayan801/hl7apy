<?xml version="1.0" encoding="UTF-8"?>
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:include href="../Common/SimulatorMessages/Drug Query Message Templates.xsl"/>
    <xsl:param name="msg-effective-time"/>
    <xsl:param name="author-description"/>
    <xsl:param name="supervisor-description"/>
    <xsl:param name="location-description"/>
    <xsl:param name="ParticipationMode"/>
    <xsl:param name="author-time"/>
    <xsl:param name="characteristic-01-value"/>
    <xsl:param name="characteristic-01-code"/>
    <xsl:param name="characteristic-01-codeSystem"/>
    <xsl:param name="characteristic-02-value"/>
    <xsl:param name="characteristic-02-code"/>
    <xsl:param name="characteristic-02-codeSystem"/>
    <xsl:param name="characteristic-03-value"/>
    <xsl:param name="characteristic-03-code"/>
    <xsl:param name="characteristic-03-codeSystem"/>
    <xsl:param name="characteristic-04-value"/>
    <xsl:param name="characteristic-04-code"/>
    <xsl:param name="characteristic-04-codeSystem"/>
    <xsl:param name="characteristic-05-value"/>
    <xsl:param name="characteristic-05-code"/>
    <xsl:param name="characteristic-05-codeSystem"/>
    <xsl:param name="drug-code"/>
    <xsl:param name="drug-codeSystem"/>
    <xsl:param name="drug-form"/>
    <xsl:param name="drug-formSystem"/>
    <xsl:param name="manufacturer"/>
    <xsl:param name="drug-name"/>
    <xsl:param name="drug-route"/>
    <xsl:param name="drug-routeSystem"/>
    <xsl:param name="query-id"/>


    <xsl:template match="/">
        <xsl:call-template name="SoapWapper"/>
    </xsl:template>
    <xsl:template match="/" mode="message">

        <xsl:call-template name="drugSearchQueryRequest">
            <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>

            <xsl:with-param name="author-description" select="$author-description"/>
            <xsl:with-param name="supervisor-description" select="$supervisor-description"/>
            <xsl:with-param name="location-description" select="$location-description"/>
            <xsl:with-param name="ParticipationMode" select="$ParticipationMode"/>
            <xsl:with-param name="author-time" select="$author-time"/>
            <xsl:with-param name="characteristic-01-value" select="$characteristic-01-value"/>
            <xsl:with-param name="characteristic-01-code" select="$characteristic-01-code"/>
            <xsl:with-param name="characteristic-01-codeSystem" select="$characteristic-01-codeSystem"/>
            <xsl:with-param name="characteristic-02-value" select="$characteristic-02-value"/>
            <xsl:with-param name="characteristic-02-code" select="$characteristic-02-code"/>
            <xsl:with-param name="characteristic-02-codeSystem" select="$characteristic-02-codeSystem"/>
            <xsl:with-param name="characteristic-03-value" select="$characteristic-03-value"/>
            <xsl:with-param name="characteristic-03-code" select="$characteristic-03-code"/>
            <xsl:with-param name="characteristic-03-codeSystem" select="$characteristic-03-codeSystem"/>
            <xsl:with-param name="characteristic-04-value" select="$characteristic-04-value"/>
            <xsl:with-param name="characteristic-04-code" select="$characteristic-04-code"/>
            <xsl:with-param name="characteristic-04-codeSystem" select="$characteristic-04-codeSystem"/>
            <xsl:with-param name="characteristic-05-value" select="$characteristic-05-value"/>
            <xsl:with-param name="characteristic-05-code" select="$characteristic-05-code"/>
            <xsl:with-param name="characteristic-05-codeSystem" select="$characteristic-05-codeSystem"/>
            <xsl:with-param name="drug-code" select="$drug-code"/>
            <xsl:with-param name="drug-codeSystem" select="$drug-codeSystem"/>
            <xsl:with-param name="drug-form" select="$drug-form"/>
            <xsl:with-param name="drug-formSystem" select="$drug-formSystem"/>
            <xsl:with-param name="manufacturer" select="$manufacturer"/>
            <xsl:with-param name="drug-name" select="$drug-name"/>
            <xsl:with-param name="drug-route" select="$drug-route"/>
            <xsl:with-param name="drug-routeSystem" select="$drug-routeSystem"/>

            <xsl:with-param name="query-id" select="$query-id"/>
        </xsl:call-template>


    </xsl:template>

</xsl:stylesheet>
