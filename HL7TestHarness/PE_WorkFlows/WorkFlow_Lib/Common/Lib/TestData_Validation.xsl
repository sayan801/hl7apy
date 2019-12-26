<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:hl7="urn:hl7-org:v3">
    <xsl:import href="..\Lib\Validation_Lib.xsl"/>
    <xsl:output omit-xml-declaration="yes"/>

    <xsl:param name="require-records-present">false</xsl:param>

    <xsl:variable name="wrong_oid_value">OID Value is incorrect at this location</xsl:variable>
    <xsl:variable name="data_mismatch">message data does not match the data contained with in the test data file</xsl:variable>
    <xsl:variable name="data_mismatch_OID">message data does not match the data contained with in the test data file, OID value provided do not match.</xsl:variable>
    <xsl:variable name="data_mismatch_attr_missing">message element is missing an attribute that is present in the test data file</xsl:variable>
    <xsl:variable name="data_mismatch_person_not_found">Person used in message element does not match the person present in the test data file</xsl:variable>
    <xsl:variable name="data_mismatch_location_not_found">Location used in message element does not match the location present in the test data file</xsl:variable>
    <xsl:variable name="data_mismatch_ID_not_found">ID is expected but no ID was found</xsl:variable>
    <xsl:variable name="data_mismatch_wrong_extension">Extension does not match the value in the Test data file</xsl:variable>
    <xsl:variable name="data_mismatch_text_incorrect">Text value does not match data found in test data file.</xsl:variable>
    <xsl:variable name="data_mismatch_note_not_found">Mismatch of notes found in HL7 message and notes found within the record in the TestData file</xsl:variable>
    <xsl:variable name="data_mismatch_infered_not_indicated">Test Data indicates that record is infered but HL7 message does not include the infered indication elements</xsl:variable>
    <xsl:variable name="data_mismatch_items_not_found">Data found in HL7 message does not match the Data found in the Test Data file. The number of items found with matching criteria differs</xsl:variable>
    <xsl:variable name="data_mismatch_trialSupplycode">Data found in HL7 message does not match the Data found in the Test Data file.</xsl:variable>
    <xsl:variable name="data_mismatch_Rx_Link">Prescription that is linked to this Dispense does not match the Data found in the Test Data file.</xsl:variable>
    <xsl:variable name="data_mismatch_Rx_not_found">Prescription that is linked to this Dispense was not found in the Test Data file.</xsl:variable>

    <xsl:variable name="record-missing">Record can not be located in Test Data file</xsl:variable>


    <!-- Patient Notes Data Validation -->
    <xsl:template match="hl7:controlActEvent/hl7:*/hl7:annotation">
        <xsl:variable name="record-id" select="./ancestor-or-self::hl7:subject/hl7:id/@extension"/>
        <xsl:variable name="record-OID">
            <xsl:call-template name="OID_String">
                <xsl:with-param name="OID" select="./ancestor-or-self::hl7:subject/hl7:id/@root"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="record" select="$TestData/medicalProfiles/medicalProfile[@sequence = '(Generated)']/descendant-or-self::*[record-id/@server = $record-id][record-id/@root_OID = $record-OID]"/>

        <xsl:call-template name="ID_check">
            <xsl:with-param name="actual" select="hl7:id"/>
            <xsl:with-param name="expected" select="$record/record-id"/>
        </xsl:call-template>
        <xsl:call-template name="compare-attributes">
            <xsl:with-param name="actual" select="hl7:code"/>
            <xsl:with-param name="expected" select="$record/code"/>
        </xsl:call-template>
        <xsl:call-template name="compare-attributes">
            <xsl:with-param name="actual" select="hl7:statusCode"/>
            <xsl:with-param name="expected" select="$record/statusCode"/>
        </xsl:call-template>

        <xsl:call-template name="compare-text">
            <xsl:with-param name="actual" select="hl7:text"/>
            <xsl:with-param name="expected" select="$record/text"/>
        </xsl:call-template>

        <xsl:call-template name="compare-people">
            <xsl:with-param name="actual" select="hl7:recordTarget/hl7:patient"/>
            <xsl:with-param name="expected" select="$record/ancestor-or-self::medicalProfile/patient"/>
        </xsl:call-template>
        <xsl:call-template name="compare-people">
            <xsl:with-param name="actual" select="hl7:responsibleParty/hl7:assignedPerson"/>
            <xsl:with-param name="expected" select="$record/supervisor"/>
        </xsl:call-template>
        <xsl:call-template name="compare-people">
            <xsl:with-param name="actual" select="hl7:author/hl7:assignedPerson"/>
            <xsl:with-param name="expected" select="$record/author"/>
        </xsl:call-template>
        <xsl:call-template name="compare-locations">
            <xsl:with-param name="actual" select="hl7:location/hl7:serviceDeliveryLocation"/>
            <xsl:with-param name="expected" select="$record/location"/>
        </xsl:call-template>



    </xsl:template>

    <!-- Allergy Data Validation -->
    <xsl:template match="hl7:intoleranceCondition">

        <xsl:variable name="record-id" select="hl7:id/@extension"/>
        <xsl:variable name="record" select="$TestData/medicalProfiles/medicalProfile[@sequence = '(Generated)']/descendant-or-self::allergy[record-id/@server = $record-id]"/>

        <xsl:choose>
            <xsl:when test="$record">
                <xsl:variable name="item" select="$TestData/allergies/allergie[@description = $record/@description]"/>
                <xsl:variable name="creationTime" select="$record/creationTime/@value"/>
                <!-- TODO: may want to make sure we found an item -->

                <xsl:call-template name="ID_check">
                    <xsl:with-param name="actual" select="hl7:id"/>
                    <xsl:with-param name="expected" select="$record/record-id"/>
                </xsl:call-template>

                <xsl:call-template name="compare-attributes">
                    <xsl:with-param name="actual" select="hl7:code"/>
                    <xsl:with-param name="expected" select="$item/code"/>
                </xsl:call-template>
                <xsl:call-template name="compare-attributes">
                    <xsl:with-param name="actual" select="hl7:statusCode"/>
                    <xsl:with-param name="expected" select="$record/statusCode"/>
                </xsl:call-template>
                <xsl:call-template name="compare-times">
                    <xsl:with-param name="actual" select="hl7:effectiveTime"/>
                    <xsl:with-param name="expected" select="$record/effectiveTime"/>
                    <xsl:with-param name="creationTime" select="$creationTime"/>
                </xsl:call-template>
                <xsl:call-template name="compare-attributes">
                    <xsl:with-param name="actual" select="hl7:uncertaintyCode"/>
                    <xsl:with-param name="expected" select="$record/uncertaintyCode"/>
                </xsl:call-template>
                <xsl:call-template name="compare-attributes">
                    <xsl:with-param name="actual" select="hl7:value"/>
                    <xsl:with-param name="expected" select="$item/value"/>
                </xsl:call-template>
                <xsl:call-template name="compare-attributes">
                    <xsl:with-param name="actual" select="hl7:*/hl7:severityObservation/hl7:value"/>
                    <xsl:with-param name="expected" select="$item/severity"/>
                </xsl:call-template>

                <xsl:call-template name="compare-people">
                    <xsl:with-param name="actual" select="hl7:subject/hl7:patient"/>
                    <xsl:with-param name="expected" select="$record/ancestor-or-self::medicalProfile/patient"/>
                </xsl:call-template>
                <xsl:call-template name="compare-people">
                    <xsl:with-param name="actual" select="hl7:responsibleParty/hl7:assignedPerson"/>
                    <xsl:with-param name="expected" select="$record/supervisor"/>
                </xsl:call-template>
                <xsl:call-template name="compare-people">
                    <xsl:with-param name="actual" select="hl7:author/hl7:assignedPerson"/>
                    <xsl:with-param name="expected" select="$record/author"/>
                </xsl:call-template>
                <!--TODO: need to add informant to both this test and the TestDataLoader.xsl
                <xsl:call-template name="compare-informant">
                    <xsl:with-param name="actual" select="hl7:informant/hl7:patient"/>
                    <xsl:with-param name="expected" select="$record/informant"/>
                </xsl:call-template>-->
                <xsl:call-template name="compare-locations">
                    <xsl:with-param name="actual" select="hl7:location/hl7:serviceDeliveryLocation"/>
                    <xsl:with-param name="expected" select="$record/location"/>
                </xsl:call-template>

                <xsl:for-each select="descendant-or-self::hl7:allergyTestEvent">
                    <xsl:variable name="msg-id" select="hl7:id/@extension"/>
                    <xsl:variable name="msg-code" select="hl7:code/@code"/>
                    <xsl:variable name="msg-value" select="hl7:value/@code"/>
                    <xsl:variable name="allergyTest" select="$record/allergytest[(record-id/@server = $msg-id) or (code/@code = $msg-code and value/@code = $msg-value)] "/>

                    <xsl:choose>
                        <xsl:when test="$allergyTest">
                            <xsl:call-template name="ID_check">
                                <xsl:with-param name="actual" select="hl7:id"/>
                                <xsl:with-param name="expected" select="$allergyTest/record-id"/>
                            </xsl:call-template>
                            <xsl:call-template name="compare-attributes">
                                <xsl:with-param name="actual" select="hl7:code"/>
                                <xsl:with-param name="expected" select="$allergyTest/code"/>
                            </xsl:call-template>
                            <xsl:call-template name="compare-attributes">
                                <xsl:with-param name="actual" select="hl7:statusCode"/>
                                <xsl:with-param name="expected" select="$allergyTest/statusCode"/>
                            </xsl:call-template>
                            <xsl:call-template name="compare-attributes">
                                <xsl:with-param name="actual" select="hl7:value"/>
                                <xsl:with-param name="expected" select="$allergyTest/value"/>
                            </xsl:call-template>
                            <xsl:call-template name="compare-times">
                                <xsl:with-param name="actual" select="hl7:effectiveTime"/>
                                <xsl:with-param name="expected" select="$allergyTest/effectiveTime"/>
                                <xsl:with-param name="creationTime" select="$creationTime"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- did not find an allergy test to validate this against. -->
                            <xsl:call-template name="ReportError">
                                <xsl:with-param name="ErrorText" select="$record-missing"/>
                                <xsl:with-param name="currentNode" select="."/>
                                <xsl:with-param name="actualValue"><xsl:value-of select="hl7:code/@code"/>:<xsl:value-of select="hl7:value/@code"/>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>


                </xsl:for-each>

                <xsl:call-template name="check-notes">
                    <xsl:with-param name="hl7-record" select="."/>
                    <xsl:with-param name="testData-record" select="$record"/>
                </xsl:call-template>

            </xsl:when>
            <xsl:when test="$require-records-present = 'true'">
                <!-- TODO: added error message saying that this record was not expected -->
                <xsl:call-template name="ReportError">
                    <xsl:with-param name="ErrorText" select="$record-missing"/>
                    <xsl:with-param name="currentNode" select="."/>
                    <xsl:with-param name="actualValue" select="$record-id"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>


    </xsl:template>

    <!-- Dispenses -->
    <xsl:template match="hl7:medicationDispense">

        <xsl:variable name="record-id" select="hl7:id/@extension"/>
        <xsl:variable name="record" select="$TestData/medicalProfiles/medicalProfile[@sequence = '(Generated)']/descendant-or-self::dispense[record-id/@server = $record-id]"/>
        
        <xsl:choose>
            <xsl:when test="$record">
                <xsl:variable name="item" select="$TestData/dispenses/dispense[@description = $record/@description]"/>
                <xsl:variable name="creationTime" select="$record/creationTime/@value"/>

                <xsl:call-template name="ID_check">
                    <xsl:with-param name="actual" select="hl7:id"/>
                    <xsl:with-param name="expected" select="$record/record-id"/>
                </xsl:call-template>

                <xsl:call-template name="compare-attributes">
                    <xsl:with-param name="actual" select="hl7:statusCode"/>
                    <xsl:with-param name="expected" select="$item/statusCode"/>
                </xsl:call-template>
                <!-- Dispenses do not identify the patient.
                  <xsl:call-template name="compare-people">
                    <xsl:with-param name="actual" select="hl7:subject/hl7:patient"/>
                    <xsl:with-param name="expected" select="$record/ancestor-or-self::medicalProfile/patient"/>
                </xsl:call-template>-->
                <xsl:call-template name="compare-people">
                    <xsl:with-param name="actual" select="hl7:responsibleParty/hl7:assignedPerson"/>
                    <xsl:with-param name="expected" select="$record/supervisor"/>
                </xsl:call-template>
                <xsl:call-template name="compare-people">
                    <xsl:with-param name="actual" select="hl7:performer/hl7:assignedPerson"/>
                    <xsl:with-param name="expected" select="$record/author"/>
                </xsl:call-template>
                <xsl:call-template name="compare-locations">
                    <xsl:with-param name="actual" select="hl7:location/hl7:serviceDeliveryLocation"/>
                    <xsl:with-param name="expected" select="$record/location"/>
                </xsl:call-template>
                
                <!-- TODO: not sure if this is the correct way to check if we should run this test. -->
                <xsl:if test="$record/prescription and descendant-or-self::hl7:substanceAdministrationRequest">
                    <xsl:call-template name="check-substanceAdministrationRequest">
                        <xsl:with-param name="actual" select="descendant-or-self::hl7:substanceAdministrationRequest"/>
                        <xsl:with-param name="expected" select="$record/prescription"/>
                    </xsl:call-template>
                </xsl:if>
                
                <xsl:for-each select="descendant-or-self::hl7:dosageInstruction">
                    <xsl:call-template name="check-dosageInstruction">
                        <xsl:with-param name="actual" select="."/>
                        <xsl:with-param name="record" select="$item"/>
                        <xsl:with-param name="creationTime" select="$creationTime"/>
                    </xsl:call-template>
                </xsl:for-each>

                <xsl:call-template name="compare-attributes">
                    <xsl:with-param name="actual" select="descendant-or-self::hl7:substitutionMade/hl7:code"/>
                    <xsl:with-param name="expected" select="$record/substitutionMade/code"/>
                </xsl:call-template>
                <xsl:call-template name="compare-attributes">
                    <xsl:with-param name="actual" select="descendant-or-self::hl7:substitutionMade/hl7:reasonCode"/>
                    <xsl:with-param name="expected" select="$record/substitutionMade/reasonCode"/>
                </xsl:call-template>

                <!-- supplyEvent -->
                <xsl:call-template name="compare-attributes">
                    <xsl:with-param name="actual" select="descendant-or-self::hl7:supplyEvent/hl7:code"/>
                    <xsl:with-param name="expected" select="$item/supplyEvent/code"/>
                </xsl:call-template>
                <xsl:call-template name="compare-times">
                    <xsl:with-param name="actual" select="descendant-or-self::hl7:supplyEvent/hl7:effectiveTime/hl7:low"/>
                    <xsl:with-param name="expected" select="$item/supplyEvent/effectiveTime/low"/>
                    <xsl:with-param name="creationTime" select="$creationTime"/>                    
                </xsl:call-template>
                <xsl:call-template name="compare-times">
                    <xsl:with-param name="actual" select="descendant-or-self::hl7:supplyEvent/hl7:effectiveTime/hl7:high"/>
                    <xsl:with-param name="expected" select="$item/supplyEvent/effectiveTime/high"/>
                    <xsl:with-param name="creationTime" select="$creationTime"/>                    
                </xsl:call-template>
                <xsl:call-template name="compare-attributes">
                    <xsl:with-param name="actual" select="descendant-or-self::hl7:supplyEvent/hl7:expectedUseTime/hl7:width"/>
                    <xsl:with-param name="expected" select="$item/supplyEvent/expectedUseTime/width"/>
                </xsl:call-template>
                <xsl:call-template name="check-medication">
                    <xsl:with-param name="actual" select="descendant-or-self::hl7:supplyEvent/descendant-or-self::hl7:player"/>
                    <xsl:with-param name="expected" select="$item/supplyEvent/drug"/>
                </xsl:call-template>
                
                
                <xsl:call-template name="check-notes">
                    <xsl:with-param name="hl7-record" select="."/>
                    <xsl:with-param name="testData-record" select="$record"/>
                </xsl:call-template>                
            </xsl:when>
            <xsl:when test="$require-records-present = 'true'">
                <xsl:call-template name="ReportError">
                    <xsl:with-param name="ErrorText" select="$record-missing"/>
                    <xsl:with-param name="currentNode" select="."/>
                    <xsl:with-param name="actualValue" select="$record-id"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
        
    </xsl:template>
    
    <!-- Prescriptions -->
    <xsl:template match="hl7:combinedMedicationRequest">

        <xsl:variable name="record-id" select="hl7:id/@extension"/>
        <xsl:variable name="record" select="$TestData/medicalProfiles/medicalProfile[@sequence = '(Generated)']/descendant-or-self::prescription[record-id/@server = $record-id]"/>
        
        <xsl:choose>
            <xsl:when test="$record">
                <xsl:variable name="item" select="$TestData/prescriptions/prescription[@description = $record/@description]"/>
                <xsl:variable name="creationTime" select="$record/creationTime/@value"/>
                <!-- TODO: may want to make sure we found an item -->

                <xsl:call-template name="ID_check">
                    <xsl:with-param name="actual" select="hl7:id"/>
                    <xsl:with-param name="expected" select="$record/record-id"/>
                </xsl:call-template>

                <xsl:call-template name="compare-attributes">
                    <xsl:with-param name="actual" select="hl7:statusCode"/>
                    <xsl:with-param name="expected" select="$item/statusCode"/>
                </xsl:call-template>
                <xsl:call-template name="check-medication">
                    <xsl:with-param name="actual" select="hl7:*/hl7:*/hl7:player"/>
                    <xsl:with-param name="expected" select="$item/drug"/>
                </xsl:call-template>
                <xsl:call-template name="compare-people">
                    <xsl:with-param name="actual" select="hl7:subject/hl7:patient"/>
                    <xsl:with-param name="expected" select="$record/ancestor-or-self::medicalProfile/patient"/>
                </xsl:call-template>
                <xsl:call-template name="compare-people">
                    <xsl:with-param name="actual" select="hl7:responsibleParty/hl7:assignedPerson"/>
                    <xsl:with-param name="expected" select="$record/supervisor"/>
                </xsl:call-template>
                <xsl:call-template name="compare-people">
                    <xsl:with-param name="actual" select="hl7:author/hl7:assignedPerson"/>
                    <xsl:with-param name="expected" select="$record/author"/>
                </xsl:call-template>
                <xsl:call-template name="compare-locations">
                    <xsl:with-param name="actual" select="hl7:location/hl7:serviceDeliveryLocation"/>
                    <xsl:with-param name="expected" select="$record/location"/>
                </xsl:call-template>

                <xsl:for-each select="hl7:reason/hl7:*[self::hl7:observationSymptom | self::hl7:observationDiagnosis | self::hl7:otherIndication]">
                    <xsl:call-template name="check-indications">
                        <xsl:with-param name="actual" select="."/>
                        <xsl:with-param name="expected" select="$item"/>
                    </xsl:call-template>
                </xsl:for-each>

                <xsl:call-template name="compare-attributes">
                    <xsl:with-param name="actual" select="descendant-or-self::hl7:verificationEventCriterion/hl7:code"/>
                    <xsl:with-param name="expected" select="$item/non-authoritative"/>
                </xsl:call-template>

                <xsl:if test="$record/@infered = 'true' and not(descendant-or-self::hl7:sourceDispense) ">
                    <xsl:call-template name="ReportError">
                        <xsl:with-param name="ErrorText" select="$data_mismatch_infered_not_indicated"/>
                        <xsl:with-param name="currentNode" select="."/>
                        <xsl:with-param name="elementName"/>
                        <xsl:with-param name="actualValue"/>
                        <xsl:with-param name="expectedValue">derivedFrom/sourceDispense</xsl:with-param>
                    </xsl:call-template>
                </xsl:if>

                <xsl:if test="descendant-or-self::hl7:administrationInstructions">
                    <xsl:call-template name="compare-text">
                        <xsl:with-param name="actual" select="descendant-or-self::hl7:administrationInstructions/hl7:text"/>
                        <xsl:with-param name="expected" select="$item/dosageInstruction/text"/>
                    </xsl:call-template>
                </xsl:if>

                <xsl:for-each select="descendant-or-self::hl7:dosageInstruction">
                    <xsl:call-template name="check-dosageInstruction">
                        <xsl:with-param name="actual" select="."/>
                        <xsl:with-param name="record" select="$item"/>
                        <xsl:with-param name="creationTime" select="$creationTime"/>
                    </xsl:call-template>
                </xsl:for-each>
                
                <xsl:choose>
                    <xsl:when test="descendant-or-self::hl7:trialSupplyPermission/parent::hl7:*/@negationInd = 'true' and $item/trialSupplycode"/>
                    <xsl:when test="descendant-or-self::hl7:trialSupplyPermission/parent::hl7:*/@negationInd = 'false' and not($item/trialSupplycode)"/>
                    <xsl:otherwise>
                        <xsl:call-template name="ReportError">
                            <xsl:with-param name="ErrorText" select="$data_mismatch_trialSupplycode"/>
                            <xsl:with-param name="currentNode" select="descendant-or-self::hl7:trialSupplyPermission"/>
                            <xsl:with-param name="actualValue">negationInd = <xsl:value-of select="descendant-or-self::hl7:trialSupplyPermission/parent::hl7:*/@negationInd"/></xsl:with-param>
                            <xsl:with-param name="expectedValue">negationInd = <xsl:choose>
                                    <xsl:when test="$item/trialSupplycode">true</xsl:when>
                                    <xsl:otherwise>false</xsl:otherwise>
                                </xsl:choose>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>

                <!-- should only be one of these but doing the for each makes processing it easier -->
                <xsl:for-each select="descendant-or-self::hl7:supplyRequest">

                    <xsl:call-template name="compare-attributes">
                        <xsl:with-param name="actual" select="hl7:statusCode"/>
                        <xsl:with-param name="expected" select="$item/statusCode"/>
                    </xsl:call-template>
                    <xsl:call-template name="compare-times">
                        <xsl:with-param name="actual" select="hl7:effectiveTime/hl7:low"/>
                        <xsl:with-param name="expected" select="$item/effectiveTime/low"/>
                        <xsl:with-param name="creationTime" select="$creationTime"/>
                    </xsl:call-template>
                    <xsl:call-template name="compare-times">
                        <xsl:with-param name="actual" select="hl7:effectiveTime/hl7:high"/>
                        <xsl:with-param name="expected" select="$item/effectiveTime/high"/>
                        <xsl:with-param name="creationTime" select="$creationTime"/>
                    </xsl:call-template>
                    <!-- TODO: add validation of receiver, should be done in the same way as informant. -->
                    <xsl:if test="$item/pharmacylocation">
                        <xsl:call-template name="compare-locations">
                            <xsl:with-param name="actual" select="hl7:location/hl7:serviceDeliveryLocation"/>
                            <xsl:with-param name="expected" select="$item/pharmacylocation"/>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:for-each select="hl7:*/hl7:supplyRequestItem">

                        <xsl:variable name="drug-codeSystem">
                            <xsl:call-template name="OID_String">
                                <xsl:with-param name="OID" select="descendant-or-self::hl7:player/hl7:code/@codeSystem"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="drug-code" select="descendant-or-self::hl7:player/hl7:code/@code"/>
                        <xsl:variable name="drug-description" select="$TestData/drugs/drug[code/@code = $drug-code][code/@codeSystem = $drug-codeSystem]/@description"/>
                        <xsl:variable name="expected-item" select="$item/supplyRequestItem[not($drug-description) or not(drug) or (drug/@description = $drug-description)][1]"/>

                        <xsl:choose>
                            <xsl:when test="$expected-item">
                                <xsl:call-template name="compare-attributes">
                                    <xsl:with-param name="actual" select="hl7:quantity"/>
                                    <xsl:with-param name="expected" select="$expected-item/quantity"/>
                                </xsl:call-template>
                                <xsl:call-template name="compare-attributes">
                                    <xsl:with-param name="actual" select="hl7:expectedUseTime/hl7:width"/>
                                    <xsl:with-param name="expected" select="$item/expectedUseTime/width"/>
                                </xsl:call-template>

                                <!-- subsequentSupplyRequest -->
                                <xsl:call-template name="compare-attributes">
                                    <xsl:with-param name="actual" select="hl7:*/hl7:subsequentSupplyRequest/hl7:effectiveTime/hl7:width"/>
                                    <xsl:with-param name="expected" select="$item/subsequentSupplyRequest/effectiveTime/width"/>
                                </xsl:call-template>
                                <xsl:call-template name="compare-attributes">
                                    <xsl:with-param name="actual" select="hl7:*/hl7:subsequentSupplyRequest/hl7:repeatNumber"/>
                                    <xsl:with-param name="expected" select="$item/subsequentSupplyRequest/repeatNumber"/>
                                </xsl:call-template>
                                <xsl:call-template name="compare-attributes">
                                    <xsl:with-param name="actual" select="hl7:*/hl7:subsequentSupplyRequest/hl7:quantity"/>
                                    <xsl:with-param name="expected" select="$item/subsequentSupplyRequest/quantity"/>
                                </xsl:call-template>
                                <xsl:call-template name="compare-attributes">
                                    <xsl:with-param name="actual" select="hl7:*/hl7:subsequentSupplyRequest/hl7:expectedUseTime/hl7:width"/>
                                    <xsl:with-param name="expected" select="$item/subsequentSupplyRequest/expectedUseTime/width"/>
                                </xsl:call-template>

                                <!-- initialSupplyRequest -->
                                <xsl:call-template name="compare-times">
                                    <xsl:with-param name="actual" select="hl7:*/hl7:initialSupplyRequest/hl7:effectiveTime/hl7:high"/>
                                    <xsl:with-param name="expected" select="$item/initialSupplyRequest/effectiveTime/high"/>
                                    <xsl:with-param name="creationTime" select="$creationTime"/>
                                </xsl:call-template>

                                <xsl:call-template name="compare-attributes">
                                    <xsl:with-param name="actual" select="hl7:*/hl7:initialSupplyRequest/hl7:quantity"/>
                                    <xsl:with-param name="expected" select="$item/initialSupplyRequest/quantity"/>
                                </xsl:call-template>
                                <xsl:call-template name="compare-attributes">
                                    <xsl:with-param name="actual" select="hl7:*/hl7:initialSupplyRequest/hl7:expectedUseTime/hl7:width"/>
                                    <xsl:with-param name="expected" select="$item/initialSupplyRequest/expectedUseTime/width"/>
                                </xsl:call-template>

                                <!-- supplyEventFirstSummary -->
                                <xsl:call-template name="compare-times">
                                    <xsl:with-param name="actual" select="hl7:*/hl7:initialSupplyRequest/hl7:effectiveTime/hl7:high"/>
                                    <xsl:with-param name="expected" select="$item/initialSupplyRequest/effectiveTime/high"/>
                                    <xsl:with-param name="creationTime" select="$creationTime"/>
                                </xsl:call-template>
                                <xsl:call-template name="compare-attributes">
                                    <xsl:with-param name="actual" select="hl7:*/hl7:supplyEventFirstSummary/hl7:quantity"/>
                                    <xsl:with-param name="expected" select="$item/supplyEventFirstSummary/quantity"/>
                                </xsl:call-template>

                                <!-- supplyEventLastSummary -->
                                <xsl:call-template name="compare-times">
                                    <xsl:with-param name="actual" select="hl7:*/hl7:supplyEventLastSummary/hl7:effectiveTime/hl7:high"/>
                                    <xsl:with-param name="expected" select="$item/supplyEventLastSummary/effectiveTime/high"/>
                                    <xsl:with-param name="creationTime" select="$creationTime"/>
                                </xsl:call-template>
                                <xsl:call-template name="compare-attributes">
                                    <xsl:with-param name="actual" select="hl7:*/hl7:supplyEventLastSummary/hl7:quantity"/>
                                    <xsl:with-param name="expected" select="$item/supplyEventLastSummary/quantity"/>
                                </xsl:call-template>

                                <!-- supplyEventFutureSummary -->
                                <xsl:call-template name="compare-attributes">
                                    <xsl:with-param name="actual" select="hl7:*/hl7:supplyEventFutureSummary/hl7:repeatNumber"/>
                                    <xsl:with-param name="expected" select="$item/supplyEventFutureSummary/repeatNumber"/>
                                </xsl:call-template>
                                <xsl:call-template name="compare-attributes">
                                    <xsl:with-param name="actual" select="hl7:*/hl7:supplyEventFutureSummary/hl7:quantity"/>
                                    <xsl:with-param name="expected" select="$item/supplyEventFutureSummary/quantity"/>
                                </xsl:call-template>

                                <!-- supplyEventPastSummary -->
                                <xsl:call-template name="compare-attributes">
                                    <xsl:with-param name="actual" select="hl7:*/hl7:supplyEventPastSummary/hl7:repeatNumber"/>
                                    <xsl:with-param name="expected" select="$item/supplyEventPastSummary/repeatNumber"/>
                                </xsl:call-template>
                                <xsl:call-template name="compare-attributes">
                                    <xsl:with-param name="actual" select="hl7:*/hl7:supplyEventPastSummary/hl7:quantity"/>
                                    <xsl:with-param name="expected" select="$item/supplyEventPastSummary/quantity"/>
                                </xsl:call-template>

                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="ReportError">
                                    <xsl:with-param name="ErrorText" select="$record-missing"/>
                                    <xsl:with-param name="currentNode" select="."/>
                                    <xsl:with-param name="actualValue"/>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>


                </xsl:for-each>

                <!-- TODO: need to add checks for fulfillment/medicationDispense -->

                <xsl:call-template name="check-notes">
                    <xsl:with-param name="hl7-record" select="."/>
                    <xsl:with-param name="testData-record" select="$record"/>
                </xsl:call-template>

                <xsl:for-each select="descendant-or-self::hl7:medicationDispense">
                    <xsl:apply-templates select="."/>
                </xsl:for-each>
                
            </xsl:when>
            <xsl:when test="$require-records-present = 'true'">
                <xsl:call-template name="ReportError">
                    <xsl:with-param name="ErrorText" select="$record-missing"/>
                    <xsl:with-param name="currentNode" select="."/>
                    <xsl:with-param name="actualValue" select="$record-id"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>


    </xsl:template>


    <!-- Below are templates used to validate parts of messages. -->
    <xsl:template name="check-medication">
        <xsl:param name="actual"/>
        <xsl:param name="expected"/>

        <xsl:variable name="expected-drug" select="$TestData/drugs/drug[@description = $expected/@description]"/>

        <xsl:call-template name="compare-attributes">
            <xsl:with-param name="actual" select="$actual/hl7:code"/>
            <xsl:with-param name="expected" select="$expected-drug/code"/>
        </xsl:call-template>
        <xsl:call-template name="compare-text">
            <xsl:with-param name="actual" select="$actual/hl7:name"/>
            <xsl:with-param name="expected" select="$expected-drug/name"/>
        </xsl:call-template>
        <xsl:call-template name="compare-attributes">
            <xsl:with-param name="actual" select="$actual/hl7:formCode"/>
            <xsl:with-param name="expected" select="$expected-drug/formCode"/>
        </xsl:call-template>
        <xsl:call-template name="compare-attributes">
            <xsl:with-param name="actual" select="$actual/hl7:asContent/hl7:quantity"/>
            <xsl:with-param name="expected" select="$expected-drug/quantity"/>
        </xsl:call-template>
        <xsl:call-template name="compare-attributes">
            <xsl:with-param name="actual" select="$actual/hl7:asContent/hl7:containerPackagedMedicine/hl7:formCode"/>
            <xsl:with-param name="expected" select="$expected-drug/packageformCode"/>
        </xsl:call-template>

        <xsl:for-each select="$actual/hl7:ingredient">
            <xsl:variable name="codeSystem">
                <xsl:call-template name="OID_String">
                    <xsl:with-param name="OID" select="hl7:ingredient/hl7:code/@codeSystem"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="code" select="hl7:ingredient/hl7:code/@code"/>

            <xsl:variable name="expected-ingredient" select="$expected-drug/ingredient[code/@code = $code][code/@codeSystem = $codeSystem]"/>

            <xsl:choose>
                <xsl:when test="$expected-ingredient">

                    <xsl:call-template name="compare-attribute">
                        <xsl:with-param name="actual" select="@negationInd"/>
                        <xsl:with-param name="expected" select="$expected-ingredient/@negation"/>
                    </xsl:call-template>
                    <xsl:call-template name="compare-attributes">
                        <xsl:with-param name="actual" select="hl7:quantity"/>
                        <xsl:with-param name="expected" select="$expected-ingredient/quantity"/>
                    </xsl:call-template>
                    <xsl:call-template name="compare-text">
                        <xsl:with-param name="actual" select="hl7:ingredient/hl7:name"/>
                        <xsl:with-param name="expected" select="$expected-ingredient/name"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="ReportError">
                        <xsl:with-param name="ErrorText" select="$record-missing"/>
                        <xsl:with-param name="currentNode" select="."/>
                        <xsl:with-param name="elementName"/>
                        <xsl:with-param name="actualValue"/>
                        <xsl:with-param name="expectedValue"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>

        </xsl:for-each>



    </xsl:template>
    <xsl:template name="check-notes">
        <xsl:param name="hl7-record"/>
        <xsl:param name="testData-record"/>

        <xsl:variable name="testData-note-count" select="count($testData-record/descendant-or-self::note)"/>
        <xsl:variable name="hl7-note-count" select="count($hl7-record/descendant-or-self::hl7:annotation)"/>
        <xsl:variable name="hl7-note-indication-count" select="count($hl7-record/descendant-or-self::hl7:annotationIndicator)"/>

        <xsl:if test="$testData-note-count &gt; 0 and $hl7-note-count = 0 and $hl7-note-indication-count = 0">
            <xsl:call-template name="ReportError">
                <xsl:with-param name="ErrorText" select="$data_mismatch_note_not_found"/>
                <xsl:with-param name="currentNode" select="$hl7-record"/>
                <xsl:with-param name="actualValue">
                    <xsl:value-of select="$hl7-note-count"/>
                </xsl:with-param>
                <xsl:with-param name="expectedValue">
                    <xsl:value-of select="$testData-note-count"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="$hl7-note-count &gt; 0">
            <xsl:for-each select="$hl7-record/descendant-or-self::hl7:annotation">
                <xsl:call-template name="compare-notes">
                    <xsl:with-param name="note-node" select="."/>
                    <xsl:with-param name="record-node" select="$testData-record"/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:if>


    </xsl:template>
    <xsl:template name="check-indications">
        <xsl:param name="actual"/>
        <xsl:param name="expected"/>

        <xsl:variable name="indication-name" select="local-name($actual)"/>
        <xsl:variable name="indication-value">
            <xsl:choose>
                <xsl:when test="$indication-name = 'otherIndication'">
                    <xsl:value-of select="$actual/hl7:code/@code"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$actual/hl7:value/@code"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="expected-indication" select="$expected/reason[@type = $indication-name][not(value/@code) or (value/@code = $indication-value)][not(text) or (text = $actual/text)]"/>

        <xsl:choose>
            <xsl:when test="$expected-indication">
                <xsl:choose>
                    <xsl:when test="$indication-name = 'otherIndication'">
                        <xsl:call-template name="compare-attributes">
                            <xsl:with-param name="actual" select="$actual/hl7:code"/>
                            <xsl:with-param name="expected" select="$expected-indication/value"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="compare-attributes">
                            <xsl:with-param name="actual" select="$actual/hl7:value"/>
                            <xsl:with-param name="expected" select="$expected-indication/value"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:call-template name="compare-attributes">
                    <xsl:with-param name="actual" select="$actual/hl7:statusCode"/>
                    <xsl:with-param name="expected" select="$expected-indication/statusCode"/>
                </xsl:call-template>
                <xsl:call-template name="compare-text">
                    <xsl:with-param name="actual" select="$actual/hl7:text"/>
                    <xsl:with-param name="expected" select="$expected-indication/text"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="ReportError">
                    <xsl:with-param name="ErrorText" select="$record-missing"/>
                    <xsl:with-param name="currentNode" select="$actual"/>
                    <xsl:with-param name="actualValue"><xsl:value-of select="$indication-name"/>:<xsl:value-of select="$indication-value"/> : <xsl:value-of select="$actual/text"/></xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>


    </xsl:template>
<xsl:template name="check-dosageInstruction">
    <xsl:param name="actual"/>
    <xsl:param name="record"/>
    <xsl:param name="creationTime"/>
    
                    <xsl:variable name="drug-codeSystem">
                        <xsl:call-template name="OID_String">
                            <xsl:with-param name="OID" select="$actual/descendant-or-self::hl7:player/hl7:code/@codeSystem"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:variable name="drug-code" select="$actual/descendant-or-self::hl7:player/hl7:code/@code"/>

                    <xsl:variable name="drug-description" select="$TestData/drugs/drug[code/@code = $drug-code][code/@codeSystem = $drug-codeSystem]/@description"/>

                    <xsl:variable name="expected-item" select="$record/dosageInstruction[not($drug-description) or not(drug) or (drug/@description = $drug-description)][1]"/>

                    <xsl:choose>
                        <xsl:when test="$expected-item">

                            <xsl:call-template name="compare-text">
                                <xsl:with-param name="actual" select="$actual/hl7:text"/>
                                <xsl:with-param name="expected" select="$expected-item/text"/>
                            </xsl:call-template>
                            <xsl:call-template name="compare-times">
                                <xsl:with-param name="actual" select="$actual/hl7:effectiveTime/hl7:low"/>
                                <xsl:with-param name="expected" select="$expected-item/effectiveTime/low"/>
                                <xsl:with-param name="creationTime" select="$creationTime"/>
                            </xsl:call-template>
                            <xsl:call-template name="compare-times">
                                <xsl:with-param name="actual" select="$actual/hl7:effectiveTime/hl7:high"/>
                                <xsl:with-param name="expected" select="$expected-item/effectiveTime/high"/>
                                <xsl:with-param name="creationTime" select="$creationTime"/>
                            </xsl:call-template>
                            <xsl:for-each select="$actual/hl7:approachSiteCode">
                                <xsl:variable name="code" select="@code"/>
                                <xsl:variable name="actual-count" select="count($actual/ancestor-or-self::hl7:dosageInstruction/hl7:approachSiteCode[@code = $code])"/>
                                <xsl:variable name="expected-count" select="count($expected-item/approachSiteCode[@code = $code])"/>
                                <xsl:if test="not($actual-count = $expected-count)">
                                    <xsl:call-template name="ReportError">
                                        <xsl:with-param name="ErrorText" select="$data_mismatch_items_not_found"/>
                                        <xsl:with-param name="currentNode" select="."/>
                                        <xsl:with-param name="actualValue">
                                            <xsl:value-of select="$actual-count"/>
                                        </xsl:with-param>
                                        <xsl:with-param name="expectedValue">
                                            <xsl:value-of select="$expected-count"/>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </xsl:if>
                            </xsl:for-each>

                            <xsl:call-template name="compare-attributes">
                                <xsl:with-param name="actual" select="$actual/hl7:maxDoseQuantity/hl7:numerator"/>
                                <xsl:with-param name="expected" select="$expected-item/maxDoseQuantity/numerator"/>
                            </xsl:call-template>
                            <xsl:call-template name="compare-attributes">
                                <xsl:with-param name="actual" select="$actual/hl7:maxDoseQuantity/hl7:denominator"/>
                                <xsl:with-param name="expected" select="$expected-item/maxDoseQuantity/denominator"/>
                            </xsl:call-template>
                            <xsl:call-template name="compare-attributes">
                                <xsl:with-param name="actual" select="$actual/hl7:administrationUnitCode"/>
                                <xsl:with-param name="expected" select="$expected-item/administrationUnitCode"/>
                            </xsl:call-template>
                            <xsl:call-template name="check-medication">
                                <xsl:with-param name="actual" select="$actual/descendant-or-self::hl7:dosageInstruction/descendant-or-self::hl7:player"/>
                                <xsl:with-param name="expected" select="$expected-item/drug"/>
                            </xsl:call-template>
                            <xsl:call-template name="compare-text">
                                <xsl:with-param name="actual" select="$actual/descendant-or-self::hl7:supplementalInstruction/hl7:text"/>
                                <xsl:with-param name="expected" select="$expected-item/instruction"/>
                            </xsl:call-template>

                            <xsl:for-each select="$actual/descendant-or-self::hl7:*[hl7:dosageLine]">
                                <xsl:variable name="seqNumber" select="$actual/hl7:sequenceNumber/@value"/>
                                <xsl:variable name="actual-text" select="$actual/hl7:dosageLine/hl7:text"/>
                                <xsl:variable name="expected-text" select="$expected-item/dosageLine[@sequenceNumber = $seqNumber]"/>
                                <xsl:if test="not($expected-text)">
                                    <xsl:call-template name="ReportError">
                                        <xsl:with-param name="ErrorText" select="$data_mismatch_items_not_found"/>
                                        <xsl:with-param name="currentNode" select="."/>
                                        <xsl:with-param name="actualValue">
                                            <xsl:value-of select="$actual-text"/>
                                        </xsl:with-param>
                                        <xsl:with-param name="expectedValue"/>
                                    </xsl:call-template>
                                </xsl:if>
                                <xsl:call-template name="compare-text">
                                    <xsl:with-param name="actual" select="$actual-text"/>
                                    <xsl:with-param name="expected" select="$expected-text"/>
                                </xsl:call-template>
                            </xsl:for-each>

                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="ReportError">
                                <xsl:with-param name="ErrorText" select="$data_mismatch_items_not_found"/>
                                <xsl:with-param name="currentNode" select="$actual"/>
                                <xsl:with-param name="actualValue"/>
                                <xsl:with-param name="expectedValue"/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
    
</xsl:template>
<xsl:template name="check-substanceAdministrationRequest">
    <xsl:param name="actual"/>
    <xsl:param name="expected"/>
    
        <xsl:variable name="record-id" select="$actual/hl7:id/@extension"/>
        <xsl:variable name="record" select="$TestData/medicalProfiles/medicalProfile[@sequence = '(Generated)']/descendant-or-self::prescription[record-id/@server = $record-id]"/>
    
    <xsl:choose>
        <xsl:when test="$record">
            <xsl:call-template name="ID_check">
                <xsl:with-param name="actual" select="hl7:id"/>
                <xsl:with-param name="expected" select="$record/record-id"/>
            </xsl:call-template>
            <xsl:if test="$actual/hl7:responsibleParty">
                <xsl:call-template name="compare-people">
                    <xsl:with-param name="actual" select="hl7:responsibleParty/hl7:assignedPerson"/>
                    <xsl:with-param name="expected" select="$record/supervisor"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="$actual/hl7:author">
                <xsl:call-template name="compare-people">
                    <xsl:with-param name="actual" select="hl7:performer/hl7:assignedPerson"/>
                    <xsl:with-param name="expected" select="$record/author"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="not($record/@description = $expected/@description)">
                    <xsl:call-template name="ReportError">
                        <xsl:with-param name="ErrorText" select="$data_mismatch_Rx_Link"/>
                        <xsl:with-param name="currentNode" select="$actual"/>
                        <xsl:with-param name="actualValue" select="$record/@description"/>
                        <xsl:with-param name="expectedValue" select="$expected/@description"/>
                    </xsl:call-template>
            </xsl:if>
        </xsl:when>
        <xsl:otherwise>
                    <xsl:call-template name="ReportError">
                        <xsl:with-param name="ErrorText" select="$data_mismatch_Rx_not_found"/>
                        <xsl:with-param name="currentNode" select="$actual"/>
                        <xsl:with-param name="actualValue" select="$record/@description"/>
                        <xsl:with-param name="expectedValue" select="$expected/@description"/>
                    </xsl:call-template>
        </xsl:otherwise>
    </xsl:choose>
    
</xsl:template>
    
    <xsl:template name="compare-notes">
        <xsl:param name="note-node"/>
        <xsl:param name="record-node"/>

        <xsl:variable name="note-text" select="$note-node/hl7:text"/>
        <xsl:variable name="note-author-id" select="$note-node/hl7:author/hl7:assignedPerson/hl7:id/@extension"/>
        <xsl:variable name="note-author-root" select="$note-node/hl7:author/hl7:assignedPerson/hl7:id/@root"/>
        <xsl:variable name="OID_Str">
            <xsl:call-template name="OID_String">
                <xsl:with-param name="OID" select="$note-author-root"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="actual-author">
            <xsl:choose>
                <xsl:when test="$TestData/providers/provider[@OID = $OID_Str][server/id/@extension = $note-author-id]">
                    <xsl:value-of select="$TestData/providers/provider[@OID = $OID_Str][server/id/@extension = $note-author-id]/@description"/>
                </xsl:when>
                <xsl:otherwise><xsl:value-of select="$note-author-id"/> : <xsl:value-of select="$OID_Str"/> (Person not found in Test Data file) </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="hl7-note-count"
            select="count($note-node/parent::hl7:*/parent::hl7:*/descendant-or-self::hl7:annotation[hl7:text = $note-text][hl7:author/hl7:assignedPerson/hl7:id/@extension = $note-author-id][hl7:author/hl7:assignedPerson/hl7:id/@root = $note-author-root])"/>
        <xsl:variable name="testData-note-count" select="count($record-node/note[text = $note-text][author/@description = $actual-author])"/>


        <xsl:choose>
            <xsl:when test="$hl7-note-count = 0">
                <xsl:call-template name="ReportError">
                    <xsl:with-param name="ErrorText">Problem with note counting(<xsl:value-of select="$note-text"/>)(<xsl:value-of select="$actual-author"/>)</xsl:with-param>
                    <xsl:with-param name="currentNode" select="$note-node"/>
                    <xsl:with-param name="actualValue">
                        <xsl:value-of select="$hl7-note-count"/>
                    </xsl:with-param>
                    <xsl:with-param name="expectedValue">
                        <xsl:value-of select="$testData-note-count"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="not($hl7-note-count = $testData-note-count)">
                <xsl:call-template name="ReportError">
                    <xsl:with-param name="ErrorText" select="$data_mismatch_note_not_found"/>
                    <xsl:with-param name="currentNode" select="$note-node"/>
                    <xsl:with-param name="actualValue">Count Found in HL7 message: <xsl:value-of select="$hl7-note-count"/></xsl:with-param>
                    <xsl:with-param name="expectedValue">Count Found in Test Data: <xsl:value-of select="$testData-note-count"/></xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise> </xsl:otherwise>
        </xsl:choose>


    </xsl:template>
    <xsl:template name="compare-attribute">
        <xsl:param name="expected"/>
        <xsl:param name="actual"/>

        <xsl:choose>
            <xsl:when test="($expected and $actual) and not($expected = $actual)">
                <xsl:call-template name="ReportError">
                    <xsl:with-param name="ErrorText" select="$data_mismatch"/>
                    <xsl:with-param name="currentNode" select="$actual"/>
                     <xsl:with-param name="elementName">@<xsl:value-of select="name($actual)"/></xsl:with-param>
                    <xsl:with-param name="actualValue" select="$actual"/>
                    <xsl:with-param name="expectedValue" select="$expected"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$expected and not($actual)">
                <xsl:call-template name="ReportError">
                    <xsl:with-param name="ErrorText" select="$data_mismatch_attr_missing"/>
                    <xsl:with-param name="currentNode" select="$actual"/>
                     <xsl:with-param name="elementName">../@<xsl:value-of select="name($expected)"/> [xpath not fully known]</xsl:with-param>
                    <xsl:with-param name="actualValue"/>
                    <xsl:with-param name="expectedValue" select="$expected"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>


    </xsl:template>
    <xsl:template name="compare-attributes">
        <xsl:param name="expected"/>
        <xsl:param name="actual"/>

        <!-- this is being used if actual does not contain any nodes -->
        <xsl:variable name="xpath-location" select="."/>
        <xsl:for-each select="$expected/@*">
            <xsl:variable name="attr-name" select="local-name()"/>
            <xsl:variable name="actual-attr" select="$actual/@*[local-name() = $attr-name]"/>
            <xsl:variable name="expected-attr" select="."/>
            <xsl:choose>
                <xsl:when test="not($actual-attr)">
                    <xsl:call-template name="ReportError">
                        <xsl:with-param name="ErrorText" select="$data_mismatch_attr_missing"/>
                        <xsl:with-param name="currentNode" select="$xpath-location"/>
                        <xsl:with-param name="elementName">../@<xsl:value-of select="$attr-name"/> [xpath not fully known]</xsl:with-param>
                        <xsl:with-param name="actualValue"/>
                        <xsl:with-param name="expectedValue" select="$expected-attr"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$attr-name = 'codeSystem' ">
                    <xsl:variable name="codeSystem">
                        <xsl:call-template name="OID_String">
                            <xsl:with-param name="OID" select="$actual-attr"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:if test="not($codeSystem = $expected-attr)">
                        <xsl:call-template name="ReportError">
                            <xsl:with-param name="ErrorText" select="$data_mismatch_OID"/>
                            <xsl:with-param name="currentNode" select="$actual"/>
                        <xsl:with-param name="elementName">@<xsl:value-of select="$attr-name"/></xsl:with-param>
                            <xsl:with-param name="actualValue" select="$codeSystem"/>
                            <xsl:with-param name="expectedValue" select="$expected-attr"/>
                        </xsl:call-template>
                    </xsl:if>

                </xsl:when>
                <xsl:when test="not($actual-attr = $expected-attr)">
                    <xsl:call-template name="ReportError">
                        <xsl:with-param name="ErrorText" select="$data_mismatch"/>
                        <xsl:with-param name="currentNode" select="$actual"/>
                        <xsl:with-param name="elementName">@<xsl:value-of select="$attr-name"/></xsl:with-param>
                        <xsl:with-param name="actualValue" select="$actual-attr"/>
                        <xsl:with-param name="expectedValue" select="$expected-attr"/>
                    </xsl:call-template>
                </xsl:when>
            </xsl:choose>

        </xsl:for-each>

    </xsl:template>
    <xsl:template name="compare-times">
        <xsl:param name="expected"/>
        <xsl:param name="actual"/>
        <xsl:param name="creationTime"/>

        <xsl:for-each select="$expected/@*">
            <xsl:variable name="attr-name" select="local-name()"/>
            <xsl:variable name="actual-attr" select="$actual/@*[local-name() = $attr-name]"/>
            <xsl:variable name="expected-attr">
                <xsl:choose>
                    <xsl:when test="$attr-name = 'value'">
                        <xsl:call-template name="convertDate">
                            <xsl:with-param name="CurrentDate" select="$creationTime"/>
                            <xsl:with-param name="MsgBaseDate" select="$TestData/@BaseDateTime"/>
                            <xsl:with-param name="MsgModDate" select="."/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="."/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="not($actual-attr)">
                    <xsl:call-template name="ReportError">
                        <xsl:with-param name="ErrorText" select="$data_mismatch_attr_missing"/>
                        <xsl:with-param name="currentNode" select="$actual"/>
                        <xsl:with-param name="elementName" select="$attr-name"/>
                        <xsl:with-param name="actualValue"/>
                        <xsl:with-param name="expectedValue" select="$expected-attr"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$attr-name = 'codeSystem' ">
                    <xsl:variable name="codeSystem">
                        <xsl:call-template name="OID_String">
                            <xsl:with-param name="OID" select="$actual-attr"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:if test="not($codeSystem = $expected-attr)">
                        <xsl:call-template name="ReportError">
                            <xsl:with-param name="ErrorText" select="$data_mismatch_OID"/>
                            <xsl:with-param name="currentNode" select="$actual"/>
                            <xsl:with-param name="elementName" select="$attr-name"/>
                            <xsl:with-param name="actualValue" select="$codeSystem"/>
                            <xsl:with-param name="expectedValue" select="$expected-attr"/>
                        </xsl:call-template>
                    </xsl:if>

                </xsl:when>
                <xsl:when test="not($actual-attr = $expected-attr)">
                    <xsl:call-template name="ReportError">
                        <xsl:with-param name="ErrorText" select="$data_mismatch"/>
                        <xsl:with-param name="currentNode" select="$actual"/>
                        <xsl:with-param name="elementName" select="$attr-name"/>
                        <xsl:with-param name="actualValue" select="$actual-attr"/>
                        <xsl:with-param name="expectedValue" select="$expected-attr"/>
                    </xsl:call-template>
                </xsl:when>
            </xsl:choose>

        </xsl:for-each>

    </xsl:template>
    <xsl:template name="compare-text">
        <xsl:param name="actual"/>
        <xsl:param name="expected"/>
        <xsl:if test="not($actual = $expected)">
            <xsl:call-template name="ReportError">
                <xsl:with-param name="ErrorText" select="$data_mismatch_text_incorrect"/>
                <xsl:with-param name="currentNode" select="$actual"/>
                <xsl:with-param name="elementName"/>
                <xsl:with-param name="actualValue" select="$actual"/>
                <xsl:with-param name="expectedValue" select="$expected"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template name="compare-people">
        <xsl:param name="actual"/>
        <xsl:param name="expected"/>

        <xsl:choose>
            <xsl:when test="$actual">
                <xsl:variable name="expected-person">
                    <xsl:choose>
                        <xsl:when test="$expected">
                            <xsl:value-of select="$expected/@description"/>
                        </xsl:when>
                        <xsl:otherwise>(No Person stored for this Item in Test Data file)</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="OID_Str">
                    <xsl:call-template name="OID_String">
                        <xsl:with-param name="OID" select="$actual/hl7:id/@root"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="person-id" select="$actual/hl7:id/@extension"/>

                <xsl:variable name="actual-person">
                    <xsl:choose>
                        <xsl:when test="$TestData/patients/patient[@OID = $OID_Str][server/phn = $person-id]">
                            <xsl:value-of select="$TestData/patients/patient[@OID = $OID_Str][server/phn = $person-id]/@description"/>
                        </xsl:when>
                        <xsl:when test="$TestData/providers/provider[@OID = $OID_Str][server/id/@extension = $person-id]">
                            <xsl:value-of select="$TestData/providers/provider[@OID = $OID_Str][server/id/@extension = $person-id]/@description"/>
                        </xsl:when>
                        <xsl:otherwise><xsl:value-of select="$person-id"/> : <xsl:value-of select="$OID_Str"/> (Person not found in Test Data file) </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <xsl:if test="not($actual-person = $expected-person)">
                    <xsl:call-template name="ReportError">
                        <xsl:with-param name="ErrorText" select="$data_mismatch_person_not_found"/>
                        <xsl:with-param name="currentNode" select="$actual"/>
                        <xsl:with-param name="actualValue" select="$actual-person"/>
                        <xsl:with-param name="expectedValue" select="$expected-person"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:when>
            <xsl:when test="not($actual) and $expected">
                <xsl:call-template name="ReportError">
                    <xsl:with-param name="ErrorText" select="$data_mismatch_person_not_found"/>
                    <xsl:with-param name="currentNode" select="$actual"/>
                    <xsl:with-param name="actualValue">(Person missing from hl7 message)</xsl:with-param>
                    <xsl:with-param name="expectedValue" select="$expected/@description"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>


    </xsl:template>
    <xsl:template name="compare-locations">
        <xsl:param name="actual"/>
        <xsl:param name="expected"/>

        <xsl:choose>
            <xsl:when test="$actual">
                <xsl:variable name="expected-location">
                    <xsl:choose>
                        <xsl:when test="$expected">
                            <xsl:value-of select="$expected/@description"/>
                        </xsl:when>
                        <xsl:otherwise>(No Location stored for this Item in Test Data file)</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="OID_Str">
                    <xsl:call-template name="OID_String">
                        <xsl:with-param name="OID" select="$actual/hl7:id/@root"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="location-id" select="$actual/hl7:id/@extension"/>

                <xsl:variable name="actual-location">
                    <xsl:choose>
                        <xsl:when test="$TestData/serviceDeliveryLocations/location[@OID = $OID_Str][server/id/@extension = $location-id]">
                            <xsl:value-of select="$TestData/serviceDeliveryLocations/location[@OID = $OID_Str][server/id/@extension = $location-id]/@description"/>
                        </xsl:when>
                        <xsl:otherwise><xsl:value-of select="$location-id"/> : <xsl:value-of select="$OID_Str"/> (Location not found.)</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <xsl:if test="not($actual-location = $expected-location)">
                    <xsl:call-template name="ReportError">
                        <xsl:with-param name="ErrorText" select="$data_mismatch_location_not_found"/>
                        <xsl:with-param name="currentNode" select="$actual"/>
                        <xsl:with-param name="actualValue" select="$actual-location"/>
                        <xsl:with-param name="expectedValue" select="$expected-location"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:when>
            <xsl:when test="not($actual) and $expected">
                <xsl:call-template name="ReportError">
                    <xsl:with-param name="ErrorText" select="$data_mismatch_location_not_found"/>
                    <xsl:with-param name="currentNode" select="$actual"/>
                    <xsl:with-param name="actualValue">(Location missing from hl7 message)</xsl:with-param>
                    <xsl:with-param name="expectedValue" select="$expected/@description"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="ID_check">
        <xsl:param name="actual"/>
        <xsl:param name="expected"/>

        <xsl:choose>
            <xsl:when test="$actual and $expected">
                <xsl:variable name="OID_Name">
                    <xsl:call-template name="OID_String">
                        <xsl:with-param name="OID" select="$actual/@root"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="exp_root">
                    <xsl:choose>
                        <xsl:when test="$expected/@root_OID">
                            <xsl:value-of select="$expected/@root_OID"/>
                        </xsl:when>
                        <xsl:when test="$expected/@root">
                            <xsl:value-of select="$expected/@root"/>
                        </xsl:when>
                        <xsl:otherwise>(Test Data does not contain a root attribute)</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:if test="not($OID_Name = $exp_root)">
                    <xsl:call-template name="ReportError">
                        <xsl:with-param name="ErrorText" select="$wrong_oid_value"/>
                        <xsl:with-param name="currentNode" select="$actual"/>
                        <xsl:with-param name="elementName">root</xsl:with-param>
                        <xsl:with-param name="actualValue" select="$OID_Name"/>
                        <xsl:with-param name="expectedValue" select="$exp_root"/>
                    </xsl:call-template>
                </xsl:if>
                <xsl:variable name="exp_extension">
                    <xsl:choose>
                        <xsl:when test="$expected/@server">
                            <xsl:value-of select="$expected/@server"/>
                        </xsl:when>
                        <xsl:when test="$expected/@extension">
                            <xsl:value-of select="$expected/@extension"/>
                        </xsl:when>
                        <xsl:otherwise>(Test Data does not contain an Extension attribute)</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:if test="not($actual/@extension = $exp_extension)">
                    <xsl:call-template name="ReportError">
                        <xsl:with-param name="ErrorText" select="$data_mismatch_wrong_extension"/>
                        <xsl:with-param name="currentNode" select="$actual"/>
                        <xsl:with-param name="elementName">extension</xsl:with-param>
                        <xsl:with-param name="actualValue" select="$actual/@extension"/>
                        <xsl:with-param name="expectedValue" select="$exp_extension"/>
                    </xsl:call-template>
                </xsl:if>

            </xsl:when>
            <xsl:when test="not($actual) and $expected">
                <xsl:call-template name="ReportError">
                    <xsl:with-param name="ErrorText" select="$data_mismatch_ID_not_found"/>
                    <xsl:with-param name="currentNode" select="$actual"/>
                    <xsl:with-param name="actualValue">(ID missing from hl7 message)</xsl:with-param>
                    <xsl:with-param name="expectedValue"><xsl:value-of select="$expected/@record-id"/> : <xsl:value-of select="$expected/@root_OID"/></xsl:with-param>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>


    </xsl:template>

    <xsl:template name="OID_String">
        <xsl:param name="OID"/>
        <xsl:value-of select="name($OID_root/*[@server = $OID])"/>
    </xsl:template>



</xsl:stylesheet>
