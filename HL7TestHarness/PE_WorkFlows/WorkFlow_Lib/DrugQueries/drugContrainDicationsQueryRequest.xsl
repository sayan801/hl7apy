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
        <xsl:param name="drug-01-code"/>
        <xsl:param name="drug-01-codeSystem"/>
        <xsl:param name="drug-02-code"/>
        <xsl:param name="drug-02-codeSystem"/>
        <xsl:param name="drug-03-code"/>
        <xsl:param name="drug-03-codeSystem"/>
        <xsl:param name="drug-04-code"/>
        <xsl:param name="drug-04-codeSystem"/>
        <xsl:param name="drug-05-code"/>
        <xsl:param name="drug-05-codeSystem"/>
        <xsl:param name="drug-06-code"/>
        <xsl:param name="drug-06-codeSystem"/>
        <xsl:param name="drug-07-code"/>
        <xsl:param name="drug-07-codeSystem"/>
        <xsl:param name="drug-08-code"/>
        <xsl:param name="drug-08-codeSystem"/>
        <xsl:param name="drug-09-code"/>
        <xsl:param name="drug-09-codeSystem"/>
        <xsl:param name="drug-10-code"/>
        <xsl:param name="drug-10-codeSystem"/>
        <xsl:param name="drug-11-code"/>
        <xsl:param name="drug-11-codeSystem"/>
        <xsl:param name="drug-12-code"/>
        <xsl:param name="drug-12-codeSystem"/>
        <xsl:param name="drug-13-code"/>
        <xsl:param name="drug-13-codeSystem"/>
        <xsl:param name="drug-14-code"/>
        <xsl:param name="drug-14-codeSystem"/>
        <xsl:param name="drug-15-code"/>
        <xsl:param name="drug-15-codeSystem"/>
        <xsl:param name="drug-16-code"/>
        <xsl:param name="drug-16-codeSystem"/>
        <xsl:param name="drug-17-code"/>
        <xsl:param name="drug-17-codeSystem"/>
        <xsl:param name="drug-18-code"/>
        <xsl:param name="drug-18-codeSystem"/>
        <xsl:param name="drug-19-code"/>
        <xsl:param name="drug-19-codeSystem"/>
        <xsl:param name="drug-20-code"/>
        <xsl:param name="drug-20-codeSystem"/>


    <xsl:template match="/">
        <xsl:call-template name="SoapWapper"/>
    </xsl:template>
    <xsl:template match="/" mode="message">

        <xsl:call-template name="drugContrainDicationsQueryRequest">
            <xsl:with-param name="msg-effective-time" select="$msg-effective-time"/>

            <xsl:with-param name="author-description" select="$author-description"/>
            <xsl:with-param name="supervisor-description" select="$supervisor-description"/>
            <xsl:with-param name="location-description" select="$location-description"/>
            <xsl:with-param name="ParticipationMode" select="$ParticipationMode"/>
            <xsl:with-param name="author-time" select="$author-time"/>
            <xsl:with-param name="drug-01-code" select="$drug-01-code"/>
            <xsl:with-param name="drug-02-code" select="$drug-02-code"/>
            <xsl:with-param name="drug-03-code" select="$drug-03-code"/>
            <xsl:with-param name="drug-04-code" select="$drug-04-code"/>
            <xsl:with-param name="drug-05-code" select="$drug-05-code"/>
            <xsl:with-param name="drug-06-code" select="$drug-06-code"/>
            <xsl:with-param name="drug-07-code" select="$drug-07-code"/>
            <xsl:with-param name="drug-08-code" select="$drug-08-code"/>
            <xsl:with-param name="drug-09-code" select="$drug-09-code"/>
            <xsl:with-param name="drug-10-code" select="$drug-10-code"/>
            <xsl:with-param name="drug-11-code" select="$drug-11-code"/>
            <xsl:with-param name="drug-12-code" select="$drug-12-code"/>
            <xsl:with-param name="drug-13-code" select="$drug-13-code"/>
            <xsl:with-param name="drug-14-code" select="$drug-14-code"/>
            <xsl:with-param name="drug-15-code" select="$drug-15-code"/>
            <xsl:with-param name="drug-16-code" select="$drug-16-code"/>
            <xsl:with-param name="drug-17-code" select="$drug-17-code"/>
            <xsl:with-param name="drug-18-code" select="$drug-18-code"/>
            <xsl:with-param name="drug-19-code" select="$drug-19-code"/>
            <xsl:with-param name="drug-20-code" select="$drug-20-code"/>
            <xsl:with-param name="drug-01-codeSystem" select="$drug-01-codeSystem"/>
            <xsl:with-param name="drug-02-codeSystem" select="$drug-02-codeSystem"/>
            <xsl:with-param name="drug-03-codeSystem" select="$drug-03-codeSystem"/>
            <xsl:with-param name="drug-04-codeSystem" select="$drug-04-codeSystem"/>
            <xsl:with-param name="drug-05-codeSystem" select="$drug-05-codeSystem"/>
            <xsl:with-param name="drug-06-codeSystem" select="$drug-06-codeSystem"/>
            <xsl:with-param name="drug-07-codeSystem" select="$drug-07-codeSystem"/>
            <xsl:with-param name="drug-08-codeSystem" select="$drug-08-codeSystem"/>
            <xsl:with-param name="drug-09-codeSystem" select="$drug-09-codeSystem"/>
            <xsl:with-param name="drug-10-codeSystem" select="$drug-10-codeSystem"/>
            <xsl:with-param name="drug-11-codeSystem" select="$drug-11-codeSystem"/>
            <xsl:with-param name="drug-12-codeSystem" select="$drug-12-codeSystem"/>
            <xsl:with-param name="drug-13-codeSystem" select="$drug-13-codeSystem"/>
            <xsl:with-param name="drug-14-codeSystem" select="$drug-14-codeSystem"/>
            <xsl:with-param name="drug-15-codeSystem" select="$drug-15-codeSystem"/>
            <xsl:with-param name="drug-16-codeSystem" select="$drug-16-codeSystem"/>
            <xsl:with-param name="drug-17-codeSystem" select="$drug-17-codeSystem"/>
            <xsl:with-param name="drug-18-codeSystem" select="$drug-18-codeSystem"/>
            <xsl:with-param name="drug-19-codeSystem" select="$drug-19-codeSystem"/>
            <xsl:with-param name="drug-20-codeSystem" select="$drug-20-codeSystem"/>
        </xsl:call-template>


    </xsl:template>

</xsl:stylesheet>
