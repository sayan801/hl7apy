<?xml version="1.0" encoding="UTF-8"?>
<!--
    Module Header
    
    $Header:   L:/pvcsrep65/HL7TestHarness/archives/Source Code/xsl/workflowRefLoad.xsl-arc   1.12   13 Apr 2007 10:42:02   mwicks  $
    
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
    Public 
    License for more details.
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
    <xsl:param name="localDirectory">../../PE_TestCases/</xsl:param>

    <xsl:template match="workflows">
        <xsl:call-template name="processElement"/>
    </xsl:template>

    <xsl:template match="SUBMISSIONS">
        <workflows testDataFile="TestData.xml">
            <xsl:apply-templates mode="CPHA"/>
        </workflows>
    </xsl:template>

    <xsl:template match="SUBMISSION" mode="CPHA">
        <!-- Identify the claim by the PHN and the Trace Number -->
        <xsl:variable name="CLAIM_ID">
            <xsl:value-of select="CLAIM/C3903"/>
            <xsl:text>_</xsl:text>
            <xsl:value-of select="CLAIM/B2303"/>
        </xsl:variable>
        <xsl:element name="workflow">
            <xsl:attribute name="id">
                <xsl:text>w_CPHA_</xsl:text>
                <xsl:value-of select="$CLAIM_ID"/>
            </xsl:attribute>
            <xsl:attribute name="description">
                <xsl:text>NeCST Claim Test Based on CPHA Claim (PHN:</xsl:text>
                <xsl:value-of select="CLAIM/C3903"/>
                <xsl:text>; TraceNumber:</xsl:text>
                <xsl:value-of select="CLAIM/B2303"/>
                <xsl:text>)</xsl:text>
            </xsl:attribute>
            <xsl:call-template name="loadCphaReference">
                <xsl:with-param name="WorkFlow_filename">SubWorkFlow_Convert_CPHA.xml</xsl:with-param>
                <xsl:with-param name="paramList" select="."/>
                <xsl:with-param name="replace">
                    <xsl:choose>
                        <xsl:when test="CLAIM/A0303 = '01' ">
                            <xsl:text>[REPLACE][FROM:LastClaimID][TO:CLAIM_</xsl:text>
                            <xsl:value-of select="$CLAIM_ID"/>
                            <xsl:text>]</xsl:text>
                        </xsl:when>
                        <xsl:when test="CLAIM/A0303 = '11' ">
                            <xsl:text>[REPLACE][FROM:ClientClaimID][TO:CLAIM_</xsl:text>
                            <xsl:value-of select="$CLAIM_ID"/>
                            <xsl:text>]</xsl:text>
                        </xsl:when>
                    </xsl:choose>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:element>
    </xsl:template>

    <xsl:template name="loadCphaReference">
        <xsl:param name="WorkFlow_filename"/>
        <xsl:param name="paramList"/>
        <xsl:param name="replace"/>


        <xsl:variable name="filename">
            <xsl:value-of select="$localDirectory"/>
            <xsl:value-of select="$WorkFlow_filename"/>
        </xsl:variable>

        <xsl:if test="$filename">
            <xsl:variable name="ref" select="document($filename)"/>
            <!--
            <xsl:variable name="replace" select="replace"/>
            <xsl:variable name="paramList" select="paramList"/>
            <xsl:variable name="validationList" select="validationList"/>
            <xsl:variable name="IgnoreRuleResultList" select="IgnoreRuleResultList"/>
-->
            <xsl:for-each select="$ref/workflows/workflow">
                <!--                <xsl:comment>
                    Referance:<xsl:value-of select="$filename"/>
                    <xsl:for-each select="$replace"> (From:<xsl:value-of select="@from"/> to:<xsl:value-of select="@to"/>) </xsl:for-each>
                    <xsl:for-each select="$paramList"> (List:<xsl:value-of select="@name"/>) 
                        <xsl:for-each select="param"> (Name:<xsl:value-of select="@name"/> value:<xsl:value-of select="@value"/>)</xsl:for-each>
                    </xsl:for-each>
                    <xsl:for-each select="$validationList/validation"> (Name:<xsl:value-of select="@descriptions"/>) </xsl:for-each>
                    <xsl:for-each select="$IgnoreRuleResultList/rule"> (rule:<xsl:value-of select="@name"/>) </xsl:for-each>
                </xsl:comment>
-->
                <xsl:apply-templates mode="workflow">
                    <xsl:with-param name="replace" select="$replace"/>
                    <xsl:with-param name="paramList" select="$paramList"/>
                    <!--<xsl:with-param name="validationList" select="$validationList"/>
                    <xsl:with-param name="IgnoreRuleResultList" select="$IgnoreRuleResultList"/>-->
                </xsl:apply-templates>
                <!-- 
                <xsl:call-template name="processElement">
                    <xsl:with-param name="replace" select="$replace"/>
                </xsl:call-template>
-->
            </xsl:for-each>

        </xsl:if>
    </xsl:template>




    <xsl:template match="*" mode="workflow">
        <xsl:param name="replace"/>
        <xsl:param name="attributes"/>
        <xsl:param name="paramList"/>
        <xsl:param name="validationList"/>
        <xsl:param name="IgnoreRuleResultList"/>

        <xsl:call-template name="processElement">
            <xsl:with-param name="replace" select="$replace"/>
             <xsl:with-param name="attributes" select="$attributes"/>
            <xsl:with-param name="paramList" select="$paramList"/>
            <xsl:with-param name="validationList" select="$validationList"/>
            <xsl:with-param name="IgnoreRuleResultList" select="$IgnoreRuleResultList"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="processElement">
        <xsl:param name="replace"/>
        <xsl:param name="attributes"/>
        <xsl:param name="paramList"/>
        <xsl:param name="validationList"/>
        <xsl:param name="IgnoreRuleResultList"/>
        <xsl:choose>
            <xsl:when test="name() = 'reference'">
                <xsl:choose>
                    <xsl:when test="name(parent::node())='workflows'">
                        <xsl:call-template name="loadWorkflowReference"/>
                    </xsl:when>
                    <xsl:when test="name(parent::node())='workflow'">
                        <xsl:call-template name="loadMessageReference"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="self::comment()"/>
            <xsl:when test="self::text()"/>
            <xsl:otherwise>
                <xsl:call-template name="createElement">
                    <xsl:with-param name="name">
                        <xsl:value-of select="name()"/>
                    </xsl:with-param>
                    <xsl:with-param name="replace" select="$replace"/>
                    <xsl:with-param name="attributes" select="$attributes"/>
                    <xsl:with-param name="paramList" select="$paramList"/>
                    <xsl:with-param name="validationList" select="$validationList"/>
                    <xsl:with-param name="IgnoreRuleResultList" select="$IgnoreRuleResultList"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="createElement">
        <xsl:param name="replace"/>
        <xsl:param name="attributes"/>
        <xsl:param name="paramList"/>
        <xsl:param name="validationList"/>
        <xsl:param name="IgnoreRuleResultList"/>
        <xsl:param name="name"/>
        <xsl:if test="$name">
            <xsl:choose>
                <xsl:when test="$name = 'paramList' and $paramList and @name = $paramList/@name and $paramList/@cpha-filename">
                    <xsl:variable name="cpha" select="document($paramList/@cpha-filename)/descendant-or-self::CLAIM"/>
                    <paramList>
                        <param name="CPHAFileName">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$paramList/@cpha-filename"/>
                            </xsl:attribute>
                        </param>
                        <param name="BIN" value="610528">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$cpha/A0101"/>
                            </xsl:attribute>
                        </param>
                        <param name="Version" value="03">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$cpha/A0203"/>
                            </xsl:attribute>
                        </param>
                        <param name="TransactionCode" value="01">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$cpha/A0303"/>
                            </xsl:attribute>
                        </param>
                        <param name="ProviderSoftwareID" value="PR">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$cpha/A0403"/>
                            </xsl:attribute>
                        </param>
                        <param name="ProviderSoftwareVersion" value="01">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$cpha/A0503"/>
                            </xsl:attribute>
                        </param>
                        <param name="ActiveDeviceID" value="">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$cpha/A0703"/>
                            </xsl:attribute>
                        </param>
                        <param name="PharmacyIDCode" value="0000441287">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$cpha/B2103"/>
                            </xsl:attribute>
                        </param>
                        <param name="ProviderTransactionDate" value="030517">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$cpha/B2203"/>
                            </xsl:attribute>
                        </param>
                        <param name="TraceNumber" value="000001">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$cpha/B2303"/>
                            </xsl:attribute>
                        </param>
                        <param name="CarrierID" value="88">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$cpha/C3003"/>
                            </xsl:attribute>
                        </param>
                        <param name="Group" value="CC">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$cpha/C3103"/>
                            </xsl:attribute>
                        </param>
                        <param name="ClientID" value="01299155">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$cpha/C3203"/>
                            </xsl:attribute>
                        </param>
                        <param name="PatientCode" value="001">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$cpha/C3301"/>
                            </xsl:attribute>
                        </param>
                        <param name="PatientDOB" value="19680323">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$cpha/C3401"/>
                            </xsl:attribute>
                        </param>
                        <param name="CardholderIdentity" value="">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$cpha/C3503"/>
                            </xsl:attribute>
                        </param>
                        <param name="Relationship" value="0">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$cpha/C3603"/>
                            </xsl:attribute>
                        </param>
                        <param name="PatientFirstName" value="MURPHY">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$cpha/C3701"/>
                            </xsl:attribute>
                        </param>
                        <param name="PatientLastName" value="CROMWELL">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$cpha/C3801"/>
                            </xsl:attribute>
                        </param>
                        <param name="ProvincialHealthIdentifier" value="01299155">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$cpha/C3903"/>
                            </xsl:attribute>
                        </param>
                        <param name="PatientGender" value="F">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$cpha/C4003"/>
                            </xsl:attribute>
                        </param>
                        <param name="MedicalReasonReference" value="">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$cpha/D5003"/>
                            </xsl:attribute>
                        </param>
                        <param name="ReasonforUse" value="">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$cpha/D5103"/>
                            </xsl:attribute>
                        </param>
                        <param name="RefillCode" value="N">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$cpha/D5203"/>
                            </xsl:attribute>
                        </param>
                        <param name="OriginalPrescription" value="000000001">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$cpha/D5303"/>
                            </xsl:attribute>
                        </param>
                        <param name="RefillAuthorizations" value="00">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$cpha/D5403"/>
                            </xsl:attribute>
                        </param>
                        <param name="CurrentRx" value="000000001">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$cpha/D5503"/>
                            </xsl:attribute>
                        </param>
                        <param name="DIN" value="02027887">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$cpha/D5603"/>
                            </xsl:attribute>
                        </param>
                        <param name="SSC" value="">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$cpha/D5703"/>
                            </xsl:attribute>
                        </param>
                        <param name="Quantity" value="000300">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$cpha/D5803"/>
                            </xsl:attribute>
                        </param>
                        <param name="DaysSupply" value="030">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$cpha/D5902"/>
                            </xsl:attribute>
                        </param>
                        <param name="PrescriberIDReference" value="21">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$cpha/D6003"/>
                            </xsl:attribute>
                        </param>
                        <param name="PrescriberID" value="1">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$cpha/D6103"/>
                            </xsl:attribute>
                        </param>
                        <param name="ProductSelection" value="">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$cpha/D6203"/>
                            </xsl:attribute>
                        </param>
                        <param name="UnlistedCompound" value="">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$cpha/D6303"/>
                            </xsl:attribute>
                        </param>
                        <param name="SpecialAuthorization" value="">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$cpha/D6403"/>
                            </xsl:attribute>
                        </param>
                        <param name="ExceptionCodes" value="UA">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$cpha/D6503"/>
                            </xsl:attribute>
                        </param>
                        <param name="DrugCost" value="004604">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$cpha/D6603"/>
                            </xsl:attribute>
                        </param>
                        <param name="Upcharge" value="01533">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$cpha/D6703"/>
                            </xsl:attribute>
                        </param>
                        <param name="ProfessionalFee" value="00700">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$cpha/D6803"/>
                            </xsl:attribute>
                        </param>
                        <param name="CompoundingCharge" value="00000">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$cpha/D7003"/>
                            </xsl:attribute>
                        </param>
                        <param name="CompoundingTime" value="00">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$cpha/D7103"/>
                            </xsl:attribute>
                        </param>
                        <param name="SpecialServicesFee" value="00000">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$cpha/D7203"/>
                            </xsl:attribute>
                        </param>
                        <param name="PreviouslyPaid" value="000000">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$cpha/D7503"/>
                            </xsl:attribute>
                        </param>
                        <param name="PharmacistID" value="9555">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$cpha/D7603"/>
                            </xsl:attribute>
                        </param>
                        <param name="AdjudicationDate" value="000000">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$cpha/D7703"/>
                            </xsl:attribute>
                        </param>
                    </paramList>
                </xsl:when>
                <xsl:when test="$name = 'paramList' and $paramList and @name = $paramList/@name and $paramList/CLAIM">
                    <paramList>
                        <param name="BIN" value="610528">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$paramList/CLAIM/A0101"/>
                            </xsl:attribute>
                        </param>
                        <param name="Version" value="03">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$paramList/CLAIM/A0203"/>
                            </xsl:attribute>
                        </param>
                        <param name="TransactionCode" value="01">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$paramList/CLAIM/A0303"/>
                            </xsl:attribute>
                        </param>
                        <param name="ProviderSoftwareID" value="PR">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$paramList/CLAIM/A0403"/>
                            </xsl:attribute>
                        </param>
                        <param name="ProviderSoftwareVersion" value="01">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$paramList/CLAIM/A0503"/>
                            </xsl:attribute>
                        </param>
                        <param name="ActiveDeviceID" value="">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$paramList/CLAIM/A0703"/>
                            </xsl:attribute>
                        </param>
                        <param name="PharmacyIDCode" value="0000441287">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$paramList/CLAIM/B2103"/>
                            </xsl:attribute>
                        </param>
                        <param name="ProviderTransactionDate" value="030517">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$paramList/CLAIM/B2203"/>
                            </xsl:attribute>
                        </param>
                        <param name="TraceNumber" value="000001">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$paramList/CLAIM/B2303"/>
                            </xsl:attribute>
                        </param>
                        <param name="CarrierID" value="88">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$paramList/CLAIM/C3003"/>
                            </xsl:attribute>
                        </param>
                        <param name="Group" value="CC">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$paramList/CLAIM/C3103"/>
                            </xsl:attribute>
                        </param>
                        <param name="ClientID" value="01299155">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$paramList/CLAIM/C3203"/>
                            </xsl:attribute>
                        </param>
                        <param name="PatientCode" value="001">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$paramList/CLAIM/C3301"/>
                            </xsl:attribute>
                        </param>
                        <param name="PatientDOB" value="19680323">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$paramList/CLAIM/C3401"/>
                            </xsl:attribute>
                        </param>
                        <param name="CardholderIdentity" value="">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$paramList/CLAIM/C3503"/>
                            </xsl:attribute>
                        </param>
                        <param name="Relationship" value="0">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$paramList/CLAIM/C3603"/>
                            </xsl:attribute>
                        </param>
                        <param name="PatientFirstName" value="MURPHY">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$paramList/CLAIM/C3701"/>
                            </xsl:attribute>
                        </param>
                        <param name="PatientLastName" value="CROMWELL">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$paramList/CLAIM/C3801"/>
                            </xsl:attribute>
                        </param>
                        <param name="ProvincialHealthIdentifier" value="01299155">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$paramList/CLAIM/C3903"/>
                            </xsl:attribute>
                        </param>
                        <param name="PatientGender" value="F">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$paramList/CLAIM/C4003"/>
                            </xsl:attribute>
                        </param>
                        <param name="MedicalReasonReference" value="">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$paramList/CLAIM/D5003"/>
                            </xsl:attribute>
                        </param>
                        <param name="ReasonforUse" value="">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$paramList/CLAIM/D5103"/>
                            </xsl:attribute>
                        </param>
                        <param name="RefillCode" value="N">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$paramList/CLAIM/D5203"/>
                            </xsl:attribute>
                        </param>
                        <param name="OriginalPrescription" value="000000001">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$paramList/CLAIM/D5303"/>
                            </xsl:attribute>
                        </param>
                        <param name="RefillAuthorizations" value="00">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$paramList/CLAIM/D5403"/>
                            </xsl:attribute>
                        </param>
                        <param name="CurrentRx" value="000000001">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$paramList/CLAIM/D5503"/>
                            </xsl:attribute>
                        </param>
                        <param name="DIN" value="02027887">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$paramList/CLAIM/D5603"/>
                            </xsl:attribute>
                        </param>
                        <param name="SSC" value="">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$paramList/CLAIM/D5703"/>
                            </xsl:attribute>
                        </param>
                        <param name="Quantity" value="000300">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$paramList/CLAIM/D5803"/>
                            </xsl:attribute>
                        </param>
                        <param name="DaysSupply" value="030">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$paramList/CLAIM/D5902"/>
                            </xsl:attribute>
                        </param>
                        <param name="PrescriberIDReference" value="21">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$paramList/CLAIM/D6003"/>
                            </xsl:attribute>
                        </param>
                        <param name="PrescriberID" value="1">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$paramList/CLAIM/D6103"/>
                            </xsl:attribute>
                        </param>
                        <param name="ProductSelection" value="">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$paramList/CLAIM/D6203"/>
                            </xsl:attribute>
                        </param>
                        <param name="UnlistedCompound" value="">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$paramList/CLAIM/D6303"/>
                            </xsl:attribute>
                        </param>
                        <param name="SpecialAuthorization" value="">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$paramList/CLAIM/D6403"/>
                            </xsl:attribute>
                        </param>
                        <param name="ExceptionCodes" value="UA">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$paramList/CLAIM/D6503"/>
                            </xsl:attribute>
                        </param>
                        <param name="DrugCost" value="004604">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$paramList/CLAIM/D6603"/>
                            </xsl:attribute>
                        </param>
                        <param name="Upcharge" value="01533">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$paramList/CLAIM/D6703"/>
                            </xsl:attribute>
                        </param>
                        <param name="ProfessionalFee" value="00700">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$paramList/CLAIM/D6803"/>
                            </xsl:attribute>
                        </param>
                        <param name="CompoundingCharge" value="00000">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$paramList/CLAIM/D7003"/>
                            </xsl:attribute>
                        </param>
                        <param name="CompoundingTime" value="00">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$paramList/CLAIM/D7103"/>
                            </xsl:attribute>
                        </param>
                        <param name="SpecialServicesFee" value="00000">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$paramList/CLAIM/D7203"/>
                            </xsl:attribute>
                        </param>
                        <param name="PreviouslyPaid" value="000000">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$paramList/CLAIM/D7503"/>
                            </xsl:attribute>
                        </param>
                        <param name="PharmacistID" value="9555">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$paramList/CLAIM/D7603"/>
                            </xsl:attribute>
                        </param>
                        <param name="AdjudicationDate" value="000000">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$paramList/CLAIM/D7703"/>
                            </xsl:attribute>
                        </param>
                    </paramList>
                </xsl:when>
                <xsl:when test="$name = 'paramList' and $paramList and @name = $paramList/@name">
                    <xsl:variable name="BaseParamList" select="."/>
                    <!-- <xsl:copy-of select="$paramList"/> -->
                    <paramList>
                        <xsl:for-each select="$paramList/param">
                            <xsl:variable name="paramName" select="@name"/>
                            <xsl:if test="$BaseParamList/param[@name = $paramName]">
                                <xsl:copy-of select="."/>
                            </xsl:if>
                        </xsl:for-each>
                    </paramList>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="$attributes">
                        <xsl:comment>
                            <xsl:call-template name="nodeXpath">
                                    <xsl:with-param name="node" select="."/>
                            </xsl:call-template>
                        </xsl:comment>
                    </xsl:if>
                    <xsl:element name="{$name}">
                        <xsl:variable name="element" select="."/>
                        <xsl:for-each select="@*">
                            <xsl:if test="name()">
                                <xsl:variable name="attr-value">
                                    <xsl:choose>
                                        <xsl:when test="$replace">
                                            <xsl:call-template name="replace-all">
                                                <xsl:with-param name="text" select="."/>
                                                <xsl:with-param name="replace-node" select="$replace"/>
                                            </xsl:call-template>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="."/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:attribute name="{name()}">
                                    <xsl:value-of select="$attr-value"/>
                                </xsl:attribute>
                                <xsl:if test="$name = 'rule' and $IgnoreRuleResultList and $IgnoreRuleResultList/rule[@name = $attr-value]">
                                    <xsl:attribute name="ignore">true</xsl:attribute>
                                </xsl:if>
                            </xsl:if>
                        </xsl:for-each>
                        <xsl:if test="$attributes">
                            <xsl:variable name="xpath">
                                <xsl:call-template name="nodeXpath">
                                    <xsl:with-param name="node" select="$element"/>
                                </xsl:call-template>
                            </xsl:variable>
                            
                            <xsl:for-each select="$attributes[@xpath = $xpath]">
                                <xsl:variable name="attr-name" select="@name"/>
                                <xsl:choose>
                                    <xsl:when test="@force = 'true'">
                                        <xsl:attribute name="{$attr-name}">
                                            <xsl:value-of select="@value"/>
                                        </xsl:attribute>
                                    </xsl:when>
                                    <xsl:when test="$element[name(attribute::*) = $attr-name]">
                                        <xsl:attribute name="{$attr-name}">
                                            <xsl:value-of select="@value"/>
                                        </xsl:attribute>
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:for-each>
                         </xsl:if>
                        
                        <xsl:if test="$name = 'messageProxy' and $validationList">
                            <xsl:variable name="msg-description" select="ancestor::node()[self::request or self::response]/@description"/>
                            <xsl:for-each select="$validationList/validation[@msg-description = $msg-description]">
                                <xsl:copy-of select="."/>
                            </xsl:for-each>
                        </xsl:if>
                        <xsl:apply-templates mode="workflow">
                            <xsl:with-param name="replace" select="$replace"/>
                            <xsl:with-param name="attributes" select="$attributes"/>
                            <xsl:with-param name="paramList" select="$paramList"/>
                            <xsl:with-param name="validationList" select="$validationList"/>
                            <xsl:with-param name="IgnoreRuleResultList" select="$IgnoreRuleResultList"/>
                        </xsl:apply-templates>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <xsl:template name="loadWorkflowReference">
        <xsl:variable name="filename">
            <xsl:value-of select="$localDirectory"/>
            <xsl:value-of select="@filename"/>
        </xsl:variable>

        <xsl:if test="$filename">
            <xsl:variable name="ref" select="document($filename)"/>
            <xsl:variable name="replace" select="replace"/>
            <xsl:variable name="attributes" select="attribute"/>
            <xsl:variable name="paramList" select="paramList"/>
            <xsl:variable name="validationList" select="validationList"/>
            <xsl:variable name="IgnoreRuleResultList" select="IgnoreRuleResultList"/>

            <xsl:for-each select="$ref/workflows">
                <!--                <xsl:comment>
                    Referance:<xsl:value-of select="$filename"/>
                    <xsl:for-each select="$replace"> (From:<xsl:value-of select="@from"/> to:<xsl:value-of select="@to"/>) </xsl:for-each>
                    <xsl:for-each select="$paramList"> (List:<xsl:value-of select="@name"/>) 
                        <xsl:for-each select="param"> (Name:<xsl:value-of select="@name"/> value:<xsl:value-of select="@value"/>)</xsl:for-each>
                    </xsl:for-each>
                    <xsl:for-each select="$validationList/validation"> (Name:<xsl:value-of select="@descriptions"/>) </xsl:for-each>
                    <xsl:for-each select="$IgnoreRuleResultList/rule"> (rule:<xsl:value-of select="@name"/>) </xsl:for-each>
                </xsl:comment>
-->
                <xsl:apply-templates mode="workflow">
                    <xsl:with-param name="replace" select="$replace"/>
                    <xsl:with-param name="attributes" select="$attributes"/>
                    <xsl:with-param name="paramList" select="$paramList"/>
                    <xsl:with-param name="validationList" select="$validationList"/>
                    <xsl:with-param name="IgnoreRuleResultList" select="$IgnoreRuleResultList"/>
                </xsl:apply-templates>
                <!-- 
                <xsl:call-template name="processElement">
                    <xsl:with-param name="replace" select="$replace"/>
                </xsl:call-template>
-->
            </xsl:for-each>

        </xsl:if>
    </xsl:template>

    <xsl:template name="loadMessageReference">
        <xsl:variable name="filename">
            <xsl:value-of select="$localDirectory"/>
            <xsl:value-of select="@filename"/>
        </xsl:variable>
        <xsl:if test="$filename">
            <xsl:variable name="ref" select="document($filename)"/>
            <xsl:variable name="replace" select="replace"/>
            <xsl:variable name="attributes" select="attribute"/>
            <xsl:variable name="paramList" select="paramList"/>
            <xsl:variable name="validationList" select="validationList"/>
            <xsl:variable name="IgnoreRuleResultList" select="IgnoreRuleResultList"/>


            <xsl:for-each select="$ref/workflows/workflow">
                <!--                <xsl:comment>
                    Referance:<xsl:value-of select="$filename"/>
                    <xsl:for-each select="$replace"> (From:<xsl:value-of select="@from"/> to:<xsl:value-of select="@to"/>) </xsl:for-each>
                    <xsl:for-each select="$paramList"> (List:<xsl:value-of select="@name"/>) 
                        <xsl:for-each select="param"> (Name:<xsl:value-of select="@name"/> value:<xsl:value-of select="@value"/>) </xsl:for-each>
                    </xsl:for-each>
                    <xsl:for-each select="$validationList/validation"> (Name:<xsl:value-of select="@descriptions"/>) </xsl:for-each>
                    <xsl:for-each select="$IgnoreRuleResultList/rule"> (rule:<xsl:value-of select="@name"/>) </xsl:for-each>
                </xsl:comment>
-->
                <xsl:apply-templates mode="workflow">
                    <xsl:with-param name="replace" select="$replace"/>
                            <xsl:with-param name="attributes" select="$attributes"/>
                    <xsl:with-param name="paramList" select="$paramList"/>
                    <xsl:with-param name="validationList" select="$validationList"/>
                    <xsl:with-param name="IgnoreRuleResultList" select="$IgnoreRuleResultList"/>
                </xsl:apply-templates>
                <!-- 
                    <xsl:call-template name="processElement">
                    <xsl:with-param name="replace" select="$replace"/>
                    </xsl:call-template>
                -->
            </xsl:for-each>

        </xsl:if>
    </xsl:template>

    <xsl:template name="replace-all">
        <xsl:param name="text"/>
        <xsl:param name="replace-node"/>

        <xsl:choose>

            <xsl:when test="starts-with($replace-node, '[REPLACE]')">
                <!-- format of replace in this case is "[REPLACE][FROM:XXX][TO:YYY]" where XXX and YYY are the values to be exchanged-->
                <xsl:variable name="from" select="substring-before(substring-after($replace-node,'[FROM:'),']')"/>
                <xsl:variable name="to" select="substring-before(substring-after($replace-node,'[TO:'),']')"/>
                <xsl:call-template name="replace-string">
                    <xsl:with-param name="from" select="$from"/>
                    <xsl:with-param name="to" select="$to"/>
                    <xsl:with-param name="text" select="$text"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="replace-string">
                    <xsl:with-param name="from" select="$replace-node/@from"/>
                    <xsl:with-param name="to" select="$replace-node/@to"/>
                    <xsl:with-param name="text">
                        <xsl:choose>
                            <xsl:when test="$replace-node/following-sibling::replace and $replace-node">
                                <xsl:call-template name="replace-all">
                                    <xsl:with-param name="text" select="$text"/>
                                    <xsl:with-param name="replace-node" select="$replace-node/following-sibling::replace"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$text"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <!-- reusable replace-string function -->
    <xsl:template name="replace-string">
        <xsl:param name="text"/>
        <xsl:param name="from"/>
        <xsl:param name="to"/>

        <xsl:choose>
            <xsl:when test="contains($text, $from)">

                <xsl:variable name="before" select="substring-before($text, $from)"/>
                <xsl:variable name="after" select="substring-after($text, $from)"/>
                <xsl:variable name="prefix" select="concat($before, $to)"/>

                <xsl:value-of select="$before"/>
                <xsl:value-of select="$to"/>
                <xsl:call-template name="replace-string">
                    <xsl:with-param name="text" select="$after"/>
                    <xsl:with-param name="from" select="$from"/>
                    <xsl:with-param name="to" select="$to"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$text"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="nodeXpath">
        <xsl:param name="node"/>
        <xsl:for-each select="$node/ancestor-or-self::*">
            <xsl:text>/</xsl:text>
            <xsl:value-of select="name()"/>
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name() = name(current())]) + 1"/>
            <xsl:text>]</xsl:text>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
