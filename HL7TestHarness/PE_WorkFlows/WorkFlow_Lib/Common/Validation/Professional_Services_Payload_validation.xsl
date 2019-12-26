<?xml version="1.0" encoding="UTF-8"?>
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->  <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:hl7="urn:hl7-org:v3" version="2.0">
    <xsl:import href="../Lib/Validation_Lib.xsl"/>
    
    <xsl:template match="text()|@*"/> <!-- override default output of text/attributes -->
    
    <!-- validate optional id element -->
    <xsl:template match="hl7:procedureEvent/hl7:id">
        <xsl:call-template name="Identifier_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="expected_OID">DIS_PROF_SERVICE_ID</xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="hl7:procedureEvent">
        <!-- validate required code attribute -->
        <xsl:call-template name="Code_Element_Test"> 
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="node" select="hl7:code"/>
            <xsl:with-param name="validCodeSet" select="$CodeSet/codeProfService"/>
        </xsl:call-template>
        
        <!-- validate required statusCode element, = "COMPLETED" or "ACTIVE" -->
        <xsl:call-template name="Code_Element_Test"> 
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="node" select="hl7:statusCode"/>
            <xsl:with-param name="validCodeSet" select="$CodeSet/statusCodeActiveCompleted"/>
        </xsl:call-template>
    </xsl:template>
    
</xsl:stylesheet>
