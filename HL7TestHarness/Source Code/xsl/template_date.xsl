<?xml version="1.0" encoding="UTF-8"?>
<!--
 Module Header

  $Header:   L:/pvcsrep65/HL7TestHarness/archives/Source Code/xsl/template_date.xsl-arc   1.3   04 Dec 2006 15:56:32   mwicks  $

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
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:date="http://local/dates-and-times">
    
    <xsl:param name="date:date-time" select="'2000-01-01T00:00:00Z'" />
    
    <xsl:template name="date:date">
        <xsl:param name="date-time">
            <xsl:choose>
                <xsl:when test="function-available('date:date-time')">
                    <xsl:value-of select="date:date-time()" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$date:date-time" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:param>
        <xsl:variable name="neg" select="starts-with($date-time, '-')" />
        <xsl:variable name="dt-no-neg">
            <xsl:choose>
                <xsl:when test="$neg or starts-with($date-time, '+')">
                    <xsl:value-of select="substring($date-time, 2)" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$date-time" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="dt-no-neg-length" select="string-length($dt-no-neg)" />
        <xsl:variable name="timezone">
            <xsl:choose>
                <xsl:when test="substring($dt-no-neg, $dt-no-neg-length) = 'Z'">Z</xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="tz" select="substring($dt-no-neg, $dt-no-neg-length - 5)" />
                    <xsl:if test="(substring($tz, 1, 1) = '-' or 
                        substring($tz, 1, 1) = '+') and
                        substring($tz, 4, 1) = ':'">
                        <xsl:value-of select="$tz" />
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="date">
            <xsl:if test="not(string($timezone)) or
                $timezone = 'Z' or 
                (substring($timezone, 2, 2) &lt;= 23 and
                substring($timezone, 5, 2) &lt;= 59)">
                <xsl:variable name="dt" select="substring($dt-no-neg, 1, $dt-no-neg-length - string-length($timezone))" />
                <xsl:variable name="dt-length" select="string-length($dt)" />
                <xsl:if test="number(substring($dt, 1, 4)) and
                    substring($dt, 5, 1) = '-' and
                    substring($dt, 6, 2) &lt;= 12 and
                    substring($dt, 8, 1) = '-' and
                    substring($dt, 9, 2) &lt;= 31 and
                    ($dt-length = 10 or
                    (substring($dt, 11, 1) = 'T' and
                    substring($dt, 12, 2) &lt;= 23 and
                    substring($dt, 14, 1) = ':' and
                    substring($dt, 15, 2) &lt;= 59 and
                    substring($dt, 17, 1) = ':' and
                    substring($dt, 18) &lt;= 60))">
                    <xsl:value-of select="substring($dt, 1, 10)" />
                </xsl:if>
            </xsl:if>
        </xsl:variable>
        <xsl:if test="string($date)">
            <xsl:if test="$neg">-</xsl:if>
            <xsl:value-of select="$date" />
            <xsl:value-of select="$timezone" />
        </xsl:if>
    </xsl:template>
    
        <xsl:template name="date:add-duration">
            <xsl:param name="duration1" />
            <xsl:param name="duration2" />
            <xsl:variable name="du1-neg" select="starts-with($duration1, '-')" />
            <xsl:variable name="du1">
                <xsl:choose>
                    <xsl:when test="$du1-neg"><xsl:value-of select="substring($duration1, 2)" /></xsl:when>
                    <xsl:otherwise><xsl:value-of select="$duration1" /></xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="du2-neg" select="starts-with($duration2, '-')" />
            <xsl:variable name="du2">
                <xsl:choose>
                    <xsl:when test="$du2-neg"><xsl:value-of select="substring($duration2, 2)" /></xsl:when>
                    <xsl:otherwise><xsl:value-of select="$duration2" /></xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="duration">
                <xsl:if test="starts-with($du1, 'P') and
                    not(translate($du1, '0123456789PYMDTHS.', '')) and
                    starts-with($du2, 'P') and
                    not(translate($du2, '0123456789PYMDTHS.', ''))">
                    <xsl:variable name="du1-date">
                        <xsl:choose>
                            <xsl:when test="contains($du1, 'T')"><xsl:value-of select="substring-before(substring($du1, 2), 'T')" /></xsl:when>
                            <xsl:otherwise><xsl:value-of select="substring($du1, 2)" /></xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="du1-time">
                        <xsl:if test="contains($du1, 'T')"><xsl:value-of select="substring-after($du1, 'T')" /></xsl:if>
                    </xsl:variable>
                    <xsl:variable name="du2-date">
                        <xsl:choose>
                            <xsl:when test="contains($du2, 'T')"><xsl:value-of select="substring-before(substring($du2, 2), 'T')" /></xsl:when>
                            <xsl:otherwise><xsl:value-of select="substring($du2, 2)" /></xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="du2-time">
                        <xsl:if test="contains($du2, 'T')"><xsl:value-of select="substring-after($du2, 'T')" /></xsl:if>
                    </xsl:variable>
                    <xsl:if test="(not($du1-date) or
                        (not(translate($du1-date, '0123456789YMD', '')) and
                        not(substring-after($du1-date, 'D')) and
                        (contains($du1-date, 'D') or 
                        (not(substring-after($du1-date, 'M')) and
                        (contains($du1-date, 'M') or
                        not(substring-after($du1-date, 'Y'))))))) and
                        (not($du1-time) or
                        (not(translate($du1-time, '0123456789HMS.', '')) and
                        not(substring-after($du1-time, 'S')) and
                        (contains($du1-time, 'S') or
                        not(substring-after($du1-time, 'M')) and
                        (contains($du1-time, 'M') or
                        not(substring-after($du1-time, 'Y')))))) and
                        (not($du2-date) or
                        (not(translate($du2-date, '0123456789YMD', '')) and
                        not(substring-after($du2-date, 'D')) and
                        (contains($du2-date, 'D') or 
                        (not(substring-after($du2-date, 'M')) and
                        (contains($du2-date, 'M') or
                        not(substring-after($du2-date, 'Y'))))))) and
                        (not($du2-time) or
                        (not(translate($du2-time, '0123456789HMS.', '')) and
                        not(substring-after($du2-time, 'S')) and
                        (contains($du2-time, 'S') or
                        not(substring-after($du2-time, 'M')) and
                        (contains($du2-time, 'M') or
                        not(substring-after($du2-time, 'Y'))))))">
                        <xsl:variable name="du1y-str">
                            <xsl:choose>
                                <xsl:when test="contains($du1-date, 'Y')"><xsl:value-of select="substring-before($du1-date, 'Y')" /></xsl:when>
                                <xsl:otherwise>0</xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="du1m-str">
                            <xsl:choose>
                                <xsl:when test="contains($du1-date, 'M')">
                                    <xsl:choose>
                                        <xsl:when test="contains($du1-date, 'Y')"><xsl:value-of select="substring-before(substring-after($du1-date, 'Y'), 'M')" /></xsl:when>
                                        <xsl:otherwise><xsl:value-of select="substring-before($du1-date, 'M')" /></xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:otherwise>0</xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="du1d-str">
                            <xsl:choose>
                                <xsl:when test="contains($du1-date, 'D')">
                                    <xsl:choose>
                                        <xsl:when test="contains($du1-date, 'M')"><xsl:value-of select="substring-before(substring-after($du1-date, 'M'), 'D')" /></xsl:when>
                                        <xsl:when test="contains($du1-date, 'Y')"><xsl:value-of select="substring-before(substring-after($du1-date, 'Y'), 'D')" /></xsl:when>
                                        <xsl:otherwise><xsl:value-of select="substring-before($du1-date, 'D')" /></xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:otherwise>0</xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="du1h-str">
                            <xsl:choose>
                                <xsl:when test="contains($du1-time, 'H')"><xsl:value-of select="substring-before($du1-time, 'H')" /></xsl:when>
                                <xsl:otherwise>0</xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="du1min-str">
                            <xsl:choose>
                                <xsl:when test="contains($du1-time, 'M')">
                                    <xsl:choose>
                                        <xsl:when test="contains($du1-time, 'H')"><xsl:value-of select="substring-before(substring-after($du1-time, 'H'), 'M')" /></xsl:when>
                                        <xsl:otherwise><xsl:value-of select="substring-before($du1-time, 'M')" /></xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:otherwise>0</xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="du1s-str">
                            <xsl:choose>
                                <xsl:when test="contains($du1-time, 'S')">
                                    <xsl:choose>
                                        <xsl:when test="contains($du1-time, 'M')"><xsl:value-of select="substring-before(substring-after($du1-time, 'M'), 'S')" /></xsl:when>
                                        <xsl:when test="contains($du1-time, 'H')"><xsl:value-of select="substring-before(substring-after($du1-time, 'H'), 'S')" /></xsl:when>
                                        <xsl:otherwise><xsl:value-of select="substring-before($du1-time, 'S')" /></xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:otherwise>0</xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="mult1" select="($du1-neg * -2) + 1" />
                        <xsl:variable name="du1y" select="$du1y-str * $mult1" />
                        <xsl:variable name="du1m" select="$du1m-str * $mult1" />
                        <xsl:variable name="du1d" select="$du1d-str * $mult1" />
                        <xsl:variable name="du1h" select="$du1h-str * $mult1" />
                        <xsl:variable name="du1min" select="$du1min-str * $mult1" />
                        <xsl:variable name="du1s" select="$du1s-str * $mult1" />
                        
                        <xsl:variable name="du2y-str">
                            <xsl:choose>
                                <xsl:when test="contains($du2-date, 'Y')"><xsl:value-of select="substring-before($du2-date, 'Y')" /></xsl:when>
                                <xsl:otherwise>0</xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="du2m-str">
                            <xsl:choose>
                                <xsl:when test="contains($du2-date, 'M')">
                                    <xsl:choose>
                                        <xsl:when test="contains($du2-date, 'Y')"><xsl:value-of select="substring-before(substring-after($du2-date, 'Y'), 'M')" /></xsl:when>
                                        <xsl:otherwise><xsl:value-of select="substring-before($du2-date, 'M')" /></xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:otherwise>0</xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="du2d-str">
                            <xsl:choose>
                                <xsl:when test="contains($du2-date, 'D')">
                                    <xsl:choose>
                                        <xsl:when test="contains($du2-date, 'M')"><xsl:value-of select="substring-before(substring-after($du2-date, 'M'), 'D')" /></xsl:when>
                                        <xsl:when test="contains($du2-date, 'Y')"><xsl:value-of select="substring-before(substring-after($du2-date, 'Y'), 'D')" /></xsl:when>
                                        <xsl:otherwise><xsl:value-of select="substring-before($du2-date, 'D')" /></xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:otherwise>0</xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="du2h-str">
                            <xsl:choose>
                                <xsl:when test="contains($du2-time, 'H')"><xsl:value-of select="substring-before($du2-time, 'H')" /></xsl:when>
                                <xsl:otherwise>0</xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="du2min-str">
                            <xsl:choose>
                                <xsl:when test="contains($du2-time, 'M')">
                                    <xsl:choose>
                                        <xsl:when test="contains($du2-time, 'H')"><xsl:value-of select="substring-before(substring-after($du2-time, 'H'), 'M')" /></xsl:when>
                                        <xsl:otherwise><xsl:value-of select="substring-before($du2-time, 'M')" /></xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:otherwise>0</xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="du2s-str">
                            <xsl:choose>
                                <xsl:when test="contains($du2-time, 'S')">
                                    <xsl:choose>
                                        <xsl:when test="contains($du2-time, 'M')"><xsl:value-of select="substring-before(substring-after($du2-time, 'M'), 'S')" /></xsl:when>
                                        <xsl:when test="contains($du2-time, 'H')"><xsl:value-of select="substring-before(substring-after($du2-time, 'H'), 'S')" /></xsl:when>
                                        <xsl:otherwise><xsl:value-of select="substring-before($du2-time, 'S')" /></xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:otherwise>0</xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="mult2" select="($du2-neg * -2) + 1" />
                        <xsl:variable name="du2y" select="$du2y-str * $mult2" />
                        <xsl:variable name="du2m" select="$du2m-str * $mult2" />
                        <xsl:variable name="du2d" select="$du2d-str * $mult2" />
                        <xsl:variable name="du2h" select="$du2h-str * $mult2" />
                        <xsl:variable name="du2min" select="$du2min-str * $mult2" />
                        <xsl:variable name="du2s" select="$du2s-str * $mult2" />
                        
                        <xsl:variable name="min-s" select="60" />
                        <xsl:variable name="hour-s" select="60 * 60" />
                        <xsl:variable name="day-s" select="60 * 60 * 24" />
                        
                        <xsl:variable name="seconds" select="($du1s + $du2s) +
                            (($du1min + $du2min) * $min-s) +
                            (($du1h + $du2h) * $hour-s) +
                            (($du1d + $du2d) * $day-s)" />
                        <xsl:variable name="months" select="($du1m + $du2m) +
                            (($du1y + $du2y) * 12)" />
                        
                        
                        <xsl:choose>
                            <xsl:when test="($months * $seconds) &lt; 0" />
                            <xsl:when test="$months or $seconds">
                                <xsl:if test="$months &lt; 0 or $seconds &lt; 0">-</xsl:if>
                                <xsl:text>P</xsl:text>
                                <xsl:variable name="m" select="$months * ((($months >= 0) * 2) - 1)" />
                                <xsl:variable name="years1" select="floor($m div 12)" />
                                <xsl:variable name="mnths1" select="$m - ($years1 * 12)" />
                                <xsl:variable name="years">
                                    <xsl:choose>
                                        <xsl:when test="$mnths1 &lt;= 0"><xsl:value-of select="$years1 -1"/></xsl:when>
                                        <xsl:otherwise><xsl:value-of select="$years1"/></xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:variable name="mnths">
                                    <xsl:choose>
                                        <xsl:when test="$mnths1 &lt;= 0">12</xsl:when>
                                        <xsl:otherwise><xsl:value-of select="$mnths1"/></xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:variable name="s" select="$seconds * ((($seconds >= 0) * 2) - 1)" />
                                <xsl:variable name="days" select="floor($s div $day-s)" />
                                <xsl:variable name="hours" select="floor(($s - ($days * $day-s)) div $hour-s)" />
                                <xsl:variable name="mins" select="floor(($s - ($days * $day-s) - ($hours * $hour-s)) div $min-s)" />
                                <xsl:variable name="secs" select="$s - ($days * $day-s) - ($hours * $hour-s) - ($mins * $min-s)" />
                                <xsl:if test="$years">
                                    <xsl:value-of select="$years" />
                                    <xsl:text>Y</xsl:text>
                                </xsl:if>
                                <xsl:if test="$mnths">
                                    <xsl:if test="string-length($mnths) = 1">0</xsl:if>
                                    <xsl:value-of select="$mnths" />
                                    <xsl:text>M</xsl:text>
                                </xsl:if>
                                <xsl:if test="$days">
                                    <xsl:if test="string-length($days) = 1">0</xsl:if>
                                    <xsl:value-of select="$days" />
                                    <xsl:text>D</xsl:text>
                                </xsl:if>
                                <xsl:if test="$hours or $mins or $secs">T</xsl:if>
                                <xsl:if test="$hours">
                                    <xsl:if test="string-length($hours) = 1">0</xsl:if>
                                    <xsl:value-of select="$hours" />
                                    <xsl:text>H</xsl:text>
                                </xsl:if>
                                <xsl:if test="$mins">
                                    <xsl:if test="string-length($mins) = 1">0</xsl:if>
                                    <xsl:value-of select="$mins" />
                                    <xsl:text>M</xsl:text>
                                </xsl:if>
                                <xsl:if test="$secs">
                                    <xsl:if test="string-length($secs) = 1">0</xsl:if>
                                    <xsl:value-of select="$secs" />
                                    <xsl:text>S</xsl:text>
                                </xsl:if>
                            </xsl:when>
                            <xsl:otherwise>P</xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                </xsl:if>
            </xsl:variable>
            <xsl:value-of select="$duration" />
        </xsl:template>
        
</xsl:stylesheet>