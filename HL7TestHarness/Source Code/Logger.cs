/* Module Header

  $Header:   L:/pvcsrep65/HL7TestHarness/archives/Source Code/Logger.cs-arc   1.23   26 Mar 2007 13:29:52   mwicks  $

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

  $Log:   L:/pvcsrep65/HL7TestHarness/archives/Source Code/Logger.cs-arc  $
 *
 *   Rev 1.23   26 Mar 2007 13:29:52   mwicks
 *Updated with the following new features:
 *- Client simulator will replace http calls to localhost with http requests to the local host name.
 *- Modified enable/disable validation and translation code to reduce amount of code executed when disabled.
 *- (GUI) message proxy now shows Rx & Tx messages.
 *- (GUI) updated to the enable and disable buttons.
 *- (GUI) updated results status grid to be resizable.
 *- (cmdline) auto start/stop file
 *- (cmdline) outputs message count, response time, avg time, total time.
 *- (cmdline) burst mode functionality.
 *
 *   Rev 1.22   16 Mar 2007 15:46:02   mwicks
 *updated for the following:
 *1. msg proxy and client sim will replace localhost address names with machine name.
 *2. msg proxy outputs timing and number of messages sent.
 *3. commandline has auto control file.
 *4. GUI msg proxy now shows msgs from client and server systems.
 *5. GUI enable/disable redone to be more clear.
 *6. Results data grid columns re-sizeable
 *7. commandline will now handle all development options that GUI uses.
 *
 *   Rev 1.21   18 Jan 2007 14:20:22   mwicks
 *updated reporting and workflow schemas.
  Revision 1.1.1.1  2006/11/24 18:16:43  deltaware
  Init check in of HL7 Test Harness, version 2.0.3.9. For releases before this version please contact deltaware systems.

 *
 *   Rev 1.20   11 Sep 2006 16:10:28   mwicks
 *updated tcp monitoring to monitor the dns HostName instead of the localhost name.
 *
 *   Rev 1.19   31 Aug 2006 21:04:40   mwicks
 *reduced memory usage
 *
 *   Rev 1.17   31 Aug 2006 11:48:44   mwicks
 *updated to remove memory leaks
 *
 *   Rev 1.16   29 Aug 2006 14:46:38   mwicks
 *Updated to fix some memory issues.
 *
 *   Rev 1.15   28 Jun 2006 16:24:30   mwicks
 *removed "All Rights Reserved." from all files.
 *
 *   Rev 1.14   28 Jun 2006 15:04:22   mwicks
 *Updated to accept a referance tag in the workflow documents
 *for linking multiple workflows.
 *
 *   Rev 1.13   26 Jun 2006 13:29:26   mwicks
 *added Lic
 *
 *   Rev 1.12   26 Jun 2006 13:18:24   mwicks
 *Updated License.
 *
 *   Rev 1.11   31 May 2006 10:03:36   mwicks
 *Updated to include a console interface
 *
 *   Rev 1.10   24 May 2006 10:33:40   mwicks
 *updated to allow system to be used as a true proxy
 *
 *   Rev 1.9   04 May 2006 13:59:42   mwicks
 *Updated WorkFlow diagram tab
 *
 *   Rev 1.8   27 Apr 2006 14:40:14   mwicks
 *Added Server user and password fields
 *
 *   Rev 1.7   07 Apr 2006 09:33:22   mwicks
 *Updated to run multiple workflows
 *
 *   Rev 1.6   30 Mar 2006 11:30:24   mwicks
 *Updated Log file to fix TxMessage bug
 *
 *   Rev 1.5   28 Mar 2006 10:32:36   mwicks
 *Update
 *
 *   Rev 1.4   24 Mar 2006 10:20:56   mwicks
 *Combined event handlers into a single base clase
 *
 *   Rev 1.3   23 Mar 2006 11:53:24   mwicks
 *Added 
 *Http Report function
 *Global start process
 *
 *   Rev 1.2   21 Mar 2006 13:24:02   mwicks
 *Multi message update
 *
 *   Rev 1.1   17 Mar 2006 15:46:26   mwicks
 *Updated $Header
*/

using System;
using System.IO;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Xml.XPath;
using System.Xml.Xsl;
using System.Net;
using System.Threading;
using System.Collections.Specialized;
using System.ComponentModel;


namespace HL7TestHarness
{
    // onLogChangedEventHandler is not thread safe.
    public delegate void onLogChangedEventHandler(XmlDocument logData);


    class Logger
    {
        public XmlDocument logFile;
        public event onLogChangedEventHandler OnLogChanged;


        public Logger( )
        {
            logFile = new XmlDocument();

        }
        ~Logger()
        {
            logFile = null;
            OnLogChanged = null;
        }

        public void setLogFileBaseStructure(XmlDocument baseStructure)
        {
            //logFile = baseStructure;
            StringReader sr = new StringReader(baseStructure.OuterXml);
            if (logFile != null)
                logFile = null;
            logFile = new XmlDocument();

            logFile.Load(sr);
            sr.Close();
            sr = null;
        }

        public void logEventHanderConsumer(testResults e)
        {
            // consume the log event.
            logData(e);
        }

        private void logData(testResults e)
        {
            XmlDocument doc;
            XPathNavigator xnav;
            XPathNodeIterator xnode;
            try
            {
                doc = new XmlDocument();
                xnav = logFile.CreateNavigator();
                xnode = xnav.Select(e.xpath);

                if (xnode.MoveNext())
                {
                    XmlWriter xwriter;

                    if (xnode.Current.MoveToAttribute("timestamp", ""))
                    {
                        xnode.Current.SetValue(e.timeStamp);
                        xnode.Current.MoveToParent();
                    }
                    else
                        xnode.Current.CreateAttribute("", "timestamp", "", e.timeStamp);


                    if (e.status.Length > 0)
                    {
                        if (xnode.Current.MoveToAttribute("status", ""))
                        {
                            xnode.Current.SetValue(e.status);
                            xnode.Current.MoveToParent();
                        }
                        else
                            xnode.Current.CreateAttribute("", "status", "", e.status);
                    }

                    if (e.element.Length > 0)
                    {
                        xwriter = xnode.Current.AppendChild();
                        if (e.details.Length > 0)
                        {
                            try
                            {
                                doc.LoadXml("<" + e.element + ">" + e.details + "</" + e.element + ">");
                                xwriter.WriteNode(doc.CreateNavigator(), false);
                            }
                            catch
                            {
                                xwriter.WriteStartElement(e.element);
                                xwriter.WriteCData(e.details);
                                xwriter.WriteEndElement();
                            }
                        }
                        else
                        {
                            xwriter.WriteStartElement(e.element);
                            xwriter.WriteValue("No details present");
                            xwriter.WriteEndElement();
                        }
                        xwriter.Flush();
                        xwriter.Close();
                    }

                    //call event to notify log update.
                    if (OnLogChanged != null)
                    {
                        OnLogChanged(logFile);
                    }

                }
                else
                {
                    e.status = "false";
                }
            }
            catch
            {
                e.status = "false";
            }
            finally
            {
                doc = null;
                xnav = null;
                xnode = null;
            }
        }

        public String getHtmlReportLog(String transformFileName)
        {
            //XslTransform transformer;
            XslCompiledTransform transformer= new XslCompiledTransform(false);
            XsltSettings settings = new XsltSettings(true, true);

            StringBuilder sbuilder = new StringBuilder();
            TextWriter writer = new StringWriter(sbuilder);

            try
            {
                transformer.Load(transformFileName, settings, new XmlUrlResolver());

                // Execute the transform.
                transformer.Transform(logFile, null, writer);

                //transformer.Transform(message,null,writer);
                writer.Close();
            }
            catch
            {
                throw;
            }
            finally
            {
                // should not be required 
                // now that we are creating the transformer with debug = false
                // if memory usages starts to go up, relook at if this is required.
                //if(transformer != null)
                //    transformer.TemporaryFiles.Delete();

                transformer = null;
                settings = null;
                writer = null;
            }
            
            
            return (sbuilder.ToString());

        }

    }
}
