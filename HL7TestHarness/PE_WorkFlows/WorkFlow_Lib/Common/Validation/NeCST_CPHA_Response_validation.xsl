<?xml version="1.0" encoding="UTF-8"?>
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->  <xsl:stylesheet xmlns:hl7="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:import href="../Lib/Validation_Lib.xsl"/>
    
                                <xsl:param name="BIN" />
                                <xsl:param name="Version"/>
                                <xsl:param name="TransactionCode" />
                                <xsl:param name="ProviderSoftwareID" />
                                <xsl:param name="ProviderSoftwareVersion"/>
                                <xsl:param name="ActiveDeviceID" />
                                <xsl:param name="PharmacyIDCode" />
                                <xsl:param name="ProviderTransactionDate" />
                                <xsl:param name="TraceNumber" />
                                <xsl:param name="CarrierID" />
                                <xsl:param name="Group" />
                                <xsl:param name="ClientID" />
                                <xsl:param name="PatientCode" />
                                <xsl:param name="PatientDOB" />
                                <xsl:param name="CardholderIdentity" />
                                <xsl:param name="Relationship" />
                                <xsl:param name="PatientFirstName" />
                                <xsl:param name="PatientLastName" />
                                <xsl:param name="ProvincialHealthIdentifier" />
                                <xsl:param name="PatientGender" />
                                <xsl:param name="MedicalReasonReference" />
                                <xsl:param name="ReasonforUse" />
                                <xsl:param name="RefillCode" />
                                <xsl:param name="OriginalPrescription" />
                                <xsl:param name="RefillAuthorizations" />
                                <xsl:param name="CurrentRx" />
                                <xsl:param name="DIN" />
                                <xsl:param name="SSC" />
                                <xsl:param name="Quantity" />
                                <xsl:param name="DaysSupply" />
                                <xsl:param name="PrescriberIDReference" />
                                <xsl:param name="PrescriberID" />
                                <xsl:param name="ProductSelection" />
                                <xsl:param name="UnlistedCompound" />
                                <xsl:param name="SpecialAuthorization" />
                                <xsl:param name="ExceptionCodes" />
                                <xsl:param name="DrugCost" />
                                <xsl:param name="Upcharge" />
                                <xsl:param name="ProfessionalFee" />
                                <xsl:param name="CompoundingCharge" />
                                <xsl:param name="CompoundingTime" />
                                <xsl:param name="SpecialServicesFee" />
                                <xsl:param name="PreviouslyPaid" />
                                <xsl:param name="PharmacistID" />
                                <xsl:param name="AdjudicationDate" />
                                <xsl:param name="Response_AdjudicationDate" />
                                <xsl:param name="Response_TraceNumber" />
                                <xsl:param name="Response_TransactionCode" />
                                <xsl:param name="Response_ReferanceNumber" />
                                <xsl:param name="Response_ResponseStatus" />
                                <xsl:param name="Response_ResponseCodes" />
                                <xsl:param name="Response_DrugCost" />
                                <xsl:param name="Response_UpCharge" />
                                <xsl:param name="Response_GenericIncentive" />
                                <xsl:param name="Response_Professional" />
                                <xsl:param name="Response_CompoundingCharge" />
                                <xsl:param name="Response_SpecialServicesFee" />
                                <xsl:param name="Response_Copay" />
                                <xsl:param name="Response_Deductible" />
                                <xsl:param name="Response_Coinsurance" />
                                <xsl:param name="Response_PlanPays" />
                                <xsl:param name="Response_MessageLine1" />
                                <xsl:param name="Response_MessageLine2" />
                                <xsl:param name="Response_MessageLine3" />
    

    <xsl:template match="text()|@*"/>

    <xsl:template name="CPHA_Response_Data">

        <xsl:text> Adjudication Date:</xsl:text><xsl:value-of select="$Response_AdjudicationDate" />
        <xsl:text> Trace Number:</xsl:text><xsl:value-of select="$Response_TraceNumber" />
        <xsl:text> Transaction Code:</xsl:text><xsl:value-of select="$Response_TransactionCode" />
        <xsl:text> Referance Number:</xsl:text><xsl:value-of select="$Response_ReferanceNumber" />
        <xsl:text> Response Status:</xsl:text><xsl:value-of select="$Response_ResponseStatus" />
        <xsl:text> Response Codes:</xsl:text><xsl:value-of select="$Response_ResponseCodes" />
        <xsl:text> Drug Cost:</xsl:text><xsl:value-of select="$Response_DrugCost" />
        <xsl:text> Up Charge:</xsl:text><xsl:value-of select="$Response_UpCharge" />
        <xsl:text> Generic Incentive:</xsl:text><xsl:value-of select="$Response_GenericIncentive" />
        <xsl:text> Professional:</xsl:text><xsl:value-of select="$Response_Professional" />
        <xsl:text> Compounding Charge:</xsl:text><xsl:value-of select="$Response_CompoundingCharge" />
        <xsl:text> Special Services Fee:</xsl:text><xsl:value-of select="$Response_SpecialServicesFee" />
        <xsl:text> Co-pay:</xsl:text><xsl:value-of select="$Response_Copay" />
        <xsl:text> Deductible:</xsl:text><xsl:value-of select="$Response_Deductible" />
        <xsl:text> Co-Insurance:</xsl:text><xsl:value-of select="$Response_Coinsurance" />
       <xsl:text> Plan Pays:</xsl:text><xsl:value-of select="$Response_PlanPays" />
        <xsl:text> Message Line 1:</xsl:text><xsl:value-of select="$Response_MessageLine1" />
        <xsl:text> Message Line 2:</xsl:text><xsl:value-of select="$Response_MessageLine2" />
        <xsl:text> Message Line 3:</xsl:text><xsl:value-of select="$Response_MessageLine3" />

    </xsl:template>

    
    
    <xsl:template name="NeCST_Response_Data">

        <xsl:text> Adjudication Date(not compared):</xsl:text><xsl:call-template name="AdjDate"/>
        <xsl:text> Trace Number(not compared):</xsl:text><xsl:call-template name="TraceNumber"/>
        <xsl:text> Transaction Code:</xsl:text><xsl:call-template name="TransactionCode"/>
        <xsl:text> Referance Number(not compared):</xsl:text><xsl:call-template name="ReferanceNumber"/>
        <xsl:text> Response Status(not compared):</xsl:text><xsl:call-template name="ResponseStatus"/>
        <xsl:text> Response Codes:</xsl:text><xsl:call-template name="ResponseCodes"/>
        <xsl:text> Drug Cost:</xsl:text><xsl:call-template name="DrugCost"/>
        <xsl:text> Up Charge:</xsl:text><xsl:call-template name="UpCharge"/>
        <xsl:text> Generic Incentive:</xsl:text><xsl:call-template name="GenericIncentive"/>
        <xsl:text> Professional:</xsl:text><xsl:call-template name="ProfessionalFee"/>
        <xsl:text> Compounding Charge:</xsl:text><xsl:call-template name="CompoundingCharge"/>
        <xsl:text> Special Services Fee:</xsl:text><xsl:call-template name="SpecialServicesFee"/>
        <xsl:text> Co-pay:</xsl:text><xsl:call-template name="Copay"/>
        <xsl:text> Deductible:</xsl:text><xsl:call-template name="Deductible"/>
        <xsl:text> Co-Insurance:</xsl:text><xsl:call-template name="CoInsurance"/>
       <xsl:text> Plan Pays:</xsl:text><xsl:call-template name="PlanPays"/>
        <xsl:text> Message Line 1:</xsl:text><xsl:call-template name="MessageLine1"/>
        <xsl:text> Message Line 2:</xsl:text><xsl:call-template name="MessageLine2"/>
        <xsl:text> Message Line 3:</xsl:text><xsl:call-template name="MessageLine3"/>

    </xsl:template>
    

    <xsl:template match="/">
                    <xsl:call-template name="ReportError">
                <xsl:with-param name="ErrorText">CPHA to NeCST Compare</xsl:with-param>
                <xsl:with-param name="currentNode" select="."/>
                <xsl:with-param name="expectedValue">
                    <xsl:call-template name="CPHA_Response_Data"/>
                </xsl:with-param>
                <xsl:with-param name="actualValue">
                    <xsl:call-template name="NeCST_Response_Data"/>
                </xsl:with-param>
            </xsl:call-template>
    </xsl:template>
    
    
    <xsl:template name="AdjDate">
        <xsl:value-of select="/descendant-or-self::hl7:controlActProcess/hl7:effectiveTime/@value" />
    </xsl:template>
    <xsl:template name="TraceNumber">
        <xsl:value-of select="/descendant-or-self::hl7:controlActProcess/hl7:id/@extension" />
    </xsl:template>
    <xsl:template name="TransactionCode">
            <xsl:choose>
                <xsl:when test="/descendant-or-self::hl7:outcomeOf/hl7:adjudicationResult/hl7:code[@code ='AR']">51</xsl:when>
                <xsl:otherwise>61</xsl:otherwise>
            </xsl:choose>
    </xsl:template>
    <xsl:template name="ReferanceNumber">
        <xsl:value-of select="/descendant-or-self::hl7:paymentIntent/hl7:reasonOf/hl7:adjudicatedInvoiceElementGroup/hl7:id/@extension" />
    </xsl:template>
    <xsl:template name="ResponseStatus">
        <!-- TODO: get mapping to NeCST -->
    </xsl:template>
    <xsl:template name="ResponseCodes">
        <xsl:for-each select="/descendant-or-self::hl7:outcomeOf[position() &lt;=5]/hl7:adjudicationResult/hl7:code">
            <xsl:value-of select="@code"/>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="DrugCost">
        <xsl:variable name="DIN_OID">
            <xsl:call-template name="getOIDRoot">
                <xsl:with-param name="root">DIN</xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="/descendant-or-self::hl7:adjudicatedInvoiceElementDetail[hl7:code/@codeSystem = $DIN_OID]/hl7:netAmt/@value"/>
    </xsl:template>
    <xsl:template name="UpCharge">
        <xsl:value-of select="/descendant-or-self::hl7:adjudicatedInvoiceElementDetail[hl7:code/@code = 'MARKUP']/hl7:netAmt/@value"/>
    </xsl:template>
    <xsl:template name="GenericIncentive">
        
    </xsl:template>
    <xsl:template name="ProfessionalFee">
        <xsl:value-of select="/descendant-or-self::hl7:adjudicatedInvoiceElementDetail[hl7:code/@code = 'PROFFEE']/hl7:netAmt/@value"/>
    </xsl:template>
    <xsl:template name="CompoundingCharge">

    </xsl:template>
    <xsl:template name="SpecialServicesFee">

    </xsl:template>
    <xsl:template name="Copay">
        <xsl:value-of select="/descendant-or-self::hl7:adjudicatedInvoiceElementDetail[hl7:code/@code = 'COPAYMENT']/hl7:netAmt/@value"/>
    </xsl:template>
    <xsl:template name="Deductible">
        <xsl:value-of select="/descendant-or-self::hl7:adjudicatedInvoiceElementDetail[hl7:code/@code = 'DEDUCTIBLE']/hl7:netAmt/@value"/>
    </xsl:template>
    <xsl:template name="CoInsurance">
        <xsl:value-of select="/descendant-or-self::hl7:adjudicatedInvoiceElementDetail[hl7:code/@code = 'COINS']/hl7:netAmt/@value"/>
    </xsl:template>
    <xsl:template name="PlanPays">
        <xsl:value-of select="/descendant-or-self::hl7:paymentIntent/hl7:amt/@value"/>
    </xsl:template>
    <xsl:template name="MessageLine1">
        <xsl:value-of select="/descendant-or-self::hl7:detectedIssueEvent[1]/hl7:value/hl7:originalText"/>
    </xsl:template>
    <xsl:template name="MessageLine2">
        <xsl:value-of select="/descendant-or-self::hl7:detectedIssueEvent[2]/hl7:value/hl7:originalText"/>
    </xsl:template>
    <xsl:template name="MessageLine3">
        <xsl:value-of select="/descendant-or-self::hl7:detectedIssueEvent[3]/hl7:value/hl7:originalText"/>
    </xsl:template>
    


</xsl:stylesheet>
