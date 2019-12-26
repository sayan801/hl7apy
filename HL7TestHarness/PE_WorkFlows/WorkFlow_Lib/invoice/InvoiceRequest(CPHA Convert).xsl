<?xml version="1.0" encoding="UTF-8"?>
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:include href="../Common/SimulatorMessages/Invoice Message Templates.xsl"/>

    <xsl:param name="BIN"/>
    <xsl:param name="Version"/>
    <xsl:param name="TransactionCode">01</xsl:param>
    <xsl:param name="ProviderSoftwareID"/>
    <xsl:param name="ProviderSoftwareVersion"/>
    <xsl:param name="ActiveDeviceID"/>
    <xsl:param name="PharmacyIDCode"/>
    <xsl:param name="ProviderTransactionDate"/>
    <xsl:param name="TraceNumber"/>
    <xsl:param name="CarrierID"/>
    <xsl:param name="Group"/>
    <xsl:param name="ClientID"/>
    <xsl:param name="PatientCode"/>
    <xsl:param name="PatientDOB"/>
    <xsl:param name="CardholderIdentity"/>
    <xsl:param name="Relationship"/>
    <xsl:param name="PatientFirstName"/>
    <xsl:param name="PatientLastName"/>
    <xsl:param name="ProvincialHealthIdentifier"/>
    <xsl:param name="PatientGender"/>
    <xsl:param name="MedicalReasonReference"/>
    <xsl:param name="ReasonforUse"/>
    <xsl:param name="RefillCode"/>
    <xsl:param name="OriginalPrescription"/>
    <xsl:param name="RefillAuthorizations"/>
    <xsl:param name="CurrentRx"/>
    <xsl:param name="DIN"/>
    <xsl:param name="SSC"/>
    <xsl:param name="Quantity"/>
    <xsl:param name="DaysSupply"/>
    <xsl:param name="PrescriberIDReference"/>
    <xsl:param name="PrescriberID"/>
    <xsl:param name="ProductSelection"/>
    <xsl:param name="UnlistedCompound"/>
    <xsl:param name="SpecialAuthorization"/>
    <xsl:param name="ExceptionCodes"/>
    <xsl:param name="DrugCost">0</xsl:param>
    <xsl:param name="Upcharge">0</xsl:param>
    <xsl:param name="ProfessionalFee">0</xsl:param>
    <xsl:param name="CompoundingCharge">0</xsl:param>
    <xsl:param name="CompoundingTime">0</xsl:param>
    <xsl:param name="SpecialServicesFee">0</xsl:param>
    <xsl:param name="PreviouslyPaid">0</xsl:param>
    <xsl:param name="PharmacistID"/>
    <xsl:param name="AdjudicationDate"/>


    <xsl:param name="Currency">CAD</xsl:param>
    <xsl:param name="DispenseTime"/>
    <xsl:param name="msgEffectiveTime"/>


    <xsl:template match="/">
        <xsl:call-template name="SoapWapper"/>
    </xsl:template>

    <xsl:template match="/" mode="message">

        <xsl:call-template name="invoice_CPHA_Convert"/>

    </xsl:template>

    <xsl:template name="invoice_CPHA_Convert">
        <xsl:variable name="msgType">clientMsg</xsl:variable>
        <xsl:variable name="msgAction">addRequest</xsl:variable>
        
        <xsl:variable name="Quantity_value"><xsl:value-of select="substring($Quantity,1,string-length($Quantity)-1)"/><xsl:text>.</xsl:text><xsl:value-of select="substring($Quantity,string-length($Quantity)-1)"/></xsl:variable>


        <xsl:variable name="totalValue" select="$DrugCost + $Upcharge + $ProfessionalFee + $CompoundingCharge + $SpecialServicesFee"/>

        <xsl:variable name="InvoiceElement_root">
            <xsl:call-template name="getOIDRootByName">
                <xsl:with-param name="OID_Name">DIS_PRESCRIPTION_ID</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </xsl:variable>
        <!--<xsl:variable name="InvoiceElement_extension" select="$OriginalPrescription"/>-->
        <xsl:variable name="InvoiceElement_extension" select="$CurrentRx"/>
        


        <xsl:choose>
            <xsl:when test="$TransactionCode = '01' ">
                <!-- Invoice Request -->
                <FICR_IN600102 xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
                    <xsl:call-template name="transmissionWrapperStart">
                        <xsl:with-param name="interactionId">FICR_IN600102</xsl:with-param>
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                    <xsl:call-template name="transmissionWrapperEnd">
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>

                    <controlActProcess moodCode="RQO">
                        <!-- identifier should be stored for use in ‘undos’.  They should be stored in such a way that they are associated with the item that was modified by this event.  For example, a system should be able to show the list of trigger event identifiers for the actions that have been recorded against a particular prescription. -->
                        <id>
                            <xsl:attribute name="root">
                                <xsl:call-template name="getOIDRootByName">
                                    <xsl:with-param name="OID_Name">PORTAL_CONTROL_ACT_ID</xsl:with-param>
                                    <xsl:with-param name="msgType" select="$msgType"/>
                                </xsl:call-template>
                            </xsl:attribute>
                            <xsl:attribute name="extension">
                                <xsl:value-of select="$TraceNumber"/>
                            </xsl:attribute>
                        </id>
                        <!-- HL7TriggerEventCode - Identifies the trigger event that occurred -->
                        <code code="FICR_TE600101UV01"/>
                        <!-- time message was sent -->
                        <effectiveTime value="">
                            <!-- TODO: should this realy be that ProviderTransactionDate ? -->
                            <xsl:attribute name="value">
                                <xsl:choose>
                                    <xsl:when test="$msgEffectiveTime">
                                        <xsl:value-of select="$msgEffectiveTime"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:call-template name="getBaseDate"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                            
                        </effectiveTime>

                        <authorOrPerformer typeCode="AUT">
                            <time>
                                <xsl:call-template name="nullFlavor"/>
                            </time>
                            <!--ParticipationMode -  Indicates how the person who recorded the event became aware of it -->
                            <modeCode>
                                <xsl:call-template name="nullFlavor"/>
                            </modeCode>
                            <assignedPerson>
                                <!-- pharmacist or prescriber id  -->
                                <id root="" extension="">
                                    <xsl:attribute name="root">
                                        <xsl:call-template name="getOIDRootByName">
                                            <xsl:with-param name="OID_Name">PEI_PHARMACIST_BOARD_ID</xsl:with-param>
                                            <!--<xsl:with-param name="OID_Name">DEPT_HEALTH_PHARMACIST_ID</xsl:with-param>-->
                                            <xsl:with-param name="msgType" select="$msgType"/>
                                        </xsl:call-template>
                                    </xsl:attribute>
                                    <xsl:attribute name="extension">
                                        <xsl:value-of select="$PharmacistID"/>
                                    </xsl:attribute>
                                </id>
                                <!--  HealthcareProviderRoleType -->
                                <code>
                                    <xsl:call-template name="nullFlavor"/>
                                </code>
                                <assignedPerson>
                                    <name>
                                        <xsl:call-template name="nullFlavor"/>
                                    </name>
                                </assignedPerson>
                            </assignedPerson>
                        </authorOrPerformer>


                        <subject>
                            <paymentRequest>

                                <!-- DIS Dispense Identifier (dis_medication_record.id ) -->
                                <id>
                                    <xsl:call-template name="nullFlavor"/>
                                    <!-- don't provide if this is a predeturmination -->
                                    <!--<xsl:attribute name="root">
                                        <xsl:value-of select="$InvoiceElement_root"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="extension">
                                        <xsl:value-of select="$InvoiceElement_extension"/>
                                    </xsl:attribute>-->
                                </id>


                                <amt value="" currency="">
                                    <xsl:attribute name="value">
                                        <xsl:call-template name="convert_to_Dollors">
                                            <xsl:with-param name="cents" select="$totalValue"/>
                                        </xsl:call-template>
                                    </xsl:attribute>
                                    <xsl:attribute name="currency">
                                        <xsl:value-of select="$Currency"/>
                                    </xsl:attribute>
                                </amt>

                                <!-- payee : a pay provider invoice - this is all we support as pay person claims are manual and would continue to be done through CPHA for now -->
                                <credit>
                                    <account>
                                        <holder>
                                            <payeeRole classCode="PROV">
                                                <!-- pay provider identifier - i.e. the pharmacy -->
                                                <id>
                                                    <xsl:attribute name="root">
                                                        <xsl:call-template name="getOIDRootByName">
                                                            <xsl:with-param name="OID_Name">DEPT_HEALTH_PHARMACY_ID</xsl:with-param>
                                                            <xsl:with-param name="msgType" select="$msgType"/>
                                                        </xsl:call-template>
                                                    </xsl:attribute>
                                                    <xsl:attribute name="extension">
                                                        <xsl:value-of select="$PharmacyIDCode"/>
                                                    </xsl:attribute>
                                                </id>
                                            </payeeRole>
                                        </holder>
                                    </account>
                                </credit>



                                <!-- only 1 reason of element allowed for drug and compound invoices -->
                                <reasonOf>
                                    <invoiceElementGroup>
                                        <!-- root invoice element group - must be same values as CeRx pharmacy local dispense id -->
                                        <id>
                                            <xsl:call-template name="nullFlavor"/>
                                                                    <xsl:attribute name="root">
                                                                        <xsl:call-template name="getOIDRootByName">
                                                                            <xsl:with-param name="OID_Name">DIS_DISPENSE_ID</xsl:with-param>
                                                                            <xsl:with-param name="msgType" select="$msgType"/>
                                                                        </xsl:call-template>
                                                                    </xsl:attribute>
                                                                    <xsl:attribute name="extension">
                                                                        <xsl:value-of select="$CurrentRx"/>
                                                                    </xsl:attribute>
                                            
                                        </id>
                                        <!-- code = RXDINV - a drug invoice. We also support  RXCINV - a compound invoice -->
                                        <code code="RXDINV"/>
                                        <!-- Identifies the total monetary amount billed for the invoice element.  This is the sum of the Submitted Invoice Line amounts. 
                              Because we have only 1 reasonOf element, this should be identical to the paymentRequest.amt 
                         -->
                                        <netAmt value="" currency="">
                                            <xsl:attribute name="value">
                                                <xsl:call-template name="convert_to_Dollors">
                                                    <xsl:with-param name="cents" select="$totalValue"/>
                                                </xsl:call-template>
                                            </xsl:attribute>
                                            <xsl:attribute name="currency">
                                                <xsl:value-of select="$Currency"/>
                                            </xsl:attribute>
                                        </netAmt>

                                        <!-- 0..9 elements for explanation of benefits from upstream payors
                              as PEI is the first payor, we expect never to see this. We will handle
                              by summing the total of all paid elements and putting this in the previously paid
                              field in the database.
				
                                -->
                                        <xsl:if test="$PreviouslyPaid &gt; 0">
                                            <reference>
                                                <adjudicatedInvoiceElementGroup>
                                                    <!-- Invoice Type: should always be Rx Dispense, Rx Compound  -->
                                                    <code code="RXDINV"/>
                                                    <!-- real time adjudicated invoices should have status of completed -->
                                                    <statusCode code="completed"/>
                                                    <!-- amt upstream payor agrees to pay -->
                                                    <netAmt value="" currency="">
                                                        <xsl:attribute name="value">
                                                            <xsl:call-template name="convert_to_Dollors">
                                                                <xsl:with-param name="cents" select="$PreviouslyPaid + 0"/>
                                                            </xsl:call-template>
                                                        </xsl:attribute>
                                                        <xsl:attribute name="currency">
                                                            <xsl:value-of select="$Currency"/>
                                                        </xsl:attribute>
                                                    </netAmt>
                                                    <!-- other optional elements come here, but we will ignore and only focus on the amt that has been paid -->

                                                </adjudicatedInvoiceElementGroup>
                                            </reference>
                                        </xsl:if>



                                        <!-- coverage is mandatory for the Root Invoice Element Group and is not permitted for all other Invoice Element Groups. 
       						  For Pharmacy invoices, only supply policies for the Adjudicator that is the recipient of the Invoice.  Other policies that 
                              may be applied against an Invoice Grouping, that will not be adjudicatd by the Adjudicator, will not be included with the Invoice. 
                              In other words, you would not disclose policies for which the Adjudicator is not going to adjudicate against. 
                              However, we could see multiple coverage elements here for several different programs and we would have to pick the appropriate one.
                                -->
                                        <coverage typeCode="COVBY">
                                            <policyOrAccount classCode="COV" moodCode="EVN">
                                                <id>
                                                    <xsl:attribute name="root">
                                                        <xsl:call-template name="getOIDRootByName">
                                                            <xsl:with-param name="OID_Name">DEPT_HEALTH_PROGRAM_ID</xsl:with-param>
                                                            <xsl:with-param name="msgType" select="$msgType"/>
                                                        </xsl:call-template>
                                                    </xsl:attribute>
                                                    <xsl:attribute name="extension">
                                                        <xsl:value-of select="$Group"/>
                                                    </xsl:attribute>
                                                </id>
                                                <!-- identification of patient -->
                                                <beneficiary typeCode="BEN">
                                                    <coveredPartyAsPatient classCode="COVPTY">
                                                        <id root="" extension="01025147">
                                                            <xsl:attribute name="root">
                                                                <xsl:call-template name="getOIDRootByName">
                                                                    <xsl:with-param name="OID_Name">PE_PHN</xsl:with-param>
                                                                    <xsl:with-param name="msgType" select="$msgType"/>
                                                                </xsl:call-template>
                                                            </xsl:attribute>
                                                            <xsl:attribute name="extension">
                                                                <xsl:value-of select="$ProvincialHealthIdentifier"/>
                                                            </xsl:attribute>
                                                        </id>
                                                        <code>
                                                            <xsl:attribute name="code">
                                                                <xsl:choose>
                                                                    <xsl:when test="$Relationship = '0' ">SELF</xsl:when>
                                                                    <!-- Need the other Relationship values -->
                                                                    <xsl:otherwise>SELF</xsl:otherwise>
                                                                </xsl:choose>
                                                            </xsl:attribute>
                                                        </code>
                                                        <coveredPartyAsPatientPerson classCode="PSN" determinerCode="INSTANCE">
                                                            <name>
                                                                <given qualifier="BR">
                                                                    <xsl:value-of select="$PatientFirstName"/>
                                                                </given>
                                                                <family qualifier="BR">
                                                                    <xsl:value-of select="$PatientLastName"/>
                                                                </family>
                                                            </name>
                                                            <administrativeGenderCode code="F">
                                                                <xsl:attribute name="code">
                                                                    <xsl:value-of select="$PatientGender"/>
                                                                </xsl:attribute>
                                                            </administrativeGenderCode>
                                                            <birthTime>
                                                                <xsl:attribute name="value">
                                                                    <xsl:value-of select="$PatientDOB"/>
                                                                </xsl:attribute>
                                                            </birthTime>
                                                        </coveredPartyAsPatientPerson>
                                                    </coveredPartyAsPatient>
                                                </beneficiary>
                                                <author typeCode="AUT">
                                                    <carrierRole classCode="UNDWRT">
                                                        <id>
                                                            <xsl:attribute name="extension">
                                                                <xsl:value-of select="$CarrierID"/>
                                                            </xsl:attribute>
                                                        </id>
                                                    </carrierRole>
                                                </author>
                                            </policyOrAccount>
                                        </coverage>

                                        <!-- component containing a group that holds the drug and markup  -->
                                        <component>
                                            <invoiceElementGroup>
                                                <!-- from spec: For child Invoice Element Groups, the identifier will be the same as its parent Invoice Element Group, appended with a ".x", where "x" is a number 
                                      siginifying the occurence of this item under its parent.  For example, the parent id is "12942" and this is the 2nd item under the parent.  Therefore, the id for this item 
                                      would be "12942.2". -->
                                                <id>
                                                    <xsl:attribute name="root">
                                                        <xsl:value-of select="$InvoiceElement_root"/>
                                                    </xsl:attribute>
                                                    <xsl:attribute name="extension"><xsl:value-of select="$InvoiceElement_extension"/>.1</xsl:attribute>
                                                </id>
                                                <!-- at this level - we use DRUGING for the grouping that holds the drug and markup -->
                                                <code code="DRUGING"/>
                                                <!-- total for the drug plus markup -->
                                                <netAmt value="" currency="">
                                                    <xsl:attribute name="value">
                                                        <xsl:call-template name="convert_to_Dollors">
                                                            <xsl:with-param name="cents" select="$DrugCost + $Upcharge"/>
                                                        </xsl:call-template>
                                                    </xsl:attribute>
                                                    <xsl:attribute name="currency">
                                                        <xsl:value-of select="$Currency"/>
                                                    </xsl:attribute>
                                                </netAmt>
                                                <!-- detail component for the drug cost -->
                                                <component>

                                                    <invoiceElementDetail>
                                                        <id>
                                                            <xsl:attribute name="root">
                                                                <xsl:value-of select="$InvoiceElement_root"/>
                                                            </xsl:attribute>
                                                            <xsl:attribute name="extension"><xsl:value-of select="$InvoiceElement_extension"/>.1.1</xsl:attribute>
                                                        </id>
                                                        <code>
                                                            <xsl:attribute name="codeSystem">
                                                                <xsl:call-template name="getOIDRootByName">
                                                                    <xsl:with-param name="OID_Name">DIN</xsl:with-param>
                                                                    <xsl:with-param name="msgType" select="$msgType"/>
                                                                </xsl:call-template>
                                                            </xsl:attribute>
                                                            <xsl:attribute name="code">
                                                                <xsl:value-of select="$DIN"/>
                                                            </xsl:attribute>
                                                        </code>
                                                        <!--  For the <DIN>/<GTIN>/<UPC> invoice element detail, specifiy as "x" over "y" with no units of measure, where "x" is the number of pills and "y" is the package size.  E.g. "10" over "100". -->
                                                        <unitQuantity>
                                                            <numerator value="">
                                                                <xsl:attribute name="value">
                                                                    <xsl:call-template name="remove_leading_zeros">
                                                                        <xsl:with-param name="value" select="$Quantity_value"/>
                                                                    </xsl:call-template>
                                                                </xsl:attribute>
                                                            </numerator>
                                                            <denominator value="">
                                                                <xsl:attribute name="value">
                                                                    <xsl:call-template name="remove_leading_zeros">
                                                                        <xsl:with-param name="value" select="$Quantity_value"/>
                                                                    </xsl:call-template>
                                                                </xsl:attribute>
                                                            </denominator>
                                                        </unitQuantity>
                                                        <!-- For the <DIN>/<GTIN>/<UPC> invoice element detail, specifiy as "x" dollars over (per) "1" pill, with no units of measure.  E.g. "5.00" "CAD" over (per) "1". -->
                                                        <unitPriceAmt>
                                                            <numerator value="10.00" currency="CAD">
                                                                <xsl:attribute name="value">
                                                                    <xsl:call-template name="convert_to_Dollors">
                                                                        <xsl:with-param name="cents" select="$DrugCost"/>
                                                                    </xsl:call-template>
                                                                </xsl:attribute>
                                                                <xsl:attribute name="currency">
                                                                    <xsl:value-of select="$Currency"/>
                                                                </xsl:attribute>
                                                            </numerator>
                                                            <denominator value="1">
                                                                <xsl:attribute name="value">
                                                                    <xsl:call-template name="remove_leading_zeros">
                                                                        <xsl:with-param name="value" select="$Quantity_value"/>
                                                                    </xsl:call-template>
                                                                </xsl:attribute>
                                                            </denominator>
                                                        </unitPriceAmt>
                                                        <!-- drug cost -->
                                                        <netAmt value="" currency="">
                                                            <xsl:attribute name="value">
                                                                <xsl:call-template name="convert_to_Dollors">
                                                                    <xsl:with-param name="cents" select="$DrugCost  + 0"/>
                                                                </xsl:call-template>
                                                            </xsl:attribute>
                                                            <xsl:attribute name="currency">
                                                                <xsl:value-of select="$Currency"/>
                                                            </xsl:attribute>
                                                        </netAmt>
                                                    </invoiceElementDetail>
                                                </component>
                                                <!-- detail component for the markup -->
                                                <xsl:if test="$Upcharge">
                                                    <component>
                                                        <invoiceElementDetail>
                                                            <id>
                                                                <xsl:attribute name="root">
                                                                    <xsl:value-of select="$InvoiceElement_root"/>
                                                                </xsl:attribute>
                                                                <xsl:attribute name="extension"><xsl:value-of select="$InvoiceElement_extension"/>.1.2</xsl:attribute>
                                                            </id>
                                                            <code code="MARKUP"/>
                                                            <!-- For the MARKUP, PROFFEE invoice element details, specify as 1 over 1.  E.g. "1" over "1". -->
                                                            <unitQuantity>
                                                                <numerator value="1"/>
                                                                <denominator value="1"/>
                                                            </unitQuantity>
                                                            <!-- For the MARKUP, PROFFEE invoice element details, specify as "x" dollars over (per) "1" unit, with no units of measure.  E.g. "12.00" "CAD" over (per) "1". -->
                                                            <unitPriceAmt>
                                                                <numerator value="" currency="">
                                                                    <xsl:attribute name="value">
                                                                        <xsl:call-template name="convert_to_Dollors">
                                                                            <xsl:with-param name="cents" select="$Upcharge + 0"/>
                                                                        </xsl:call-template>
                                                                    </xsl:attribute>
                                                                    <xsl:attribute name="currency">
                                                                        <xsl:value-of select="$Currency"/>
                                                                    </xsl:attribute>
                                                                </numerator>
                                                                <denominator value="1"/>
                                                            </unitPriceAmt>
                                                            <netAmt value="" currency="">
                                                                <xsl:attribute name="value">
                                                                    <xsl:call-template name="convert_to_Dollors">
                                                                        <xsl:with-param name="cents" select="$Upcharge + 0"/>
                                                                    </xsl:call-template>
                                                                </xsl:attribute>
                                                                <xsl:attribute name="currency">
                                                                    <xsl:value-of select="$Currency"/>
                                                                </xsl:attribute>
                                                            </netAmt>
                                                        </invoiceElementDetail>
                                                    </component>
                                                </xsl:if>

                                                <reasonOf>
                                                    <supplyEvent1 moodCode="RQO">
                                                        <!-- Type of Dispense: first fill/partial fill/trial/completion of trial, etc. ActPharmacySupplyType -->
                                                        <code code="FF">
                                                            <xsl:if test="not($RefillCode = 'N')">
                                                                <xsl:attribute name="code">RF</xsl:attribute>
                                                            </xsl:if>
                                                        </code>
                                                        <!-- dispense time - must support hour/minute to handle multi-dispense/day of same product - e.g. methadone -->
                                                        <effectiveTime>
                                                            <xsl:attribute name="value">
                                                                <xsl:choose>
                                                                    <xsl:when test="$DispenseTime">
                                                                        <xsl:value-of select="$DispenseTime"/>
                                                                    </xsl:when>
                                                                    <xsl:otherwise>
                                                                        <xsl:call-template name="getBaseDate"/>
                                                                    </xsl:otherwise>
                                                                </xsl:choose>
                                                            </xsl:attribute>
                                                        </effectiveTime>
                                                        <!-- Quantity suppled. The quantity billed will generally default to the quantity supplied. 0 is not a valid value, as non-dispense events (e.g. prof services) 
					  should not include a supply (dispense) event. leave unit blank for pills -->
                                                        <quantity value="0">
                                                            <xsl:attribute name="value">
                                                                <xsl:call-template name="remove_leading_zeros">
                                                                    <xsl:with-param name="value" select="$Quantity_value"/>
                                                                </xsl:call-template>
                                                            </xsl:attribute>
                                                        </quantity>
                                                        <!-- Dispensed Days Supply : see x_TimeUnitsOfMeasure for time units -->
                                                        <expectedUseTime>
                                                            <width value="10" unit="d">
                                                                <xsl:attribute name="value">
                                                                    <xsl:call-template name="remove_leading_zeros">
                                                                        <xsl:with-param name="value" select="$DaysSupply"/>
                                                                    </xsl:call-template>
                                                                </xsl:attribute>
                                                            </width>
                                                        </expectedUseTime>
                                                        <product>
                                                            <manufacturedProduct>
                                                                <manufacturedMaterialKind>
                                                                    <!-- OID needs to be identified for DIN coding system -->
                                                                    <code>
                                                                        <xsl:attribute name="codeSystem">
                                                                            <xsl:call-template name="getOIDRootByName">
                                                                                <xsl:with-param name="OID_Name">DIN</xsl:with-param>
                                                                                <xsl:with-param name="msgType" select="$msgType"/>
                                                                            </xsl:call-template>
                                                                        </xsl:attribute>
                                                                        <xsl:attribute name="code">
                                                                            <xsl:value-of select="$DIN"/>
                                                                        </xsl:attribute>
                                                                    </code>
                                                                </manufacturedMaterialKind>
                                                            </manufacturedProduct>
                                                        </product>
                                                        <!-- identification of the pharmacist -->
                                                        <performer typeCode="PRF">
                                                            <healthCareProvider classCode="PROV">
                                                                <!-- pharmacist id -->
                                                                <id>
                                                                    <xsl:attribute name="root">
                                                                        <xsl:call-template name="getOIDRootByName">
                                            <xsl:with-param name="OID_Name">PEI_PHARMACIST_BOARD_ID</xsl:with-param>
                                            <!--<xsl:with-param name="OID_Name">DEPT_HEALTH_PHARMACIST_ID</xsl:with-param>-->
                                                                            <xsl:with-param name="msgType" select="$msgType"/>
                                                                        </xsl:call-template>
                                                                    </xsl:attribute>
                                                                    <xsl:attribute name="extension">
                                                                        <xsl:value-of select="$PharmacistID"/>
                                                                    </xsl:attribute>
                                                                </id>
                                                            </healthCareProvider>
                                                        </performer>
                                                        <!-- identifies a location to which drug may be shipped - we don't use this ignore if provided -->
                                                        <location>
                                                            <serviceDeliveryLocation>
                                                                <id nullFlavor="NA"/>
                                                            </serviceDeliveryLocation>
                                                        </location>
                                                        <!-- identification of some prescription details and prescriber -->
                                                        <reasonOf>
                                                            <substanceAdministrationIntent>
                                                                <!-- optional dis e-prescription id -->
                                                                <id>
                                                                    <xsl:attribute name="root">
                                                                        <xsl:call-template name="getOIDRootByName">
                                                                            <xsl:with-param name="OID_Name">DIS_PRESCRIPTION_ID</xsl:with-param>
                                                                            <xsl:with-param name="msgType" select="$msgType"/>
                                                                        </xsl:call-template>
                                                                    </xsl:attribute>
                                                                    <xsl:attribute name="extension">
                                                                        <!--<xsl:value-of select="$OriginalPrescription"/>-->
                                                                        <xsl:value-of select="$CurrentRx"/>
                                                                    </xsl:attribute>
                                                                </id>
                                                                <!-- details of the original prescription for which the dispense is filling -->
                                                                <inFulfillmentOf typeCode="FLFS">
                                                                    <substanceAdministrationOrder classCode="SBADM" moodCode="RQO">
                                                                        <!-- identify the prescriber -->
                                                                        <author typeCode="AUT">
                                                                            <prescriberRole classCode="ROL">
                                                                                <!-- prescriber id -->
                                                                                <id root="2.16.124.9.101.1.9.21" extension="123455">
                                                                                    <xsl:attribute name="root">
                                                                                        <xsl:call-template name="getOIDRootByName">
                                                                                            <xsl:with-param name="OID_Name">
                                                                                                <xsl:choose>
                                                                                                    <!-- TODO: add other Ref numbers -->
                                                                                                    <xsl:when test="$PrescriberIDReference = '21' ">DEPT_HEALTH_BILLING_NUMBER</xsl:when>
                                                                                                    <xsl:otherwise>DEPT_HEALTH_BILLING_NUMBER</xsl:otherwise>
                                                                                                </xsl:choose>
                                                                                            </xsl:with-param>
                                                                                            <xsl:with-param name="msgType" select="$msgType"/>
                                                                                        </xsl:call-template>
                                                                                    </xsl:attribute>
                                                                                    <xsl:attribute name="extension">
                                                                                        <xsl:value-of select="$PrescriberID"/>
                                                                                    </xsl:attribute>
                                                                                </id>
                                                                                <playingPrescriberPerson>
                                                                                    <name>
                                                                                        <xsl:call-template name="nullFlavor"/>
                                                                                    </name>
                                                                                </playingPrescriberPerson>
                                                                            </prescriberRole>
                                                                        </author>
                                                                        <xsl:if test="$RefillAuthorizations">
                                                                        <reason typeCode="RSON">
                                                                            <supplyOrder classCode="SPLY" moodCode="RQO">
                                                                                <effectiveTime>
                                                                                    <high>
                                                                                        <xsl:attribute name="value">
                                                                                            <xsl:choose>
                                                                                                <xsl:when test="$DispenseTime">
                                                                                                    <xsl:value-of select="$DispenseTime"/>
                                                                                                </xsl:when>
                                                                                                <xsl:otherwise>
                                                                                                    <xsl:call-template name="getBaseDate"/>
                                                                                                </xsl:otherwise>
                                                                                            </xsl:choose>
                                                                                        </xsl:attribute>                                                                                        
                                                                                    </high>
                                                                                </effectiveTime>
                                                                                <repeatNumber>
                                                                                    <center value="12">
                                                                                        <xsl:attribute name="value"><xsl:value-of select="$RefillAuthorizations"/></xsl:attribute>
                                                                                    </center>
                                                                                </repeatNumber>
                                                                            </supplyOrder>
                                                                            </reason>
                                                                        </xsl:if>
                                                                        <!-- restrictions on substitution from the Ordering Provider perspective  -->
                                                                        <xsl:if test="$ProductSelection and $ProductSelection = '1' ">
                                                                            <pertinentInformation typeCode="PERT">
                                                                                <substitution classCode="SUBST" moodCode="EVN">
                                                                                    <code code="N"/>
                                                                                </substitution>
                                                                            </pertinentInformation>
                                                                        </xsl:if>
                                                                    </substanceAdministrationOrder>
                                                                </inFulfillmentOf>
                                                                <!-- optionally indicates any substitution that was actually done by the dispenser -->
                                                                <!-- type of substitution: G generic, TE therapeutic, F formulary, N none - ActSubstanceAdminSubstitutionCode  -->
                                                                <!-- reason why subs performed - OS out of stock  -->
                                                                <!-- TODO: check if this comes in CPHA message
                                                                 <pertinentInformation>
                                                                    <substitution>
                                                                        <code code="G"/>
                                                                        <reasonCode code="OS"/>
                                                                    </substitution>
                                                                </pertinentInformation>-->
                                                            </substanceAdministrationIntent>
                                                        </reasonOf>
                                                    </supplyEvent1>
                                                </reasonOf>

                                            </invoiceElementGroup>
                                        </component>

                                        <!-- component to represent the professional fee -->
                                        <xsl:if test="$ProfessionalFee &gt; 0">
                                            <component typeCode="COMP">
                                                <invoiceElementDetail classCode="INVE" moodCode="RQO">
                                                    <!-- this is the second occurence of component at this level, so append .2 to the extension attribute -->
                                                    <id>
                                                        <xsl:attribute name="root">
                                                            <xsl:value-of select="$InvoiceElement_root"/>
                                                        </xsl:attribute>
                                                        <xsl:attribute name="extension"><xsl:value-of select="$InvoiceElement_extension"/>.2</xsl:attribute>
                                                    </id>
                                                    <!-- Note that there is no code represent a professional fee within the HL7 vocabulary - the following code however is referenced in the NeCST Tag spreadsheets -->
                                                    <code code="PROFFEE"/>
                                                    <!-- For the MARKUP, PROFFEE invoice element details, specify as 1 over 1.  E.g. "1" over "1". -->
                                                    <unitQuantity>
                                                        <numerator value="1"/>
                                                        <denominator value="1"/>
                                                    </unitQuantity>
                                                    <!-- For the MARKUP, PROFFEE invoice element details, specify as "x" dollars over (per) "1" unit, with no units of measure.  E.g. "12.00" "CAD" over (per) "1". -->
                                                    <unitPriceAmt>
                                                        <numerator value="" currency="">
                                                            <xsl:attribute name="value">
                                                                <xsl:call-template name="convert_to_Dollors">
                                                                    <xsl:with-param name="cents" select="$ProfessionalFee + 0 "/>
                                                                </xsl:call-template>
                                                            </xsl:attribute>
                                                            <xsl:attribute name="currency">
                                                                <xsl:value-of select="$Currency"/>
                                                            </xsl:attribute>
                                                        </numerator>
                                                        <denominator value="1"/>
                                                    </unitPriceAmt>
                                                    <netAmt value="" currency="">
                                                        <xsl:attribute name="value">
                                                            <xsl:call-template name="convert_to_Dollors">
                                                                <xsl:with-param name="cents" select="$ProfessionalFee + 0"/>
                                                            </xsl:call-template>
                                                        </xsl:attribute>
                                                        <xsl:attribute name="currency">
                                                            <xsl:value-of select="$Currency"/>
                                                        </xsl:attribute>
                                                    </netAmt>
                                                </invoiceElementDetail>
                                            </component>
                                        </xsl:if>
                                        <!--0..* override codes that the pharmacist may have provided.  If an adjudicator does not support the override (e.g. repeated service), the override code 
						    should not be ignored.  In other words, the Invoice Grouping will likely be refused with a message "we don't support this type of override" -->
                                        <xsl:if test="$SpecialAuthorization">
                                            <triggerFor>
                                                <invoiceElementOverride>
                                                    <code code="">
                                                        <xsl:attribute name="code">
                                                            <xsl:value-of select="$SpecialAuthorization"/>
                                                        </xsl:attribute>
                                                    </code>
                                                </invoiceElementOverride>
                                            </triggerFor>
                                        </xsl:if>

                                    </invoiceElementGroup>
                                </reasonOf>
                            </paymentRequest>
                        </subject>

                    </controlActProcess>

                </FICR_IN600102>

            </xsl:when>
            <xsl:when test="$TransactionCode = '11' ">
                <!-- Invoice Reversal Request -->
                <FICR_IN620102 xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
                    <xsl:call-template name="transmissionWrapperStart">
                        <xsl:with-param name="interactionId">FICR_IN620102</xsl:with-param>
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                    <xsl:call-template name="transmissionWrapperEnd">
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>

                    <controlActProcess moodCode="RQO">
                                <id>
                                    <xsl:attribute name="root">
                                        <xsl:call-template name="getOIDRootByName">
                                            <xsl:with-param name="OID_Name">PORTAL_CONTROL_ACT_ID</xsl:with-param>
                                            <xsl:with-param name="msgType" select="$msgType"/>
                                        </xsl:call-template>
                                    </xsl:attribute>
                                    <xsl:attribute name="extension">
                                        <xsl:value-of select="$TraceNumber"/>
                                    </xsl:attribute>
                                </id>
                        <subject contextConductionInd="false" typeCode="SUBJ">
                            <invoiceElementGroup>
                                <id>
                                    <xsl:attribute name="root">
                                        <xsl:call-template name="getOIDRootByName">
                                            <xsl:with-param name="OID_Name">DIS_PRESCRIPTION_ID</xsl:with-param>
                                            <xsl:with-param name="msgType" select="$msgType"/>
                                        </xsl:call-template>
                                    </xsl:attribute>
                                    <xsl:attribute name="extension">
                                        <!--<xsl:value-of select="$OriginalPrescription"/>-->
                                        <xsl:value-of select="$CurrentRx"/>
                                    </xsl:attribute>
                                </id>
                                <code code="RXDINV"/>
                                <netAmt value="" currency="">
                                    <xsl:attribute name="value">
                                        <xsl:call-template name="convert_to_Dollors">
                                            <xsl:with-param name="cents" select="$totalValue"/>
                                        </xsl:call-template>
                                    </xsl:attribute>
                                    <xsl:attribute name="currency">
                                        <xsl:value-of select="$Currency"/>
                                    </xsl:attribute>
                                </netAmt>
                            </invoiceElementGroup>
                        </subject>
                    </controlActProcess>
                </FICR_IN620102>
            </xsl:when>
        </xsl:choose>


    </xsl:template>


    <xsl:template name="convert_to_Dollors">
        <xsl:param name="cents"/>
        <xsl:choose>
            <xsl:when test="not($cents)">
                <xsl:text>0.00</xsl:text>
            </xsl:when>
            <xsl:when test="string-length($cents) &gt; 2">
                <xsl:value-of select="substring($cents,1,string-length($cents) - 2)"/>
                <xsl:text>.</xsl:text>
                <xsl:value-of select="substring($cents,string-length($cents) - 1)"/>
            </xsl:when>
            <xsl:when test="string-length($cents) = 2">
                <xsl:text>0.</xsl:text>
                <xsl:value-of select="$cents"/>
            </xsl:when>
            <xsl:when test="string-length($cents) = 1">
                <xsl:text>0.0</xsl:text>
                <xsl:value-of select="$cents"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>0.00</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="remove_leading_zeros">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="string-length($value) &lt; 1">0</xsl:when>
            <xsl:when test="string-length($value)  = 1">
                <xsl:value-of select="$value"/>
            </xsl:when>
            <xsl:when test="starts-with($value, '0')">
                <xsl:call-template name="remove_leading_zeros">
                    <xsl:with-param name="value" select="substring($value,2)"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>


</xsl:stylesheet>
