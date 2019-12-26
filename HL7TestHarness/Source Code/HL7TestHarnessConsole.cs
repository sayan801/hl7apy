/* Module Header

  $Header:   L:/pvcsrep65/HL7TestHarness/archives/Source Code/HL7TestHarnessConsole.cs-arc   1.6   18 Jan 2007 14:20:22   mwicks  $

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

------------------------------------------------------------------------
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
------------------------------------------------------------------------

  Project:          HL7 Test Harness
  Programmer:       Matthew Wicks
  Created:          March 17, 2006

  History:
  Action      Who     Date            Comments
  ------------------------------------------------------------------------
  <<Action>>  xxx     yyyy-mm-dd      <<Comments here>>


  Application notes:
  ------------------------------------------------------------------------
  <<Place notes on usages, known problems, etc>>

  $Log:   L:/pvcsrep65/HL7TestHarness/archives/Source Code/HL7TestHarnessConsole.cs-arc  $
 *
 *   Rev 1.6   18 Jan 2007 14:20:22   mwicks
 *updated reporting and workflow schemas.
  Revision 1.1.1.1  2006/11/24 18:16:42  deltaware
  Init check in of HL7 Test Harness, version 2.0.3.9. For releases before this version please contact deltaware systems.

 *
 *   Rev 1.5   11 Sep 2006 16:10:26   mwicks
 *updated tcp monitoring to monitor the dns HostName instead of the localhost name.
 *
 *   Rev 1.4   28 Jun 2006 16:24:26   mwicks
 *removed "All Rights Reserved." from all files.
 *
 *   Rev 1.3   27 Jun 2006 13:00:26   mwicks
 *updated console application with ablitiy to stop processes from the command line.
 *
 *   Rev 1.2   26 Jun 2006 13:29:26   mwicks
 *added Lic
 *
 *   Rev 1.1   26 Jun 2006 13:18:24   mwicks
 *Updated License.
 */

using System;
using System.Collections.Generic;
using System.Text;

namespace HL7TestHarnessConsole
{
    class HL7TestHarnessConsole
    {
        static void Main(string[] args)
        {
            HL7TestHarness.TestHarnessConsole console = new HL7TestHarness.TestHarnessConsole(args);
        }
    }
}
