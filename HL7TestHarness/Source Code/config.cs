/* Module Header

  $Header:   L:/pvcsrep65/HL7TestHarness/archives/Source Code/config.cs-arc   1.16   24 Jul 2007 15:17:50   mwicks  $

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

  $Log:   L:/pvcsrep65/HL7TestHarness/archives/Source Code/config.cs-arc  $
 *
 *   Rev 1.16   24 Jul 2007 15:17:50   mwicks
 *updated to include http compression options
 *
 *   Rev 1.15   27 Mar 2007 15:59:50   mwicks
 *updated to fix two compiler warnings.
 *- warning CS0108: 'HL7TestHarness.config.ProxyConfig.port' hides inherited member 'HL7TestH
 *arness.config.SimulatorConfig.port'. Use the new keyword if hiding was intended
 *- warning CS0169: The private field 'HL7TestHarness.MessageValidator.ValidationMs
 *g' is never used
 *
 *   Rev 1.14   16 Mar 2007 15:46:00   mwicks
 *updated for the following:
 *1. msg proxy and client sim will replace localhost address names with machine name.
 *2. msg proxy outputs timing and number of messages sent.
 *3. commandline has auto control file.
 *4. GUI msg proxy now shows msgs from client and server systems.
 *5. GUI enable/disable redone to be more clear.
 *6. Results data grid columns re-sizeable
 *7. commandline will now handle all development options that GUI uses.
 *
 *   Rev 1.13   18 Jan 2007 14:20:16   mwicks
 *updated reporting and workflow schemas.
  Revision 1.1.1.1  2006/11/24 18:16:40  deltaware
  Init check in of HL7 Test Harness, version 2.0.3.9. For releases before this version please contact deltaware systems.

 *
 *   Rev 1.12   30 Oct 2006 09:32:52   mwicks
 *updated to add:
 *server simulator port
 *enable/disable client request validation
 *enable/disable server response validation
 *enable/disable message transformations by message proxy
 *
 *   Rev 1.11   15 Sep 2006 10:27:52   mwicks
 *Updated display of messages in UI
 *
 *   Rev 1.10   11 Sep 2006 16:10:24   mwicks
 *updated tcp monitoring to monitor the dns HostName instead of the localhost name.
 *
 *   Rev 1.9   31 Aug 2006 21:04:38   mwicks
 *reduced memory usage
 *
 *   Rev 1.8   31 Aug 2006 11:48:44   mwicks
 *updated to remove memory leaks
 *
 *   Rev 1.7   28 Jun 2006 16:21:04   mwicks
 *updated splash screen
 *
 *   Rev 1.6   26 Jun 2006 13:29:24   mwicks
 *added Lic
 *
 *   Rev 1.5   26 Jun 2006 13:18:24   mwicks
 *Updated License.
 *
 *   Rev 1.4   23 Jun 2006 09:11:46   mwicks
 *updated comments
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
using System.Net;


namespace HL7TestHarness
{
    /// <summary>
    /// The config object holds the data that configures the test harness. 
    /// It will load configuration data from a file and store it back to a file. 
    /// </summary>
    class config
    {
        /// <summary>
        /// Staged Data configuration
        /// datafile - file location of Test Data file.
        /// </summary>
        public class StagedData
        {
            public bool stageClient;
            public bool stageServer;
            public string datafile;
            ~StagedData()
            {
                datafile = "";
            }
        }

        /// <summary>
        /// Simulator Config
        /// </summary>
        public class SimulatorConfig
        {
            public bool enabled;
            public string port;
            public bool compression;
        }

        /// <summary>
        /// Proxy Config - configuration for the message simulator
        /// port - port to lisson for requests
        /// servers - list of virtual servers.
        /// </summary>
        public class ProxyConfig : SimulatorConfig
        {
            //public string port;
            public List<VirtualServer> servers = new List<VirtualServer>();
            public bool workflowLoop;
            public bool msgLoop;
            public bool clientValidation;
            public bool serverValidation;
            public bool msgConstructor;

            ~ProxyConfig()
            {
                port = "";
                if (servers != null)
                    servers.Clear();
                servers = null;
            }

        }

        /// <summary>
        /// Virtual Server Configuration.
        /// Single viruatl server contains a 
        /// virtual address - address application makes request too.
        /// remote address - address request is redirected too.
        /// use simulator - send request to simulator.
        /// </summary>
        public class VirtualServer
        {
            public string virtualAddress;
            public string remoteAddress;
            public bool useRemoteSimulator;
            public VirtualServer(string virtualAddr, string remoteAddr, bool useSim)
            {
                virtualAddress = virtualAddr;
                remoteAddress = remoteAddr;
                useRemoteSimulator = useSim;
            }
            ~VirtualServer()
            {
                virtualAddress = "";
                remoteAddress = "";
            }
        }
        

        public SimulatorConfig ClientSimulatorConfig;
        public SimulatorConfig ServerSimulatorConfig;
        public ProxyConfig MessageProxyConfig;
        public String WorkFlowFileName;
        public StagedData testData;
        


        public config()
        {
            ClientSimulatorConfig = new SimulatorConfig();
            ServerSimulatorConfig = new SimulatorConfig();
            MessageProxyConfig = new ProxyConfig();
            testData = new StagedData();
        }

        ~config()
        {
            ClientSimulatorConfig = null;
            ServerSimulatorConfig = null;
            MessageProxyConfig = null;
            WorkFlowFileName = "";
            testData = null;
        }
        /// <summary>
        /// Load config file from disk and populate stucture.
        /// </summary>
        /// <param name="filename"></param>
        public void loadConfig(String filename)
        {
            XmlDocument configData = new XmlDocument();
            XmlNodeList ServerData;

            try
            {
                configData.Load(filename);

                ClientSimulatorConfig.enabled = bool.Parse(configData.SelectSingleNode("config/clientSimulator").Attributes["enabled"].Value);
                try { ClientSimulatorConfig.compression = bool.Parse(configData.SelectSingleNode("config/clientSimulator").Attributes["compression"].Value); }
                catch { ClientSimulatorConfig.compression = false; }
                ServerSimulatorConfig.enabled = bool.Parse(configData.SelectSingleNode("config/serverSimulator").Attributes["enabled"].Value);
                ServerSimulatorConfig.port = configData.SelectSingleNode("config/serverSimulator").Attributes["port"].Value;
                MessageProxyConfig.enabled = bool.Parse(configData.SelectSingleNode("config/messageProxy").Attributes["enabled"].Value);
                MessageProxyConfig.port = configData.SelectSingleNode("config/messageProxy").Attributes["port"].Value;
                MessageProxyConfig.workflowLoop = bool.Parse(configData.SelectSingleNode("config/messageProxy").Attributes["workflowLoop"].Value);
                MessageProxyConfig.msgLoop = bool.Parse(configData.SelectSingleNode("config/messageProxy").Attributes["msgLoop"].Value);
                MessageProxyConfig.clientValidation = bool.Parse(configData.SelectSingleNode("config/messageProxy").Attributes["clientValidation"].Value);
                MessageProxyConfig.serverValidation = bool.Parse(configData.SelectSingleNode("config/messageProxy").Attributes["serverValidation"].Value);
                MessageProxyConfig.msgConstructor = bool.Parse(configData.SelectSingleNode("config/messageProxy").Attributes["msgConstuctor"].Value);
                WorkFlowFileName = configData.SelectSingleNode("config/workflow").Attributes["file"].Value;
                testData.stageClient = bool.Parse(configData.SelectSingleNode("config/testData").Attributes["stageClient"].Value);
                testData.stageServer = bool.Parse(configData.SelectSingleNode("config/testData").Attributes["stageServer"].Value);
                testData.datafile = configData.SelectSingleNode("config/testData").Attributes["fileName"].Value;


                ServerData = configData.SelectNodes("config/messageProxy/server");
                MessageProxyConfig.servers.Clear();
                for (int i = ServerData.Count - 1; i >= 0; i--)
                {
                    MessageProxyConfig.servers.Add(
                        new VirtualServer(ServerData[i].Attributes["virtual"].Value.Replace("localhost", Dns.GetHostName()),
                                           ServerData[i].Attributes["remote"].Value.Replace("localhost", Dns.GetHostName()),
                                           bool.Parse(ServerData[i].Attributes["useRemoteSimulator"].Value)));
                }
                

            }
            catch
            {
                MessageProxyConfig.clientValidation = true;
                MessageProxyConfig.serverValidation = true;
                MessageProxyConfig.msgConstructor = true;
                ServerSimulatorConfig.port = "5050";
                MessageProxyConfig.port = "8080";
            }
            finally
            {
                ServerData = null;
                configData = null;
            }
        }

        /// <summary>
        /// Saves the Config file to disk.
        /// </summary>
        /// <param name="filename"></param>
        public void saveConfig(String filename)
        {
            XmlWriter configDocumentWriter;
            XmlDocument configDocument = new XmlDocument();
            XPathNavigator navigator = configDocument.CreateNavigator();

            try
            {
                configDocumentWriter = navigator.PrependChild();

                configDocumentWriter.WriteStartElement("config");
                configDocumentWriter.WriteStartElement("messageProxy");
                configDocumentWriter.WriteAttributeString("enabled", MessageProxyConfig.enabled.ToString());
                configDocumentWriter.WriteAttributeString("port", MessageProxyConfig.port);
                configDocumentWriter.WriteAttributeString("workflowLoop", MessageProxyConfig.workflowLoop.ToString());
                configDocumentWriter.WriteAttributeString("msgLoop", MessageProxyConfig.msgLoop.ToString());
                configDocumentWriter.WriteAttributeString("clientValidation", MessageProxyConfig.clientValidation.ToString());
                configDocumentWriter.WriteAttributeString("serverValidation", MessageProxyConfig.serverValidation.ToString());
                configDocumentWriter.WriteAttributeString("msgConstuctor", MessageProxyConfig.msgConstructor.ToString());
                for (int i = MessageProxyConfig.servers.Count - 1; i >= 0; i--)
                {
                    configDocumentWriter.WriteStartElement("server");
                    configDocumentWriter.WriteAttributeString("virtual", MessageProxyConfig.servers[i].virtualAddress.Replace("localhost", Dns.GetHostName()));
                    configDocumentWriter.WriteAttributeString("remote", MessageProxyConfig.servers[i].remoteAddress.Replace("localhost", Dns.GetHostName()));
                    configDocumentWriter.WriteAttributeString("useRemoteSimulator", MessageProxyConfig.servers[i].useRemoteSimulator.ToString());
                    configDocumentWriter.WriteEndElement();
                }

                configDocumentWriter.WriteEndElement();
                configDocumentWriter.WriteStartElement("clientSimulator");
                configDocumentWriter.WriteAttributeString("enabled", ClientSimulatorConfig.enabled.ToString());
                configDocumentWriter.WriteAttributeString("compression", ClientSimulatorConfig.compression.ToString());
                configDocumentWriter.WriteEndElement();
                configDocumentWriter.WriteStartElement("serverSimulator");
                configDocumentWriter.WriteAttributeString("enabled", ServerSimulatorConfig.enabled.ToString());
                configDocumentWriter.WriteAttributeString("port", ServerSimulatorConfig.port);
                configDocumentWriter.WriteEndElement();
                configDocumentWriter.WriteStartElement("workflow");
                configDocumentWriter.WriteAttributeString("file", WorkFlowFileName);
                configDocumentWriter.WriteEndElement();

                configDocumentWriter.WriteStartElement("testData");
                configDocumentWriter.WriteAttributeString("stageClient", testData.stageClient.ToString());
                configDocumentWriter.WriteAttributeString("stageServer", testData.stageServer.ToString());
                configDocumentWriter.WriteAttributeString("fileName", testData.datafile);
                configDocumentWriter.WriteEndElement();


                configDocumentWriter.WriteEndElement();
                configDocumentWriter.Close();

                configDocument.Save(filename);
            }
            finally
            {
                configDocumentWriter = null;
                configDocument = null;
                navigator = null;
            }
        }
    }
}
