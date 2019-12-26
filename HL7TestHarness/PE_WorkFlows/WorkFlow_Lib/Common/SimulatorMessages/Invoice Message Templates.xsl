<?xml version="1.0" encoding="UTF-8"?>
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="urn:hl7-org:v3" xmlns:hl7="urn:hl7-org:v3" version="1.0">
    <xsl:include href="../Lib/MsgCreation_Lib.xsl"/>

    <xsl:key name="keyTotals" match="Daily-totals" use="@Date"/>

    <xsl:template name="invoiceRequest">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>
    <xsl:param name="author-description"/>
    <xsl:param name="payee-description"/>
        <xsl:param name="prescriber-description"/>

        <xsl:param name="invoice-description"/>

        <xsl:variable name="msgType">clientMsg</xsl:variable>
        <xsl:variable name="msgAction">addRequest</xsl:variable>

<!--         <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][patient/@description = $patient-description]"/> -->
        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][not($patient-description) or patient/@description = $patient-description]"/>


        <xsl:variable name="invoiceData" select="$ProfileData/descendant::items/invoice[@description=$invoice-description]"/>

        <xsl:variable name="Dispense-description" select="$invoiceData/dispense/@description"/>
        <xsl:variable name="DispenseData" select="$ProfileData/items/dispense[@description=$Dispense-description]"/>
        <xsl:variable name="DispenseInfo" select="$BaseData/dispenses/dispense[@description=$Dispense-description]"/>
        <xsl:variable name="Rx-description" select="$DispenseData/prescription/@description"/>
        <xsl:variable name="RxData" select="$BaseData/prescriptions/prescription[@description=$Rx-description]"/>
        <xsl:variable name="RxProfileData" select="$ProfileData/items/prescription[@description=$Rx-description]"/>
        <xsl:variable name="Drug-description" select="$RxData/drug/@description"/>
        <xsl:variable name="DrugData" select="$BaseData/drugs/drug[@description=$Drug-description]"/>

        <xsl:variable name="DrugCost">
            <xsl:choose>
                <xsl:when test="$DrugData/cost/@value">
                    <xsl:value-of select="$DrugData/cost/@value"/>
                </xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="DrugQuantity">
            <xsl:choose>
                <xsl:when test="$DrugData/quantity/@value">
                    <xsl:value-of select="$DrugData/quantity/@value"/>
                </xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="DrugCostPer">
            <xsl:choose>
                <xsl:when test="$DrugData/cost/@per">
                    <xsl:value-of select="$DrugData/cost/@per"/>
                </xsl:when>
                <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>


        <!-- total requested amt for invoice -->
        <xsl:variable name="totalValue" select="$invoiceData/request/professionalfee/@value + $invoiceData/request/markupfee/@value + (($DrugCost * $DrugQuantity) div $DrugCostPer)"/>
        <xsl:variable name="InvoiceElement_root">
            <xsl:call-template name="getOIDRootByName">
                <xsl:with-param name="OID_Name">
                    <xsl:value-of select="$DispenseData/local-id/@root_OID"/>
                </xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="InvoiceElement_extension">
            <xsl:call-template name="record-id">
                <xsl:with-param name="Record" select="$DispenseData/local-id"/>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </xsl:variable>

         

        <FICR_IN600102 xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:comment>search: <xsl:value-of select="$profile-description"/>; <xsl:value-of select="$profile-sequence"/>; <xsl:value-of select="$patient-description"/> </xsl:comment>
            <xsl:comment>profile: <xsl:value-of select="$ProfileData/@description"/>; <xsl:value-of select="$ProfileData/@sequence"/>;  <xsl:value-of select="$ProfileData/patient/@description"/></xsl:comment>
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
                        <xsl:value-of select="$OID"/>
                    </xsl:attribute>
                </id>
                <!-- HL7TriggerEventCode - Identifies the trigger event that occurred -->
                <code code="FICR_TE600101UV01"/>
                <!-- time message was sent -->
                <effectiveTime value="">
                    <xsl:attribute name="value">
                        <xsl:call-template name="getBaseDateTime"/>
                    </xsl:attribute>
                </effectiveTime>

                <authorOrPerformer typeCode="AUT">
                    <time>
                        <xsl:choose>
                            <xsl:when test="$author-description">
                                <xsl:call-template name="nullFlavor"/>
                            </xsl:when>
                            <xsl:when test="$invoiceData/author/@time">
                                <xsl:attribute name="value">
                                    <xsl:value-of select="$invoiceData/author/@time"/>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="nullFlavor"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </time>
                    <!--ParticipationMode -  Indicates how the person who recorded the event became aware of it -->
                    <modeCode>
                        <xsl:choose>
                            <xsl:when test="$author-description">
                                <xsl:call-template name="nullFlavor"/>
                            </xsl:when>
                            <xsl:when test="$invoiceData/author/@ParticipationMode">
                                <xsl:attribute name="code">
                                    <xsl:value-of select="$invoiceData/author/@ParticipationMode"/>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="nullFlavor"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </modeCode>
                    <xsl:choose>
                            <xsl:when test="$author-description">
                                <xsl:call-template name="ProviderByDescription">
                                    <xsl:with-param name="description" select="$author-description"/>
                                    <xsl:with-param name="msgType" select="$msgType"/>
                                    <xsl:with-param name="format">necst</xsl:with-param>
                                </xsl:call-template>
                            </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="ProviderByDescription">
                                <xsl:with-param name="description" select="$invoiceData/author/@description"/>
                                <xsl:with-param name="msgType" select="$msgType"/>
                                <xsl:with-param name="format">necst</xsl:with-param>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                    
                </authorOrPerformer>


                <subject>
                    <paymentRequest>

                        <!-- DIS Dispense Identifier (dis_medication_record.id ) -->
                        <id>
                            <xsl:choose>
                                <xsl:when test="$invoiceData/@predetermin = 'true'">
                                    <xsl:call-template name="nullFlavor"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:attribute name="root">
                                        <xsl:call-template name="getOIDRootByName">
                                            <xsl:with-param name="OID_Name">
                                                <xsl:value-of select="$DispenseData/record-id/@root_OID"/>
                                            </xsl:with-param>
                                            <xsl:with-param name="msgType" select="$msgType"/>
                                        </xsl:call-template>
                                    </xsl:attribute>
                                    <xsl:attribute name="extension">
                                        <xsl:call-template name="record-id">
                                            <xsl:with-param name="Record" select="$DispenseData/record-id"/>
                                            <xsl:with-param name="msgType" select="$msgType"/>
                                        </xsl:call-template>
                                    </xsl:attribute>
                                </xsl:otherwise>
                            </xsl:choose>
                        </id>


                        <amt value="" currency="">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$totalValue"/>
                            </xsl:attribute>
                            <xsl:attribute name="currency">
                                <xsl:value-of select="$invoiceData/@currency"/>
                            </xsl:attribute>
                        </amt>

                        <!-- payee : a pay provider invoice - this is all we support as pay person claims are manual and would continue to be done through CPHA for now -->
                        <credit>
                            <account>
                                <holder>
                                    <payeeRole classCode="PROV">
                                        <!-- pay provider identifier - i.e. the pharmacy -->
                                        <id>
                                            <xsl:choose>
                                                <xsl:when test="$payee-description and $BaseData/serviceDeliveryLocations/location[@description = $payee-description]">
                                                    <xsl:variable name="location" select="$BaseData/serviceDeliveryLocations/location[@description = $payee-description]"/>
                                                    <xsl:choose>
                                                        <xsl:when test="$msgType = 'clientMsg'">
                                                            <xsl:attribute name="root">
                                                                <xsl:value-of select="$location/client/id/@root"/>
                                                            </xsl:attribute>
                                                            <xsl:attribute name="extension">
                                                                <xsl:value-of select="$location/client/id/@extension"/>
                                                            </xsl:attribute>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:attribute name="root">
                                                                <xsl:value-of select="$location/server/id/@root"/>
                                                            </xsl:attribute>
                                                            <xsl:attribute name="extension">
                                                                <xsl:value-of select="$location/server/id/@extension"/>
                                                            </xsl:attribute>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:when>
                                                <xsl:when test="$payee-description and $BaseData/providers/provider[@description = $payee-description]">
                                                    <xsl:variable name="provider" select="$BaseData/providers/provider[@description = $payee-description]"/>
                                                    <xsl:choose>
                                                        <xsl:when test="$msgType = 'clientMsg'">
                                                            <xsl:attribute name="root">
                                                                <xsl:value-of select="$provider/client/id/@root"/>
                                                            </xsl:attribute>
                                                            <xsl:attribute name="extension">
                                                                <xsl:value-of select="$provider/client/id/@extension"/>
                                                            </xsl:attribute>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:attribute name="root">
                                                                <xsl:value-of select="$provider/server/id/@root"/>
                                                            </xsl:attribute>
                                                            <xsl:attribute name="extension">
                                                                <xsl:value-of select="$provider/server/id/@extension"/>
                                                            </xsl:attribute>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:when>
                                                <xsl:when test="$BaseData/providers/provider/@description = $invoiceData/payee/@description">
                                                    <xsl:variable name="provider" select="$BaseData/providers/provider[@description = $invoiceData/payee/@description]"/>
                                                    <xsl:choose>
                                                        <xsl:when test="$msgType = 'clientMsg'">
                                                            <xsl:attribute name="root">
                                                                <xsl:value-of select="$provider/client/id/@root"/>
                                                            </xsl:attribute>
                                                            <xsl:attribute name="extension">
                                                                <xsl:value-of select="$provider/client/id/@extension"/>
                                                            </xsl:attribute>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:attribute name="root">
                                                                <xsl:value-of select="$provider/server/id/@root"/>
                                                            </xsl:attribute>
                                                            <xsl:attribute name="extension">
                                                                <xsl:value-of select="$provider/server/id/@extension"/>
                                                            </xsl:attribute>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:when>
                                                <xsl:when test="$BaseData/serviceDeliveryLocations/location[@description = $invoiceData/payee/@description]">
                                                    <xsl:variable name="location" select="$BaseData/serviceDeliveryLocations/location[@description = $invoiceData/payee/@description]"/>
                                                    <xsl:choose>
                                                        <xsl:when test="$msgType = 'clientMsg'">
                                                            <xsl:attribute name="root">
                                                                <xsl:value-of select="$location/client/id/@root"/>
                                                            </xsl:attribute>
                                                            <xsl:attribute name="extension">
                                                                <xsl:value-of select="$location/client/id/@extension"/>
                                                            </xsl:attribute>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:attribute name="root">
                                                                <xsl:value-of select="$location/server/id/@root"/>
                                                            </xsl:attribute>
                                                            <xsl:attribute name="extension">
                                                                <xsl:value-of select="$location/server/id/@extension"/>
                                                            </xsl:attribute>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:when>
                                            </xsl:choose>
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
                                    <xsl:attribute name="root">
                                        <xsl:value-of select="$InvoiceElement_root"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="extension">
                                        <xsl:value-of select="$InvoiceElement_extension"/>
                                    </xsl:attribute>
                                </id>
                                <!-- code = RXDINV - a drug invoice. We also support  RXCINV - a compound invoice -->
                                <code code="RXDINV"/>
                                <!-- Identifies the total monetary amount billed for the invoice element.  This is the sum of the Submitted Invoice Line amounts. 
                              Because we have only 1 reasonOf element, this should be identical to the paymentRequest.amt 
                         -->
                                <netAmt value="" currency="">
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="$totalValue"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="currency">
                                        <xsl:value-of select="$invoiceData/@currency"/>
                                    </xsl:attribute>
                                </netAmt>

                                <!-- 0..9 elements for explanation of benefits from upstream payors
                              as PEI is the first payor, we expect never to see this. We will handle
                              by summing the total of all paid elements and putting this in the previously paid
                              field in the database.
				
                                -->
                                <xsl:for-each select="$invoiceData/request/upstreampayor">
                                    <reference>
                                        <adjudicatedInvoiceElementGroup>
                                            <!-- Invoice Type: should always be Rx Dispense, Rx Compound  -->
                                            <code code="RXDINV"/>
                                            <!-- real time adjudicated invoices should have status of completed -->
                                            <statusCode code="completed"/>
                                            <!-- amt upstream payor agrees to pay -->
                                            <netAmt value="" currency="">
                                                <xsl:attribute name="value">
                                                    <xsl:value-of select="$invoiceData/request/upstreampayor/@value"/>
                                                </xsl:attribute>
                                                <xsl:attribute name="currency">
                                                    <xsl:value-of select="$invoiceData/@currency"/>
                                                </xsl:attribute>
                                            </netAmt>
                                            <!-- other optional elements come here, but we will ignore and only focus on the amt that has been paid -->

                                        </adjudicatedInvoiceElementGroup>
                                    </reference>
                                </xsl:for-each>



                                <!-- coverage is mandatory for the Root Invoice Element Group and is not permitted for all other Invoice Element Groups. 
       						  For Pharmacy invoices, only supply policies for the Adjudicator that is the recipient of the Invoice.  Other policies that 
                              may be applied against an Invoice Grouping, that will not be adjudicatd by the Adjudicator, will not be included with the Invoice. 
                              In other words, you would not disclose policies for which the Adjudicator is not going to adjudicate against. 
                              However, we could see multiple coverage elements here for several different programs and we would have to pick the appropriate one.
                                -->
                                <xsl:for-each select="$invoiceData/request/coverage">
                                    <coverage typeCode="COVBY">
                                        <xsl:variable name="coverage-description" select="@description"/>
                                        <xsl:variable name="coverage" select="$BaseData/coverages/coverage[@description = $coverage-description]"/>
                                        <policyOrAccount classCode="COV" moodCode="EVN">
                                            <id>
                                                <xsl:call-template name="ID_Element">
                                                    <xsl:with-param name="Record" select="$coverage/record-id"/>
                                                    <xsl:with-param name="msgType" select="$msgType"/>
                                                </xsl:call-template>
                                            </id>
                                            <xsl:call-template name="PatientByDescription">
                                                <xsl:with-param name="description" select="$ProfileData/patient/@description"/>
                                                <xsl:with-param name="msgType" select="$msgType"/>
                                                <xsl:with-param name="format">necst_beneficiary</xsl:with-param>
                                                <xsl:with-param name="use_phn">true</xsl:with-param>
                                                <xsl:with-param name="use_name">true</xsl:with-param>
                                                <xsl:with-param name="use_gender">true</xsl:with-param>
                                                <xsl:with-param name="use_dob">true</xsl:with-param>
                                            </xsl:call-template>
                                            <author typeCode="AUT">
                                                <carrierRole classCode="UNDWRT">
                                                    <id>
                                                        <xsl:call-template name="ID_Element">
                                                            <xsl:with-param name="Record" select="$coverage/underwriter/record-id"/>
                                                            <xsl:with-param name="msgType" select="$msgType"/>
                                                        </xsl:call-template>
                                                    </id>
                                                </carrierRole>
                                            </author>
                                        </policyOrAccount>
                                    </coverage>
                                </xsl:for-each>

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
                                                <xsl:value-of select="$invoiceData/request/markupfee/@value + (($DrugCost * $DrugData/quantity/@value) div $DrugCostPer)"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="currency">
                                                <xsl:value-of select="$invoiceData/@currency"/>
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
                                                <code code="" codeSystem="">
                                                    <xsl:call-template name="codeSystem">
                                                        <xsl:with-param name="codeElement" select="$DrugData/code"/>
                                                        <xsl:with-param name="msgType" select="$msgType"/>
                                                    </xsl:call-template>
                                                </code>
                                                <!--  For the <DIN>/<GTIN>/<UPC> invoice element detail, specifiy as "x" over "y" with no units of measure, where "x" is the number of pills and "y" is the package size.  E.g. "10" over "100". -->
                                                <unitQuantity>
                                                    <numerator value="">
                                                        <xsl:attribute name="value">
                                                            <xsl:value-of select="$DrugData/quantity/@value"/>
                                                        </xsl:attribute>
                                                    </numerator>
                                                    <denominator value="">
                                                        <xsl:attribute name="value">
                                                            <xsl:value-of select="$DrugData/quantity/@value"/>
                                                        </xsl:attribute>
                                                    </denominator>
                                                </unitQuantity>
                                                <!-- For the <DIN>/<GTIN>/<UPC> invoice element detail, specifiy as "x" dollars over (per) "1" pill, with no units of measure.  E.g. "5.00" "CAD" over (per) "1". -->
                                                <unitPriceAmt>
                                                    <numerator value="10.00" currency="CAD">
                                                        <xsl:attribute name="value">
                                                            <xsl:value-of select="$DrugCost"/>
                                                        </xsl:attribute>
                                                        <xsl:attribute name="currency">
                                                            <xsl:value-of select="$invoiceData/@currency"/>
                                                        </xsl:attribute>
                                                    </numerator>
                                                    <denominator value="1">
                                                        <xsl:attribute name="value">
                                                            <xsl:value-of select="$DrugCostPer"/>
                                                        </xsl:attribute>
                                                    </denominator>
                                                </unitPriceAmt>
                                                <!-- drug cost -->
                                                <netAmt value="" currency="">
                                                    <xsl:attribute name="value">
                                                        <xsl:value-of select="(($DrugCost * $DrugData/quantity/@value) div $DrugCostPer)"/>
                                                    </xsl:attribute>
                                                    <xsl:attribute name="currency">
                                                        <xsl:value-of select="$invoiceData/@currency"/>
                                                    </xsl:attribute>
                                                </netAmt>
                                            </invoiceElementDetail>
                                        </component>
                                        <!-- detail component for the markup -->
                                        <xsl:if test="$invoiceData/request/markupfee">
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
                                                                <xsl:value-of select="$invoiceData/request/markupfee/@value"/>
                                                            </xsl:attribute>
                                                            <xsl:attribute name="currency">
                                                                <xsl:value-of select="$invoiceData/@currency"/>
                                                            </xsl:attribute>
                                                        </numerator>
                                                        <denominator value="1"/>
                                                    </unitPriceAmt>
                                                    <netAmt value="" currency="">
                                                        <xsl:attribute name="value">
                                                            <xsl:value-of select="$invoiceData/request/markupfee/@value"/>
                                                        </xsl:attribute>
                                                        <xsl:attribute name="currency">
                                                            <xsl:value-of select="$invoiceData/@currency"/>
                                                        </xsl:attribute>
                                                    </netAmt>
                                                </invoiceElementDetail>
                                            </component>
                                        </xsl:if>

                                        <reasonOf>
                                            <supplyEvent1 moodCode="RQO">
                                                <!-- Type of Dispense: first fill/partial fill/trial/completion of trial, etc. ActPharmacySupplyType -->
                                                <code code="">
                                                    <xsl:call-template name="codeSystem">
                                                        <xsl:with-param name="codeElement" select="$DispenseInfo/supplyEvent/code"/>
                                                        <xsl:with-param name="msgType" select="$msgType"/>
                                                    </xsl:call-template>
                                                </code>
                                                <!-- dispense time - must support hour/minute to handle multi-dispense/day of same product - e.g. methadone -->
                                                <effectiveTime>
                                                    <xsl:call-template name="effectiveTime">
                                                        <xsl:with-param name="effectiveTime" select="$DispenseInfo/supplyEvent/effectiveTime"/>
                                                        <xsl:with-param name="valueOnly">true</xsl:with-param>
                                                    </xsl:call-template>
                                                </effectiveTime>
                                                <!-- Quantity suppled. The quantity billed will generally default to the quantity supplied. 0 is not a valid value, as non-dispense events (e.g. prof services) 
                                                    should not include a supply (dispense) event. leave unit blank for pills -->
                                                <quantity>
                                                    <xsl:call-template name="valueAndUnit">
                                                        <xsl:with-param name="valueElement" select="$DispenseInfo/supplyEvent/quantity"/>
                                                    </xsl:call-template>
                                                </quantity>
                                                <!-- Dispensed Days Supply : see x_TimeUnitsOfMeasure for time units -->
                                                <expectedUseTime>
                                                    <xsl:call-template name="effectiveTime">
                                                        <xsl:with-param name="effectiveTime" select="$DispenseInfo/supplyEvent/expectedUseTime"/>
                                                    </xsl:call-template>
                                                </expectedUseTime>

                                                <product>
                                                    <manufacturedProduct>
                                                        <manufacturedMaterialKind>
                                                            <!-- OID needs to be identified for DIN coding system -->
                                                            <code code="">
                                                                <xsl:call-template name="codeSystem">
                                                                    <xsl:with-param name="codeElement" select="$DrugData/code"/>
                                                                    <xsl:with-param name="msgType" select="$msgType"/>
                                                                </xsl:call-template>
                                                            </code>
                                                        </manufacturedMaterialKind>
                                                    </manufacturedProduct>
                                                </product>
                                                <!-- identification of the pharmacist -->
                                                <performer typeCode="PRF">
                                                    <healthCareProvider classCode="PROV">
                                                        <!-- pharmacist id -->
                                                        <xsl:choose>
                                                            <xsl:when test="$author-description">
                                                                <xsl:call-template name="ProviderIDByDescription">
                                                                    <xsl:with-param name="description" select="$author-description"/>
                                                                    <xsl:with-param name="msgType" select="$msgType"/>
                                                                </xsl:call-template>
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <xsl:call-template name="ProviderIDByDescription">
                                                                    <xsl:with-param name="description" select="$DispenseData/author/@description"/>
                                                                    <xsl:with-param name="msgType" select="$msgType"/>
                                                                </xsl:call-template>
                                                            </xsl:otherwise>
                                                        </xsl:choose>
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
                                                        <xsl:if test="not($RxProfileData/@infered = 'true' and $invoiceData/@predetermin = 'true' )">
                                                            <id>
                                                                <xsl:call-template name="ID_Element">
                                                                    <xsl:with-param name="Record" select="$RxProfileData/record-id"/>
                                                                    <xsl:with-param name="msgType" select="$msgType"/>
                                                                    <xsl:with-param name="Default_OID">DIS_PRESCRIPTION_ID</xsl:with-param>
                                                                </xsl:call-template>
                                                            </id>
                                                        </xsl:if>
                                                        <!-- details of the original prescription for which the dispense is filling -->
                                                        <inFulfillmentOf typeCode="FLFS">
                                                            <substanceAdministrationOrder classCode="SBADM" moodCode="RQO">
                                                                <!-- identify the prescriber -->
                                                                <author typeCode="AUT">
                                                                    <prescriberRole classCode="ROL">
                                                                            <!-- prescriber id -->
                                                                            <xsl:choose>
                                                                                <xsl:when test="$prescriber-description">
                                                                                    <xsl:call-template name="ProviderIDByDescription">
                                                                                        <xsl:with-param name="description" select="$prescriber-description"/>
                                                                                        <xsl:with-param name="msgType" select="$msgType"/>
                                                                                    </xsl:call-template>
                                                                                </xsl:when>
                                                                                <xsl:otherwise>
                                                                                    <xsl:call-template name="ProviderIDByDescription">
                                                                                        <xsl:with-param name="description" select="$RxProfileData/author/@description"/>
                                                                                        <xsl:with-param name="msgType" select="$msgType"/>
                                                                                    </xsl:call-template>
                                                                                </xsl:otherwise>
                                                                            </xsl:choose>
                                                                        <playingPrescriberPerson>
                                                                            <name>
                                                                                <xsl:call-template name="nullFlavor"/>
                                                                            </name>
                                                                        </playingPrescriberPerson>
                                                                    </prescriberRole>
                                                                </author>
                                                                <reason typeCode="RSON">
                                                                    <supplyOrder classCode="SPLY" moodCode="RQO">
                                                                        <!-- date of the last allowed dispense -->
                                                                        <effectiveTime>
                                                                            <xsl:call-template name="nullFlavor"/>
                                                                            <!-- I guess this is how you would handle a request that has not been dispensed yet. -->
                                                                            <!-- <high value="20060101"/> -->
                                                                        </effectiveTime>
                                                                        <!-- total number of fills authorized on the prescription including the first standard fill : i.e. # refills + 1 -->
                                                                        <xsl:if test="$RxData/supplyRequestItem[1]/subsequentSupplyRequest[1]/repeatNumber[1]/@value">
                                                                            <repeatNumber>
                                                                                <center value="">
                                                                                    <xsl:attribute name="value">
                                                                                        <xsl:value-of select="$RxData/supplyRequestItem[1]/subsequentSupplyRequest[1]/repeatNumber[1]/@value"/>
                                                                                    </xsl:attribute>
                                                                                </center>
                                                                            </repeatNumber>
                                                                        </xsl:if>
                                                                    </supplyOrder>
                                                                </reason>
                                                                <!-- restrictions on substitution from the Ordering Provider perspective  -->
                                                                <xsl:if test="$RxData/substitutionPermission">
                                                                    <pertinentInformation typeCode="PERT">
                                                                        <substitution classCode="SUBST" moodCode="EVN">
                                                                            <!-- type of substitution: G generic, TE therapeutic, F formulary, N none - ActSubstanceAdminSubstitutionCode 
                                                                                The only thing that makes any sense here is N - i.e. for the doctor to say no subs allowed
                                                                            -->
                                                                            <code>
                                                                                <xsl:call-template name="codeSystem">
                                                                                    <xsl:with-param name="codeElement" select="$RxData/substitutionPermission/code"/>
                                                                                    <xsl:with-param name="msgType" select="$msgType"/>
                                                                                </xsl:call-template>
                                                                            </code>
                                                                            <reasonCode>
                                                                                <xsl:call-template name="codeSystem">
                                                                                    <xsl:with-param name="codeElement" select="$RxData/substitutionPermission/reasonCode"/>
                                                                                    <xsl:with-param name="msgType" select="$msgType"/>
                                                                                </xsl:call-template>
                                                                            </reasonCode>
                                                                        </substitution>
                                                                    </pertinentInformation>
                                                                </xsl:if>
                                                            </substanceAdministrationOrder>
                                                        </inFulfillmentOf>

                                                        <!-- optionally indicates any substitution that was actually done by the dispenser -->
                                                        <xsl:if test="$DispenseInfo/substitutionMade">
                                                            <pertinentInformation>
                                                                <substitution>
                                                                    <!-- type of substitution: G generic, TE therapeutic, F formulary, N none - ActSubstanceAdminSubstitutionCode  -->
                                                                    <code code="G">
                                                                        <xsl:if test="$DispenseInfo/substitutionMade/code">
                                                                            <xsl:call-template name="codeSystem">
                                                                                <xsl:with-param name="codeElement" select="$DispenseInfo/substitutionMade/code"/>
                                                                                <xsl:with-param name="msgType" select="$msgType"/>
                                                                            </xsl:call-template>
                                                                        </xsl:if>
                                                                    </code>
                                                                    <!-- reason why subs performed - OS out of stock  -->
                                                                    <reasonCode code="">
                                                                        <xsl:call-template name="codeSystem">
                                                                            <xsl:with-param name="codeElement" select="$DispenseInfo/substitutionMade/reasonCode"/>
                                                                            <xsl:with-param name="msgType" select="$msgType"/>
                                                                        </xsl:call-template>
                                                                    </reasonCode>
                                                                </substitution>
                                                            </pertinentInformation>
                                                        </xsl:if>

                                                        <!-- 0..* detected medication issues which the pharmacist is providing management for -->
                                                        <xsl:for-each select="$invoiceData/request/issue">
                                                            <subjectOf>
                                                                <detectedMedicationIssue>
                                                                    <!-- spec says use ActSuppliedItemAlertCode but this hasn't been defined, so we will use the CeRx ActDetectedIssueCode vocab: 
                                                                        A coded value that is used to distinguish between different kinds of issues GEND indicates Gender Alert-->
                                                                    <code code="GEND">
                                                                        <xsl:call-template name="codeSystem">
                                                                            <xsl:with-param name="codeElement" select="./code"/>
                                                                            <xsl:with-param name="msgType" select="$msgType"/>
                                                                        </xsl:call-template>
                                                                    </code>
                                                                    <!-- optional Alert detail code from FDB e.g. MT - Drug Gender Conflict -->
                                                                    <xsl:if test="./value">
                                                                        <value>
                                                                            <xsl:call-template name="codeSystem">
                                                                                <xsl:with-param name="codeElement" select="./value"/>
                                                                                <xsl:with-param name="msgType" select="$msgType"/>
                                                                            </xsl:call-template>
                                                                        </value>
                                                                    </xsl:if>

                                                                    <!-- 0..* management codes provided by the pharmacist -->
                                                                    <xsl:for-each select="./management">
                                                                        <mitigatedBy>
                                                                            <management>
                                                                                <!-- mgmt code: ActDetectedIssueManagementCode: i.e. 10 Provided Patient Education  -->
                                                                                <code code="10">
                                                                                    <xsl:call-template name="codeSystem">
                                                                                        <xsl:with-param name="codeElement" select="./code"/>
                                                                                        <xsl:with-param name="msgType" select="$msgType"/>
                                                                                    </xsl:call-template>
                                                                                </code>
                                                                            </management>
                                                                        </mitigatedBy>
                                                                    </xsl:for-each>

                                                                    <!-- 0..* elements to give the severity - have many for ability to send code in both English and French -->
                                                                    <subjectOf>
                                                                        <severityObservation>
                                                                            <!-- SeverityObservation vocab: H High , M Moderate , L Low  -->
                                                                            <code code="">
                                                                                <xsl:call-template name="codeSystem">
                                                                                    <xsl:with-param name="codeElement" select="./severity"/>
                                                                                    <xsl:with-param name="msgType" select="$msgType"/>
                                                                                </xsl:call-template>
                                                                            </code>
                                                                            <value>
                                                                                <xsl:call-template name="nullFlavor"/>
                                                                            </value>
                                                                        </severityObservation>
                                                                    </subjectOf>
                                                                </detectedMedicationIssue>
                                                            </subjectOf>
                                                        </xsl:for-each>
                                                    </substanceAdministrationIntent>
                                                </reasonOf>
                                            </supplyEvent1>
                                        </reasonOf>

                                    </invoiceElementGroup>
                                </component>

                                <!-- component to represent the professional fee -->
                                <xsl:if test="$invoiceData/request/professionalfee">
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
                                                        <xsl:value-of select="$invoiceData/request/professionalfee/@value"/>
                                                    </xsl:attribute>
                                                    <xsl:attribute name="currency">
                                                        <xsl:value-of select="$invoiceData/@currency"/>
                                                    </xsl:attribute>
                                                </numerator>
                                                <denominator value="1"/>
                                            </unitPriceAmt>
                                            <netAmt value="" currency="">
                                                <xsl:attribute name="value">
                                                    <xsl:value-of select="$invoiceData/request/professionalfee/@value"/>
                                                </xsl:attribute>
                                                <xsl:attribute name="currency">
                                                    <xsl:value-of select="$invoiceData/@currency"/>
                                                </xsl:attribute>
                                            </netAmt>
                                        </invoiceElementDetail>
                                    </component>
                                </xsl:if>
                                <!--0..* override codes that the pharmacist may have provided.  If an adjudicator does not support the override (e.g. repeated service), the override code 
						    should not be ignored.  In other words, the Invoice Grouping will likely be refused with a message "we don't support this type of override" -->
                                <xsl:for-each select="$invoiceData/override">
                                    <triggerFor>
                                        <invoiceElementOverride>
                                            <code code="">
                                                <xsl:call-template name="codeSystem">
                                                    <xsl:with-param name="codeElement" select="."/>
                                                    <xsl:with-param name="msgType" select="$msgType"/>
                                                </xsl:call-template>
                                            </code>
                                        </invoiceElementOverride>
                                    </triggerFor>
                                </xsl:for-each>

                            </invoiceElementGroup>
                        </reasonOf>
                    </paymentRequest>
                </subject>

            </controlActProcess>

        </FICR_IN600102>
    </xsl:template>

    <xsl:template name="invoiceAcceptedResponse">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>
        <xsl:param name="invoice-description"/>

        <xsl:variable name="msgType">serverMsg</xsl:variable>
        <xsl:variable name="msgAction">addResponse</xsl:variable>

        <xsl:variable name="patient_description">
            <xsl:call-template name="getPatientNameByID">
                <xsl:with-param name="node" select="descendant-or-self::hl7:coveredPartyAsPatient/hl7:id"/>
            </xsl:call-template>
        </xsl:variable>

        <!-- <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][patient/@description = $patient_description]"/> -->
        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][patient/@description = $patient_description]"/>

        <xsl:variable name="description">
            <xsl:choose>
                <xsl:when test="$invoice-description and not($invoice-description = '')">
                    <xsl:value-of select="$invoice-description"/>
                </xsl:when>
                <xsl:otherwise>Invoice(NEW_ITEM)</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>


        <xsl:variable name="invoiceData" select="$ProfileData/descendant::items/invoice[@description=$description]"/>

        <xsl:variable name="Dispense-description" select="$invoiceData/dispense/@description"/>
        <xsl:variable name="DispenseData" select="$ProfileData/items/dispense[@description=$Dispense-description]"/>
        <xsl:variable name="DispenseInfo" select="$BaseData/dispenses/dispense[@description=$Dispense-description]"/>
        <xsl:variable name="Rx-description" select="$DispenseData/prescription/@description"/>
        <xsl:variable name="RxData" select="$BaseData/prescriptions/prescription[@description=$Rx-description]"/>
        <xsl:variable name="RxProfileData" select="$ProfileData/items/prescription[@description=$Rx-description]"/>
        <xsl:variable name="Drug-description" select="$RxData/drug/@description"/>

        <xsl:variable name="Drug-codeSystem">
            <xsl:call-template name="getOIDNameByRoot">
                <xsl:with-param name="OID_Value" select="descendant-or-self::hl7:invoiceElementDetail/hl7:code[@codeSystem][1]/@codeSystem"/>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="Drug-ext" select="descendant-or-self::hl7:invoiceElementDetail/hl7:code[@codeSystem][1]/@code"/>

        <!--<xsl:variable name="DrugData" select="$BaseData/drugs/drug[@description=$Drug-description]"/>-->
        <xsl:variable name="DrugData" select="$BaseData/drugs/drug[code/@code = $Drug-ext][code/@codeSystem = $Drug-codeSystem][cost]"/>

        <xsl:variable name="DrugCostPayment" select="$DrugData/cost/coverage[@description=$invoiceData/payment/coverage/@description]"/>

        <xsl:variable name="DrugCost">
            <xsl:choose>
                <xsl:when test="$DrugCostPayment/cost/@value">
                    <xsl:value-of select="$DrugCostPayment/cost/@value"/>
                </xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="DrugQuantity">
            <xsl:choose>
                <xsl:when test="$DrugData/quantity/@value">
                    <xsl:value-of select="$DrugData/quantity/@value"/>
                </xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="DrugCostPer">
            <xsl:choose>
                <xsl:when test="$DrugCostPayment/cost/@per">
                    <xsl:value-of select="$DrugCostPayment/cost/@per"/>
                </xsl:when>
                <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <!-- total requested amt for invoice -->
        <xsl:variable name="totalValue" select="$invoiceData/payment/professionalfee/@value + $invoiceData/payment/markupfee/@value + (($DrugCost * $DrugQuantity) div $DrugCostPer)"/>
        <xsl:variable name="coverageInfo" select="$BaseData/coverages/coverage[@description = $invoiceData/payment/coverage/@description]"/>
        <xsl:variable name="InvoiceElement_root">
            <xsl:call-template name="getOIDRootByName">
                <xsl:with-param name="OID_Name">DIS_ADJUDICATED_INVOICE_GROUP_ID</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="InvoiceElement_extension">
            <xsl:choose>
                <xsl:when test="$DispenseData/record-id">
                    <xsl:call-template name="record-id">
                        <xsl:with-param name="Record" select="$DispenseData/record-id"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$OID"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <FICR_IN610102 xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">FICR_IN610102</xsl:with-param>
                <xsl:with-param name="msgType">serverMsg</xsl:with-param>
            </xsl:call-template>

            <!--
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">FICR_IN610102</xsl:with-param>
                <xsl:with-param name="msgType">NECSTserverMsg</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="transmissionWrapperEnd">
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <acknowledgement>
                <typeCode code="AA"/>
                <targetMessage>
                    <xsl:choose>
                        <xsl:when test="$lastServerRequest/descendant-or-self::hl7:*[1]/child::node()[local-name() = 'id']">
                            <xsl:copy-of select="$lastServerRequest/descendant-or-self::hl7:*[1]/child::node()[local-name() = 'id']"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="nullFlavor"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </targetMessage>
            </acknowledgement>
-->

            <controlActProcess moodCode="PRMS">
                <!-- DIS control act event id -->
                <id root="" extension="">
                    <xsl:attribute name="root">
                        <xsl:call-template name="getOIDRootByName">
                            <xsl:with-param name="OID_Name">DIS_CONTROL_ACT_ID</xsl:with-param>
                            <xsl:with-param name="msgType" select="$msgType"/>
                        </xsl:call-template>
                    </xsl:attribute>
                    <xsl:attribute name="extension">
                        <xsl:value-of select="$OID"/>
                    </xsl:attribute>
                </id>
                <!-- HL7TriggerEventCode - Identifies the trigger event that occurred -->
                <code code="FICR_TE610101UV01"/>
                <!-- time DIS has adjudicated the invoice -->
                <effectiveTime value="">
                    <xsl:attribute name="value">
                        <xsl:call-template name="getBaseDateTime"/>
                    </xsl:attribute>
                </effectiveTime>

                <!-- payload -->
                <subject>
                    <paymentIntent moodCode="PRMS">
                        <!-- Time payor intends to make payment: i.e. PYMNT_DTE from claim_key. -->
                        <effectiveTime>
                            <xsl:call-template name="effectiveTime">
                                <xsl:with-param name="effectiveTime" select="$invoiceData/payment/paymentTime"/>
                            </xsl:call-template>
                        </effectiveTime>
                        <!-- Total Amount of Payment Intent -->
                        <amt value="" currency="">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$totalValue"/>
                            </xsl:attribute>
                            <xsl:attribute name="currency">
                                <xsl:value-of select="$invoiceData/@currency"/>
                            </xsl:attribute>
                        </amt>
                        <!-- The organization or individual designated to receive payment for a claim against a particular policy. 
				      A pay provider invoice - this is all we support as pay person claims are manual and would continue to be done through CPHA for now -->
                        <credit>
                            <account>
                                <holder>
                                    <payeeRole classCode="PROV">
                                        <!-- pay provider identifier - i.e. the pharmacy -->
                                        <id root="" extension="">
                                            <xsl:choose>
                                                <xsl:when test="$BaseData/providers/provider/@description = $invoiceData/payee/@description">
                                                    <xsl:variable name="provider" select="$BaseData/providers/provider[@description = $invoiceData/payee/@description]"/>
                                                    <xsl:choose>
                                                        <xsl:when test="$msgType = 'clientMsg'">
                                                            <xsl:attribute name="root">
                                                                <xsl:value-of select="$provider/client/id/@root"/>
                                                            </xsl:attribute>
                                                            <xsl:attribute name="extension">
                                                                <xsl:value-of select="$provider/client/id/@extension"/>
                                                            </xsl:attribute>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:attribute name="root">
                                                                <xsl:value-of select="$provider/server/id/@root"/>
                                                            </xsl:attribute>
                                                            <xsl:attribute name="extension">
                                                                <xsl:value-of select="$provider/server/id/@extension"/>
                                                            </xsl:attribute>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:when>
                                                <xsl:when test="$BaseData/serviceDeliveryLocations/location/@description = $invoiceData/payee/@description">
                                                    <xsl:variable name="location" select="$BaseData/serviceDeliveryLocations/location[@description = $invoiceData/payee/@description]"/>
                                                    <xsl:choose>
                                                        <xsl:when test="$msgType = 'clientMsg'">
                                                            <xsl:attribute name="root">
                                                                <xsl:value-of select="$location/client/id/@root"/>
                                                            </xsl:attribute>
                                                            <xsl:attribute name="extension">
                                                                <xsl:value-of select="$location/client/id/@extension"/>
                                                            </xsl:attribute>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:attribute name="root">
                                                                <xsl:value-of select="$location/server/id/@root"/>
                                                            </xsl:attribute>
                                                            <xsl:attribute name="extension">
                                                                <xsl:value-of select="$location/server/id/@extension"/>
                                                            </xsl:attribute>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:when>
                                            </xsl:choose>
                                        </id>
                                    </payeeRole>
                                </holder>
                            </account>
                        </credit>
                        <!-- Definition of the Payor is the organization that is "responsible" (generally the name on the cheque) for payment, not the one that cuts the cheque. -->
                        <debit>
                            <account>
                                <code code="CHEQUE"/>
                                <holder>
                                    <payorRole>
                                        <!-- identifier for the Dept of Health Program responsible for paying the claim -->
                                        <id>
                                            <xsl:call-template name="ID_Element">
                                                <xsl:with-param name="Record" select="$coverageInfo/record-id"/>
                                                <xsl:with-param name="msgType" select="$msgType"/>
                                            </xsl:call-template>
                                        </id>
                                    </payorRole>
                                </holder>
                            </account>
                        </debit>

                        <!-- payment results -->
                        <reasonOf>
                            <adjudicatedInvoiceElementGroup>
                                <!--  Adjudication Result Identifier: this is going to be the claim key identifier with an OID to represent adjudication result ids   -->
                                <id>
                                    <xsl:attribute name="root">
                                        <xsl:value-of select="$InvoiceElement_root"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="extension">
                                        <xsl:value-of select="$InvoiceElement_extension"/>
                                    </xsl:attribute>
                                </id>

                                <!-- Invoice Type  - either RXDINV - drug invoice or  RXCINV for compound invoice -->
                                <code code="RXDINV"/>
                                <!-- must be completed for real time adjudication results -->
                                <statusCode code="completed"/>
                                <!-- Paid Amount -->
                                <netAmt value="" currency="">
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="$totalValue"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="currency">
                                        <xsl:value-of select="$invoiceData/@currency"/>
                                    </xsl:attribute>
                                </netAmt>
                                <!-- Adjudicator Information: Mandatory for Root AdjudicatedInvoiceElementGroup, otherwise not specified at other levels. -->
                                <author>
                                    <!-- adjudication time of the claim: claim_pharmacy DATE_PROCESSED field -->
                                    <time value="">
                                        <xsl:attribute name="value">
                                            <xsl:call-template name="getBaseDateTime"/>
                                        </xsl:attribute>
                                    </time>
                                    <adjudicatorRole>
                                        <!--  identifier that uniquely identifies the adjudicator of the invoice - PEI Dept of HEALTH -->
                                        <id root="2.16.124.9.101.1">
                                            <xsl:attribute name="root">
                                                <xsl:call-template name="getOIDRootByName">
                                                    <xsl:with-param name="OID_Name">DEPT_HEALTH</xsl:with-param>
                                                    <xsl:with-param name="msgType" select="$msgType"/>
                                                </xsl:call-template>
                                            </xsl:attribute>
                                        </id>
                                        <directAuthority>
                                            <insuranceCarrierRole>
                                                <!-- don't know what the OID should be for carrier's ....we'll just send extension for now -->
                                                <id>
                                                    <xsl:call-template name="ID_Element">
                                                        <xsl:with-param name="Record" select="$coverageInfo/underwriter/record-id"/>
                                                        <xsl:with-param name="msgType" select="$msgType"/>
                                                    </xsl:call-template>
                                                </id>
                                            </insuranceCarrierRole>
                                        </directAuthority>
                                    </adjudicatorRole>
                                </author>

                                <!-- any EOB from upstream payors in the request echoed back in the response at the root adjudicated invoice group level: note that we don't expect this in PEI
							  as we are payor of first choice.
						-->
                                <xsl:for-each select="$invoiceData/request/upstreampayor">
                                    <reference>
                                        <adjudicatedInvoiceElementGroup>
                                            <!-- Invoice Type: should always be Rx Dispense, Rx Compound  -->
                                            <code code="RXDINV"/>
                                            <!-- real time adjudicated invoices should have status of completed -->
                                            <statusCode code="completed"/>
                                            <!-- amt upstream payor agrees to pay -->
                                            <netAmt value="" currency="">
                                                <xsl:attribute name="value">
                                                    <xsl:value-of select="@value"/>
                                                </xsl:attribute>
                                                <xsl:attribute name="currency">
                                                    <xsl:value-of select="$invoiceData/@currency"/>
                                                </xsl:attribute>
                                            </netAmt>
                                        </adjudicatedInvoiceElementGroup>
                                    </reference>
                                </xsl:for-each>
                                <!-- even if multiple coverage elements specified in the request, we will only specify single coverage element in the response to 
                              represent program that we decide is paying for the claim -->
                                <coverage>
                                    <sequenceNumber value="1"/>
                                    <policyOrAccount classCode="COV" moodCode="EVN">
                                        <id>
                                            <xsl:call-template name="ID_Element">
                                                <xsl:with-param name="Record" select="$coverageInfo/record-id"/>
                                                <xsl:with-param name="msgType" select="$msgType"/>
                                            </xsl:call-template>
                                        </id>
                                        <code/>
                                        <xsl:call-template name="PatientByDescription">
                                            <xsl:with-param name="description" select="$ProfileData/patient/@description"/>
                                            <xsl:with-param name="msgType" select="$msgType"/>
                                            <xsl:with-param name="format">necst_beneficiary_response</xsl:with-param>
                                            <xsl:with-param name="use_phn">true</xsl:with-param>
                                            <xsl:with-param name="use_name">true</xsl:with-param>
                                            <xsl:with-param name="use_gender">true</xsl:with-param>
                                            <xsl:with-param name="use_dob">true</xsl:with-param>
                                        </xsl:call-template>
                                        <author typeCode="AUT">
                                            <carrierRole classCode="UNDWRT">
                                                <id>
                                                    <xsl:call-template name="ID_Element">
                                                        <xsl:with-param name="Record" select="$coverageInfo/underwriter/record-id"/>
                                                        <xsl:with-param name="msgType" select="$msgType"/>
                                                    </xsl:call-template>
                                                </id>
                                            </carrierRole>
                                        </author>
                                    </policyOrAccount>
                                </coverage>

                                <!-- component containing a group that holds adjudication details for the drug and markup  -->
                                <component>
                                    <adjudicatedInvoiceElementGroup>
                                        <!--  Adjudication Result Identifier : this is the first occurence of a sub group, so we append .1 to the extension as per the rules of the standard -->
                                        <id>
                                            <xsl:attribute name="root">
                                                <xsl:value-of select="$InvoiceElement_root"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="extension"><xsl:value-of select="$InvoiceElement_extension"/>.1</xsl:attribute>
                                        </id>

                                        <!-- at this level - we use DRUGING for the grouping that holds the drug and markup -->
                                        <code code="DRUGING"/>
                                        <!-- real time adjudicated invoices should have status of completed -->
                                        <statusCode code="completed"/>
                                        <!-- total that we have agreed to pay for the drug plus markup -->
                                        <netAmt value="" currency="">
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="$invoiceData/payment/markupfee/@value + (($DrugCost * $DrugData/quantity/@value) div $DrugCostPer)"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="currency">
                                                <xsl:value-of select="$invoiceData/@currency"/>
                                            </xsl:attribute>
                                        </netAmt>
                                        <!-- adjudicated detail element for the drug -->
                                        <component>
                                            <!-- adjudiction results for drug cost  -->
                                            <!-- moved in schema
                                            <outcomeOf>
                                                <xsl:call-template name="adjudicationResult">
                                                    <xsl:with-param name="DrugCostPayment" select="$DrugCostPayment"/>
                                                    <xsl:with-param name="msgType" select="$msgType"/>
                                                </xsl:call-template>
                                            </outcomeOf>
                                            -->
                                            <adjudicatedInvoiceElementDetail>
                                                <!--  Adjudication Result Identifier : this is the first occurence of a detail element within this sub group, so we append .1 to the extension as per the rules of the standard -->
                                                <id>
                                                    <xsl:attribute name="root">
                                                        <xsl:value-of select="$InvoiceElement_root"/>
                                                    </xsl:attribute>
                                                    <xsl:attribute name="extension"><xsl:value-of select="$InvoiceElement_extension"/>.1.1</xsl:attribute>
                                                </id>
                                                <!-- identification of the drug -->
                                                <code>
                                                    <xsl:call-template name="codeSystem">
                                                        <xsl:with-param name="codeElement" select="$DrugData/code"/>
                                                        <xsl:with-param name="msgType" select="$msgType"/>
                                                    </xsl:call-template>
                                                </code>

                                                <unitQuantity>
                                                    <numerator value="">
                                                        <xsl:attribute name="value">
                                                            <xsl:value-of select="$DrugData/quantity/@value"/>
                                                        </xsl:attribute>
                                                    </numerator>
                                                    <denominator value="">
                                                        <xsl:attribute name="value">
                                                            <xsl:value-of select="$DrugData/quantity/@value"/>
                                                        </xsl:attribute>
                                                    </denominator>
                                                </unitQuantity>
                                                <!-- For the <DIN>/<GTIN>/<UPC> invoice element detail, specifiy as "x" dollars over (per) "1" pill, with no units of measure.  E.g. "5.00" "CAD" over (per) "1". -->
                                                <unitPriceAmt>
                                                    <numerator value="" currency="">
                                                        <xsl:attribute name="value">
                                                            <xsl:value-of select="$DrugCost"/>
                                                        </xsl:attribute>
                                                        <xsl:attribute name="currency">
                                                            <xsl:value-of select="$invoiceData/@currency"/>
                                                        </xsl:attribute>
                                                    </numerator>
                                                    <denominator value="1">
                                                        <xsl:attribute name="value">
                                                            <xsl:value-of select="$DrugCostPer"/>
                                                        </xsl:attribute>
                                                    </denominator>
                                                </unitPriceAmt>
                                                <!-- drug cost -->
                                                <netAmt value="" currency="">
                                                    <xsl:attribute name="value">
                                                        <xsl:value-of select="(($DrugCost * $DrugData/quantity/@value) div $DrugCostPer)"/>
                                                    </xsl:attribute>
                                                    <xsl:attribute name="currency">
                                                        <xsl:value-of select="$invoiceData/@currency"/>
                                                    </xsl:attribute>
                                                </netAmt>
                                                <outcomeOf>
                                                    <xsl:call-template name="adjudicationResult">
                                                        <xsl:with-param name="DrugCostPayment" select="$DrugCostPayment"/>
                                                        <xsl:with-param name="msgType" select="$msgType"/>
                                                    </xsl:call-template>
                                                </outcomeOf>
                                            </adjudicatedInvoiceElementDetail>
                                        </component>

                                        <!-- adjudicated detail element for the markup -->
                                        <component>
                                            <!-- adjudication result for markup -->
                                            <!--  moved in schema
                                            <outcomeOf>
                                                <xsl:call-template name="adjudicationResult">
                                                    <xsl:with-param name="DrugCostPayment" select="$invoiceData/payment/markupfee"/>
                                                    <xsl:with-param name="msgType" select="$msgType"/>
                                                </xsl:call-template>
                                            </outcomeOf>
                                            -->
                                            <xsl:call-template name="adjudicatedInvoiceElementDetail">
                                                <xsl:with-param name="root_value" select="$InvoiceElement_root"/>
                                                <xsl:with-param name="extension_value"><xsl:value-of select="$InvoiceElement_extension"/>.1.2</xsl:with-param>
                                                <xsl:with-param name="adjudicationCode">MARKUP</xsl:with-param>
                                                <xsl:with-param name="currency" select="$invoiceData/@currency"/>
                                                <xsl:with-param name="unitPriceAmt" select="$invoiceData/payment/markupfee/@value"/>
                                                <xsl:with-param name="units">1</xsl:with-param>
                                                <xsl:with-param name="quantity">1</xsl:with-param>
                                                <xsl:with-param name="outcomeNode" select="$invoiceData/payment/markupfee"/>
                                                <xsl:with-param name="msgType" select="$msgType"/>
                                            </xsl:call-template>
                                        </component>
                                    </adjudicatedInvoiceElementGroup>
                                </component>

                                <!-- adjudicated detail element for the prof fee -->
                                <component>
                                    <!-- adjudication result for prof fee -->
                                    <!-- moved in schemas
                                    <outcomeOf>
                                        <xsl:call-template name="adjudicationResult">
                                            <xsl:with-param name="DrugCostPayment" select="$invoiceData/payment/professionalfee"/>
                                            <xsl:with-param name="msgType" select="$msgType"/>
                                        </xsl:call-template>
                                    </outcomeOf>
                                    -->
                                    <xsl:call-template name="adjudicatedInvoiceElementDetail">
                                        <xsl:with-param name="root_value" select="$InvoiceElement_root"/>
                                        <xsl:with-param name="extension_value"><xsl:value-of select="$InvoiceElement_extension"/>.2</xsl:with-param>
                                        <xsl:with-param name="adjudicationCode">PROFFEE</xsl:with-param>
                                        <xsl:with-param name="currency" select="$invoiceData/@currency"/>
                                        <xsl:with-param name="unitPriceAmt" select="$invoiceData/payment/professionalfee/@value"/>
                                        <xsl:with-param name="units">1</xsl:with-param>
                                        <xsl:with-param name="quantity">1</xsl:with-param>
                                        <xsl:with-param name="outcomeNode" select="$invoiceData/payment/professionalfee"/>
                                        <xsl:with-param name="msgType" select="$msgType"/>
                                    </xsl:call-template>
                                </component>

                                <!-- adjudicated detail element for the co-insurance - the covered party pays a percentage of the cost of covered services - this is the amount to collect from patient  -->
                                <component>
                                    <xsl:call-template name="adjudicatedInvoiceElementDetail">
                                        <xsl:with-param name="root_value" select="$InvoiceElement_root"/>
                                        <xsl:with-param name="extension_value"><xsl:value-of select="$InvoiceElement_extension"/>.3</xsl:with-param>
                                        <xsl:with-param name="adjudicationCode">COINS</xsl:with-param>
                                        <xsl:with-param name="currency" select="$invoiceData/@currency"/>
                                        <xsl:with-param name="unitPriceAmt" select="$invoiceData/payment/patientcost/@value"/>
                                        <xsl:with-param name="units">1</xsl:with-param>
                                        <xsl:with-param name="quantity">1</xsl:with-param>
                                    </xsl:call-template>
                                </component>

                                <!-- adjudicated detail element for the patient co-pay - that portion of the eligible charges which a covered party must pay for each service and/or product.
                               It is either a defined amount per service/product or percentage of the eligibile amount for the service/product. This amount represents the covered party's 
                               copayment that is applied to a particular adjudication result. It is expressed as a negative dollar amount in adjudication results. 
                              In this scenario, where we reduced the drug cost - we'll provide a value for the copayment 
                        -->
                                <component>
                                    <xsl:call-template name="adjudicatedInvoiceElementDetail">
                                        <xsl:with-param name="root_value" select="$InvoiceElement_root"/>
                                        <xsl:with-param name="extension_value"><xsl:value-of select="$InvoiceElement_extension"/>.4</xsl:with-param>
                                        <xsl:with-param name="adjudicationCode">COPAYMENT</xsl:with-param>
                                        <xsl:with-param name="currency" select="$invoiceData/@currency"/>
                                        <xsl:with-param name="unitPriceAmt" select="$invoiceData/payment/copayment/@value"/>
                                        <xsl:with-param name="units">1</xsl:with-param>
                                        <xsl:with-param name="quantity">1</xsl:with-param>
                                    </xsl:call-template>
                                </component>

                                <!-- adjudicated detail element for the deductible  - That portion of the eligible charges which a covered party must pay in a particular period 
                              (e.g. annual) before the benefits are payable by the adjudicator
                        -->
                                <component>
                                    <xsl:call-template name="adjudicatedInvoiceElementDetail">
                                        <xsl:with-param name="root_value" select="$InvoiceElement_root"/>
                                        <xsl:with-param name="extension_value"><xsl:value-of select="$InvoiceElement_extension"/>.5</xsl:with-param>
                                        <xsl:with-param name="adjudicationCode">DEDUCTIBLE</xsl:with-param>
                                        <xsl:with-param name="currency" select="$invoiceData/@currency"/>
                                        <xsl:with-param name="unitPriceAmt" select="$invoiceData/payment/deductible/@value"/>
                                        <xsl:with-param name="units">1</xsl:with-param>
                                        <xsl:with-param name="quantity">1</xsl:with-param>
                                    </xsl:call-template>
                                </component>

                            </adjudicatedInvoiceElementGroup>
                        </reasonOf>
                    </paymentIntent>
                </subject>
            </controlActProcess>
        </FICR_IN610102>
    </xsl:template>


    <xsl:template name="invoiceReversalRequest">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>

        <xsl:param name="invoice-description"/>

        <xsl:variable name="msgType">clientMsg</xsl:variable>
        <xsl:variable name="msgAction">updateRequest</xsl:variable>

        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][not($patient-description) or patient/@description = $patient-description]"/>

        <xsl:variable name="description">
            <xsl:choose>
                <xsl:when test="$invoice-description and not($invoice-description = '')">
                    <xsl:value-of select="$invoice-description"/>
                </xsl:when>
                <xsl:otherwise>Invoice(NEW_ITEM)</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="invoiceData" select="$ProfileData/descendant::items/invoice[@description=$description]"/>


        <xsl:variable name="Dispense-description" select="$invoiceData/dispense/@description"/>
        <xsl:variable name="DispenseData" select="$ProfileData/items/dispense[@description=$Dispense-description]"/>
        <!-- <xsl:variable name="DispenseInfo" select="$BaseData/dispenses/dispense[@description=$Dispense-description]"/> -->
        <xsl:variable name="Rx-description" select="$DispenseData/prescription/@description"/>
        <xsl:variable name="RxData" select="$BaseData/prescriptions/prescription[@description=$Rx-description]"/>
        <!-- <xsl:variable name="RxProfileData" select="$ProfileData/items/prescription[@description=$Rx-description]"/> -->
        <xsl:variable name="Drug-description">
            <xsl:choose>
                <xsl:when test="$invoiceData/dispense/@description">
                    <xsl:value-of select="$RxData/drug/@description"/>
                </xsl:when>
                <xsl:when test="$invoiceData/drug/@description">
                    <xsl:value-of select="$invoiceData/drug/@description"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="DrugData" select="$BaseData/drugs/drug[@description=$Drug-description]"/>
        <xsl:variable name="DrugCostPayment" select="$DrugData/cost/coverage[@description=$invoiceData/payment/coverage/@description]"/>

        <xsl:variable name="DrugCost">
            <xsl:choose>
                <xsl:when test="$DrugCostPayment/cost/@value">
                    <xsl:value-of select="$DrugCostPayment/cost/@value"/>
                </xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="DrugQuantity">
            <xsl:choose>
                <xsl:when test="$DrugData/quantity/@value">
                    <xsl:value-of select="$DrugData/quantity/@value"/>
                </xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="DrugCostPer">
            <xsl:choose>
                <xsl:when test="$DrugCostPayment/cost/@per">
                    <xsl:value-of select="$DrugCostPayment/cost/@per"/>
                </xsl:when>
                <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <!-- total requested amt for invoice -->
        <xsl:variable name="totalValue" select="$invoiceData/payment/professionalfee/@value + $invoiceData/payment/markupfee/@value + (($DrugCost * $DrugQuantity) div $DrugCostPer)"/>


        <FICR_IN620102 xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">FICR_IN620102</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
            <xsl:call-template name="transmissionWrapperEnd">
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <controlActProcess moodCode="RQO">
                <subject contextConductionInd="false" typeCode="SUBJ">
                    <invoiceElementGroup>
                        <id>
                            <xsl:attribute name="root">
                                <xsl:call-template name="getOIDRootByName">
                                    <xsl:with-param name="OID_Name">DIS_ADJUDICATED_INVOICE_GROUP_ID</xsl:with-param>
                                    <xsl:with-param name="msgType" select="$msgType"/>
                                </xsl:call-template>
                            </xsl:attribute>
                            <xsl:attribute name="extension">
                                <xsl:choose>
                                    <xsl:when test="$DispenseData/record-id">
                                        <xsl:call-template name="record-id">
                                            <xsl:with-param name="Record" select="$DispenseData/record-id"/>
                                            <xsl:with-param name="msgType" select="$msgType"/>
                                        </xsl:call-template>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$OID"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                        </id>
                        <code code="RXDINV"/>
                        <netAmt value="" currency="">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$totalValue"/>
                            </xsl:attribute>
                            <xsl:attribute name="currency">
                                <xsl:value-of select="$invoiceData/@currency"/>
                            </xsl:attribute>
                        </netAmt>
                    </invoiceElementGroup>
                </subject>
            </controlActProcess>
        </FICR_IN620102>
    </xsl:template>

    <xsl:template name="invoiceReversalResponse">
        <xsl:param name="profile-description"/>
        <xsl:param name="profile-sequence"/>
        <xsl:param name="patient-description"/>
        <xsl:param name="msg-effective-time"/>
        <xsl:param name="invoice-description"/>


        <xsl:variable name="msgType">serverMsg</xsl:variable>
        <xsl:variable name="msgAction">updateResponse</xsl:variable>

        <xsl:variable name="patient_description">
            <xsl:call-template name="getPatientNameByID">
                <xsl:with-param name="node" select="descendant-or-self::hl7:coveredPartyAsPatient/hl7:id"/>
            </xsl:call-template>
        </xsl:variable>

         <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence][patient/@description = $patient_description]"/> 
<!--        <xsl:variable name="ProfileData" select="$BaseData/medicalProfiles/medicalProfile[@description=$profile-description][@sequence=$profile-sequence]"/>-->

        <xsl:variable name="description">
            <xsl:choose>
                <xsl:when test="$invoice-description and not($invoice-description = '')">
                    <xsl:value-of select="$invoice-description"/>
                </xsl:when>
                <xsl:otherwise>Invoice(<xsl:value-of select="descendant-or-self::hl7:subject/hl7:invoiceElementGroup/hl7:id/@extension"/>)</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="invoiceData" select="$ProfileData/descendant::items/invoice[@description=$description]"/>


        <xsl:variable name="Dispense-description" select="$invoiceData/dispense/@description"/>
        <xsl:variable name="DispenseData" select="$ProfileData/items/dispense[@description=$Dispense-description]"/>
        <!-- <xsl:variable name="DispenseInfo" select="$BaseData/dispenses/dispense[@description=$Dispense-description]"/> -->
        <xsl:variable name="Rx-description" select="$DispenseData/prescription/@description"/>
        <xsl:variable name="RxData" select="$BaseData/prescriptions/prescription[@description=$Rx-description]"/>
        <!-- <xsl:variable name="RxProfileData" select="$ProfileData/items/prescription[@description=$Rx-description]"/> -->
        <!--<xsl:variable name="Drug-description" select="$RxData/drug/@description"/>-->
        <xsl:variable name="Drug-description">
            <xsl:choose>
                <xsl:when test="$invoiceData/dispense/@description">
                    <xsl:value-of select="$RxData/drug/@description"/>
                </xsl:when>
                <xsl:when test="$invoiceData/drug/@description">
                    <xsl:value-of select="$invoiceData/drug/@description"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="DrugData" select="$BaseData/drugs/drug[@description=$Drug-description]"/>
        <xsl:variable name="DrugCostPayment" select="$DrugData/cost/coverage[@description=$invoiceData/payment/coverage/@description]"/>

        <xsl:variable name="coverageInfo" select="$BaseData/coverages/coverage[@description = $invoiceData/payment/coverage/@description]"/>

        <xsl:variable name="DrugCost">
            <xsl:choose>
                <xsl:when test="$DrugCostPayment/cost/@value">
                    <xsl:value-of select="$DrugCostPayment/cost/@value"/>
                </xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="DrugQuantity">
            <xsl:choose>
                <xsl:when test="$DrugData/quantity/@value">
                    <xsl:value-of select="$DrugData/quantity/@value"/>
                </xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="DrugCostPer">
            <xsl:choose>
                <xsl:when test="$DrugCostPayment/cost/@per">
                    <xsl:value-of select="$DrugCostPayment/cost/@per"/>
                </xsl:when>
                <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <!-- total requested amt for invoice -->
        <xsl:variable name="totalValue" select="$invoiceData/payment/professionalfee/@value + $invoiceData/payment/markupfee/@value + (($DrugCost * $DrugQuantity) div $DrugCostPer)"/>


        <FICR_IN630102 xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">FICR_IN630102</xsl:with-param>
                <xsl:with-param name="msgType">serverMsg</xsl:with-param>
            </xsl:call-template>
            <!-- 
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">FICR_IN630102</xsl:with-param>
                <xsl:with-param name="msgType">NECSTserverMsg</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="transmissionWrapperEnd">
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <acknowledgement>
                <typeCode code="AA"/>
                <targetMessage>
                    <xsl:choose>
                        <xsl:when test="$lastServerRequest/descendant-or-self::hl7:*[1]/child::node()[local-name() = 'id']">
                            <xsl:copy-of select="$lastServerRequest/descendant-or-self::hl7:*[1]/child::node()[local-name() = 'id']"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="nullFlavor"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </targetMessage>
            </acknowledgement>
            -->

            <controlActProcess classCode="CACT" moodCode="PRMS">
                <subject contextConductionInd="false" typeCode="SUBJ">
                    <invoiceElementGroup classCode="INVE" moodCode="RQO">
                        <statusCode code="nullified"/>
                        <netAmt value="" currency="">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$totalValue"/>
                            </xsl:attribute>
                            <xsl:attribute name="currency">
                                <xsl:value-of select="$invoiceData/@currency"/>
                            </xsl:attribute>
                        </netAmt>
                        <reference>
                            <adjudicatedInvoiceElementGroup classCode="INVE" moodCode="EVN">
                                <id>
                                    <xsl:attribute name="root">
                                        <xsl:call-template name="getOIDRootByName">
                                            <xsl:with-param name="OID_Name">DIS_ADJUDICATED_INVOICE_GROUP_ID</xsl:with-param>
                                            <xsl:with-param name="msgType" select="$msgType"/>
                                        </xsl:call-template>
                                    </xsl:attribute>
                                    <xsl:attribute name="extension">
                                        <xsl:value-of select="descendant-or-self::hl7:subject/hl7:invoiceElementGroup/hl7:id/@extension"/>
                                    </xsl:attribute>
                                </id>
                                <code code="RXDINV"/>
                                <statusCode code="nullified"/>
                                <netAmt value="" currency="">
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="$totalValue"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="currency">
                                        <xsl:value-of select="$invoiceData/@currency"/>
                                    </xsl:attribute>
                                </netAmt>
                                <reason>
                                    <paymentIntent>
                                        <amt value="" currency="">
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="$totalValue"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="currency">
                                                <xsl:value-of select="$invoiceData/@currency"/>
                                            </xsl:attribute>
                                        </amt>

                                        <credit>
                                            <account>
                                                <holder>
                                                    <payeeRole classCode="PROV">
                                                        <!-- pay provider identifier - i.e. the pharmacy -->
                                                        <id root="" extension="">
                                                            <xsl:choose>
                                                                <xsl:when test="$BaseData/providers/provider/@description = $invoiceData/payee/@description">
                                                                    <xsl:variable name="provider" select="$BaseData/providers/provider[@description = $invoiceData/payee/@description]"/>
                                                                    <xsl:choose>
                                                                        <xsl:when test="$msgType = 'clientMsg'">
                                                                            <xsl:attribute name="root">
                                                                                <xsl:value-of select="$provider/client/id/@root"/>
                                                                            </xsl:attribute>
                                                                            <xsl:attribute name="extension">
                                                                                <xsl:value-of select="$provider/client/id/@extension"/>
                                                                            </xsl:attribute>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                            <xsl:attribute name="root">
                                                                                <xsl:value-of select="$provider/server/id/@root"/>
                                                                            </xsl:attribute>
                                                                            <xsl:attribute name="extension">
                                                                                <xsl:value-of select="$provider/server/id/@extension"/>
                                                                            </xsl:attribute>
                                                                        </xsl:otherwise>
                                                                    </xsl:choose>
                                                                </xsl:when>
                                                                <xsl:when test="$BaseData/serviceDeliveryLocations/location/@description = $invoiceData/payee/@description">
                                                                    <xsl:variable name="location" select="$BaseData/serviceDeliveryLocations/location[@description = $invoiceData/payee/@description]"/>
                                                                    <xsl:choose>
                                                                        <xsl:when test="$msgType = 'clientMsg'">
                                                                            <xsl:attribute name="root">
                                                                                <xsl:value-of select="$location/client/id/@root"/>
                                                                            </xsl:attribute>
                                                                            <xsl:attribute name="extension">
                                                                                <xsl:value-of select="$location/client/id/@extension"/>
                                                                            </xsl:attribute>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                            <xsl:attribute name="root">
                                                                                <xsl:value-of select="$location/server/id/@root"/>
                                                                            </xsl:attribute>
                                                                            <xsl:attribute name="extension">
                                                                                <xsl:value-of select="$location/server/id/@extension"/>
                                                                            </xsl:attribute>
                                                                        </xsl:otherwise>
                                                                    </xsl:choose>
                                                                </xsl:when>
                                                            </xsl:choose>
                                                        </id>
                                                    </payeeRole>
                                                </holder>
                                            </account>
                                        </credit>
                                        <debit>
                                            <account>
                                                <code>
                                                    <xsl:call-template name="nullFlavor"/>
                                                </code>
                                                <holder>
                                                    <payorRole>
                                                        <id>
                                                            <xsl:call-template name="ID_Element">
                                                                <xsl:with-param name="Record" select="$coverageInfo/record-id"/>
                                                                <xsl:with-param name="msgType" select="$msgType"/>
                                                            </xsl:call-template>
                                                        </id>
                                                    </payorRole>
                                                </holder>
                                            </account>
                                        </debit>
                                    </paymentIntent>
                                </reason>
                            </adjudicatedInvoiceElementGroup>
                        </reference>
                    </invoiceElementGroup>
                </subject>
            </controlActProcess>
        </FICR_IN630102>
    </xsl:template>


    <xsl:template name="invoiceSOFARequest">
        <xsl:param name="author-description"/>
        <xsl:param name="provider-description"/>
        <xsl:param name="payee-description"/>
        <xsl:param name="program-description"/>
        <xsl:param name="adjudicationStartDate"/>
        <xsl:param name="adjudicationEndDate"/>


        <xsl:variable name="msgType">clientMsg</xsl:variable>
        <xsl:variable name="msgAction">queryRequest</xsl:variable>

        <QUCR_IN800102 xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">QUCR_IN800102</xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
            <xsl:call-template name="transmissionWrapperEnd">
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <controlActProcess moodCode="RQO">
                <id root="" extension="">
                    <xsl:attribute name="root">
                        <xsl:call-template name="getOIDRootByName">
                            <xsl:with-param name="OID_Name">PORTAL_CONTROL_ACT_ID</xsl:with-param>
                            <xsl:with-param name="msgType" select="$msgType"/>
                        </xsl:call-template>
                    </xsl:attribute>
                    <xsl:attribute name="extension">
                        <xsl:value-of select="$OID"/>
                    </xsl:attribute>
                </id>
                <!-- HL7TriggerEventCode - Identifies the trigger event that occurred -->
                <code code="QUCR_TE820101UV01"/>
                <!-- time message was sent -->
                <effectiveTime value="">
                    <xsl:attribute name="value">
                        <xsl:call-template name="getBaseDateTime"/>
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
                    <xsl:call-template name="ProviderByDescription">
                        <xsl:with-param name="description" select="$author-description"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                        <xsl:with-param name="format">necst</xsl:with-param>
                    </xsl:call-template>
                </authorOrPerformer>


                <queryByParameter>
                    <!--<queryId root="2.16.124.9.101.1.2.5" extension="101"/>-->
                    <statusCode code="new"/>
                    <parameterList>
                        <!-- Query Identifier : not clear how this is different from queryId which is optional: docs say this is query identifier, so this is how we will treat it although it is in a different location from the CeRx schemas -->
                        <id root="" extension="">
                            <xsl:attribute name="root">
                                <xsl:call-template name="getOIDRootByName">
                                    <xsl:with-param name="OID_Name">PORTAL_QUERY_ID</xsl:with-param>
                                    <xsl:with-param name="msgType" select="$msgType"/>
                                </xsl:call-template>
                            </xsl:attribute>
                            <xsl:attribute name="extension">
                                <xsl:value-of select="$OID"/>
                            </xsl:attribute>
                        </id>

                        <!-- all params are 0 or 1: the only ones I see us supporting are: adjudication period, payee id, provider id, and financial contract id -->
                        <!--  adjudication period -->
                        <xsl:if test="$adjudicationStartDate and $adjudicationEndDate">
                            <adjudResultsGroup.Author.Time>
                                <value>
                                    <low value="20050101" inclusive="true">
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="$adjudicationStartDate"/>
                                        </xsl:attribute>
                                    </low>
                                    <high value="20050102" inclusive="true">
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="$adjudicationEndDate"/>
                                        </xsl:attribute>
                                    </high>
                                </value>
                            </adjudResultsGroup.Author.Time>
                        </xsl:if>

                        <!-- Business Arrangement Identifier : use this to optionally indicate a specific program -->
                        <xsl:if test="$program-description">
                            <financialContract.Id>
                                <value root="2.16.124.9.101.1.3" extension="FA">
                                    <xsl:attribute name="root">
                                        <xsl:call-template name="getOIDRootByName">
                                            <xsl:with-param name="OID_Name">DEPT_HEALTH_PROGRAM_ID</xsl:with-param>
                                            <xsl:with-param name="msgType" select="$msgType"/>
                                        </xsl:call-template>
                                    </xsl:attribute>
                                    <xsl:attribute name="extension">
                                        <xsl:value-of select="$program-description"/>
                                    </xsl:attribute>
                                </value>
                            </financialContract.Id>
                        </xsl:if>

                        <!-- payee identifier: should indicate a specific pharmacy using PEI Dept of Health Pharmacy Identifier: give me all payment details for this period for this payee  -->
                        <xsl:if test="$payee-description">
                            <xsl:variable name="payee" select="$BaseData/descendant::*[local-name() = 'provider' or local-name() = 'location'][@description = $payee-description]"/>
                            <payee.Id>
                                <value root="2.16.124.9.101.1.2" extension="123">
                                    <xsl:attribute name="root">
                                        <xsl:call-template name="getOIDRootByName">
                                            <xsl:with-param name="OID_Name">
                                                <xsl:value-of select="$payee/@OID"/>
                                            </xsl:with-param>
                                            <xsl:with-param name="msgType" select="$msgType"/>
                                        </xsl:call-template>
                                    </xsl:attribute>
                                    <xsl:attribute name="extension">
                                        <!-- we know this message is always a client message so we can go directly to the client node. -->
                                        <xsl:value-of select="$payee/client/id/@extension"/>
                                    </xsl:attribute>
                                </value>
                            </payee.Id>
                        </xsl:if>

                        <!-- provider identifier for service/good: should indicate a specific pharmacist using PEI Dept of Health Pharmacist Identification Number -->
                        <xsl:if test="$provider-description">
                            <xsl:variable name="provider" select="$BaseData/descendant::hl7:provider[@description = $provider-description]"/>
                            <provider.Id>
                                <value root="2.16.124.9.101.1.2" extension="123">
                                    <xsl:attribute name="root">
                                        <xsl:call-template name="getOIDRootByName">
                                            <xsl:with-param name="OID_Name">
                                                <xsl:value-of select="$provider/@OID"/>
                                            </xsl:with-param>
                                            <xsl:with-param name="msgType" select="$msgType"/>
                                        </xsl:call-template>
                                    </xsl:attribute>
                                    <xsl:attribute name="extension">
                                        <!-- we know this message is always a client message so we can go directly to the client node. -->
                                        <xsl:value-of select="$provider/client/id/@extension"/>
                                    </xsl:attribute>
                                </value>
                            </provider.Id>
                        </xsl:if>

                    </parameterList>
                </queryByParameter>
            </controlActProcess>
        </QUCR_IN800102>
    </xsl:template>

    <xsl:template name="invoiceSOFAResponse">

        <xsl:variable name="msgType">serverMsg</xsl:variable>
        <xsl:variable name="msgAction">queryResponse</xsl:variable>

        <xsl:variable name="searchOID">
            <xsl:call-template name="getOIDNameByRoot">
                <xsl:with-param name="OID_Value">
                    <xsl:value-of select="descendant-or-self::hl7:payee.Id/hl7:value/@root"/>
                </xsl:with-param>
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="searchExtension">
            <xsl:value-of select="descendant-or-self::hl7:payee.Id/hl7:value/@extension"/>
        </xsl:variable>
        <xsl:variable name="payeeName">
            <xsl:value-of select="$BaseData/descendant::node()[@OID = $searchOID][server/id/@extension = $searchExtension]/@description"/>
        </xsl:variable>
        <xsl:variable name="startDate">
            <xsl:value-of select="descendant-or-self::hl7:adjudResultsGroup.Author.Time/hl7:value/hl7:low/@value"/>
        </xsl:variable>
        <xsl:variable name="endDate">
            <xsl:value-of select="descendant-or-self::hl7:adjudResultsGroup.Author.Time/hl7:value/hl7:high/@value"/>
        </xsl:variable>
        <xsl:variable name="programType">
            <xsl:value-of select="descendant-or-self::hl7:financialContract.Id/hl7:value/@extension"/>
        </xsl:variable>

        <xsl:variable name="Totals" select="$BaseData/SOFA/payee[@description = $payeeName][($programType = '' or @program = $programType)]"/>
        <xsl:variable name="DailyTotals" select="$Totals/Daily-totals[(@Date &gt;= $startDate and @Date &lt;= $endDate)]"/>

        <QUCR_IN810102 xmlns="urn:hl7-org:v3" ITSVersion="XML_1.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">QUCR_IN810102</xsl:with-param>
                <xsl:with-param name="msgType">serverMsg</xsl:with-param>
            </xsl:call-template>
            <!-- 
            <xsl:call-template name="transmissionWrapperStart">
                <xsl:with-param name="interactionId">QUCR_IN810102</xsl:with-param>
                <xsl:with-param name="msgType">NECSTserverMsg</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="transmissionWrapperEnd">
                <xsl:with-param name="msgType" select="$msgType"/>
            </xsl:call-template>

            <acknowledgement>
                <typeCode code="AA"/>
                <targetMessage>
                    <xsl:choose>
                        <xsl:when test="$lastServerRequest/descendant-or-self::hl7:*[1]/child::node()[local-name() = 'id']">
                            <xsl:copy-of select="$lastServerRequest/descendant-or-self::hl7:*[1]/child::node()[local-name() = 'id']"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="nullFlavor"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </targetMessage>
            </acknowledgement>
            -->
            <controlActProcess classCode="CACT" moodCode="RQO">

                <xsl:if test="$Totals">
                    <subject>
                        <adjudResultsGroup>
                            <!-- ActInvoiceAdjudicationPaymentCode vocab : defines the categorization or summary -->
                            <!-- e.g. Code of PERIOD indicates Transaction counts and value totals for the date range specified. -->
                            <code code="PERIOD"/>
                            <!-- Time period for the payment or summary period. at the root level adjudResultsGroup - this will be the same as the adjudResultsGroup.Author.Time submitted in the request -->
                            <effectiveTime>
                                <low value="20050101" inclusive="true">
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="$startDate"/>
                                    </xsl:attribute>
                                </low>
                                <high value="20050102" inclusive="true">
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="$endDate"/>
                                    </xsl:attribute>
                                </high>
                            </effectiveTime>
                            <!-- total payable claim amt for provider for the period specified in the  -->
                            <netAmt value="2000.00" currency="CAD">
                                <xsl:attribute name="value">
                                    <xsl:value-of select="sum($DailyTotals/payment-total/@value)"/>
                                </xsl:attribute>
                            </netAmt>

                            <!-- Location is the health care facility where the service or good is being provided as specified in the Billable Act (e.g. store location, hospital). all pay-provider claims to this location -->
                            <location>
                                <xsl:call-template name="LocationByDescription">
                                    <xsl:with-param name="description" select="$payeeName"/>
                                    <xsl:with-param name="msgType" select="$msgType"/>
                                    <xsl:with-param name="format">CeRx</xsl:with-param>
                                </xsl:call-template>
                            </location>

                            <!-- specify the program here if it was specified in query - if not specified simply provide details for all  (i.e. no reference element) -->
                            <xsl:if test="descendant-or-self::hl7:financialContract.Id">
                                <reference>
                                    <adjudResultsFinancialContract>
                                        <id root="2.16.124.9.101.1.3" extension="FA">
                                            <xsl:attribute name="root">
                                                <xsl:value-of select="descendant-or-self::hl7:financialContract.Id/hl7:value/@root"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="extension">
                                                <xsl:value-of select="descendant-or-self::hl7:financialContract.Id/hl7:value/@extension"/>
                                            </xsl:attribute>
                                        </id>
                                    </adjudResultsFinancialContract>
                                </reference>
                            </xsl:if>

                            <xsl:for-each select="$DailyTotals">
                                <xsl:variable name="DailyDate">
                                    <xsl:value-of select="@Date"/>
                                </xsl:variable>
                                <xsl:variable name="RecordPosition">
                                    <xsl:value-of select="position()"/>
                                </xsl:variable>
                                <xsl:if test="count($DailyTotals[position() &lt;= $RecordPosition][@Date = $DailyDate]) = 1">
                                    <xsl:variable name="DailyTotalGroup" select="$Totals/Daily-totals[@Date = $DailyDate]/sub-total"/>
                                    <xsl:variable name="DailyTotalValue" select="sum($DailyTotalGroup/payment-total/@value)"/>
                                    <component>
                                        <adjudResultsGroup>
                                            <!-- e.g. Code of DAY indicates Transaction counts and value totals for each calendar day within the date range specified. -->
                                            <code code="DAY"/>
                                            <effectiveTime>
                                                <center value="20050101">
                                                    <xsl:attribute name="value">
                                                        <xsl:value-of select="$DailyDate"/>
                                                    </xsl:attribute>
                                                </center>
                                                <width value="1" unit="day"/>
                                            </effectiveTime>
                                            <!-- total payable on this day -->
                                            <netAmt value="1000.00" currency="CAD">
                                                <xsl:attribute name="value">
                                                    <xsl:value-of select="$DailyTotalValue"/>
                                                </xsl:attribute>
                                            </netAmt>
                                            <xsl:for-each select="$DailyTotalGroup">
                                                <xsl:variable name="SubTotalCode" select="@code"/>
                                                <xsl:variable name="subRecordPosition">
                                                    <xsl:value-of select="position()"/>
                                                </xsl:variable>
                                                <xsl:variable name="test1" select="count($DailyTotalGroup)"/>
                                                <xsl:variable name="test2" select="count($DailyTotalGroup[@code = $SubTotalCode])"/>
                                                <xsl:variable name="test3" select="count($DailyTotalGroup[position() &lt;= $subRecordPosition][@code = $SubTotalCode])"/>
                                                <xsl:if test="count($DailyTotalGroup[position() &lt;= $subRecordPosition][@code = $SubTotalCode]) = 1">
                                                    <xsl:variable name="SubTotalGroup" select="$DailyTotalGroup[@code = $SubTotalCode]"/>
                                                    <xsl:variable name="SubTotalValue" select="sum($SubTotalGroup/@value)"/>
                                                    <xsl:variable name="SubTotalCount" select="sum($SubTotalGroup/@count)"/>
                                                    <component>
                                                        <xsl:call-template name="sofa-adjudResultsGroup">
                                                            <xsl:with-param name="groupCount" select="$SubTotalCount"/>
                                                            <xsl:with-param name="groupCode" select="$SubTotalCode"/>
                                                            <xsl:with-param name="goupValue" select="$SubTotalValue"/>
                                                            <xsl:with-param name="groupDate" select="$DailyDate"/>
                                                        </xsl:call-template>
                                                    </component>
                                                </xsl:if>
                                            </xsl:for-each>
                                        </adjudResultsGroup>
                                    </component>
                                </xsl:if>
                            </xsl:for-each>
                        </adjudResultsGroup>
                    </subject>
                </xsl:if>

                <xsl:variable name="totalCount" select="count($Totals/Daily-totals[(@Date &gt;= $startDate and @Date &lt;= $endDate)][generate-id()=generate-id(key('keyTotals',@Date)[1])])"/>
                <queryAck>
                    <queryId root="2.16.124.9.101.1.2.5" extension="101">
                        <xsl:attribute name="root">
                            <xsl:value-of select="descendant-or-self::hl7:parameterList/hl7:id/@root"/>
                        </xsl:attribute>
                        <xsl:attribute name="extension">
                            <xsl:value-of select="descendant-or-self::hl7:parameterList/hl7:id/@extension"/>
                        </xsl:attribute>
                    </queryId>
                    <statusCode code="deliveredResponse"/>
                    <queryResponseCode code="OK"/>
                    <resultTotalQuantity value="1">
                        <xsl:attribute name="value">
                            <xsl:value-of select="$totalCount"/>
                        </xsl:attribute>
                    </resultTotalQuantity>
                    <resultCurrentQuantity value="1">
                        <xsl:attribute name="value">
                            <xsl:value-of select="$totalCount"/>
                        </xsl:attribute>
                    </resultCurrentQuantity>
                    <resultRemainingQuantity value="0"/>
                </queryAck>


            </controlActProcess>

        </QUCR_IN810102>



    </xsl:template>

    <xsl:template name="sofa-adjudResultsGroup">
        <xsl:param name="groupDate"/>
        <xsl:param name="goupValue"/>
        <xsl:param name="groupCount"/>
        <xsl:param name="groupCode"/>
        <adjudResultsGroup>
            <code code="DAY"/>
            <effectiveTime>
                <center value="20050101">
                    <xsl:attribute name="value">
                        <xsl:value-of select="$groupDate"/>
                    </xsl:attribute>
                </center>
                <width value="1" unit="day"/>
            </effectiveTime>
            <netAmt value="" currency="CAD">
                <xsl:attribute name="value">
                    <xsl:value-of select="$goupValue"/>
                </xsl:attribute>
            </netAmt>
            <!--  the total number of all Invoice Groupings that were adjudicated as payable during the specified time period (based on adjudication date) 
                    that match a specified payee (e.g. pay provider) and submitted electronically.  -->
            <summary>
                <adjudResultsGroupSummaryData>
                    <code code="">
                        <xsl:attribute name="code">
                            <xsl:value-of select="$groupCode"/>
                            <xsl:text>CT</xsl:text>
                        </xsl:attribute>
                    </code>
                    <value xsi:type="PQ" value="" unit="1">
                        <xsl:attribute name="value">
                            <xsl:value-of select="$groupCount"/>
                        </xsl:attribute>
                    </value>
                </adjudResultsGroupSummaryData>
            </summary>
            <!-- the total net amount of all Invoice Groupings that were adjudicated as payable during the specified time period (based on adjudication date) 
                    that match a specified payee (e.g. pay provider) and submitted electronically  -->
            <summary>
                <adjudResultsGroupSummaryData>
                    <code code="">
                        <xsl:attribute name="code">
                            <xsl:value-of select="$groupCode"/>
                            <xsl:text>AT</xsl:text>
                        </xsl:attribute>
                    </code>
                    <value xsi:type="MO" value="" currency="CAD">
                        <xsl:attribute name="value">
                            <xsl:value-of select="$goupValue"/>
                        </xsl:attribute>
                    </value>
                </adjudResultsGroupSummaryData>
            </summary>
        </adjudResultsGroup>
    </xsl:template>

    <xsl:template name="adjudicationResult">
        <xsl:param name="DrugCostPayment"/>
        <xsl:param name="msgType"/>

        <adjudicationResult>
            <xsl:choose>
                <xsl:when test="$DrugCostPayment/cost/reason">
                    <code code="AA">
                        <xsl:call-template name="codeSystem">
                            <xsl:with-param name="codeElement" select="$DrugCostPayment/cost/reason/code"/>
                            <xsl:with-param name="msgType" select="$msgType"/>
                        </xsl:call-template>
                    </code>

                    <xsl:if test="$DrugCostPayment/cost/reason/@warning">
                        <pertinentInformation>
                            <adjudicationResultInformation>
                                <value>
                                    <xsl:value-of select="$DrugCostPayment/cost/reason/@warning"/>
                                </value>
                                <!-- nearing health spending acct. funds max -->
                            </adjudicationResultInformation>
                        </pertinentInformation>
                    </xsl:if>

                    <xsl:if test="$DrugCostPayment/cost/reason/@error">
                        <pertinentInformation>
                            <adjudicationResultReason>
                                <value>
                                    <xsl:value-of select="$DrugCostPayment/cost/reason/@error"/>
                                </value>
                                <!-- reduced to generic cost -->
                            </adjudicationResultReason>
                        </pertinentInformation>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <code code="AS"/>
                </xsl:otherwise>
            </xsl:choose>
        </adjudicationResult>
    </xsl:template>
    <xsl:template name="adjudicatedInvoiceElementDetail">
        <xsl:param name="root_value"/>
        <xsl:param name="extension_value"/>
        <xsl:param name="adjudicationCode"/>
        <xsl:param name="quantity">1</xsl:param>
        <xsl:param name="currency"/>
        <xsl:param name="unitPriceAmt"/>
        <xsl:param name="units">1</xsl:param>
        <xsl:param name="outcomeNode"/>
        <xsl:param name="msgType"/>

        <adjudicatedInvoiceElementDetail>
            <id>
                <xsl:attribute name="root">
                    <xsl:value-of select="$root_value"/>
                </xsl:attribute>
                <xsl:attribute name="extension">
                    <xsl:value-of select="$extension_value"/>
                </xsl:attribute>
            </id>
            <code code="">
                <xsl:attribute name="code">
                    <xsl:value-of select="$adjudicationCode"/>
                </xsl:attribute>
            </code>
            <!-- For the MARKUP, PROFFEE invoice element details, specify as 1 over 1.  E.g. "1" over "1". -->
            <unitQuantity>
                <numerator value="">
                    <xsl:attribute name="value">
                        <xsl:value-of select="$quantity"/>
                    </xsl:attribute>
                </numerator>
                <denominator value="">
                    <xsl:attribute name="value">
                        <xsl:value-of select="$quantity"/>
                    </xsl:attribute>
                </denominator>
            </unitQuantity>
            <!-- For the MARKUP, PROFFEE invoice element details, specify as "x" dollars over (per) "1" unit, with no units of measure.  E.g. "12.00" "CAD" over (per) "1". -->
            <unitPriceAmt>
                <numerator value="" currency="">
                    <xsl:attribute name="value">
                        <xsl:value-of select="$unitPriceAmt"/>
                    </xsl:attribute>
                    <xsl:attribute name="currency">
                        <xsl:value-of select="$currency"/>
                    </xsl:attribute>
                </numerator>
                <denominator value="">
                    <xsl:attribute name="value">
                        <xsl:value-of select="$units"/>
                    </xsl:attribute>
                </denominator>
            </unitPriceAmt>
            <netAmt value="" currency="">
                <xsl:attribute name="value">
                    <xsl:value-of select="($unitPriceAmt * $quantity) div $units"/>
                </xsl:attribute>
                <xsl:attribute name="currency">
                    <xsl:value-of select="$currency"/>
                </xsl:attribute>
            </netAmt>
            <xsl:if test="$outcomeNode">
                <outcomeOf>
                    <xsl:call-template name="adjudicationResult">
                        <xsl:with-param name="DrugCostPayment" select="$outcomeNode"/>
                        <xsl:with-param name="msgType" select="$msgType"/>
                    </xsl:call-template>
                </outcomeOf>
            </xsl:if>

        </adjudicatedInvoiceElementDetail>
    </xsl:template>
</xsl:stylesheet>
