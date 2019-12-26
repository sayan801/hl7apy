/* Module Header

  $Header:   L:/pvcsrep65/HL7TestHarness/archives/Source Code/TestHarnessUI.cs-arc   1.55   24 Jul 2007 15:17:52   mwicks  $

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

  $Log:   L:/pvcsrep65/HL7TestHarness/archives/Source Code/TestHarnessUI.cs-arc  $
 *
 *   Rev 1.55   24 Jul 2007 15:17:52   mwicks
 *updated to include http compression options
 *
 *   Rev 1.54   11 Apr 2007 10:54:12   mwicks
 *Updated to fix a bug that cuased the GUI not to load the last workflow that when the app is opened.
 *
 *   Rev 1.53   11 Apr 2007 10:09:26   mwicks
 *Updated to add a GUI option not to load the TestData file when loading a workflow file. 
 *Added a status bar on the Test Data tab that tells the user what test data file is currently loaded.
 *
 *   Rev 1.52   16 Mar 2007 15:46:02   mwicks
 *updated for the following:
 *1. msg proxy and client sim will replace localhost address names with machine name.
 *2. msg proxy outputs timing and number of messages sent.
 *3. commandline has auto control file.
 *4. GUI msg proxy now shows msgs from client and server systems.
 *5. GUI enable/disable redone to be more clear.
 *6. Results data grid columns re-sizeable
 *7. commandline will now handle all development options that GUI uses.
 *
 *   Rev 1.51   18 Jan 2007 14:20:26   mwicks
 *updated reporting and workflow schemas.
  Revision 1.1.1.1  2006/11/24 18:16:47  deltaware
  Init check in of HL7 Test Harness, version 2.0.3.9. For releases before this version please contact deltaware systems.

 *
 *   Rev 1.50   30 Oct 2006 09:32:56   mwicks
 *updated to add:
 *server simulator port
 *enable/disable client request validation
 *enable/disable server response validation
 *enable/disable message transformations by message proxy
 *
 *   Rev 1.49   27 Sep 2006 15:45:58   mwicks
 *updated:
 *removed LOAD OID functionality
 *add auto file name on report generation.
 *
 *   Rev 1.48   22 Sep 2006 10:55:28   mwicks
 *updated to restage test data when test data file changes between test runs.
 *
 *   Rev 1.47   21 Sep 2006 09:46:22   mwicks
 *updated to check the last write time of the test data file and warn the user if it has changed.
 *
 *   Rev 1.46   15 Sep 2006 10:27:54   mwicks
 *Updated display of messages in UI
 *
 *   Rev 1.45   11 Sep 2006 16:10:32   mwicks
 *updated tcp monitoring to monitor the dns HostName instead of the localhost name.
 *
 *   Rev 1.44   31 Aug 2006 21:04:42   mwicks
 *reduced memory usage
 *
 *   Rev 1.43   31 Aug 2006 16:10:54   mwicks
 *updated usage of XslCompiledTransform to try to clean up it's memory after use.
 *
 *   Rev 1.42   31 Aug 2006 11:48:46   mwicks
 *updated to remove memory leaks
 *
 *   Rev 1.41   29 Aug 2006 14:46:40   mwicks
 *Updated to fix some memory issues.
 *
 *   Rev 1.40   28 Aug 2006 14:35:00   mwicks
 *updated to verion 2.0.0.0
 *
 *   Rev 1.39   15 Aug 2006 16:17:00   mwicks
 *Updated to load xmlfile using streams.
 *updated to include parameters in construction transforms
 *updated workflows to allow paramlists.
 *
 *   Rev 1.38   03 Aug 2006 15:04:20   mwicks
 *Changed xml loading processes to always load from a stream.
 *xmldoc.loadxml(string) 
 *changed to 
 *xsldoc.load(new StringStream(string))
 *
 *
 *   Rev 1.37   02 Aug 2006 15:57:08   mwicks
 *Updated test harness to handle the following:
 *optional messages
 *non-sequential groups
 *globally non-sequential messages
 *
 *   Rev 1.36   28 Jun 2006 16:24:38   mwicks
 *removed "All Rights Reserved." from all files.
 *
 *   Rev 1.35   28 Jun 2006 16:21:08   mwicks
 *updated splash screen
 *
 *   Rev 1.34   28 Jun 2006 15:04:24   mwicks
 *Updated to accept a referance tag in the workflow documents
 *for linking multiple workflows.
 *
 *   Rev 1.33   27 Jun 2006 08:52:00   mwicks
 *Updated GUI to include an enable/disable in the status bar 
 *to show the state of the current msgproxy and simulators.
 *
 *   Rev 1.32   26 Jun 2006 13:29:28   mwicks
 *added Lic
 *
 *   Rev 1.31   26 Jun 2006 13:18:26   mwicks
 *Updated License.
*/

using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Xml;
using System.Xml.XPath;
using System.IO;
using System.Threading;
using System.Net;

namespace HL7TestHarness
   {
    public partial class TestHarnessUI : Form
    {
        private TestHarness TestHarnessEngine;

        private Boolean ClientEnabled = true;
        private Boolean ServerEnabled = true;
        private Boolean ProxyEnabled = true;

        private String MsgProxyStatusString = "Not Running";
        private String ClientSimStatusString = "Not Running";
        private String ServerSimStatusString = "Not Running";

        private String workflowFileName = "";

        private string httpReportCreateFilename = Directory.GetCurrentDirectory() + "\\xsl\\report.xsl";
        private string MessageValidationFilename = Directory.GetCurrentDirectory() + "\\xsl\\DB_GridView.xsl";
        private string TreeViewXslFilename = Directory.GetCurrentDirectory() + "\\xsl\\TreeView.xsl";
        private string configFilename = Directory.GetCurrentDirectory() + "\\config.xml";

        private string SimulatorServerAddress = "http://localhost:";
        private const string SimulatorServerUsr = "";
        private const string SimulatorServerPsw = "";

        private int intCurSimulator = 0;
        private int intMaxSimulator = 0;

        private String getSimulatorServerAddress()
        {
            return SimulatorServerAddress + TestHarnessEngine.UIConfig.ServerSimulatorConfig.port;
        }
        public TestHarnessUI()
        {
            InitializeComponent();

            // show splash screen.
            Thread th = new Thread(new ThreadStart(DoSplash));
            th.Start();
            Thread.Sleep(3500);
            th.Abort();
            th = null;

            SimulatorServerAddress = SimulatorServerAddress.Replace("localhost", Dns.GetHostName());
            

            this.Cursor = Cursors.WaitCursor;
            this.Text = "HL7 Test Harness v" + System.Windows.Forms.Application.ProductVersion.ToString();
         

            TestHarnessEngine = new TestHarness(configFilename, 
                                                updateMessageProxyStatus,
                                                updateClientSimStatus, 
                                                updateServerSimStatus, 
                                                ProcessXML,
                                                WorkFlowStop);

            LoadConfig();
            viewStageData();
            updateDisplay();
            updateStatusMessages();
            this.Cursor = Cursors.Default;
        }

        private void DoSplash()
        {
            Splash sp = new Splash();
            sp.ShowDialog();
            Thread.Sleep(3000);
            sp.Close();
            //sp = null;
        }

        private void workflowOpen(object sender, EventArgs e)
        {
            Boolean reloadTestData = false;
            String oldworkflow = workflowFileName;
            OpenFile.Filter = "XML Files | *.xml";
            OpenFile.Multiselect = false;
            if (OpenFile.ShowDialog() == DialogResult.OK)
            {
                workflowFileName = OpenFile.FileName;
                if (MessageBox.Show("Do you wish to Load the Test Data File contained with in this workflow file", "Test Data File Load", MessageBoxButtons.YesNo) == DialogResult.Yes)
                { reloadTestData = true; }
                if (openworkflow(reloadTestData) == true)
                { this.Text = "HL7 Test Harness v" + System.Windows.Forms.Application.ProductVersion.ToString() + "(" + workflowFileName + ")"; }
                else
                { workflowFileName = oldworkflow; }
                    
            }
        }

        private Boolean openworkflow(Boolean reloadTestData)
        {
            if (workflowFileName.Length <= 0)
                return false;
            try
            {
                this.Cursor = Cursors.WaitCursor;
                
                if(workflowFileName.LastIndexOf(":\\") > 0)
                    Directory.SetCurrentDirectory(workflowFileName.Substring(0, workflowFileName.LastIndexOf("\\")));

                TestHarnessEngine.LoadWorkFlowFile(workflowFileName, reloadTestData);

                if (TestHarnessEngine.TestFileChanged == true)
                {
                    if (MessageBox.Show("Test Data File has been modified.\n\nDo you wish to reload it?\n(Reloading will restage the data)", "WARNING File Changed", MessageBoxButtons.YesNo) == DialogResult.Yes)
                    {
                        TestHarnessEngine.LoadWorkFlowFile(workflowFileName, true);
                        viewStageData();
                    }
                }

                if (reloadTestData)
                    viewStageData();
                DisplayWorkFlowDiagram(false);
                fnDataReadingFromXMLFile();
                this.Cursor = Cursors.Default;
                updateDisplay();
                return true;
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error Loading Workflow Document\n\r[" + ex.Message + "]\n\r\n\r", "Error");
                this.Cursor = Cursors.Default;
                return false;
            }
        }

        private void GlobalStart(object sender, EventArgs e)
        {

            if (openworkflow(false))
            {
                if(TestHarnessEngine.dataStager.Status() == true)
                {
                    updateConfig(false);
                    
                    MsgProxy.Enabled = false;
                    ClientSimTab.Enabled = false;
                    ServerSimTab.Enabled = false;
                    WorkFlowTab.Enabled = false;
                    StageDataTab.Enabled = false;

                    ClientSimTxMsg.Clear();
                    ClientSimRxMsg.Clear();
                    ServerSimTxMsg.Clear();
                    ServerSimRxMsg.Clear();

                    TestHarnessEngine.GlobalStart();

                    GlobalStopButton.Visible = true;
                    GobalStartButton.Visible = false;
                }
                else
                {
                    MessageBox.Show("Test Data is invalid!", "Error");
                }
            }
        }

        private void GlobalStop(object sender, EventArgs e)
        {
            StopAll();
        }

        private void StopAll()
        {
            Switch.STOP = true;
            
            MsgProxy.Enabled = true;
            ClientSimTab.Enabled = true;
            ServerSimTab.Enabled = true;
            WorkFlowTab.Enabled = true;
            StageDataTab.Enabled = true;

            TestHarnessEngine.GlobalStop();

            GlobalStopButton.Visible = false;
            GobalStartButton.Visible = true;
            loadTxRxMessages();
            DisplayWorkFlowDiagram(true);
        }

        private void WorkFlowStop()
        {
            StopAll();
            if (WorkFlowLoop.Checked == true)
            {
                GlobalStart(this, new EventArgs());
            }
        }

        private void CreateHtmlReport(object sender, EventArgs e)
        {
            //DisplayResultsXml(xdoc);
            SaveFile.DefaultExt = "html";
            SaveFile.Filter = "html files (*.html)|*.html";
            SaveFile.AddExtension = true;
            SaveFile.FileName = workflowFileName + ".html";

            if (SaveFile.ShowDialog() == DialogResult.OK)
            {
                this.Cursor = Cursors.WaitCursor;
                String FileName = SaveFile.FileName;
                FileStream file = new FileStream(FileName, FileMode.Create, FileAccess.Write);
                StreamWriter sw = new StreamWriter(file);
                sw.Write(TestHarnessEngine.systemLog.getHtmlReportLog(httpReportCreateFilename));
                sw.Close();
                file.Close();
                System.Diagnostics.Process.Start(FileName);
                this.Cursor = Cursors.Default;

            }
        }

        public void updateClientSimStatus(String status)
        {
            ClientSimStatusString = status;
            status1.Text = "Client Simulator [" + status + "]";

            updateStatusMessages();
        }
        public void updateMessageProxyStatus(String status)
        {
            MsgProxyStatusString = status;
            status1.Text = "Message Proxy [" + status + "]";

            updateStatusMessages();
        }
        public void updateServerSimStatus(String status)
        {
            ServerSimStatusString = status;
            status1.Text = "Server Simulator [" + status + "]";
            updateStatusMessages();
        }

        private void updateStatusMessages()
        {
            if (ClientEnabled == false)
                ClientSimStatusString = "Not Running";
            if (ServerEnabled == false)
                ServerSimStatusString = "Not Running";
            if (ProxyEnabled == false)
                MsgProxyStatusString = "Not Running";
            
            ClientSimStatus.Text = ClientSimStatusString;
            ServerSimStatus.Text = ServerSimStatusString;
            MsgProxyStatus.Text = MsgProxyStatusString;

        }


        private void SaveResults(object sender, EventArgs e)
        {
            SaveFile.AddExtension = true;
            SaveFile.DefaultExt = "xml";
            SaveFile.Filter = "XML Files(*.xml)|*.xml";
            SaveFile.FileName = "";
            if (SaveFile.ShowDialog() == DialogResult.OK)
            {
                this.Cursor = Cursors.WaitCursor;
                XmlWriter xwriter = XmlWriter.Create(SaveFile.FileName);
                TestHarnessEngine.systemLog.logFile.WriteContentTo(xwriter);
                xwriter.Close();
                this.Cursor = Cursors.Default;
            }
        }


        /// <summary>
        /// Updates the display items as per the current state.
        /// </summary>
        private void updateDisplay()
        {
            DataStageStatusLabel.Text = TestHarnessEngine.UIConfig.testData.datafile;

            ClientSimDisable.Visible = true;
            ClientSimDisable.Enabled = ClientEnabled;
            ClientSimEnable.Visible = true;
            ClientSimEnable.Enabled = !ClientEnabled;
            ClientSimDisabledIcon.Visible = !ClientEnabled;
            ClientSimEnabledIcon.Visible = ClientEnabled;
            if (ClientEnabled)
            {
                ClientSimEnableStatus.Text = "(Enabled)";
                ClientSimEnableStatus.ForeColor = Color.Green;
            }
            else
            {
                ClientSimEnableStatus.Text = "(Disabled)";
                ClientSimEnableStatus.ForeColor = Color.Red;
            }
            
            ServerSimDisable.Visible = true;
            ServerSimDisable.Enabled = ServerEnabled;
            ServerSimEnable.Visible = true;
            ServerSimEnable.Enabled = !ServerEnabled;
            ServerSimDisabledIcon.Visible = !ServerEnabled;
            ServerSimEnabledIcon.Visible = ServerEnabled;
            if (ServerEnabled)
            {
                ServerSimEnableStatus.Text = "(Enabled)";
                ServerSimEnableStatus.ForeColor = Color.Green;
            }
            else
            {
                ServerSimEnableStatus.Text = "(Disabled)";
                ServerSimEnableStatus.ForeColor = Color.Red;
            }


            proxyDisable.Visible = true;
            proxyDisable.Enabled = ProxyEnabled;
            proxyEnable.Visible =  true;
            proxyEnable.Enabled = !ProxyEnabled;
            proxyDisabledIcon.Visible = !ProxyEnabled;
            proxyEnabledIcon.Visible = ProxyEnabled;
            if (ProxyEnabled)
            {
                MsgProxyEnableStatus.Text = "(Enabled)";
                MsgProxyEnableStatus.ForeColor = Color.Green;
            }
            else
            {
                MsgProxyEnableStatus.Text = "(Disabled)";
                MsgProxyEnableStatus.ForeColor = Color.Red;
            }



            LocalSettings.Enabled = ProxyEnabled;
            VirtualServers.Enabled = ProxyEnabled;
            ClientSimContainer.Enabled = ClientEnabled;
            ServerSimContainer.Enabled = ServerEnabled;


            if (SecurityEnable.Checked == true)
            {
                Security_user.Enabled = true;
                Security_psw.Enabled = true;
            }
            else
            {
                Security_user.Enabled = false;
                Security_psw.Enabled = false;
            }

            if (SimulatorServer1.Checked == true)
            {
                RemoteServer_1.Text = getSimulatorServerAddress();
                RemoteServer_1_usr.Text = SimulatorServerUsr;
                RemoteServer_1_psw.Text = SimulatorServerPsw;

                RemoteServer_1.Enabled = false;
                RemoteServer_1_usr.Enabled = false;
                RemoteServer_1_psw.Enabled = false;
            }
            else
            {
                RemoteServer_1.Enabled = true;
                RemoteServer_1_usr.Enabled = true;
                RemoteServer_1_psw.Enabled = true;
            }

            if (SimulatorServer2.Checked == true)
            {
                RemoteServer_2.Text = getSimulatorServerAddress();
                RemoteServer_2_usr.Text = SimulatorServerUsr;
                RemoteServer_2_psw.Text = SimulatorServerPsw;

                RemoteServer_2.Enabled = false;
                RemoteServer_2_usr.Enabled = false;
                RemoteServer_2_psw.Enabled = false;
            }
            else
            {
                RemoteServer_2.Enabled = true;
                RemoteServer_2_usr.Enabled = true;
                RemoteServer_2_psw.Enabled = true;
            }

            if (SimulatorServer3.Checked == true)
            {
                RemoteServer_3.Text = getSimulatorServerAddress();
                RemoteServer_3_usr.Text = SimulatorServerUsr;
                RemoteServer_3_psw.Text = SimulatorServerPsw;

                RemoteServer_3.Enabled = false;
                RemoteServer_3_usr.Enabled = false;
                RemoteServer_3_psw.Enabled = false;
            }
            else
            {
                RemoteServer_3.Enabled = true;
                RemoteServer_3_usr.Enabled = true;
                RemoteServer_3_psw.Enabled = true;
            }

            if (SimulatorServer4.Checked == true)
            {
                RemoteServer_4.Text = getSimulatorServerAddress();
                RemoteServer_4_usr.Text = SimulatorServerUsr;
                RemoteServer_4_psw.Text = SimulatorServerPsw;

                RemoteServer_4.Enabled = false;
                RemoteServer_4_usr.Enabled = false;
                RemoteServer_4_psw.Enabled = false;
            }
            else
            {
                RemoteServer_4.Enabled = true;
                RemoteServer_4_usr.Enabled = true;
                RemoteServer_4_psw.Enabled = true;
            }

            if (SimulatorServer5.Checked == true)
            {
                RemoteServer_5.Text = getSimulatorServerAddress();
                RemoteServer_5_usr.Text = SimulatorServerUsr;
                RemoteServer_5_psw.Text = SimulatorServerPsw;

                RemoteServer_5.Enabled = false;
                RemoteServer_5_usr.Enabled = false;
                RemoteServer_5_psw.Enabled = false;
            }
            else
            {
                RemoteServer_5.Enabled = true;
                RemoteServer_5_usr.Enabled = true;
                RemoteServer_5_psw.Enabled = true;
            }

            if (SimulatorServer6.Checked == true)
            {
                RemoteServer_6.Text = getSimulatorServerAddress();
                RemoteServer_6_usr.Text = SimulatorServerUsr;
                RemoteServer_6_psw.Text = SimulatorServerPsw;

                RemoteServer_6.Enabled = false;
                RemoteServer_6_usr.Enabled = false;
                RemoteServer_6_psw.Enabled = false;
            }
            else
            {
                RemoteServer_6.Enabled = true;
                RemoteServer_6_usr.Enabled = true;
                RemoteServer_6_psw.Enabled = true;
            }

            if (SimulatorServer7.Checked == true)
            {
                RemoteServer_7.Text = getSimulatorServerAddress();
                RemoteServer_7_usr.Text = SimulatorServerUsr;
                RemoteServer_7_psw.Text = SimulatorServerPsw;

                RemoteServer_7.Enabled = false;
                RemoteServer_7_usr.Enabled = false;
                RemoteServer_7_psw.Enabled = false;
            }
            else
            {
                RemoteServer_7.Enabled = true;
                RemoteServer_7_usr.Enabled = true;
                RemoteServer_7_psw.Enabled = true;
            }

            virtualServer_1.Text = virtualServer_1.Text.Replace("localhost", Dns.GetHostName());
            RemoteServer_1.Text = RemoteServer_1.Text.Replace("localhost", Dns.GetHostName());
            virtualServer_2.Text = virtualServer_2.Text.Replace("localhost", Dns.GetHostName());
            RemoteServer_2.Text = RemoteServer_2.Text.Replace("localhost", Dns.GetHostName());
            virtualServer_3.Text = virtualServer_3.Text.Replace("localhost", Dns.GetHostName());
            RemoteServer_3.Text = RemoteServer_3.Text.Replace("localhost", Dns.GetHostName());
            virtualServer_4.Text = virtualServer_4.Text.Replace("localhost", Dns.GetHostName());
            RemoteServer_4.Text = RemoteServer_4.Text.Replace("localhost", Dns.GetHostName());
            virtualServer_5.Text = virtualServer_5.Text.Replace("localhost", Dns.GetHostName());
            RemoteServer_5.Text = RemoteServer_5.Text.Replace("localhost", Dns.GetHostName());
            virtualServer_6.Text = virtualServer_6.Text.Replace("localhost", Dns.GetHostName());
            RemoteServer_6.Text = RemoteServer_6.Text.Replace("localhost", Dns.GetHostName());
            virtualServer_7.Text = virtualServer_7.Text.Replace("localhost", Dns.GetHostName());
            RemoteServer_7.Text = RemoteServer_7.Text.Replace("localhost", Dns.GetHostName());

        }

        private void ServerSimEnable_Click(object sender, EventArgs e)
        {
            ServerEnabled = true;
            updateDisplay();
        }

        private void ServerSimDisable_Click(object sender, EventArgs e)
        {
            ServerEnabled = false;
            updateDisplay();
        }

        private void ClientSimEnable_Click(object sender, EventArgs e)
        {
            ClientEnabled = true;
            if (SingleMsgLoop.Checked == true & ClientEnabled == true)
            {
                if (MessageBox.Show("You currently have Single Message Loop Mode Eabled\nSingle Message Loop Mode can only be used when the Client Simulator is disabled.\n\nDo you wish to DISABLE the Single Message Loop Mode?", "Error!", MessageBoxButtons.YesNo) == DialogResult.Yes)
                {
                    SingleMsgLoop.Checked = false;
                }
                else
                {
                    ClientEnabled = false;
                }
            }

            updateDisplay();
        }

        private void ClientSimDisable_Click(object sender, EventArgs e)
        {
            ClientEnabled = false;
            updateDisplay();
        }

        private void ProxyEnable_Click(object sender, EventArgs e)
        {
            ProxyEnabled = true;
            updateDisplay();
        }

        private void ProxyDisable_Click(object sender, EventArgs e)
        {
            ProxyEnabled = false;
            updateDisplay();
        }

        private void ProcessXML(XmlDocument xdoc)
        {
            fnCompareResults();
            if (updateSimMsg.Checked == true)
                loadTxRxMessages();
            xdoc = null;
        }


        private void RefreshWorkFlowDiagram(object sender, EventArgs e)
        {
            DisplayWorkFlowDiagram(true);
        }

        private void DisplayWorkFlowDiagram(Boolean expandTree)
        {
            XmlDocument results = new XmlDocument();
            try
            {
                StringReader sr = new StringReader(TestHarnessEngine.systemLog.getHtmlReportLog(TreeViewXslFilename));
                results.Load(sr);
                sr.Close();
                sr = null;
                DisplayResultsXml(results, expandTree);
            }
            catch 
            { }
        }

        private void DisplayResultsXml(XmlDocument xdoc, Boolean expandTree)
        {
            XPathNavigator navdoc;
            Boolean exit = false;
            String node = "/";
            string child = "";
            TreeNode newNode = new TreeNode();
            String status = "";

            try
            {
                WorkFlowDisplay.BeginUpdate();

                navdoc = xdoc.CreateNavigator();

                //navdoc.MoveToRoot();

                WorkFlowDisplay.Nodes.Clear();

                navdoc.MoveToRoot();
                navdoc.MoveToFollowing("workflows", "");
                navdoc.MoveToFirstChild();

                do
                {
                    status = navdoc.GetAttribute("status", "");
                    if (navdoc.GetAttribute("description", "") == "")
                    {
                        child = navdoc.Name;
                    }
                    else
                    {
                        child = navdoc.GetAttribute("description", "");
                    }

                    if (node == "/")
                        newNode = WorkFlowDisplay.Nodes.Add(child);
                    else
                        newNode = newNode.Nodes.Add(child);


                    if (status.ToLower() == "pass")
                    {
                        //newNode.ForeColor = Color.Green;
                        newNode.ImageIndex = 1;
                        newNode.SelectedImageIndex = 1;
                    }
                    else if (status.ToLower() == "fail")
                    {
                        //newNode.ForeColor = Color.Red;
                        newNode.ImageIndex = 0;
                        newNode.SelectedImageIndex = 0;
                    }
                    else
                    {
                        // check if any children have a failed status.

                    }

                    if (navdoc.HasChildren)
                    {
                        navdoc.MoveToFirstChild();
                        node = node + child + "/";
                    }
                    else
                    {
                        newNode = newNode.Parent;

                        while (navdoc.MoveToNext() == false & exit == false)
                        {
                            if (node == "/")
                                exit = true;
                            else
                            {
                                navdoc.MoveToParent();
                                newNode = newNode.Parent;
                                node = node.Substring(0, node.Length - 1);
                                node = node.Substring(0, node.LastIndexOf('/')) + "/";
                            }
                        }
                    }
                }
                while (exit == false);

            }
            catch { }
            finally
            {
                //if (expandTree == true)
                {
                    //  WorkFlowDisplay.ExpandAll();
                    int nodeCount = WorkFlowDisplay.GetNodeCount(false);
                    while(nodeCount > 0)
                    {
                        nodeCount--;
                        WorkFlowDisplay.Nodes[nodeCount].Expand();
                        expandTreeNodes(WorkFlowDisplay.Nodes[nodeCount]);
                    }
                }
                WorkFlowDisplay.EndUpdate();

                navdoc = null;
                newNode = null;
            }

        }

        private void expandTreeNodes(TreeNode node)
        {
            int nodeCount;

            if (node != null)
            {
                nodeCount = node.GetNodeCount(false);
                while (nodeCount > 0)
                {
                    nodeCount--;
                    // only expand image 0 nodes (failed nodes)
                    if (node.Nodes[nodeCount].ImageIndex == 0)
                    {
                        node.Nodes[nodeCount].Expand();
                        expandTreeNodes(node.Nodes[nodeCount]);
                    }
                }
            }
        }

        private void fnDataReadingFromXMLFile()
        {
            DataSet ds = new DataSet();
            try
            {
                if (TestHarnessEngine.systemLog.logFile.OuterXml != "")
                {
                    StringReader reader = new StringReader(TestHarnessEngine.systemLog.getHtmlReportLog(MessageValidationFilename));
                    ds.ReadXml(reader, XmlReadMode.InferSchema);
                    TestResults.DataSource = ds;
                    TestResults.DataMember = "rule";
                    reader.Close();
                    reader = null;
                }
            }
            finally
            {
                ds = null;
            }
        }

        private void fnCompareResults()
        {
            DataSet ds = new DataSet();
            try
            {
                if (TestHarnessEngine.systemLog.logFile.OuterXml != "")
                {
                    StringReader reader = new StringReader(TestHarnessEngine.systemLog.getHtmlReportLog(MessageValidationFilename));
                    ds.ReadXml(reader, XmlReadMode.InferSchema);
                    reader.Close();
                    reader = null;

                    for (int i = 0; i < TestResults.RowCount; i++)
                    {
                        for (int j = 0; j < TestResults.ColumnCount; j++)
                        {
                            if (TestResults.Rows[i].Cells[j].Value.ToString() != ds.Tables[0].Rows[i].ItemArray[j].ToString())
                            {
                                TestResults.Rows[i].Cells[j].Value = ds.Tables[0].Rows[i].ItemArray[j].ToString();
                            }
                        }
                    }
                }
            }
            finally
            {
                ds = null;
            }
        }

        #region TxRxMessageDisplay

        private void loadTxRxMessages()
        {
            //fnClientMessage();
            //fnServerMessage();

            fnSimulatorMessages();
            //NavigateMessage("request", false);
            //NavigateMessage("response", false);
            NavigateMessage(false);

            updateNavButtons();

            //toolStripClientNext.Enabled = false;
            //toolStripServerNext.Enabled = false;
            //if (intMaxSimulator >= 1)
            //{
            //    toolStripClientPrev.Enabled = true;
            //    toolStripServerPrev.Enabled = true;
           // }
        }

        private void toolStripClientPrev_Click(object sender, EventArgs e)
        {
            updateintCurSimulator("prev");
            NavigateMessage(true);

            //NavigateMessage("request", true);
            //NavigateMessage("response", false);
            updateNavButtons();
        }

        private void toolStripClientNext_Click(object sender, EventArgs e)
        {
            updateintCurSimulator("next");
            NavigateMessage(true);
            //NavigateMessage("request", true);
            //NavigateMessage("response", false);
            updateNavButtons();
        }

        private void toolStripServerPrev_Click(object sender, EventArgs e)
        {
            toolStripClientPrev_Click(sender, e);
        }

        private void toolStripServerNext_Click(object sender, EventArgs e)
        {
            toolStripClientNext_Click(sender, e);
        }


        private void populateToolStrip(XmlNode curNode)
        {
            String messageName;
            //messageName = "Messages[" + curNode.ParentNode.ParentNode.Attributes["description"].Value + "]";
            messageName = "Messages[" + curNode.Attributes["description"].Value + "]";
            ClientSimStatus.Text = "Client " + messageName;
            ServerSimStatus.Text = "Server " + messageName;
        }

        private void NavigateMessage(bool clearfirst)
        {
            XmlNodeList nodelist;
            //XmlNodeList newnodelist;
            XmlNode nodeData;

            try
            {
                if (clearfirst == true)
                {
                    ClientSimTxMsg.Text = "";
                    ClientSimRxMsg.Text = "";
                    ServerSimTxMsg.Text = "";
                    ServerSimRxMsg.Text = "";
                    ProxyClientRxMsg.Text = "";
                    ProxyClientTxMsg.Text = "";
                    ProxyServerRxMsg.Text = "";
                    ProxyServerTxMsg.Text = "";
                }

                nodelist = TestHarnessEngine.systemLog.logFile.SelectNodes("//message");
                if (intCurSimulator >= 0 & intCurSimulator < nodelist.Count)
                {
                    populateToolStrip(nodelist[intCurSimulator]);
                    
                    nodeData = nodelist[intCurSimulator].SelectSingleNode("request/Simulator/TxMessage[last()]");
                    if(nodeData != null)
                        ClientSimTxMsg.Text = PrettyPrint(nodeData.OuterXml);

                    nodeData = nodelist[intCurSimulator].SelectSingleNode("request/Simulator/RxMessage[last()]");
                    if (nodeData != null)
                        ClientSimRxMsg.Text = PrettyPrint(nodeData.OuterXml);

                    nodeData = nodelist[intCurSimulator].SelectSingleNode("response/Simulator/TxMessage[last()]");
                    if (nodeData != null)
                        ServerSimTxMsg.Text = PrettyPrint(nodeData.OuterXml);

                    nodeData = nodelist[intCurSimulator].SelectSingleNode("response/Simulator/RxMessage[last()]");
                    if (nodeData != null)
                        ServerSimRxMsg.Text = PrettyPrint(nodeData.OuterXml);


                    nodeData = nodelist[intCurSimulator].SelectSingleNode("request/messageProxy/RxMessage[last()]");
                    if (nodeData != null)
                        ProxyClientRxMsg.Text = PrettyPrint(nodeData.OuterXml);

                    nodeData = nodelist[intCurSimulator].SelectSingleNode("response/messageProxy/TxMessage[last()]");
                    if (nodeData != null)
                        ProxyClientTxMsg.Text = PrettyPrint(nodeData.OuterXml);

                    nodeData = nodelist[intCurSimulator].SelectSingleNode("response/messageProxy/RxMessage[last()]");
                    if (nodeData != null)
                        ProxyServerRxMsg.Text = PrettyPrint(nodeData.OuterXml);

                    nodeData = nodelist[intCurSimulator].SelectSingleNode("request/messageProxy/TxMessage[last()]");
                    if (nodeData != null)
                        ProxyServerTxMsg.Text = PrettyPrint(nodeData.OuterXml);

                    

                    /*
                    newnodelist = nodelist[intCurSimulator]..ChildNodes;
                    for (int j = 0; j < newnodelist.Count; j++)
                    {
                        if (newnodelist[j].Name == "TxMessage")
                        {
                            if (Type = "Simulator")
                            {
                                if (mType == "request")
                                {
                                    ClientSimTxMsg.Text = PrettyPrint(newnodelist[j].OuterXml);
                                }
                                else if (mType == "response")
                                {
                                    ServerSimTxMsg.Text = PrettyPrint(newnodelist[j].OuterXml);
                                }
                            }
                            else if (Type = "messageProxy")
                            {
                                if (mType == "request")
                                {
                                    ClientSimTxMsg.Text = PrettyPrint(newnodelist[j].OuterXml);
                                }
                                else if (mType == "response")
                                {
                                    ServerSimTxMsg.Text = PrettyPrint(newnodelist[j].OuterXml);
                                }
                            }
                        }
                        else if (newnodelist[j].Name == "RxMessage")
                        {
                            if (Type = "Simulator")
                            {
                                if (mType == "request")
                                {
                                    ClientSimRxMsg.Text = PrettyPrint(newnodelist[j].OuterXml);
                                }
                                else if (mType == "response")
                                {
                                    ServerSimRxMsg.Text = PrettyPrint(newnodelist[j].OuterXml);
                                }
                            }
                            else if (Type = "messageProxy")
                            {
                                if (mType == "request")
                                {
                                    ClientSimRxMsg.Text = PrettyPrint(newnodelist[j].OuterXml);
                                }
                                else if (mType == "response")
                                {
                                    ServerSimRxMsg.Text = PrettyPrint(newnodelist[j].OuterXml);
                                }
                            }
                        }
                    }
                     */ 
                }
            }
            finally
            {
                nodelist = null;
                nodeData = null;
                //newnodelist = null;
            }
        }

        private void updateintCurSimulator(String direction)
        {
            if (direction == "next")
            {
                intCurSimulator = intCurSimulator + 1;
            }
            else if (direction == "prev")
            {
                intCurSimulator = intCurSimulator - 1;
            }
        }

        private void updateNavButtons()
        {
            if (intCurSimulator == 0)
            {
                toolStripClientPrev.Enabled = false;
                toolStripServerPrev.Enabled = false;
                toolStripProxyPrev.Enabled = false;
            }
            else
            {
                toolStripClientPrev.Enabled = true;
                toolStripServerPrev.Enabled = true;
                toolStripProxyPrev.Enabled = true;
            }
            if (intCurSimulator < intMaxSimulator)
            {
                toolStripClientNext.Enabled = true;
                toolStripServerNext.Enabled = true;
                toolStripProxyNext.Enabled = true;
            }
            else
            {
                toolStripClientNext.Enabled = false;
                toolStripServerNext.Enabled = false;
                toolStripProxyNext.Enabled = false;
            }
        }

        private void fnSimulatorMessages()
        {
            XmlNodeList nodelist;
            try
            {
                nodelist = TestHarnessEngine.systemLog.logFile.SelectNodes("//message");
                intMaxSimulator = nodelist.Count - 1;

                nodelist = TestHarnessEngine.systemLog.logFile.SelectNodes("//response/messageProxy[RxMessage]");
                intCurSimulator = nodelist.Count - 1;
                nodelist = TestHarnessEngine.systemLog.logFile.SelectNodes("//request/messageProxy[TxMessage]");
                if (intCurSimulator < nodelist.Count)
                    intCurSimulator = nodelist.Count - 1;
            }
            catch
            {
                intMaxSimulator = 0;
                intCurSimulator = 0;
            }
            finally
            {
                if(intCurSimulator < 0)
                    intCurSimulator = 0;

                nodelist = null;
            }
        }

        public static String PrettyPrint(String XML)
        {
            String Result = "";

            MemoryStream MS = new MemoryStream();
            XmlTextWriter W = new XmlTextWriter(MS, Encoding.Unicode);
            XmlDocument D = new XmlDocument();

            try
            {
                // Load the XmlDocument with the XML.
                StringReader sr = new StringReader(XML);
                D.Load(sr);
                sr.Close();
                sr = null;

                W.Formatting = Formatting.Indented;

                // Write the XML into a formatting XmlTextWriter
                D.WriteContentTo(W);
                W.Flush();
                MS.Flush();

                // Have to rewind the MemoryStream in order to read
                // its contents.
                MS.Position = 0;

                // Read MemoryStream contents into a StreamReader.
                StreamReader SR = new StreamReader(MS);

                // Extract the text from the StreamReader.
                String FormattedXML = SR.ReadToEnd();

                Result = FormattedXML;
            }
            catch (XmlException)
            {
            }
            finally
            {
                if (MS != null)
                    MS.Close();
                if (W != null)
                    W.Close();
                MS = null;
                W = null;
                D = null;
            }
            return Result;
        }

#endregion

        private void RefreshClientMsg_Click(object sender, EventArgs e)
        {
            loadTxRxMessages();
        }

        private void EnableSecurity(object sender, EventArgs e)
        {
            updateDisplay();
        }

        private void OpenDataFile(object sender, EventArgs e)
        {
            OpenFile.Filter = "XML Files | *.xml";
            OpenFile.Multiselect = false;
            if (OpenFile.ShowDialog() == DialogResult.OK)
            {
                this.Cursor = Cursors.WaitCursor;
                OpenTestDataFile(OpenFile.FileName);
                this.Cursor = Cursors.Default;
            }

        }

        private void OpenTestDataFile(String filename)
        {

            if (TestHarnessEngine.LoadDataFile(filename) == false)
            {
                DataStageOutput.Text = "Error : " + TestHarnessEngine.dataStager.errorMessage;
                MessageBox.Show("Error Loading Test Data File\n\r[" + TestHarnessEngine.dataStager.errorMessage + "]", "Error");
            }
            else
            {
                DataStageStatusLabel.Text = "Data File (" + filename + ")";
                viewStageData();
            }
        }

        private void SimulateServer(object sender, EventArgs e)
        {
            updateDisplay();
        }

        private void btnGenerateData_Click(object sender, EventArgs e)
        {
            reStageData();
            updateDisplay();
        }

        private void TestDataSimulateClient_CheckedChanged(object sender, EventArgs e)
        {
            if (GenerateClientData.Checked == false)
            {
                if(ClientEnabled == false)
                {
                    if (MessageBox.Show("WARNING:\nNon-Staged Client Data should only be run using the Client Simulator.\nCurrently your Client Simulator is disabled.\n\nDo you wish to ENABLE the Client Simulator?", "Warning", MessageBoxButtons.YesNo) == DialogResult.Yes)
                  {
                      ClientEnabled = true;
                  }
                }
            }
            else
            {
                if (ClientEnabled == true)
                {
                    if (MessageBox.Show("WARNING:\nStaged Client Data should not be run using the Client Simulator.\nCurrently your Client Simulator is enabled.\n\nDo you wish to DISABLE the Client Simulator?", "Warning", MessageBoxButtons.YesNo) == DialogResult.Yes)
                    {
                        ClientEnabled = false;
                    }
                }
            }
            updateDisplay();
        }

        private void TestDataSimulateServer_CheckedChanged(object sender, EventArgs e)
        {
            if (GenerateServerData.Checked == false)
            {
                if (ServerEnabled == false)
                {
                    if (MessageBox.Show("WARNING:\nNon-Staged Server Data should only be run against a Server Simulator.\nCurrently your Server Simulator is disabled.\n\nDo you wish to ENABLE the Server Simulator?", "Warning", MessageBoxButtons.YesNo) == DialogResult.Yes)
                    {
                        ServerEnabled = true;
                    }
                }
            }
            else
            {
                if (ServerEnabled == true)
                {
                    if (MessageBox.Show("WARNING:\nStaged Server Data should not be run against a Server Simulator.\nCurrently your Server Simulator is enabled.\n\nDo you wish to DISABLE the Server Simulator?", "Warning", MessageBoxButtons.YesNo) == DialogResult.Yes)
                    {
                        ServerEnabled = false;
                    }
                }
            }
            updateDisplay();
        }

        private void reStageData()
        {
            this.Cursor = Cursors.WaitCursor;
            if (TestHarnessEngine.dataStager.reStageData(GenerateClientData.Checked, 
                     GenerateServerData.Checked) == false)
            {
                DataStageOutput.Text = "Error : " + TestHarnessEngine.dataStager.errorMessage;
            }
            else
            {
                DataStageOutput.Text = PrettyPrint(TestHarnessEngine.dataStager.DBStagedData.OuterXml);
            }
            this.Cursor = Cursors.Default;

        }

        private void viewStageData()
        {
            if (TestHarnessEngine.dataStager.reStageData(false, false) == false)
                DataStageOutput.Text = "Error : " + TestHarnessEngine.dataStager.errorMessage;
            else
                DataStageOutput.Text = PrettyPrint(TestHarnessEngine.dataStager.DBStagedData.OuterXml);
        }

        private void LoadServerOIDs(object sender, EventArgs e)
        {
            OpenFile.Filter = "XML Files | *.xml";
            OpenFile.Multiselect = false;
            if (OpenFile.ShowDialog() == DialogResult.OK)
            {
                if (TestHarnessEngine.dataStager.LoadServerOIDs(OpenFile.FileName) == false)
                {
                    MessageBox.Show(TestHarnessEngine.dataStager.errorMessage, "Error", MessageBoxButtons.OK);
                }

                reStageData();
            }
        }

        private void LoadClientOIDs(object sender, EventArgs e)
        {
            OpenFile.Filter = "XML Files | *.xml";
            OpenFile.Multiselect = false;
            if (OpenFile.ShowDialog() == DialogResult.OK)
            {
                if (TestHarnessEngine.dataStager.LoadClientOIDs(OpenFile.FileName) == false)
                {
                    MessageBox.Show(TestHarnessEngine.dataStager.errorMessage, "Error", MessageBoxButtons.OK);
                }

                reStageData();
            }
        }

        private void SaveStagedData(object sender, EventArgs e)
        {
            SaveFile.AddExtension = true;
            SaveFile.DefaultExt = "xml";
            SaveFile.Filter = "XML Files(*.xml)|*.xml";
            SaveFile.FileName = "StagedData.xml";
            if (SaveFile.ShowDialog() == DialogResult.OK)
            {
                this.Cursor = Cursors.WaitCursor;
                XmlWriter xwriter = XmlWriter.Create(SaveFile.FileName);
                TestHarnessEngine.dataStager.StagedData.WriteContentTo(xwriter);
                xwriter.Close();
                xwriter = null;
                this.Cursor = Cursors.Default;
            }

        }

        private void SingleMsgLoop_CheckedChanged(object sender, EventArgs e)
        {
            if (SingleMsgLoop.Checked == true & ClientEnabled == true)
            {
                if (MessageBox.Show("Single Message Loop Mode can only be used when the Client Simulator is disabled.\n\nDo you wish to DISABLE the Client Simulator?", "Error!", MessageBoxButtons.YesNo) == DialogResult.Yes)
                {
                    ClientEnabled = false;
                }
                else
                {
                    SingleMsgLoop.Checked = false;
                }
            }
            updateDisplay();

        }

        private void LoadConfig()
        {
            try
            {
                GenerateClientData.Checked = TestHarnessEngine.UIConfig.testData.stageClient;
                GenerateServerData.Checked = TestHarnessEngine.UIConfig.testData.stageServer;
                ServerEnabled = TestHarnessEngine.UIConfig.ServerSimulatorConfig.enabled;

                ClientEnabled = TestHarnessEngine.UIConfig.ClientSimulatorConfig.enabled;
                compressionEnabled.Checked = TestHarnessEngine.UIConfig.ClientSimulatorConfig.compression;
                ProxyEnabled = TestHarnessEngine.UIConfig.MessageProxyConfig.enabled;
                WorkFlowLoop.Checked = TestHarnessEngine.UIConfig.MessageProxyConfig.workflowLoop;
                SingleMsgLoop.Checked = TestHarnessEngine.UIConfig.MessageProxyConfig.msgLoop;
                validateClient.Checked = TestHarnessEngine.UIConfig.MessageProxyConfig.clientValidation;
                validateServer.Checked = TestHarnessEngine.UIConfig.MessageProxyConfig.serverValidation;
                constructMsg.Checked = TestHarnessEngine.UIConfig.MessageProxyConfig.msgConstructor;

                if (TestHarnessEngine.UIConfig.MessageProxyConfig.port != "")
                    localport.Text = TestHarnessEngine.UIConfig.MessageProxyConfig.port;

                if (TestHarnessEngine.UIConfig.MessageProxyConfig.servers.Count >= 0)
                {
                    virtualServer_1.Text = TestHarnessEngine.UIConfig.MessageProxyConfig.servers[0].virtualAddress;
                    RemoteServer_1.Text = TestHarnessEngine.UIConfig.MessageProxyConfig.servers[0].remoteAddress;
                    SimulatorServer1.Checked = TestHarnessEngine.UIConfig.MessageProxyConfig.servers[0].useRemoteSimulator;
                }
                if (TestHarnessEngine.UIConfig.MessageProxyConfig.servers.Count >= 1)
                {
                    virtualServer_2.Text = TestHarnessEngine.UIConfig.MessageProxyConfig.servers[1].virtualAddress;
                    RemoteServer_2.Text = TestHarnessEngine.UIConfig.MessageProxyConfig.servers[1].remoteAddress;
                    SimulatorServer2.Checked = TestHarnessEngine.UIConfig.MessageProxyConfig.servers[1].useRemoteSimulator;
                }
                if (TestHarnessEngine.UIConfig.MessageProxyConfig.servers.Count >= 2)
                {
                    virtualServer_3.Text = TestHarnessEngine.UIConfig.MessageProxyConfig.servers[2].virtualAddress;
                    RemoteServer_3.Text = TestHarnessEngine.UIConfig.MessageProxyConfig.servers[2].remoteAddress;
                    SimulatorServer3.Checked = TestHarnessEngine.UIConfig.MessageProxyConfig.servers[2].useRemoteSimulator;
                }
                if (TestHarnessEngine.UIConfig.MessageProxyConfig.servers.Count >= 3)
                {
                    virtualServer_4.Text = TestHarnessEngine.UIConfig.MessageProxyConfig.servers[3].virtualAddress;
                    RemoteServer_4.Text = TestHarnessEngine.UIConfig.MessageProxyConfig.servers[3].remoteAddress;
                    SimulatorServer4.Checked = TestHarnessEngine.UIConfig.MessageProxyConfig.servers[3].useRemoteSimulator;
                }
                if (TestHarnessEngine.UIConfig.MessageProxyConfig.servers.Count >= 4)
                {
                    virtualServer_5.Text = TestHarnessEngine.UIConfig.MessageProxyConfig.servers[4].virtualAddress;
                    RemoteServer_5.Text = TestHarnessEngine.UIConfig.MessageProxyConfig.servers[4].remoteAddress;
                    SimulatorServer5.Checked = TestHarnessEngine.UIConfig.MessageProxyConfig.servers[4].useRemoteSimulator;
                }
                if (TestHarnessEngine.UIConfig.MessageProxyConfig.servers.Count >= 5)
                {
                    virtualServer_6.Text = TestHarnessEngine.UIConfig.MessageProxyConfig.servers[5].virtualAddress;
                    RemoteServer_6.Text = TestHarnessEngine.UIConfig.MessageProxyConfig.servers[5].remoteAddress;
                    SimulatorServer6.Checked = TestHarnessEngine.UIConfig.MessageProxyConfig.servers[5].useRemoteSimulator;
                }
                if (TestHarnessEngine.UIConfig.MessageProxyConfig.servers.Count >= 6)
                {
                    virtualServer_7.Text = TestHarnessEngine.UIConfig.MessageProxyConfig.servers[6].virtualAddress;
                    RemoteServer_7.Text = TestHarnessEngine.UIConfig.MessageProxyConfig.servers[6].remoteAddress;
                    SimulatorServer7.Checked = TestHarnessEngine.UIConfig.MessageProxyConfig.servers[6].useRemoteSimulator;
                }

                if (TestHarnessEngine.UIConfig.testData.datafile != "")
                {
                    OpenTestDataFile(TestHarnessEngine.UIConfig.testData.datafile);
                }

                if (TestHarnessEngine.UIConfig.WorkFlowFileName != "")
                {
                    workflowFileName = TestHarnessEngine.UIConfig.WorkFlowFileName;
                    this.Text = "HL7 Test Harness v" + System.Windows.Forms.Application.ProductVersion.ToString() + "(" + workflowFileName + ")";
                    openworkflow(false);
                }

                // This has to be done last because it actually causes an update to the config file.
                SeverSimPort.Text = TestHarnessEngine.UIConfig.ServerSimulatorConfig.port;

                updateDisplay();

            }
            catch { }

        }

        private void TestHarnessUI_FormClosing(object sender, FormClosingEventArgs e)
        {
            updateConfig(true);
        }

        private void updateConfig(bool SaveToFile)
        {
            try
            {
                TestHarnessEngine.UIConfig.testData.stageClient = GenerateClientData.Checked;
                TestHarnessEngine.UIConfig.testData.stageServer = GenerateServerData.Checked;

                TestHarnessEngine.UIConfig.WorkFlowFileName = workflowFileName;

                TestHarnessEngine.UIConfig.ServerSimulatorConfig.enabled = ServerEnabled;
                TestHarnessEngine.UIConfig.ServerSimulatorConfig.port = SeverSimPort.Text;
                TestHarnessEngine.UIConfig.ClientSimulatorConfig.enabled = ClientEnabled;
                TestHarnessEngine.UIConfig.ClientSimulatorConfig.compression = compressionEnabled.Checked;
                TestHarnessEngine.UIConfig.MessageProxyConfig.enabled = ProxyEnabled;
                TestHarnessEngine.UIConfig.MessageProxyConfig.workflowLoop = WorkFlowLoop.Checked;
                TestHarnessEngine.UIConfig.MessageProxyConfig.msgLoop = SingleMsgLoop.Checked;
                TestHarnessEngine.UIConfig.MessageProxyConfig.clientValidation = validateClient.Checked;
                TestHarnessEngine.UIConfig.MessageProxyConfig.serverValidation = validateServer.Checked;
                TestHarnessEngine.UIConfig.MessageProxyConfig.msgConstructor = constructMsg.Checked;


                TestHarnessEngine.UIConfig.MessageProxyConfig.port = localport.Text;

                TestHarnessEngine.UIConfig.MessageProxyConfig.servers.Clear();
                TestHarnessEngine.UIConfig.MessageProxyConfig.servers.Add(new config.VirtualServer(virtualServer_1.Text, RemoteServer_1.Text, SimulatorServer1.Checked));
                TestHarnessEngine.UIConfig.MessageProxyConfig.servers.Add(new config.VirtualServer(virtualServer_2.Text, RemoteServer_2.Text, SimulatorServer2.Checked));
                TestHarnessEngine.UIConfig.MessageProxyConfig.servers.Add(new config.VirtualServer(virtualServer_3.Text, RemoteServer_3.Text, SimulatorServer3.Checked));
                TestHarnessEngine.UIConfig.MessageProxyConfig.servers.Add(new config.VirtualServer(virtualServer_4.Text, RemoteServer_4.Text, SimulatorServer4.Checked));
                TestHarnessEngine.UIConfig.MessageProxyConfig.servers.Add(new config.VirtualServer(virtualServer_5.Text, RemoteServer_5.Text, SimulatorServer5.Checked));
                TestHarnessEngine.UIConfig.MessageProxyConfig.servers.Add(new config.VirtualServer(virtualServer_6.Text, RemoteServer_6.Text, SimulatorServer6.Checked));
                TestHarnessEngine.UIConfig.MessageProxyConfig.servers.Add(new config.VirtualServer(virtualServer_7.Text, RemoteServer_7.Text, SimulatorServer7.Checked));

                if (SaveToFile)
                {
                    TestHarnessEngine.UIConfig.saveConfig(configFilename);
                }

            }
            catch { }
        }

        private void WorkFlowLoop_CheckedChanged(object sender, EventArgs e)
        {
            if (WorkFlowLoop.Checked == true & ClientEnabled == true)
            {
                if (MessageBox.Show("Continues Workflow Loop Mode can only be used when the Client Simulator is disabled.\n\nDo you wish to DISABLE the Client Simulator?", "Error!", MessageBoxButtons.YesNo) == DialogResult.Yes)
                {
                    ClientEnabled = false;
                }
                else
                {
                    WorkFlowLoop.Checked = false;
                }
            }
            updateDisplay();
        }

        private void HelpLink_Click(object sender, EventArgs e)
        {
            About ab = new About();
            ab.ShowDialog();
            ab = null;
        }

        private void SeverSimPort_TextChanged(object sender, EventArgs e)
        {

            updateConfig(false);
            updateDisplay();
        }


        private void updated(object sender, KeyEventArgs e)
        {
            updateDisplay();
        }

    }
}