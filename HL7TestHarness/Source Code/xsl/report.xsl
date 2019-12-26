<?xml version="1.0" encoding="UTF-8"?>
<!--
 Module Header

  $Header:   L:/pvcsrep65/HL7TestHarness/archives/Source Code/xsl/report.xsl-arc   1.18   15 Feb 2007 14:55:50   mwicks  $

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
Public License for more details.
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
<!-- $Header:   L:/pvcsrep65/HL7TestHarness/archives/Source Code/xsl/report.xsl-arc   1.18   15 Feb 2007 14:55:50   mwicks  $  -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:hl7="urn:hl7-org:v3">

    <xsl:template match="/">
        <html>
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
                <title>DeltaWare Test Case Result Summary</title>
                <style type="text/css"> .copyright { font: 8pt Arial; font-style: italic; text-align: right; } body { background-color: #F0F8FF; /* AliceBlue; */ /* width: 8in; */ } h1 { margin-left: 0; margin-right: 0; margin-bottom: 8px;
                    padding-bottom: 2px; width: 100%; border-bottom-style: dotted; border-bottom: 2px; } .notes { padding-left: 40px; padding-right: 40px; } .procedure_notes { padding-bottom: 10px; padding-left: 20px; padding-right: 20px; } .fixed40
                    { width: 24px; } .ok {} .warning {background-color: Yellow;} .alert {background-color: #FFB6C1; /* LightPink; */ } .alertright {background-color: #FFB6C1; text-align: right; } table, tr, td, th { border-collapse: collapse; }
                    table, tr, th, td { border: 1px solid #00008B; text-align: left; } table { margin: 0 0 0 0; } .mastertable { width: 96%; } .innertable { border: none; padding: 0 0 0 0; margin: 0 0 0 0; } .left { text-align: left; } .center {
                    text-align: center; } .right { text-align: right; } .code { background-color: #FFF8DC; border: 1px black solid; font: 8pt Courier New; margin-left: 12px; margin-right: 12px; margin-top: 4px; margin-bottom: 4px; padding: 4px; }
                    .elem, .elem0, .elem1, .elem2, .elem3 { font-weight: bold; color: #008B8B; } .attr { color: purple; } .value { color: blue; } .text { color: #00008B; } .testa { border-style: none;} .testb { text-align: left; border-top-style:
                    none; border-left-style: none; border-right-style: none; border-bottom-style: dotted;} .testc { text-align: right; border-top-style: none; border-left-style: none; border-right-style: none; border-bottom-style: dotted;} .datum {
                    width: 120px; text-align: right; } .datumh { width: 120px; font-weight: bold; color: #0000FF; /* blue; */ background-color: #00FFFF; /* cyan; */ } .control { width: 10px; } .subheader1 { background-color: white; color: blue;
                    text-align: left; height: 40px; vertical-align: top; } .rheader { text-align: center; vertical-align: top; width: 10% } .description{ text-align: left; vertical-align: top } .subheader2 { background-color: #DCDCDC; /* gainsboro;
                    */ color: blue; text-align: left; height: 25px; } .subheader3 { background-color: #F5F5DC; /* beige; */ color: blue; height: 20px; } .subfooter { background-color: white; color: blue; text-align: left; height: 10px; } img {
                    border: none; } </style>
            </head>
            <body>
                <xsl:apply-templates/>
                <xsl:call-template name="copyright"/>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="workflows">
        <div class="center">
            <xsl:call-template name="workFlowSummary"/>
        </div>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="workflow">
        <xsl:call-template name="title"/>
        <div class="center">
            <xsl:call-template name="messageSummary"/>
        </div>
        <p/>
        <!--
        <div class="center">
            <xsl:call-template name="ErrorTable"/>
        </div>
        <p/>
        <div class="center">
            <xsl:call-template name="ExceptionTable"/>
        </div>
        -->
    </xsl:template>

    <xsl:template name="workFlowSummary">
        <xsl:if test="count(workflow) > 1">
            <table width="96%">
                <tr>
                    <td colspan="6" class="subheader1">Summary for <b>Work Flows</b></td>
                </tr>
                <tr class="subheader2">
                    <td>Work Flow</td>
                    <td class="rheader">Status</td>
                </tr>
                <xsl:for-each select="workflow">
                    <tr>
                        <td class="description">
                            <a>
                                <xsl:if test="@id">
                                    <xsl:attribute name="name">#TOP_<xsl:value-of select="@id"/></xsl:attribute>
                                    <xsl:attribute name="href">#_<xsl:value-of select="@id"/></xsl:attribute>
                                </xsl:if>
                                <xsl:value-of select="@description"/>
                            </a>
                        </td>
                        <td class="rheader">
<!--                            <xsl:variable name="all-rules" select="count(child::message/child::*/messageProxy/validation[not(@status ='N/A')]/rule)"/>-->
                            <xsl:variable name="all-rules" select="count(child::message/child::*/messageProxy/validation/rule)"/>
                            <xsl:variable name="ignored-rules" select="count(child::message/child::*/messageProxy/validation[not(@status ='N/A')]/rule[(@status='FAIL' or @status='PASS') and (@ignore and @ignore = true())])"/>
                            <xsl:variable name="passed-rules" select="count(child::message/child::*/messageProxy/validation[not(@status ='N/A')]/rule[@status='PASS'  and not(@ignore and @ignore = true())])"/>
                            <xsl:variable name="failed-rules" select="count(child::message/child::*/messageProxy/validation[not(@status ='N/A')]/rule[@status='FAIL'  and not(@ignore and @ignore = true())])"/>
<!--                            <xsl:variable name="optional-rules" select="count(child::message/child::*/messageProxy/validation[@status ='N/A']/rule[@status!='FAIL' and @status!='PASS'])"/>-->
                            <xsl:variable name="optional-rules" select="count(child::message/child::*/messageProxy/validation[@status ='N/A']/rule)"/>

                            <xsl:choose>
                                <xsl:when test="$all-rules = ($passed-rules + $ignored-rules + $optional-rules)">PASS</xsl:when>
                                <xsl:when test="$all-rules = ($failed-rules + $passed-rules + $ignored-rules + $optional-rules)">
                                    <b>FAIL</b>
                                </xsl:when>
                                <xsl:otherwise>
                                    <b>Incomplete</b>
                                </xsl:otherwise>
                            </xsl:choose>


                            <!--                            <xsl:choose>
                                <xsl:when test="count(child::message/child::*/messageProxy/validation[not(@status ='N/A')]/rule)=(count(child::*/child::*/messageProxy/validation[not(@status ='N/A')]/rule[@status='PASS']) + count(child::message[@optional = true()]/child::*/messageProxy/validation[not(@status ='N/A')]/rule[@status!='FAIL' and @status!='PASS']))" >PASS</xsl:when>
                                <xsl:when test="count(child::message/child::*/messageProxy/validation[not(@status ='N/A')]/rule)=(count(child::*/child::*/messageProxy/validation[not(@status ='N/A')]/rule[@status='PASS']) + count(child::*/child::*/messageProxy/validation[not(@status ='N/A')]/rule[@status='FAIL']) + count(child::message[@optional = true()]/child::*/messageProxy/validation[not(@status ='N/A')]/rule[@status!='FAIL' and @status!='PASS']))">FAIL</xsl:when>
                                <xsl:otherwise>Incomplete</xsl:otherwise>
                            </xsl:choose>
-->
                        </td>
                    </tr>
                </xsl:for-each>
                <tr class="subfooter">
                    <td>Total</td>
                    <td align="center">
                        <xsl:value-of select="count(descendant-or-self::workflow)"/>
                    </td>
                </tr>
            </table>
        </xsl:if>
    </xsl:template>

    <xsl:template name="messageSummary">
        <table width="96%">
            <tr>
                <td colspan="7" class="subheader1">Summary for <xsl:call-template name="name"/></td>
            </tr>
            <tr class="subheader2">
                <td>Message</td>
                <td class="rheader">Pass</td>
                <td class="rheader">Fail</td>
                <td class="rheader">UnTested</td>
                <td class="rheader">Optional/Ignored</td>
                <td class="rheader">Total</td>
                <td class="rheader">Status</td>
            </tr>
            <xsl:for-each select="message/child::*">
<!--                <xsl:variable name="all-rules" select="count(messageProxy/validation[not(@status ='N/A')]/rule)"/>-->
                <xsl:variable name="all-rules" select="count(messageProxy/validation/rule)"/>
                <xsl:variable name="ignored-rules" select="count(messageProxy/validation[not(@status ='N/A')]/rule[(@status='FAIL' or @status='PASS') and (@ignore and @ignore = true())])"/>
                <xsl:variable name="passed-rules" select="count(messageProxy/validation[not(@status ='N/A')]/rule[@status='PASS'  and not(@ignore and @ignore = true())])"/>
                <xsl:variable name="failed-rules" select="count(messageProxy/validation[not(@status ='N/A')]/rule[@status='FAIL'  and not(@ignore and @ignore = true())])"/>
<!--                <xsl:variable name="optional-rules" select="count(messageProxy/validation[@status ='N/A']/rule[@status!='FAIL' and @status!='PASS'])"/>-->
                <xsl:variable name="optional-rules" select="count(messageProxy/validation[@status ='N/A']/rule)"/>

                <tr>
                    <td class="description">
                        <a>
                            <xsl:variable name="timeStamp" select="descendant-or-self::*[@timestamp]/@timestamp"/>
                            <xsl:attribute name="name">TOP_<xsl:value-of select="translate(@description,' ', '_')"/>_<xsl:value-of select="translate($timeStamp,' /:','___')"/></xsl:attribute>
                            <xsl:attribute name="href">#_<xsl:value-of select="translate(@description,' ', '_')"/>_<xsl:value-of select="translate($timeStamp,' /:','___')"/></xsl:attribute>
                            <xsl:value-of select="@description"/>
                        </a>
                        <!-- <xsl:if test="parent::node()/@optional = true()"> (Optional)</xsl:if> -->
                    </td>
                    <td class="rheader">
                        <!--                        <xsl:value-of select="count(messageProxy/validation[not(@status ='N/A')]/rule[@status='PASS'])"/>-->
                        <xsl:value-of select="$passed-rules"/>
                    </td>
                    <td class="rheader">
                        <!--                        <xsl:value-of select="count(messageProxy/validation[not(@status ='N/A')]/rule[@status='FAIL'])"/>-->
                        <xsl:value-of select="$failed-rules"/>
                    </td>
                    <td class="rheader">
                        <!--                        <xsl:value-of select="count(messageProxy/validation[not(@status ='N/A')]/rule) - (count(messageProxy/validation[not(@status ='N/A')]/rule[@status='FAIL']) + count(messageProxy/validation[not(@status ='N/A')]/rule[@status='PASS']))"/>-->
                        <xsl:value-of select="$all-rules - ($passed-rules + $failed-rules + $optional-rules + $ignored-rules)"/>
                    </td>
                    <td class="rheader">
                        <!--                        <xsl:value-of select="count(messageProxy/validation[not(@status ='N/A')]/rule)"/>-->
                        <xsl:value-of select="$optional-rules + $ignored-rules"/>
                    </td>
                    <td class="rheader">
                        <!--                        <xsl:value-of select="count(messageProxy/validation[not(@status ='N/A')]/rule)"/>-->
                        <xsl:value-of select="$all-rules"/>
                    </td>
                    <!-- <td class="rheader"><xsl:value-of select="@status"/></td> -->
                    <td class="rheader">
                        <xsl:choose>
                            <xsl:when test="$all-rules = ($passed-rules + $ignored-rules + $optional-rules)">PASS</xsl:when>
                            <xsl:when test="$all-rules = ($failed-rules + $passed-rules + $ignored-rules + $optional-rules)">
                                <b>FAIL</b>
                            </xsl:when>
                            <xsl:when test="parent::node()/@optional = true()">optional</xsl:when>
                            <xsl:otherwise>
                                <b>Incomplete</b>
                            </xsl:otherwise>
                        </xsl:choose>
                        <!--                        <xsl:choose>
                            <xsl:when test="count(messageProxy/validation[not(@status ='N/A')]/rule) =count(messageProxy/validation[not(@status ='N/A')]/rule[@status='PASS'])">PASS</xsl:when>
                            <xsl:when test="count(messageProxy/validation[not(@status ='N/A')]/rule) =(count(messageProxy/validation[not(@status ='N/A')]/rule[@status='PASS']) + count(messageProxy/validation[not(@status ='N/A')]/rule[@status='FAIL']))">FAIL</xsl:when>
                            <xsl:when test="parent::node()/@optional = true()">optional</xsl:when>
                            <xsl:otherwise>Incomplete</xsl:otherwise>
                        </xsl:choose>
-->
                    </td>
                </tr>
            </xsl:for-each>
            <tr class="subheader2">
                <xsl:variable name="all-rules" select="count(descendant-or-self::messageProxy/validation[not(@status ='N/A')]/rule)"/>
                <xsl:variable name="ignored-rules" select="count(descendant-or-self::messageProxy/validation[not(@status ='N/A')]/rule[(@status='FAIL' or @status='PASS') and (@ignore and @ignore = true())])"/>
                <xsl:variable name="passed-rules" select="count(descendant-or-self::messageProxy/validation[not(@status ='N/A')]/rule[@status='PASS'  and not(@ignore and @ignore = true())])"/>
                <xsl:variable name="failed-rules" select="count(descendant-or-self::messageProxy/validation[not(@status ='N/A')]/rule[@status='FAIL'  and not(@ignore and @ignore = true())])"/>
                <xsl:variable name="optional-rules" select="count(descendant-or-self::messageProxy/validation[@status ='N/A']/rule[@status!='FAIL' and @status!='PASS'])"/>

                <td align="left">
                    <b>Total</b>
                </td>
                <td class="rheader">
                    <b>
                        <xsl:value-of select="$passed-rules"/>
                    </b>
                </td>
                <td class="rheader">
                    <b>
                        <xsl:value-of select="$failed-rules"/>
                    </b>
                </td>
                <td class="rheader">
                    <!--                        <xsl:value-of select="count(messageProxy/validation[not(@status ='N/A')]/rule) - (count(messageProxy/validation[not(@status ='N/A')]/rule[@status='FAIL']) + count(messageProxy/validation[not(@status ='N/A')]/rule[@status='PASS']))"/>-->
                    <xsl:value-of select="$all-rules - ($passed-rules + $failed-rules + $optional-rules + $ignored-rules)"/>
                </td>

                <td class="rheader">
                    <!--                        <xsl:value-of select="count(messageProxy/validation[not(@status ='N/A')]/rule)"/>-->
                    <xsl:value-of select="$optional-rules + $ignored-rules"/>
                </td>
                <td class="rheader">
                    <!--                        <xsl:value-of select="count(messageProxy/validation[not(@status ='N/A')]/rule)"/>-->
                    <xsl:value-of select="$all-rules"/>
                </td>
                <!-- <td class="rheader"><xsl:value-of select="@status"/></td> -->
                <td class="rheader">
                    <xsl:choose>
                        <xsl:when test="$all-rules = ($passed-rules + $ignored-rules + $optional-rules)">PASS</xsl:when>
                        <xsl:otherwise>
                            <b>FAIL</b>
                        </xsl:otherwise>
                    </xsl:choose>
                    <!--                        <xsl:choose>
                            <xsl:when test="count(messageProxy/validation[not(@status ='N/A')]/rule) =count(messageProxy/validation[not(@status ='N/A')]/rule[@status='PASS'])">PASS</xsl:when>
                            <xsl:when test="count(messageProxy/validation[not(@status ='N/A')]/rule) =(count(messageProxy/validation[not(@status ='N/A')]/rule[@status='PASS']) + count(messageProxy/validation[not(@status ='N/A')]/rule[@status='FAIL']))">FAIL</xsl:when>
                            <xsl:when test="parent::node()/@optional = true()">optional</xsl:when>
                            <xsl:otherwise>Incomplete</xsl:otherwise>
                        </xsl:choose>
-->
                </td>
            </tr>
            <tr class="subfooter">
                <td colspan="7"/>
            </tr>
        </table>
        <!-- message details -->
        <xsl:for-each select="message/child::*">
            <p/>
            <xsl:call-template name="MessageDetail">
                <xsl:with-param name="id">
                    <xsl:value-of select="generate-id()"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>


    <xsl:template name="MessageDetail">
        <xsl:param name="id"/>
        <table width="96%">
            <tr>
                <td colspan="2" class="subheader1">
                    Message: <span onmouseover="this.style.cursor='hand'" onclick="">
                        <xsl:attribute name="onclick">
                            <xsl:text>document.getElementById('</xsl:text>
                            <xsl:value-of select="$id"/>
                            <xsl:text>').style.display=='none'?document.getElementById('</xsl:text>
                            <xsl:value-of select="$id"/>
                            <xsl:text>').style.display='block':document.getElementById('</xsl:text>
                            <xsl:value-of select="$id"/>
                            <xsl:text>').style.display='none'</xsl:text>
                        </xsl:attribute>
                        <xsl:call-template name="name"/>
                        <xsl:text>  </xsl:text>
                        <span style="font-size:smaller">(<xsl:value-of select="descendant-or-self::messageProxy[1]/@timestamp"/>) [<i>message</i>]</span>
                    </span>

                </td>
                <td  class="subheader1" align="right">
                                        <a style="font-size:smaller"  >
                                        <xsl:variable name="timeStamp" select="descendant-or-self::*[@timestamp]/@timestamp"/>
                <xsl:attribute name="href">#TOP_<xsl:value-of select="translate(@description,' ', '_')"/>_<xsl:value-of select="translate($timeStamp,' /:','___')"/></xsl:attribute>
                        [TOP]
                    </a>

                </td>
            </tr>
            <tr id="" style="display:none">
                <xsl:attribute name="id">
                    <xsl:value-of select="$id"/>
                </xsl:attribute>
                <td colspan="6" class="subheader1">
                    <table width="100%">
                        <xsl:choose>
                            <xsl:when test="ancestor-or-self::request">
                                <tr>
                                    <td class="subheader1">Client System Request Message (Recieved by Message Proxy)</td>
                                    <td class="subheader1">Client System Request Message (Transmitted by Message Proxy to Server)</td>
                                </tr>
                                <tr>
                                    <td width="50%">
                                        <DIV STYLE="overflow: auto; width: 480px; height: 100%; border-left: 1px gray solid; border-bottom: 1px gray solid; padding:0px; margin: 0px">
                                            <xmp>
                                                <xsl:copy-of select="messageProxy/RxMessage/child::node()"/>
                                            </xmp>
                                        </DIV>
                                    </td>
                                    <td width="50%">
                                        <DIV STYLE="overflow: auto; width: 480px; height: 100%; border-left: 1px gray solid; border-bottom: 1px gray solid; padding:0px; margin: 0px">
                                            <xmp>
                                                <xsl:copy-of select="messageProxy/TxMessage/child::node()"/>
                                            </xmp>
                                        </DIV>
                                    </td>
                                </tr>
                            </xsl:when>
                            <xsl:when test="ancestor-or-self::response">
                                <tr>
                                    <td class="subheader1">Server System Response Message (Recieved by Message Proxy)</td>
                                    <td class="subheader1">Server System Response Message (Transmitted by Message Proxy to Client)</td>
                                </tr>
                                <tr>
                                    <td width="50%">
                                        <DIV STYLE="overflow: auto; width: 480px; height: 100%; border-left: 1px gray solid; border-bottom: 1px gray solid; padding:0px; margin: 0px">
                                            <xmp>
                                                <xsl:copy-of select="messageProxy/RxMessage/child::node()"/>
                                            </xmp>
                                        </DIV>
                                    </td>
                                    <td width="50%">
                                        <DIV STYLE="overflow: auto; width: 480px; height: 100%; border-left: 1px gray solid; border-bottom: 1px gray solid; padding:0px; margin: 0px">
                                            <xmp>
                                                <xsl:copy-of select="messageProxy/TxMessage/child::node()"/>
                                            </xmp>
                                        </DIV>
                                    </td>
                                </tr>
                            </xsl:when>
                            <xsl:otherwise>
                                <tr>
                                    <td class="subheader1">Unknown Message Type</td>
                                </tr>
                            </xsl:otherwise>
                        </xsl:choose>
                    </table>
                </td>
            </tr>
            <xsl:for-each select="messageProxy/validation">
                <tr class="subheader2">
                    <td class="description" colspan="3">
                        <xsl:value-of select="@description"/>
                    </td>
                </tr>
                <xsl:if test="./rule">
                    <tr class="subheader3">
                        <td/>
                        <td align="left">Case</td>
                        <td align="right">Status</td>
                    </tr>
                    <xsl:for-each select="./rule">
                        <tr class="">
                            <td class="testa"/>
                            <td align="left" class="testb">
                                <xsl:value-of select="@description"/>
                            </td>
                            <td align="right" class="testc">
                                <xsl:choose>
                                    <xsl:when test="@status">
                                        <xsl:choose>
                                            <xsl:when test="@ignore and @ignore = true()">
                                                <xsl:value-of select="@status"/>
                                                <i>(ignored)</i>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="@status"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:when>
                                    <xsl:when test="ancestor-or-self::validation/@status = 'N/A'">N/A</xsl:when>
                                    <xsl:when test="ancestor-or-self::*/@optional = 'true'">Optional</xsl:when>
                                    <xsl:otherwise/>
                                </xsl:choose>
                            </td>
                        </tr>
                    </xsl:for-each>
                </xsl:if>
            </xsl:for-each>
            <tr class="subfooter">
                <td colspan="6"/>
            </tr>
        </table>
        <div class="center">
            <xsl:call-template name="ErrorTable">
                <xsl:with-param name="id">
                    <xsl:value-of select="$id"/>
                    <xsl:text>-Errors</xsl:text>
                </xsl:with-param>
            </xsl:call-template>
        </div>
        <div class="center">
            <xsl:call-template name="ExceptionTable">
                <xsl:with-param name="id">
                    <xsl:value-of select="$id"/>
                    <xsl:text>-Exception</xsl:text>
                </xsl:with-param>
            </xsl:call-template>
        </div>

    </xsl:template>


    <xsl:template name="ErrorTable">
        <xsl:param name="id"/>
        <xsl:if test="count(descendant::validation/descendant::error) > 0">
            <table width="96%">
                <tr>
                    <td colspan="8" class="subheader1">
                        <span onmouseover="this.style.cursor='hand'" onclick="">
                            <xsl:attribute name="onclick">
                                <xsl:text>document.getElementById('</xsl:text>
                                <xsl:value-of select="$id"/>
                                <xsl:text>').style.display=='none'?document.getElementById('</xsl:text>
                                <xsl:value-of select="$id"/>
                                <xsl:text>').style.display='block':document.getElementById('</xsl:text>
                                <xsl:value-of select="$id"/>
                                <xsl:text>').style.display='none'</xsl:text>
                            </xsl:attribute>
                            <xsl:text>Failed Cases  </xsl:text>
                            <span style="font-size:smaller">[<i>view</i>]</span>
                        </span>
                    </td>
                </tr>
            </table>
            <table width="96%" style="display:block">
                <xsl:attribute name="id">
                    <xsl:value-of select="$id"/>
                </xsl:attribute>
                <xsl:for-each select="descendant::validation[descendant::error]">
                    <tr class="subheader2">
                        <td class="description" colspan="3"><xsl:value-of select="../../@description"/> [<xsl:value-of select="@description"/>]</td>
                    </tr>
                    <tr class="subheader3">
                        <td/>
                        <td>Case</td>
                        <td width="65%">Details</td>
                    </tr>
                    <xsl:for-each select="descendant::rule[descendant::error]">
                        <tr>
                            <td/>
                            <td class="description">
                                <div>
                                    <b>
                                        <xsl:if test="@ignore and @ignore = true()">
                                            <i>(Error Ignored)</i>
                                        </xsl:if>
                                        <xsl:value-of select="@description"/>
                                    </b>
                                </div>
                                <div>
                                    <b>
                                        <i>TimeStamp: </i>
                                    </b>
                                    <xsl:value-of select="../../@timestamp"/>
                                </div>
                                <div>
                                    <b>
                                        <i>Transform File: </i>
                                    </b>
                                    <xsl:value-of select="@filename"/>
                                </div>
                                <div>
                                    <b>
                                        <i>Expected File: </i>
                                    </b>
                                    <xsl:value-of select="@expectedfile"/>
                                </div>
                            </td>
                            <td>
                                <xsl:for-each select=".//error/error">
                                    <div>
                                        <b>
                                            <xsl:value-of select="@description"/>
                                        </b>
                                    </div>
                                    <div>
                                        <b>
                                            <i>Element Name: </i>
                                        </b>
                                        <xsl:value-of select="@element"/>
                                    </div>
                                    <div>
                                        <b>
                                            <i>Actual:</i>
                                        </b>
                                        <table align="center" width="90%">
                                            <td class="subheader3">
                                                <xsl:value-of select="./actual"/>
                                            </td>
                                        </table>
                                    </div>
                                    <div>
                                        <b>
                                            <i>Expected:</i>
                                        </b>
                                        <table align="center" width="90%">
                                            <td class="subheader3">
                                                <xsl:value-of select="./expected"/>
                                            </td>
                                        </table>
                                    </div>
                                    <p>
                                        <xsl:if test="following-sibling::*">
                                            <table class="innertable" align="center" width="100%">
                                                <tr class="">
                                                    <td class="testb" width="100%"/>
                                                </tr>
                                            </table>
                                        </xsl:if>
                                    </p>
                                </xsl:for-each>
                                <xsl:for-each select=".//error/compareResults">
                                    <div>
                                        <b> Actual Results Don't Match Expected Results </b>
                                    </div>
                                    <div>
                                        <b>
                                            <i>Actual:</i>
                                        </b>
                                        <table align="center" width="90%">
                                            <td class="subheader3">
                                                <xsl:for-each select="./actual/child::node()/child::node()">
                                                    <xsl:call-template name="copyData"/>
                                                </xsl:for-each>
                                            </td>
                                        </table>
                                    </div>
                                    <div>
                                        <b>
                                            <i>Expected:</i>
                                        </b>
                                        <table align="center" width="90%">
                                            <td class="subheader3">
                                                <xsl:for-each select="./expected/child::node()/child::node()">
                                                    <xsl:call-template name="copyData"/>
                                                </xsl:for-each>
                                            </td>
                                        </table>
                                    </div>
                                    <p>
                                        <xsl:if test="following-sibling::*">
                                            <table class="innertable" align="center" width="100%">
                                                <tr class="">
                                                    <td class="testb" width="100%"/>
                                                </tr>
                                            </table>
                                        </xsl:if>
                                    </p>
                                </xsl:for-each>
                            </td>
                        </tr>
                    </xsl:for-each>
                </xsl:for-each>
            </table>
        </xsl:if>
    </xsl:template>

    <xsl:template name="copyData"> &lt;<xsl:value-of select="name()"/><xsl:for-each select="@*"><xsl:text> </xsl:text><xsl:value-of select="name()"/>="<xsl:value-of select="."/>"</xsl:for-each>
        <xsl:choose>
            <xsl:when test="text()"> &gt;<xsl:value-of select="text()"/>
                <xsl:for-each select="child::node">
                    <xsl:call-template name="copyData"/>
                </xsl:for-each> &lt;/<xsl:value-of select="name()"/>&gt; </xsl:when>
            <xsl:when test="child::node()"> &gt;<xsl:for-each select="child::node()">
                    <xsl:call-template name="copyData"/>
                </xsl:for-each> &lt;/<xsl:value-of select="name()"/>&gt; </xsl:when>
            <xsl:otherwise>/&gt;</xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="ExceptionTable">
        <xsl:param name="id"/>
        <xsl:if test="count(descendant::exception) > 0">
            <table width="96%">
                <tr>
                    <td colspan="8" class="subheader1">
                        <span onmouseover="this.style.cursor='hand'" onclick="">
                            <xsl:attribute name="onclick">
                                <xsl:text>document.getElementById('</xsl:text>
                                <xsl:value-of select="$id"/>
                                <xsl:text>').style.display=='none'?document.getElementById('</xsl:text>
                                <xsl:value-of select="$id"/>
                                <xsl:text>').style.display='block':document.getElementById('</xsl:text>
                                <xsl:value-of select="$id"/>
                                <xsl:text>').style.display='none'</xsl:text>
                            </xsl:attribute>
                            <xsl:text>Exceptions </xsl:text>
                            <span style="font-size:smaller">[<i>view</i>]</span>
                        </span>
                    </td>
                </tr>
            </table>

            <table width="96%" style="display:none">
                <xsl:attribute name="id">
                    <xsl:value-of select="$id"/>
                </xsl:attribute>
                <xsl:for-each select="descendant::validation[descendant::exception]">
                    <tr class="subheader2">
                        <td class="description" colspan="3"><xsl:value-of select="../../@description"/> [<xsl:value-of select="@description"/>]</td>
                    </tr>
                    <tr class="subheader3">
                        <td/>
                        <td>Case</td>
                        <td width="65%">Exception</td>
                    </tr>
                    <xsl:for-each select="descendant::rule[descendant::exception]">
                        <tr>
                            <td/>
                            <td class="description">
                                <div>
                                    <b>
                                        <xsl:value-of select="@description"/>
                                    </b>
                                </div>
                                <div>
                                    <b>
                                        <i>TimeStamp: </i>
                                    </b>
                                    <xsl:value-of select="../../@timestamp"/>
                                </div>
                                <div>
                                    <b>
                                        <i>Transform File: </i>
                                    </b>
                                    <xsl:value-of select="@filename"/>
                                </div>
                                <div>
                                    <b>
                                        <i>Expected File: </i>
                                    </b>
                                    <xsl:value-of select="@expectedfile"/>
                                </div>
                            </td>
                            <td>
                                <xsl:for-each select="descendant::exception">
                                    <xsl:choose>
                                        <xsl:when test="details">
                                            <div>
                                                <b>
                                                    <xsl:value-of select="details"/>
                                                </b>
                                            </div>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <div>
                                                <b>
                                                    <xsl:value-of select="."/>
                                                </b>
                                            </div>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </td>
                        </tr>
                    </xsl:for-each>
                </xsl:for-each>
                <xsl:if test="count(descendant::Simulator/descendant::exception) > 0">
                    <tr class="subheader2">
                        <td class="description" colspan="3">Simulator Execptions</td>
                        <tr class="subheader3">
                            <td/>
                            <td>Case</td>
                            <td width="65%">Exception</td>
                        </tr>
                    </tr>
                    <xsl:for-each select="descendant::Simulator[exception]">
                        <tr>
                            <td/>
                            <td class="description">
                                <div>
                                    <b>
                                        <xsl:value-of select=" ../@description"/>
                                    </b>
                                </div>
                                <div>
                                    <b>
                                        <i>TimeStamp: </i>
                                    </b>
                                    <xsl:value-of select="../@timestamp"/>
                                </div>
                            </td>
                            <td>
                                <xsl:for-each select="exception">
                                    <xsl:choose>
                                        <xsl:when test="details">
                                            <div>
                                                <b>
                                                    <xsl:value-of select="details"/>
                                                </b>
                                            </div>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <div>
                                                <b>
                                                    <xsl:value-of select="."/>
                                                </b>
                                            </div>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </td>
                        </tr>
                    </xsl:for-each>
                </xsl:if>

                <xsl:if test="count(descendant::messageProxy/construction/descendant::exception) > 0">
                    <tr class="subheader2">
                        <td class="description" colspan="3">Message Construction Execptions</td>
                        <tr class="subheader3">
                            <td/>
                            <td>Case</td>
                            <td width="65%">Exception</td>
                        </tr>
                    </tr>
                    <xsl:for-each select="descendant::messageProxy/construction[descendant::exception]">
                        <tr>
                            <td/>
                            <td class="description">
                                <div>
                                    <b>
                                        <xsl:value-of select="../../@description"/>
                                    </b>
                                </div>
                                <div>
                                    <b>
                                        <i>TimeStamp: </i>
                                    </b>
                                    <xsl:value-of select="@timestamp"/>
                                </div>
                            </td>
                            <td>
                                <xsl:for-each select="descendant::exception">
                                    <xsl:choose>
                                        <xsl:when test="details">
                                            <div>
                                                <b>
                                                    <xsl:value-of select="details"/>
                                                </b>
                                            </div>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <div>
                                                <b>
                                                    <xsl:value-of select="."/>
                                                </b>
                                            </div>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </td>
                        </tr>
                    </xsl:for-each>
                </xsl:if>

            </table>
        </xsl:if>
    </xsl:template>


    <xsl:template name="name">
        <b>
            <a>
                <xsl:variable name="timeStamp" select="descendant-or-self::*[@timestamp]/@timestamp"/>
                <xsl:attribute name="name">_<xsl:value-of select="translate(@description,' ', '_')"/>_<xsl:value-of select="translate($timeStamp,' /:','___')"/></xsl:attribute>
                <xsl:value-of select="@description"/>
            </a>
            <!-- <xsl:if test="parent::node()/@optional = true()"> (Optional)</xsl:if> -->
        </b>
    </xsl:template>


    <!-- copyright notice -->
    <xsl:template name="copyright">
        <p class="copyright"> Copyright (c) 1999-2004 DeltaWare Systems Inc.<br/> Http/Xml Version: @BUILDVERSION@<br/> Http/Xml Date: @BUILDDATE@ </p>
    </xsl:template>

    <!-- summary/title information -->
    <xsl:template name="title">
        <a>
            <xsl:if test="@id">
                <xsl:attribute name="name">_<xsl:value-of select="@id"/></xsl:attribute>
            </xsl:if>
            <h1 style="margin-bottom: 8px; padding-bottom: 2px">Work Flow: <xsl:value-of select="@description"/> - Run Results</h1>
            <h6 style="margin-bottom: 0; margin-top: 0;">Run Date: <xsl:value-of select="descendant-or-self::messageProxy[1]/@timestamp"/>
            <a>
                <xsl:if test="@id">
                    <xsl:attribute name="href">#TOP_<xsl:value-of select="@id"/></xsl:attribute>
                </xsl:if>
                [Return to Top]
            </a>
            </h6>
            <xsl:for-each select="document">
                <h4 style="margin-bottom: 0; margin-top: 0;"><xsl:value-of select="."/></h4>    
            </xsl:for-each>
        </a>
        <p/>
    </xsl:template>



</xsl:stylesheet>
