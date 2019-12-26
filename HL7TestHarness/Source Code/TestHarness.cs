/* Module Header

  $Header:   L:/pvcsrep65/HL7TestHarness/archives/Source Code/TestHarness.cs-arc   1.30   24 Jul 2007 15:17:52   mwicks  $

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

  $Log:   L:/pvcsrep65/HL7TestHarness/archives/Source Code/TestHarness.cs-arc  $
 *
 *   Rev 1.30   24 Jul 2007 15:17:52   mwicks
 *updated to include http compression options
 *
 *   Rev 1.29   19 Jul 2007 15:45:00   mwicks
 *Updated 
 *change tcp handling
 *removed thread sleeps
 *added attribute to disable client sim by message.
 *
 *   Rev 1.28   26 Mar 2007 13:29:54   mwicks
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
 *   Rev 1.27   16 Mar 2007 15:46:02   mwicks
 *updated for the following:
 *1. msg proxy and client sim will replace localhost address names with machine name.
 *2. msg proxy outputs timing and number of messages sent.
 *3. commandline has auto control file.
 *4. GUI msg proxy now shows msgs from client and server systems.
 *5. GUI enable/disable redone to be more clear.
 *6. Results data grid columns re-sizeable
 *7. commandline will now handle all development options that GUI uses.
 *
 *   Rev 1.26   18 Jan 2007 14:20:26   mwicks
 *updated reporting and workflow schemas.
  Revision 1.1.1.1  2006/11/24 18:16:46  deltaware
  Init check in of HL7 Test Harness, version 2.0.3.9. For releases before this version please contact deltaware systems.

 *
 *   Rev 1.25   10 Nov 2006 09:26:44   mwicks
 *updated construction vars so that all simulators can access vars set by other simulators.
 *
 *   Rev 1.24   08 Nov 2006 17:46:52   mwicks
 *added WorkingDirectory to xsl calls from simulators
 *
 *   Rev 1.23   30 Oct 2006 09:32:56   mwicks
 *updated to add:
 *server simulator port
 *enable/disable client request validation
 *enable/disable server response validation
 *enable/disable message transformations by message proxy
 *
 *   Rev 1.22   27 Sep 2006 15:45:58   mwicks
 *updated:
 *removed LOAD OID functionality
 *add auto file name on report generation.
 *
 *   Rev 1.21   21 Sep 2006 09:46:22   mwicks
 *updated to check the last write time of the test data file and warn the user if it has changed.
 *
 *   Rev 1.20   11 Sep 2006 16:10:30   mwicks
 *updated tcp monitoring to monitor the dns HostName instead of the localhost name.
 *
 *   Rev 1.19   05 Sep 2006 13:18:00   mwicks
 *Updated to reduce memory usage
 *
 *   Rev 1.18   31 Aug 2006 21:04:42   mwicks
 *reduced memory usage
 *
 *   Rev 1.17   31 Aug 2006 16:10:54   mwicks
 *updated usage of XslCompiledTransform to try to clean up it's memory after use.
 *
 *   Rev 1.16   31 Aug 2006 11:48:46   mwicks
 *updated to remove memory leaks
 *
 *   Rev 1.15   29 Aug 2006 14:46:38   mwicks
 *Updated to fix some memory issues.
 *
 *   Rev 1.14   03 Aug 2006 15:04:20   mwicks
 *Changed xml loading processes to always load from a stream.
 *xmldoc.loadxml(string) 
 *changed to 
 *xsldoc.load(new StringStream(string))
 *
 *
 *   Rev 1.13   29 Jun 2006 10:48:20   mwicks
 *updated status messages for console
 *
 *   Rev 1.12   28 Jun 2006 16:24:38   mwicks
 *removed "All Rights Reserved." from all files.
 *
 *   Rev 1.11   28 Jun 2006 15:04:24   mwicks
 *Updated to accept a referance tag in the workflow documents
 *for linking multiple workflows.
 *
 *   Rev 1.10   27 Jun 2006 13:00:28   mwicks
 *updated console application with ablitiy to stop processes from the command line.
 *
 *   Rev 1.9   26 Jun 2006 13:29:28   mwicks
 *added Lic
 *
 *   Rev 1.8   26 Jun 2006 13:18:26   mwicks
 *Updated License.
 *
 *   Rev 1.7   23 Jun 2006 15:13:08   mwicks
 *updated command line control. 
 *
 *   Rev 1.6   21 Jun 2006 15:01:32   mwicks
 *added new schema checking for workflow documents and test data.
 *
 *   Rev 1.5   20 Jun 2006 15:47:44   mwicks
 *Added Help About Screen
 *
 *   Rev 1.3   31 May 2006 10:03:34   mwicks
 *Updated to include a console interface
 *
 *   Rev 1.2   28 May 2006 10:35:18   mwicks
 *Updated test data file name to be included in config file that is saved on close and reloaded on open.
 *
 *   Rev 1.1   26 May 2006 15:19:24   mwicks
 *update file headers to include PVCS tags
 *updated config file to use bool instead of strings.

 */
using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Xml.XPath;
using System.Xml.Schema;
using System.Xml.Xsl;
using System.IO;
using System.Threading;



namespace HL7TestHarness
{
    class TestHarness
    {
        public ClientSimulator clientSim;
        public ServerSimulator serverSim;
        public MessageProxy msgProxy;
        public Logger systemLog;
        public DataStage dataStager;
        public config UIConfig;
        public bool TestFileChanged = false;
        public int burstMode = 0;

        private onProgressEventHandler MessageProxyStatusChange = null;
        private onProgressEventHandler ClientSimulatorStatusChange = null;
        private onProgressEventHandler ServerSimulatorStatusChange = null;
        private onLogChangedEventHandler SystemLogDataHandler = null;
        private onCompleteEventHandler SystemCompleteHandler = null;

        public XmlDocument workflowDoc = new XmlDocument();
        private String workflowFileName;
        private List<MessageConstructor.variable> Variables = new List<MessageConstructor.variable>();

        private String workflowSchemaFile = Directory.GetCurrentDirectory() + "\\xsd\\workflow.xsd";
        private String workflowRefTransformFile = Directory.GetCurrentDirectory() + "\\xsl\\workflowRefLoad.xsl";

        public TestHarness(String configFilename,
                           onProgressEventHandler MessageProxyStatusHandler,
                           onProgressEventHandler ClientSimulatorStatusHandler,
                           onProgressEventHandler ServerSimulatorStatusHandler,
                           onLogChangedEventHandler LogDataHandler,
                           onCompleteEventHandler OperationCompleteHandler
            )
        {
            MessageProxyStatusChange = MessageProxyStatusHandler;
            ClientSimulatorStatusChange = ClientSimulatorStatusHandler;
            ServerSimulatorStatusChange = ServerSimulatorStatusHandler;
            SystemLogDataHandler = LogDataHandler;
            SystemCompleteHandler = OperationCompleteHandler;
            Initialize(configFilename);
            
        }

        public TestHarness(String configFilename)
        {
            MessageProxyStatusChange = null;
            ClientSimulatorStatusChange = null;
            ServerSimulatorStatusChange = null;
            SystemLogDataHandler = null;
            SystemCompleteHandler = null;
            Initialize(configFilename);
        }

        ~TestHarness()
        {
            clientSim = null;
            serverSim = null;
            msgProxy = null;
            systemLog = null;
            dataStager = null;
            UIConfig = null;

            MessageProxyStatusChange = null;
            ClientSimulatorStatusChange = null;
            ServerSimulatorStatusChange = null;
            SystemLogDataHandler = null;
            SystemCompleteHandler = null;

            workflowDoc = null;
            workflowFileName = "";

            workflowSchemaFile = "";
            workflowRefTransformFile = "";
        }

        private void Initialize(String configFilename)
        {
            systemLog = new Logger();
            if (SystemLogDataHandler != null) 
                systemLog.OnLogChanged += new onLogChangedEventHandler(SystemLogDataHandler);
            dataStager = new DataStage();
            UIConfig = new config();
            try
            { UIConfig.loadConfig(configFilename); }
            catch { }
        }

        public void LoadWorkFlowFile(String filename, bool loadEmbededTestDatafile)
        {
            XmlDocument validatedLoad = new XmlDocument();
            validatedLoad.Load(filename);
            //validate the workflow file using the schema file.
            validatedLoad.Schemas.Add(null, workflowSchemaFile);
            validatedLoad.Validate(null);

            //run the workflow transfrom to load any referanced workflow files.
            StringReader reader = new StringReader(transfromXmlDoc(validatedLoad, workflowRefTransformFile, filename.Substring(0, filename.LastIndexOf("\\") + 1)));
            validatedLoad.Load(reader);
            reader.Close();
            reader = null;
            
            //validate the resulting workflow using the schema file.
            validatedLoad.Schemas.Add(null, workflowSchemaFile);
            validatedLoad.Validate(null);

            //if the above validation works we load the file into the workflow.
            workflowFileName = filename;
            StringReader validated = new StringReader(validatedLoad.OuterXml);
            workflowDoc.Load(validated);
            validated.Close();
            validated = null;
            

            validatedLoad.Schemas = null;
            validatedLoad = null;

            systemLog.setLogFileBaseStructure(workflowDoc);


            if (loadEmbededTestDatafile)
            {
                LoadDataFile(getTestDataFileName());
            }
            else if (dataStager.TestDataFileName != null)
            {
                FileInfo testFileInfo = new FileInfo(dataStager.TestDataFileName);
                if (testFileInfo.LastWriteTimeUtc != dataStager.LastWriteTimeUtc)
                    TestFileChanged = true;
                else
                    TestFileChanged = false;
            }
        }

        public bool LoadDataFile(String filename)
        {
            bool status = dataStager.loadDataFile(filename);

            if (status == true)
            {
                UIConfig.testData.datafile = filename;
                TestFileChanged = false;
            }

            return status;
        }

        private String getTestDataFileName()
        {
            String result =
                    workflowDoc.SelectSingleNode("workflows").Attributes.GetNamedItem("testDataFile").Value;
            result = workflowFileName.Substring(0, workflowFileName.LastIndexOf("\\")) + "\\" + result;
            return result;
        }


        public void GlobalStart()
        {
             Switch.STOP = false;
             Switch.MoveToNextTest = !UIConfig.MessageProxyConfig.msgLoop;
            
             StartMessageProxy();
             StartServerSim();
             StartClientSim();
        }

        public void GlobalStop()
        {
            Switch.STOP = true;
            StopClientSim();
            StopServerSim();
            StopMessageProxy();
        }


        private void StartMessageProxy()
        {
            int port;

            if (UIConfig.MessageProxyConfig.enabled)
            {
                if (msgProxy != null)
                    msgProxy = null;
                msgProxy = new MessageProxy(Variables);

                msgProxy.onTestProgress += new onTestProgressEventHandler(systemLog.logEventHanderConsumer);
                msgProxy.OnProgressChange += new onProgressEventHandler(MessageProxyStatusChange);

                for (int i = UIConfig.MessageProxyConfig.servers.Count - 1; i >= 0; i--)
                {
                    msgProxy.addHttpAddress(UIConfig.MessageProxyConfig.servers[i].virtualAddress,
                                            UIConfig.MessageProxyConfig.servers[i].remoteAddress,
                                            "", "");
                }
                msgProxy.setMessageFlow(workflowDoc);
                msgProxy.setStagedData(dataStager.StagedData);
                msgProxy.enableClientValidation = UIConfig.MessageProxyConfig.clientValidation;
                msgProxy.enableServerValidation = UIConfig.MessageProxyConfig.serverValidation;
                msgProxy.enableMsgConstructor = UIConfig.MessageProxyConfig.msgConstructor;


                try
                {
                    port = int.Parse(UIConfig.MessageProxyConfig.port);
                }
                catch 
                {
                    port = 8080;
                }

                msgProxy.Start(port);
            }
        }
        private void StopMessageProxy()
        {
            if (msgProxy != null)
            {
                msgProxy.Stop();
            }
            msgProxy = null;
        }

        private void StartClientSim()
        {
            if (UIConfig.ClientSimulatorConfig.enabled)
            {
                clientSim = new ClientSimulator(Variables);

                clientSim.onTestProgress += new onTestProgressEventHandler(systemLog.logEventHanderConsumer);
                clientSim.OnProgressChange += new onProgressEventHandler(ClientSimulatorStatusChange);
                clientSim.OnComplete += new onCompleteEventHandler(SystemCompleteHandler);

                clientSim.setMessageFlow(workflowDoc);
                clientSim.setHistoryData(msgProxy.history.historyDocument);
                clientSim.setStagedData(dataStager.StagedData);
                clientSim.compressionEnabled = UIConfig.ClientSimulatorConfig.compression;
                if(burstMode > 0)
                    clientSim.requestThreads = burstMode;


                clientSim.Start();
            }
        }
        private void StopClientSim()
        {
            if (clientSim != null)
            {
                clientSim.Stop();
            }
            clientSim = null;
        }

        private void StartServerSim()
        {
            int port;

            if ((UIConfig.ServerSimulatorConfig.enabled))
            {
                serverSim = new ServerSimulator(Variables);

                serverSim.onTestProgress += new onTestProgressEventHandler(systemLog.logEventHanderConsumer);
                serverSim.OnProgressChange += new onProgressEventHandler(ServerSimulatorStatusChange);

                serverSim.setMessageFlow(workflowDoc);
                serverSim.setStagedData(dataStager.StagedData);
                serverSim.setHistoryData(msgProxy.history.historyDocument);
                try
                {
                    port = int.Parse(UIConfig.ServerSimulatorConfig.port);
                }
                catch
                {
                    port = 5050;
                }
                serverSim.Start(port);
            }
        }
        private void StopServerSim()
        {
            if (serverSim != null)
            {
                serverSim.Stop();
            }
            serverSim = null;
        }

        private String transfromXmlDoc(XmlDocument src, String transformFileName, String LocalDirectory)
        {
            //XslTransform transformer;
            String reply = "";
            XslCompiledTransform transformer = new XslCompiledTransform(false);
            XsltSettings settings = new XsltSettings(true, true);

            StringBuilder sbuilder = new StringBuilder();
            TextWriter writer = new StringWriter(sbuilder);
            
            XsltArgumentList arg = new XsltArgumentList();

            try
            {

                arg.AddParam("localDirectory", "", LocalDirectory);

                //transformer = new XslTransform();

                transformer.Load(transformFileName, settings, new XmlUrlResolver());
                //transformer.Load(transformFileName, new XmlUrlResolver());
                // Execute the transform.
                transformer.Transform(src, arg, writer);
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

                transformer = null;
                settings = null;
                arg = null;
                if(sbuilder != null)
                    reply = sbuilder.ToString();
                sbuilder = null;
            }

            return (reply);
        }


        public Boolean IsFinished
        {
            get { return Switch.STOP; }
        }
    }
}
