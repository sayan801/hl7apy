/* Module Header

  $Header:   L:/pvcsrep65/HL7TestHarness/archives/Source Code/MessageValidator.cs-arc   1.33   19 Jul 2007 15:45:00   mwicks  $

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

  $Log:   L:/pvcsrep65/HL7TestHarness/archives/Source Code/MessageValidator.cs-arc  $
 *
 *   Rev 1.33   19 Jul 2007 15:45:00   mwicks
 *Updated 
 *change tcp handling
 *removed thread sleeps
 *added attribute to disable client sim by message.
 *
 *   Rev 1.32   27 Mar 2007 15:59:52   mwicks
 *updated to fix two compiler warnings.
 *- warning CS0108: 'HL7TestHarness.config.ProxyConfig.port' hides inherited member 'HL7TestH
 *arness.config.SimulatorConfig.port'. Use the new keyword if hiding was intended
 *- warning CS0169: The private field 'HL7TestHarness.MessageValidator.ValidationMs
 *g' is never used
 *
 *   Rev 1.31   16 Mar 2007 15:46:02   mwicks
 *updated for the following:
 *1. msg proxy and client sim will replace localhost address names with machine name.
 *2. msg proxy outputs timing and number of messages sent.
 *3. commandline has auto control file.
 *4. GUI msg proxy now shows msgs from client and server systems.
 *5. GUI enable/disable redone to be more clear.
 *6. Results data grid columns re-sizeable
 *7. commandline will now handle all development options that GUI uses.
 *
 *   Rev 1.30   18 Jan 2007 14:20:24   mwicks
 *updated reporting and workflow schemas.
  Revision 1.1.1.1  2006/11/24 18:16:44  deltaware
  Init check in of HL7 Test Harness, version 2.0.3.9. For releases before this version please contact deltaware systems.

 *
 *   Rev 1.29   08 Nov 2006 17:46:50   mwicks
 *added WorkingDirectory to xsl calls from simulators
 *
 *   Rev 1.28   08 Nov 2006 15:21:04   mwicks
 *updated 
 *report - to place errors with messaging
 *testdata - all threads now use same testdata document
 *xsd - testdata and workflow xsd have been updated.
 *
 *   Rev 1.27   30 Oct 2006 09:32:54   mwicks
 *updated to add:
 *server simulator port
 *enable/disable client request validation
 *enable/disable server response validation
 *enable/disable message transformations by message proxy
 *
 *   Rev 1.26   28 Sep 2006 15:23:00   mwicks
 *updated to allow for validations to be dependent on message name.
 *
 *   Rev 1.25   19 Sep 2006 15:08:46   mwicks
 *updated to remove exception when parameters are not set during construction of messages.
 *
 *   Rev 1.24   15 Sep 2006 10:27:54   mwicks
 *Updated display of messages in UI
 *
 *   Rev 1.23   11 Sep 2006 16:10:28   mwicks
 *updated tcp monitoring to monitor the dns HostName instead of the localhost name.
 *
 *   Rev 1.22   06 Sep 2006 10:40:20   mwicks
 *updated to allow soap wrappers to be used.
 *
 *   Rev 1.21   05 Sep 2006 13:18:00   mwicks
 *Updated to reduce memory usage
 *
 *   Rev 1.20   31 Aug 2006 21:04:40   mwicks
 *reduced memory usage
 *
 *   Rev 1.19   31 Aug 2006 16:10:54   mwicks
 *updated usage of XslCompiledTransform to try to clean up it's memory after use.
 *
 *   Rev 1.18   31 Aug 2006 11:48:46   mwicks
 *updated to remove memory leaks
 *
 *   Rev 1.17   15 Aug 2006 16:16:58   mwicks
 *Updated to load xmlfile using streams.
 *updated to include parameters in construction transforms
 *updated workflows to allow paramlists.
 *
 *   Rev 1.16   03 Aug 2006 15:04:18   mwicks
 *Changed xml loading processes to always load from a stream.
 *xmldoc.loadxml(string) 
 *changed to 
 *xsldoc.load(new StringStream(string))
 *
 *
 *   Rev 1.15   28 Jun 2006 16:24:30   mwicks
 *removed "All Rights Reserved." from all files.
 *
 *   Rev 1.14   26 Jun 2006 13:29:26   mwicks
 *added Lic
 *
 *   Rev 1.13   26 Jun 2006 13:18:24   mwicks
 *Updated License.
 *
 *   Rev 1.12   21 Jun 2006 15:01:30   mwicks
 *added new schema checking for workflow documents and test data.
 *
 *   Rev 1.11   19 Jun 2006 14:38:40   mwicks
 *Updated to allow for direct file compares.
 *Updated to pass the message direction to xsl during construction and validation.
 *
 *   Rev 1.10   24 May 2006 10:33:40   mwicks
 *updated to allow system to be used as a true proxy
 *
 *   Rev 1.9   05 May 2006 09:51:08   mwicks
 *Updated message validation and construction to accept the TestData as a parameter.
 *
 *   Rev 1.8   04 May 2006 13:59:40   mwicks
 *Updated WorkFlow diagram tab
 *
 *   Rev 1.7   27 Apr 2006 14:40:14   mwicks
 *Added Server user and password fields
 *
 *   Rev 1.6   07 Apr 2006 09:33:24   mwicks
 *Updated to run multiple workflows
 *
 *   Rev 1.5   28 Mar 2006 10:32:36   mwicks
 *Update
 *
 *   Rev 1.4   24 Mar 2006 15:02:42   mwicks
 *Updated test status updating process
 *
 *   Rev 1.3   24 Mar 2006 10:21:00   mwicks
 *Combined event handlers into a single base clase
 *
 *   Rev 1.2   21 Mar 2006 14:51:46   mwicks
 *Added Try statement to catch exceptions.
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
using System.Globalization;


using System.Threading;



namespace HL7TestHarness
{
    class MessageValidator
    {
        public delegate void onTestProgress(String path, testResultStatus testStatus, String elementName, String testDetails);

        private XPathNavigator navdoc;
        private XmlDocument stagedTestData;
        private XmlDocument historyData;
        private Boolean isServerRequest;

        private Boolean Continue = true;

        private const String validationXpath = "/validation";
        private const String ruleXpath = "/rule";

        //private String ValidationMsg;

        public MessageValidator()
        {
            //stagedTestData = new XmlDocument();
        }

        ~MessageValidator()
        {
            //stagedTestData = null;
            navdoc = null;
        }

        public Boolean IsServerRequest
        {
            get { return isServerRequest; }
            set { isServerRequest = value; }
        }

        public void setRule(XPathNavigator rule)
        {
            navdoc = rule;
        }

        public void setStagedData(XmlDocument Data)
        {
            stagedTestData = Data;
            //StringReader sr = new StringReader(Data.OuterXml);
            //stagedTestData.Load(sr);
            //sr.Close();
            //sr = null;
        }
        public void setHisotryData(XmlDocument Data)
        {
            historyData = Data;
            //StringReader sr = new StringReader(Data.OuterXml);
            //historyData.Load(sr);
            //sr.Close();
            //sr = null;
        }

        public String ValidationErrors()
        {
            return "";
        }

        public Boolean Validate(XmlDocument msg, onTestProgress callback, String xpath, String msgName, bool enabled)
        {
            int level = 0;
            String validationMsgName;
            String location = xpath + validationXpath;

            XPathNodeIterator nodeIter = navdoc.Select(".//validation");

            while (nodeIter.MoveNext() & Continue)
            {
                level++;
                location = xpath + validationXpath + "[" + level + "]";
                validationMsgName = nodeIter.Current.GetAttribute("root-element-name", "");
                if (enabled == false)
                {
                    callback(location, testResultStatus.NA, "", "");
                }
                else if ((msgName != "") & (validationMsgName != "") & (msgName != validationMsgName))
                {
                    callback(location, testResultStatus.NA, "", "");
                }
                else if (ValidateRules(msg, callback, nodeIter.Current.SelectSingleNode("."), location))
                {
                    callback(location, testResultStatus.pass, "", "");
                }
                else
                {
                    callback(location, testResultStatus.fail, "error", "");
                }
            }

            nodeIter = null;

            return Continue;
        }


        private Boolean ValidateRules(XmlDocument msg, onTestProgress callback, XPathNavigator rule, String xpath)
        {

            XmlDocument message;
            Boolean status = true;
            int level = 0;
            String location = xpath + ruleXpath;
            String result;
            String expectedfile;
            String expectedResults;
            String filename;
            String validationType;
            Boolean continueOnFail = true;

            XPathNodeIterator nodeIter = rule.Select(".//rule");


            while (nodeIter.MoveNext())
            {
                level++;
                location = xpath + ruleXpath + "[" + level + "]";

                validationType = nodeIter.Current.GetAttribute("type", "");
                filename = nodeIter.Current.GetAttribute("filename", "");
                expectedfile = nodeIter.Current.GetAttribute("expectedfile", "");
                result = nodeIter.Current.GetAttribute("continueOnfail", "");
                if(result.Length > 0 & result == "false")
                { continueOnFail = false; }
                else
                { continueOnFail = true; }
                result = "";

                try
                {
                    //Thread.Sleep(10);
                    // copy the xml text from message to be used localy.
                    message = new XmlDocument();
                    StringReader sr = new StringReader(msg.OuterXml);
                    message.Load(sr);
                    sr.Close();
                    sr = null;
                    expectedResults = loadMessageFromFile(expectedfile);

                    if (validationType == "schematron")
                    {

                    }
                    else if (validationType == "schema")
                    {
                        try
                        {
                            //validate the workflow file using the schema file.
                            message.Schemas.Add(null, filename);
                            message.Validate(null);
                        }
                        catch (Exception ex) 
                        {
                            result = "<error description=\"Schema validation failed\">" +
                                     "<expected></expected>" +
                                     "<actual>" + ex.Message + "</actual>" +
                                     "</error>";
                        }
                        finally
                        {
                            message.Schemas = null;
                        }

                    }
                    else if (validationType == "transform")
                    {
                        result = TransformMessage(message, filename, nodeIter.Current);
                    }



                    if (compareMessages(result, expectedResults))
                    {
                        Continue = true;
                        callback(location, testResultStatus.pass, "", "");
                    }
                    else
                    {
                        status = false;
                        if (expectedResults.Trim().Length > 0)
                        {
                            result = "<compareResults><expected>" + expectedResults +
                                     "</expected><actual>" + result +
                                     "</actual></compareResults>";
                        }
                        callback(location, testResultStatus.fail, "error", result);
                    }
                }
                catch (Exception ex)
                {
                    status = false;
                    callback(location, testResultStatus.exception, "exception", ex.Message);
                }
                finally
                {
                    message = null;
                    expectedResults = "";
                    result = "";
                }
            }

            // if the test has failed and the continueOnFail flag is false,
            // tell the validator to return false.

            if (status == false & continueOnFail == false)
            { Continue = false; }

            nodeIter = null;

            return status;
        }

        private String TransformMessage(XmlDocument message, String xslFileName, XPathNavigator parameters)
        {
            //XslTransform transformer;
            XslCompiledTransform transformer = new XslCompiledTransform(false);
            XsltArgumentList arg = new XsltArgumentList();
            XsltSettings settings = new XsltSettings(true, true);
            //XPathNodeIterator paramList = parameters.Select("descendant-or-self::param");
            XPathNodeIterator paramList = parameters.Select("ancestor-or-self::node()/paramList/param");
            
            XmlUrlResolver resolver = new XmlUrlResolver();
            String paramName;
            String paramValue;
            // Create the XsltSettings object with script enabled.

            StringBuilder sbuilder = new StringBuilder();
            TextWriter writer = new StringWriter(sbuilder);

            try
            {
                transformer.Load(xslFileName, settings, resolver);

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
                transformer.Transform(message, arg, writer);

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
                resolver = null;
                transformer = null;
                settings = null;
                paramList = null;
                if(writer != null)
                    writer.Close();
                writer = null;
            }

            return (sbuilder.ToString());
        }

        private String loadMessageFromFile(String filename)
        {
            FileStream file;
            StreamReader fileReader;
            String contents;

            try
            {
                file = new FileStream(filename, FileMode.Open, FileAccess.Read);
                fileReader = new StreamReader(file);
                contents = fileReader.ReadToEnd();
                file.Close();
                file = null;
            }
            catch
            {
                throw;
            }
            finally
            {
                fileReader = null;
            }

            return contents;
        }

        private Boolean compareMessages(String srcData, String expectedResults)
        {
            int result;

            result = String.Compare(srcData.Replace(" ", ""), expectedResults.Replace(" ", ""), false, CultureInfo.InvariantCulture);

            return (result == 0);
        }


    }
}
