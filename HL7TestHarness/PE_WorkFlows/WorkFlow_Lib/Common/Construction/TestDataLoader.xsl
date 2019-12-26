<?xml version="1.0" encoding="UTF-8"?>
<!--       Copyright © 1996-2006 by DeltaWare Systems Inc.       The GNU General Public License (GPL)     This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the      Free Software Foundation; either version 2 of the License, or (at your option) any later version.     This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.     You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc.,      59 Temple Place, Suite 330, Boston, MA 02111-1307 USA -->
<xsl:stylesheet xmlns:hl7="urn:hl7-org:v3" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:import href="..\Lib\TestData_Lib.xsl"/>
    <xsl:param name="profile-description"/>
    <xsl:param name="profile-sequence"/>
    <xsl:param name="patient-description"/>
    <xsl:param name="msg-effective-time"/>

    <xsl:param name="messageType">server</xsl:param>

    <xsl:template match="text()|@*"/>

    <xsl:template match="/">
        <xsl:call-template name="outputTestData"/>
    </xsl:template>

    <xsl:template name="outputTestData">
        <xsl:variable name="requestMsg" select="."/>

        <xsl:variable name="patient_description">
            <xsl:choose>
                <xsl:when test="descendant-or-self::hl7:controlActProcess/hl7:subject/descendant-or-self::hl7:coveredPartyAsPatient/hl7:id">
                    <xsl:call-template name="getPatientNameByID">
                        <xsl:with-param name="node" select="descendant-or-self::hl7:controlActProcess/hl7:subject/descendant-or-self::hl7:coveredPartyAsPatient/hl7:id"/>
                        <xsl:with-param name="messageType" select="$messageType"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:annotation/hl7:subject/hl7:annotatedAct/hl7:subject/hl7:patient/hl7:id">
                    <xsl:call-template name="getPatientNameByID">
                        <xsl:with-param name="node" select="descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:annotation/hl7:subject/hl7:annotatedAct/hl7:subject/hl7:patient/hl7:id"/>
                        <xsl:with-param name="messageType" select="$messageType"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="descendant-or-self::hl7:controlActEvent/hl7:subject/descendant-or-self::hl7:recordTarget/hl7:patient/hl7:id">
                    <xsl:call-template name="getPatientNameByID">
                        <xsl:with-param name="node" select="descendant-or-self::hl7:controlActEvent/hl7:subject/descendant-or-self::hl7:recordTarget/hl7:patient/hl7:id"/>
                        <xsl:with-param name="messageType" select="$messageType"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="getPatientNameByID">
                        <xsl:with-param name="node" select="descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:*/hl7:subject/hl7:*[starts-with(local-name(),'patient')]/hl7:id"/>
                        <xsl:with-param name="messageType" select="$messageType"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <configuration>
            <testData>
                <xsl:for-each select="$TestDataXml/configuration/testData/@*">
                    <xsl:attribute name="{name()}">
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                </xsl:for-each>

                <xsl:for-each select="$TestDataXml/configuration/testData/*">
                    <xsl:variable name="elementName" select="local-name()"/>

                    <xsl:choose>
                        <xsl:when test="$elementName = 'medicalProfiles' ">
                            <medicalProfiles>
                                <xsl:copy-of select="$TestDataXml/configuration/testData/medicalProfiles/medicalProfile[not(@description=$profile-description and @sequence=$profile-sequence and patient/@description=$patient_description)]"/>
                                <xsl:variable name="profile"
                                    select="$TestDataXml/configuration/testData/medicalProfiles/medicalProfile[@description=$profile-description and @sequence=$profile-sequence and patient/@description=$patient_description][1]"/>
                                <medicalProfile>
                                    <xsl:attribute name="description">
                                        <xsl:value-of select="$profile-description"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="sequence">
                                        <xsl:value-of select="$profile-sequence"/>
                                    </xsl:attribute>
                                    <xsl:for-each select="$profile/@*">
                                        <xsl:attribute name="{name()}">
                                            <xsl:value-of select="."/>
                                        </xsl:attribute>
                                    </xsl:for-each>
                                    <xsl:if test="not($profile/patient)">
                                        <xsl:element name="patient">
                                            <xsl:attribute name="description">
                                                <xsl:value-of select="$patient_description"/>
                                            </xsl:attribute>
                                        </xsl:element>
                                    </xsl:if>
                                    <xsl:copy-of select="$profile/*[not(name() = 'items')]"/>
                                    <items>
                                        <xsl:for-each select="$profile/items/@*">
                                            <xsl:attribute name="{name()}">
                                                <xsl:value-of select="."/>
                                            </xsl:attribute>
                                        </xsl:for-each>

                                        <xsl:for-each select="$profile/items/*">
                                            <xsl:variable name="profileItem" select="."/>
                                            <xsl:variable name="record-ext">
                                                <xsl:choose>
                                                    <xsl:when test="$messageType = 'server'">
                                                        <xsl:value-of select="record-id/@server"/>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:value-of select="record-id/@client"/>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:variable>
                                            <xsl:variable name="record-OID">
                                                <xsl:choose>
                                                    <xsl:when test="$messageType = 'server'">
                                                        <xsl:value-of select="$OID_root/*[name() = $profileItem/record-id/@root_OID]/@server"/>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:value-of select="$OID_root/*[name() = $profileItem/record-id/@root_OID]/@client"/>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:variable>

                                            <xsl:choose>
                                                <xsl:when test="$requestMsg/descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:intoleranceCondition[hl7:id/@extension = $record-ext][hl7:id/@root = $record-OID]">
                                                    <!-- update allergy items. -->
                                                    <xsl:for-each select="$requestMsg/descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:intoleranceCondition[hl7:id/@extension = $record-ext][hl7:id/@root = $record-OID]">
                                                        <xsl:call-template name="Profile_Allergy">
                                                            <xsl:with-param name="requestMsg" select="$requestMsg"/>
                                                            <xsl:with-param name="Profile" select="$profile"/>
                                                            <xsl:with-param name="currentAllergy" select="$profileItem"/>
                                                            <xsl:with-param name="description" select="$profileItem/@description"/>
                                                        </xsl:call-template>
                                                    </xsl:for-each>
                                                </xsl:when>
                                                <xsl:when test="$requestMsg/descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:combinedMedicationRequest[hl7:id/@extension = $record-ext][hl7:id/@root = $record-OID]">
                                                    <!-- update prescription items. -->
                                                    <xsl:for-each select="$requestMsg/descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:combinedMedicationRequest[hl7:id/@extension = $record-ext][hl7:id/@root = $record-OID]">
                                                        <xsl:call-template name="Profile_Prescription">
                                                            <xsl:with-param name="requestMsg" select="$requestMsg"/>
                                                            <xsl:with-param name="Profile" select="$profile"/>
                                                            <xsl:with-param name="currentPrescription" select="$profileItem"/>
                                                            <xsl:with-param name="description" select="$profileItem/@description"/>
                                                        </xsl:call-template>
                                                    </xsl:for-each>
                                                </xsl:when>
                                                <xsl:when test="$requestMsg/hl7:PORX_IN010060CA/hl7:controlActEvent/hl7:subject/hl7:supplyEvent[hl7:id/@extension = $record-ext][hl7:id/@root = $record-OID] ">
                                                    <xsl:for-each select="$requestMsg/descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:supplyEvent[hl7:id/@extension = $record-ext][hl7:id/@root = $record-OID]">
                                                        <xsl:call-template name="Profile_RefusalToFill">
                                                            <xsl:with-param name="requestMsg" select="$requestMsg"/>
                                                            <xsl:with-param name="Item" select="$profileItem"/>
                                                        </xsl:call-template>
                                                    </xsl:for-each>
                                                </xsl:when>
                                                <xsl:when test="$requestMsg/hl7:PORX_IN020080CA/hl7:controlActEvent/hl7:subject/hl7:supplyEvent[hl7:id/@extension = $record-ext][hl7:id/@root = $record-OID] ">
                                                    <xsl:for-each select="$requestMsg/descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:supplyEvent[hl7:id/@extension = $record-ext][hl7:id/@root = $record-OID]">
                                                        <xsl:call-template name="Profile_DispensePickup">
                                                            <xsl:with-param name="requestMsg" select="$requestMsg"/>
                                                            <xsl:with-param name="currentDispense" select="$profileItem"/>
                                                        </xsl:call-template>
                                                    </xsl:for-each>
                                                </xsl:when>
                                                <xsl:when
                                                    test="$requestMsg/hl7:COMT_IN301001CA/hl7:controlActEvent/hl7:subject/hl7:annotation[hl7:subject/hl7:annotatedAct/hl7:id/@extension = $record-ext][hl7:subject/hl7:annotatedAct/hl7:id/@root = $record-OID] ">
                                                    <xsl:for-each
                                                        select="$requestMsg/hl7:COMT_IN301001CA/hl7:controlActEvent/hl7:subject/hl7:annotation[hl7:subject/hl7:annotatedAct/hl7:id/@extension = $record-ext][hl7:subject/hl7:annotatedAct/hl7:id/@root = $record-OID]">
                                                        <xsl:call-template name="Profile_RecordNote">
                                                            <xsl:with-param name="requestMsg" select="$requestMsg"/>
                                                            <xsl:with-param name="Record" select="$profileItem"/>
                                                        </xsl:call-template>
                                                    </xsl:for-each>
                                                </xsl:when>
                                                <xsl:when test="$requestMsg/descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:reactionObservationEvent[hl7:id/@extension = $record-ext][hl7:id/@root = $record-OID]">
                                                    <!-- update reaction items. -->
                                                    <xsl:for-each select="$requestMsg/descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:reactionObservationEvent[hl7:id/@extension = $record-ext][hl7:id/@root = $record-OID]">
                                                        <xsl:call-template name="Profile_Reaction">
                                                            <xsl:with-param name="requestMsg" select="$requestMsg"/>
                                                            <xsl:with-param name="Profile" select="$profile"/>
                                                            <xsl:with-param name="currentReaction" select="$profileItem"/>
                                                            <xsl:with-param name="description" select="$profileItem/@description"/>
                                                        </xsl:call-template>
                                                    </xsl:for-each>
                                                </xsl:when>
                                                <xsl:when test="$requestMsg/descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:immunization[hl7:id/@extension = $record-ext][hl7:id/@root = $record-OID]">
                                                    <!-- update immunization items. -->
                                                    <xsl:for-each select="$requestMsg/descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:immunization[hl7:id/@extension = $record-ext][hl7:id/@root = $record-OID]">
                                                        <xsl:call-template name="Profile_Immunization">
                                                            <xsl:with-param name="requestMsg" select="$requestMsg"/>
                                                            <xsl:with-param name="Profile" select="$profile"/>
                                                            <xsl:with-param name="currentImmunization" select="$profileItem"/>
                                                            <xsl:with-param name="description" select="$profileItem/@description"/>
                                                        </xsl:call-template>
                                                    </xsl:for-each>
                                                </xsl:when>
                                                <xsl:when test="$requestMsg/descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:commonObservationEvent[hl7:id/@extension = $record-ext][hl7:id/@root = $record-OID]">
                                                    <!-- update Observation items. -->
                                                    <xsl:for-each select="$requestMsg/descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:commonObservationEvent[hl7:id/@extension = $record-ext][hl7:id/@root = $record-OID]">
                                                        <xsl:call-template name="Profile_Observation">
                                                            <xsl:with-param name="requestMsg" select="$requestMsg"/>
                                                            <xsl:with-param name="Profile" select="$profile"/>
                                                            <xsl:with-param name="currentObservation" select="$profileItem"/>
                                                            <xsl:with-param name="description" select="$profileItem/@description"/>
                                                        </xsl:call-template>
                                                    </xsl:for-each>
                                                </xsl:when>
                                                <xsl:when test="$requestMsg/descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:medicalCondition[hl7:id/@extension = $record-ext][hl7:id/@root = $record-OID]">
                                                    <!-- update Observation items. -->
                                                    <xsl:for-each select="$requestMsg/descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:medicalCondition[hl7:id/@extension = $record-ext][hl7:id/@root = $record-OID]">
                                                        <xsl:call-template name="Profile_Condition">
                                                            <xsl:with-param name="requestMsg" select="$requestMsg"/>
                                                            <xsl:with-param name="Profile" select="$profile"/>
                                                            <xsl:with-param name="currentCondition" select="$profileItem"/>
                                                            <xsl:with-param name="description" select="$profileItem/@description"/>
                                                        </xsl:call-template>
                                                    </xsl:for-each>
                                                </xsl:when>
                                                <xsl:when test="$requestMsg/descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:otherMedication[hl7:id/@extension = $record-ext][hl7:id/@root = $record-OID]">
                                                    <!-- update Observation items. -->
                                                    <xsl:for-each select="$requestMsg/descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:otherMedication[hl7:id/@extension = $record-ext][hl7:id/@root = $record-OID]">
                                                        <xsl:call-template name="Profile_OtherMedication">
                                                            <xsl:with-param name="requestMsg" select="$requestMsg"/>
                                                            <xsl:with-param name="Profile" select="$profile"/>
                                                            <xsl:with-param name="currentOtherMedication" select="$profileItem"/>
                                                            <xsl:with-param name="description" select="$profileItem/@description"/>
                                                        </xsl:call-template>
                                                    </xsl:for-each>
                                                </xsl:when>
                                                <xsl:when test="$requestMsg/descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:procedureEvent[hl7:id/@extension = $record-ext][hl7:id/@root = $record-OID]">
                                                    <!-- update Observation items. -->
                                                    <xsl:for-each select="$requestMsg/descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:procedureEvent[hl7:id/@extension = $record-ext][hl7:id/@root = $record-OID]">
                                                        <xsl:call-template name="Profile_ProfessionalService">
                                                            <xsl:with-param name="requestMsg" select="$requestMsg"/>
                                                            <xsl:with-param name="Profile" select="$profile"/>
                                                            <xsl:with-param name="currentProfService" select="$profileItem"/>
                                                            <xsl:with-param name="description" select="$profileItem/@description"/>
                                                        </xsl:call-template>
                                                    </xsl:for-each>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:copy-of select="."/>
                                                </xsl:otherwise>
                                            </xsl:choose>

                                        </xsl:for-each>


                                        <xsl:for-each select="$requestMsg/descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:intoleranceCondition[not(hl7:id)]">
                                            <xsl:call-template name="Profile_Allergy">
                                                <xsl:with-param name="requestMsg" select="$requestMsg"/>
                                                <xsl:with-param name="Profile" select="$profile"/>
                                                <xsl:with-param name="description">Allergy(NEW_ITEM)</xsl:with-param>
                                            </xsl:call-template>
                                        </xsl:for-each>
                                        <xsl:for-each select="$requestMsg/descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:combinedMedicationRequest[not(hl7:id)]">
                                            <xsl:call-template name="Profile_Prescription">
                                                <xsl:with-param name="requestMsg" select="$requestMsg"/>
                                                <xsl:with-param name="Profile" select="$profile"/>
                                                <xsl:with-param name="description">Prescription(NEW_ITEM)</xsl:with-param>
                                            </xsl:call-template>
                                        </xsl:for-each>
                                        <xsl:for-each select="$requestMsg/descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:medicationDispense">
                                            <xsl:call-template name="Profile_Dispense">
                                                <xsl:with-param name="requestMsg" select="$requestMsg"/>
                                                <xsl:with-param name="Profile" select="$profile"/>
                                                <xsl:with-param name="description">Dispense(NEW_ITEM)</xsl:with-param>
                                            </xsl:call-template>
                                            <xsl:if test="not(descendant-or-self::hl7:inFulfillmentOf/hl7:substanceAdministrationRequest/hl7:id/@extension)">
                                                <xsl:call-template name="Profile_InferredPrescription">
                                                    <xsl:with-param name="requestMsg" select="$requestMsg"/>
                                                    <xsl:with-param name="description">Prescription(INFERRED_ITEM)</xsl:with-param>
                                                </xsl:call-template>
                                            </xsl:if>
                                        </xsl:for-each>
                                        <xsl:for-each select="$requestMsg/descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:reactionObservationEvent[not(hl7:id)]">
                                            <xsl:call-template name="Profile_Reaction">
                                                <xsl:with-param name="requestMsg" select="$requestMsg"/>
                                                <xsl:with-param name="Profile" select="$profile"/>
                                                <xsl:with-param name="description">Reaction(NEW_ITEM)</xsl:with-param>
                                            </xsl:call-template>
                                        </xsl:for-each>
                                        <xsl:for-each select="$requestMsg/descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:immunization[not(hl7:id)]">
                                            <xsl:call-template name="Profile_Immunization">
                                                <xsl:with-param name="requestMsg" select="$requestMsg"/>
                                                <xsl:with-param name="Profile" select="$profile"/>
                                                <xsl:with-param name="description">Immunization(NEW_ITEM)</xsl:with-param>
                                            </xsl:call-template>
                                        </xsl:for-each>
                                        <xsl:for-each select="$requestMsg/descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:commonObservationEvent[not(hl7:id)]">
                                            <xsl:call-template name="Profile_Observation">
                                                <xsl:with-param name="requestMsg" select="$requestMsg"/>
                                                <xsl:with-param name="Profile" select="$profile"/>
                                                <xsl:with-param name="description">Observation(NEW_ITEM)</xsl:with-param>
                                            </xsl:call-template>
                                        </xsl:for-each>
                                        <xsl:for-each select="$requestMsg/descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:medicalCondition[not(hl7:id)]">
                                            <xsl:call-template name="Profile_Condition">
                                                <xsl:with-param name="requestMsg" select="$requestMsg"/>
                                                <xsl:with-param name="Profile" select="$profile"/>
                                                <xsl:with-param name="description">Condition(NEW_ITEM)</xsl:with-param>
                                            </xsl:call-template>
                                        </xsl:for-each>
                                        <xsl:for-each select="$requestMsg/descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:otherMedication[not(hl7:id)]">
                                            <xsl:call-template name="Profile_OtherMedication">
                                                <xsl:with-param name="requestMsg" select="$requestMsg"/>
                                                <xsl:with-param name="Profile" select="$profile"/>
                                                <xsl:with-param name="description">otherMedication(NEW_ITEM)</xsl:with-param>
                                            </xsl:call-template>
                                        </xsl:for-each>
                                        <xsl:for-each select="$requestMsg/descendant-or-self::hl7:controlActProcess/hl7:subject/hl7:paymentRequest">
                                            <xsl:call-template name="Profile_Invoice">
                                                <xsl:with-param name="requestMsg" select="$requestMsg"/>
                                                <xsl:with-param name="Profile" select="$profile"/>
                                                <xsl:with-param name="description">Invoice(NEW_ITEM)</xsl:with-param>
                                            </xsl:call-template>
                                        </xsl:for-each>
                                        <xsl:for-each select="$requestMsg/descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:procedureEvent[not(hl7:id)]">
                                            <xsl:call-template name="Profile_ProfessionalService">
                                                <xsl:with-param name="requestMsg" select="$requestMsg"/>
                                                <xsl:with-param name="Profile" select="$profile"/>
                                                <xsl:with-param name="description">ProfService(NEW_ITEM)</xsl:with-param>
                                            </xsl:call-template>
                                        </xsl:for-each>
                                        <xsl:for-each select="$requestMsg/descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:annotation[not(hl7:id)]">
                                            <xsl:call-template name="Profile_PatientNote">
                                                <xsl:with-param name="requestMsg" select="$requestMsg"/>
                                                <xsl:with-param name="Profile" select="$profile"/>
                                                <xsl:with-param name="description">Annotation(NEW_ITEM)</xsl:with-param>
                                            </xsl:call-template>
                                        </xsl:for-each>

                                    </items>
                                </medicalProfile>
                            </medicalProfiles>
                        </xsl:when>
                        <xsl:when test="$elementName = 'allergies' ">
                            <allergies>
                                <xsl:copy-of select="$TestDataXml/configuration/testData/allergies/*"/>
                                <xsl:for-each select="$requestMsg/descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:intoleranceCondition[1]">
                                    <xsl:comment>generated item</xsl:comment>
                                    <xsl:call-template name="NewAllergy">
                                        <xsl:with-param name="description">Allergy(NEW_ITEM)</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:for-each>
                            </allergies>
                        </xsl:when>
                        <xsl:when test="$elementName = 'prescriptions' ">
                            <prescriptions>
                                <xsl:copy-of select="$TestDataXml/configuration/testData/prescriptions/*"/>
                                <xsl:for-each select="$requestMsg/descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:combinedMedicationRequest[1]">
                                    <xsl:comment>generated item</xsl:comment>
                                    <xsl:call-template name="NewPrescription">
                                        <xsl:with-param name="description">Prescription(NEW_ITEM)</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:for-each>
                                <xsl:for-each select="$requestMsg/descendant-or-self::hl7:subject/descendant-or-self::hl7:medicationDispense[1][ not(descendant-or-self::hl7:inFulfillmentOf/hl7:substanceAdministrationRequest/hl7:id/@extension)]">
                                    <xsl:call-template name="NewInferredPrescription">
                                        <xsl:with-param name="requestMsg" select="$requestMsg"/>
                                        <xsl:with-param name="description">Prescription(INFERRED_ITEM)</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:for-each>
                            </prescriptions>
                        </xsl:when>
                        <xsl:when test="$elementName = 'dispenses' ">
                            <dispenses>
                                <xsl:copy-of select="$TestDataXml/configuration/testData/dispenses/*"/>
                                <xsl:for-each select="$requestMsg/descendant-or-self::hl7:subject/descendant-or-self::hl7:medicationDispense[1]">
                                    <xsl:comment>generated item</xsl:comment>
                                    <xsl:call-template name="NewDispense">
                                        <xsl:with-param name="description">Dispense(NEW_ITEM)</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:for-each>
                            </dispenses>
                        </xsl:when>
                        <xsl:when test="$elementName='reactions' ">
                            <reactions>
                                <xsl:copy-of select="$TestDataXml/configuration/testData/reactions/*"/>
                                <xsl:for-each select="$requestMsg/descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:reactionObservationEvent[1]">
                                    <xsl:comment>generated item</xsl:comment>
                                    <xsl:call-template name="NewReaction">
                                        <xsl:with-param name="description">Reaction(NEW_ITEM)</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:for-each>
                            </reactions>
                        </xsl:when>
                        <xsl:when test="$elementName='immunizations' ">
                            <immunizations>
                                <xsl:copy-of select="$TestDataXml/configuration/testData/immunizations/*"/>
                                <xsl:for-each select="$requestMsg/descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:immunization[1]">
                                    <xsl:comment>generated item</xsl:comment>
                                    <xsl:call-template name="NewImmunization">
                                        <xsl:with-param name="description">Immunization(NEW_ITEM)</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:for-each>
                            </immunizations>
                        </xsl:when>
                        <xsl:when test="$elementName='observations' ">
                            <observations>
                                <xsl:copy-of select="$TestDataXml/configuration/testData/observations/*"/>
                                <xsl:for-each select="$requestMsg/descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:commonObservationEvent[1]">
                                    <xsl:comment>generated item</xsl:comment>
                                    <xsl:call-template name="NewObservation">
                                        <xsl:with-param name="description">Observation(NEW_ITEM)</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:for-each>
                            </observations>
                        </xsl:when>
                        <xsl:when test="$elementName='conditions' ">
                            <conditions>
                                <xsl:copy-of select="$TestDataXml/configuration/testData/conditions/*"/>
                                <xsl:for-each select="$requestMsg/descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:medicalCondition[1]">
                                    <xsl:comment>generated item</xsl:comment>
                                    <xsl:call-template name="NewCondition">
                                        <xsl:with-param name="description">Condition(NEW_ITEM)</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:for-each>
                            </conditions>
                        </xsl:when>
                        <xsl:when test="$elementName='otherMedications' ">
                            <otherMedications>
                                <xsl:copy-of select="$TestDataXml/configuration/testData/otherMedications/*"/>
                                <xsl:for-each select="$requestMsg/descendant-or-self::hl7:controlActEvent/hl7:subject/hl7:otherMedication[1]">
                                    <xsl:comment>generated item</xsl:comment>
                                    <xsl:call-template name="NewOtherMedication">
                                        <xsl:with-param name="description">otherMedication(NEW_ITEM)</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:for-each>
                            </otherMedications>
                        </xsl:when>
                        <xsl:when test="$elementName = 'drugs' ">
                            <drugs>
                                <xsl:copy-of select="$TestDataXml/configuration/testData/drugs/*"/>
                                <xsl:for-each select="$requestMsg/descendant-or-self::hl7:player">
                                    <xsl:variable name="drug-description">
                                        <xsl:call-template name="getDrugDescription">
                                            <xsl:with-param name="medication" select="."/>
                                        </xsl:call-template>
                                    </xsl:variable>
                                    <xsl:if test="not($TestDataXml/configuration/testData/drugs/drug[@description = $drug-description])">
                                        <xsl:call-template name="NewDrug">
                                            <xsl:with-param name="node" select="."/>
                                            <xsl:with-param name="description" select="$drug-description"/>
                                        </xsl:call-template>
                                    </xsl:if>
                                </xsl:for-each>
                            </drugs>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:copy-of select="."/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </testData>
            <xsl:copy-of select="$TestDataXml/configuration/*[not(name() = 'testData')]"/>
        </configuration>
    </xsl:template>

    <xsl:template name="codeElements">
        <xsl:param name="node"/>

        <xsl:if test="$node/@code">
            <xsl:attribute name="code">
                <xsl:value-of select="$node/@code"/>
            </xsl:attribute>
        </xsl:if>

        <xsl:if test="$node/@codeSystem">
            <xsl:attribute name="codeSystem">
                <xsl:variable name="codeSystem" select="$node/@codeSystem"/>
                <xsl:choose>
                    <xsl:when test="$messageType = 'server'">
                        <xsl:value-of select="local-name($OID_root/*[@server = $codeSystem])"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="local-name($OID_root/*[@client = $codeSystem])"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
        </xsl:if>

    </xsl:template>
    <xsl:template name="authorName">
        <xsl:param name="node"/>
        <xsl:variable name="ID" select="$node/@root"/>
        <xsl:variable name="Extension" select="$node/@extension"/>
        <xsl:variable name="providerType">
            <xsl:choose>
                <xsl:when test="$messageType = 'server'">
                    <xsl:value-of select="name($OID_root/*[@server = $ID])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="name($OID_root/*[@client = $ID])"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:attribute name="description">
            <xsl:choose>
                <xsl:when test="$messageType = 'server'">
                    <xsl:value-of select="$TestData/providers/provider[@OID = $providerType][server/id/@extension = $Extension]/@description"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$TestData/providers/provider[@OID = $providerType][client/id/@extension = $Extension]/@description"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>
    <xsl:template name="locationName">
        <xsl:param name="node"/>
        <xsl:variable name="ID" select="$node/@root"/>
        <xsl:variable name="Extension" select="$node/@extension"/>
        <xsl:variable name="locationType">
            <xsl:choose>
                <xsl:when test="$messageType = 'server'">
                    <xsl:value-of select="name($OID_root/*[@server = $ID])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="name($OID_root/*[@client = $ID])"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:attribute name="description">
            <xsl:choose>
                <xsl:when test="$messageType = 'server'">
                    <xsl:value-of select="$TestData/serviceDeliveryLocations/location[@OID = $locationType][server/id/@extension = $Extension]/@description"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$TestData/serviceDeliveryLocations/location[@OID = $locationType][client/id/@extension = $Extension]/@description"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>
    <xsl:template name="payeeName">
        <xsl:param name="node"/>
        <xsl:variable name="ID" select="$node/@root"/>
        <xsl:variable name="Extension" select="$node/@extension"/>
        <xsl:variable name="payeeType">
            <xsl:choose>
                <xsl:when test="$messageType = 'server'">
                    <xsl:value-of select="name($OID_root/*[@server = $ID])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="name($OID_root/*[@client = $ID])"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:attribute name="description">
            <xsl:choose>
                <xsl:when test="$messageType = 'server'">
                    <xsl:value-of select="$TestData/*[self::providers or self::serviceDeliveryLocations]/*[@OID = $payeeType][server/id/@extension = $Extension]/@description"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$TestData/*[self::providers or self::serviceDeliveryLocations]/*[@OID = $payeeType][client/id/@extension = $Extension]/@description"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>


    <!-- call template from with-in intoleranceCondition  -->
    <xsl:template name="NewAllergy">
        <xsl:param name="description"/>
        <allergy description="">
            <xsl:attribute name="description">
                <xsl:value-of select="$description"/>
            </xsl:attribute>
            <code code="EALG" codeSystem="ACTCODE">
                <xsl:call-template name="codeElements">
                    <xsl:with-param name="node" select="hl7:code"/>
                </xsl:call-template>
            </code>
            <value codeSystem="ENTITYCODE" code="NDA01">
                <xsl:call-template name="codeElements">
                    <xsl:with-param name="node" select="hl7:value"/>
                </xsl:call-template>
            </value>
        </allergy>
    </xsl:template>
    <xsl:template name="Profile_Allergy">
        <xsl:param name="requestMsg"/>
        <xsl:param name="currentAllergy"/>
        <xsl:param name="Profile"/>
        <xsl:param name="description"/>

        <allergy description="">
            <xsl:attribute name="description">
                <xsl:value-of select="$description"/>
            </xsl:attribute>



            <record-id root_OID="DIS_ALLERGY_ID">
                <xsl:call-template name="getRecordID">
                    <xsl:with-param name="TdataNode" select="$currentAllergy"/>
                    <xsl:with-param name="hl7Node" select="hl7:id"/>
                    <xsl:with-param name="default-OID">DIS_ALLERGY_ID</xsl:with-param>
                </xsl:call-template>

            </record-id>

            <xsl:call-template name="createRecordIdentifiers">
                <xsl:with-param name="requestMsg" select="$requestMsg"/>
            </xsl:call-template>

            <statusCode code="active">
                <xsl:call-template name="codeElements">
                    <xsl:with-param name="node" select="hl7:statusCode"/>
                </xsl:call-template>
            </statusCode>
            <xsl:if test="hl7:effectiveTime">
                <xsl:call-template name="Time">
                    <xsl:with-param name="elementName">effectiveTime</xsl:with-param>
                    <xsl:with-param name="node" select="hl7:effectiveTime"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="hl7:uncertaintyCode/@code">
                <uncertaintyCode code="U">
                    <xsl:call-template name="codeElements">
                        <xsl:with-param name="node" select="hl7:uncertaintyCode"/>
                    </xsl:call-template>
                </uncertaintyCode>
            </xsl:if>
            <xsl:if test="hl7:subjectOf2/hl7:severityObservation/hl7:value/@code">
                <severity code="L">
                    <xsl:call-template name="codeElements">
                        <xsl:with-param name="node" select="hl7:subjectOf2/hl7:severityObservation/hl7:value"/>
                    </xsl:call-template>
                </severity>
            </xsl:if>
            <xsl:for-each select="descendant-or-self::hl7:allergyTestEvent">
                <allergytest description="generated Test">
                    <xsl:if test="hl7:id">
                        <record-id>
                            <xsl:call-template name="getRecordID">
                                <xsl:with-param name="node" select="hl7:id"/>
                                <xsl:with-param name="default-OID">DIS_ALLERGY_TEST_ID</xsl:with-param>
                            </xsl:call-template>
                        </record-id>
                    </xsl:if>
                    <!-- required element for a coded value denoting the type of allergy test conducted. ObservationAllergyTestType vocab -->
                    <code code="1234">
                        <xsl:call-template name="codeElements">
                            <xsl:with-param name="node" select="hl7:code"/>
                        </xsl:call-template>
                    </code>
                    <!-- required element with default value - status code is now everywhere -->
                    <statusCode code="completed">
                        <xsl:call-template name="codeElements">
                            <xsl:with-param name="node" select="hl7:statusCode"/>
                        </xsl:call-template>
                    </statusCode>
                    <!-- optional element for the date on which the allergy test was performed -->
                    <xsl:if test="hl7:effectiveTime">
                        <xsl:call-template name="Time">
                            <xsl:with-param name="elementName">effectiveTime</xsl:with-param>
                            <xsl:with-param name="node" select="hl7:effectiveTime"/>
                        </xsl:call-template>
                    </xsl:if>
                    <!-- optional element for a coded value denoting the result of the allergy test - AllergyTestValue vocab. -->
                    <xsl:if test="hl7:value">
                        <value code="A3">
                            <xsl:call-template name="codeElements">
                                <xsl:with-param name="node" select="hl7:value"/>
                            </xsl:call-template>
                        </value>
                    </xsl:if>
                </allergytest>
            </xsl:for-each>
            <xsl:for-each select="descendant-or-self::hl7:causalityAssessment">
                <xsl:call-template name="exposure">
                    <xsl:with-param name="Profile" select="$Profile"/>
                </xsl:call-template>
            </xsl:for-each>

            <xsl:for-each select="descendant-or-self::hl7:annotation[1]">
                <xsl:call-template name="createNote">
                    <xsl:with-param name="requestMsg" select="$requestMsg"/>
                    <xsl:with-param name="noteNode" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:if test="$currentAllergy">
                <xsl:for-each select="$currentAllergy/exposure">
                    <xsl:copy-of select="."/>
                </xsl:for-each>
                <xsl:for-each select="$currentAllergy/note">
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </xsl:if>

        </allergy>
    </xsl:template>

    <xsl:template name="NewReaction">
        <xsl:param name="description"/>
        <reaction description="">
            <xsl:attribute name="description">
                <xsl:value-of select="$description"/>
            </xsl:attribute>
            <xsl:if test="hl7:text">
                <text>
                    <xsl:value-of select="hl7:text"/>
                </text>
            </xsl:if>
            <value>
                <xsl:call-template name="codeElements">
                    <xsl:with-param name="node" select="hl7:value"/>
                </xsl:call-template>
            </value>
        </reaction>
    </xsl:template>
    <xsl:template name="Profile_Reaction">
        <xsl:param name="requestMsg"/>
        <xsl:param name="currentReaction"/>
        <xsl:param name="Profile"/>
        <xsl:param name="description"/>

        <reaction description="">
            <xsl:attribute name="description">
                <xsl:value-of select="$description"/>
            </xsl:attribute>

            <record-id root_OID="DIS_REACTION_ID">
                <xsl:call-template name="getRecordID">
                    <xsl:with-param name="TdataNode" select="$currentReaction"/>
                    <xsl:with-param name="hl7Node" select="hl7:id"/>
                    <xsl:with-param name="default-OID">DIS_REACTION_ID</xsl:with-param>
                </xsl:call-template>
            </record-id>

            <xsl:call-template name="createRecordIdentifiers">
                <xsl:with-param name="requestMsg" select="$requestMsg"/>
            </xsl:call-template>

            <xsl:if test="hl7:effectiveTime">
                <xsl:call-template name="Time">
                    <xsl:with-param name="elementName">effectiveTime</xsl:with-param>
                    <xsl:with-param name="node" select="hl7:effectiveTime"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="hl7:*/hl7:severityObservation/hl7:value/@code">
                <severity code="L">
                    <xsl:call-template name="codeElements">
                        <xsl:with-param name="node" select="hl7:*/hl7:severityObservation/hl7:value[1]"/>
                    </xsl:call-template>
                </severity>
            </xsl:if>
            <xsl:for-each select="descendant-or-self::hl7:annotation[1]">
                <xsl:call-template name="createNote">
                    <xsl:with-param name="requestMsg" select="$requestMsg"/>
                    <xsl:with-param name="noteNode" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:if test="$currentReaction">
                <xsl:for-each select="$currentReaction/exposure">
                    <xsl:copy-of select="."/>
                </xsl:for-each>
                <xsl:for-each select="$currentReaction/note">
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </xsl:if>
            <xsl:for-each select="descendant-or-self::hl7:causalityAssessment">
                <xsl:call-template name="exposure">
                    <xsl:with-param name="Profile" select="$Profile"/>
                </xsl:call-template>
            </xsl:for-each>
        </reaction>
    </xsl:template>

    <xsl:template name="NewImmunization">
        <xsl:param name="description"/>
        <immunization description="">
            <xsl:attribute name="description">
                <xsl:value-of select="$description"/>
            </xsl:attribute>
            <xsl:if test="hl7:reasonCode">
                <reasonCode>
                    <xsl:call-template name="codeElements">
                        <xsl:with-param name="node" select="hl7:reasonCode"/>
                    </xsl:call-template>
                </reasonCode>
            </xsl:if>
            <routeCode>
                <xsl:call-template name="codeElements">
                    <xsl:with-param name="node" select="hl7:routeCode"/>
                </xsl:call-template>
            </routeCode>
            <approachSiteCode>
                <xsl:call-template name="codeElements">
                    <xsl:with-param name="node" select="hl7:approachSiteCode"/>
                </xsl:call-template>
            </approachSiteCode>
            <doseQuantity>
                <xsl:attribute name="value">
                    <xsl:value-of select="hl7:doseQuantity/@value"/>
                </xsl:attribute>
                <xsl:attribute name="unit">
                    <xsl:value-of select="hl7:doseQuantity/@unit"/>
                </xsl:attribute>
            </doseQuantity>
            <drug>
                <xsl:attribute name="description">
                    <xsl:call-template name="getDrugDescription">
                        <xsl:with-param name="medication" select="descendant-or-self::hl7:player[1]"/>
                    </xsl:call-template>
                </xsl:attribute>
            </drug>
        </immunization>
    </xsl:template>
    <xsl:template name="Profile_Immunization">
        <xsl:param name="requestMsg"/>
        <xsl:param name="currentImmunization"/>
        <xsl:param name="Profile"/>
        <xsl:param name="description"/>

        <immunization description="">
            <xsl:attribute name="description">
                <xsl:value-of select="$description"/>
            </xsl:attribute>

            <record-id root_OID="DIS_IMMUNIZATION_ID">
                <xsl:call-template name="getRecordID">
                    <xsl:with-param name="TdataNode" select="$currentImmunization"/>
                    <xsl:with-param name="hl7Node" select="hl7:id"/>
                    <xsl:with-param name="default-OID">DIS_IMMUNIZATION_ID</xsl:with-param>
                </xsl:call-template>
            </record-id>

            <xsl:call-template name="createRecordIdentifiers">
                <xsl:with-param name="requestMsg" select="$requestMsg"/>
            </xsl:call-template>
            <xsl:if test="hl7:effectiveTime">
                <xsl:call-template name="Time">
                    <xsl:with-param name="elementName">effectiveTime</xsl:with-param>
                    <xsl:with-param name="node" select="hl7:effectiveTime"/>
                </xsl:call-template>
            </xsl:if>


            <xsl:if test="hl7:inFulfillmentOf">
                <immunizationPlan>
                    <xsl:attribute name="type">
                        <xsl:choose>
                            <xsl:when test="descendant-or-self::hl7:nextPlannedImmunization">fulfillment</xsl:when>
                            <xsl:otherwise>successor</xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:if test="hl7:inFulfillmentOf/descendant-or-self::hl7:subsetCode/@code">
                        <subsetCode>
                            <xsl:call-template name="codeElements">
                                <xsl:with-param name="node" select="hl7:inFulfillmentOf/descendant-or-self::hl7:subsetCode"/>
                            </xsl:call-template>
                        </subsetCode>
                    </xsl:if>

                    <sequenceNumber>
                        <xsl:attribute name="value">
                            <xsl:value-of select="hl7:inFulfillmentOf/hl7:sequenceNumber/@value"/>
                        </xsl:attribute>
                    </sequenceNumber>
                    <xsl:if test="hl7:inFulfillmentOf/descendant-or-self::hl7:effectiveTime">
                        <xsl:call-template name="Time">
                            <xsl:with-param name="elementName">effectiveTime</xsl:with-param>
                            <xsl:with-param name="node" select="hl7:inFulfillmentOf/descendant-or-self::hl7:effectiveTime[1]"/>
                        </xsl:call-template>
                    </xsl:if>
                </immunizationPlan>
            </xsl:if>
            <xsl:if test="descendant-or-self::hl7:adverseReactionObservationEvent">
                <reaction/>
            </xsl:if>

            <xsl:for-each select="descendant-or-self::hl7:annotation[1]">
                <xsl:call-template name="createNote">
                    <xsl:with-param name="requestMsg" select="$requestMsg"/>
                    <xsl:with-param name="noteNode" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:if test="$currentImmunization">
                <xsl:for-each select="$currentImmunization/note">
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </xsl:if>
            <!-- todo: add issues -->
        </immunization>
    </xsl:template>

    <xsl:template name="NewObservation">
        <xsl:param name="description"/>
        <observation description="">
            <xsl:attribute name="description">
                <xsl:value-of select="$description"/>
            </xsl:attribute>

            <code>
                <xsl:call-template name="codeElements">
                    <xsl:with-param name="node" select="hl7:code"/>
                </xsl:call-template>
            </code>
            <xsl:if test="hl7:effectiveTime">
                <xsl:call-template name="Time">
                    <xsl:with-param name="elementName">effectiveTime</xsl:with-param>
                    <xsl:with-param name="node" select="hl7:effectiveTime"/>
                </xsl:call-template>
            </xsl:if>
            <value>
                <xsl:attribute name="value">
                    <xsl:value-of select="hl7:value/@value"/>
                </xsl:attribute>
                <xsl:attribute name="unit">
                    <xsl:value-of select="hl7:value/@unit"/>
                </xsl:attribute>
            </value>
            <xsl:for-each select="descendant-or-self::hl7:subObservationEvent[position() &lt;=2]">
                <subObservation>
                    <code>
                        <xsl:call-template name="codeElements">
                            <xsl:with-param name="node" select="hl7:code"/>
                        </xsl:call-template>
                    </code>
                    <value>
                        <xsl:attribute name="value">
                            <xsl:value-of select="hl7:value/@value"/>
                        </xsl:attribute>
                        <xsl:attribute name="unit">
                            <xsl:value-of select="hl7:value/@unit"/>
                        </xsl:attribute>
                    </value>
                </subObservation>
            </xsl:for-each>
        </observation>
    </xsl:template>
    <xsl:template name="Profile_Observation">
        <xsl:param name="requestMsg"/>
        <xsl:param name="currentObservation"/>
        <xsl:param name="Profile"/>
        <xsl:param name="description"/>

        <observation description="">
            <xsl:attribute name="description">
                <xsl:value-of select="$description"/>
            </xsl:attribute>

            <record-id root_OID="DIS_IMMUNIZATION_ID">
                <xsl:call-template name="getRecordID">
                    <xsl:with-param name="TdataNode" select="$currentObservation"/>
                    <xsl:with-param name="hl7Node" select="hl7:id"/>
                    <xsl:with-param name="default-OID">DIS_IMMUNIZATION_ID</xsl:with-param>
                </xsl:call-template>
            </record-id>

            <xsl:call-template name="createRecordIdentifiers">
                <xsl:with-param name="requestMsg" select="$requestMsg"/>
            </xsl:call-template>

            <xsl:for-each select="descendant-or-self::hl7:annotation[1]">
                <xsl:call-template name="createNote">
                    <xsl:with-param name="requestMsg" select="$requestMsg"/>
                    <xsl:with-param name="noteNode" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:if test="$currentObservation">
                <xsl:for-each select="$currentObservation/note">
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </xsl:if>
        </observation>
    </xsl:template>

    <xsl:template name="NewCondition">
        <xsl:param name="description"/>
        <condition description="">
            <xsl:attribute name="description">
                <xsl:value-of select="$description"/>
            </xsl:attribute>
            <value>
                <xsl:call-template name="codeElements">
                    <xsl:with-param name="node" select="hl7:value"/>
                </xsl:call-template>
            </value>
        </condition>
    </xsl:template>
    <xsl:template name="Profile_Condition">
        <xsl:param name="requestMsg"/>
        <xsl:param name="currentCondition"/>
        <xsl:param name="Profile"/>
        <xsl:param name="description"/>

        <condition description="">
            <xsl:attribute name="description">
                <xsl:value-of select="$description"/>
            </xsl:attribute>

            <record-id root_OID="DIS_MEDICAL_CONDITION_ID">
                <xsl:call-template name="getRecordID">
                    <xsl:with-param name="TdataNode" select="$currentCondition"/>
                    <xsl:with-param name="hl7Node" select="hl7:id"/>
                    <xsl:with-param name="default-OID">DIS_MEDICAL_CONDITION_ID</xsl:with-param>
                </xsl:call-template>
            </record-id>
            <statusCode>
                <xsl:call-template name="codeElements">
                    <xsl:with-param name="node" select="hl7:statusCode"/>
                </xsl:call-template>
            </statusCode>
            <xsl:if test="hl7:effectiveTime">
                <xsl:call-template name="Time">
                    <xsl:with-param name="elementName">effectiveTime</xsl:with-param>
                    <xsl:with-param name="node" select="hl7:effectiveTime"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:call-template name="createRecordIdentifiers">
                <xsl:with-param name="requestMsg" select="$requestMsg"/>
            </xsl:call-template>
            <xsl:if test="descendant-or-self::hl7:chronicIndicator">
                <chronic/>
            </xsl:if>

            <xsl:for-each select="descendant-or-self::hl7:annotation[1]">
                <xsl:call-template name="createNote">
                    <xsl:with-param name="requestMsg" select="$requestMsg"/>
                    <xsl:with-param name="noteNode" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:if test="$currentCondition">
                <xsl:for-each select="$currentCondition/note">
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </xsl:if>
        </condition>
    </xsl:template>

    <xsl:template name="NewOtherMedication">
        <xsl:param name="description"/>
        <otherMedication description="">
            <xsl:attribute name="description">
                <xsl:value-of select="$description"/>
            </xsl:attribute>
            <xsl:if test="hl7:routeCode">
                <routeCode>
                    <xsl:call-template name="codeElements">
                        <xsl:with-param name="node" select="hl7:routeCode"/>
                    </xsl:call-template>
                </routeCode>
            </xsl:if>
            <drug>
                <xsl:attribute name="description">
                    <xsl:call-template name="getDrugDescription">
                        <xsl:with-param name="medication" select="descendant-or-self::hl7:player[1]"/>
                    </xsl:call-template>
                </xsl:attribute>
            </drug>
            <xsl:for-each select="descendant-or-self::hl7:dosageInstruction">
                <xsl:call-template name="dosageInstruction"/>
            </xsl:for-each>
        </otherMedication>
    </xsl:template>
    <xsl:template name="Profile_OtherMedication">
        <xsl:param name="requestMsg"/>
        <xsl:param name="currentOtherMedication"/>
        <xsl:param name="Profile"/>
        <xsl:param name="description"/>

        <otherMedication description="">
            <xsl:attribute name="description">
                <xsl:value-of select="$description"/>
            </xsl:attribute>

            <record-id root_OID="DIS_OTHER_ACTIVE_MED_ID">
                <xsl:call-template name="getRecordID">
                    <xsl:with-param name="TdataNode" select="$currentOtherMedication"/>
                    <xsl:with-param name="hl7Node" select="hl7:id"/>
                    <xsl:with-param name="default-OID">DIS_OTHER_ACTIVE_MED_ID</xsl:with-param>
                </xsl:call-template>
            </record-id>
            <statusCode>
                <xsl:call-template name="codeElements">
                    <xsl:with-param name="node" select="hl7:statusCode"/>
                </xsl:call-template>
            </statusCode>
            <xsl:if test="hl7:effectiveTime">
                <xsl:call-template name="Time">
                    <xsl:with-param name="elementName">effectiveTime</xsl:with-param>
                    <xsl:with-param name="node" select="hl7:effectiveTime"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:call-template name="createRecordIdentifiers">
                <xsl:with-param name="requestMsg" select="$requestMsg"/>
            </xsl:call-template>

            <xsl:for-each select="descendant-or-self::hl7:annotation[1]">
                <xsl:call-template name="createNote">
                    <xsl:with-param name="requestMsg" select="$requestMsg"/>
                    <xsl:with-param name="noteNode" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:if test="$currentOtherMedication">
                <xsl:for-each select="$currentOtherMedication/note">
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </xsl:if>
        </otherMedication>
    </xsl:template>

    <xsl:template name="NewPrescription">
        <xsl:param name="description"/>
        <prescription>
            <xsl:attribute name="description">
                <xsl:value-of select="$description"/>
            </xsl:attribute>

            <statusCode code="active">
                <xsl:call-template name="codeElements">
                    <xsl:with-param name="node" select="hl7:statusCode"/>
                </xsl:call-template>
            </statusCode>
            <confidentialityCode code="NORMAL">
                <xsl:call-template name="codeElements">
                    <xsl:with-param name="node" select="hl7:confidentialityCode"/>
                </xsl:call-template>
            </confidentialityCode>

            <drug>
                <xsl:attribute name="description">
                    <xsl:call-template name="getDrugDescription">
                        <xsl:with-param name="medication" select="descendant-or-self::hl7:player[1]"/>
                    </xsl:call-template>
                </xsl:attribute>
            </drug>

            <xsl:for-each select="hl7:definition/hl7:substanceAdministrationDefinition">
                <substanceAdministrationDefinition>
                    <record-id>
                        <xsl:call-template name="getRecordID">
                            <xsl:with-param name="hl7Node" select="hl7:id"/>
                        </xsl:call-template>
                    </record-id>
                    <code>
                        <xsl:call-template name="codeElements">
                            <xsl:with-param name="node" select="hl7:code"/>
                        </xsl:call-template>
                    </code>
                </substanceAdministrationDefinition>
            </xsl:for-each>


            <xsl:for-each select="hl7:reason">
                <reason>
                    <xsl:variable name="reason" select="hl7:*[local-name() = 'observationDiagnosis' or local-name() = 'observationSymptom' or local-name() = 'otherIndication' ]"/>
                    <xsl:attribute name="type">
                        <xsl:value-of select="local-name($reason)"/>
                    </xsl:attribute>
                    <xsl:if test="$reason/@nullFlavor">
                        <xsl:attribute name="nullFlavor">
                            <xsl:value-of select="$reason/@nullFlavor"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$reason/text">
                        <text>
                            <xsl:value-of select="$reason/text"/>
                        </text>
                    </xsl:if>

                    <statusCode code="completed">
                        <xsl:if test="$reason/statusCode/@code and not($reason/statusCode/@code = '')">
                            <xsl:call-template name="codeElements">
                                <xsl:with-param name="node" select="$reason/statusCode"/>
                            </xsl:call-template>
                        </xsl:if>
                    </statusCode>
                    <xsl:choose>
                        <xsl:when test="$reason/value">
                            <value>
                                <xsl:call-template name="codeElements">
                                    <xsl:with-param name="node" select="$reason/value"/>
                                </xsl:call-template>
                            </value>
                        </xsl:when>
                        <xsl:when test="$reason/code">
                            <value>
                                <xsl:call-template name="codeElements">
                                    <xsl:with-param name="node" select="$reason/code"/>
                                </xsl:call-template>
                            </value>
                        </xsl:when>
                    </xsl:choose>

                    <xsl:if test="hl7:priorityNumber/@value">
                        <priorityNumber>
                            <xsl:attribute name="value">
                                <xsl:value-of select="hl7:priorityNumber/@value"/>
                            </xsl:attribute>
                        </priorityNumber>
                    </xsl:if>
                </reason>
            </xsl:for-each>

            <xsl:if test="hl7:precondition/hl7:verificationEventCriterion/hl7:code">
                <non-authoritative>
                    <xsl:call-template name="codeElements">
                        <xsl:with-param name="node" select="hl7:precondition/hl7:verificationEventCriterion/hl7:code"/>
                    </xsl:call-template>
                </non-authoritative>
            </xsl:if>

            <xsl:for-each select="hl7:pertinentInformation/hl7:quantityObservationEvent">
                <observation>
                    <code>
                        <xsl:call-template name="codeElements">
                            <xsl:with-param name="node" select="hl7:code"/>
                        </xsl:call-template>
                    </code>
                    <value>
                        <xsl:attribute name="value">
                            <xsl:value-of select="hl7:value/@value"/>
                        </xsl:attribute>
                        <xsl:attribute name="unit">
                            <xsl:value-of select="hl7:value/@unit"/>
                        </xsl:attribute>
                    </value>
                    <xsl:call-template name="Time">
                        <xsl:with-param name="node" select="hl7:effectiveTime"/>
                        <xsl:with-param name="elementName">effectiveTime</xsl:with-param>
                    </xsl:call-template>
                </observation>
            </xsl:for-each>

            <xsl:for-each select="descendant-or-self::hl7:dosageInstruction">
                <xsl:call-template name="dosageInstruction"/>
            </xsl:for-each>

            <xsl:if test="not(hl7:component2/negationInd = 'true' or hl7:component2/negationInd = 'TRUE')">
                <trialSupplycode code="TF"/>
            </xsl:if>

            <xsl:call-template name="Time">
                <xsl:with-param name="node" select="hl7:component3/hl7:supplyRequest/hl7:effectiveTime"/>
                <xsl:with-param name="elementName">effectiveTime</xsl:with-param>
            </xsl:call-template>

            <xsl:for-each select="hl7:component3/hl7:supplyRequest/hl7:receiver">
                <responsibleParty>
                    <xsl:if test="hl7:id">
                        <phn>
                            <xsl:call-template name="getRecordID">
                                <xsl:with-param name="hl7Node" select="hl7:id"/>
                            </xsl:call-template>
                        </phn>
                    </xsl:if>
                    <xsl:if test="hl7:code">
                        <relationship>
                            <xsl:call-template name="codeElements">
                                <xsl:with-param name="node" select="hl7:code"/>
                            </xsl:call-template>
                        </relationship>
                    </xsl:if>
                    <xsl:if test="hl7:telecom/@value">
                        <telecom>
                            <xsl:value-of select="hl7:telecom/@value"/>
                        </telecom>
                    </xsl:if>
                    <name>
                        <xsl:choose>
                            <xsl:when test="hl7:agentPerson/hl7:name[hl7:given][hl7:family]">
                                <xsl:value-of select="hl7:agentPerson/hl7:name/hl7:given"/>
                                <xsl:value-of select="hl7:agentPerson/hl7:name/hl7:family"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="hl7:agentPerson/hl7:name"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </name>
                </responsibleParty>
            </xsl:for-each>

            <xsl:for-each select="hl7:component3/hl7:supplyRequest/hl7:location">
                <xsl:if test="not(hl7:serviceDeliveryLocation/hl7:id/@nullFlavor)">
                    <pharmacylocation>
                        <xsl:if test="hl7:time/@value">
                            <xsl:attribute name="value">
                                <xsl:call-template name="changeDate">
                                    <xsl:with-param name="date" select="hl7:time/@value"/>
                                </xsl:call-template>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:call-template name="locationName">
                            <xsl:with-param name="node" select="hl7:serviceDeliveryLocation/hl7:id"/>
                        </xsl:call-template>
                        <xsl:if test="hl7:substitutionConditionCode">
                            <xsl:call-template name="codeElements">
                                <xsl:with-param name="node" select="hl7:substitutionConditionCode"/>
                            </xsl:call-template>
                        </xsl:if>
                    </pharmacylocation>
                </xsl:if>
            </xsl:for-each>


            <xsl:for-each select="hl7:component3/hl7:supplyRequest/hl7:component/hl7:supplyRequestItem">
                <supplyRequestItem>
                    <xsl:if test="hl7:quantity">
                        <quantity>
                            <xsl:attribute name="value">
                                <xsl:value-of select="hl7:quantity/@value"/>
                            </xsl:attribute>
                            <xsl:attribute name="unit">
                                <xsl:value-of select="hl7:quantity/@unit"/>
                            </xsl:attribute>
                        </quantity>
                    </xsl:if>
                    <xsl:call-template name="Time">
                        <xsl:with-param name="node" select="hl7:expectedUseTime"/>
                        <xsl:with-param name="elementName">expectedUseTime</xsl:with-param>
                    </xsl:call-template>

                    <xsl:if test="descendant-or-self::hl7:player">
                        <drug>
                            <xsl:attribute name="description">
                                <xsl:call-template name="getDrugDescription">
                                    <xsl:with-param name="medication" select="descendant-or-self::hl7:player[1]"/>
                                </xsl:call-template>
                            </xsl:attribute>
                        </drug>
                    </xsl:if>

                    <initialSupplyRequest>
                        <xsl:for-each select="descendant-or-self::hl7:initialSupplyRequest[1]">
                            <xsl:if test="hl7:effectiveTime">
                                <xsl:call-template name="Time">
                                    <xsl:with-param name="node" select="hl7:effectiveTime"/>
                                    <xsl:with-param name="elementName">effectiveTime</xsl:with-param>
                                </xsl:call-template>
                            </xsl:if>
                            <xsl:if test="hl7:repeatNumber/@value">
                                <repeatNumber>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="hl7:repeatNumber/@value"/>
                                    </xsl:attribute>
                                </repeatNumber>
                            </xsl:if>
                            <xsl:if test="hl7:quantity">
                                <quantity>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="hl7:quantity/@value"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="unit">
                                        <xsl:value-of select="hl7:quantity/@unit"/>
                                    </xsl:attribute>
                                </quantity>
                            </xsl:if>
                            <xsl:if test="hl7:expectedUseTime">
                                <xsl:call-template name="Time">
                                    <xsl:with-param name="node" select="hl7:expectedUseTime"/>
                                    <xsl:with-param name="elementName">expectedUseTime</xsl:with-param>
                                </xsl:call-template>
                            </xsl:if>
                        </xsl:for-each>
                    </initialSupplyRequest>
                    <subsequentSupplyRequest>
                        <xsl:for-each select="descendant-or-self::hl7:subsequentSupplyRequest[1]">
                            <xsl:if test="hl7:effectiveTime">
                                <xsl:call-template name="Time">
                                    <xsl:with-param name="node" select="hl7:effectiveTime"/>
                                    <xsl:with-param name="elementName">effectiveTime</xsl:with-param>
                                </xsl:call-template>
                            </xsl:if>
                            <xsl:if test="hl7:repeatNumber/@value">
                                <repeatNumber>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="hl7:repeatNumber/@value"/>
                                    </xsl:attribute>
                                </repeatNumber>
                            </xsl:if>
                            <xsl:if test="hl7:quantity">
                                <quantity>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="hl7:quantity/@value"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="unit">
                                        <xsl:value-of select="hl7:quantity/@unit"/>
                                    </xsl:attribute>
                                </quantity>
                            </xsl:if>
                            <xsl:if test="hl7:expectedUseTime">
                                <xsl:call-template name="Time">
                                    <xsl:with-param name="node" select="hl7:expectedUseTime"/>
                                    <xsl:with-param name="elementName">expectedUseTime</xsl:with-param>
                                </xsl:call-template>
                            </xsl:if>
                        </xsl:for-each>
                    </subsequentSupplyRequest>

                    <xsl:for-each select="descendant-or-self::hl7:supplyEventFutureSummary[1]">
                        <supplyEventFutureSummary>
                            <xsl:if test="hl7:repeatNumber/@value">
                                <repeatNumber>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="hl7:repeatNumber/@value"/>
                                    </xsl:attribute>
                                </repeatNumber>
                            </xsl:if>
                            <xsl:if test="hl7:quantity">
                                <quantity>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="hl7:quantity/@value"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="unit">
                                        <xsl:value-of select="hl7:quantity/@unit"/>
                                    </xsl:attribute>
                                </quantity>
                            </xsl:if>
                        </supplyEventFutureSummary>
                    </xsl:for-each>
                    <xsl:for-each select="descendant-or-self::hl7:supplyEventFirstSummary[1]">
                        <supplyEventFirstSummary>
                            <xsl:if test="hl7:effectiveTime">
                                <xsl:call-template name="Time">
                                    <xsl:with-param name="node" select="hl7:effectiveTime"/>
                                    <xsl:with-param name="elementName">effectiveTime</xsl:with-param>
                                </xsl:call-template>
                            </xsl:if>
                            <xsl:if test="hl7:quantity">
                                <quantity>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="hl7:quantity/@value"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="unit">
                                        <xsl:value-of select="hl7:quantity/@unit"/>
                                    </xsl:attribute>
                                </quantity>
                            </xsl:if>
                        </supplyEventFirstSummary>
                    </xsl:for-each>
                    <xsl:for-each select="descendant-or-self::hl7:supplyEventLastSummary[1]">
                        <supplyEventLastSummary>
                            <xsl:if test="hl7:effectiveTime">
                                <xsl:call-template name="Time">
                                    <xsl:with-param name="node" select="hl7:effectiveTime"/>
                                    <xsl:with-param name="elementName">effectiveTime</xsl:with-param>
                                </xsl:call-template>
                            </xsl:if>
                            <xsl:if test="hl7:quantity">
                                <quantity>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="hl7:quantity/@value"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="unit">
                                        <xsl:value-of select="hl7:quantity/@unit"/>
                                    </xsl:attribute>
                                </quantity>
                            </xsl:if>
                        </supplyEventLastSummary>
                    </xsl:for-each>
                    <xsl:for-each select="descendant-or-self::hl7:supplyEventPastSummary[1]">
                        <supplyEventPastSummary>
                            <xsl:if test="hl7:repeatNumber/@value">
                                <repeatNumber>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="hl7:repeatNumber/@value"/>
                                    </xsl:attribute>
                                </repeatNumber>
                            </xsl:if>
                            <xsl:if test="hl7:quantity">
                                <quantity>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="hl7:quantity/@value"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="unit">
                                        <xsl:value-of select="hl7:quantity/@unit"/>
                                    </xsl:attribute>
                                </quantity>
                            </xsl:if>
                        </supplyEventPastSummary>
                    </xsl:for-each>
                </supplyRequestItem>
            </xsl:for-each>

            <xsl:for-each select="descendant-or-self::hl7:substitutionPermission[1]">
                <substitutionPermission>
                    <xsl:if test="hl7:code">
                        <code>
                            <xsl:call-template name="codeElements">
                                <xsl:with-param name="node" select="hl7:code"/>
                            </xsl:call-template>
                        </code>
                    </xsl:if>
                    <xsl:if test="hl7:reasonCode">
                        <reasonCode>
                            <xsl:call-template name="codeElements">
                                <xsl:with-param name="node" select="hl7:reasonCode"/>
                            </xsl:call-template>
                        </reasonCode>
                    </xsl:if>
                </substitutionPermission>
            </xsl:for-each>

            <xsl:if test="descendant-or-self::hl7:workingListEvent">
                <category code="CHRON">
                    <xsl:call-template name="codeElements">
                        <xsl:with-param name="node" select="descendant-or-self::hl7:workingListEvent[1]"/>
                    </xsl:call-template>
                </category>
            </xsl:if>

            <!-- TODO: add coverage (should likly move to profile element)-->
            <!-- <coverage description="Insurance Coverage 1"/>  -->

        </prescription>

    </xsl:template>
    <xsl:template name="Profile_Prescription">
        <xsl:param name="requestMsg"/>
        <xsl:param name="currentPrescription"/>
        <xsl:param name="Profile"/>
        <xsl:param name="description"/>


        <prescription>
            <xsl:attribute name="description">
                <xsl:value-of select="$description"/>
            </xsl:attribute>

            <record-id root_OID="DIS_PRESCRIPTION_ID">
                <xsl:call-template name="getRecordID">
                    <xsl:with-param name="TdataNode" select="$currentPrescription"/>
                    <xsl:with-param name="hl7Node" select="hl7:id"/>
                    <xsl:with-param name="default-OID">DIS_PRESCRIPTION_ID</xsl:with-param>
                </xsl:call-template>
            </record-id>

            <xsl:call-template name="createRecordIdentifiers">
                <xsl:with-param name="requestMsg" select="$requestMsg"/>
            </xsl:call-template>

            <xsl:for-each select="hl7:predecessor/hl7:priorCombinedMedicationRequest">
                <priorPrescription>
                    <xsl:variable name="record-ext" select="hl7:id/@extension"/>
                    <xsl:variable name="record-OID">
                        <xsl:choose>
                            <xsl:when test="$messageType = 'server'">
                                <xsl:value-of select="name($OID_root/*[@server = hl7:id/@root])"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="name($OID_root/*[@client = hl7:id/@root])"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:attribute name="description">
                        <xsl:choose>
                            <xsl:when test="$messageType = 'server'">
                                <xsl:value-of select="$Profile/Items/*[record-id/@server = $record-ext][record-id/@root-OID = $record-OID]/@description"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$Profile/Items/*[record-id/@client = $record-ext][record-id/@root-OID = $record-OID]/@description"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                </priorPrescription>
            </xsl:for-each>


            <xsl:for-each select="descendant-or-self::hl7:annotation[1]">
                <xsl:call-template name="createNote">
                    <xsl:with-param name="requestMsg" select="$requestMsg"/>
                    <xsl:with-param name="noteNode" select="."/>
                </xsl:call-template>
            </xsl:for-each>

            <xsl:if test="$currentPrescription">
                <xsl:for-each select="$currentPrescription/note">
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </xsl:if>

        </prescription>

    </xsl:template>

    <xsl:template name="NewInferredPrescription">
        <xsl:param name="description"/>
        <prescription>
            <xsl:attribute name="description">
                <xsl:value-of select="$description"/>
            </xsl:attribute>

            <statusCode code="active"/>

            <drug>
                <xsl:attribute name="description">
                    <xsl:call-template name="getDrugDescription">
                        <xsl:with-param name="medication" select="descendant-or-self::hl7:player[1]"/>
                    </xsl:call-template>
                </xsl:attribute>
            </drug>

            <non-authoritative code="VFPAPER"/>

            <xsl:for-each select="descendant-or-self::hl7:dosageInstruction">
                <xsl:call-template name="dosageInstruction"/>
            </xsl:for-each>


            <xsl:call-template name="Time">
                <xsl:with-param name="node" select="hl7:component3/hl7:supplyEvent/hl7:effectiveTime"/>
                <xsl:with-param name="elementName">effectiveTime</xsl:with-param>
            </xsl:call-template>

            <xsl:for-each select="hl7:component3/hl7:supplyEvent/hl7:receiver">
                <responsibleParty>
                    <xsl:if test="hl7:id">
                        <phn>
                            <xsl:call-template name="getRecordID">
                                <xsl:with-param name="hl7Node" select="hl7:id"/>
                            </xsl:call-template>
                        </phn>
                    </xsl:if>
                    <xsl:if test="hl7:code">
                        <relationship>
                            <xsl:call-template name="codeElements">
                                <xsl:with-param name="node" select="hl7:code"/>
                            </xsl:call-template>
                        </relationship>
                    </xsl:if>
                    <xsl:if test="hl7:telecom/@value">
                        <telecom>
                            <xsl:value-of select="hl7:telecom/@value"/>
                        </telecom>
                    </xsl:if>
                    <name>
                        <xsl:choose>
                            <xsl:when test="hl7:agentPerson/hl7:name[hl7:given][hl7:family]">
                                <xsl:value-of select="hl7:agentPerson/hl7:name/hl7:given"/>
                                <xsl:value-of select="hl7:agentPerson/hl7:name/hl7:family"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="hl7:agentPerson/hl7:name"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </name>
                </responsibleParty>
            </xsl:for-each>

            <xsl:for-each select="hl7:component3/hl7:supplyEvent/hl7:location">
                <pharmacylocation>
                    <xsl:if test="hl7:time/@value">
                        <xsl:attribute name="value">
                            <xsl:call-template name="changeDate">
                                <xsl:with-param name="date" select="hl7:time/@value"/>
                            </xsl:call-template>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:call-template name="locationName">
                        <xsl:with-param name="node" select="hl7:serviceDeliveryLocation/hl7:id"/>
                    </xsl:call-template>
                    <xsl:if test="hl7:substitutionConditionCode">
                        <xsl:call-template name="codeElements">
                            <xsl:with-param name="node" select="hl7:substitutionConditionCode"/>
                        </xsl:call-template>
                    </xsl:if>
                </pharmacylocation>
            </xsl:for-each>

            <xsl:for-each select="hl7:component3/hl7:supplyEvent">
                <supplyRequestItem>
                    <xsl:if test="hl7:quantity">
                        <quantity>
                            <xsl:attribute name="value">
                                <xsl:value-of select="hl7:quantity/@value"/>
                            </xsl:attribute>
                            <xsl:attribute name="unit">
                                <xsl:value-of select="hl7:quantity/@unit"/>
                            </xsl:attribute>
                        </quantity>
                    </xsl:if>
                    <xsl:call-template name="Time">
                        <xsl:with-param name="node" select="hl7:expectedUseTime"/>
                        <xsl:with-param name="elementName">expectedUseTime</xsl:with-param>
                    </xsl:call-template>

                    <xsl:if test="descendant-or-self::hl7:player">
                        <drug>
                            <xsl:attribute name="description">
                                <xsl:call-template name="getDrugDescription">
                                    <xsl:with-param name="medication" select="descendant-or-self::hl7:player[1]"/>
                                </xsl:call-template>
                            </xsl:attribute>
                        </drug>
                    </xsl:if>
                    <!--
                    <initialSupplyRequest>
                        <xsl:for-each select="descendant-or-self::hl7:initialSupplyRequest[1]">
                            <xsl:if test="hl7:effectiveTime">
                                <xsl:call-template name="Time">
                                    <xsl:with-param name="node" select="hl7:effectiveTime"/>
                                    <xsl:with-param name="elementName">effectiveTime</xsl:with-param>
                                </xsl:call-template>
                            </xsl:if>
                            <xsl:if test="hl7:repeatNumber/@value">
                                <repeatNumber>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="hl7:repeatNumber/@value"/>
                                    </xsl:attribute>
                                </repeatNumber>
                            </xsl:if>
                            <xsl:if test="hl7:quantity">
                                <quantity>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="hl7:quantity/@value"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="unit">
                                        <xsl:value-of select="hl7:quantity/@unit"/>
                                    </xsl:attribute>
                                </quantity>
                            </xsl:if>
                            <xsl:if test="hl7:expectedUseTime">
                                <xsl:call-template name="Time">
                                    <xsl:with-param name="node" select="hl7:expectedUseTime"/>
                                    <xsl:with-param name="elementName">expectedUseTime</xsl:with-param>
                                </xsl:call-template>
                            </xsl:if>
                        </xsl:for-each>
                    </initialSupplyRequest>
                    <subsequentSupplyRequest>
                        <xsl:for-each select="descendant-or-self::hl7:subsequentSupplyRequest[1]">
                            <xsl:if test="hl7:effectiveTime">
                                <xsl:call-template name="Time">
                                    <xsl:with-param name="node" select="hl7:effectiveTime"/>
                                    <xsl:with-param name="elementName">effectiveTime</xsl:with-param>
                                </xsl:call-template>
                            </xsl:if>
                            <xsl:if test="hl7:repeatNumber/@value">
                                <repeatNumber>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="hl7:repeatNumber/@value"/>
                                    </xsl:attribute>
                                </repeatNumber>
                            </xsl:if>
                            <xsl:if test="hl7:quantity">
                                <quantity>
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="hl7:quantity/@value"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="unit">
                                        <xsl:value-of select="hl7:quantity/@unit"/>
                                    </xsl:attribute>
                                </quantity>
                            </xsl:if>
                            <xsl:if test="hl7:expectedUseTime">
                                <xsl:call-template name="Time">
                                    <xsl:with-param name="node" select="hl7:expectedUseTime"/>
                                    <xsl:with-param name="elementName">expectedUseTime</xsl:with-param>
                                </xsl:call-template>
                            </xsl:if>
                        </xsl:for-each>
                    </subsequentSupplyRequest>

-->
                </supplyRequestItem>
            </xsl:for-each>

            <!-- TODO: add coverage (should likly move to profile element)-->
            <!-- <coverage description="Insurance Coverage 1"/>  -->

        </prescription>

    </xsl:template>
    <xsl:template name="Profile_InferredPrescription">
        <xsl:param name="requestMsg"/>
        <xsl:param name="description"/>

        <prescription infered="true">
            <xsl:attribute name="description">
                <xsl:value-of select="$description"/>
            </xsl:attribute>


            <record-id root_OID="DIS_PRESCRIPTION_ID">
                <xsl:call-template name="getRecordID">
                    <xsl:with-param name="default-OID">DIS_PRESCRIPTION_ID</xsl:with-param>
                </xsl:call-template>
            </record-id>

            <xsl:call-template name="createRecordIdentifiers">
                <xsl:with-param name="requestMsg" select="$requestMsg"/>
            </xsl:call-template>

        </prescription>

    </xsl:template>

    <xsl:template name="Profile_RefusalToFill">
        <xsl:param name="requestMsg"/>
        <xsl:param name="Item"/>

        <xsl:element name="{name($Item)}">
            <xsl:for-each select="$Item/@*">
                <xsl:attribute name="{name()}">
                    <xsl:value-of select="."/>
                </xsl:attribute>
            </xsl:for-each>
            <xsl:copy-of select="$Item/*"/>

            <refusalToFill>
                <code>
                    <xsl:call-template name="codeElements">
                        <xsl:with-param name="node" select="hl7:code"/>
                    </xsl:call-template>
                </code>
                <reasonCode>
                    <xsl:call-template name="codeElements">
                        <xsl:with-param name="node" select="hl7:reasonCode"/>
                    </xsl:call-template>
                </reasonCode>
                <xsl:if test="hl7:effectiveTime">
                    <xsl:call-template name="Time">
                        <xsl:with-param name="elementName">effectiveTime</xsl:with-param>
                        <xsl:with-param name="node" select="hl7:effectiveTime"/>
                    </xsl:call-template>
                </xsl:if>
                <xsl:call-template name="createRecordIdentifiers">
                    <xsl:with-param name="requestMsg" select="$requestMsg"/>
                </xsl:call-template>
            </refusalToFill>

        </xsl:element>
    </xsl:template>

    <xsl:template name="NewDispense">
        <xsl:param name="description"/>
        <dispense>
            <xsl:attribute name="description">
                <xsl:value-of select="$description"/>
            </xsl:attribute>

            <xsl:for-each select="descendant-or-self::hl7:dosageInstruction">
                <xsl:call-template name="dosageInstruction"/>
            </xsl:for-each>
            <xsl:for-each select="descendant-or-self::hl7:supplyEvent[1]">
                <supplyEvent>
                    <code>
                        <xsl:call-template name="codeElements">
                            <xsl:with-param name="node" select="hl7:code"/>
                        </xsl:call-template>
                    </code>
                    <xsl:call-template name="Time">
                        <xsl:with-param name="node" select="hl7:effectiveTime"/>
                        <xsl:with-param name="elementName">effectiveTime</xsl:with-param>
                    </xsl:call-template>
                    <quantity>
                        <xsl:attribute name="value">
                            <xsl:value-of select="hl7:quantity/@value"/>
                        </xsl:attribute>
                        <xsl:attribute name="unit">
                            <xsl:value-of select="hl7:quantity/@unit"/>
                        </xsl:attribute>
                    </quantity>
                    <xsl:call-template name="Time">
                        <xsl:with-param name="node" select="hl7:expectedUseTime"/>
                        <xsl:with-param name="elementName">expectedUseTime</xsl:with-param>
                    </xsl:call-template>
                    <drug>
                        <xsl:attribute name="description">
                            <xsl:call-template name="getDrugDescription">
                                <xsl:with-param name="medication" select="descendant-or-self::hl7:player[1]"/>
                            </xsl:call-template>
                        </xsl:attribute>
                    </drug>
                </supplyEvent>
            </xsl:for-each>

        </dispense>

    </xsl:template>
    <xsl:template name="Profile_Dispense">
        <xsl:param name="requestMsg"/>
        <xsl:param name="currentDispense"/>
        <xsl:param name="Profile"/>
        <xsl:param name="description"/>

        <dispense>
            <xsl:attribute name="description">
                <xsl:value-of select="$description"/>
            </xsl:attribute>

            <record-id root_OID="DIS_DISPENSE_ID">
                <xsl:call-template name="getRecordID">
                    <xsl:with-param name="TdataNode" select="$currentDispense"/>
                    <xsl:with-param name="default-OID">DIS_DISPENSE_ID</xsl:with-param>
                </xsl:call-template>
            </record-id>
            <local-id root_OID="PORTAL_DISPENSE_ID">
                <xsl:call-template name="getLocalRecordID">
                    <xsl:with-param name="TdataNode" select="$currentDispense"/>
                    <xsl:with-param name="hl7Node" select="hl7:id"/>
                    <xsl:with-param name="default-OID">PORTAL_DISPENSE_ID</xsl:with-param>
                </xsl:call-template>
            </local-id>

            <statusCode code="active"/>

            <xsl:call-template name="createRecordIdentifiers">
                <xsl:with-param name="requestMsg" select="$requestMsg"/>
            </xsl:call-template>

            <xsl:choose>
                <xsl:when test="descendant-or-self::hl7:inFulfillmentOf/hl7:substanceAdministrationRequest/hl7:id/@extension">
                    <xsl:variable name="prescription-id" select="descendant-or-self::hl7:inFulfillmentOf/hl7:substanceAdministrationRequest/hl7:id[1]/@extension"/>
                    <xsl:variable name="prescription-root" select="descendant-or-self::hl7:inFulfillmentOf/hl7:substanceAdministrationRequest/hl7:id[1]/@root"/>
                    <xsl:variable name="prescription-OID">
                        <xsl:choose>
                            <xsl:when test="$messageType = 'server'">
                                <xsl:value-of select="name($OID_root/*[@server = $prescription-root])"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="name($OID_root/*[@client = $prescription-root])"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="prescription-desc">
                        <xsl:choose>
                            <xsl:when test="$messageType = 'server'">
                                <xsl:value-of select="$Profile/descendant-or-self::prescription[record-id/@server = $prescription-id][record-id/@root_OID = $prescription-OID]/@description"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$Profile/descendant-or-self::prescription[record-id/@client = $prescription-id][record-id/@root_OID = $prescription-OID]/@description"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <prescription>
                        <xsl:attribute name="description">
                            <xsl:value-of select="$prescription-desc"/>
                        </xsl:attribute>
                    </prescription>
                </xsl:when>
                <xsl:otherwise>
                    <!-- TODO: add the ablity to do an inferred prescription -->
                    <prescription description="Prescription(INFERRED_ITEM)"/>
                </xsl:otherwise>
            </xsl:choose>


            <xsl:for-each select="descendant-or-self::hl7:substitutionMade[1]">
                <substitutionMade>
                    <code>
                        <xsl:call-template name="codeElements">
                            <xsl:with-param name="node" select="hl7:code"/>
                        </xsl:call-template>
                    </code>
                    <xsl:if test="hl7:reasonCode">
                        <reasonCode>
                            <xsl:call-template name="codeElements">
                                <xsl:with-param name="node" select="hl7:reasonCode"/>
                            </xsl:call-template>
                        </reasonCode>
                    </xsl:if>
                    <xsl:if test="hl7:responsibleParty/hl7:author/hl7:id">
                        <author>
                            <xsl:call-template name="authorName">
                                <xsl:with-param name="node" select="hl7:responsibleParty/hl7:author/hl7:id"/>
                            </xsl:call-template>
                        </author>
                    </xsl:if>
                </substitutionMade>
            </xsl:for-each>

            <xsl:for-each select="descendant-or-self::hl7:annotation[1]">
                <xsl:call-template name="createNote">
                    <xsl:with-param name="requestMsg" select="$requestMsg"/>
                    <xsl:with-param name="noteNode" select="."/>
                </xsl:call-template>
            </xsl:for-each>

            <xsl:if test="$currentDispense">
                <xsl:for-each select="$currentDispense/note">
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </xsl:if>
        </dispense>
    </xsl:template>

    <xsl:template name="Profile_DispensePickup">
        <xsl:param name="requestMsg"/>
        <xsl:param name="currentDispense"/>
        <dispense>
            <xsl:for-each select="$currentDispense/@*">
                <xsl:attribute name="{name()}">
                    <xsl:value-of select="."/>
                </xsl:attribute>
            </xsl:for-each>
            <xsl:for-each select="$currentDispense/*">
                <xsl:variable name="elementName" select="local-name()"/>
                <xsl:choose>
                    <xsl:when test="$elementName = 'statusCode' ">
                        <statusCode code="completed"/>
                    </xsl:when>
                    <xsl:when test="$elementName = 'supplyEvent' ">
                        <supplyEvent>
                            <xsl:for-each select="@*">
                                <xsl:attribute name="{name()}">
                                    <xsl:value-of select="."/>
                                </xsl:attribute>
                            </xsl:for-each>
                            <xsl:for-each select="/*">
                                <xsl:variable name="subElementName" select="local-name()"/>
                                <xsl:choose>
                                    <xsl:when test="$subElementName = 'effectiveTime'">
                                        <effectiveTime>
                                            <low>
                                                <xsl:attribute name="value">
                                                    <xsl:call-template name="changeDate">
                                                        <xsl:with-param name="date" select="hl7:low/@value"/>
                                                    </xsl:call-template>
                                                </xsl:attribute>
                                            </low>
                                            <high>
                                                <xsl:attribute name="value">
                                                    <xsl:choose>
                                                        <xsl:when test="$requestMsg/hl7:effectiveTime/@value">
                                                            <xsl:call-template name="changeDate">
                                                                <xsl:with-param name="date" select="$requestMsg/hl7:effectiveTime/@value"/>
                                                            </xsl:call-template>
                                                        </xsl:when>
                                                        <xsl:when test="$requestMsg/hl7:effectiveTime/hl7:high/@value">
                                                            <xsl:call-template name="changeDate">
                                                                <xsl:with-param name="date" select="$requestMsg/hl7:effectiveTime/hl7:high/@value"/>
                                                            </xsl:call-template>
                                                        </xsl:when>
                                                        <xsl:when test="$requestMsg/descendant-or-self::hl7:author/hl7:time/@value">
                                                            <xsl:call-template name="changeDate">
                                                                <xsl:with-param name="date" select="$requestMsg/descendant-or-self::hl7:author[1]/hl7:time/@value"/>
                                                            </xsl:call-template>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:call-template name="changeDate">
                                                                <xsl:with-param name="date" select="$requestMsg/descendant-or-self::hl7:creationTime/@value"/>
                                                            </xsl:call-template>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:attribute>
                                            </high>
                                        </effectiveTime>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:copy-of select="."/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </supplyEvent>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy-of select="."/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>

            <pickup>
                <xsl:call-template name="createRecordIdentifiers">
                    <xsl:with-param name="requestMsg" select="$requestMsg"/>
                </xsl:call-template>
            </pickup>

        </dispense>
    </xsl:template>

    <xsl:template name="Profile_ProfessionalService">
        <xsl:param name="requestMsg"/>
        <xsl:param name="currentProfService"/>
        <xsl:param name="Profile"/>
        <xsl:param name="description"/>

        <profService>
            <xsl:attribute name="description">
                <xsl:value-of select="$description"/>
            </xsl:attribute>

            <record-id root_OID="DIS_PROF_SERVICE_ID">
                <xsl:call-template name="getRecordID">
                    <xsl:with-param name="TdataNode" select="$currentProfService"/>
                    <xsl:with-param name="default-OID">DIS_PROF_SERVICE_ID</xsl:with-param>
                </xsl:call-template>
            </record-id>

            <xsl:call-template name="createRecordIdentifiers">
                <xsl:with-param name="requestMsg" select="$requestMsg"/>
            </xsl:call-template>

            <statusCode>
                <xsl:call-template name="codeElements">
                    <xsl:with-param name="node" select="hl7:statusCode"/>
                </xsl:call-template>
            </statusCode>
            <code>
                <xsl:call-template name="codeElements">
                    <xsl:with-param name="node" select="hl7:code"/>
                </xsl:call-template>
            </code>
            <xsl:if test="hl7:effectiveTime">
                <xsl:call-template name="Time">
                    <xsl:with-param name="node" select="hl7:effectiveTime"/>
                    <xsl:with-param name="elementName">effectiveTime</xsl:with-param>
                </xsl:call-template>
            </xsl:if>


            <xsl:if test="hl7:inFulfillmentOf/hl7:actRequest/hl7:author/hl7:id">
                <requestedBy>
                    <xsl:call-template name="authorName">
                        <xsl:with-param name="node" select="hl7:inFulfillmentOf/hl7:actRequest/hl7:author/hl7:id"/>
                    </xsl:call-template>
                </requestedBy>
            </xsl:if>

            <xsl:for-each select="descendant-or-self::hl7:annotation[1]">
                <xsl:call-template name="createNote">
                    <xsl:with-param name="requestMsg" select="$requestMsg"/>
                    <xsl:with-param name="noteNode" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:if test="$currentProfService">
                <xsl:for-each select="$currentProfService/note">
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </xsl:if>

        </profService>

    </xsl:template>

    <xsl:template name="Profile_PatientNote">
        <xsl:param name="requestMsg"/>
        <xsl:param name="Profile"/>
        <xsl:param name="description"/>

        <xsl:call-template name="createNote">
            <xsl:with-param name="description" select="$description"/>
            <xsl:with-param name="createRecordID">true</xsl:with-param>
            <xsl:with-param name="noteNode" select="."/>
            <xsl:with-param name="requestMsg" select="$requestMsg"/>
        </xsl:call-template>

    </xsl:template>

    <xsl:template name="Profile_RecordNote">
        <xsl:param name="requestMsg"/>
        <xsl:param name="Record"/>

        <xsl:element name="{name($Record)}">
            <xsl:for-each select="$Record/@*">
                <xsl:attribute name="{name()}">
                    <xsl:value-of select="."/>
                </xsl:attribute>
            </xsl:for-each>
            <xsl:copy-of select="$Record/*"/>

            <xsl:call-template name="createNote">
                <xsl:with-param name="noteNode" select="."/>
                <xsl:with-param name="requestMsg" select="$requestMsg"/>
            </xsl:call-template>
        </xsl:element>
    </xsl:template>

    <xsl:template name="Profile_Invoice">
        <xsl:param name="requestMsg"/>
        <xsl:param name="Profile"/>
        <xsl:param name="description"/>
        <invoice>
            <xsl:attribute name="description">
                <xsl:value-of select="$description"/>
            </xsl:attribute>
            <xsl:attribute name="currency">CAD</xsl:attribute>

            <xsl:call-template name="createRecordIdentifiers">
                <xsl:with-param name="requestMsg" select="$requestMsg"/>
            </xsl:call-template>
            
            <xsl:choose>
                <xsl:when test="hl7:id[1]/@extension">
                    <!-- Dispense description -->
                    <dispense>
                        <xsl:attribute name="description">
                            <xsl:variable name="dispense-id" select="hl7:id[1]/@extension"/>
                            <xsl:variable name="dispense-root" select="hl7:id[1]/@root"/>
                            <xsl:variable name="dispense-OID">
                                <xsl:choose>
                                    <xsl:when test="$messageType = 'server'">
                                        <xsl:value-of select="name($OID_root/*[@server = $dispense-root])"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="name($OID_root/*[@client = $dispense-root])"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:variable name="dispense-desc">
                                <xsl:choose>
                                    <xsl:when test="$messageType = 'server'">
                                        <xsl:value-of select="$Profile/descendant-or-self::dispense[record-id/@server = $dispense-id][record-id/@root_OID = $dispense-OID]/@description"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$Profile/descendant-or-self::dispense[record-id/@client = $dispense-id][record-id/@root_OID = $dispense-OID]/@description"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:value-of select="$dispense-desc"/>
                        </xsl:attribute>
                    </dispense>
                    
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="Drug-codeSystem">
                        <xsl:call-template name="getOIDNameByRoot">
                            <xsl:with-param name="OID_Value" select="descendant-or-self::hl7:invoiceElementDetail/hl7:code[@codeSystem][1]/@codeSystem"/>
                            <xsl:with-param name="msgType" select="$messageType"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:variable name="Drug-ext" select="descendant-or-self::hl7:invoiceElementDetail/hl7:code[@codeSystem][1]/@code"/>
                    
                    <!--<xsl:variable name="DrugData" select="$BaseData/drugs/drug[@description=$Drug-description]"/>-->
                    <xsl:variable name="DrugData" select="$TestDataXml/configuration/testData/drugs/drug[code/@code = $Drug-ext][code/@codeSystem = $Drug-codeSystem][cost]"/>
                    <drug>
                        <xsl:attribute name="description"><xsl:value-of select="$DrugData/@description"/></xsl:attribute>
                    </drug>

                </xsl:otherwise>
            </xsl:choose>
            
            
            <!--            <payee description="Pharmacy 1"/>-->
            <payee>
                <xsl:call-template name="payeeName">
                    <xsl:with-param name="node" select="descendant-or-self::hl7:payeeRole/hl7:id"/>
                </xsl:call-template>
            </payee>
            <xsl:if test="descendant-or-self::hl7:invoiceElementOverride/hl7:code/@code">
                <override>
                    <xsl:call-template name="codeElements">
                        <xsl:with-param name="node" select="descendant-or-self::hl7:invoiceElementOverride/hl7:code"/>
                    </xsl:call-template>
                </override>
            </xsl:if>
            <xsl:variable name="paymentTime" select="$now"/>
            <xsl:variable name="coverage" select="descendant-or-self::hl7:coverage/hl7:policyOrAccount/hl7:id"/>
            <xsl:variable name="coverage-OID">
                <xsl:choose>
                    <xsl:when test="$messageType = 'server'">
                        <xsl:value-of select="name($OID_root/*[@server = $coverage/@root])"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="name($OID_root/*[@client = $coverage/@root])"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="coverage-ID" select="$coverage/@extension"/>
            <xsl:variable name="coverage-item"
                select="$TestData/coverages/coverage[($messageType = 'server' and record-id/@server = $coverage-ID) or ($messageType = 'client' and record-id/@client = $coverage-ID)][record-id/@root_OID = $coverage-OID]"/>
            <xsl:variable name="upstreampayor" select="(descendant-or-self::hl7:reference/hl7:adjudicatedInvoiceElementGroup/hl7:netAmt/@value)"/>
            <xsl:variable name="markupfee" select="sum(descendant-or-self::hl7:invoiceElementDetail[hl7:code/@code='MARKUP']/hl7:unitPriceAmt/hl7:numerator/@value)"/>
            <xsl:variable name="professionalfee" select="sum(descendant-or-self::hl7:invoiceElementDetail[hl7:code/@code='PROFFEE'][1]/hl7:unitPriceAmt/hl7:numerator/@value)"/>
            <request>
                <coverage>
                    <xsl:attribute name="description">
                        <xsl:value-of select="$coverage-item/@description"/>
                    </xsl:attribute>
                </coverage>
                <professionalfee>
                    <xsl:attribute name="value">
                        <xsl:value-of select="$professionalfee"/>
                    </xsl:attribute>
                </professionalfee>
                <markupfee>
                    <xsl:attribute name="value">
                        <xsl:value-of select="$markupfee"/>
                    </xsl:attribute>
                </markupfee>
                <xsl:if test="$upstreampayor > 0">
                    <upstreampayor>
                        <xsl:attribute name="value">
                            <xsl:value-of select="$upstreampayor"/>
                        </xsl:attribute>
                    </upstreampayor>
                </xsl:if>
            </request>


            <xsl:variable name="maxMarkupfee">
                <xsl:choose>
                    <xsl:when test="$coverage-item/payment/markupfee">
                        <xsl:value-of select="$coverage-item/payment/markupfee/@value"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$markupfee"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="maxProfessionalfee">
                <xsl:choose>
                    <xsl:when test="$coverage-item/payment/professionalfee">
                        <xsl:value-of select="$coverage-item/payment/professionalfee/@value"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$professionalfee"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="maxPatientcost">
                <xsl:choose>
                    <xsl:when test="$coverage-item/payment/patientcost">
                        <xsl:value-of select="$coverage-item/payment/patientcost/@value"/>
                    </xsl:when>
                    <xsl:otherwise>0</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="maxCopayment">
                <xsl:choose>
                    <xsl:when test="$coverage-item/payment/copayment">
                        <xsl:value-of select="$coverage-item/payment/copayment/@value"/>
                    </xsl:when>
                    <xsl:otherwise>0</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="maxDeductible">
                <xsl:choose>
                    <xsl:when test="$coverage-item/payment/deductible">
                        <xsl:value-of select="$coverage-item/payment/deductible/@value"/>
                    </xsl:when>
                    <xsl:otherwise>0</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <payment>
                <paymentTime value="20060201">
                    <xsl:attribute name="value">
                        <xsl:value-of select="$TestData/@BaseDateTime"/>
                    </xsl:attribute>
                </paymentTime>
                <coverage>
                    <xsl:attribute name="description">
                        <xsl:value-of select="$coverage-item/@description"/>
                    </xsl:attribute>
                </coverage>
                <professionalfee>
                    <xsl:call-template name="InvoicePayment">
                        <xsl:with-param name="requestedAmount" select="$professionalfee"/>
                        <xsl:with-param name="maxAmount" select="$maxProfessionalfee"/>
                    </xsl:call-template>
                </professionalfee>
                <markupfee value="25.00">
                    <xsl:call-template name="InvoicePayment">
                        <xsl:with-param name="requestedAmount" select="$markupfee"/>
                        <xsl:with-param name="maxAmount" select="$maxMarkupfee"/>
                    </xsl:call-template>
                </markupfee>
                <patientcost>
                    <xsl:attribute name="value">
                        <xsl:value-of select="$maxPatientcost"/>
                    </xsl:attribute>
                </patientcost>
                <copayment value="0">
                    <xsl:attribute name="value">
                        <xsl:value-of select="$maxCopayment"/>
                    </xsl:attribute>
                </copayment>
                <deductible value="0">
                    <xsl:attribute name="value">
                        <xsl:value-of select="$maxDeductible"/>
                    </xsl:attribute>
                </deductible>
            </payment>
        </invoice>
    </xsl:template>

    <xsl:template name="InvoicePayment">
        <xsl:param name="requestedAmount"/>
        <xsl:param name="maxAmount"/>
        <xsl:choose>
            <xsl:when test="$requestedAmount &lt;= $maxAmount">
                <xsl:attribute name="value">
                    <xsl:value-of select="$requestedAmount"/>
                </xsl:attribute>
                <reason code="AS"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="value">
                    <xsl:value-of select="$maxAmount"/>
                </xsl:attribute>
                <reason code="AA"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template name="NewDrug">
        <xsl:param name="node"/>
        <xsl:param name="description"/>
        <drug>
            <xsl:attribute name="description">
                <xsl:value-of select="$description"/>
            </xsl:attribute>
            <code>
                <xsl:call-template name="codeElements">
                    <xsl:with-param name="node" select="$node/hl7:code"/>
                </xsl:call-template>
            </code>
            <name>
                <xsl:value-of select="$node/hl7:name"/>
            </name>
            <desc>
                <xsl:value-of select="$node/hl7:desc"/>
            </desc>
            <xsl:if test="$node/hl7:formCode">
                <formCode>
                    <xsl:call-template name="codeElements">
                        <xsl:with-param name="node" select="$node/hl7:formCode"/>
                    </xsl:call-template>
                </formCode>
            </xsl:if>
            <xsl:if test="node/descendant-or-self::hl7:manufacturer/hl7:name">
                <manufacturer>
                    <xsl:value-of select="node/descendant-or-self::hl7:manufacturer/hl7:name"/>
                </manufacturer>
            </xsl:if>
            <quantity>
                <xsl:attribute name="value">
                    <xsl:value-of select="$node/descendant-or-self::hl7:quantity/@value"/>
                </xsl:attribute>
                <xsl:attribute name="unit">
                    <xsl:value-of select="$node/descendant-or-self::hl7:quantity/@unit"/>
                </xsl:attribute>
            </quantity>

            <packageformCode code="">
                <xsl:call-template name="codeElements">
                    <xsl:with-param name="node" select="$node/descendant-or-self::hl7:containerPackagedMedicine/hl7:formCode"/>
                </xsl:call-template>
            </packageformCode>

        </drug>
    </xsl:template>



    <xsl:template name="Issue">
        <xsl:param name="description"/>
        <xsl:param name="Profile"/>
        <issue>
            <xsl:attribute name="description">
                <xsl:value-of select="$description"/>
            </xsl:attribute>

            <code>
                <xsl:call-template name="codeElements">
                    <xsl:with-param name="node" select="hl7:code"/>
                </xsl:call-template>
            </code>
            <xsl:if test="hl7:text">
                <text>
                    <xsl:value-of select="hl7:text"/>
                </text>
            </xsl:if>
            <priorityCode>
                <xsl:call-template name="codeElements">
                    <xsl:with-param name="node" select="hl7:priorityCode"/>
                </xsl:call-template>
            </priorityCode>
            <severity code="L">
                <xsl:call-template name="codeElements">
                    <xsl:with-param name="node" select="hl7:subjectOf2/hl7:severityObservation/hl7:value"/>
                </xsl:call-template>
            </severity>
            <xsl:for-each select="hl7:subject">
                <causes>
                    <xsl:variable name="root" select="hl7:*/hl7:id/@root"/>
                    <xsl:variable name="ext" select="hl7:*/hl7:id/@ext"/>

                    <xsl:choose>
                        <xsl:when test="$messageType = 'server'">
                            <xsl:variable name="root_OID" select="name($OID_root/*[@server = $root])"/>
                            <xsl:variable name="cause-item" select="$Profile/descendant-or-self::*[record-id/@server = $ext][record-id/@root_OID = $root_OID][1]"/>
                            <xsl:element name="{name($cause-item)}">
                                <xsl:attribute name="description">
                                    <xsl:value-of select="$cause-item/@description"/>
                                </xsl:attribute>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:variable name="root_OID" select="name($OID_root/*[@client = $root])"/>
                            <xsl:variable name="cause-item" select="$Profile/descendant-or-self::*[record-id/@client = $ext][record-id/@root_OID = $root_OID][1]"/>
                            <xsl:element name="{name($cause-item)}">
                                <xsl:attribute name="description">
                                    <xsl:value-of select="$cause-item/@description"/>
                                </xsl:attribute>
                            </xsl:element>
                        </xsl:otherwise>
                    </xsl:choose>
                </causes>
            </xsl:for-each>
            <xsl:if test="descendant-or-self::hl7:detectedIssueDefinition">
                <detectedIssueDefinition>
                    <id>
                        <xsl:call-template name="getRecordID">
                            <xsl:with-param name="hl7Node" select="descendant-or-self::hl7:detectedIssueDefinition[1]/hl7:id"/>
                        </xsl:call-template>
                    </id>
                    <name>
                        <xsl:value-of select="descendant-or-self::hl7:detectedIssueDefinition[1]/hl7:author/descendant-or-self::hl7:name[1]"/>
                    </name>
                </detectedIssueDefinition>
            </xsl:if>

            <xsl:for-each select="descendant-or-self::hl7:detectedIssueManagement">
                <managment>
                    <code>
                        <xsl:call-template name="codeElements">
                            <xsl:with-param name="node" select="hl7:code"/>
                        </xsl:call-template>
                    </code>
                    <xsl:if test="hl7:text">
                        <text>
                            <xsl:value-of select="hl7:text"/>
                        </text>
                    </xsl:if>
                    <xsl:call-template name="Time">
                        <xsl:with-param name="elementName">time</xsl:with-param>
                        <xsl:with-param name="node" select="hl7:author/hl7:time"/>
                    </xsl:call-template>
                    <author>
                        <xsl:call-template name="authorName">
                            <xsl:with-param name="node" select="hl7:author/hl7:assignedPerson/hl7:id[1]"/>
                        </xsl:call-template>
                    </author>
                </managment>
            </xsl:for-each>
        </issue>
    </xsl:template>

    <xsl:template name="Time">
        <xsl:param name="node"/>
        <xsl:param name="elementName"/>

        <xsl:element name="{$elementName}">
            <xsl:if test="$node/@value">
                <xsl:attribute name="value">
                    <xsl:call-template name="changeDate">
                        <xsl:with-param name="date" select="$node/@value"/>
                    </xsl:call-template>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="$node/hl7:low/@value">
                <low>
                    <xsl:attribute name="value">
                        <xsl:call-template name="changeDate">
                            <xsl:with-param name="date" select="$node/hl7:low/@value"/>
                        </xsl:call-template>
                    </xsl:attribute>
                </low>
            </xsl:if>
            <xsl:if test="$node/hl7:high/@value">
                <high>
                    <xsl:attribute name="value">
                        <xsl:call-template name="changeDate">
                            <xsl:with-param name="date" select="$node/hl7:high/@value"/>
                        </xsl:call-template>
                    </xsl:attribute>
                </high>
            </xsl:if>
            <xsl:if test="$node/hl7:center/@value">
                <center>
                    <xsl:attribute name="value">
                        <xsl:call-template name="changeDate">
                            <xsl:with-param name="date" select="$node/hl7:center/@value"/>
                        </xsl:call-template>
                    </xsl:attribute>
                </center>
            </xsl:if>
            <xsl:if test="$node/hl7:width/@value">
                <width>
                    <xsl:attribute name="value">
                        <xsl:value-of select="$node/hl7:width/@value"/>
                    </xsl:attribute>
                    <xsl:attribute name="unit">
                        <xsl:value-of select="$node/hl7:width/@unit"/>
                    </xsl:attribute>
                </width>
            </xsl:if>
        </xsl:element>
    </xsl:template>

    <xsl:template name="getRecordID">
        <xsl:param name="TdataNode"/>
        <xsl:param name="hl7Node"/>
        <xsl:param name="default-OID"/>
        <xsl:choose>
            <xsl:when test="$TdataNode and $TdataNode/record-id">
                <xsl:for-each select="$TdataNode/record-id/@*">
                    <xsl:attribute name="{name()}">
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="$hl7Node and $hl7Node/@extension">
                <xsl:attribute name="client">
                    <xsl:value-of select="$hl7Node/@extension"/>
                </xsl:attribute>
                <xsl:attribute name="server">
                    <xsl:value-of select="$hl7Node/@extension"/>
                </xsl:attribute>
                <xsl:variable name="root_OID">
                    <xsl:choose>
                        <xsl:when test="$messageType = 'server'">
                            <xsl:value-of select="$OID_root/*[@server = $hl7Node/@root]"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$OID_root/*[@client = $hl7Node/@root]"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:attribute name="root_OID">
                    <xsl:choose>
                        <xsl:when test="$root_OID">
                            <xsl:value-of select="name($root_OID)"/>
                        </xsl:when>
                        <xsl:when test="$default-OID">
                            <xsl:value-of select="$default-OID"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$hl7Node/@root"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="client">
                    <xsl:value-of select="$OID"/>
                </xsl:attribute>
                <xsl:attribute name="server">
                    <xsl:value-of select="$OID"/>
                </xsl:attribute>
                <xsl:attribute name="root_OID">
                    <xsl:value-of select="$default-OID"/>
                </xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="getLocalRecordID">
        <xsl:param name="TdataNode"/>
        <xsl:param name="hl7Node"/>
        <xsl:param name="default-OID"/>
        <xsl:choose>
            <xsl:when test="$TdataNode and $TdataNode/local-id">
                <xsl:for-each select="$TdataNode/local-id/@*">
                    <xsl:attribute name="{name()}">
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="$hl7Node and $hl7Node/@extension">
                <xsl:attribute name="client">
                    <xsl:value-of select="$hl7Node/@extension"/>
                </xsl:attribute>
                <xsl:attribute name="server">
                    <xsl:value-of select="$hl7Node/@extension"/>
                </xsl:attribute>
                <xsl:variable name="root_OID">
                    <xsl:choose>
                        <xsl:when test="$messageType = 'server'">
                            <xsl:value-of select="name($OID_root/*[@server = $hl7Node/@root])"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="name($OID_root/*[@client = $hl7Node/@root])"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <xsl:attribute name="root_OID">
                    <xsl:choose>
                        <xsl:when test="$root_OID and ($root_OID='')">
                            <xsl:value-of select="$root_OID"/>
                        </xsl:when>
                        <xsl:when test="$default-OID">
                            <xsl:value-of select="$default-OID"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$hl7Node/@root"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="createRecordIdentifiers">
        <xsl:param name="requestMsg"/>
        <creationTime>
            <xsl:attribute name="value">
                <xsl:value-of select="$now"/>
            </xsl:attribute>
        </creationTime>
        <xsl:if test="$requestMsg/descendant-or-self::hl7:controlActEvent/hl7:responsibleParty/hl7:assignedPerson/hl7:id">
            <supervisor>
                <xsl:call-template name="authorName">
                    <xsl:with-param name="node" select="$requestMsg/descendant-or-self::hl7:controlActEvent/hl7:responsibleParty/hl7:assignedPerson/hl7:id[1]"/>
                </xsl:call-template>
            </supervisor>
        </xsl:if>
        <author>
            <xsl:choose>
                <xsl:when test="$requestMsg/descendant-or-self::hl7:authorOrPerformer/hl7:assignedPerson/hl7:id">
                    <xsl:call-template name="authorName">
                        <xsl:with-param name="node" select="$requestMsg/descendant-or-self::hl7:authorOrPerformer/hl7:assignedPerson/hl7:id"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="authorName">
                        <xsl:with-param name="node" select="$requestMsg/descendant-or-self::hl7:controlActEvent/hl7:author/hl7:assignedPerson/hl7:id"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </author>
        <location description="Pharmacy 1">
            <xsl:call-template name="locationName">
                <xsl:with-param name="node" select="$requestMsg/descendant-or-self::hl7:controlActEvent/hl7:location/hl7:serviceDeliveryLocation/hl7:id[1]"/>
            </xsl:call-template>
        </location>
    </xsl:template>

    <xsl:template name="createNote">
        <xsl:param name="requestMsg"/>
        <xsl:param name="noteNode"/>
        <xsl:param name="description">generated Note</xsl:param>
        <xsl:param name="createRecordID">false</xsl:param>

        <note description="generated Note">
            <xsl:attribute name="description">
                <xsl:value-of select="$description"/>
            </xsl:attribute>

            <xsl:if test="$createRecordID = 'true'">
                <record-id root_OID="DIS_PATIENT_NOTE_ID">
                    <xsl:call-template name="getRecordID">
                        <xsl:with-param name="default-OID">DIS_PATIENT_NOTE_ID</xsl:with-param>
                    </xsl:call-template>
                </record-id>
            </xsl:if>

            <xsl:call-template name="createRecordIdentifiers">
                <xsl:with-param name="requestMsg" select="$requestMsg"/>
            </xsl:call-template>
            <!--
            <author>
                <xsl:choose>
                    <xsl:when test="$noteNode/hl7:author/hl7:assignedPerson/hl7:id">
                        <xsl:call-template name="authorName">
                            <xsl:with-param name="node" select="$noteNode/hl7:author/hl7:assignedPerson/hl7:id"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="authorName">
                            <xsl:with-param name="node"
                                select="$requestMsg/hl7:controlActEvent/hl7:author/hl7:assignedPerson/hl7:id"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </author>
            <location description="Pharmacy 1">
                <xsl:call-template name="locationName">
                    <xsl:with-param name="node" select="$requestMsg/hl7:controlActEvent/hl7:location/hl7:serviceDeliveryLocation/hl7:id"/>
                </xsl:call-template>
            </location>
            -->
            <text>
                <xsl:value-of select="$noteNode/hl7:text"/>
            </text>
        </note>

    </xsl:template>

    <xsl:template name="getDrugDescription">
        <xsl:param name="medication"/>
        <xsl:variable name="drug-OID">
            <xsl:choose>
                <xsl:when test="$messageType = 'server'">
                    <xsl:value-of select="name($OID_root/*[@server = $medication/descendant-or-self::hl7:code/@codeSystem])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="name($OID_root/*[@client = $medication/descendant-or-self::hl7:code/@codeSystem])"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="drug-code" select="$medication/descendant-or-self::hl7:code/@code"/>

        <xsl:choose>
            <xsl:when test="$TestDataXml/configuration/testData/drugs/drug[code/@code = $drug-code][code/@codeSystem = $drug-OID]">
                <xsl:value-of select="$TestDataXml/configuration/testData/drugs/drug[code/@code = $drug-code][code/@codeSystem = $drug-OID][1]/@description"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$drug-OID"/>
                <xsl:text>_</xsl:text>
                <xsl:value-of select="$drug-code"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="dosageInstruction">

        <dosageInstruction>
            <text>
                <xsl:value-of select="hl7:text"/>
            </text>
            <xsl:if test="hl7:effectiveTime">
                <xsl:call-template name="Time">
                    <xsl:with-param name="node" select="hl7:effectiveTime"/>
                    <xsl:with-param name="elementName">effectiveTime</xsl:with-param>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="hl7:routeCode">
                <routeCode>
                    <xsl:call-template name="codeElements">
                        <xsl:with-param name="node" select="hl7:routeCode"/>
                    </xsl:call-template>
                </routeCode>
            </xsl:if>
            <xsl:for-each select="hl7:approachSiteCode">
                <approachSiteCode>
                    <xsl:call-template name="codeElements">
                        <xsl:with-param name="node" select="."/>
                    </xsl:call-template>
                </approachSiteCode>
            </xsl:for-each>
            <xsl:if test="hl7:maxDoseQuantity">
                <maxDoseQuantity>
                    <numerator>
                        <xsl:attribute name="value">
                            <xsl:value-of select="hl7:maxDoseQuantity/hl7:numerator/@value"/>
                        </xsl:attribute>
                        <xsl:attribute name="unit">
                            <xsl:value-of select="hl7:maxDoseQuantity/hl7:numerator/@unit"/>
                        </xsl:attribute>
                    </numerator>
                    <denominator>
                        <xsl:attribute name="value">
                            <xsl:value-of select="hl7:maxDoseQuantity/hl7:denominator/@value"/>
                        </xsl:attribute>
                        <xsl:attribute name="unit">
                            <xsl:value-of select="hl7:maxDoseQuantity/hl7:denominator/@unit"/>
                        </xsl:attribute>
                    </denominator>
                </maxDoseQuantity>
            </xsl:if>
            <xsl:if test="hl7:administrationUnitCode">
                <administrationUnitCode>
                    <xsl:call-template name="codeElements">
                        <xsl:with-param name="node" select="hl7:administrationUnitCode"/>
                    </xsl:call-template>
                </administrationUnitCode>
            </xsl:if>

            <drug>
                <xsl:attribute name="description">
                    <xsl:call-template name="getDrugDescription">
                        <xsl:with-param name="medication" select="descendant-or-self::hl7:player[1]"/>
                    </xsl:call-template>
                </xsl:attribute>
            </drug>

            <xsl:for-each select="descendant-or-self::hl7:supplementalInstruction">
                <instruction>
                    <xsl:value-of select="hl7:text"/>
                </instruction>
            </xsl:for-each>
            <xsl:for-each select="descendant-or-self::hl7:dosageLine">
                <dosageLine>
                    <xsl:attribute name="sequenceNumber">
                        <xsl:value-of select="parent::*/hl7:sequenceNumber/@value"/>
                    </xsl:attribute>
                    <text>
                        <xsl:value-of select="hl7:text"/>
                    </text>
                    <!-- TODO: add reset of dosage line elements -->
                </dosageLine>
            </xsl:for-each>

        </dosageInstruction>

    </xsl:template>

    <xsl:template name="exposure">
        <xsl:param name="Profile"/>

        <exposure>
            <xsl:for-each select="descendant-or-self::hl7:observationEvent">
                <reaction>
                    <xsl:choose>
                        <xsl:when test="hl7:id">
                            <xsl:variable name="ID" select="hl7:id/@extension"/>
                            <xsl:attribute name="description">
                                <xsl:choose>
                                    <xsl:when test="$messageType = 'server'">
                                        <xsl:variable name="OIDName" select="name($OID_root/*[@server = hl7:id/@root])"/>
                                        <xsl:value-of select="$Profile/descendant-or-self::*[@root_OID=$OIDName][@server=$ID]/parent::node()/@description"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:variable name="OIDName" select="name($OID_root/*[@client = hl7:id/@root])"/>
                                        <xsl:value-of select="$Profile/descendant-or-self::*[@root_OID=$OIDName][@client=$ID]/parent::node()/@description"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- TODO:  -->
                            <!-- need to create a new reaction and place name here -->
                        </xsl:otherwise>
                    </xsl:choose>
                </reaction>
            </xsl:for-each>
            <xsl:for-each select="descendant-or-self::hl7:exposureEvent">
                <cause>
                    <xsl:if test="hl7:id">
                        <xsl:variable name="OIDName">
                            <xsl:choose>
                                <xsl:when test="$messageType = 'server'">
                                    <xsl:value-of select="name($OID_root/*[@server = hl7:id/@root])"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="name($OID_root/*[@client = hl7:id/@root])"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="ID" select="hl7:id/@extension"/>

                        <xsl:attribute name="type">
                            <xsl:choose>
                                <xsl:when test="OIDName = 'DIS_PRESCRIPTION_ID'">prescription</xsl:when>
                                <xsl:when test="OIDName = 'DIS_IMMUNIZATION_ID'">immunization</xsl:when>
                                <xsl:when test="OIDName = 'DIS_OTHER_ACTIVE_MED_ID'">otherMedication</xsl:when>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:attribute name="description">
                            <xsl:choose>
                                <xsl:when test="$messageType = 'server'">
                                    <xsl:value-of select="$Profile/descendant-or-self::*[@root_OID=$OIDName][@server=$ID]/parent::node()/@description"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$Profile/descendant-or-self::*[@root_OID=$OIDName][@client=$ID]/parent::node()/@description"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>

                    </xsl:if>
                    <xsl:if test="hl7:routeCode">
                        <routeCode>
                            <xsl:call-template name="codeElements">
                                <xsl:with-param name="node" select="hl7:routeCode"/>
                            </xsl:call-template>
                        </routeCode>
                    </xsl:if>

                    <xsl:if test="hl7:consumable/descendant-or-self::hl7:code">
                        <code>
                            <xsl:call-template name="codeElements">
                                <xsl:with-param name="node" select="hl7:consumable/descendant-or-self::hl7:code"/>
                            </xsl:call-template>
                        </code>
                    </xsl:if>

                </cause>
            </xsl:for-each>
        </exposure>
    </xsl:template>

    <xsl:template name="changeDate">
        <xsl:param name="date"/>

        <xsl:call-template name="convertDate">
            <xsl:with-param name="CurrentDate" select="$TestData/@BaseDateTime"/>
            <xsl:with-param name="MsgBaseDate" select="//descendant-or-self::hl7:creationTime/@value"/>
            <xsl:with-param name="MsgModDate" select="$date"/>
        </xsl:call-template>

        <!-- 
        <xsl:text>(</xsl:text>
        <xsl:value-of select="$TestData/@BaseDateTime"/>
        <xsl:value-of select="//descendant-or-self::hl7:creationTime/@value"/>
        <xsl:value-of select="$date"/>
        <xsl:text>)</xsl:text>
        -->

    </xsl:template>

</xsl:stylesheet>
