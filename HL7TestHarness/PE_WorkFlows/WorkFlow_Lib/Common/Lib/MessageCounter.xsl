<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:hl7="urn:hl7-org:v3">

    <xsl:variable name="MessageList" select="document('messageData.xml')"/>

    <xsl:template match="text()|@*"/>

    <xsl:template match="workflows">
        <xsl:element name="Messages">
            <xsl:variable name="test-node" select="."/>
            <xsl:for-each select="$MessageList/messages/*">
                <xsl:call-template name="messageCount">
                    <xsl:with-param name="hl7-name" select="local-name()"/>
                    <xsl:with-param name="test-node" select="$test-node"/>
                </xsl:call-template>
            </xsl:for-each>
            <!--<xsl:apply-templates/>-->
        </xsl:element>
    </xsl:template>

    <xsl:template name="messageCount">
        <xsl:param name="hl7-name"/>
        <xsl:param name="test-node"/>


        <xsl:element name="Message">

            <xsl:attribute name="name">
                <xsl:value-of select="$hl7-name"/>
            </xsl:attribute>

            <xsl:attribute name="action">
                <xsl:value-of select="recordType/@action"/>
            </xsl:attribute>
            <xsl:attribute name="type">
                <xsl:value-of select="recordType/@type"/>
            </xsl:attribute>
            <xsl:attribute name="description">
                <xsl:value-of select="recordType/@value"/>
            </xsl:attribute>

            <xsl:attribute name="count">
                <xsl:value-of select="count($test-node/ancestor-or-self::workflows/descendant-or-self::messageProxy/RxMessage[local-name(hl7:*) = $hl7-name])"/>
            </xsl:attribute>

            <xsl:for-each select="$test-node/ancestor-or-self::workflows/descendant-or-self::messageProxy/RxMessage[local-name(hl7:*) = $hl7-name]">
                <xsl:element name="Instance">
                    <xsl:attribute name="workflow">
                        <xsl:value-of select="ancestor-or-self::workflow/@description"/>
                    </xsl:attribute>
                    <xsl:attribute name="message">
                        <xsl:value-of select="ancestor-or-self::message/@description"/>
                    </xsl:attribute>
                    <xsl:attribute name="action">
                        <xsl:choose>
                            <xsl:when test="ancestor-or-self::request">
                                <xsl:value-of select="ancestor-or-self::request/@description"/>
                                <xsl:text> [request]</xsl:text>
                            </xsl:when>
                            <xsl:when test="ancestor-or-self::response">
                                <xsl:value-of select="ancestor-or-self::response/@description"/>
                                <xsl:text> [request]</xsl:text>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:attribute>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>


    <xsl:template match="messageProxy/RxMessage">

        <xsl:variable name="hl7-name" select="local-name(hl7:*)"/>

        <xsl:if test="not(ancestor-or-self::workflow/preceding-sibling::workflow/descendant-or-self::messageProxy/RxMessage/hl7:*[local-name() = $hl7-name])">
            <xsl:element name="Message">


                <xsl:attribute name="name">
                    <xsl:value-of select="$hl7-name"/>
                </xsl:attribute>
                <xsl:attribute name="count">
                    <xsl:value-of select="count(/descendant-or-self::RxMessage[local-name(hl7:*) = $hl7-name])"/>
                </xsl:attribute>

                <xsl:for-each select="/descendant-or-self::RxMessage[local-name(hl7:*) = $hl7-name]">
                    <xsl:element name="Instance">
                        <xsl:attribute name="workflow">
                            <xsl:value-of select="ancestor-or-self::workflow/@description"/>
                        </xsl:attribute>
                        <xsl:attribute name="message">
                            <xsl:value-of select="ancestor-or-self::message/@description"/>
                        </xsl:attribute>
                        <xsl:attribute name="action">
                            <xsl:choose>
                                <xsl:when test="ancestor-or-self::request">
                                    <xsl:value-of select="ancestor-or-self::request/@description"/>
                                    <xsl:text> [request]</xsl:text>
                                </xsl:when>
                                <xsl:when test="ancestor-or-self::response">
                                    <xsl:value-of select="ancestor-or-self::response/@description"/>
                                    <xsl:text> [request]</xsl:text>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:attribute>
                    </xsl:element>
                </xsl:for-each>
            </xsl:element>
        </xsl:if>

    </xsl:template>

</xsl:stylesheet>
