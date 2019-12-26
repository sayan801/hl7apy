/* Module Header

  $Header:   L:/pvcsrep65/HL7TestHarness/archives/Source Code/ServerSimulator.cs-arc   1.39   24 Jul 2007 15:17:52   mwicks  $

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

  $Log:   L:/pvcsrep65/HL7TestHarness/archives/Source Code/ServerSimulator.cs-arc  $
 *
 *   Rev 1.39   24 Jul 2007 15:17:52   mwicks
 *updated to include http compression options
 *
 *   Rev 1.38   19 Jul 2007 15:45:00   mwicks
 *Updated 
 *change tcp handling
 *removed thread sleeps
 *added attribute to disable client sim by message.
 *
 *   Rev 1.37   18 Jan 2007 14:20:24   mwicks
 *updated reporting and workflow schemas.
  Revision 1.1.1.1  2006/11/24 18:16:45  deltaware
  Init check in of HL7 Test Harness, version 2.0.3.9. For releases before this version please contact deltaware systems.

 *
 *   Rev 1.36   10 Nov 2006 09:26:44   mwicks
 *updated construction vars so that all simulators can access vars set by other simulators.
 *
 *   Rev 1.35   06 Nov 2006 11:48:56   mwicks
 *Added Test Data file updating
 *
 *   Rev 1.34   06 Oct 2006 08:13:38   mwicks
 *updated to fix a bug in the process message groups, optional messages and non-seq messages.
 *
 *   Rev 1.33   28 Sep 2006 10:28:48   mwicks
 *updated to allow workflows to use put and set var's.
 *
 *   Rev 1.32   15 Sep 2006 10:27:54   mwicks
 *Updated display of messages in UI
 *
 *   Rev 1.30   06 Sep 2006 16:07:42   mwicks
 *Updated xpath values to get hl7 namespace root element name with multiple other namespaces defined.
 *
 *   Rev 1.29   06 Sep 2006 10:40:18   mwicks
 *updated to allow soap wrappers to be used.
 *
 *   Rev 1.28   05 Sep 2006 13:18:00   mwicks
 *Updated to reduce memory usage
 *
 *   Rev 1.27   31 Aug 2006 21:04:40   mwicks
 *reduced memory usage
 *
 *   Rev 1.26   31 Aug 2006 11:48:46   mwicks
 *updated to remove memory leaks
 *
 *   Rev 1.25   29 Aug 2006 14:46:38   mwicks
 *Updated to fix some memory issues.
 *
 *   Rev 1.24   15 Aug 2006 16:16:58   mwicks
 *Updated to load xmlfile using streams.
 *updated to include parameters in construction transforms
 *updated workflows to allow paramlists.
 *
 *   Rev 1.23   03 Aug 2006 15:04:18   mwicks
 *Changed xml loading processes to always load from a stream.
 *xmldoc.loadxml(string) 
 *changed to 
 *xsldoc.load(new StringStream(string))
 *
 *
 *   Rev 1.22   02 Aug 2006 15:57:08   mwicks
 *Updated test harness to handle the following:
 *optional messages
 *non-sequential groups
 *globally non-sequential messages
 *
 *   Rev 1.21   29 Jun 2006 10:48:18   mwicks
 *updated status messages for console
 *
 *   Rev 1.20   28 Jun 2006 16:24:30   mwicks
 *removed "All Rights Reserved." from all files.
 *
 *   Rev 1.19   26 Jun 2006 13:29:26   mwicks
 *added Lic
 *
 *   Rev 1.18   26 Jun 2006 13:18:24   mwicks
 *Updated License.
 *
 *   Rev 1.17   23 Jun 2006 09:11:48   mwicks
 *updated comments
 *
 *   Rev 1.16   19 Jun 2006 14:38:44   mwicks
 *Updated to allow for direct file compares.
 *Updated to pass the message direction to xsl during construction and validation.
 *
 *   Rev 1.15   31 May 2006 10:03:38   mwicks
 *Updated to include a console interface
 *
 *   Rev 1.14   24 May 2006 10:33:38   mwicks
 *updated to allow system to be used as a true proxy
 *
 *   Rev 1.13   15 May 2006 13:32:30   mwicks
 *Updated to close msg socket and to include Single Message Loop selection.
 *
 *   Rev 1.12   05 May 2006 09:51:08   mwicks
 *Updated message validation and construction to accept the TestData as a parameter.
 *
 *   Rev 1.11   04 May 2006 13:59:40   mwicks
 *Updated WorkFlow diagram tab
 *
 *   Rev 1.10   27 Apr 2006 14:40:14   mwicks
 *Added Server user and password fields
 *
 *   Rev 1.9   07 Apr 2006 09:33:24   mwicks
 *Updated to run multiple workflows
 *
 *   Rev 1.8   28 Mar 2006 15:57:38   mwicks
 *Update for error handling
 *
 *   Rev 1.7   28 Mar 2006 15:01:36   mwicks
 *Updated to enable Stopping and Starting the Simulators and Proxy.
 *
 *   Rev 1.6   24 Mar 2006 15:02:44   mwicks
 *Updated test status updating process
 *
 *   Rev 1.5   24 Mar 2006 10:20:56   mwicks
 *Combined event handlers into a single base clase
 *
 *   Rev 1.4   23 Mar 2006 11:53:22   mwicks
 *Added 
 *Http Report function
 *Global start process
 *
 *   Rev 1.3   22 Mar 2006 11:29:52   mwicks
 *Updated Http get reqest in message proxy and server to parse request correctly.
 *
 *   Rev 1.2   21 Mar 2006 13:24:00   mwicks
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
using System.Net;
using System.Net.Sockets;
using System.Threading;
using System.Collections.Specialized;
using System.ComponentModel;
using System.IO.Compression;


namespace HL7TestHarness
{
    class ServerSimulator : Simulator
    {
        public enum simulatorStatus { running, paused, stopped, error };

        private TcpListener Listener;
        private XmlDocument MessageFlowData = new XmlDocument();
        private XmlDocument stagedTestData;
        private XmlDocument historyData;
        private XPathNavigator msgNav;
        private const String messageXpath = "//message";
        private const String simulatorXpath = "/response/Simulator";
        private simulatorStatus state;
        //private List<String> xpathList = new List<String>();
        private String sHttpVersion;
        MessageConstructor msgConstructor;
        public static ManualResetEvent clientConnected = new ManualResetEvent(false);

        private messageList xpathList = new messageList();

        private const String WaitingForRX = "Waiting for Request";
        private const String RequestMsg = "Request message Received";
        private const String ConstructMsg = "Constucting Response Message";
        private const String ResponseMsg = "Sending Response Message";

        private delegate void WorkerEventHandler(AsyncOperation asyncOp);

        private WorkerEventHandler workerDelegate;
        StringDictionary HeaderFields = new StringDictionary();

        public ServerSimulator()
        {
            msgConstructor = new MessageConstructor();
        }
        public ServerSimulator(List<MessageConstructor.variable> Variables)
        {
            msgConstructor = new MessageConstructor(Variables);
        }

        ~ServerSimulator()
        {
           // if (MessageFlowData != null)
           //     MessageFlowData.RemoveAll();
           // if (stagedTestData != null)
           //     stagedTestData.RemoveAll();

            xpathList = null;
            Listener = null;
            MessageFlowData = null;
            stagedTestData = null;
            msgNav = null;
            workerDelegate = null;
            sHttpVersion = null;
        }


        public void setMessageFlow(XmlDocument msg)
        {
            MessageFlowData.Load( new StringReader(msg.OuterXml));
        }

        public void setStagedData(XmlDocument data)
        {
            stagedTestData = data;
        }
        public void setHistoryData(XmlDocument data)
        {
            historyData = data;
        }


        public simulatorStatus getStatus()
        {
            return state;
        }

        public void Stop()
        {
            state = simulatorStatus.stopped;
            clearConnection();
        }

        public void Start(int port)
        {
            try
            {
                reportProgressChange("Starting...");

                msgConstructor.setStagedData(stagedTestData);
                msgConstructor.setHistoryData(historyData);
                msgConstructor.IsServerRequest = false;

                //start listing on the given port
                //IPAddress ipAddress = Dns.Resolve("localhost").AddressList[0];
                IPAddress ipAddress = Dns.GetHostEntry(Dns.GetHostName()).AddressList[0];

                Listener = new TcpListener(ipAddress,port);
                Listener.Start();
                
                // Create an AsyncOperation for taskId.
                AsyncOperation asyncOp =
                    AsyncOperationManager.CreateOperation(null);
                setAsyncOperation(asyncOp);

                // Start the asynchronous operation.
                workerDelegate = new WorkerEventHandler(run);
                workerDelegate.BeginInvoke(asyncOp, null, null);

                //start the thread which calls the method 'StartListen'
                //Thread th = new Thread(new ThreadStart(run));
                //th.Start();
            }
            catch (Exception ex)
            {
                state = simulatorStatus.error;
                stopProcess("Stopped (" + ex.Message + ")");
            }
        }

        private void stopProcess(String StatusMsg)
        {
            Listener.Stop();
            reportProgressChange(StatusMsg);
        }

        private void createXpathList()
        {
            String xpath;
            String group;
            String msgName;
            Boolean optional;
            Boolean nonsequential;
            Boolean repeatable;

            int workflowCount = 0;
            int messageCount = 0;
            XPathNodeIterator msgInterator = msgNav.Select("//workflow");
            // TODO: check if we have any expected requests.

            xpathList.clear();

            while (msgInterator.MoveNext())
            {
                workflowCount++;
                messageCount = 0;
                if (msgInterator.Current.MoveToChild("message", ""))
                {
                    do
                    {
                        messageCount++;
                        xpath = "//workflow[" + workflowCount + "]/message[" + messageCount + "]";
                        group = msgInterator.Current.GetAttribute("group-non-sequential", "");
                        msgName = msgInterator.Current.GetAttribute("root-element-name", "");
                        optional = (msgInterator.Current.GetAttribute("optional", "") == "true");
                        nonsequential = (msgInterator.Current.GetAttribute("globally-non-sequential", "") == "true");
                        repeatable = (msgInterator.Current.GetAttribute("repeatable", "") == "true");

                        xpathList.add(xpath, group, msgName, optional, nonsequential, repeatable);

                        //xpathList.Add("//workflow[" + workflowCount + "]/message[" + messageCount + "]");

                    } while (msgInterator.Current.MoveToNext("message", ""));
                }

            }

        }


        /// <summary>
        /// processMessage finds the message to respond to a request.
        /// </summary>
        /// <param name="RxMsg">received message to be responed too.</param>
        /// <param name="asyncOp">logging object referance</param>
        /// <returns></returns>
        private Byte[] processMessage(Byte[] RxMsg)
        {
            XmlDocument TxMessage = new XmlDocument();
            XmlDocument RxMessage = new XmlDocument();
            
            XPathNodeIterator msgInterator;
            String msgName;
            int xpathIndex;

            try
            {
                //String Buffer = Encoding.ASCII.GetString(RxMsg);
                RxMessage.Load(new MemoryStream(RxMsg));



                XmlNamespaceManager nsmg = new XmlNamespaceManager(RxMessage.NameTable);
                nsmg.AddNamespace("hl7", "urn:hl7-org:v3");
                try
                {
                    msgName = RxMessage.SelectSingleNode("descendant-or-self::hl7:*[1]", nsmg).LocalName;
                }
                catch { msgName = ""; }
//                msgName = RxMessage.DocumentElement.LocalName;
//                if (msgName == "Envelope")
//                {
//                    msgName = RxMessage.DocumentElement.FirstChild.FirstChild.LocalName;
//                }


                xpathIndex = xpathList.getIndex(msgName);

                if (xpathIndex >= 0)
                {
                    //String xpath = messageXpath + "[" + (xpathLocation + 1) + "]" + simulatorXpath;
                    String xpath = xpathList.getXpath(xpathIndex) + simulatorXpath;
                    try
                    {
                        // load the current location.
                        msgInterator = msgNav.Select(xpath);

                        if (msgInterator.MoveNext())
                        {
                            reportTestProgress(xpath, testResultStatus.processing, "RxMessage", RxMessage.DocumentElement.OuterXml);

                            msgConstructor.IsServerRequest = false;

                            msgConstructor.setRule(msgInterator.Current.SelectSingleNode("."));
                            // constuct the message to be sent out.
                            reportProgressChange(ConstructMsg);

                            TxMessage = msgConstructor.Construct(RxMessage);

                            reportTestProgress(xpath, testResultStatus.pass, "TxMessage", TxMessage.DocumentElement.OuterXml);

                            if (Switch.MoveToNextTest == true)
                            {
                                xpathList.processed(xpathIndex);
                                //xpathLocation++;
                            }
                        }
                        else
                        {
                            //no response message configured
                            TxMessage.LoadXml("<error>Response message not configured</error>");
                            reportTestProgress(xpath, testResultStatus.fail, "error", "<error>Response message not configured</error>");
                        }
                    }
                    catch (Exception ex)
                    {
                        //request cuased exception
                        TxMessage.LoadXml("<error>" + ex.Message + "</error>");

                        reportTestProgress(xpath, testResultStatus.exception, "exception", ex.Message);
                    }
                    finally
                    {
                        msgInterator = null;
                    }
                }
                else
                {
                    //no response message configured
                    TxMessage.LoadXml("<error>Response message not found</error>");
                }
            }
            catch (Exception ex)
            {
                //request cuased exception
                TxMessage.LoadXml("<error>" + ex.Message + "</error>");
            }

            MemoryStream ms = new MemoryStream();
            StreamWriter sw = new StreamWriter(ms);
            TxMessage.Save(sw);

            TxMessage = null;
            RxMessage = null;
            sw.Close();
            sw = null;

            byte[] sBuffer = ms.ToArray();
            ms.Close();
            ms = null;

            return sBuffer;
        }



        private void run(AsyncOperation asyncOp)
        {
            try
            {
                state = simulatorStatus.running;
                msgNav = MessageFlowData.CreateNavigator();
                msgNav.MoveToRoot();
                createXpathList();

                setAsyncOperation(asyncOp);

                // start the Listener
                StartListen();
            }
            catch (Exception ex)
            {
                state = simulatorStatus.error;
                stopProcess("Stopped (" + ex.Message + ")");
            }

        }


        public void StartListen()
        {
            reportProgressChange("Started");

            reportProgressChange(WaitingForRX);

            while (state != simulatorStatus.stopped & Switch.STOP == false)
            {

                if (state == simulatorStatus.running)
                {
                    // Set the event to nonsignaled state.
                    clientConnected.Reset();

                    reportProgressChange(WaitingForRX);
                    // Accept the connection. 
                    // BeginAcceptSocket() creates the accepted socket.
                    Listener.BeginAcceptSocket(
                        new AsyncCallback(DoAcceptSocketCallback), Listener);
                    // Wait until a connection is made and processed before 
                    // continuing.
                    clientConnected.WaitOne();
                }

            }

            stopProcess("Stopped");
        }

        public void DoAcceptSocketCallback(IAsyncResult ar)
        {
            byte[] RxBuffer;
            byte[] TxBuffer;
            string encodeValue;

            if (state == simulatorStatus.running)
            {
                // Get the listener that handles the client request.
                //TcpListener listener = (TcpListener)ar.AsyncState;

                // End the operation and display the received data on the
                //console.
                Socket clientSocket = Listener.EndAcceptSocket(ar);

                if (clientSocket != null)
                {
                    if (clientSocket.Connected)
                    {
                        reportProgressChange(RequestMsg);
                        RxBuffer = ReceiveMessage(clientSocket);

                        // create the response to this message.
                        TxBuffer = processMessage(RxBuffer);

                        RxBuffer = null;
                        if (clientSocket.Connected == true)
                        {
                            String sMimeType = "text/xml";

                            StreamWriter sw;
                            MemoryStream ms = new MemoryStream();
                            if (HeaderFields.ContainsKey("Accept-Encoding"))
                            {
                                if (HeaderFields["Accept-Encoding"].ToLower().Contains("deflate"))
                                {
                                    DeflateStream def = new DeflateStream(ms, CompressionMode.Compress, true);
                                    sw = new StreamWriter(def);
                                    sw.BaseStream.Write(TxBuffer, 0, TxBuffer.Length);
                                    sw.Close();
                                    encodeValue = "deflate";
                                }
                                else if (HeaderFields["Accept-Encoding"].ToLower().Contains("gzip"))
                                {
                                    GZipStream zip = new GZipStream(ms, CompressionMode.Compress, true);
                                    sw = new StreamWriter(zip);
                                    sw.BaseStream.Write(TxBuffer, 0, TxBuffer.Length);
                                    sw.Close();
                                    encodeValue = "gzip";
                                }
                                else
                                {
                                    
                                    sw = new StreamWriter(ms);
                                    sw.BaseStream.Write(TxBuffer, 0, TxBuffer.Length);
                                    encodeValue = "";
                                }
                            }
                            else
                            {
                                sw = new StreamWriter(ms);
                                sw.BaseStream.Write(TxBuffer, 0, TxBuffer.Length);
                                encodeValue = "";
                            }
                            ms.Position = 0;
                            
                            byte[] sBuffer = ms.ToArray();
                            sw.Close();
                            ms.Close();

                            int iTotBytes = sBuffer.Length;

                            reportProgressChange(ResponseMsg);

                            SendHeader(sHttpVersion, sMimeType, encodeValue, iTotBytes, " 200 OK", ref clientSocket);

                            SendToBrowser(sBuffer, ref clientSocket);
                        }

                        reportProgressChange(WaitingForRX);
                    }
                    if(clientSocket != null)
                        clientSocket.Close();
                    clientSocket = null;
                    TxBuffer = null;
                    RxBuffer = null;
                    clearConnection();
                }
            }
        }
        private void clearConnection()
        {
            clientConnected.Set();
        }

        //This method Accepts new connection
        /* OLD Http code.
        private void StartListen()
        {
            Byte[] RxBuffer;
            Byte[] TxBuffer;

            reportProgressChange("Started");

            reportProgressChange(WaitingForRX);

            while (state != simulatorStatus.stopped & Switch.STOP == false)
            {
                if (Listener.Pending() & state == simulatorStatus.running)
                {
                    Socket msgSocket = Listener.AcceptSocket();

                    if (msgSocket.Connected)
                    {
                        reportProgressChange(RequestMsg);
                        RxBuffer = ReceiveMessage(msgSocket);

                        TxBuffer = processMessage(RxBuffer);

                        RxBuffer = null;
                        if (msgSocket.Connected == true)
                        {
                            String sMimeType = "text/xml";

                            int iTotBytes = TxBuffer.Length;

                            reportProgressChange(ResponseMsg);

                            SendHeader(sHttpVersion, sMimeType, iTotBytes, " 200 OK", ref msgSocket);

                            SendToBrowser(TxBuffer, ref msgSocket);
                        }

                        reportProgressChange(WaitingForRX);
                    }
                    if(msgSocket != null)
                        msgSocket.Close();
                    msgSocket = null;
                    TxBuffer = null;
                    RxBuffer = null;
                }
                Thread.Sleep(10);
            }
            stopProcess("Stopped");
        }
        */

        private Byte[] ReceiveMessage(Socket msgSocket)
        {
            int iStartPos = 0;
            Byte[] buffer = new Byte[1];
            String msg = "";
            Int32 bytes;

            do
            {
                bytes = msgSocket.Receive(buffer, buffer.Length, 0);
                msg += Encoding.ASCII.GetString(buffer, 0, bytes);
            } while (bytes > 0 & (ValidHeader(msg) == false));

            HeaderFields.Clear();
		    string [] Lines = msg.Replace("\r\n", "\n").Split('\n');
            for(int Cnt = 0; Cnt < Lines.Length; Cnt++) 
            {
			    int Ret = Lines[Cnt].IndexOf(":");
			    if (Ret > 0 && Ret < Lines[Cnt].Length - 1) 
                {
				    try {
                        HeaderFields.Add(Lines[Cnt].Substring(0, Ret), Lines[Cnt].Substring(Ret + 1).Trim());
				    } catch {}
			    }
            }

            // Get the content length
            iStartPos = msg.IndexOf("Content-Length:", 1) + 16;
            string sContentlength = msg.Substring(iStartPos, msg.IndexOf("\r", iStartPos) - iStartPos);
            int contentlength = int.Parse(sContentlength);

            Byte[] msgBuffer = new Byte[contentlength];
            bytes = msgSocket.Receive(msgBuffer, contentlength, 0);

            // Look for HTTP request
            iStartPos = msg.IndexOf("HTTP", 1);

            // Get the HTTP text and version e.g. it will return "HTTP/1.1"
            sHttpVersion = msg.Substring(iStartPos, 8);

            if (HeaderFields.ContainsKey("Content-Encoding"))
            {
                MemoryStream ms;
                StreamReader sr;
                if (HeaderFields["Content-Encoding"].ToLower() == "deflate")
                {
                    ms = new MemoryStream(msgBuffer);
                    DeflateStream def = new DeflateStream(ms, CompressionMode.Decompress, true);
                    sr = new StreamReader(def);
                    return Encoding.ASCII.GetBytes(sr.ReadToEnd());
                }
                else if (HeaderFields["Content-Encoding"].ToLower() == "gzip")
                {
                    ms = new MemoryStream(msgBuffer);
                    GZipStream zip = new GZipStream(ms, CompressionMode.Decompress, true);
                    sr = new StreamReader(zip);
                    return Encoding.ASCII.GetBytes(sr.ReadToEnd());
                }
            }
            return msgBuffer;
        }

        private bool ValidHeader(String header)
        {
            if (header.Contains("\r\n\r\n"))
                return true;
            if (header.Contains("\r\r"))
                return true;
            if (header.Contains("\n\n"))
                return true;

            return false;
        }
        /// <summary>
        /// This function send the Header Information to the client (Browser)
        /// </summary>
        /// <param name="sHttpVersion">HTTP Version</param>
        /// <param name="sMIMEHeader">Mime Type</param>
        /// <param name="iTotBytes">Total Bytes to be sent in the body</param>
        /// <param name="mySocket">Socket reference</param>
        /// <returns></returns>
        private void SendHeader(string sHttpVersion, string sMIMEHeader, string sEncoding, int iTotBytes, string sStatusCode, ref Socket msgSocket)
        {

            String sBuffer = "";

            // if Mime type is not provided set default to text/html
            if (sMIMEHeader.Length == 0)
            {
                sMIMEHeader = "text/html";  // Default Mime Type is text/html
            }

            sBuffer = sBuffer + sHttpVersion + sStatusCode + "\r\n";
            sBuffer = sBuffer + "Server: cx1193719-b\r\n";
            sBuffer = sBuffer + "Content-Type: " + sMIMEHeader + "\r\n";
            if (sEncoding != "")
                sBuffer = sBuffer + "Content-Encoding: " + sEncoding + "\r\n";
            //sBuffer = sBuffer + "Content-Encoding: gzip\r\n";
            sBuffer = sBuffer + "Accept-Ranges: bytes\r\n";
            sBuffer = sBuffer + "Content-Length: " + iTotBytes + "\r\n\r\n";

            Byte[] bSendData = Encoding.ASCII.GetBytes(sBuffer);

            SendToBrowser(bSendData, ref msgSocket);

            bSendData = null;
        }

        /// <summary>
        /// Overloaded Function, takes string, convert to bytes and calls 
        /// overloaded sendToBrowserFunction.
        /// </summary>
        /// <param name="sData">The data to be sent to the browser(client)</param>
        /// <param name="mySocket">Socket reference</param>
        private void SendToBrowser(String sData, ref Socket msgSocket)
        {
            SendToBrowser(Encoding.ASCII.GetBytes(sData), ref msgSocket);
        }

        /// <summary>
        /// Sends data to the browser (client)
        /// </summary>
        /// <param name="bSendData">Byte Array</param>
        /// <param name="mySocket">Socket reference</param>
        private void SendToBrowser(Byte[] bSendData, ref Socket msgSocket)
        {
            int numBytes = 0;

            try
            {
                if (msgSocket.Connected)
                {
                    if ((numBytes = msgSocket.Send(bSendData, bSendData.Length, 0)) == -1)
                    {
                    }
                    else
                    {
                    }
                }
                else
                {
                }
            }
            catch{ }

        }



    }

}
