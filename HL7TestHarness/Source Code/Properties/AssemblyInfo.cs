/* Module Header

  $Header:   L:/pvcsrep65/HL7TestHarness/archives/Source Code/Properties/AssemblyInfo.cs-arc   1.32   11 Apr 2007 14:23:04   ottobuild  $

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

  $Log:   L:/pvcsrep65/HL7TestHarness/archives/Source Code/Properties/AssemblyInfo.cs-arc  $
 *
 *   Rev 1.32   11 Apr 2007 14:23:04   ottobuild
 *Increment_build_number_(performed_by_autobuild_process)
 *
 *   Rev 1.31   30 Mar 2007 10:25:38   ottobuild
 *Increment_build_number_(performed_by_autobuild_process)
 *
 *   Rev 1.30   30 Mar 2007 09:53:20   ottobuild
 *Increment_build_number_(performed_by_autobuild_process)
 *
 *   Rev 1.29   28 Mar 2007 07:48:30   ottobuild
 *Increment_build_number_(performed_by_autobuild_process)
 *
 *   Rev 1.28   27 Mar 2007 12:40:50   ottobuild
 *Increment_build_number_(performed_by_autobuild_process)
 *
 *   Rev 1.27   16 Mar 2007 15:46:46   mwicks
 *updated for the following:
 *1. msg proxy and client sim will replace localhost address names with machine name.
 *2. msg proxy outputs timing and number of messages sent.
 *3. commandline has auto control file.
 *4. GUI msg proxy now shows msgs from client and server systems.
 *5. GUI enable/disable redone to be more clear.
 *6. Results data grid columns re-sizeable
 *7. commandline will now handle all development options that GUI uses.
 *
 *   Rev 1.25   15 Nov 2006 11:45:48   ottobuild
 *Increment_build_number_(performed_by_autobuild_process)
 *
 *   Rev 1.24   10 Nov 2006 09:36:44   ottobuild
 *Increment_build_number_(performed_by_autobuild_process)
 *
 *   Rev 1.23   Nov 08 2006 09:26:16   scollicutt
 *Increment_build_number_(performed_by_autobuild_process)
 *
 *   Rev 1.22   Nov 08 2006 09:21:42   scollicutt
 *Increment_build_number_(performed_by_autobuild_process)
 *
 *   Rev 1.21   07 Nov 2006 17:01:46   ottobuild
 *Increment_build_number_(performed_by_autobuild_process)
 *
 *   Rev 1.20   07 Nov 2006 16:55:12   mwicks
 *updated version to 2.0.4.0
 *
 *   Rev 1.18   07 Nov 2006 16:27:54   mwicks
 *Updated Version
 *
 *   Rev 1.17   12 Oct 2006 15:53:14   ottobuild
 *Increment_build_number_(performed_by_autobuild_process)
 *
 *   Rev 1.16   11 Sep 2006 16:10:34   mwicks
 *updated tcp monitoring to monitor the dns HostName instead of the localhost name.
 *
 *   Rev 1.8   06 Sep 2006 16:07:44   mwicks
 *Updated xpath values to get hl7 namespace root element name with multiple other namespaces defined.
 *
 *   Rev 1.7   06 Sep 2006 10:40:22   mwicks
 *updated to allow soap wrappers to be used.
 *
 *   Rev 1.6   05 Sep 2006 13:33:20   mwicks
 *updated version
 *
 *   Rev 1.5   01 Sep 2006 08:54:40   mwicks
 *Updated version
 *
 *   Rev 1.4   28 Aug 2006 14:35:16   mwicks
 *updated to version 2.0.0.0
 *
 *   Rev 1.3   29 Jun 2006 10:55:20   mwicks
 *update about box
 *
 *   Rev 1.2   26 Jun 2006 13:28:52   mwicks
 *Added Lic
*/
using System.Reflection;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;

// General Information about an assembly is controlled through the following 
// set of attributes. Change these attribute values to modify the information
// associated with an assembly.
[assembly: AssemblyTitle("HL7 Test Harness")]
[assembly: AssemblyDescription("")]
[assembly: AssemblyConfiguration("")]
[assembly: AssemblyCompany("Deltaware Systems")]
[assembly: AssemblyProduct("HL7 Test Harness")]
[assembly: AssemblyCopyright("Copyright ©  2006")]
[assembly: AssemblyTrademark("")]
[assembly: AssemblyCulture("")]

// Setting ComVisible to false makes the types in this assembly not visible 
// to COM components.  If you need to access a type in this assembly from 
// COM, set the ComVisible attribute to true on that type.
[assembly: ComVisible(false)]

// The following GUID is for the ID of the typelib if this project is exposed to COM
[assembly: Guid("977fc023-6a92-4dfa-9786-b42ce891ced4")]

// Version information for an assembly consists of the following four values:
//
//      Major Version
//      Minor Version 
//      Build Number
//      Revision
//
[assembly: AssemblyVersion("2.0.1.4")]
[assembly: AssemblyFileVersion("2.0.3.15")]
