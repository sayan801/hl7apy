<?xml version="1.0" encoding="UTF-8"?>
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->  <xsl:stylesheet xmlns:hl7="urn:hl7-org:v3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:import href="../Lib/Validation_Lib.xsl"/>

    <xsl:variable name="Net_Amount_Incorrect_ErrorMsg">Amount supplied does not match the sum of all descendant Detail invoice elements</xsl:variable>
    <xsl:variable name="Net_Amount_miss_match_ErrorMsg">Amount supplied does not match the Payment Request amoutn</xsl:variable>
    <xsl:variable name="Incorrect_Currency_Value_ErrorMsg">Incorrect Currency value supplied</xsl:variable>
    <xsl:variable name="PayeeRole_Incorrect_ErrorMsg">PayeeRole is an incorrect value</xsl:variable>
    <xsl:variable name="DRUGING_child_ErrorMsg">This element must be a child of the invoiceElementGroup with a code = 'DRUGING'</xsl:variable>
    <xsl:variable name="UnitQuantity_numerator_restriction_ErrorMsg">Quantity numerator does not meant the required restriction</xsl:variable>
    <xsl:variable name="UnitQuantity_numerator_denominator_missmatch_ErrorMsg">Quantity numerator and denominator must match</xsl:variable>
    <xsl:variable name="UnitPriceAmt_denominator_restriction_ErrorMsg">Price denominator does not meant the required restriction</xsl:variable>
    <xsl:variable name="netAmt_Calculation_ErrorMsg">Calculated net amount does not match amount found in netAmt element</xsl:variable>
    <xsl:variable name="upstream_payor_total_ErrorMsg">Upstream payor total does not match the total for all upstream payors in request.</xsl:variable>


    <xsl:template match="text()|@*"/>


    <!-- general invoice checks -->
    <xsl:template match="hl7:credit/hl7:account/hl7:holder/hl7:payeeRole">
        <xsl:if test="not(@classCode='PROV')">
            <xsl:call-template name="ReportError">
                <xsl:with-param name="ErrorText" select="$PayeeRole_Incorrect_ErrorMsg"/>
                <xsl:with-param name="currentNode" select="."/>
                <xsl:with-param name="expectedValue">PROV</xsl:with-param>
                <xsl:with-param name="actualValue">
                    <xsl:value-of select="@classCode"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:manufacturedProduct/hl7:manufacturedMaterialKind/hl7:code">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/invoiceMedication"/>
            <xsl:with-param name="codeSystemRequired">true</xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:supplyEvent1/hl7:performer/hl7:healthCareProvider/hl7:id">
        <xsl:call-template name="Identifier_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="expected_OID_List" select="$OIDSet/assignedPerson"/>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="hl7:substanceAdministrationOrder/hl7:pertinentInformation/hl7:substitution">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="hl7:code"/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/ActSubstanceAdminSubstitutionCode"/>
            <xsl:with-param name="codeSystemRequired">false</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="hl7:reasonCode"/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/SubstanceAdminSubstitutionNotAllowedReason"/>
            <xsl:with-param name="codeSystemRequired">false</xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:substanceAdministrationIntent/hl7:substitution">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="hl7:code"/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/ActSubstanceAdminSubstitutionCode"/>
            <xsl:with-param name="codeSystemRequired">false</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="hl7:reasonCode"/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/SubstanceAdminSubstitutionReason"/>
            <xsl:with-param name="codeSystemRequired">false</xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:detectedMedicationIssue">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="hl7:code"/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/ActDetectedIssueCode"/>
            <xsl:with-param name="codeSystemRequired">false</xsl:with-param>
        </xsl:call-template>
        <xsl:if test="./value">
            <xsl:call-template name="Code_Element_Test">
                <xsl:with-param name="node" select="hl7:value"/>
                <xsl:with-param name="nullable">false</xsl:with-param>
                <xsl:with-param name="validCodeSet" select="$CodeSet/invoiceIssueAlertCode"/>
                <xsl:with-param name="codeSystemRequired">false</xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="./otherCode">
            <xsl:call-template name="Code_Element_Test">
                <xsl:with-param name="node" select="hl7:otherCode"/>
                <xsl:with-param name="nullable">false</xsl:with-param>
                <xsl:with-param name="validCodeSet" select="$CodeSet/CPHACodes"/>
                <xsl:with-param name="codeSystemRequired">false</xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:mitigatedBy/management">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="hl7:code"/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/ActDetectedIssueManagementCode"/>
            <xsl:with-param name="codeSystemRequired">false</xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>

    <!-- Invoice request checks -->
    <xsl:template match="hl7:paymentRequest">
        <xsl:call-template name="MaxAllowed_ChildElement_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="child_element_max">1</xsl:with-param>
            <xsl:with-param name="child_element_min">1</xsl:with-param>
            <xsl:with-param name="child_element_name">reasonOf</xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:paymentRequest/hl7:id">
            <xsl:call-template name="Identifier_Element_Test">
                <xsl:with-param name="node" select="."/>
                <xsl:with-param name="nullable">true</xsl:with-param>
                <!--<xsl:with-param name="expected_OID">DIS_ADJUDICATED_INVOICE_GROUP_ID</xsl:with-param>-->
                <xsl:with-param name="expected_OID">DIS_DISPENSE_ID</xsl:with-param>
            </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:paymentRequest/hl7:amt">
        <xsl:call-template name="Invoice_amount_Test">
            <xsl:with-param name="node" select="."/>
        </xsl:call-template>
        <xsl:call-template name="currency_Test">
            <xsl:with-param name="node" select="."/>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:component/hl7:invoiceElementGroup/hl7:netAmt">
        <xsl:call-template name="Invoice_amount_Test">
            <xsl:with-param name="node" select="."/>
        </xsl:call-template>
        <xsl:call-template name="currency_Test">
            <xsl:with-param name="node" select="."/>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:reasonOf/hl7:invoiceElementGroup/hl7:netAmt">
        <xsl:variable name="PaymentAmt" select="ancestor::hl7:paymentRequest/hl7:amt/@value"/>
        <xsl:if test="not(@value = $PaymentAmt)">
            <xsl:call-template name="ReportError">
                <xsl:with-param name="ErrorText" select="$Net_Amount_miss_match_ErrorMsg"/>
                <xsl:with-param name="currentNode" select="."/>
                <xsl:with-param name="expectedValue">
                    <xsl:value-of select="$PaymentAmt"/>
                </xsl:with-param>
                <xsl:with-param name="actualValue">
                    <xsl:value-of select="@value"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        <xsl:call-template name="currency_Test">
            <xsl:with-param name="node" select="."/>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:reasonOf/hl7:invoiceElementGroup/hl7:id">
        <xsl:call-template name="Identifier_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">true</xsl:with-param>
            <xsl:with-param name="expected_OID">PORTAL_DISPENSE_ID</xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:reasonOf/hl7:invoiceElementGroup/hl7:code">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/InvoiceReasonOfCode"/>
            <xsl:with-param name="codeSystemRequired">false</xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:component/hl7:invoiceElementGroup/hl7:code">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/invoiceElementGroupCode"/>
            <xsl:with-param name="codeSystemRequired">false</xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:reasonOf/hl7:supplyEvent1">
        <xsl:if test="not(ancestor::hl7:invoiceElementGroup[1]/hl7:code/@code = 'DRUGING')">
            <xsl:call-template name="ReportError">
                <xsl:with-param name="ErrorText" select="$DRUGING_child_ErrorMsg"/>
                <xsl:with-param name="currentNode" select="."/>
                <xsl:with-param name="expectedValue"/>
                <xsl:with-param name="actualValue"/>
            </xsl:call-template>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:invoiceElementDetail">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/invoiceElementDetailCode"/>
            <xsl:with-param name="codeSystemRequired">false</xsl:with-param>
        </xsl:call-template>
        <xsl:choose>
            <xsl:when test="hl7:code/@code = 'MARKUP' ">
                <xsl:if test="not(ancestor::hl7:invoiceElementGroup[1]/hl7:code/@code = 'DRUGING')">
                    <xsl:call-template name="ReportError">
                        <xsl:with-param name="ErrorText" select="$DRUGING_child_ErrorMsg"/>
                        <xsl:with-param name="currentNode" select="."/>
                        <xsl:with-param name="expectedValue"/>
                        <xsl:with-param name="actualValue"/>
                    </xsl:call-template>
                    <xsl:call-template name="invoiceElementDetail">
                        <xsl:with-param name="node" select="."/>
                        <xsl:with-param name="QuantityNumerator">1</xsl:with-param>
                        <xsl:with-param name="PriceDenominator">1</xsl:with-param>
                    </xsl:call-template>
                </xsl:if>
            </xsl:when>
            <xsl:when test="hl7:code/@code = 'PROFFEE' ">
                <xsl:call-template name="invoiceElementDetail">
                    <xsl:with-param name="node" select="."/>
                    <xsl:with-param name="QuantityNumerator">1</xsl:with-param>
                    <xsl:with-param name="PriceDenominator">1</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="hl7:code/@code = 'COINS' ">
                <xsl:call-template name="invoiceElementDetail">
                    <xsl:with-param name="node" select="."/>
                    <xsl:with-param name="QuantityNumerator">1</xsl:with-param>
                    <xsl:with-param name="PriceDenominator">1</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="hl7:code/@code = 'COPAYMENT' ">
                <xsl:call-template name="invoiceElementDetail">
                    <xsl:with-param name="node" select="."/>
                    <xsl:with-param name="QuantityNumerator">1</xsl:with-param>
                    <xsl:with-param name="PriceDenominator">1</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="hl7:code/@code = 'DEDUCTIBLE' ">
                <xsl:call-template name="invoiceElementDetail">
                    <xsl:with-param name="node" select="."/>
                    <xsl:with-param name="QuantityNumerator">1</xsl:with-param>
                    <xsl:with-param name="PriceDenominator">1</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <!-- The Drug -->
                <xsl:if test="not(ancestor::hl7:invoiceElementGroup[1]/hl7:code/@code = 'DRUGING')">
                    <xsl:call-template name="ReportError">
                        <xsl:with-param name="ErrorText" select="$DRUGING_child_ErrorMsg"/>
                        <xsl:with-param name="currentNode" select="."/>
                        <xsl:with-param name="expectedValue"/>
                        <xsl:with-param name="actualValue"/>
                    </xsl:call-template>
                </xsl:if>
                <xsl:call-template name="Code_Element_Test">
                    <xsl:with-param name="node" select="hl7:code"/>
                    <xsl:with-param name="nullable">false</xsl:with-param>
                    <xsl:with-param name="validCodeSet" select="$CodeSet/invoiceMedication"/>
                    <xsl:with-param name="codeSystemRequired">true</xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="invoiceElementDetail">
                    <xsl:with-param name="node" select="."/>
                    <xsl:with-param name="QuantityNumerator">
                        <xsl:value-of select="hl7:unitQuantity/hl7:numerator/@value"/>
                    </xsl:with-param>
                    <xsl:with-param name="PriceDenominator">
                        <xsl:value-of select="hl7:unitPriceAmt/hl7:denominator/@value"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates/>
    </xsl:template>



    <!-- adjudicated results checks -->
    <xsl:template match="hl7:component/hl7:adjudicatedInvoiceElementGroup/hl7:netAmt">
        <xsl:call-template name="Adjudicated_Invoice_amount_Test">
            <xsl:with-param name="node" select="."/>
        </xsl:call-template>
        <xsl:call-template name="currency_Test">
            <xsl:with-param name="node" select="."/>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:reasonOf/hl7:adjudicatedInvoiceElementGroup/hl7:netAmt">
        <xsl:variable name="PaymentAmt" select="ancestor::hl7:paymentIntent/hl7:amt/@value"/>
        <xsl:if test="not(@value = $PaymentAmt)">
            <xsl:call-template name="ReportError">
                <xsl:with-param name="ErrorText" select="$Net_Amount_miss_match_ErrorMsg"/>
                <xsl:with-param name="currentNode" select="."/>
                <xsl:with-param name="expectedValue">
                    <xsl:value-of select="$PaymentAmt"/>
                </xsl:with-param>
                <xsl:with-param name="actualValue">
                    <xsl:value-of select="@value"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        <xsl:call-template name="currency_Test">
            <xsl:with-param name="node" select="."/>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:reasonOf/hl7:adjudicatedInvoiceElementGroup/hl7:id">
        <xsl:call-template name="Identifier_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">true</xsl:with-param>
            <xsl:with-param name="expected_OID">DIS_ADJUDICATED_INVOICE_GROUP_ID</xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:reasonOf/hl7:adjudicatedInvoiceElementGroup/hl7:code">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/InvoiceReasonOfCode"/>
            <xsl:with-param name="codeSystemRequired">false</xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:reasonOf/hl7:adjudicatedInvoiceElementGroup/hl7:statusCode">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/statusCodeCompleted"/>
            <xsl:with-param name="codeSystemRequired">false</xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:paymentIntent/hl7:reasonOf/hl7:adjudicatedInvoiceElementGroup">
        <xsl:if test="$lastServerRequest/descendant-or-self::hl7:paymentRequest/hl7:reasonOf/hl7:invoiceElementGroup/hl7:reference">
            <xsl:call-template name="MaxAllowed_ChildElement_Test">
                <xsl:with-param name="node" select="."/>
                <xsl:with-param name="child_element_max">1</xsl:with-param>
                <xsl:with-param name="child_element_min">1</xsl:with-param>
                <xsl:with-param name="child_element_name">reference</xsl:with-param>
            </xsl:call-template>
            <xsl:variable name="totalRequest" select="sum($lastServerRequest/descendant-or-self::hl7:paymentRequest/hl7:reasonOf/hl7:invoiceElementGroup/hl7:reference/hl7:adjudicatedInvoiceElementGroup/hl7:netAmt/@value)"/>
            <xsl:if test="not($totalRequest = hl7:reference/hl7:adjudicatedInvoiceElementGroup/hl7:netAmt/@value)">
                <xsl:call-template name="ReportError">
                    <xsl:with-param name="ErrorText" select="$upstream_payor_total_ErrorMsg"/>
                    <xsl:with-param name="currentNode" select="hl7:reference/hl7:adjudicatedInvoiceElementGroup/hl7:netAmt"/>
                    <xsl:with-param name="expectedValue">
                        <xsl:value-of select="$totalRequest"/>
                    </xsl:with-param>
                    <xsl:with-param name="actualValue">
                        <xsl:value-of select="hl7:reference/hl7:adjudicatedInvoiceElementGroup/hl7:netAmt/@value"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:if>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:component/hl7:adjudicatedInvoiceElementGroup/hl7:code">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/invoiceElementGroupCode"/>
            <xsl:with-param name="codeSystemRequired">false</xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:adjudicatedInvoiceElementDetail">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="hl7:code"/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/adjudicatedInvoiceElementDetailCode"/>
            <xsl:with-param name="codeSystemRequired">false</xsl:with-param>
        </xsl:call-template>
        <xsl:choose>
            <xsl:when test="hl7:code/@code = 'MARKUP' ">
                <xsl:if test="not(ancestor::hl7:adjudicatedInvoiceElementGroup[1]/hl7:code/@code = 'DRUGING')">
                    <xsl:call-template name="ReportError">
                        <xsl:with-param name="ErrorText" select="$DRUGING_child_ErrorMsg"/>
                        <xsl:with-param name="currentNode" select="."/>
                        <xsl:with-param name="expectedValue"/>
                        <xsl:with-param name="actualValue"/>
                    </xsl:call-template>
                    <xsl:call-template name="invoiceElementDetail">
                        <xsl:with-param name="node" select="."/>
                        <xsl:with-param name="QuantityNumerator">1</xsl:with-param>
                        <xsl:with-param name="PriceDenominator">1</xsl:with-param>
                    </xsl:call-template>
                </xsl:if>
            </xsl:when>
            <xsl:when test="hl7:code/@code = 'PROFFEE' ">
                <xsl:call-template name="invoiceElementDetail">
                    <xsl:with-param name="node" select="."/>
                    <xsl:with-param name="QuantityNumerator">1</xsl:with-param>
                    <xsl:with-param name="PriceDenominator">1</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="hl7:code/@code = 'COINS' ">
                <xsl:call-template name="invoiceElementDetail">
                    <xsl:with-param name="node" select="."/>
                    <xsl:with-param name="QuantityNumerator">1</xsl:with-param>
                    <xsl:with-param name="PriceDenominator">1</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="hl7:code/@code = 'COPAYMENT' ">
                <xsl:call-template name="invoiceElementDetail">
                    <xsl:with-param name="node" select="."/>
                    <xsl:with-param name="QuantityNumerator">1</xsl:with-param>
                    <xsl:with-param name="PriceDenominator">1</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="hl7:code/@code = 'DEDUCTIBLE' ">
                <xsl:call-template name="invoiceElementDetail">
                    <xsl:with-param name="node" select="."/>
                    <xsl:with-param name="QuantityNumerator">1</xsl:with-param>
                    <xsl:with-param name="PriceDenominator">1</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <!-- The Drug -->
                <xsl:if test="not(ancestor::hl7:adjudicatedInvoiceElementGroup[1]/hl7:code/@code = 'DRUGING')">
                    <xsl:call-template name="ReportError">
                        <xsl:with-param name="ErrorText" select="$DRUGING_child_ErrorMsg"/>
                        <xsl:with-param name="currentNode" select="."/>
                        <xsl:with-param name="expectedValue"/>
                        <xsl:with-param name="actualValue"/>
                    </xsl:call-template>
                </xsl:if>
                <xsl:call-template name="Code_Element_Test">
                    <xsl:with-param name="node" select="hl7:code"/>
                    <xsl:with-param name="nullable">false</xsl:with-param>
                    <xsl:with-param name="validCodeSet" select="$CodeSet/invoiceMedication"/>
                    <xsl:with-param name="codeSystemRequired">true</xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="invoiceElementDetail">
                    <xsl:with-param name="node" select="."/>
                    <xsl:with-param name="QuantityNumerator">
                        <xsl:value-of select="hl7:unitQuantity/hl7:numerator/@value"/>
                    </xsl:with-param>
                    <xsl:with-param name="PriceDenominator">
                        <xsl:value-of select="hl7:unitPriceAmt/hl7:denominator/@value"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="hl7:outcomeOf/hl7:adjudicationResult">
        <xsl:call-template name="Code_Element_Test">
            <xsl:with-param name="node" select="hl7:code"/>
            <xsl:with-param name="nullable">false</xsl:with-param>
            <xsl:with-param name="validCodeSet" select="$CodeSet/adjudicationResultCode"/>
            <xsl:with-param name="codeSystemRequired">false</xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates/>
    </xsl:template>

    <!-- named tempates -->
    <xsl:template name="invoiceElementDetail">
        <xsl:param name="node"/>
        <xsl:param name="QuantityNumerator"/>
        <xsl:param name="PriceDenominator"/>

        <xsl:if test="not($QuantityNumerator = $node/hl7:unitQuantity/hl7:numerator/@value)">
            <xsl:call-template name="ReportError">
                <xsl:with-param name="ErrorText" select="$UnitQuantity_numerator_restriction_ErrorMsg"/>
                <xsl:with-param name="currentNode" select="."/>
                <xsl:with-param name="expectedValue">
                    <xsl:value-of select="$QuantityNumerator"/>
                </xsl:with-param>
                <xsl:with-param name="actualValue">
                    <xsl:value-of select="$node/hl7:unitQuantity/hl7:numerator/@value"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="not($QuantityNumerator = $node/hl7:unitQuantity/hl7:denominator/@value)">
            <xsl:call-template name="ReportError">
                <xsl:with-param name="ErrorText" select="$UnitQuantity_numerator_denominator_missmatch_ErrorMsg"/>
                <xsl:with-param name="currentNode" select="."/>
                <xsl:with-param name="expectedValue">
                    <xsl:value-of select="$QuantityNumerator"/>
                </xsl:with-param>
                <xsl:with-param name="actualValue">
                    <xsl:value-of select="$node/hl7:unitQuantity/hl7:denominator/@value"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="not($PriceDenominator = $node/hl7:unitPriceAmt/hl7:denominator/@value)">
            <xsl:call-template name="ReportError">
                <xsl:with-param name="ErrorText" select="$UnitPriceAmt_denominator_restriction_ErrorMsg"/>
                <xsl:with-param name="currentNode" select="."/>
                <xsl:with-param name="expectedValue">
                    <xsl:value-of select="$QuantityNumerator"/>
                </xsl:with-param>
                <xsl:with-param name="actualValue">
                    <xsl:value-of select="$node/hl7:unitQuantity/hl7:denominator/@value"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:if>

        <xsl:variable name="priceTotal" select="($node/hl7:unitQuantity/hl7:numerator/@value * $node/hl7:unitPriceAmt/hl7:numerator/@value) div $node/hl7:unitPriceAmt/hl7:denominator/@value"/>
        <xsl:if test="not($priceTotal = $node/hl7:netAmt/@value)">
            <xsl:call-template name="ReportError">
                <xsl:with-param name="ErrorText" select="$netAmt_Calculation_ErrorMsg"/>
                <xsl:with-param name="currentNode" select="."/>
                <xsl:with-param name="expectedValue">
                    <xsl:value-of select="$priceTotal"/>
                </xsl:with-param>
                <xsl:with-param name="actualValue">
                    <xsl:value-of select="$node/hl7:netAmt/@value"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    
    <xsl:template name="Adjudicated_Invoice_amount_Test">
        <xsl:param name="node"/>
        
        <xsl:variable name="totalNetamt" select="sum($node/parent::node()/descendant::hl7:adjudicatedInvoiceElementDetail/hl7:netAmt/@value)"/>
        
        <xsl:if test="not($node/@value = $totalNetamt)">
            <xsl:call-template name="ReportError">
                <xsl:with-param name="ErrorText" select="$Net_Amount_Incorrect_ErrorMsg"/>
                <xsl:with-param name="currentNode" select="$node"/>
                <xsl:with-param name="expectedValue">
                    <xsl:value-of select="$totalNetamt"/>
                </xsl:with-param>
                <xsl:with-param name="actualValue">
                    <xsl:value-of select="$node/@value"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template name="Invoice_amount_Test">
        <xsl:param name="node"/>

        <xsl:variable name="totalNetamt" select="sum($node/parent::node()/descendant::hl7:invoiceElementDetail/hl7:netAmt/@value)"/>

        <xsl:if test="not($node/@value = $totalNetamt)">
            <xsl:call-template name="ReportError">
                <xsl:with-param name="ErrorText" select="$Net_Amount_Incorrect_ErrorMsg"/>
                <xsl:with-param name="currentNode" select="$node"/>
                <xsl:with-param name="expectedValue">
                    <xsl:value-of select="$totalNetamt"/>
                </xsl:with-param>
                <xsl:with-param name="actualValue">
                    <xsl:value-of select="$node/@value"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template name="currency_Test">
        <xsl:param name="node"/>
        <xsl:if test="not($node/@currency = 'CAD')">
            <xsl:call-template name="ReportError">
                <xsl:with-param name="ErrorText" select="$Incorrect_Currency_Value_ErrorMsg"/>
                <xsl:with-param name="currentNode" select="$node"/>
                <xsl:with-param name="expectedValue">CAD</xsl:with-param>
                <xsl:with-param name="actualValue">
                    <xsl:value-of select="$node/@currency"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>




</xsl:stylesheet>
