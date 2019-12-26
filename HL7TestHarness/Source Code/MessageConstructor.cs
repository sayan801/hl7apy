/* Module Header

  $Header:   L:/pvcsrep65/HL7TestHarness/archives/Source Code/MessageConstructor.cs-arc   1.26   19 Jul 2007 15:45:00   mwicks  $

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

  $Log:   L:/pvcsrep65/HL7TestHarness/archives/Source Code/MessageConstructor.cs-arc  $
 *
 *   Rev 1.26   19 Jul 2007 15:45:00   mwicks
 *Updated 
 *change tcp handling
 *removed thread sleeps
 *added attribute to disable client sim by message.
 *
 *   Rev 1.25   26 Mar 2007 13:29:52   mwicks
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
 *   Rev 1.24   16 Mar 2007 15:46:02   mwicks
 *updated for the following:
 *1. msg proxy and client sim will replace localhost address names with machine name.
 *2. msg proxy outputs timing and number of messages sent.
 *3. commandline has auto control file.
 *4. GUI msg proxy now shows msgs from client and server systems.
 *5. GUI enable/disable redone to be more clear.
 *6. Results data grid columns re-sizeable
 *7. commandline will now handle all development options that GUI uses.
 *
 *   Rev 1.23   18 Jan 2007 14:20:24   mwicks
 *updated reporting and workflow schemas.
  Revision 1.1.1.1  2006/11/24 18:16:43  deltaware
  Init check in of HL7 Test Harness, version 2.0.3.9. For releases before this version please contact deltaware systems.

 *
 *   Rev 1.22   10 Nov 2006 09:26:42   mwicks
 *updated construction vars so that all simulators can access vars set by other simulators.
 *
 *   Rev 1.21   08 Nov 2006 17:46:48   mwicks
 *added WorkingDirectory to xsl calls from simulators
 *
 *   Rev 1.20   06 Nov 2006 11:48:56   mwicks
 *Added Test Data file updating
 *
 *   Rev 1.19   19 Sep 2006 15:08:46   mwicks
 *updated to remove exception when parameters are not set during construction of messages.
 *
 *   Rev 1.18   11 Sep 2006 16:10:28   mwicks
 *updated tcp monitoring to monitor the dns HostName instead of the localhost name.
 *
 *   Rev 1.17   06 Sep 2006 10:40:20   mwicks
 *updated to allow soap wrappers to be used.
 *
 *   Rev 1.16   31 Aug 2006 16:10:52   mwicks
 *updated usage of XslCompiledTransform to try to clean up it's memory after use.
 *
 *   Rev 1.15   31 Aug 2006 11:48:46   mwicks
 *updated to remove memory leaks
 *
 *   Rev 1.14   24 Aug 2006 09:27:26   mwicks
 *Updated Message Constuctor to use a memory stream not a String stream to prevent it form changing the encoding of the messages.
 *
 *   Rev 1.13   15 Aug 2006 16:16:58   mwicks
 *Updated to load xmlfile using streams.
 *updated to include parameters in construction transforms
 *updated workflows to allow paramlists.
 *
 *   Rev 1.12   03 Aug 2006 15:04:18   mwicks
 *Changed xml loading processes to always load from a stream.
 *xmldoc.loadxml(string) 
 *changed to 
 *xsldoc.load(new StringStream(string))
 *
 *
 *   Rev 1.11   28 Jun 2006 16:24:30   mwicks
 *removed "All Rights Reserved." from all files.
 *
 *   Rev 1.10   26 Jun 2006 13:29:26   mwicks
 *added Lic
 *
 *   Rev 1.9   26 Jun 2006 13:18:24   mwicks
 *Updated License.
 *
 *   Rev 1.8   23 Jun 2006 09:11:48   mwicks
 *updated comments
 *
 *   Rev 1.7   19 Jun 2006 14:38:40   mwicks
 *Updated to allow for direct file compares.
 *Updated to pass the message direction to xsl during construction and validation.
 *
 *   Rev 1.6   24 May 2006 10:33:40   mwicks
 *updated to allow system to be used as a true proxy
 *
 *   Rev 1.5   05 May 2006 09:51:08   mwicks
 *Updated message validation and construction to accept the TestData as a parameter.
 *
 *   Rev 1.4   04 May 2006 13:59:36   mwicks
 *Updated WorkFlow diagram tab
 *
 *   Rev 1.3   02 May 2006 11:17:02   mwicks
 *Added Staged Data update Ablities
 *
 *   Rev 1.2   27 Apr 2006 14:40:16   mwicks
 *Added Server user and password fields
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
using System.Threading;


namespace HL7TestHarness
{


    class MessageConstructor
    {
        public class variable
        {
            public String name;
            public String value;
            public variable(String name, String value)
            {
                this.name = name;
                this.value = value;
            }
            ~variable()
            {
                name = "";
                value = "";
            }
        }

        private XPathNavigator navdoc;
        private XmlDocument message;
        private XmlDocument stagedTestData;
        private XmlDocument historyData;

        private const String ruleXpath = ".//construction/rule";
        private Boolean isServerRequest;

        //private List<variable> Variables = new List<variable>();
        private List<variable> Variables;

        public String Errors = "";
        public Boolean IsServerRequest
        {
            get { return isServerRequest; }
            set { isServerRequest = value; }
        }
        
        public MessageConstructor()
        {
            message = new XmlDocument();
            Variables = new List<variable>();
        }
        public MessageConstructor(List<variable> VariableObj)
        {
            message = new XmlDocument();
            Variables = VariableObj;
        }

        ~MessageConstructor()
        {
            navdoc = null;
            message = null;
            stagedTestData = null;

            if(Variables != null)
                Variables.Clear();
            Variables = null;
        }
        
        public void setRule(XPathNavigator rule)
        {
            navdoc = rule;
        }

        public void setStagedData(XmlDocument Data)
        {
            stagedTestData = Data;
        }
        public void setHistoryData(XmlDocument Data)
        {
            historyData = Data;
        }


        public XmlDocument Construct ( XmlDocument msg )
        {
            XPathNodeIterator nodeIter = navdoc.Select(ruleXpath);

            // create a copy of the message.
            try
            {
                StringReader sr = new StringReader(msg.OuterXml);
                message.Load(sr);
                sr.Close();
                sr = null;
            }
            catch
            {
                message.CreateElement("error");
                message.CreateComment("empty document");
            }

            while (nodeIter.MoveNext())
            {
                String constructType = nodeIter.Current.GetAttribute("type", "");
                String filename = nodeIter.Current.GetAttribute("filename", "");
                String name = nodeIter.Current.GetAttribute("name", "");
                String xpath = nodeIter.Current.GetAttribute("xpath", "");
                String nameSpace = nodeIter.Current.GetAttribute("ns", "");

                // modify message via transform
                if (constructType == "transform")
                {
                    TransformMessage(filename,nodeIter.Current,message);
                }
                // modify test data via transform
                else if (constructType == "testDataLoad")
                {
                    TransformMessage(filename, nodeIter.Current,stagedTestData);
                }
                // modify message via direct file load
                else if (constructType == "static")
                {
                    message.Load(filename);
                }
                // modify message via direct file load
                else if (constructType == "local")
                {
                    message.Load(nodeIter.Current.SelectSingleNode("child::*[1]").OuterXml);
                }
                // Variable setting (get the data from the message)
                else if (constructType == "setVariable")
                {
                    try
                    {
                        XmlNamespaceManager nsmgr = new XmlNamespaceManager(message.NameTable);
                        if (nameSpace != "")
                            nsmgr.AddNamespace("ns", nameSpace);

                        // remove any old Variables with the same name.
                        while (Variables.Exists(varName(name)))
                        {
                            Variables.Remove(Variables.Find(varName(name)));
                        }

                        Variables.Add(new variable(name, message.SelectSingleNode(xpath, nsmgr).Value));
                    }
                    catch 
                    {
                        Errors = Errors + "Error setting Variable [" + name + "] to xpath [" + xpath + "]\n\r";
                        //throw new Exception("Error setting Variable [" + name + "] to xpath [" + xpath + "]");
                    }
                }
                // Variable putting (put the data into the message)
                else if (constructType == "putVariable")
                {
                    try
                    {
                        XmlNamespaceManager nsmgr = new XmlNamespaceManager(message.NameTable);
                        if (nameSpace != "")
                            nsmgr.AddNamespace("ns", nameSpace);
                        if (Variables.Exists(varName(name)))
                        {
                            message.SelectSingleNode(xpath, nsmgr).Value = Variables.FindLast(varName(name)).value;
                        }
                    }
                    catch 
                    {
                        Errors = Errors + "Error Putting Variable [" + name + "] to xpath [" + xpath + "]\n\r";
                        //throw new Exception("Error Putting Variable [" + name + "] at xpath [" + xpath + "]");
                    }
                }
            }

            return message;
        }

        private void TransformMessage(String xslFileName, XPathNavigator parameters, XmlDocument output)
        {
            //XslTransform transformer;
            XslCompiledTransform transformer = new XslCompiledTransform(false);
            XsltArgumentList arg = new XsltArgumentList();
            XsltSettings settings = new XsltSettings(true, true);
            //XPathNodeIterator paramList = parameters.Select("descendant-or-self::param");
            XPathNodeIterator paramList = parameters.Select("ancestor-or-self::node()/paramList/param");

            MemoryStream ms = new MemoryStream();
            StreamWriter sw = new StreamWriter(ms);

            //StringBuilder sbuilder=new StringBuilder();
            //TextWriter writer=new StringWriter(sbuilder);

            String paramName;
            String paramValue;
            try
            {
                transformer.Load(xslFileName, settings, new XmlUrlResolver());

                DateTime d = DateTime.Now;
                arg.AddParam("now", "", d.ToString("yyyyMMddHHmmss"));
                arg.AddParam("OID", "", Guid.NewGuid().ToString());
                arg.AddParam("TestDataXml", "", stagedTestData);
                arg.AddParam("historyXml", "", historyData);
                arg.AddParam("WorkingDirectory", "", Directory.GetCurrentDirectory());
                arg.AddParam("threadID", "", Thread.CurrentThread.GetHashCode().ToString());

                if (IsServerRequest == true)
                    arg.AddParam("mapping", "", "toServer");
                else
                    arg.AddParam("mapping", "", "toClient");

                // add any param's that are defined in the workflow.
                while (paramList.MoveNext())
                {
                    paramName = paramList.Current.GetAttribute("name", "");
                    paramValue = paramList.Current.GetAttribute("value", "");
                    if (paramName != String.Empty & paramValue != String.Empty)
                    {
                        arg.AddParam(paramName, "", paramValue);
                    }
                }
                // Execute the transform.
                transformer.Transform(message, arg, sw);

                ms.Seek(0, SeekOrigin.Begin);
                output.Load(ms);

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

                if (arg != null)
                    arg.Clear();

                arg = null;
                transformer = null;
                settings = null;
                paramList = null;

                ms = null;
                sw = null;
            }
        }

  
        Predicate<variable> varName(String name)
        {
            return delegate(variable item) { return (item.name == name); };
        }
    }

}
