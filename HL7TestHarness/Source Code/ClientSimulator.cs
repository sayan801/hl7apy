/* Module Header

  $Header:   L:/pvcsrep65/HL7TestHarness/archives/Source Code/ClientSimulator.cs-arc   1.33   24 Jul 2007 15:17:50   mwicks  $

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

  $Log:   L:/pvcsrep65/HL7TestHarness/archives/Source Code/ClientSimulator.cs-arc  $
 *
 *   Rev 1.33   24 Jul 2007 15:17:50   mwicks
 *updated to include http compression options
 *
 *   Rev 1.32   19 Jul 2007 15:44:56   mwicks
 *Updated 
 *change tcp handling
 *removed thread sleeps
 *added attribute to disable client sim by message.
 *
 *   Rev 1.31   26 Mar 2007 13:29:50   mwicks
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
 *   Rev 1.30   16 Mar 2007 15:46:00   mwicks
 *updated for the following:
 *1. msg proxy and client sim will replace localhost address names with machine name.
 *2. msg proxy outputs timing and number of messages sent.
 *3. commandline has auto control file.
 *4. GUI msg proxy now shows msgs from client and server systems.
 *5. GUI enable/disable redone to be more clear.
 *6. Results data grid columns re-sizeable
 *7. commandline will now handle all development options that GUI uses.
 *
 *   Rev 1.29   18 Jan 2007 14:20:14   mwicks
 *updated reporting and workflow schemas.
  Revision 1.1.1.1  2006/11/24 18:16:40  deltaware
  Init check in of HL7 Test Harness, version 2.0.3.9. For releases before this version please contact deltaware systems.

 *
 *   Rev 1.28   10 Nov 2006 09:26:40   mwicks
 *updated construction vars so that all simulators can access vars set by other simulators.
 *
 *   Rev 1.27   08 Nov 2006 15:21:02   mwicks
 *updated 
 *report - to place errors with messaging
 *testdata - all threads now use same testdata document
 *xsd - testdata and workflow xsd have been updated.
 *
 *   Rev 1.26   28 Sep 2006 10:28:44   mwicks
 *updated to allow workflows to use put and set var's.
 *
 *   Rev 1.25   11 Sep 2006 16:10:22   mwicks
 *updated tcp monitoring to monitor the dns HostName instead of the localhost name.
 *
 *   Rev 1.24   05 Sep 2006 13:17:56   mwicks
 *Updated to reduce memory usage
 *
 *   Rev 1.23   31 Aug 2006 21:04:38   mwicks
 *reduced memory usage
 *
 *   Rev 1.22   31 Aug 2006 11:48:44   mwicks
 *updated to remove memory leaks
 *
 *   Rev 1.21   29 Aug 2006 14:46:36   mwicks
 *Updated to fix some memory issues.
 *
 *   Rev 1.20   15 Aug 2006 16:16:56   mwicks
 *Updated to load xmlfile using streams.
 *updated to include parameters in construction transforms
 *updated workflows to allow paramlists.
 *
 *   Rev 1.19   03 Aug 2006 15:04:16   mwicks
 *Changed xml loading processes to always load from a stream.
 *xmldoc.loadxml(string) 
 *changed to 
 *xsldoc.load(new StringStream(string))
 *
 *
 *   Rev 1.18   29 Jun 2006 10:48:16   mwicks
 *updated status messages for console
 *
 *   Rev 1.17   28 Jun 2006 16:24:20   mwicks
 *removed "All Rights Reserved." from all files.
 *
 *   Rev 1.16   26 Jun 2006 13:29:24   mwicks
 *added Lic
 *
 *   Rev 1.15   26 Jun 2006 13:18:22   mwicks
 *Updated License.
 *
 *   Rev 1.14   23 Jun 2006 09:11:46   mwicks
 *updated comments
 *
 *   Rev 1.13   19 Jun 2006 14:38:42   mwicks
 *Updated to allow for direct file compares.
 *Updated to pass the message direction to xsl during construction and validation.
 *
 *   Rev 1.12   26 May 2006 15:19:26   mwicks
 *update file headers to include PVCS tags
 *updated config file to use bool instead of strings.
 *
 *   Rev 1.11   24 May 2006 10:33:40   mwicks
 *updated to allow system to be used as a true proxy
 *
 *   Rev 1.10   05 May 2006 09:51:08   mwicks
 *Updated message validation and construction to accept the TestData as a parameter.
 *
 *   Rev 1.9   04 May 2006 13:59:42   mwicks
 *Updated WorkFlow diagram tab
 *
 *   Rev 1.8   27 Apr 2006 14:40:14   mwicks
 *Added Server user and password fields
 *
 *   Rev 1.7   07 Apr 2006 09:33:24   mwicks
 *Updated to run multiple workflows
 *
 *   Rev 1.6   28 Mar 2006 15:57:38   mwicks
 *Update for error handling
 *
 *   Rev 1.5   28 Mar 2006 15:01:38   mwicks
 *Updated to enable Stopping and Starting the Simulators and Proxy.
 *
 *   Rev 1.4   24 Mar 2006 15:02:44   mwicks
 *Updated test status updating process
 *
 *   Rev 1.3   24 Mar 2006 10:21:00   mwicks
 *Combined event handlers into a single base clase
 *
 *   Rev 1.2   21 Mar 2006 13:24:00   mwicks
 *Multi message update
 *
 *   Rev 1.1   17 Mar 2006 15:46:28   mwicks
 *Updated $Header
*/
using System;
using System.IO;
using System.IO.Compression;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Xml.XPath;
using System.Net;
using System.Threading;
using System.Collections.Specialized;
using System.ComponentModel;


namespace HL7TestHarness
{

    /// <summary>
    /// Simulates a client system by acting as a xml file provider. 
    /// Files as sent to a web server as per the message flow
    /// </summary>


    class ClientSimulator : Simulator
    {
        private class requestItem
        {
            public String xpath;
            public XmlDocument message;
            public String address;

            public requestItem(String Xpath, XmlDocument Message, String Address)
            {
                message = new XmlDocument();
                xpath = Xpath;
                message.LoadXml(Message.OuterXml);
                address = Address;
            }
            ~requestItem()
            {
                xpath = null;
                message = null;
                address = null;
            }

        }

        /// <summary>
        /// messages sent back to delegate functions to indicate status changes
        /// </summary>
        private const String TxRequestMsg = "TX request message Sent, Waiting for RX";
        private const String RxSuccess = "TX/RX success";
        private const String RxFailed = "TX/RX error";


        private delegate void WorkerEventHandler(AsyncOperation asyncOp);

        private WorkerEventHandler workerDelegate;

        public enum simulatorStatus { running, paused, stopped, error };

        private XmlDocument MessageFlowData = new XmlDocument();
        private XmlDocument stagedTestData;
        private XmlDocument historyData;
        private XPathNavigator msgNav;
        private XPathNodeIterator msgInterator;
        private const String workflowXpath = "//workflow";
        private const String messageXpath = "/message";
        private const String simulatorXpath = "/request/Simulator";
        private simulatorStatus state;
        private MessageConstructor msgConstructor;
        private MsgTimer msgTime = new MsgTimer();
        
        

        private XmlDocument RxMessage = new XmlDocument();

        public int requestThreads = 1;

        public ClientSimulator()
        {
            msgConstructor = new MessageConstructor();
        }
        public ClientSimulator(List<MessageConstructor.variable> Variables)
        {
            msgConstructor = new MessageConstructor(Variables);
        }

        ~ClientSimulator()
        {
            stagedTestData = null;
            msgNav = null;
            msgInterator = null;
            RxMessage = null;
            workerDelegate = null;
            msgConstructor = null;
        }

        /// <summary>
        /// Interface to load the message flow xml document.
        /// The client simulator looks for data held with in the 
        /// request/simulator tags.
        /// </summary>
        /// <param name="msg">message flow xml document</param>
        public void setMessageFlow(XmlDocument msg)
        {
            MessageFlowData.Load( new StringReader(msg.OuterXml));
            msgNav = MessageFlowData.CreateNavigator();
        }

        public void setStagedData(XmlDocument data)
        {
            stagedTestData = data;
        }
        public void setHistoryData(XmlDocument data)
        {
            historyData = data;
        }


        /// <summary>
        /// Start simulator.
        /// Simulator runs on it own thread and communicates with the calling object via
        /// delegate functions.
        /// </summary>
        public void Start()
        {
            reportProgressChange("Starting...");

            // Create an AsyncOperation for taskId.
            AsyncOperation asyncOp =
                AsyncOperationManager.CreateOperation(null);
                
            // Start the asynchronous operation.
            workerDelegate = new WorkerEventHandler(run);
            workerDelegate.BeginInvoke(asyncOp,null,null);

        }


        /// <summary>
        /// Async opertion that runs the simulator process.
        /// </summary>
        private void run(AsyncOperation asyncOp)
        {
            int xpathLocation = 0;
            int msgCount = 0;
            int msgSent = 0;
            XmlDocument message;
            //MessageConstructor msgConstructor;
            String xpath;
            String workflow;
            List<requestItem> requestList = new List<requestItem>();
            

            setAsyncOperation(asyncOp);

            reportProgressChange("Started");
            msgNav.MoveToRoot();

            //msgConstructor = new MessageConstructor();
            // tell the constructor what staged data to use when creating messages.
            msgConstructor.setStagedData(stagedTestData);
            msgConstructor.setHistoryData(historyData);

            msgConstructor.IsServerRequest = true;

            // get the first workflow from the workflow xml document.
            msgInterator = msgNav.Select("//workflow");
            msgCount = msgNav.Select("//request[(not(@simulator))or(@simulator='true')]/Simulator").Count;
            while (msgInterator.MoveNext() & state != simulatorStatus.stopped & Switch.STOP == false)
            {
                // the following sections move throw the workflow xml document looking
                // for all message/request/simulator nodes, once found the data in these nodes
                // tells the simulator what messages to send and to what server.
                if (msgInterator.Current.HasChildren == true)
                {
                    workflow = workflowXpath + "[" + msgInterator.CurrentPosition + "]";
                    msgInterator.Current.MoveToFirstChild();
                    xpathLocation = 0;

                    do
                    {
                        if (msgInterator.Current.LocalName.ToLower() == "message")
                        {
                            xpathLocation++;

                            xpath = workflow + messageXpath + "[" + xpathLocation + "]" + simulatorXpath;

                            // move to the request node.
                            if(msgInterator.Current.MoveToChild("request",""))
                            {
                                if (msgInterator.Current.GetAttribute("simulator", "") != "false")
                                {
                                    // move to the Simulator node.
                                    if (msgInterator.Current.MoveToChild("Simulator", ""))
                                    {
                                        // state == run|stop|pause
                                        // if state == pause system will sit in this loop but
                                        //  will never enter the if statement to run the tests.
                                        if (state == simulatorStatus.running)
                                        {
                                            try
                                            {

                                                message = new XmlDocument();

                                                // Load the message constructor rules
                                                msgConstructor.setRule(msgInterator.Current.SelectSingleNode("."));
                                                // constuct the message to be sent out.
                                                message = msgConstructor.Construct(message);

                                                reportTestProgress(xpath, testResultStatus.processing, "TxMessage", message.DocumentElement.OuterXml);

                                                // Send the message and wait for reply
                                                String address = msgInterator.Current.GetAttribute("RemoteServerAddr", "");
                                                address = address.Replace("localhost", Dns.GetHostName());

                                                reportProgressChange(message.InnerXml);

                                                if (requestThreads <= 1)
                                                {
                                                    msgTime.start();
                                                    if (SendReceiveMessage(message, address) == false)
                                                    {
                                                        msgTime.stop();
                                                        reportProgressChange(RxFailed);
                                                        reportProgressChange("Message Time [Last:" + msgTime.Last() + "ms Avg:" + msgTime.Average() + "ms Total:" + msgTime.Total() + "ms Count:" + msgTime.Count() + "/" + msgCount.ToString() + "]");
                                                        reportTestProgress(xpath, testResultStatus.fail, "", "");
                                                        //state = simulatorStatus.error;
                                                    }
                                                    else
                                                    {
                                                        msgTime.stop();
                                                        reportProgressChange(RxSuccess);
                                                        reportProgressChange("Message Time [Last:" + msgTime.Last() + "ms Avg:" + msgTime.Average() + "ms Total:" + msgTime.Total() + "ms Count:" + msgTime.Count() + "/" + msgCount.ToString() + "]");
                                                        reportTestProgress(xpath, testResultStatus.pass, "", "");
                                                    }
                                                    reportTestProgress(xpath, testResultStatus.processing, "RxMessage", RxMessage.DocumentElement.OuterXml);
                                                }
                                                else
                                                {
                                                    requestList.Add(new requestItem(xpath, message, address));
                                                    reportProgressChange("Request List [(" + requestList.Count.ToString() + "+" + msgTime.count() + ")/" + msgCount.ToString() + "]");

                                                    if ((requestList.Count >= requestThreads)
                                                         |
                                                        (msgCount <= (requestList.Count + msgTime.count())))
                                                    {
                                                        reportProgressChange("Message[(" + requestList.Count.ToString() + "+" + msgTime.count() + ")/" + msgCount.ToString() + "]");
                                                        msgSent = 0;
                                                        while (msgSent < requestList.Count)
                                                        {
                                                            msgTime.start();
                                                            try
                                                            {
                                                                reportProgressChange("Sending Request");
                                                                if (SendReceiveMessage(requestList[msgSent].message, requestList[msgSent].address) == false)
                                                                {
                                                                    msgTime.stop();
                                                                    reportProgressChange(RxFailed);
                                                                    reportProgressChange("Message Time [Last:" + msgTime.Last() + "ms Avg:" + msgTime.Average() + "ms Total:" + msgTime.Total() + "ms Count:" + msgTime.Count() + "/" + msgCount.ToString() + "]");
                                                                    reportTestProgress(requestList[msgSent].xpath, testResultStatus.fail, "", "");
                                                                    //state = simulatorStatus.error;
                                                                }
                                                                else
                                                                {
                                                                    msgTime.stop();
                                                                    reportProgressChange(RxSuccess);
                                                                    reportProgressChange("Message Time [Last:" + msgTime.Last() + "ms Avg:" + msgTime.Average() + "ms Total:" + msgTime.Total() + "ms Count:" + msgTime.Count() + "/" + msgCount.ToString() + "]");
                                                                    reportTestProgress(requestList[msgSent].xpath, testResultStatus.pass, "", "");
                                                                }
                                                            }
                                                            catch (Exception ex)
                                                            {
                                                                msgTime.stop();
                                                                reportProgressChange(ex.Message);
                                                            }
                                                            //requestList[msgSent] = null;
                                                            reportTestProgress(requestList[msgSent].xpath, testResultStatus.processing, "RxMessage", RxMessage.DocumentElement.OuterXml);
                                                            msgSent++;
                                                        }
                                                        requestList.Clear();
                                                        //requestList = null;
                                                        //requestList = new List<requestItem>();
                                                    }
                                                }
                                            }
                                            catch (Exception ex)
                                            {
                                                reportTestProgress(xpath, testResultStatus.exception, "exception", ex.Message);
                                            }
                                            finally
                                            {
                                                message = null;
                                            }
                                            // give everyone time to process.
                                            Thread.Sleep(50);
                                        }
                                        msgInterator.Current.MoveToParent();
                                    }
                                }
                                msgInterator.Current.MoveToParent();
                            }
                        }
                    }
                    while (msgInterator.Current.MoveToNext() & state != simulatorStatus.stopped & Switch.STOP == false);


                    msgInterator.Current.MoveToParent();
                }
            }

            msgConstructor = null;

            // give everyone time to finish.
            Thread.Sleep(1000);
            reportProgressChange("Message Processing Done");
            reportComplete();
            //TODO: Check if we need to do this.
            Thread.CurrentThread.Abort();

        }


        public simulatorStatus getStatus()
        {
            return state;
        }

        public void Stop()
        {
            state = simulatorStatus.stopped;
        }


        /// <summary>
        /// Sends the xml file to the server address and receives the response from
        /// the server.
        /// </summary>
        /// <param name="ServerAddr">web address of server to send request too</param>
        /// <returns>success = true, failure = false</returns>
        private Boolean SendReceiveMessage(XmlDocument TxMsg, String ServerAddr)
        {
            Boolean success = true;
            HttpWebRequest req = null;
            HttpWebResponse rsp = null;

            try
            {

                req = (HttpWebRequest)WebRequest.Create(ServerAddr);
                req.Method = "POST";        // Post method
                req.ContentType = "text/xml";     // content type
                req.Timeout = 200000;
                req.KeepAlive = false;
                req.AutomaticDecompression = DecompressionMethods.None;

                if (compressionEnabled == true)
                {
                    //req.AutomaticDecompression = DecompressionMethods.GZip;
                    req.Headers.Add("Content-Encoding", "gzip");
                    //req.ContentType = "GZip";
                    req.Headers.Add("Accept-Encoding", "gzip");
                    //MemoryStream ms = new MemoryStream();
                    StreamWriter writer = new StreamWriter(req.GetRequestStream());
                    GZipStream zip = new GZipStream(writer.BaseStream, CompressionMode.Compress, true);
                    //StreamWriter writer = new StreamWriter(zip);
                    // Write the xml text into the stream
                    TxMsg.Save(zip);
                    //ms.WriteTo(req.GetRequestStream());
                    //ms.Close();
                    zip.Close();
                    writer.Close();
                }
                else
                {
                    // Wrap the request stream with a text-based writer
                    StreamWriter writer = new StreamWriter(req.GetRequestStream());
                    // Write the xml text into the stream
                    TxMsg.Save(writer);
                    writer.Close();
                }

                // Send the data to the webserver
                rsp = (HttpWebResponse)req.GetResponse();

                Stream responseStream = rsp.GetResponseStream();

                if (rsp.ContentEncoding.ToLower().Contains("gzip"))
                {
                    //GZipStream zip = new GZipStream(responseStream, CompressionMode.Decompress, true);
                    //StreamReader sr = new StreamReader(zip);
                    //string text = sr.ReadToEnd();
                    responseStream = new GZipStream(responseStream, CompressionMode.Decompress, true);
                }
                else if (rsp.ContentEncoding.ToLower().Contains("deflate"))
                {
                    responseStream = new DeflateStream(responseStream, CompressionMode.Decompress, true);
                }
                RxMessage.Load(responseStream);
                //RxMessage.Load(rsp.GetResponseStream());
            }
            catch (WebException webEx)
            {
                success = false;
                RxMessage.LoadXml("<error>"+ webEx.ToString() +"</error>");
                //LastMessage = webEx.ToString();
            }
            catch (Exception ex)
            {
                success = false;
                RxMessage.LoadXml("<error>" + ex.ToString() + "</error>");
                //LastMessage = ex.ToString();
            }
            finally
            {
                if (rsp != null)
                {
                    rsp.GetResponseStream().Close();
                    rsp.Close();
                    rsp = null;
                }
                if (req != null)
                {
                    req.GetRequestStream().Close();
                    req.Abort();
                    req = null;
                }
                
            }
            return success;

        }
    }
}
