/* Module Header

  $Header:   L:/pvcsrep65/HL7TestHarness/archives/Source Code/MessageProxy.cs-arc   1.50   24 Jul 2007 15:17:52   mwicks  $

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

  $Log:   L:/pvcsrep65/HL7TestHarness/archives/Source Code/MessageProxy.cs-arc  $
 *
 *   Rev 1.50   24 Jul 2007 15:17:52   mwicks
 *updated to include http compression options
 *
 *   Rev 1.49   19 Jul 2007 15:45:00   mwicks
 *Updated 
 *change tcp handling
 *removed thread sleeps
 *added attribute to disable client sim by message.
 *
 *   Rev 1.48   19 Apr 2007 08:45:12   mwicks
 *IBM Update - added the soapactionheader attribute to the consturctor element to allow the setting of the http soap header value.
 *
 *   Rev 1.47   26 Mar 2007 13:29:52   mwicks
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
 *   Rev 1.46   16 Mar 2007 15:46:02   mwicks
 *updated for the following:
 *1. msg proxy and client sim will replace localhost address names with machine name.
 *2. msg proxy outputs timing and number of messages sent.
 *3. commandline has auto control file.
 *4. GUI msg proxy now shows msgs from client and server systems.
 *5. GUI enable/disable redone to be more clear.
 *6. Results data grid columns re-sizeable
 *7. commandline will now handle all development options that GUI uses.
 *
 *   Rev 1.45   18 Jan 2007 14:20:24   mwicks
 *updated reporting and workflow schemas.
  Revision 1.1.1.1  2006/11/24 18:16:44  deltaware
  Init check in of HL7 Test Harness, version 2.0.3.9. For releases before this version please contact deltaware systems.

 *
 *   Rev 1.44   10 Nov 2006 09:26:42   mwicks
 *updated construction vars so that all simulators can access vars set by other simulators.
 *
 *   Rev 1.43   08 Nov 2006 15:21:04   mwicks
 *updated 
 *report - to place errors with messaging
 *testdata - all threads now use same testdata document
 *xsd - testdata and workflow xsd have been updated.
 *
 *   Rev 1.42   30 Oct 2006 09:32:54   mwicks
 *updated to add:
 *server simulator port
 *enable/disable client request validation
 *enable/disable server response validation
 *enable/disable message transformations by message proxy
 *
 *   Rev 1.41   06 Oct 2006 08:13:36   mwicks
 *updated to fix a bug in the process message groups, optional messages and non-seq messages.
 *
 *   Rev 1.40   28 Sep 2006 15:23:00   mwicks
 *updated to allow for validations to be dependent on message name.
 *
 *   Rev 1.39   28 Sep 2006 10:28:46   mwicks
 *updated to allow workflows to use put and set var's.
 *
 *   Rev 1.38   19 Sep 2006 15:08:46   mwicks
 *updated to remove exception when parameters are not set during construction of messages.
 *
 *   Rev 1.37   11 Sep 2006 16:10:28   mwicks
 *updated tcp monitoring to monitor the dns HostName instead of the localhost name.
 *
 *   Rev 1.36   06 Sep 2006 16:07:42   mwicks
 *Updated xpath values to get hl7 namespace root element name with multiple other namespaces defined.
 *
 *   Rev 1.35   06 Sep 2006 10:40:20   mwicks
 *updated to allow soap wrappers to be used.
 *
 *   Rev 1.34   05 Sep 2006 13:18:00   mwicks
 *Updated to reduce memory usage
 *
 *   Rev 1.33   31 Aug 2006 21:04:40   mwicks
 *reduced memory usage
 *
 *   Rev 1.32   31 Aug 2006 11:48:46   mwicks
 *updated to remove memory leaks
 *
 *   Rev 1.31   29 Aug 2006 15:09:04   mwicks
 *removed client = null as there is and issue with client object being closed at the wrong place.
 *
 *   Rev 1.30   29 Aug 2006 14:46:38   mwicks
 *Updated to fix some memory issues.
 *
 *   Rev 1.29   15 Aug 2006 16:16:58   mwicks
 *Updated to load xmlfile using streams.
 *updated to include parameters in construction transforms
 *updated workflows to allow paramlists.
 *
 *   Rev 1.28   03 Aug 2006 15:04:18   mwicks
 *Changed xml loading processes to always load from a stream.
 *xmldoc.loadxml(string) 
 *changed to 
 *xsldoc.load(new StringStream(string))
 *
 *
 *   Rev 1.27   02 Aug 2006 16:00:46   mwicks
 *placed log tag back in file
*/

using System;
using System.IO;
using System.IO.Compression;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Xml.XPath;
using System.Net;
using System.Net.NetworkInformation;
using System.Net.Sockets;
using System.Threading;
using System.Collections.Specialized;
using System.ComponentModel;


namespace HL7TestHarness
{
    public class Switch
    {
        public static bool STOP;
        public static bool MoveToNextTest;
    }

    class MessageProxy : Simulator
    {
        public enum simulatorStatus { running, paused, stopped, error };

        private TcpListener Listener;
        private XmlDocument MessageFlowData = new XmlDocument();
        private XmlDocument stagedTestData = new XmlDocument();
        private XPathNavigator msgNav;
        //private XPathNodeIterator msgInterator;
        private const String messageXpath = "//message";
        private const String requestProxyXpath = "/request/messageProxy";
        private const String responseProxyXpath = "/response/messageProxy";
        //private List<String> xpathList = new List<String>();
        private simulatorStatus state;
        private MsgTimer msgTime = new MsgTimer();

        MessageConstructor msgConstructor;

        private messageList xpathList = new messageList();

        // Virtual Server data.
        private List<String> httpSrc = new List<String>();
        private List<String> httpDsc = new List<String>();
        private List<String> httpDscUsr = new List<String>();
        private List<String> httpDscPsw = new List<String>();
        private const String NoUsrPswNeeded = "NoUsrPswNeeded";

        public History history = new History("history.xml");

        private StringDictionary sHttpHeader;

        private const String MsgToClient = "Response sent to Client";
        private const String ConstructMsg = "Constructing Message";
        private const String ValidateMsg = "Validating Message";
        private const String MsgToServer = "Request sent to Server";
        private const String MsgFromServer = "Response received from Server";
        private const String MsgFromClient = "Request received from Client";
        private const String WaitingForRx = "Listening for Request";
        private const String RxReceived = "Request Received";

        private delegate void WorkerEventHandler(AsyncOperation asyncOp);

        private WorkerEventHandler workerDelegate;

        public bool enableClientValidation;
        public bool enableServerValidation;
        public bool enableMsgConstructor;

        public static ManualResetEvent clientConnected =
            new ManualResetEvent(false);

        public MessageProxy()
        {
            msgConstructor = new MessageConstructor();
        }
        public MessageProxy(List<MessageConstructor.variable> Variables)
        {
            msgConstructor = new MessageConstructor(Variables);
        }

        ~MessageProxy()
        {
           // if(MessageFlowData != null)
           //     MessageFlowData.RemoveAll();
           // if(stagedTestData != null)
           //     stagedTestData.RemoveAll();

            sHttpHeader = null;
            history = null;
            httpDscPsw = null;
            httpDscUsr = null;
            httpDsc = null;
            httpSrc = null;
            xpathList = null;
            Listener = null;
            MessageFlowData = null;
            stagedTestData = null;
            msgNav = null;
            //msgInterator = null;
            workerDelegate = null;
            msgConstructor = null;
        }


        public void addHttpAddress(String src, String dsc, String dsc_usr, String dsc_psw)
        {
            int index;

            if (src.EndsWith("/"))
                src = src.Substring(0,src.Length - 1);
            if (dsc.EndsWith("/"))
                dsc = dsc.Substring(0, dsc.Length - 1);

            if (src.StartsWith("http://"))
                src = src.Substring(7);
            if (dsc.StartsWith("http://"))
                dsc = dsc.Substring(7);
    

            if (dsc_usr.Length <= 0 & dsc_psw.Length <= 0)
            {
                dsc_usr = NoUsrPswNeeded;
                dsc_psw = NoUsrPswNeeded;
            }

            if (src.Length > 0 & dsc.Length > 0)
            {
                
                if (httpSrc.Contains(src.ToLower()))
                {
                    index = httpSrc.IndexOf(src.ToLower());
                    httpDsc[index] = dsc;
                    httpDscUsr[index] = dsc_usr;
                    httpDscPsw[index] = dsc_psw;
                }
                else
                {
                    httpSrc.Add(src.ToLower());
                    httpDsc.Add(dsc);
                    httpDscUsr.Add(dsc_usr);
                    httpDscPsw.Add(dsc_psw);
                }
            }

        }

        public void setMessageFlow(XmlDocument msg)
        {
            MessageFlowData.Load( new StringReader(msg.OuterXml));
        }

        public void setStagedData(XmlDocument data)
        {
            //stagedTestData.Load( new StringReader(data.OuterXml));
            stagedTestData = data;
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
                msgConstructor.setHistoryData(history.historyDocument);

                //start listing on the given port
                IPAddress ipAddress = Dns.GetHostEntry(Dns.GetHostName()).AddressList[0];
                Listener = new TcpListener(ipAddress, port);

                Listener.Start();

                //start the thread which calls the method 'StartListen'

                // Create an AsyncOperation for taskId.
                AsyncOperation asyncOp =
                    AsyncOperationManager.CreateOperation(null);
                setAsyncOperation(asyncOp);

                // Start the asynchronous operation.
                workerDelegate = new WorkerEventHandler(run);
                workerDelegate.BeginInvoke(asyncOp, null, null);

                string[] bypass = getRequestServers();

                WebRequest.DefaultWebProxy = new WebProxyBypass("http://" + Dns.GetHostName() + ":" + port, false, bypass);
            }
            catch (Exception ex)
            {
                state = simulatorStatus.error;
                stopProcess("Stopped (" + ex.Message + ")");
            }

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
        private void stopProcess(String StatusMsg)
        {
            reportProgressChange(StatusMsg);
            if( Listener != null)
                Listener.Stop();
            Listener = null;
            msgNav = null;
            WebRequest.DefaultWebProxy = null;
        }

        public void StartListen()
        {
            reportProgressChange("Started");

            reportProgressChange(WaitingForRx);

            while (state != simulatorStatus.stopped & Switch.STOP == false)
            {

                if (state == simulatorStatus.running)
                {
                    // Set the event to nonsignaled state.
                    clientConnected.Reset();

                    reportProgressChange(WaitingForRx);
                    // Accept the connection. 
                    // BeginAcceptSocket() creates the accepted socket.
                    Listener.BeginAcceptSocket(
                        new AsyncCallback(DoAcceptSocketCallback), Listener);
                    // Wait until a connection is made and processed before 
                    // continuing.
                    clientConnected.WaitOne();
                }

                /*
                if (Listener.Pending() & state == simulatorStatus.running)
                {
                    Socket NewSocket = Listener.AcceptSocket();
                    if (NewSocket != null)
                    {
                        reportProgressChange(RxReceived);
                        HttpClient NewClient = new HttpClient(NewSocket, null, processSocket);
                        NewClient.setInterseptAddresses(httpSrc);
                        NewClient.run();
                    }
                }
                 */
                // give everyone time to process.
                //Thread.Sleep(10);
            }

            stopProcess("Stopped");
        }

        public void DoAcceptSocketCallback(IAsyncResult ar)
        {
            if (state == simulatorStatus.running)
            {
                // Get the listener that handles the client request.
                //TcpListener listener = (TcpListener)ar.AsyncState;

                // End the operation and display the received data on the
                //console.
                Socket clientSocket = Listener.EndAcceptSocket(ar);

                if (clientSocket != null)
                {

                    reportProgressChange(RxReceived);
                    HttpClient NewClient = new HttpClient(clientSocket, null, processSocket, clearConnection);
                    NewClient.setInterseptAddresses(httpSrc);
                    //NewClient.Start(asyncOp);
                    NewClient.runSingleThread();
                    //NewClient.run();
                }
            }
        }
        private void clearConnection()
        {
            clientConnected.Set();
        }


        private void createXpathList()
        {
            String xpath;
            String group;
            String msgName;
            Boolean optional;
            Boolean nonsequential;
            Boolean repeatable;
            XPathNodeIterator msgInterator;

            int workflowCount = 0;
            int messageCount = 0;
            msgInterator = msgNav.Select("//workflow");
            xpathList.clear();

            while (msgInterator.MoveNext())
            {
                workflowCount++;
                messageCount = 0;
                if (msgInterator.Current.MoveToChild("message",""))
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
                    } while (msgInterator.Current.MoveToNext("message",""));
                }

            }

        }
       
        private void processSocket(Socket msgSocket, StringDictionary header, Byte[] Header, Client client)
        {
            Byte[] sBuffer;
            String currentXpath;
            int xpathIndex;
            String msgName;
            String soapActionHeaderVal = null; //optional; when using soap, this will be non-null
            XPathNodeIterator msgInterator;
            
            if (msgSocket.Connected)
            {
                // receive the message from client
                sBuffer = ReceiveMessage(msgSocket, header, Header);
                try
                {
                    XmlDocument message = new XmlDocument();
                    message.Load(new MemoryStream(sBuffer));
                    XmlNamespaceManager nsmg = new XmlNamespaceManager(message.NameTable);
                    nsmg.AddNamespace("hl7", "urn:hl7-org:v3");
                    try
                    {
                        msgName = message.SelectSingleNode("descendant-or-self::hl7:*[1]", nsmg).LocalName;
                    }
                    catch { msgName = ""; }

                    xpathIndex = xpathList.getIndex(msgName);

                    if (xpathIndex >= 0)
                    {
                        reportProgressChange(MsgFromClient);

                        //currentXpath = xpathList[xpathLocation] + requestProxyXpath;
                        currentXpath = xpathList.getXpath(xpathIndex) + requestProxyXpath;

                        // get the list of request messages the object is expecting to receive.
                        msgInterator = msgNav.Select(currentXpath);
                        
                        if (msgInterator.MoveNext())
                        {
                            try
                            {
                                // store message in history file
                                history.createEntry(message, History.historyEvent.clientRequest, msgSocket.LocalEndPoint.ToString(), Thread.CurrentThread.GetHashCode().ToString());

                                // store message in log file
                                reportTestProgress(currentXpath, testResultStatus.processing, "RxMessage", message.DocumentElement.OuterXml);

                                // detect and extract soapActionHeader
                                soapActionHeaderVal = msgInterator.Current.SelectSingleNode("construction").GetAttribute("soapactionheader","");

                                if (enableClientValidation)
                                {
                                    reportProgressChange(ValidateMsg);
                                    // validate the received message
                                    ValidateMessage(message, currentXpath, true, msgInterator);
                                }

                                if (enableMsgConstructor)
                                {
                                    reportProgressChange(ConstructMsg);
                                    // construct the message to be sent to the server
                                    message = ConstructMessage(message, currentXpath, true, msgInterator);
                                }

                                // store message in history file
                                history.createEntry(message, History.historyEvent.serverRequest, getRemoteAddress(), Thread.CurrentThread.GetHashCode().ToString());

                                // store message in log file
                                reportTestProgress(currentXpath, testResultStatus.processing, "TxMessage", message.DocumentElement.OuterXml);

                                reportProgressChange(MsgToServer);
                                // send the message to the server and get reply
                                msgTime.start();
                                message = SendReceiveMessage(message, getRemoteAddress(), soapActionHeaderVal, ref header);
                                msgTime.stop();

                                reportProgressChange(MsgFromServer);
                                reportProgressChange("Message Time [Last:" + msgTime.Last() + "ms Avg:" + msgTime.Average() + "ms Total:" + msgTime.Total() + "ms Count:" + msgTime.Count() + "/" + xpathList.count().ToString() + "]");

                                //currentXpath = messageXpath + "[" + xpathLocation + "]" + responseProxyXpath;
                                currentXpath = xpathList.getXpath(xpathIndex) + responseProxyXpath;

                                // get the list of response messages the object is expecting to receive.
                                msgInterator = msgNav.Select(currentXpath);
                                // TODO: check if we have any expected requests.
                                msgInterator.MoveNext();

                                // store message in history file
                                history.createEntry(message, History.historyEvent.serverResponse, getRemoteAddress(), Thread.CurrentThread.GetHashCode().ToString());

                                // store message in log file
                                reportTestProgress(currentXpath, testResultStatus.processing, "RxMessage", message.DocumentElement.OuterXml);

                                if (enableServerValidation)
                                {
                                    reportProgressChange(ValidateMsg);
                                    // validate the reply message
                                    ValidateMessage(message, currentXpath, false, msgInterator);
                                }

                                if (enableMsgConstructor)
                                {
                                    reportProgressChange(ConstructMsg);
                                    // construct the message to be sent back to the client
                                    message = ConstructMessage(message, currentXpath, false, msgInterator);
                                }

                                // store message in history file
                                history.createEntry(message, History.historyEvent.clientResponse, msgSocket.LocalEndPoint.ToString(), Thread.CurrentThread.GetHashCode().ToString());

                                // store message in log file
                                reportTestProgress(currentXpath, testResultStatus.processing, "TxMessage", message.DocumentElement.OuterXml);

                                reportProgressChange(MsgToClient);
                                // send reply back to client.

                                SendReplyMessage(msgSocket, message, header);

                                // add a timestamp to the workflows element.
                                reportTestProgress("//workflows", testResultStatus.noUpdate, "", "");

                                reportTestProgress(currentXpath, testResultStatus.done, "", "");

                                if (Switch.MoveToNextTest == true)
                                    xpathList.processed(xpathIndex);
                                //xpathLocation++;
                            }
                            catch (Exception)
                            {
                                SendReplyMessage(msgSocket, "<error>Error processing request</error>");
                            }
                            reportProgressChange(WaitingForRx);
                        }
                        else
                        {
                            SendReplyMessage(msgSocket, "<error>Invalid Request. No response configured</error>");
                        }
                    }
                    else
                    {
                        SendReplyMessage(msgSocket, "<error>Invalid Request. No response configured</error>");
                    }
                }
                catch (Exception ex)
                {
                    SendReplyMessage(msgSocket, "<error>Invalid Request. Request is not a valid xml stream [" + ex.Message + "]</error>");
                }
                finally
                { 
                    sBuffer = null;
                    
                }

            }
            try
            {
                msgSocket.Disconnect(false);

                msgSocket.Shutdown(SocketShutdown.Both);
                msgSocket.Close();
            }
            catch{}
            finally
            { 
                msgSocket = null;
                if (header != null)
                    header.Clear();
                header = null;
                
                clientConnected.Set();
            }
        }


        private void SendReplyMessage(Socket msgSocket, XmlDocument doc, StringDictionary header)
        {
            string encodeValue;
            StreamWriter sw;
            MemoryStream ms = new MemoryStream();
            if (header.ContainsKey("Content-Encoding"))
            {
                if (header["Content-Encoding"].ToLower() == "gzip")
                {
                    GZipStream zip = new GZipStream(ms, CompressionMode.Compress, true);
                    sw = new StreamWriter(zip);
                    doc.Save(sw);
                    sw.Close();
                    encodeValue = "gzip";
                }
                else if (header["Content-Encoding"].ToLower() == "deflate")
                {
                    DeflateStream def = new DeflateStream(ms, CompressionMode.Compress, true);
                    sw = new StreamWriter(def);
                    doc.Save(sw);
                    sw.Close();
                    encodeValue = "deflate";
                }
                else
                {
                    sw = new StreamWriter(ms);
                    doc.Save(sw);
                    encodeValue = "";
                }
            }
            else
            {
                sw = new StreamWriter(ms);
                doc.Save(sw);
                encodeValue = "";
            }

            Byte[] sBuffer = ms.ToArray();
            sw.Close();
            ms.Close();

            if (msgSocket.Connected == true)
            {
                String sMimeType = "text/xml";

                int iTotBytes = sBuffer.Length;

                SendHeader(sHttpHeader["HttpVersion"], sMimeType, encodeValue, iTotBytes, " 200 OK", ref msgSocket);

                SendToBrowser(sBuffer, ref msgSocket);
            }
        }
        private void SendReplyMessage(Socket msgSocket, String sBuffer)
        {
            if (msgSocket.Connected == true)
            {
                String sMimeType = "text/xml";

                int iTotBytes = sBuffer.Length;

                SendHeader(sHttpHeader["HttpVersion"], sMimeType, "", iTotBytes, " 200 OK", ref msgSocket);

                SendToBrowser(sBuffer, ref msgSocket);
            }
        }

        private string[] getRequestServers()
        {
            string temp;
            string[] bypass = new string[httpSrc.Count];

            // go throw the httpSrc address list and extract all the server names.
            for (int i = 0; i < httpSrc.Count; i++)
            {
                temp = httpSrc[i];
                if (temp.IndexOf("/") > 0)
                {
                    bypass[i] = temp.Substring(0, temp.IndexOf("/"));
                }
                else
                {
                    bypass[i] = temp;
                }
            }
            return bypass;
        }

        private String getRemoteAddress()
        {
            String addrPath;
            String addr;
            addrPath = sHttpHeader["RequestPath"];

            if (sHttpHeader.ContainsKey("Host"))
            {
                addr = sHttpHeader["Host"] + addrPath;
            }
            else
            {
                addr = addrPath;
            }
            addr = addr.Trim();

            if(addr.StartsWith("http://"))
                addr = addr.Substring(7);

            if (addr.EndsWith("/"))
                addr = addr.Substring(0,addr.Length -1);

            if (httpSrc.Contains(addr.ToLower()))
            {
                addr = httpDsc[httpSrc.IndexOf(addr.ToLower())];            
            }

            if (addr.EndsWith("/") == false)
                addr = addr + "/";
            if (addr.StartsWith("http://") == false)
                addr = "http://" + addr;

            return addr;
        }

        private String getRemoteUsr(String RemoteAddress)
        {
            String Usr = NoUsrPswNeeded;
            if (httpDsc.Contains(RemoteAddress))
            {
                
                Usr = httpDscUsr[httpDsc.IndexOf(RemoteAddress)];
            }

            return Usr;
        }
        private String getRemotePsw(String RemoteAddress)
        {
            String Psw = NoUsrPswNeeded;
            if (httpDsc.Contains(RemoteAddress))
            {

                Psw = httpDscPsw[httpDsc.IndexOf(RemoteAddress)];
            }

            return Psw;
        }

        private Byte[] ReceiveMessage(Socket msgSocket, StringDictionary HeaderFields, Byte[] msg)
        {
            Byte[] msgBuffer;
            String Header;
            int msgLength = 0;

            //MemoryStream stream = new MemoryStream(buffer);

            Int32 bytes = msg.Length;
            Header = Encoding.ASCII.GetString(msg);

            sHttpHeader = HeaderFields;

            // Get the content length
            int contentlength = 0;
            try
            {
                contentlength = int.Parse(HeaderFields["Content-Length"]);
            }
            catch { }

            msgBuffer = new Byte[contentlength];

            if (Header.Contains("HTTP"))
            {
                int headerLen = 0;
                headerLen = Header.IndexOf("\r\n\r\n");
                if (headerLen > 0)
                { headerLen += 4; }
                else
                {
                    headerLen = Header.IndexOf("\r\r");
                    if (headerLen > 0)
                    { headerLen += 2; }
                    else
                    {
                        headerLen = Header.IndexOf("\n\n");
                        if (headerLen > 0)
                        { headerLen += 2; }
                    }
                }

            if (contentlength >= msg.Length)
                msgLength = msg.Length;
            else
                msgLength = contentlength;

            contentlength = contentlength - msgLength;
            for (int i = 0; i < msgLength; i++)
            {
                msgBuffer[i] = msg[i];
            }
            }

            while (contentlength != 0 & bytes != 0)
            {
                bytes = msgSocket.Receive(msgBuffer, msgLength, contentlength, 0);
                
                msgLength += bytes;
                contentlength -= bytes;
            }

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

        private XmlDocument SendReceiveMessage(XmlDocument msg, String ServerAddr, String soapActionHeaderVal, ref StringDictionary header)
        {
            HttpWebRequest req = null;
            HttpWebResponse rsp = null;
            XmlDocument replyMsg = new XmlDocument();
            String username;
            String password;
            StreamWriter writer;

            try
            {
                
                req = (HttpWebRequest)WebRequest.Create(ServerAddr);
                req.Method = "POST";        // Post method
                req.ContentType = "text/xml";     // content type
                req.KeepAlive = false;
                req.Timeout = 120000; // large timeout for DIS processing.

                username = getRemoteUsr(ServerAddr);
                if (username != NoUsrPswNeeded)
                {
                    password = getRemotePsw(ServerAddr);
                    // need to encode64 the username and password.
                    req.Headers.Add("Authorization", "Base " + username + ":" + password);
                }
                if (soapActionHeaderVal != null)
                {
                    req.Headers.Add("SOAPAction", "\"" + soapActionHeaderVal + "\"");
                }

                req.AutomaticDecompression = DecompressionMethods.None;
                if (header.ContainsKey("Accept-Encoding"))
                {
                    if (header["Accept-Encoding"].ToLower().Contains("deflate"))
                        req.Headers.Add("Accept-Encoding", "deflate");
                        //req.AutomaticDecompression = DecompressionMethods.Deflate;
                    if (header["Accept-Encoding"].ToLower().Contains("gzip"))
                        req.Headers.Add("Accept-Encoding", "gzip");
                    //req.AutomaticDecompression = req.AutomaticDecompression | DecompressionMethods.GZip;
                }
                if (header.ContainsKey("Content-Encoding"))
                {
                    if (header["Content-Encoding"].ToLower() == "deflate")
                    {
                        writer = new StreamWriter(req.GetRequestStream());
                        DeflateStream def = new DeflateStream(writer.BaseStream, CompressionMode.Compress, true);
                        msg.Save(def);
                        def.Close();
                        writer.Close();
                        req.Headers.Add("Content-Encoding", "deflate");
                    }
                    else if (header["Content-Encoding"].ToLower() == "gzip")
                    {
                        writer = new StreamWriter(req.GetRequestStream());
                        GZipStream zip = new GZipStream(writer.BaseStream, CompressionMode.Compress, true);
                        msg.Save(zip);
                        zip.Close();
                        writer.Close();
                        req.Headers.Add("Content-Encoding", "gzip");
                    }
                    else
                    {
                        // don't understand the encoding so just send it.
                        writer = new StreamWriter(req.GetRequestStream());
                        msg.Save(writer);
                        writer.Close();
                    }
                }
                else
                {
                    // no encoding so send it.
                    writer = new StreamWriter(req.GetRequestStream());
                    msg.Save(writer);
                    writer.Close();
                }

                // Send the data to the webserver
                rsp = (HttpWebResponse) req.GetResponse();

                header.Remove("Content-Encoding");
                Stream responseStream = rsp.GetResponseStream();

                if (rsp.ContentEncoding.ToLower().Contains("gzip"))
                {
                    header.Add("Content-Encoding", "gzip");
                    responseStream = new GZipStream(responseStream, CompressionMode.Decompress, true);
                }
                else if (rsp.ContentEncoding.ToLower().Contains("deflate"))
                {
                    header.Add("Content-Encoding", "deflate");
                    responseStream = new DeflateStream(responseStream, CompressionMode.Decompress, true);
                }
                replyMsg.Load(responseStream);
                //replyMsg.Load(rsp.GetResponseStream());
            }
            catch (WebException webEx)
            {
                replyMsg.LoadXml("<error>" + webEx.ToString() + "</error>");
            }
            catch (Exception ex)
            {
                replyMsg.LoadXml("<error>" + ex.ToString() + "</error>");
            }
            finally
            {
                if (req != null)
                {
                    req.GetRequestStream().Close();
                    req.Abort();
                    req = null;
                }
                if (rsp != null)
                {
                    rsp.GetResponseStream().Close();
                    rsp.Close();
                    rsp = null;
                }
            }
            return replyMsg;

        }

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
            if(sEncoding != "")
                sBuffer = sBuffer + "Content-Encoding: " + sEncoding + "\r\n";
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
            SendToBrowser( Encoding.ASCII.GetBytes(sData), ref msgSocket);
        }

        private void SendToBrowser(XmlDocument sData, ref Socket msgSocket)
        {
            MemoryStream ms = new MemoryStream();
            StreamWriter sw = new StreamWriter(ms);
            sData.Save(sw);

            //compression
            //GZipStream zip = new GZipStream(ms, CompressionMode.Compress, true);
            //sData.Save(zip);
            
            byte[] bytes = ms.ToArray();
            sw.Close();
            ms.Close();
            sw = null;
            ms = null;

            SendToBrowser( bytes, ref msgSocket);
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
                        reportProgressChange("Error sending Request(Send failed)");
                    }
                }
                else
                {
                    reportProgressChange("Error sending Request(Socket Disconnected)");
                }
            }
            catch 
            {
                reportProgressChange("Error sending Request(Exception)");
            }

        }

        private Boolean ValidateMessage(XmlDocument msg, String xpath, Boolean isServerRequest, XPathNodeIterator msgInterator)
        {
            Boolean valid = true;
            XmlDocument RxMessage = new XmlDocument();
            MessageValidator msgValidator = new MessageValidator();
            String msgName;
            try
            {
                RxMessage = msg;

                XmlNamespaceManager nsmg = new XmlNamespaceManager(RxMessage.NameTable);
                nsmg.AddNamespace("hl7", "urn:hl7-org:v3");
                msgName = RxMessage.SelectSingleNode("//descendant-or-self::hl7:*[1]", nsmg).LocalName;

                //msgValidator.setRule(MessageFlowData.CreateNavigator());
                msgValidator.setRule(msgInterator.Current.SelectSingleNode("."));
                msgValidator.setStagedData(stagedTestData);
                msgValidator.setHisotryData(history.historyDocument);
                msgValidator.IsServerRequest = isServerRequest;
                // validate the message.
                if(isServerRequest)
                    valid = msgValidator.Validate(RxMessage,reportTestProgress,xpath,msgName,enableClientValidation);
                else
                    valid = msgValidator.Validate(RxMessage, reportTestProgress, xpath, msgName, enableServerValidation);
            }
            catch (Exception ex)
            {
                valid = false;
                reportTestProgress(xpath + "/validate", testResultStatus.fail, "exception", "MessageProxy.ValidateMessage <details><![CDATA[" + ex.Message + "]]></details>");
            }

            RxMessage = null;
            msgValidator = null;

            return valid;
        }

        private XmlDocument ConstructMessage(XmlDocument RxMsg, String xpath, Boolean isServerRequest, XPathNodeIterator msgInterator)
        {
            XmlDocument TxMessage = new XmlDocument();
            XmlDocument RxMessage = new XmlDocument();
            //MessageConstructor msgConstructor = new MessageConstructor();
            
            try
            {
                RxMessage = RxMsg;
                
                msgConstructor.setRule(msgInterator.Current.SelectSingleNode("."));
                //msgConstructor.setStagedData(stagedTestData);
                msgConstructor.setHistoryData(history.historyDocument);
                msgConstructor.IsServerRequest = isServerRequest;

                // constuct the message to be sent out.
                TxMessage = msgConstructor.Construct(RxMessage);
                reportTestProgress(xpath + "/construction", testResultStatus.pass, "constructedMessage", TxMessage.DocumentElement.OuterXml);
                
                // this will check for errors that do not require exception handling.
                if(msgConstructor.Errors != "")
                    reportTestProgress(xpath + "/construction", testResultStatus.fail, "exception", msgConstructor.Errors);
            }
            catch (Exception ex)
            {
                //request caused exception
                reportTestProgress(xpath + "/construction", testResultStatus.fail, "exception", ex.Message);
                TxMessage = RxMsg;
            }

            RxMessage = null;
            //msgConstructor = null;

            return TxMessage;
        }


    }


}
