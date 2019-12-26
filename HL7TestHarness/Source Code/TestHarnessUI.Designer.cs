/* Module Header

  $Header:   L:/pvcsrep65/HL7TestHarness/archives/Source Code/TestHarnessUI.Designer.cs-arc   1.34   24 Jul 2007 15:17:52   mwicks  $

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

  $Log:   L:/pvcsrep65/HL7TestHarness/archives/Source Code/TestHarnessUI.Designer.cs-arc  $
 *
 *   Rev 1.34   24 Jul 2007 15:17:52   mwicks
 *updated to include http compression options
 *
 *   Rev 1.33   16 Mar 2007 15:46:02   mwicks
 *updated for the following:
 *1. msg proxy and client sim will replace localhost address names with machine name.
 *2. msg proxy outputs timing and number of messages sent.
 *3. commandline has auto control file.
 *4. GUI msg proxy now shows msgs from client and server systems.
 *5. GUI enable/disable redone to be more clear.
 *6. Results data grid columns re-sizeable
 *7. commandline will now handle all development options that GUI uses.
 *
 *   Rev 1.32   18 Jan 2007 14:20:26   mwicks
 *updated reporting and workflow schemas.
  Revision 1.1.1.1  2006/11/24 18:16:48  deltaware
  Init check in of HL7 Test Harness, version 2.0.3.9. For releases before this version please contact deltaware systems.

 *
 *   Rev 1.31   30 Oct 2006 10:05:34   mwicks
 *updated test data tab to fix resizing issue
 *
 *   Rev 1.30   30 Oct 2006 09:32:56   mwicks
 *updated to add:
 *server simulator port
 *enable/disable client request validation
 *enable/disable server response validation
 *enable/disable message transformations by message proxy
 *
 *   Rev 1.29   27 Sep 2006 15:46:00   mwicks
 *updated:
 *removed LOAD OID functionality
 *add auto file name on report generation.
 *
 *   Rev 1.28   15 Sep 2006 10:27:54   mwicks
 *Updated display of messages in UI
 *
 *   Rev 1.27   11 Sep 2006 16:10:32   mwicks
 *updated tcp monitoring to monitor the dns HostName instead of the localhost name.
 *
 *   Rev 1.26   29 Aug 2006 14:46:40   mwicks
 *Updated to fix some memory issues.
 *
 *   Rev 1.25   28 Aug 2006 14:35:00   mwicks
 *updated to verion 2.0.0.0
 *
 *   Rev 1.24   28 Jun 2006 16:24:38   mwicks
 *removed "All Rights Reserved." from all files.
 *
 *   Rev 1.23   27 Jun 2006 08:52:00   mwicks
 *Updated GUI to include an enable/disable in the status bar 
 *to show the state of the current msgproxy and simulators.
 *
 *   Rev 1.22   26 Jun 2006 13:29:28   mwicks
 *added Lic
 *
 *   Rev 1.21   26 Jun 2006 13:18:26   mwicks
 *Updated License.
*/
namespace HL7TestHarness
{
    partial class TestHarnessUI
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle4 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle5 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle6 = new System.Windows.Forms.DataGridViewCellStyle();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(TestHarnessUI));
            this.splitContainer1 = new System.Windows.Forms.SplitContainer();
            this.TestResults = new System.Windows.Forms.DataGridView();
            this.ResulttoolStrip = new System.Windows.Forms.ToolStrip();
            this.OpenReport = new System.Windows.Forms.ToolStripLabel();
            this.SaveReport = new System.Windows.Forms.ToolStripLabel();
            this.toolStripSeparator1 = new System.Windows.Forms.ToolStripSeparator();
            this.CreateReport = new System.Windows.Forms.ToolStripLabel();
            this.toolStripSeparator9 = new System.Windows.Forms.ToolStripSeparator();
            this.GobalStartButton = new System.Windows.Forms.ToolStripLabel();
            this.GlobalStopButton = new System.Windows.Forms.ToolStripLabel();
            this.toolStripSeparator10 = new System.Windows.Forms.ToolStripSeparator();
            this.HelpLink = new System.Windows.Forms.ToolStripLabel();
            this.ResultStatusBar = new System.Windows.Forms.StatusStrip();
            this.status1 = new System.Windows.Forms.ToolStripStatusLabel();
            this.ConfigTabs = new System.Windows.Forms.TabControl();
            this.MsgProxy = new System.Windows.Forms.TabPage();
            this.tabControl1 = new System.Windows.Forms.TabControl();
            this.Config = new System.Windows.Forms.TabPage();
            this.VirtualServers = new System.Windows.Forms.GroupBox();
            this.VirtualServerData = new System.Windows.Forms.TabControl();
            this.Server1 = new System.Windows.Forms.TabPage();
            this.SimulatorServer1 = new System.Windows.Forms.CheckBox();
            this.RemoteServer_1_psw = new System.Windows.Forms.TextBox();
            this.RemoteServer_1_usr = new System.Windows.Forms.TextBox();
            this.label16 = new System.Windows.Forms.Label();
            this.virtualServer_1 = new System.Windows.Forms.TextBox();
            this.RemoteServer_1 = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.label18 = new System.Windows.Forms.Label();
            this.label19 = new System.Windows.Forms.Label();
            this.Server2 = new System.Windows.Forms.TabPage();
            this.SimulatorServer2 = new System.Windows.Forms.CheckBox();
            this.label20 = new System.Windows.Forms.Label();
            this.label21 = new System.Windows.Forms.Label();
            this.RemoteServer_2_psw = new System.Windows.Forms.TextBox();
            this.RemoteServer_2_usr = new System.Windows.Forms.TextBox();
            this.label14 = new System.Windows.Forms.Label();
            this.label15 = new System.Windows.Forms.Label();
            this.virtualServer_2 = new System.Windows.Forms.TextBox();
            this.RemoteServer_2 = new System.Windows.Forms.TextBox();
            this.Server3 = new System.Windows.Forms.TabPage();
            this.SimulatorServer3 = new System.Windows.Forms.CheckBox();
            this.label22 = new System.Windows.Forms.Label();
            this.label23 = new System.Windows.Forms.Label();
            this.RemoteServer_3_psw = new System.Windows.Forms.TextBox();
            this.RemoteServer_3_usr = new System.Windows.Forms.TextBox();
            this.label12 = new System.Windows.Forms.Label();
            this.label13 = new System.Windows.Forms.Label();
            this.virtualServer_3 = new System.Windows.Forms.TextBox();
            this.RemoteServer_3 = new System.Windows.Forms.TextBox();
            this.Server4 = new System.Windows.Forms.TabPage();
            this.SimulatorServer4 = new System.Windows.Forms.CheckBox();
            this.label24 = new System.Windows.Forms.Label();
            this.label25 = new System.Windows.Forms.Label();
            this.RemoteServer_4_psw = new System.Windows.Forms.TextBox();
            this.RemoteServer_4_usr = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.label5 = new System.Windows.Forms.Label();
            this.virtualServer_4 = new System.Windows.Forms.TextBox();
            this.RemoteServer_4 = new System.Windows.Forms.TextBox();
            this.Server5 = new System.Windows.Forms.TabPage();
            this.SimulatorServer5 = new System.Windows.Forms.CheckBox();
            this.label26 = new System.Windows.Forms.Label();
            this.label27 = new System.Windows.Forms.Label();
            this.RemoteServer_5_psw = new System.Windows.Forms.TextBox();
            this.RemoteServer_5_usr = new System.Windows.Forms.TextBox();
            this.label6 = new System.Windows.Forms.Label();
            this.label7 = new System.Windows.Forms.Label();
            this.virtualServer_5 = new System.Windows.Forms.TextBox();
            this.RemoteServer_5 = new System.Windows.Forms.TextBox();
            this.Server6 = new System.Windows.Forms.TabPage();
            this.SimulatorServer6 = new System.Windows.Forms.CheckBox();
            this.label28 = new System.Windows.Forms.Label();
            this.label29 = new System.Windows.Forms.Label();
            this.RemoteServer_6_psw = new System.Windows.Forms.TextBox();
            this.RemoteServer_6_usr = new System.Windows.Forms.TextBox();
            this.label8 = new System.Windows.Forms.Label();
            this.label9 = new System.Windows.Forms.Label();
            this.virtualServer_6 = new System.Windows.Forms.TextBox();
            this.RemoteServer_6 = new System.Windows.Forms.TextBox();
            this.Server7 = new System.Windows.Forms.TabPage();
            this.SimulatorServer7 = new System.Windows.Forms.CheckBox();
            this.label30 = new System.Windows.Forms.Label();
            this.label31 = new System.Windows.Forms.Label();
            this.RemoteServer_7_psw = new System.Windows.Forms.TextBox();
            this.RemoteServer_7_usr = new System.Windows.Forms.TextBox();
            this.label10 = new System.Windows.Forms.Label();
            this.RemoteServer_7 = new System.Windows.Forms.TextBox();
            this.label11 = new System.Windows.Forms.Label();
            this.virtualServer_7 = new System.Windows.Forms.TextBox();
            this.LocalSettings = new System.Windows.Forms.GroupBox();
            this.constructMsg = new System.Windows.Forms.CheckBox();
            this.validateServer = new System.Windows.Forms.CheckBox();
            this.validateClient = new System.Windows.Forms.CheckBox();
            this.label32 = new System.Windows.Forms.Label();
            this.SeverSimPort = new System.Windows.Forms.TextBox();
            this.label17 = new System.Windows.Forms.Label();
            this.updateSimMsg = new System.Windows.Forms.CheckBox();
            this.label4 = new System.Windows.Forms.Label();
            this.Security_psw = new System.Windows.Forms.TextBox();
            this.WorkFlowLoop = new System.Windows.Forms.CheckBox();
            this.Security_user = new System.Windows.Forms.TextBox();
            this.SingleMsgLoop = new System.Windows.Forms.CheckBox();
            this.SecurityEnable = new System.Windows.Forms.CheckBox();
            this.label1 = new System.Windows.Forms.Label();
            this.localport = new System.Windows.Forms.TextBox();
            this.ClientMsg = new System.Windows.Forms.TabPage();
            this.splitContainer2 = new System.Windows.Forms.SplitContainer();
            this.groupBox2 = new System.Windows.Forms.GroupBox();
            this.ProxyClientRxMsg = new System.Windows.Forms.RichTextBox();
            this.groupBox9 = new System.Windows.Forms.GroupBox();
            this.ProxyClientTxMsg = new System.Windows.Forms.RichTextBox();
            this.ServerMsg = new System.Windows.Forms.TabPage();
            this.splitContainer3 = new System.Windows.Forms.SplitContainer();
            this.groupBox10 = new System.Windows.Forms.GroupBox();
            this.ProxyServerTxMsg = new System.Windows.Forms.RichTextBox();
            this.groupBox11 = new System.Windows.Forms.GroupBox();
            this.ProxyServerRxMsg = new System.Windows.Forms.RichTextBox();
            this.MsgProxyStatusBar = new System.Windows.Forms.StatusStrip();
            this.MsgProxyEnableStatus = new System.Windows.Forms.ToolStripStatusLabel();
            this.MsgProxyStatus = new System.Windows.Forms.ToolStripStatusLabel();
            this.MsgProxyToolBar = new System.Windows.Forms.ToolStrip();
            this.proxyDisabledIcon = new System.Windows.Forms.ToolStripLabel();
            this.proxyEnabledIcon = new System.Windows.Forms.ToolStripLabel();
            this.toolStripSeparator11 = new System.Windows.Forms.ToolStripSeparator();
            this.toolStripProxyNext = new System.Windows.Forms.ToolStripLabel();
            this.toolStripProxyPrev = new System.Windows.Forms.ToolStripLabel();
            this.toolStripSeparator6 = new System.Windows.Forms.ToolStripSeparator();
            this.proxyDisable = new System.Windows.Forms.ToolStripLabel();
            this.proxyEnable = new System.Windows.Forms.ToolStripLabel();
            this.ClientSimTab = new System.Windows.Forms.TabPage();
            this.ClientSimContainer = new System.Windows.Forms.SplitContainer();
            this.groupBox4 = new System.Windows.Forms.GroupBox();
            this.ClientSimTxMsg = new System.Windows.Forms.RichTextBox();
            this.groupBox5 = new System.Windows.Forms.GroupBox();
            this.ClientSimRxMsg = new System.Windows.Forms.RichTextBox();
            this.ClientSimStatusBar = new System.Windows.Forms.StatusStrip();
            this.ClientSimEnableStatus = new System.Windows.Forms.ToolStripStatusLabel();
            this.ClientSimStatus = new System.Windows.Forms.ToolStripStatusLabel();
            this.ClientSimToolBar = new System.Windows.Forms.ToolStrip();
            this.ClientSimDisabledIcon = new System.Windows.Forms.ToolStripLabel();
            this.ClientSimEnabledIcon = new System.Windows.Forms.ToolStripLabel();
            this.toolStripSeparator3 = new System.Windows.Forms.ToolStripSeparator();
            this.toolStripClientNext = new System.Windows.Forms.ToolStripLabel();
            this.toolStripClientPrev = new System.Windows.Forms.ToolStripLabel();
            this.toolStripSeparator7 = new System.Windows.Forms.ToolStripSeparator();
            this.ClientSimDisable = new System.Windows.Forms.ToolStripLabel();
            this.ClientSimEnable = new System.Windows.Forms.ToolStripLabel();
            this.ServerSimTab = new System.Windows.Forms.TabPage();
            this.ServerSimContainer = new System.Windows.Forms.SplitContainer();
            this.groupBox6 = new System.Windows.Forms.GroupBox();
            this.ServerSimRxMsg = new System.Windows.Forms.RichTextBox();
            this.groupBox7 = new System.Windows.Forms.GroupBox();
            this.ServerSimTxMsg = new System.Windows.Forms.RichTextBox();
            this.ServerSimStatusBar = new System.Windows.Forms.StatusStrip();
            this.ServerSimEnableStatus = new System.Windows.Forms.ToolStripStatusLabel();
            this.ServerSimStatus = new System.Windows.Forms.ToolStripStatusLabel();
            this.ServerSimToolBar = new System.Windows.Forms.ToolStrip();
            this.ServerSimEnabledIcon = new System.Windows.Forms.ToolStripLabel();
            this.ServerSimDisabledIcon = new System.Windows.Forms.ToolStripLabel();
            this.toolStripSeparator5 = new System.Windows.Forms.ToolStripSeparator();
            this.toolStripServerNext = new System.Windows.Forms.ToolStripLabel();
            this.toolStripServerPrev = new System.Windows.Forms.ToolStripLabel();
            this.toolStripSeparator8 = new System.Windows.Forms.ToolStripSeparator();
            this.ServerSimDisable = new System.Windows.Forms.ToolStripLabel();
            this.ServerSimEnable = new System.Windows.Forms.ToolStripLabel();
            this.WorkFlowTab = new System.Windows.Forms.TabPage();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.WorkFlowDisplay = new System.Windows.Forms.TreeView();
            this.resultImages = new System.Windows.Forms.ImageList(this.components);
            this.workFlowStatusBar = new System.Windows.Forms.StatusStrip();
            this.WorkFlowToolStrip = new System.Windows.Forms.ToolStrip();
            this.RefreshWorkFlow = new System.Windows.Forms.ToolStripLabel();
            this.toolStripSeparator2 = new System.Windows.Forms.ToolStripSeparator();
            this.StageDataTab = new System.Windows.Forms.TabPage();
            this.panel1 = new System.Windows.Forms.Panel();
            this.panel2 = new System.Windows.Forms.Panel();
            this.groupBox8 = new System.Windows.Forms.GroupBox();
            this.DataStageOutput = new System.Windows.Forms.RichTextBox();
            this.groupBox3 = new System.Windows.Forms.GroupBox();
            this.btnGenerateData = new System.Windows.Forms.Button();
            this.GenerateServerData = new System.Windows.Forms.CheckBox();
            this.GenerateClientData = new System.Windows.Forms.CheckBox();
            this.DataStageStatusBar = new System.Windows.Forms.StatusStrip();
            this.DataStageStatusLabel = new System.Windows.Forms.ToolStripStatusLabel();
            this.DataStageStrip = new System.Windows.Forms.ToolStrip();
            this.toolStripLabel1 = new System.Windows.Forms.ToolStripLabel();
            this.toolStripLabel2 = new System.Windows.Forms.ToolStripLabel();
            this.toolStripSeparator4 = new System.Windows.Forms.ToolStripSeparator();
            this.toolStripDropDownButton1 = new System.Windows.Forms.ToolStripDropDownButton();
            this.toolStripMenuItem1 = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem2 = new System.Windows.Forms.ToolStripMenuItem();
            this.OpenFile = new System.Windows.Forms.OpenFileDialog();
            this.SaveFile = new System.Windows.Forms.SaveFileDialog();
            this.TestDataSet = new System.Data.DataSet();
            this.compressionEnabled = new System.Windows.Forms.CheckBox();
            this.splitContainer1.Panel1.SuspendLayout();
            this.splitContainer1.Panel2.SuspendLayout();
            this.splitContainer1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.TestResults)).BeginInit();
            this.ResulttoolStrip.SuspendLayout();
            this.ResultStatusBar.SuspendLayout();
            this.ConfigTabs.SuspendLayout();
            this.MsgProxy.SuspendLayout();
            this.tabControl1.SuspendLayout();
            this.Config.SuspendLayout();
            this.VirtualServers.SuspendLayout();
            this.VirtualServerData.SuspendLayout();
            this.Server1.SuspendLayout();
            this.Server2.SuspendLayout();
            this.Server3.SuspendLayout();
            this.Server4.SuspendLayout();
            this.Server5.SuspendLayout();
            this.Server6.SuspendLayout();
            this.Server7.SuspendLayout();
            this.LocalSettings.SuspendLayout();
            this.ClientMsg.SuspendLayout();
            this.splitContainer2.Panel1.SuspendLayout();
            this.splitContainer2.Panel2.SuspendLayout();
            this.splitContainer2.SuspendLayout();
            this.groupBox2.SuspendLayout();
            this.groupBox9.SuspendLayout();
            this.ServerMsg.SuspendLayout();
            this.splitContainer3.Panel1.SuspendLayout();
            this.splitContainer3.Panel2.SuspendLayout();
            this.splitContainer3.SuspendLayout();
            this.groupBox10.SuspendLayout();
            this.groupBox11.SuspendLayout();
            this.MsgProxyStatusBar.SuspendLayout();
            this.MsgProxyToolBar.SuspendLayout();
            this.ClientSimTab.SuspendLayout();
            this.ClientSimContainer.Panel1.SuspendLayout();
            this.ClientSimContainer.Panel2.SuspendLayout();
            this.ClientSimContainer.SuspendLayout();
            this.groupBox4.SuspendLayout();
            this.groupBox5.SuspendLayout();
            this.ClientSimStatusBar.SuspendLayout();
            this.ClientSimToolBar.SuspendLayout();
            this.ServerSimTab.SuspendLayout();
            this.ServerSimContainer.Panel1.SuspendLayout();
            this.ServerSimContainer.Panel2.SuspendLayout();
            this.ServerSimContainer.SuspendLayout();
            this.groupBox6.SuspendLayout();
            this.groupBox7.SuspendLayout();
            this.ServerSimStatusBar.SuspendLayout();
            this.ServerSimToolBar.SuspendLayout();
            this.WorkFlowTab.SuspendLayout();
            this.groupBox1.SuspendLayout();
            this.WorkFlowToolStrip.SuspendLayout();
            this.StageDataTab.SuspendLayout();
            this.panel1.SuspendLayout();
            this.panel2.SuspendLayout();
            this.groupBox8.SuspendLayout();
            this.groupBox3.SuspendLayout();
            this.DataStageStatusBar.SuspendLayout();
            this.DataStageStrip.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.TestDataSet)).BeginInit();
            this.SuspendLayout();
            // 
            // splitContainer1
            // 
            this.splitContainer1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.splitContainer1.Location = new System.Drawing.Point(0, 0);
            this.splitContainer1.Name = "splitContainer1";
            // 
            // splitContainer1.Panel1
            // 
            this.splitContainer1.Panel1.Controls.Add(this.TestResults);
            this.splitContainer1.Panel1.Controls.Add(this.ResulttoolStrip);
            this.splitContainer1.Panel1.Controls.Add(this.ResultStatusBar);
            // 
            // splitContainer1.Panel2
            // 
            this.splitContainer1.Panel2.Controls.Add(this.ConfigTabs);
            this.splitContainer1.Size = new System.Drawing.Size(804, 555);
            this.splitContainer1.SplitterDistance = 361;
            this.splitContainer1.TabIndex = 0;
            // 
            // TestResults
            // 
            this.TestResults.AllowUserToAddRows = false;
            this.TestResults.AllowUserToDeleteRows = false;
            this.TestResults.AllowUserToOrderColumns = true;
            this.TestResults.AllowUserToResizeRows = false;
            this.TestResults.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill;
            this.TestResults.BackgroundColor = System.Drawing.SystemColors.HighlightText;
            this.TestResults.BorderStyle = System.Windows.Forms.BorderStyle.None;
            dataGridViewCellStyle4.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle4.BackColor = System.Drawing.SystemColors.Control;
            dataGridViewCellStyle4.Font = new System.Drawing.Font("Tahoma", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            dataGridViewCellStyle4.ForeColor = System.Drawing.SystemColors.WindowText;
            dataGridViewCellStyle4.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle4.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle4.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.TestResults.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle4;
            this.TestResults.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dataGridViewCellStyle5.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle5.BackColor = System.Drawing.SystemColors.Window;
            dataGridViewCellStyle5.Font = new System.Drawing.Font("Tahoma", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            dataGridViewCellStyle5.ForeColor = System.Drawing.SystemColors.ControlText;
            dataGridViewCellStyle5.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle5.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle5.WrapMode = System.Windows.Forms.DataGridViewTriState.False;
            this.TestResults.DefaultCellStyle = dataGridViewCellStyle5;
            this.TestResults.Dock = System.Windows.Forms.DockStyle.Fill;
            this.TestResults.Location = new System.Drawing.Point(0, 25);
            this.TestResults.Name = "TestResults";
            this.TestResults.ReadOnly = true;
            dataGridViewCellStyle6.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle6.BackColor = System.Drawing.SystemColors.Control;
            dataGridViewCellStyle6.Font = new System.Drawing.Font("Courier New", 6F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            dataGridViewCellStyle6.ForeColor = System.Drawing.SystemColors.WindowText;
            dataGridViewCellStyle6.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle6.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle6.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.TestResults.RowHeadersDefaultCellStyle = dataGridViewCellStyle6;
            this.TestResults.RowHeadersVisible = false;
            this.TestResults.Size = new System.Drawing.Size(361, 508);
            this.TestResults.TabIndex = 2;
            // 
            // ResulttoolStrip
            // 
            this.ResulttoolStrip.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.OpenReport,
            this.SaveReport,
            this.toolStripSeparator1,
            this.CreateReport,
            this.toolStripSeparator9,
            this.GobalStartButton,
            this.GlobalStopButton,
            this.toolStripSeparator10,
            this.HelpLink});
            this.ResulttoolStrip.Location = new System.Drawing.Point(0, 0);
            this.ResulttoolStrip.Name = "ResulttoolStrip";
            this.ResulttoolStrip.Size = new System.Drawing.Size(361, 25);
            this.ResulttoolStrip.TabIndex = 1;
            this.ResulttoolStrip.Text = "toolStrip1";
            // 
            // OpenReport
            // 
            this.OpenReport.IsLink = true;
            this.OpenReport.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline;
            this.OpenReport.Name = "OpenReport";
            this.OpenReport.Size = new System.Drawing.Size(33, 22);
            this.OpenReport.Text = "Open";
            this.OpenReport.Click += new System.EventHandler(this.workflowOpen);
            // 
            // SaveReport
            // 
            this.SaveReport.IsLink = true;
            this.SaveReport.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline;
            this.SaveReport.Name = "SaveReport";
            this.SaveReport.Size = new System.Drawing.Size(31, 22);
            this.SaveReport.Text = "Save";
            this.SaveReport.Click += new System.EventHandler(this.SaveResults);
            // 
            // toolStripSeparator1
            // 
            this.toolStripSeparator1.Name = "toolStripSeparator1";
            this.toolStripSeparator1.Size = new System.Drawing.Size(6, 25);
            // 
            // CreateReport
            // 
            this.CreateReport.IsLink = true;
            this.CreateReport.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline;
            this.CreateReport.Name = "CreateReport";
            this.CreateReport.Size = new System.Drawing.Size(76, 22);
            this.CreateReport.Text = "Create Report";
            this.CreateReport.Click += new System.EventHandler(this.CreateHtmlReport);
            // 
            // toolStripSeparator9
            // 
            this.toolStripSeparator9.Name = "toolStripSeparator9";
            this.toolStripSeparator9.Size = new System.Drawing.Size(6, 25);
            // 
            // GobalStartButton
            // 
            this.GobalStartButton.IsLink = true;
            this.GobalStartButton.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline;
            this.GobalStartButton.Name = "GobalStartButton";
            this.GobalStartButton.Size = new System.Drawing.Size(31, 22);
            this.GobalStartButton.Text = "Start";
            this.GobalStartButton.Click += new System.EventHandler(this.GlobalStart);
            // 
            // GlobalStopButton
            // 
            this.GlobalStopButton.IsLink = true;
            this.GlobalStopButton.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline;
            this.GlobalStopButton.Name = "GlobalStopButton";
            this.GlobalStopButton.Size = new System.Drawing.Size(29, 22);
            this.GlobalStopButton.Text = "Stop";
            this.GlobalStopButton.Visible = false;
            this.GlobalStopButton.Click += new System.EventHandler(this.GlobalStop);
            // 
            // toolStripSeparator10
            // 
            this.toolStripSeparator10.Name = "toolStripSeparator10";
            this.toolStripSeparator10.Size = new System.Drawing.Size(6, 25);
            // 
            // HelpLink
            // 
            this.HelpLink.IsLink = true;
            this.HelpLink.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline;
            this.HelpLink.Name = "HelpLink";
            this.HelpLink.Size = new System.Drawing.Size(28, 22);
            this.HelpLink.Text = "Help";
            this.HelpLink.Click += new System.EventHandler(this.HelpLink_Click);
            // 
            // ResultStatusBar
            // 
            this.ResultStatusBar.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.status1});
            this.ResultStatusBar.Location = new System.Drawing.Point(0, 533);
            this.ResultStatusBar.Name = "ResultStatusBar";
            this.ResultStatusBar.Size = new System.Drawing.Size(361, 22);
            this.ResultStatusBar.TabIndex = 0;
            this.ResultStatusBar.Text = "statusStrip1";
            // 
            // status1
            // 
            this.status1.ActiveLinkColor = System.Drawing.Color.Red;
            this.status1.ForeColor = System.Drawing.Color.Black;
            this.status1.Name = "status1";
            this.status1.Size = new System.Drawing.Size(66, 17);
            this.status1.Text = "Not Running";
            // 
            // ConfigTabs
            // 
            this.ConfigTabs.Controls.Add(this.MsgProxy);
            this.ConfigTabs.Controls.Add(this.ClientSimTab);
            this.ConfigTabs.Controls.Add(this.ServerSimTab);
            this.ConfigTabs.Controls.Add(this.WorkFlowTab);
            this.ConfigTabs.Controls.Add(this.StageDataTab);
            this.ConfigTabs.Dock = System.Windows.Forms.DockStyle.Fill;
            this.ConfigTabs.Location = new System.Drawing.Point(0, 0);
            this.ConfigTabs.Name = "ConfigTabs";
            this.ConfigTabs.SelectedIndex = 0;
            this.ConfigTabs.Size = new System.Drawing.Size(439, 555);
            this.ConfigTabs.TabIndex = 0;
            // 
            // MsgProxy
            // 
            this.MsgProxy.AutoScroll = true;
            this.MsgProxy.Controls.Add(this.tabControl1);
            this.MsgProxy.Controls.Add(this.MsgProxyStatusBar);
            this.MsgProxy.Controls.Add(this.MsgProxyToolBar);
            this.MsgProxy.Location = new System.Drawing.Point(4, 22);
            this.MsgProxy.Name = "MsgProxy";
            this.MsgProxy.Padding = new System.Windows.Forms.Padding(3);
            this.MsgProxy.Size = new System.Drawing.Size(431, 529);
            this.MsgProxy.TabIndex = 4;
            this.MsgProxy.Text = "Message Proxy";
            this.MsgProxy.UseVisualStyleBackColor = true;
            // 
            // tabControl1
            // 
            this.tabControl1.Controls.Add(this.Config);
            this.tabControl1.Controls.Add(this.ClientMsg);
            this.tabControl1.Controls.Add(this.ServerMsg);
            this.tabControl1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tabControl1.Location = new System.Drawing.Point(3, 28);
            this.tabControl1.Name = "tabControl1";
            this.tabControl1.SelectedIndex = 0;
            this.tabControl1.Size = new System.Drawing.Size(425, 476);
            this.tabControl1.TabIndex = 29;
            // 
            // Config
            // 
            this.Config.Controls.Add(this.VirtualServers);
            this.Config.Controls.Add(this.LocalSettings);
            this.Config.Location = new System.Drawing.Point(4, 22);
            this.Config.Name = "Config";
            this.Config.Padding = new System.Windows.Forms.Padding(3);
            this.Config.Size = new System.Drawing.Size(417, 450);
            this.Config.TabIndex = 0;
            this.Config.Text = "Configuration";
            this.Config.UseVisualStyleBackColor = true;
            // 
            // VirtualServers
            // 
            this.VirtualServers.Controls.Add(this.VirtualServerData);
            this.VirtualServers.Dock = System.Windows.Forms.DockStyle.Top;
            this.VirtualServers.Location = new System.Drawing.Point(3, 131);
            this.VirtualServers.Name = "VirtualServers";
            this.VirtualServers.Size = new System.Drawing.Size(411, 213);
            this.VirtualServers.TabIndex = 27;
            this.VirtualServers.TabStop = false;
            this.VirtualServers.Text = "Virtual Servers";
            // 
            // VirtualServerData
            // 
            this.VirtualServerData.Controls.Add(this.Server1);
            this.VirtualServerData.Controls.Add(this.Server2);
            this.VirtualServerData.Controls.Add(this.Server3);
            this.VirtualServerData.Controls.Add(this.Server4);
            this.VirtualServerData.Controls.Add(this.Server5);
            this.VirtualServerData.Controls.Add(this.Server6);
            this.VirtualServerData.Controls.Add(this.Server7);
            this.VirtualServerData.Dock = System.Windows.Forms.DockStyle.Fill;
            this.VirtualServerData.Location = new System.Drawing.Point(3, 16);
            this.VirtualServerData.Name = "VirtualServerData";
            this.VirtualServerData.SelectedIndex = 0;
            this.VirtualServerData.Size = new System.Drawing.Size(405, 194);
            this.VirtualServerData.TabIndex = 26;
            this.VirtualServerData.KeyUp += new System.Windows.Forms.KeyEventHandler(this.updated);
            // 
            // Server1
            // 
            this.Server1.Controls.Add(this.SimulatorServer1);
            this.Server1.Controls.Add(this.RemoteServer_1_psw);
            this.Server1.Controls.Add(this.RemoteServer_1_usr);
            this.Server1.Controls.Add(this.label16);
            this.Server1.Controls.Add(this.virtualServer_1);
            this.Server1.Controls.Add(this.RemoteServer_1);
            this.Server1.Controls.Add(this.label3);
            this.Server1.Controls.Add(this.label18);
            this.Server1.Controls.Add(this.label19);
            this.Server1.Location = new System.Drawing.Point(4, 22);
            this.Server1.Name = "Server1";
            this.Server1.Padding = new System.Windows.Forms.Padding(3);
            this.Server1.Size = new System.Drawing.Size(397, 168);
            this.Server1.TabIndex = 0;
            this.Server1.Text = "Server 1";
            this.Server1.UseVisualStyleBackColor = true;
            // 
            // SimulatorServer1
            // 
            this.SimulatorServer1.AutoSize = true;
            this.SimulatorServer1.Checked = true;
            this.SimulatorServer1.CheckState = System.Windows.Forms.CheckState.Checked;
            this.SimulatorServer1.Location = new System.Drawing.Point(21, 64);
            this.SimulatorServer1.Name = "SimulatorServer1";
            this.SimulatorServer1.Size = new System.Drawing.Size(125, 17);
            this.SimulatorServer1.TabIndex = 15;
            this.SimulatorServer1.Text = "Use Server Simulator";
            this.SimulatorServer1.UseVisualStyleBackColor = true;
            this.SimulatorServer1.CheckedChanged += new System.EventHandler(this.SimulateServer);
            // 
            // RemoteServer_1_psw
            // 
            this.RemoteServer_1_psw.Enabled = false;
            this.RemoteServer_1_psw.Location = new System.Drawing.Point(106, 134);
            this.RemoteServer_1_psw.Name = "RemoteServer_1_psw";
            this.RemoteServer_1_psw.PasswordChar = '*';
            this.RemoteServer_1_psw.Size = new System.Drawing.Size(114, 20);
            this.RemoteServer_1_psw.TabIndex = 12;
            this.RemoteServer_1_psw.Visible = false;
            // 
            // RemoteServer_1_usr
            // 
            this.RemoteServer_1_usr.Enabled = false;
            this.RemoteServer_1_usr.Location = new System.Drawing.Point(106, 108);
            this.RemoteServer_1_usr.Name = "RemoteServer_1_usr";
            this.RemoteServer_1_usr.Size = new System.Drawing.Size(114, 20);
            this.RemoteServer_1_usr.TabIndex = 11;
            this.RemoteServer_1_usr.Visible = false;
            // 
            // label16
            // 
            this.label16.AutoSize = true;
            this.label16.Location = new System.Drawing.Point(3, 48);
            this.label16.Name = "label16";
            this.label16.Size = new System.Drawing.Size(106, 13);
            this.label16.TabIndex = 10;
            this.label16.Text = "Remote Server : Port";
            // 
            // virtualServer_1
            // 
            this.virtualServer_1.AcceptsReturn = true;
            this.virtualServer_1.Location = new System.Drawing.Point(20, 20);
            this.virtualServer_1.Name = "virtualServer_1";
            this.virtualServer_1.Size = new System.Drawing.Size(200, 20);
            this.virtualServer_1.TabIndex = 4;
            this.virtualServer_1.Text = "http://ClientReg_Server";
            // 
            // RemoteServer_1
            // 
            this.RemoteServer_1.Enabled = false;
            this.RemoteServer_1.Location = new System.Drawing.Point(20, 82);
            this.RemoteServer_1.Name = "RemoteServer_1";
            this.RemoteServer_1.Size = new System.Drawing.Size(200, 20);
            this.RemoteServer_1.TabIndex = 6;
            this.RemoteServer_1.Text = "http://localhost:5050/";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(3, 3);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(98, 13);
            this.label3.TabIndex = 5;
            this.label3.Text = "Virtual Server : Port";
            // 
            // label18
            // 
            this.label18.AutoSize = true;
            this.label18.Location = new System.Drawing.Point(41, 137);
            this.label18.Name = "label18";
            this.label18.Size = new System.Drawing.Size(53, 13);
            this.label18.TabIndex = 14;
            this.label18.Text = "Password";
            this.label18.Visible = false;
            // 
            // label19
            // 
            this.label19.AutoSize = true;
            this.label19.Location = new System.Drawing.Point(38, 111);
            this.label19.Name = "label19";
            this.label19.Size = new System.Drawing.Size(60, 13);
            this.label19.TabIndex = 13;
            this.label19.Text = "User Name";
            this.label19.Visible = false;
            // 
            // Server2
            // 
            this.Server2.Controls.Add(this.SimulatorServer2);
            this.Server2.Controls.Add(this.label20);
            this.Server2.Controls.Add(this.label21);
            this.Server2.Controls.Add(this.RemoteServer_2_psw);
            this.Server2.Controls.Add(this.RemoteServer_2_usr);
            this.Server2.Controls.Add(this.label14);
            this.Server2.Controls.Add(this.label15);
            this.Server2.Controls.Add(this.virtualServer_2);
            this.Server2.Controls.Add(this.RemoteServer_2);
            this.Server2.Location = new System.Drawing.Point(4, 22);
            this.Server2.Name = "Server2";
            this.Server2.Padding = new System.Windows.Forms.Padding(3);
            this.Server2.Size = new System.Drawing.Size(397, 168);
            this.Server2.TabIndex = 1;
            this.Server2.Text = "Server 2";
            this.Server2.UseVisualStyleBackColor = true;
            // 
            // SimulatorServer2
            // 
            this.SimulatorServer2.AutoSize = true;
            this.SimulatorServer2.Checked = true;
            this.SimulatorServer2.CheckState = System.Windows.Forms.CheckState.Checked;
            this.SimulatorServer2.Location = new System.Drawing.Point(21, 64);
            this.SimulatorServer2.Name = "SimulatorServer2";
            this.SimulatorServer2.Size = new System.Drawing.Size(125, 17);
            this.SimulatorServer2.TabIndex = 19;
            this.SimulatorServer2.Text = "Use Server Simulator";
            this.SimulatorServer2.UseVisualStyleBackColor = true;
            this.SimulatorServer2.CheckedChanged += new System.EventHandler(this.SimulateServer);
            // 
            // label20
            // 
            this.label20.AutoSize = true;
            this.label20.Location = new System.Drawing.Point(41, 137);
            this.label20.Name = "label20";
            this.label20.Size = new System.Drawing.Size(53, 13);
            this.label20.TabIndex = 18;
            this.label20.Text = "Password";
            this.label20.Visible = false;
            // 
            // label21
            // 
            this.label21.AutoSize = true;
            this.label21.Location = new System.Drawing.Point(38, 111);
            this.label21.Name = "label21";
            this.label21.Size = new System.Drawing.Size(60, 13);
            this.label21.TabIndex = 17;
            this.label21.Text = "User Name";
            this.label21.Visible = false;
            // 
            // RemoteServer_2_psw
            // 
            this.RemoteServer_2_psw.Location = new System.Drawing.Point(106, 134);
            this.RemoteServer_2_psw.Name = "RemoteServer_2_psw";
            this.RemoteServer_2_psw.PasswordChar = '*';
            this.RemoteServer_2_psw.Size = new System.Drawing.Size(114, 20);
            this.RemoteServer_2_psw.TabIndex = 16;
            this.RemoteServer_2_psw.Visible = false;
            // 
            // RemoteServer_2_usr
            // 
            this.RemoteServer_2_usr.Location = new System.Drawing.Point(106, 108);
            this.RemoteServer_2_usr.Name = "RemoteServer_2_usr";
            this.RemoteServer_2_usr.Size = new System.Drawing.Size(114, 20);
            this.RemoteServer_2_usr.TabIndex = 15;
            this.RemoteServer_2_usr.Visible = false;
            // 
            // label14
            // 
            this.label14.AutoSize = true;
            this.label14.Location = new System.Drawing.Point(3, 3);
            this.label14.Name = "label14";
            this.label14.Size = new System.Drawing.Size(98, 13);
            this.label14.TabIndex = 8;
            this.label14.Text = "Virtual Server : Port";
            // 
            // label15
            // 
            this.label15.AutoSize = true;
            this.label15.Location = new System.Drawing.Point(3, 48);
            this.label15.Name = "label15";
            this.label15.Size = new System.Drawing.Size(106, 13);
            this.label15.TabIndex = 9;
            this.label15.Text = "Remote Server : Port";
            // 
            // virtualServer_2
            // 
            this.virtualServer_2.Location = new System.Drawing.Point(20, 20);
            this.virtualServer_2.Name = "virtualServer_2";
            this.virtualServer_2.Size = new System.Drawing.Size(200, 20);
            this.virtualServer_2.TabIndex = 9;
            this.virtualServer_2.Text = "http://DIS_Server";
            // 
            // RemoteServer_2
            // 
            this.RemoteServer_2.Location = new System.Drawing.Point(20, 82);
            this.RemoteServer_2.Name = "RemoteServer_2";
            this.RemoteServer_2.Size = new System.Drawing.Size(200, 20);
            this.RemoteServer_2.TabIndex = 10;
            this.RemoteServer_2.Text = "http://localhost:5050/";
            // 
            // Server3
            // 
            this.Server3.Controls.Add(this.SimulatorServer3);
            this.Server3.Controls.Add(this.label22);
            this.Server3.Controls.Add(this.label23);
            this.Server3.Controls.Add(this.RemoteServer_3_psw);
            this.Server3.Controls.Add(this.RemoteServer_3_usr);
            this.Server3.Controls.Add(this.label12);
            this.Server3.Controls.Add(this.label13);
            this.Server3.Controls.Add(this.virtualServer_3);
            this.Server3.Controls.Add(this.RemoteServer_3);
            this.Server3.Location = new System.Drawing.Point(4, 22);
            this.Server3.Name = "Server3";
            this.Server3.Padding = new System.Windows.Forms.Padding(3);
            this.Server3.Size = new System.Drawing.Size(397, 168);
            this.Server3.TabIndex = 2;
            this.Server3.Text = "Server 3";
            this.Server3.UseVisualStyleBackColor = true;
            // 
            // SimulatorServer3
            // 
            this.SimulatorServer3.AutoSize = true;
            this.SimulatorServer3.Checked = true;
            this.SimulatorServer3.CheckState = System.Windows.Forms.CheckState.Checked;
            this.SimulatorServer3.Location = new System.Drawing.Point(21, 64);
            this.SimulatorServer3.Name = "SimulatorServer3";
            this.SimulatorServer3.Size = new System.Drawing.Size(125, 17);
            this.SimulatorServer3.TabIndex = 19;
            this.SimulatorServer3.Text = "Use Server Simulator";
            this.SimulatorServer3.UseVisualStyleBackColor = true;
            this.SimulatorServer3.CheckedChanged += new System.EventHandler(this.SimulateServer);
            // 
            // label22
            // 
            this.label22.AutoSize = true;
            this.label22.Location = new System.Drawing.Point(41, 137);
            this.label22.Name = "label22";
            this.label22.Size = new System.Drawing.Size(53, 13);
            this.label22.TabIndex = 18;
            this.label22.Text = "Password";
            this.label22.Visible = false;
            // 
            // label23
            // 
            this.label23.AutoSize = true;
            this.label23.Location = new System.Drawing.Point(38, 111);
            this.label23.Name = "label23";
            this.label23.Size = new System.Drawing.Size(60, 13);
            this.label23.TabIndex = 17;
            this.label23.Text = "User Name";
            this.label23.Visible = false;
            // 
            // RemoteServer_3_psw
            // 
            this.RemoteServer_3_psw.Location = new System.Drawing.Point(106, 134);
            this.RemoteServer_3_psw.Name = "RemoteServer_3_psw";
            this.RemoteServer_3_psw.PasswordChar = '*';
            this.RemoteServer_3_psw.Size = new System.Drawing.Size(114, 20);
            this.RemoteServer_3_psw.TabIndex = 16;
            this.RemoteServer_3_psw.Visible = false;
            // 
            // RemoteServer_3_usr
            // 
            this.RemoteServer_3_usr.Location = new System.Drawing.Point(106, 108);
            this.RemoteServer_3_usr.Name = "RemoteServer_3_usr";
            this.RemoteServer_3_usr.Size = new System.Drawing.Size(114, 20);
            this.RemoteServer_3_usr.TabIndex = 15;
            this.RemoteServer_3_usr.Visible = false;
            // 
            // label12
            // 
            this.label12.AutoSize = true;
            this.label12.Location = new System.Drawing.Point(3, 3);
            this.label12.Name = "label12";
            this.label12.Size = new System.Drawing.Size(98, 13);
            this.label12.TabIndex = 8;
            this.label12.Text = "Virtual Server : Port";
            // 
            // label13
            // 
            this.label13.AutoSize = true;
            this.label13.Location = new System.Drawing.Point(3, 48);
            this.label13.Name = "label13";
            this.label13.Size = new System.Drawing.Size(106, 13);
            this.label13.TabIndex = 9;
            this.label13.Text = "Remote Server : Port";
            // 
            // virtualServer_3
            // 
            this.virtualServer_3.Location = new System.Drawing.Point(20, 20);
            this.virtualServer_3.Name = "virtualServer_3";
            this.virtualServer_3.Size = new System.Drawing.Size(200, 20);
            this.virtualServer_3.TabIndex = 12;
            this.virtualServer_3.Text = "http://localhost:8080/DIS_Server";
            // 
            // RemoteServer_3
            // 
            this.RemoteServer_3.Location = new System.Drawing.Point(20, 82);
            this.RemoteServer_3.Name = "RemoteServer_3";
            this.RemoteServer_3.Size = new System.Drawing.Size(200, 20);
            this.RemoteServer_3.TabIndex = 13;
            // 
            // Server4
            // 
            this.Server4.Controls.Add(this.SimulatorServer4);
            this.Server4.Controls.Add(this.label24);
            this.Server4.Controls.Add(this.label25);
            this.Server4.Controls.Add(this.RemoteServer_4_psw);
            this.Server4.Controls.Add(this.RemoteServer_4_usr);
            this.Server4.Controls.Add(this.label2);
            this.Server4.Controls.Add(this.label5);
            this.Server4.Controls.Add(this.virtualServer_4);
            this.Server4.Controls.Add(this.RemoteServer_4);
            this.Server4.Location = new System.Drawing.Point(4, 22);
            this.Server4.Name = "Server4";
            this.Server4.Padding = new System.Windows.Forms.Padding(3);
            this.Server4.Size = new System.Drawing.Size(397, 168);
            this.Server4.TabIndex = 3;
            this.Server4.Text = "Server 4";
            this.Server4.UseVisualStyleBackColor = true;
            // 
            // SimulatorServer4
            // 
            this.SimulatorServer4.AutoSize = true;
            this.SimulatorServer4.Checked = true;
            this.SimulatorServer4.CheckState = System.Windows.Forms.CheckState.Checked;
            this.SimulatorServer4.Location = new System.Drawing.Point(21, 64);
            this.SimulatorServer4.Name = "SimulatorServer4";
            this.SimulatorServer4.Size = new System.Drawing.Size(125, 17);
            this.SimulatorServer4.TabIndex = 21;
            this.SimulatorServer4.Text = "Use Server Simulator";
            this.SimulatorServer4.UseVisualStyleBackColor = true;
            this.SimulatorServer4.CheckedChanged += new System.EventHandler(this.SimulateServer);
            // 
            // label24
            // 
            this.label24.AutoSize = true;
            this.label24.Location = new System.Drawing.Point(41, 137);
            this.label24.Name = "label24";
            this.label24.Size = new System.Drawing.Size(53, 13);
            this.label24.TabIndex = 20;
            this.label24.Text = "Password";
            this.label24.Visible = false;
            // 
            // label25
            // 
            this.label25.AutoSize = true;
            this.label25.Location = new System.Drawing.Point(38, 111);
            this.label25.Name = "label25";
            this.label25.Size = new System.Drawing.Size(60, 13);
            this.label25.TabIndex = 19;
            this.label25.Text = "User Name";
            this.label25.Visible = false;
            // 
            // RemoteServer_4_psw
            // 
            this.RemoteServer_4_psw.Location = new System.Drawing.Point(106, 134);
            this.RemoteServer_4_psw.Name = "RemoteServer_4_psw";
            this.RemoteServer_4_psw.PasswordChar = '*';
            this.RemoteServer_4_psw.Size = new System.Drawing.Size(114, 20);
            this.RemoteServer_4_psw.TabIndex = 18;
            this.RemoteServer_4_psw.Visible = false;
            // 
            // RemoteServer_4_usr
            // 
            this.RemoteServer_4_usr.Location = new System.Drawing.Point(106, 108);
            this.RemoteServer_4_usr.Name = "RemoteServer_4_usr";
            this.RemoteServer_4_usr.Size = new System.Drawing.Size(114, 20);
            this.RemoteServer_4_usr.TabIndex = 17;
            this.RemoteServer_4_usr.Visible = false;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(3, 3);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(98, 13);
            this.label2.TabIndex = 8;
            this.label2.Text = "Virtual Server : Port";
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(3, 48);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(106, 13);
            this.label5.TabIndex = 9;
            this.label5.Text = "Remote Server : Port";
            // 
            // virtualServer_4
            // 
            this.virtualServer_4.Location = new System.Drawing.Point(20, 20);
            this.virtualServer_4.Name = "virtualServer_4";
            this.virtualServer_4.Size = new System.Drawing.Size(200, 20);
            this.virtualServer_4.TabIndex = 15;
            this.virtualServer_4.Text = "http://localhost:8080/ClientReg_Server";
            // 
            // RemoteServer_4
            // 
            this.RemoteServer_4.Location = new System.Drawing.Point(20, 82);
            this.RemoteServer_4.Name = "RemoteServer_4";
            this.RemoteServer_4.Size = new System.Drawing.Size(200, 20);
            this.RemoteServer_4.TabIndex = 16;
            // 
            // Server5
            // 
            this.Server5.Controls.Add(this.SimulatorServer5);
            this.Server5.Controls.Add(this.label26);
            this.Server5.Controls.Add(this.label27);
            this.Server5.Controls.Add(this.RemoteServer_5_psw);
            this.Server5.Controls.Add(this.RemoteServer_5_usr);
            this.Server5.Controls.Add(this.label6);
            this.Server5.Controls.Add(this.label7);
            this.Server5.Controls.Add(this.virtualServer_5);
            this.Server5.Controls.Add(this.RemoteServer_5);
            this.Server5.Location = new System.Drawing.Point(4, 22);
            this.Server5.Name = "Server5";
            this.Server5.Padding = new System.Windows.Forms.Padding(3);
            this.Server5.Size = new System.Drawing.Size(397, 168);
            this.Server5.TabIndex = 4;
            this.Server5.Text = "Server 5";
            this.Server5.UseVisualStyleBackColor = true;
            // 
            // SimulatorServer5
            // 
            this.SimulatorServer5.AutoSize = true;
            this.SimulatorServer5.Checked = true;
            this.SimulatorServer5.CheckState = System.Windows.Forms.CheckState.Checked;
            this.SimulatorServer5.Location = new System.Drawing.Point(21, 64);
            this.SimulatorServer5.Name = "SimulatorServer5";
            this.SimulatorServer5.Size = new System.Drawing.Size(125, 17);
            this.SimulatorServer5.TabIndex = 24;
            this.SimulatorServer5.Text = "Use Server Simulator";
            this.SimulatorServer5.UseVisualStyleBackColor = true;
            this.SimulatorServer5.CheckedChanged += new System.EventHandler(this.SimulateServer);
            // 
            // label26
            // 
            this.label26.AutoSize = true;
            this.label26.Location = new System.Drawing.Point(41, 137);
            this.label26.Name = "label26";
            this.label26.Size = new System.Drawing.Size(53, 13);
            this.label26.TabIndex = 23;
            this.label26.Text = "Password";
            this.label26.Visible = false;
            // 
            // label27
            // 
            this.label27.AutoSize = true;
            this.label27.Location = new System.Drawing.Point(38, 111);
            this.label27.Name = "label27";
            this.label27.Size = new System.Drawing.Size(60, 13);
            this.label27.TabIndex = 22;
            this.label27.Text = "User Name";
            this.label27.Visible = false;
            // 
            // RemoteServer_5_psw
            // 
            this.RemoteServer_5_psw.Location = new System.Drawing.Point(106, 134);
            this.RemoteServer_5_psw.Name = "RemoteServer_5_psw";
            this.RemoteServer_5_psw.PasswordChar = '*';
            this.RemoteServer_5_psw.Size = new System.Drawing.Size(114, 20);
            this.RemoteServer_5_psw.TabIndex = 21;
            this.RemoteServer_5_psw.Visible = false;
            // 
            // RemoteServer_5_usr
            // 
            this.RemoteServer_5_usr.Location = new System.Drawing.Point(106, 108);
            this.RemoteServer_5_usr.Name = "RemoteServer_5_usr";
            this.RemoteServer_5_usr.Size = new System.Drawing.Size(114, 20);
            this.RemoteServer_5_usr.TabIndex = 20;
            this.RemoteServer_5_usr.Visible = false;
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(3, 3);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(98, 13);
            this.label6.TabIndex = 8;
            this.label6.Text = "Virtual Server : Port";
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Location = new System.Drawing.Point(3, 48);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(106, 13);
            this.label7.TabIndex = 9;
            this.label7.Text = "Remote Server : Port";
            // 
            // virtualServer_5
            // 
            this.virtualServer_5.Location = new System.Drawing.Point(20, 20);
            this.virtualServer_5.Name = "virtualServer_5";
            this.virtualServer_5.Size = new System.Drawing.Size(200, 20);
            this.virtualServer_5.TabIndex = 18;
            // 
            // RemoteServer_5
            // 
            this.RemoteServer_5.Location = new System.Drawing.Point(20, 82);
            this.RemoteServer_5.Name = "RemoteServer_5";
            this.RemoteServer_5.Size = new System.Drawing.Size(200, 20);
            this.RemoteServer_5.TabIndex = 19;
            // 
            // Server6
            // 
            this.Server6.Controls.Add(this.SimulatorServer6);
            this.Server6.Controls.Add(this.label28);
            this.Server6.Controls.Add(this.label29);
            this.Server6.Controls.Add(this.RemoteServer_6_psw);
            this.Server6.Controls.Add(this.RemoteServer_6_usr);
            this.Server6.Controls.Add(this.label8);
            this.Server6.Controls.Add(this.label9);
            this.Server6.Controls.Add(this.virtualServer_6);
            this.Server6.Controls.Add(this.RemoteServer_6);
            this.Server6.Location = new System.Drawing.Point(4, 22);
            this.Server6.Name = "Server6";
            this.Server6.Padding = new System.Windows.Forms.Padding(3);
            this.Server6.Size = new System.Drawing.Size(397, 168);
            this.Server6.TabIndex = 5;
            this.Server6.Text = "Server 6";
            this.Server6.UseVisualStyleBackColor = true;
            // 
            // SimulatorServer6
            // 
            this.SimulatorServer6.AutoSize = true;
            this.SimulatorServer6.Checked = true;
            this.SimulatorServer6.CheckState = System.Windows.Forms.CheckState.Checked;
            this.SimulatorServer6.Location = new System.Drawing.Point(21, 64);
            this.SimulatorServer6.Name = "SimulatorServer6";
            this.SimulatorServer6.Size = new System.Drawing.Size(125, 17);
            this.SimulatorServer6.TabIndex = 27;
            this.SimulatorServer6.Text = "Use Server Simulator";
            this.SimulatorServer6.UseVisualStyleBackColor = true;
            this.SimulatorServer6.CheckedChanged += new System.EventHandler(this.SimulateServer);
            // 
            // label28
            // 
            this.label28.AutoSize = true;
            this.label28.Location = new System.Drawing.Point(41, 137);
            this.label28.Name = "label28";
            this.label28.Size = new System.Drawing.Size(53, 13);
            this.label28.TabIndex = 26;
            this.label28.Text = "Password";
            this.label28.Visible = false;
            // 
            // label29
            // 
            this.label29.AutoSize = true;
            this.label29.Location = new System.Drawing.Point(38, 111);
            this.label29.Name = "label29";
            this.label29.Size = new System.Drawing.Size(60, 13);
            this.label29.TabIndex = 25;
            this.label29.Text = "User Name";
            this.label29.Visible = false;
            // 
            // RemoteServer_6_psw
            // 
            this.RemoteServer_6_psw.Location = new System.Drawing.Point(106, 134);
            this.RemoteServer_6_psw.Name = "RemoteServer_6_psw";
            this.RemoteServer_6_psw.PasswordChar = '*';
            this.RemoteServer_6_psw.Size = new System.Drawing.Size(114, 20);
            this.RemoteServer_6_psw.TabIndex = 24;
            this.RemoteServer_6_psw.Visible = false;
            // 
            // RemoteServer_6_usr
            // 
            this.RemoteServer_6_usr.Location = new System.Drawing.Point(106, 108);
            this.RemoteServer_6_usr.Name = "RemoteServer_6_usr";
            this.RemoteServer_6_usr.Size = new System.Drawing.Size(114, 20);
            this.RemoteServer_6_usr.TabIndex = 23;
            this.RemoteServer_6_usr.Visible = false;
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.Location = new System.Drawing.Point(3, 3);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(98, 13);
            this.label8.TabIndex = 8;
            this.label8.Text = "Virtual Server : Port";
            // 
            // label9
            // 
            this.label9.AutoSize = true;
            this.label9.Location = new System.Drawing.Point(3, 48);
            this.label9.Name = "label9";
            this.label9.Size = new System.Drawing.Size(106, 13);
            this.label9.TabIndex = 9;
            this.label9.Text = "Remote Server : Port";
            // 
            // virtualServer_6
            // 
            this.virtualServer_6.Location = new System.Drawing.Point(20, 20);
            this.virtualServer_6.Name = "virtualServer_6";
            this.virtualServer_6.Size = new System.Drawing.Size(200, 20);
            this.virtualServer_6.TabIndex = 21;
            // 
            // RemoteServer_6
            // 
            this.RemoteServer_6.Location = new System.Drawing.Point(20, 82);
            this.RemoteServer_6.Name = "RemoteServer_6";
            this.RemoteServer_6.Size = new System.Drawing.Size(200, 20);
            this.RemoteServer_6.TabIndex = 22;
            // 
            // Server7
            // 
            this.Server7.Controls.Add(this.SimulatorServer7);
            this.Server7.Controls.Add(this.label30);
            this.Server7.Controls.Add(this.label31);
            this.Server7.Controls.Add(this.RemoteServer_7_psw);
            this.Server7.Controls.Add(this.RemoteServer_7_usr);
            this.Server7.Controls.Add(this.label10);
            this.Server7.Controls.Add(this.RemoteServer_7);
            this.Server7.Controls.Add(this.label11);
            this.Server7.Controls.Add(this.virtualServer_7);
            this.Server7.Location = new System.Drawing.Point(4, 22);
            this.Server7.Name = "Server7";
            this.Server7.Padding = new System.Windows.Forms.Padding(3);
            this.Server7.Size = new System.Drawing.Size(397, 168);
            this.Server7.TabIndex = 6;
            this.Server7.Text = "Server 7";
            this.Server7.UseVisualStyleBackColor = true;
            // 
            // SimulatorServer7
            // 
            this.SimulatorServer7.AutoSize = true;
            this.SimulatorServer7.Checked = true;
            this.SimulatorServer7.CheckState = System.Windows.Forms.CheckState.Checked;
            this.SimulatorServer7.Location = new System.Drawing.Point(21, 64);
            this.SimulatorServer7.Name = "SimulatorServer7";
            this.SimulatorServer7.Size = new System.Drawing.Size(125, 17);
            this.SimulatorServer7.TabIndex = 30;
            this.SimulatorServer7.Text = "Use Server Simulator";
            this.SimulatorServer7.UseVisualStyleBackColor = true;
            this.SimulatorServer7.CheckedChanged += new System.EventHandler(this.SimulateServer);
            // 
            // label30
            // 
            this.label30.AutoSize = true;
            this.label30.Location = new System.Drawing.Point(41, 137);
            this.label30.Name = "label30";
            this.label30.Size = new System.Drawing.Size(53, 13);
            this.label30.TabIndex = 29;
            this.label30.Text = "Password";
            this.label30.Visible = false;
            // 
            // label31
            // 
            this.label31.AutoSize = true;
            this.label31.Location = new System.Drawing.Point(38, 111);
            this.label31.Name = "label31";
            this.label31.Size = new System.Drawing.Size(60, 13);
            this.label31.TabIndex = 28;
            this.label31.Text = "User Name";
            this.label31.Visible = false;
            // 
            // RemoteServer_7_psw
            // 
            this.RemoteServer_7_psw.Location = new System.Drawing.Point(106, 134);
            this.RemoteServer_7_psw.Name = "RemoteServer_7_psw";
            this.RemoteServer_7_psw.PasswordChar = '*';
            this.RemoteServer_7_psw.Size = new System.Drawing.Size(114, 20);
            this.RemoteServer_7_psw.TabIndex = 27;
            this.RemoteServer_7_psw.Visible = false;
            // 
            // RemoteServer_7_usr
            // 
            this.RemoteServer_7_usr.Location = new System.Drawing.Point(106, 108);
            this.RemoteServer_7_usr.Name = "RemoteServer_7_usr";
            this.RemoteServer_7_usr.Size = new System.Drawing.Size(114, 20);
            this.RemoteServer_7_usr.TabIndex = 26;
            this.RemoteServer_7_usr.Visible = false;
            // 
            // label10
            // 
            this.label10.AutoSize = true;
            this.label10.Location = new System.Drawing.Point(3, 3);
            this.label10.Name = "label10";
            this.label10.Size = new System.Drawing.Size(98, 13);
            this.label10.TabIndex = 8;
            this.label10.Text = "Virtual Server : Port";
            // 
            // RemoteServer_7
            // 
            this.RemoteServer_7.Location = new System.Drawing.Point(20, 82);
            this.RemoteServer_7.Name = "RemoteServer_7";
            this.RemoteServer_7.Size = new System.Drawing.Size(200, 20);
            this.RemoteServer_7.TabIndex = 25;
            // 
            // label11
            // 
            this.label11.AutoSize = true;
            this.label11.Location = new System.Drawing.Point(3, 48);
            this.label11.Name = "label11";
            this.label11.Size = new System.Drawing.Size(106, 13);
            this.label11.TabIndex = 9;
            this.label11.Text = "Remote Server : Port";
            // 
            // virtualServer_7
            // 
            this.virtualServer_7.Location = new System.Drawing.Point(20, 20);
            this.virtualServer_7.Name = "virtualServer_7";
            this.virtualServer_7.Size = new System.Drawing.Size(200, 20);
            this.virtualServer_7.TabIndex = 24;
            // 
            // LocalSettings
            // 
            this.LocalSettings.Controls.Add(this.compressionEnabled);
            this.LocalSettings.Controls.Add(this.constructMsg);
            this.LocalSettings.Controls.Add(this.validateServer);
            this.LocalSettings.Controls.Add(this.validateClient);
            this.LocalSettings.Controls.Add(this.label32);
            this.LocalSettings.Controls.Add(this.SeverSimPort);
            this.LocalSettings.Controls.Add(this.label17);
            this.LocalSettings.Controls.Add(this.updateSimMsg);
            this.LocalSettings.Controls.Add(this.label4);
            this.LocalSettings.Controls.Add(this.Security_psw);
            this.LocalSettings.Controls.Add(this.WorkFlowLoop);
            this.LocalSettings.Controls.Add(this.Security_user);
            this.LocalSettings.Controls.Add(this.SingleMsgLoop);
            this.LocalSettings.Controls.Add(this.SecurityEnable);
            this.LocalSettings.Controls.Add(this.label1);
            this.LocalSettings.Controls.Add(this.localport);
            this.LocalSettings.Dock = System.Windows.Forms.DockStyle.Top;
            this.LocalSettings.Location = new System.Drawing.Point(3, 3);
            this.LocalSettings.Name = "LocalSettings";
            this.LocalSettings.Size = new System.Drawing.Size(411, 128);
            this.LocalSettings.TabIndex = 28;
            this.LocalSettings.TabStop = false;
            this.LocalSettings.Text = "Local Settings";
            // 
            // constructMsg
            // 
            this.constructMsg.AutoSize = true;
            this.constructMsg.Checked = true;
            this.constructMsg.CheckState = System.Windows.Forms.CheckState.Checked;
            this.constructMsg.Location = new System.Drawing.Point(211, 95);
            this.constructMsg.Name = "constructMsg";
            this.constructMsg.Size = new System.Drawing.Size(142, 17);
            this.constructMsg.TabIndex = 12;
            this.constructMsg.Text = "Enable Msg Translations";
            this.constructMsg.UseVisualStyleBackColor = true;
            // 
            // validateServer
            // 
            this.validateServer.AutoSize = true;
            this.validateServer.Checked = true;
            this.validateServer.CheckState = System.Windows.Forms.CheckState.Checked;
            this.validateServer.Location = new System.Drawing.Point(211, 79);
            this.validateServer.Name = "validateServer";
            this.validateServer.Size = new System.Drawing.Size(157, 17);
            this.validateServer.TabIndex = 11;
            this.validateServer.Text = "Server Response Validation";
            this.validateServer.UseVisualStyleBackColor = true;
            // 
            // validateClient
            // 
            this.validateClient.AutoSize = true;
            this.validateClient.Checked = true;
            this.validateClient.CheckState = System.Windows.Forms.CheckState.Checked;
            this.validateClient.Location = new System.Drawing.Point(211, 63);
            this.validateClient.Name = "validateClient";
            this.validateClient.Size = new System.Drawing.Size(144, 17);
            this.validateClient.TabIndex = 10;
            this.validateClient.Text = "Client Request Validation";
            this.validateClient.UseVisualStyleBackColor = true;
            // 
            // label32
            // 
            this.label32.AutoSize = true;
            this.label32.Location = new System.Drawing.Point(6, 42);
            this.label32.Name = "label32";
            this.label32.Size = new System.Drawing.Size(80, 13);
            this.label32.TabIndex = 9;
            this.label32.Text = "Server Sim Port";
            // 
            // SeverSimPort
            // 
            this.SeverSimPort.Location = new System.Drawing.Point(105, 40);
            this.SeverSimPort.Name = "SeverSimPort";
            this.SeverSimPort.Size = new System.Drawing.Size(100, 20);
            this.SeverSimPort.TabIndex = 8;
            this.SeverSimPort.Text = "5050";
            this.SeverSimPort.TextChanged += new System.EventHandler(this.SeverSimPort_TextChanged);
            // 
            // label17
            // 
            this.label17.AutoSize = true;
            this.label17.Location = new System.Drawing.Point(10, 105);
            this.label17.Name = "label17";
            this.label17.Size = new System.Drawing.Size(53, 13);
            this.label17.TabIndex = 7;
            this.label17.Text = "Password";
            this.label17.Visible = false;
            // 
            // updateSimMsg
            // 
            this.updateSimMsg.AutoSize = true;
            this.updateSimMsg.Location = new System.Drawing.Point(211, 47);
            this.updateSimMsg.Name = "updateSimMsg";
            this.updateSimMsg.Size = new System.Drawing.Size(212, 17);
            this.updateSimMsg.TabIndex = 7;
            this.updateSimMsg.Text = "Update Simulator Msg\'s When Running";
            this.updateSimMsg.UseVisualStyleBackColor = true;
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(7, 82);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(60, 13);
            this.label4.TabIndex = 6;
            this.label4.Text = "User Name";
            this.label4.Visible = false;
            // 
            // Security_psw
            // 
            this.Security_psw.Location = new System.Drawing.Point(75, 102);
            this.Security_psw.Name = "Security_psw";
            this.Security_psw.PasswordChar = '*';
            this.Security_psw.Size = new System.Drawing.Size(114, 20);
            this.Security_psw.TabIndex = 5;
            this.Security_psw.Visible = false;
            // 
            // WorkFlowLoop
            // 
            this.WorkFlowLoop.AutoSize = true;
            this.WorkFlowLoop.Location = new System.Drawing.Point(211, 15);
            this.WorkFlowLoop.Name = "WorkFlowLoop";
            this.WorkFlowLoop.Size = new System.Drawing.Size(98, 17);
            this.WorkFlowLoop.TabIndex = 6;
            this.WorkFlowLoop.Text = "Workflow Loop";
            this.WorkFlowLoop.UseVisualStyleBackColor = true;
            this.WorkFlowLoop.CheckedChanged += new System.EventHandler(this.WorkFlowLoop_CheckedChanged);
            // 
            // Security_user
            // 
            this.Security_user.Location = new System.Drawing.Point(75, 79);
            this.Security_user.Name = "Security_user";
            this.Security_user.Size = new System.Drawing.Size(114, 20);
            this.Security_user.TabIndex = 4;
            this.Security_user.Visible = false;
            // 
            // SingleMsgLoop
            // 
            this.SingleMsgLoop.AutoSize = true;
            this.SingleMsgLoop.Location = new System.Drawing.Point(211, 31);
            this.SingleMsgLoop.Name = "SingleMsgLoop";
            this.SingleMsgLoop.Size = new System.Drawing.Size(128, 17);
            this.SingleMsgLoop.TabIndex = 5;
            this.SingleMsgLoop.Text = "Single Message Loop";
            this.SingleMsgLoop.UseVisualStyleBackColor = true;
            this.SingleMsgLoop.CheckedChanged += new System.EventHandler(this.SingleMsgLoop_CheckedChanged);
            // 
            // SecurityEnable
            // 
            this.SecurityEnable.AutoSize = true;
            this.SecurityEnable.Location = new System.Drawing.Point(12, 62);
            this.SecurityEnable.Name = "SecurityEnable";
            this.SecurityEnable.Size = new System.Drawing.Size(100, 17);
            this.SecurityEnable.TabIndex = 3;
            this.SecurityEnable.Text = "Enable Security";
            this.SecurityEnable.UseVisualStyleBackColor = true;
            this.SecurityEnable.Visible = false;
            this.SecurityEnable.CheckedChanged += new System.EventHandler(this.EnableSecurity);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(6, 20);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(93, 13);
            this.label1.TabIndex = 2;
            this.label1.Text = "Proxy Monitor Port";
            // 
            // localport
            // 
            this.localport.Location = new System.Drawing.Point(105, 18);
            this.localport.Name = "localport";
            this.localport.Size = new System.Drawing.Size(100, 20);
            this.localport.TabIndex = 0;
            this.localport.Text = "8080";
            // 
            // ClientMsg
            // 
            this.ClientMsg.Controls.Add(this.splitContainer2);
            this.ClientMsg.Location = new System.Drawing.Point(4, 22);
            this.ClientMsg.Name = "ClientMsg";
            this.ClientMsg.Padding = new System.Windows.Forms.Padding(3);
            this.ClientMsg.Size = new System.Drawing.Size(417, 450);
            this.ClientMsg.TabIndex = 1;
            this.ClientMsg.Text = "Client Messages";
            this.ClientMsg.UseVisualStyleBackColor = true;
            // 
            // splitContainer2
            // 
            this.splitContainer2.Dock = System.Windows.Forms.DockStyle.Fill;
            this.splitContainer2.Location = new System.Drawing.Point(3, 3);
            this.splitContainer2.Name = "splitContainer2";
            this.splitContainer2.Orientation = System.Windows.Forms.Orientation.Horizontal;
            // 
            // splitContainer2.Panel1
            // 
            this.splitContainer2.Panel1.Controls.Add(this.groupBox2);
            // 
            // splitContainer2.Panel2
            // 
            this.splitContainer2.Panel2.Controls.Add(this.groupBox9);
            this.splitContainer2.Size = new System.Drawing.Size(411, 444);
            this.splitContainer2.SplitterDistance = 241;
            this.splitContainer2.TabIndex = 0;
            // 
            // groupBox2
            // 
            this.groupBox2.Controls.Add(this.ProxyClientRxMsg);
            this.groupBox2.Dock = System.Windows.Forms.DockStyle.Fill;
            this.groupBox2.Location = new System.Drawing.Point(0, 0);
            this.groupBox2.Name = "groupBox2";
            this.groupBox2.Size = new System.Drawing.Size(411, 241);
            this.groupBox2.TabIndex = 0;
            this.groupBox2.TabStop = false;
            this.groupBox2.Text = "Request Message (From Client)";
            // 
            // ProxyClientRxMsg
            // 
            this.ProxyClientRxMsg.Dock = System.Windows.Forms.DockStyle.Fill;
            this.ProxyClientRxMsg.Location = new System.Drawing.Point(3, 16);
            this.ProxyClientRxMsg.Name = "ProxyClientRxMsg";
            this.ProxyClientRxMsg.ReadOnly = true;
            this.ProxyClientRxMsg.RightToLeft = System.Windows.Forms.RightToLeft.No;
            this.ProxyClientRxMsg.Size = new System.Drawing.Size(405, 222);
            this.ProxyClientRxMsg.TabIndex = 1;
            this.ProxyClientRxMsg.Text = "";
            this.ProxyClientRxMsg.WordWrap = false;
            // 
            // groupBox9
            // 
            this.groupBox9.Controls.Add(this.ProxyClientTxMsg);
            this.groupBox9.Dock = System.Windows.Forms.DockStyle.Fill;
            this.groupBox9.Location = new System.Drawing.Point(0, 0);
            this.groupBox9.Name = "groupBox9";
            this.groupBox9.Size = new System.Drawing.Size(411, 199);
            this.groupBox9.TabIndex = 0;
            this.groupBox9.TabStop = false;
            this.groupBox9.Text = "Response Message (To Client)";
            // 
            // ProxyClientTxMsg
            // 
            this.ProxyClientTxMsg.Dock = System.Windows.Forms.DockStyle.Fill;
            this.ProxyClientTxMsg.Location = new System.Drawing.Point(3, 16);
            this.ProxyClientTxMsg.Name = "ProxyClientTxMsg";
            this.ProxyClientTxMsg.ReadOnly = true;
            this.ProxyClientTxMsg.RightToLeft = System.Windows.Forms.RightToLeft.No;
            this.ProxyClientTxMsg.Size = new System.Drawing.Size(405, 180);
            this.ProxyClientTxMsg.TabIndex = 1;
            this.ProxyClientTxMsg.Text = "";
            this.ProxyClientTxMsg.WordWrap = false;
            // 
            // ServerMsg
            // 
            this.ServerMsg.Controls.Add(this.splitContainer3);
            this.ServerMsg.Location = new System.Drawing.Point(4, 22);
            this.ServerMsg.Name = "ServerMsg";
            this.ServerMsg.Size = new System.Drawing.Size(417, 450);
            this.ServerMsg.TabIndex = 2;
            this.ServerMsg.Text = "Server Messages";
            this.ServerMsg.UseVisualStyleBackColor = true;
            // 
            // splitContainer3
            // 
            this.splitContainer3.Dock = System.Windows.Forms.DockStyle.Fill;
            this.splitContainer3.Location = new System.Drawing.Point(0, 0);
            this.splitContainer3.Name = "splitContainer3";
            this.splitContainer3.Orientation = System.Windows.Forms.Orientation.Horizontal;
            // 
            // splitContainer3.Panel1
            // 
            this.splitContainer3.Panel1.Controls.Add(this.groupBox10);
            this.splitContainer3.Panel1.Padding = new System.Windows.Forms.Padding(3);
            // 
            // splitContainer3.Panel2
            // 
            this.splitContainer3.Panel2.Controls.Add(this.groupBox11);
            this.splitContainer3.Panel2.Padding = new System.Windows.Forms.Padding(3);
            this.splitContainer3.Size = new System.Drawing.Size(417, 450);
            this.splitContainer3.SplitterDistance = 245;
            this.splitContainer3.SplitterWidth = 1;
            this.splitContainer3.TabIndex = 0;
            // 
            // groupBox10
            // 
            this.groupBox10.Controls.Add(this.ProxyServerTxMsg);
            this.groupBox10.Dock = System.Windows.Forms.DockStyle.Fill;
            this.groupBox10.Location = new System.Drawing.Point(3, 3);
            this.groupBox10.Name = "groupBox10";
            this.groupBox10.RightToLeft = System.Windows.Forms.RightToLeft.No;
            this.groupBox10.Size = new System.Drawing.Size(411, 239);
            this.groupBox10.TabIndex = 1;
            this.groupBox10.TabStop = false;
            this.groupBox10.Text = "Request Message (To Server)";
            // 
            // ProxyServerTxMsg
            // 
            this.ProxyServerTxMsg.Dock = System.Windows.Forms.DockStyle.Fill;
            this.ProxyServerTxMsg.Location = new System.Drawing.Point(3, 16);
            this.ProxyServerTxMsg.Name = "ProxyServerTxMsg";
            this.ProxyServerTxMsg.ReadOnly = true;
            this.ProxyServerTxMsg.RightToLeft = System.Windows.Forms.RightToLeft.No;
            this.ProxyServerTxMsg.Size = new System.Drawing.Size(405, 220);
            this.ProxyServerTxMsg.TabIndex = 1;
            this.ProxyServerTxMsg.Text = "";
            this.ProxyServerTxMsg.WordWrap = false;
            // 
            // groupBox11
            // 
            this.groupBox11.Controls.Add(this.ProxyServerRxMsg);
            this.groupBox11.Dock = System.Windows.Forms.DockStyle.Fill;
            this.groupBox11.Location = new System.Drawing.Point(3, 3);
            this.groupBox11.Name = "groupBox11";
            this.groupBox11.Size = new System.Drawing.Size(411, 198);
            this.groupBox11.TabIndex = 1;
            this.groupBox11.TabStop = false;
            this.groupBox11.Text = "Response Message (From Server)";
            // 
            // ProxyServerRxMsg
            // 
            this.ProxyServerRxMsg.Dock = System.Windows.Forms.DockStyle.Fill;
            this.ProxyServerRxMsg.Location = new System.Drawing.Point(3, 16);
            this.ProxyServerRxMsg.Name = "ProxyServerRxMsg";
            this.ProxyServerRxMsg.ReadOnly = true;
            this.ProxyServerRxMsg.RightToLeft = System.Windows.Forms.RightToLeft.No;
            this.ProxyServerRxMsg.Size = new System.Drawing.Size(405, 179);
            this.ProxyServerRxMsg.TabIndex = 1;
            this.ProxyServerRxMsg.Text = "";
            this.ProxyServerRxMsg.WordWrap = false;
            // 
            // MsgProxyStatusBar
            // 
            this.MsgProxyStatusBar.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.MsgProxyEnableStatus,
            this.MsgProxyStatus});
            this.MsgProxyStatusBar.Location = new System.Drawing.Point(3, 504);
            this.MsgProxyStatusBar.Name = "MsgProxyStatusBar";
            this.MsgProxyStatusBar.Size = new System.Drawing.Size(425, 22);
            this.MsgProxyStatusBar.TabIndex = 1;
            this.MsgProxyStatusBar.Text = "statusStrip2";
            // 
            // MsgProxyEnableStatus
            // 
            this.MsgProxyEnableStatus.ForeColor = System.Drawing.SystemColors.ControlText;
            this.MsgProxyEnableStatus.Name = "MsgProxyEnableStatus";
            this.MsgProxyEnableStatus.Size = new System.Drawing.Size(81, 17);
            this.MsgProxyEnableStatus.Text = "(Enable Status)";
            // 
            // MsgProxyStatus
            // 
            this.MsgProxyStatus.Name = "MsgProxyStatus";
            this.MsgProxyStatus.Size = new System.Drawing.Size(114, 17);
            this.MsgProxyStatus.Text = "Message Proxy Status";
            // 
            // MsgProxyToolBar
            // 
            this.MsgProxyToolBar.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.proxyDisabledIcon,
            this.proxyEnabledIcon,
            this.toolStripSeparator11,
            this.toolStripProxyNext,
            this.toolStripProxyPrev,
            this.toolStripSeparator6,
            this.proxyDisable,
            this.proxyEnable});
            this.MsgProxyToolBar.Location = new System.Drawing.Point(3, 3);
            this.MsgProxyToolBar.Name = "MsgProxyToolBar";
            this.MsgProxyToolBar.Size = new System.Drawing.Size(425, 25);
            this.MsgProxyToolBar.TabIndex = 0;
            this.MsgProxyToolBar.Text = "toolStrip4";
            // 
            // proxyDisabledIcon
            // 
            this.proxyDisabledIcon.ForeColor = System.Drawing.Color.Red;
            this.proxyDisabledIcon.Image = global::HL7TestHarness.Properties.Resources.x;
            this.proxyDisabledIcon.ImageScaling = System.Windows.Forms.ToolStripItemImageScaling.None;
            this.proxyDisabledIcon.Name = "proxyDisabledIcon";
            this.proxyDisabledIcon.Size = new System.Drawing.Size(56, 22);
            this.proxyDisabledIcon.Text = "Disabled";
            // 
            // proxyEnabledIcon
            // 
            this.proxyEnabledIcon.ForeColor = System.Drawing.Color.Black;
            this.proxyEnabledIcon.Image = global::HL7TestHarness.Properties.Resources.check;
            this.proxyEnabledIcon.ImageScaling = System.Windows.Forms.ToolStripItemImageScaling.None;
            this.proxyEnabledIcon.Name = "proxyEnabledIcon";
            this.proxyEnabledIcon.Size = new System.Drawing.Size(54, 22);
            this.proxyEnabledIcon.Text = "Enabled";
            // 
            // toolStripSeparator11
            // 
            this.toolStripSeparator11.Name = "toolStripSeparator11";
            this.toolStripSeparator11.Size = new System.Drawing.Size(6, 25);
            // 
            // toolStripProxyNext
            // 
            this.toolStripProxyNext.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right;
            this.toolStripProxyNext.Enabled = false;
            this.toolStripProxyNext.IsLink = true;
            this.toolStripProxyNext.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline;
            this.toolStripProxyNext.Name = "toolStripProxyNext";
            this.toolStripProxyNext.Size = new System.Drawing.Size(15, 22);
            this.toolStripProxyNext.Text = ">";
            this.toolStripProxyNext.Click += new System.EventHandler(this.toolStripClientNext_Click);
            // 
            // toolStripProxyPrev
            // 
            this.toolStripProxyPrev.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right;
            this.toolStripProxyPrev.Enabled = false;
            this.toolStripProxyPrev.IsLink = true;
            this.toolStripProxyPrev.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline;
            this.toolStripProxyPrev.Name = "toolStripProxyPrev";
            this.toolStripProxyPrev.Size = new System.Drawing.Size(15, 22);
            this.toolStripProxyPrev.Text = "<";
            this.toolStripProxyPrev.Click += new System.EventHandler(this.toolStripClientPrev_Click);
            // 
            // toolStripSeparator6
            // 
            this.toolStripSeparator6.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right;
            this.toolStripSeparator6.Name = "toolStripSeparator6";
            this.toolStripSeparator6.Size = new System.Drawing.Size(6, 25);
            // 
            // proxyDisable
            // 
            this.proxyDisable.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right;
            this.proxyDisable.BackColor = System.Drawing.Color.Transparent;
            this.proxyDisable.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text;
            this.proxyDisable.IsLink = true;
            this.proxyDisable.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline;
            this.proxyDisable.Name = "proxyDisable";
            this.proxyDisable.Size = new System.Drawing.Size(41, 22);
            this.proxyDisable.Text = "Disable";
            this.proxyDisable.Click += new System.EventHandler(this.ProxyDisable_Click);
            // 
            // proxyEnable
            // 
            this.proxyEnable.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right;
            this.proxyEnable.BackColor = System.Drawing.Color.Transparent;
            this.proxyEnable.IsLink = true;
            this.proxyEnable.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline;
            this.proxyEnable.Name = "proxyEnable";
            this.proxyEnable.Size = new System.Drawing.Size(39, 22);
            this.proxyEnable.Text = "Enable";
            this.proxyEnable.Click += new System.EventHandler(this.ProxyEnable_Click);
            // 
            // ClientSimTab
            // 
            this.ClientSimTab.Controls.Add(this.ClientSimContainer);
            this.ClientSimTab.Controls.Add(this.ClientSimStatusBar);
            this.ClientSimTab.Controls.Add(this.ClientSimToolBar);
            this.ClientSimTab.Location = new System.Drawing.Point(4, 22);
            this.ClientSimTab.Name = "ClientSimTab";
            this.ClientSimTab.Padding = new System.Windows.Forms.Padding(3);
            this.ClientSimTab.Size = new System.Drawing.Size(431, 529);
            this.ClientSimTab.TabIndex = 1;
            this.ClientSimTab.Text = "Client Simulator";
            this.ClientSimTab.UseVisualStyleBackColor = true;
            // 
            // ClientSimContainer
            // 
            this.ClientSimContainer.Dock = System.Windows.Forms.DockStyle.Fill;
            this.ClientSimContainer.Location = new System.Drawing.Point(3, 28);
            this.ClientSimContainer.Name = "ClientSimContainer";
            this.ClientSimContainer.Orientation = System.Windows.Forms.Orientation.Horizontal;
            // 
            // ClientSimContainer.Panel1
            // 
            this.ClientSimContainer.Panel1.Controls.Add(this.groupBox4);
            // 
            // ClientSimContainer.Panel2
            // 
            this.ClientSimContainer.Panel2.Controls.Add(this.groupBox5);
            this.ClientSimContainer.Size = new System.Drawing.Size(425, 476);
            this.ClientSimContainer.SplitterDistance = 220;
            this.ClientSimContainer.TabIndex = 2;
            // 
            // groupBox4
            // 
            this.groupBox4.Controls.Add(this.ClientSimTxMsg);
            this.groupBox4.Dock = System.Windows.Forms.DockStyle.Fill;
            this.groupBox4.Location = new System.Drawing.Point(0, 0);
            this.groupBox4.Name = "groupBox4";
            this.groupBox4.Size = new System.Drawing.Size(425, 220);
            this.groupBox4.TabIndex = 0;
            this.groupBox4.TabStop = false;
            this.groupBox4.Text = "Tx Message";
            // 
            // ClientSimTxMsg
            // 
            this.ClientSimTxMsg.Dock = System.Windows.Forms.DockStyle.Fill;
            this.ClientSimTxMsg.Location = new System.Drawing.Point(3, 16);
            this.ClientSimTxMsg.Name = "ClientSimTxMsg";
            this.ClientSimTxMsg.ReadOnly = true;
            this.ClientSimTxMsg.RightToLeft = System.Windows.Forms.RightToLeft.No;
            this.ClientSimTxMsg.Size = new System.Drawing.Size(419, 201);
            this.ClientSimTxMsg.TabIndex = 0;
            this.ClientSimTxMsg.Text = "";
            this.ClientSimTxMsg.WordWrap = false;
            // 
            // groupBox5
            // 
            this.groupBox5.Controls.Add(this.ClientSimRxMsg);
            this.groupBox5.Dock = System.Windows.Forms.DockStyle.Fill;
            this.groupBox5.Location = new System.Drawing.Point(0, 0);
            this.groupBox5.Name = "groupBox5";
            this.groupBox5.Size = new System.Drawing.Size(425, 252);
            this.groupBox5.TabIndex = 0;
            this.groupBox5.TabStop = false;
            this.groupBox5.Text = "Rx Message";
            // 
            // ClientSimRxMsg
            // 
            this.ClientSimRxMsg.Dock = System.Windows.Forms.DockStyle.Fill;
            this.ClientSimRxMsg.Location = new System.Drawing.Point(3, 16);
            this.ClientSimRxMsg.Name = "ClientSimRxMsg";
            this.ClientSimRxMsg.ReadOnly = true;
            this.ClientSimRxMsg.Size = new System.Drawing.Size(419, 233);
            this.ClientSimRxMsg.TabIndex = 0;
            this.ClientSimRxMsg.Text = "";
            this.ClientSimRxMsg.WordWrap = false;
            // 
            // ClientSimStatusBar
            // 
            this.ClientSimStatusBar.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.ClientSimEnableStatus,
            this.ClientSimStatus});
            this.ClientSimStatusBar.Location = new System.Drawing.Point(3, 504);
            this.ClientSimStatusBar.Name = "ClientSimStatusBar";
            this.ClientSimStatusBar.Size = new System.Drawing.Size(425, 22);
            this.ClientSimStatusBar.TabIndex = 1;
            this.ClientSimStatusBar.Text = "statusStrip3";
            // 
            // ClientSimEnableStatus
            // 
            this.ClientSimEnableStatus.Name = "ClientSimEnableStatus";
            this.ClientSimEnableStatus.Size = new System.Drawing.Size(47, 17);
            this.ClientSimEnableStatus.Text = "(Enable)";
            // 
            // ClientSimStatus
            // 
            this.ClientSimStatus.Name = "ClientSimStatus";
            this.ClientSimStatus.Size = new System.Drawing.Size(115, 17);
            this.ClientSimStatus.Text = "Client Simulator Status";
            // 
            // ClientSimToolBar
            // 
            this.ClientSimToolBar.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.ClientSimDisabledIcon,
            this.ClientSimEnabledIcon,
            this.toolStripSeparator3,
            this.toolStripClientNext,
            this.toolStripClientPrev,
            this.toolStripSeparator7,
            this.ClientSimDisable,
            this.ClientSimEnable});
            this.ClientSimToolBar.Location = new System.Drawing.Point(3, 3);
            this.ClientSimToolBar.Name = "ClientSimToolBar";
            this.ClientSimToolBar.Size = new System.Drawing.Size(425, 25);
            this.ClientSimToolBar.TabIndex = 0;
            this.ClientSimToolBar.Text = "toolStrip2";
            // 
            // ClientSimDisabledIcon
            // 
            this.ClientSimDisabledIcon.ForeColor = System.Drawing.Color.Red;
            this.ClientSimDisabledIcon.Image = global::HL7TestHarness.Properties.Resources.x;
            this.ClientSimDisabledIcon.ImageScaling = System.Windows.Forms.ToolStripItemImageScaling.None;
            this.ClientSimDisabledIcon.Name = "ClientSimDisabledIcon";
            this.ClientSimDisabledIcon.Size = new System.Drawing.Size(56, 22);
            this.ClientSimDisabledIcon.Text = "Disabled";
            // 
            // ClientSimEnabledIcon
            // 
            this.ClientSimEnabledIcon.Image = global::HL7TestHarness.Properties.Resources.check;
            this.ClientSimEnabledIcon.ImageScaling = System.Windows.Forms.ToolStripItemImageScaling.None;
            this.ClientSimEnabledIcon.Name = "ClientSimEnabledIcon";
            this.ClientSimEnabledIcon.Size = new System.Drawing.Size(54, 22);
            this.ClientSimEnabledIcon.Text = "Enabled";
            // 
            // toolStripSeparator3
            // 
            this.toolStripSeparator3.Name = "toolStripSeparator3";
            this.toolStripSeparator3.Size = new System.Drawing.Size(6, 25);
            // 
            // toolStripClientNext
            // 
            this.toolStripClientNext.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right;
            this.toolStripClientNext.Enabled = false;
            this.toolStripClientNext.IsLink = true;
            this.toolStripClientNext.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline;
            this.toolStripClientNext.Name = "toolStripClientNext";
            this.toolStripClientNext.Size = new System.Drawing.Size(15, 22);
            this.toolStripClientNext.Text = ">";
            this.toolStripClientNext.Click += new System.EventHandler(this.toolStripClientNext_Click);
            // 
            // toolStripClientPrev
            // 
            this.toolStripClientPrev.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right;
            this.toolStripClientPrev.Enabled = false;
            this.toolStripClientPrev.IsLink = true;
            this.toolStripClientPrev.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline;
            this.toolStripClientPrev.Name = "toolStripClientPrev";
            this.toolStripClientPrev.Size = new System.Drawing.Size(15, 22);
            this.toolStripClientPrev.Text = "<";
            this.toolStripClientPrev.Click += new System.EventHandler(this.toolStripClientPrev_Click);
            // 
            // toolStripSeparator7
            // 
            this.toolStripSeparator7.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right;
            this.toolStripSeparator7.Name = "toolStripSeparator7";
            this.toolStripSeparator7.Size = new System.Drawing.Size(6, 25);
            // 
            // ClientSimDisable
            // 
            this.ClientSimDisable.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right;
            this.ClientSimDisable.IsLink = true;
            this.ClientSimDisable.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline;
            this.ClientSimDisable.Name = "ClientSimDisable";
            this.ClientSimDisable.RightToLeft = System.Windows.Forms.RightToLeft.No;
            this.ClientSimDisable.Size = new System.Drawing.Size(41, 22);
            this.ClientSimDisable.Text = "Disable";
            this.ClientSimDisable.Click += new System.EventHandler(this.ClientSimDisable_Click);
            // 
            // ClientSimEnable
            // 
            this.ClientSimEnable.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right;
            this.ClientSimEnable.IsLink = true;
            this.ClientSimEnable.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline;
            this.ClientSimEnable.Name = "ClientSimEnable";
            this.ClientSimEnable.RightToLeft = System.Windows.Forms.RightToLeft.No;
            this.ClientSimEnable.Size = new System.Drawing.Size(39, 22);
            this.ClientSimEnable.Text = "Enable";
            this.ClientSimEnable.Click += new System.EventHandler(this.ClientSimEnable_Click);
            // 
            // ServerSimTab
            // 
            this.ServerSimTab.Controls.Add(this.ServerSimContainer);
            this.ServerSimTab.Controls.Add(this.ServerSimStatusBar);
            this.ServerSimTab.Controls.Add(this.ServerSimToolBar);
            this.ServerSimTab.Location = new System.Drawing.Point(4, 22);
            this.ServerSimTab.Name = "ServerSimTab";
            this.ServerSimTab.Padding = new System.Windows.Forms.Padding(3);
            this.ServerSimTab.Size = new System.Drawing.Size(431, 529);
            this.ServerSimTab.TabIndex = 3;
            this.ServerSimTab.Text = "Server Simulator";
            this.ServerSimTab.UseVisualStyleBackColor = true;
            // 
            // ServerSimContainer
            // 
            this.ServerSimContainer.Dock = System.Windows.Forms.DockStyle.Fill;
            this.ServerSimContainer.Location = new System.Drawing.Point(3, 28);
            this.ServerSimContainer.Name = "ServerSimContainer";
            this.ServerSimContainer.Orientation = System.Windows.Forms.Orientation.Horizontal;
            // 
            // ServerSimContainer.Panel1
            // 
            this.ServerSimContainer.Panel1.Controls.Add(this.groupBox6);
            // 
            // ServerSimContainer.Panel2
            // 
            this.ServerSimContainer.Panel2.Controls.Add(this.groupBox7);
            this.ServerSimContainer.Size = new System.Drawing.Size(425, 476);
            this.ServerSimContainer.SplitterDistance = 220;
            this.ServerSimContainer.TabIndex = 2;
            // 
            // groupBox6
            // 
            this.groupBox6.Controls.Add(this.ServerSimRxMsg);
            this.groupBox6.Dock = System.Windows.Forms.DockStyle.Fill;
            this.groupBox6.Location = new System.Drawing.Point(0, 0);
            this.groupBox6.Name = "groupBox6";
            this.groupBox6.Size = new System.Drawing.Size(425, 220);
            this.groupBox6.TabIndex = 0;
            this.groupBox6.TabStop = false;
            this.groupBox6.Text = "Rx Message";
            // 
            // ServerSimRxMsg
            // 
            this.ServerSimRxMsg.Dock = System.Windows.Forms.DockStyle.Fill;
            this.ServerSimRxMsg.Location = new System.Drawing.Point(3, 16);
            this.ServerSimRxMsg.Name = "ServerSimRxMsg";
            this.ServerSimRxMsg.ReadOnly = true;
            this.ServerSimRxMsg.Size = new System.Drawing.Size(419, 201);
            this.ServerSimRxMsg.TabIndex = 0;
            this.ServerSimRxMsg.Text = "";
            this.ServerSimRxMsg.WordWrap = false;
            // 
            // groupBox7
            // 
            this.groupBox7.Controls.Add(this.ServerSimTxMsg);
            this.groupBox7.Dock = System.Windows.Forms.DockStyle.Fill;
            this.groupBox7.Location = new System.Drawing.Point(0, 0);
            this.groupBox7.Name = "groupBox7";
            this.groupBox7.Size = new System.Drawing.Size(425, 252);
            this.groupBox7.TabIndex = 0;
            this.groupBox7.TabStop = false;
            this.groupBox7.Text = "Tx Message";
            // 
            // ServerSimTxMsg
            // 
            this.ServerSimTxMsg.Dock = System.Windows.Forms.DockStyle.Fill;
            this.ServerSimTxMsg.Location = new System.Drawing.Point(3, 16);
            this.ServerSimTxMsg.Name = "ServerSimTxMsg";
            this.ServerSimTxMsg.ReadOnly = true;
            this.ServerSimTxMsg.Size = new System.Drawing.Size(419, 233);
            this.ServerSimTxMsg.TabIndex = 0;
            this.ServerSimTxMsg.Text = "";
            this.ServerSimTxMsg.WordWrap = false;
            // 
            // ServerSimStatusBar
            // 
            this.ServerSimStatusBar.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.ServerSimEnableStatus,
            this.ServerSimStatus});
            this.ServerSimStatusBar.Location = new System.Drawing.Point(3, 504);
            this.ServerSimStatusBar.Name = "ServerSimStatusBar";
            this.ServerSimStatusBar.Size = new System.Drawing.Size(425, 22);
            this.ServerSimStatusBar.TabIndex = 1;
            this.ServerSimStatusBar.Text = "statusStrip3";
            // 
            // ServerSimEnableStatus
            // 
            this.ServerSimEnableStatus.Name = "ServerSimEnableStatus";
            this.ServerSimEnableStatus.Size = new System.Drawing.Size(53, 17);
            this.ServerSimEnableStatus.Text = "(Enabled)";
            // 
            // ServerSimStatus
            // 
            this.ServerSimStatus.Name = "ServerSimStatus";
            this.ServerSimStatus.Size = new System.Drawing.Size(120, 17);
            this.ServerSimStatus.Text = "Server Simulator Status";
            // 
            // ServerSimToolBar
            // 
            this.ServerSimToolBar.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.ServerSimEnabledIcon,
            this.ServerSimDisabledIcon,
            this.toolStripSeparator5,
            this.toolStripServerNext,
            this.toolStripServerPrev,
            this.toolStripSeparator8,
            this.ServerSimDisable,
            this.ServerSimEnable});
            this.ServerSimToolBar.Location = new System.Drawing.Point(3, 3);
            this.ServerSimToolBar.Name = "ServerSimToolBar";
            this.ServerSimToolBar.Size = new System.Drawing.Size(425, 25);
            this.ServerSimToolBar.TabIndex = 0;
            this.ServerSimToolBar.Text = "toolStrip2";
            // 
            // ServerSimEnabledIcon
            // 
            this.ServerSimEnabledIcon.Image = global::HL7TestHarness.Properties.Resources.check;
            this.ServerSimEnabledIcon.ImageScaling = System.Windows.Forms.ToolStripItemImageScaling.None;
            this.ServerSimEnabledIcon.Name = "ServerSimEnabledIcon";
            this.ServerSimEnabledIcon.Size = new System.Drawing.Size(54, 22);
            this.ServerSimEnabledIcon.Text = "Enabled";
            // 
            // ServerSimDisabledIcon
            // 
            this.ServerSimDisabledIcon.ForeColor = System.Drawing.Color.Red;
            this.ServerSimDisabledIcon.Image = global::HL7TestHarness.Properties.Resources.x;
            this.ServerSimDisabledIcon.ImageScaling = System.Windows.Forms.ToolStripItemImageScaling.None;
            this.ServerSimDisabledIcon.Name = "ServerSimDisabledIcon";
            this.ServerSimDisabledIcon.Size = new System.Drawing.Size(56, 22);
            this.ServerSimDisabledIcon.Text = "Disabled";
            // 
            // toolStripSeparator5
            // 
            this.toolStripSeparator5.Name = "toolStripSeparator5";
            this.toolStripSeparator5.Size = new System.Drawing.Size(6, 25);
            // 
            // toolStripServerNext
            // 
            this.toolStripServerNext.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right;
            this.toolStripServerNext.Enabled = false;
            this.toolStripServerNext.IsLink = true;
            this.toolStripServerNext.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline;
            this.toolStripServerNext.Name = "toolStripServerNext";
            this.toolStripServerNext.Size = new System.Drawing.Size(15, 22);
            this.toolStripServerNext.Text = ">";
            this.toolStripServerNext.Click += new System.EventHandler(this.toolStripServerNext_Click);
            // 
            // toolStripServerPrev
            // 
            this.toolStripServerPrev.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right;
            this.toolStripServerPrev.Enabled = false;
            this.toolStripServerPrev.IsLink = true;
            this.toolStripServerPrev.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline;
            this.toolStripServerPrev.Name = "toolStripServerPrev";
            this.toolStripServerPrev.Size = new System.Drawing.Size(15, 22);
            this.toolStripServerPrev.Text = "<";
            this.toolStripServerPrev.Click += new System.EventHandler(this.toolStripServerPrev_Click);
            // 
            // toolStripSeparator8
            // 
            this.toolStripSeparator8.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right;
            this.toolStripSeparator8.Name = "toolStripSeparator8";
            this.toolStripSeparator8.Size = new System.Drawing.Size(6, 25);
            // 
            // ServerSimDisable
            // 
            this.ServerSimDisable.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right;
            this.ServerSimDisable.IsLink = true;
            this.ServerSimDisable.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline;
            this.ServerSimDisable.Name = "ServerSimDisable";
            this.ServerSimDisable.Size = new System.Drawing.Size(41, 22);
            this.ServerSimDisable.Text = "Disable";
            this.ServerSimDisable.Click += new System.EventHandler(this.ServerSimDisable_Click);
            // 
            // ServerSimEnable
            // 
            this.ServerSimEnable.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right;
            this.ServerSimEnable.IsLink = true;
            this.ServerSimEnable.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline;
            this.ServerSimEnable.Name = "ServerSimEnable";
            this.ServerSimEnable.Size = new System.Drawing.Size(39, 22);
            this.ServerSimEnable.Text = "Enable";
            this.ServerSimEnable.Click += new System.EventHandler(this.ServerSimEnable_Click);
            // 
            // WorkFlowTab
            // 
            this.WorkFlowTab.Controls.Add(this.groupBox1);
            this.WorkFlowTab.Controls.Add(this.workFlowStatusBar);
            this.WorkFlowTab.Controls.Add(this.WorkFlowToolStrip);
            this.WorkFlowTab.Location = new System.Drawing.Point(4, 22);
            this.WorkFlowTab.Name = "WorkFlowTab";
            this.WorkFlowTab.Padding = new System.Windows.Forms.Padding(3);
            this.WorkFlowTab.Size = new System.Drawing.Size(431, 529);
            this.WorkFlowTab.TabIndex = 5;
            this.WorkFlowTab.Text = "Work Flow Details";
            this.WorkFlowTab.UseVisualStyleBackColor = true;
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.WorkFlowDisplay);
            this.groupBox1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.groupBox1.Location = new System.Drawing.Point(3, 28);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(425, 476);
            this.groupBox1.TabIndex = 6;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "Work Flow";
            // 
            // WorkFlowDisplay
            // 
            this.WorkFlowDisplay.CausesValidation = false;
            this.WorkFlowDisplay.Dock = System.Windows.Forms.DockStyle.Fill;
            this.WorkFlowDisplay.HotTracking = true;
            this.WorkFlowDisplay.ImageKey = "empty.JPG";
            this.WorkFlowDisplay.ImageList = this.resultImages;
            this.WorkFlowDisplay.Location = new System.Drawing.Point(3, 16);
            this.WorkFlowDisplay.Name = "WorkFlowDisplay";
            this.WorkFlowDisplay.SelectedImageIndex = 2;
            this.WorkFlowDisplay.Size = new System.Drawing.Size(419, 457);
            this.WorkFlowDisplay.TabIndex = 4;
            // 
            // resultImages
            // 
            this.resultImages.ImageStream = ((System.Windows.Forms.ImageListStreamer)(resources.GetObject("resultImages.ImageStream")));
            this.resultImages.TransparentColor = System.Drawing.Color.Transparent;
            this.resultImages.Images.SetKeyName(0, "x.jpg");
            this.resultImages.Images.SetKeyName(1, "check.JPG");
            this.resultImages.Images.SetKeyName(2, "empty.JPG");
            // 
            // workFlowStatusBar
            // 
            this.workFlowStatusBar.Location = new System.Drawing.Point(3, 504);
            this.workFlowStatusBar.Name = "workFlowStatusBar";
            this.workFlowStatusBar.Size = new System.Drawing.Size(425, 22);
            this.workFlowStatusBar.TabIndex = 5;
            this.workFlowStatusBar.Text = "statusStrip1";
            // 
            // WorkFlowToolStrip
            // 
            this.WorkFlowToolStrip.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.RefreshWorkFlow,
            this.toolStripSeparator2});
            this.WorkFlowToolStrip.Location = new System.Drawing.Point(3, 3);
            this.WorkFlowToolStrip.Name = "WorkFlowToolStrip";
            this.WorkFlowToolStrip.Size = new System.Drawing.Size(425, 25);
            this.WorkFlowToolStrip.TabIndex = 3;
            this.WorkFlowToolStrip.Text = "toolStrip1";
            // 
            // RefreshWorkFlow
            // 
            this.RefreshWorkFlow.IsLink = true;
            this.RefreshWorkFlow.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline;
            this.RefreshWorkFlow.Name = "RefreshWorkFlow";
            this.RefreshWorkFlow.Size = new System.Drawing.Size(83, 22);
            this.RefreshWorkFlow.Text = "Refresh Results";
            this.RefreshWorkFlow.Click += new System.EventHandler(this.RefreshWorkFlowDiagram);
            // 
            // toolStripSeparator2
            // 
            this.toolStripSeparator2.Name = "toolStripSeparator2";
            this.toolStripSeparator2.Size = new System.Drawing.Size(6, 25);
            // 
            // StageDataTab
            // 
            this.StageDataTab.Controls.Add(this.panel1);
            this.StageDataTab.Controls.Add(this.DataStageStatusBar);
            this.StageDataTab.Controls.Add(this.DataStageStrip);
            this.StageDataTab.Location = new System.Drawing.Point(4, 22);
            this.StageDataTab.Name = "StageDataTab";
            this.StageDataTab.Padding = new System.Windows.Forms.Padding(3);
            this.StageDataTab.Size = new System.Drawing.Size(431, 529);
            this.StageDataTab.TabIndex = 6;
            this.StageDataTab.Text = "Test Data";
            this.StageDataTab.UseVisualStyleBackColor = true;
            // 
            // panel1
            // 
            this.panel1.Controls.Add(this.panel2);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panel1.Location = new System.Drawing.Point(3, 28);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(425, 476);
            this.panel1.TabIndex = 8;
            // 
            // panel2
            // 
            this.panel2.Controls.Add(this.groupBox8);
            this.panel2.Controls.Add(this.groupBox3);
            this.panel2.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panel2.Location = new System.Drawing.Point(0, 0);
            this.panel2.Name = "panel2";
            this.panel2.Size = new System.Drawing.Size(425, 476);
            this.panel2.TabIndex = 8;
            // 
            // groupBox8
            // 
            this.groupBox8.Controls.Add(this.DataStageOutput);
            this.groupBox8.Dock = System.Windows.Forms.DockStyle.Fill;
            this.groupBox8.Location = new System.Drawing.Point(0, 74);
            this.groupBox8.Name = "groupBox8";
            this.groupBox8.Size = new System.Drawing.Size(425, 402);
            this.groupBox8.TabIndex = 3;
            this.groupBox8.TabStop = false;
            this.groupBox8.Text = "DB Staging Data";
            // 
            // DataStageOutput
            // 
            this.DataStageOutput.Dock = System.Windows.Forms.DockStyle.Fill;
            this.DataStageOutput.Location = new System.Drawing.Point(3, 16);
            this.DataStageOutput.Name = "DataStageOutput";
            this.DataStageOutput.ReadOnly = true;
            this.DataStageOutput.Size = new System.Drawing.Size(419, 383);
            this.DataStageOutput.TabIndex = 7;
            this.DataStageOutput.Text = "";
            this.DataStageOutput.WordWrap = false;
            // 
            // groupBox3
            // 
            this.groupBox3.Controls.Add(this.btnGenerateData);
            this.groupBox3.Controls.Add(this.GenerateServerData);
            this.groupBox3.Controls.Add(this.GenerateClientData);
            this.groupBox3.Dock = System.Windows.Forms.DockStyle.Top;
            this.groupBox3.Location = new System.Drawing.Point(0, 0);
            this.groupBox3.Name = "groupBox3";
            this.groupBox3.Size = new System.Drawing.Size(425, 74);
            this.groupBox3.TabIndex = 1;
            this.groupBox3.TabStop = false;
            // 
            // btnGenerateData
            // 
            this.btnGenerateData.Location = new System.Drawing.Point(11, 19);
            this.btnGenerateData.Name = "btnGenerateData";
            this.btnGenerateData.Size = new System.Drawing.Size(75, 40);
            this.btnGenerateData.TabIndex = 2;
            this.btnGenerateData.Text = "Generate Data";
            this.btnGenerateData.UseVisualStyleBackColor = true;
            this.btnGenerateData.Click += new System.EventHandler(this.btnGenerateData_Click);
            // 
            // GenerateServerData
            // 
            this.GenerateServerData.AutoSize = true;
            this.GenerateServerData.Location = new System.Drawing.Point(89, 42);
            this.GenerateServerData.Name = "GenerateServerData";
            this.GenerateServerData.Size = new System.Drawing.Size(112, 17);
            this.GenerateServerData.TabIndex = 1;
            this.GenerateServerData.Text = "For Server System";
            this.GenerateServerData.UseVisualStyleBackColor = true;
            this.GenerateServerData.CheckedChanged += new System.EventHandler(this.TestDataSimulateServer_CheckedChanged);
            // 
            // GenerateClientData
            // 
            this.GenerateClientData.AutoSize = true;
            this.GenerateClientData.Location = new System.Drawing.Point(89, 19);
            this.GenerateClientData.Name = "GenerateClientData";
            this.GenerateClientData.Size = new System.Drawing.Size(107, 17);
            this.GenerateClientData.TabIndex = 0;
            this.GenerateClientData.Text = "For Client System";
            this.GenerateClientData.UseVisualStyleBackColor = true;
            this.GenerateClientData.CheckedChanged += new System.EventHandler(this.TestDataSimulateClient_CheckedChanged);
            // 
            // DataStageStatusBar
            // 
            this.DataStageStatusBar.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.DataStageStatusLabel});
            this.DataStageStatusBar.Location = new System.Drawing.Point(3, 504);
            this.DataStageStatusBar.Name = "DataStageStatusBar";
            this.DataStageStatusBar.Size = new System.Drawing.Size(425, 22);
            this.DataStageStatusBar.TabIndex = 6;
            this.DataStageStatusBar.Text = "statusStrip2";
            // 
            // DataStageStatusLabel
            // 
            this.DataStageStatusLabel.Name = "DataStageStatusLabel";
            this.DataStageStatusLabel.Size = new System.Drawing.Size(37, 17);
            this.DataStageStatusLabel.Text = "          ";
            // 
            // DataStageStrip
            // 
            this.DataStageStrip.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.toolStripLabel1,
            this.toolStripLabel2,
            this.toolStripSeparator4,
            this.toolStripDropDownButton1});
            this.DataStageStrip.Location = new System.Drawing.Point(3, 3);
            this.DataStageStrip.Name = "DataStageStrip";
            this.DataStageStrip.Size = new System.Drawing.Size(425, 25);
            this.DataStageStrip.TabIndex = 4;
            this.DataStageStrip.Text = "toolStrip1";
            // 
            // toolStripLabel1
            // 
            this.toolStripLabel1.IsLink = true;
            this.toolStripLabel1.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline;
            this.toolStripLabel1.Name = "toolStripLabel1";
            this.toolStripLabel1.Size = new System.Drawing.Size(33, 22);
            this.toolStripLabel1.Text = "Open";
            this.toolStripLabel1.Click += new System.EventHandler(this.OpenDataFile);
            // 
            // toolStripLabel2
            // 
            this.toolStripLabel2.IsLink = true;
            this.toolStripLabel2.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline;
            this.toolStripLabel2.Name = "toolStripLabel2";
            this.toolStripLabel2.Size = new System.Drawing.Size(31, 22);
            this.toolStripLabel2.Text = "Save";
            this.toolStripLabel2.Click += new System.EventHandler(this.SaveStagedData);
            // 
            // toolStripSeparator4
            // 
            this.toolStripSeparator4.Name = "toolStripSeparator4";
            this.toolStripSeparator4.Size = new System.Drawing.Size(6, 25);
            // 
            // toolStripDropDownButton1
            // 
            this.toolStripDropDownButton1.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text;
            this.toolStripDropDownButton1.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.toolStripMenuItem1,
            this.toolStripMenuItem2});
            this.toolStripDropDownButton1.ForeColor = System.Drawing.Color.Blue;
            this.toolStripDropDownButton1.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.toolStripDropDownButton1.Name = "toolStripDropDownButton1";
            this.toolStripDropDownButton1.Size = new System.Drawing.Size(70, 22);
            this.toolStripDropDownButton1.Text = "Load OIDs";
            this.toolStripDropDownButton1.Visible = false;
            // 
            // toolStripMenuItem1
            // 
            this.toolStripMenuItem1.Name = "toolStripMenuItem1";
            this.toolStripMenuItem1.Size = new System.Drawing.Size(170, 22);
            this.toolStripMenuItem1.Text = "Load Server OIDs";
            this.toolStripMenuItem1.Click += new System.EventHandler(this.LoadServerOIDs);
            // 
            // toolStripMenuItem2
            // 
            this.toolStripMenuItem2.Name = "toolStripMenuItem2";
            this.toolStripMenuItem2.Size = new System.Drawing.Size(170, 22);
            this.toolStripMenuItem2.Text = "Load Client OIDs";
            this.toolStripMenuItem2.Click += new System.EventHandler(this.LoadClientOIDs);
            // 
            // TestDataSet
            // 
            this.TestDataSet.DataSetName = "NewDataSet";
            // 
            // compressionEnabled
            // 
            this.compressionEnabled.AutoSize = true;
            this.compressionEnabled.Location = new System.Drawing.Point(211, 111);
            this.compressionEnabled.Name = "compressionEnabled";
            this.compressionEnabled.Size = new System.Drawing.Size(161, 17);
            this.compressionEnabled.TabIndex = 13;
            this.compressionEnabled.Text = "Client Simulator Compression";
            this.compressionEnabled.UseVisualStyleBackColor = true;
            // 
            // TestHarnessUI
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(804, 555);
            this.Controls.Add(this.splitContainer1);
            this.Name = "TestHarnessUI";
            this.Text = "HL7 Test Harness";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.TestHarnessUI_FormClosing);
            this.splitContainer1.Panel1.ResumeLayout(false);
            this.splitContainer1.Panel1.PerformLayout();
            this.splitContainer1.Panel2.ResumeLayout(false);
            this.splitContainer1.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.TestResults)).EndInit();
            this.ResulttoolStrip.ResumeLayout(false);
            this.ResulttoolStrip.PerformLayout();
            this.ResultStatusBar.ResumeLayout(false);
            this.ResultStatusBar.PerformLayout();
            this.ConfigTabs.ResumeLayout(false);
            this.MsgProxy.ResumeLayout(false);
            this.MsgProxy.PerformLayout();
            this.tabControl1.ResumeLayout(false);
            this.Config.ResumeLayout(false);
            this.VirtualServers.ResumeLayout(false);
            this.VirtualServerData.ResumeLayout(false);
            this.Server1.ResumeLayout(false);
            this.Server1.PerformLayout();
            this.Server2.ResumeLayout(false);
            this.Server2.PerformLayout();
            this.Server3.ResumeLayout(false);
            this.Server3.PerformLayout();
            this.Server4.ResumeLayout(false);
            this.Server4.PerformLayout();
            this.Server5.ResumeLayout(false);
            this.Server5.PerformLayout();
            this.Server6.ResumeLayout(false);
            this.Server6.PerformLayout();
            this.Server7.ResumeLayout(false);
            this.Server7.PerformLayout();
            this.LocalSettings.ResumeLayout(false);
            this.LocalSettings.PerformLayout();
            this.ClientMsg.ResumeLayout(false);
            this.splitContainer2.Panel1.ResumeLayout(false);
            this.splitContainer2.Panel2.ResumeLayout(false);
            this.splitContainer2.ResumeLayout(false);
            this.groupBox2.ResumeLayout(false);
            this.groupBox9.ResumeLayout(false);
            this.ServerMsg.ResumeLayout(false);
            this.splitContainer3.Panel1.ResumeLayout(false);
            this.splitContainer3.Panel2.ResumeLayout(false);
            this.splitContainer3.ResumeLayout(false);
            this.groupBox10.ResumeLayout(false);
            this.groupBox11.ResumeLayout(false);
            this.MsgProxyStatusBar.ResumeLayout(false);
            this.MsgProxyStatusBar.PerformLayout();
            this.MsgProxyToolBar.ResumeLayout(false);
            this.MsgProxyToolBar.PerformLayout();
            this.ClientSimTab.ResumeLayout(false);
            this.ClientSimTab.PerformLayout();
            this.ClientSimContainer.Panel1.ResumeLayout(false);
            this.ClientSimContainer.Panel2.ResumeLayout(false);
            this.ClientSimContainer.ResumeLayout(false);
            this.groupBox4.ResumeLayout(false);
            this.groupBox5.ResumeLayout(false);
            this.ClientSimStatusBar.ResumeLayout(false);
            this.ClientSimStatusBar.PerformLayout();
            this.ClientSimToolBar.ResumeLayout(false);
            this.ClientSimToolBar.PerformLayout();
            this.ServerSimTab.ResumeLayout(false);
            this.ServerSimTab.PerformLayout();
            this.ServerSimContainer.Panel1.ResumeLayout(false);
            this.ServerSimContainer.Panel2.ResumeLayout(false);
            this.ServerSimContainer.ResumeLayout(false);
            this.groupBox6.ResumeLayout(false);
            this.groupBox7.ResumeLayout(false);
            this.ServerSimStatusBar.ResumeLayout(false);
            this.ServerSimStatusBar.PerformLayout();
            this.ServerSimToolBar.ResumeLayout(false);
            this.ServerSimToolBar.PerformLayout();
            this.WorkFlowTab.ResumeLayout(false);
            this.WorkFlowTab.PerformLayout();
            this.groupBox1.ResumeLayout(false);
            this.WorkFlowToolStrip.ResumeLayout(false);
            this.WorkFlowToolStrip.PerformLayout();
            this.StageDataTab.ResumeLayout(false);
            this.StageDataTab.PerformLayout();
            this.panel1.ResumeLayout(false);
            this.panel2.ResumeLayout(false);
            this.groupBox8.ResumeLayout(false);
            this.groupBox3.ResumeLayout(false);
            this.groupBox3.PerformLayout();
            this.DataStageStatusBar.ResumeLayout(false);
            this.DataStageStatusBar.PerformLayout();
            this.DataStageStrip.ResumeLayout(false);
            this.DataStageStrip.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.TestDataSet)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.SplitContainer splitContainer1;
        private System.Windows.Forms.TabControl ConfigTabs;
        private System.Windows.Forms.TabPage ClientSimTab;
        private System.Windows.Forms.StatusStrip ResultStatusBar;
        private System.Windows.Forms.ToolStripStatusLabel status1;
        private System.Windows.Forms.ToolStrip ClientSimToolBar;
        private System.Windows.Forms.ToolStripLabel ClientSimEnable;
        private System.Windows.Forms.ToolStripLabel ClientSimDisable;
        private System.Windows.Forms.SplitContainer ClientSimContainer;
        private System.Windows.Forms.GroupBox groupBox4;
        private System.Windows.Forms.RichTextBox ClientSimTxMsg;
        private System.Windows.Forms.GroupBox groupBox5;
        private System.Windows.Forms.RichTextBox ClientSimRxMsg;
        private System.Windows.Forms.StatusStrip ClientSimStatusBar;
        private System.Windows.Forms.TabPage ServerSimTab;
        private System.Windows.Forms.SplitContainer ServerSimContainer;
        private System.Windows.Forms.GroupBox groupBox6;
        private System.Windows.Forms.RichTextBox ServerSimRxMsg;
        private System.Windows.Forms.GroupBox groupBox7;
        private System.Windows.Forms.RichTextBox ServerSimTxMsg;
        private System.Windows.Forms.StatusStrip ServerSimStatusBar;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator3;
        private System.Windows.Forms.TabPage MsgProxy;
        private System.Windows.Forms.StatusStrip MsgProxyStatusBar;
        private System.Windows.Forms.ToolStrip MsgProxyToolBar;
        private System.Windows.Forms.ToolStripLabel proxyEnable;
        private System.Windows.Forms.ToolStrip ResulttoolStrip;
        private System.Windows.Forms.ToolStripLabel OpenReport;
        private System.Windows.Forms.ToolStripLabel SaveReport;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator1;
        private System.Windows.Forms.ToolStripLabel CreateReport;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator9;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator7;
        private System.Windows.Forms.OpenFileDialog OpenFile;
        private System.Windows.Forms.ToolStripStatusLabel MsgProxyStatus;
        private System.Windows.Forms.ToolStripStatusLabel ClientSimStatus;
        private System.Windows.Forms.ToolStripStatusLabel ServerSimStatus;
        private System.Windows.Forms.SaveFileDialog SaveFile;
        private System.Windows.Forms.ToolStrip ServerSimToolBar;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator5;
        private System.Windows.Forms.ToolStripLabel ServerSimEnable;
        private System.Windows.Forms.ToolStripLabel ServerSimDisable;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator8;
        private System.Windows.Forms.ToolStripLabel GobalStartButton;
        private System.Windows.Forms.ToolStripLabel GlobalStopButton;
        private System.Windows.Forms.ToolStripLabel proxyDisable;
        private System.Windows.Forms.TabPage WorkFlowTab;
        private System.Windows.Forms.ToolStrip WorkFlowToolStrip;
        private System.Windows.Forms.ToolStripLabel RefreshWorkFlow;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator2;
        private System.Windows.Forms.TreeView WorkFlowDisplay;
        private System.Windows.Forms.StatusStrip workFlowStatusBar;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.DataGridView TestResults;
        private System.Windows.Forms.ImageList resultImages;
        private System.Windows.Forms.TextBox localport;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox virtualServer_1;
        private System.Windows.Forms.TextBox RemoteServer_1;
        private System.Windows.Forms.TextBox RemoteServer_7;
        private System.Windows.Forms.TextBox virtualServer_7;
        private System.Windows.Forms.TextBox RemoteServer_6;
        private System.Windows.Forms.TextBox virtualServer_6;
        private System.Windows.Forms.TextBox RemoteServer_5;
        private System.Windows.Forms.TextBox virtualServer_5;
        private System.Windows.Forms.TextBox RemoteServer_4;
        private System.Windows.Forms.TextBox virtualServer_4;
        private System.Windows.Forms.TextBox RemoteServer_3;
        private System.Windows.Forms.TextBox virtualServer_3;
        private System.Windows.Forms.TextBox RemoteServer_2;
        private System.Windows.Forms.TextBox virtualServer_2;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.ToolStripLabel toolStripClientNext;
        private System.Windows.Forms.ToolStripLabel toolStripClientPrev;
        private System.Windows.Forms.ToolStripLabel toolStripServerNext;
        private System.Windows.Forms.ToolStripLabel toolStripServerPrev;
        private System.Windows.Forms.TabControl VirtualServerData;
        private System.Windows.Forms.TabPage Server1;
        private System.Windows.Forms.TabPage Server2;
        private System.Windows.Forms.TabPage Server3;
        private System.Windows.Forms.TabPage Server4;
        private System.Windows.Forms.TabPage Server5;
        private System.Windows.Forms.TabPage Server6;
        private System.Windows.Forms.TabPage Server7;
        private System.Windows.Forms.Label label16;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.Label label9;
        private System.Windows.Forms.Label label10;
        private System.Windows.Forms.Label label11;
        private System.Windows.Forms.Label label12;
        private System.Windows.Forms.Label label13;
        private System.Windows.Forms.Label label14;
        private System.Windows.Forms.Label label15;
        private System.Windows.Forms.GroupBox VirtualServers;
        private System.Windows.Forms.GroupBox LocalSettings;
        private System.Windows.Forms.Label label20;
        private System.Windows.Forms.Label label21;
        private System.Windows.Forms.TextBox RemoteServer_2_psw;
        private System.Windows.Forms.TextBox RemoteServer_2_usr;
        private System.Windows.Forms.Label label22;
        private System.Windows.Forms.Label label23;
        private System.Windows.Forms.TextBox RemoteServer_3_psw;
        private System.Windows.Forms.TextBox RemoteServer_3_usr;
        private System.Windows.Forms.Label label24;
        private System.Windows.Forms.Label label25;
        private System.Windows.Forms.TextBox RemoteServer_4_psw;
        private System.Windows.Forms.TextBox RemoteServer_4_usr;
        private System.Windows.Forms.Label label26;
        private System.Windows.Forms.Label label27;
        private System.Windows.Forms.TextBox RemoteServer_5_psw;
        private System.Windows.Forms.TextBox RemoteServer_5_usr;
        private System.Windows.Forms.Label label28;
        private System.Windows.Forms.Label label29;
        private System.Windows.Forms.TextBox RemoteServer_6_psw;
        private System.Windows.Forms.TextBox RemoteServer_6_usr;
        private System.Windows.Forms.Label label30;
        private System.Windows.Forms.Label label31;
        private System.Windows.Forms.TextBox RemoteServer_7_psw;
        private System.Windows.Forms.TextBox RemoteServer_7_usr;
        private System.Windows.Forms.TabPage StageDataTab;
        private System.Windows.Forms.ToolStrip DataStageStrip;
        private System.Windows.Forms.ToolStripLabel toolStripLabel1;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator4;
        private System.Windows.Forms.StatusStrip DataStageStatusBar;
        private System.Windows.Forms.RichTextBox DataStageOutput;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.ToolStripStatusLabel DataStageStatusLabel;
        private System.Windows.Forms.Panel panel2;
        private System.Data.DataSet TestDataSet;
        private System.Windows.Forms.CheckBox SimulatorServer1;
        private System.Windows.Forms.CheckBox SimulatorServer2;
        private System.Windows.Forms.CheckBox SimulatorServer3;
        private System.Windows.Forms.CheckBox SimulatorServer4;
        private System.Windows.Forms.CheckBox SimulatorServer5;
        private System.Windows.Forms.CheckBox SimulatorServer6;
        private System.Windows.Forms.CheckBox SimulatorServer7;
        private System.Windows.Forms.TextBox RemoteServer_1_psw;
        private System.Windows.Forms.TextBox RemoteServer_1_usr;
        private System.Windows.Forms.Label label18;
        private System.Windows.Forms.Label label19;
        private System.Windows.Forms.Label label17;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.TextBox Security_psw;
        private System.Windows.Forms.TextBox Security_user;
        private System.Windows.Forms.CheckBox SecurityEnable;
        private System.Windows.Forms.CheckBox GenerateServerData;
        private System.Windows.Forms.CheckBox GenerateClientData;
        private System.Windows.Forms.ToolStripDropDownButton toolStripDropDownButton1;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem1;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem2;
        private System.Windows.Forms.ToolStripLabel toolStripLabel2;
        private System.Windows.Forms.CheckBox SingleMsgLoop;
        private System.Windows.Forms.CheckBox WorkFlowLoop;
        private System.Windows.Forms.Button btnGenerateData;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator10;
        private System.Windows.Forms.ToolStripLabel HelpLink;
        private System.Windows.Forms.ToolStripStatusLabel MsgProxyEnableStatus;
        private System.Windows.Forms.ToolStripStatusLabel ClientSimEnableStatus;
        private System.Windows.Forms.ToolStripStatusLabel ServerSimEnableStatus;
        private System.Windows.Forms.CheckBox updateSimMsg;
        private System.Windows.Forms.Label label32;
        private System.Windows.Forms.TextBox SeverSimPort;
        private System.Windows.Forms.CheckBox validateClient;
        private System.Windows.Forms.CheckBox constructMsg;
        private System.Windows.Forms.CheckBox validateServer;
        private System.Windows.Forms.GroupBox groupBox3;
        private System.Windows.Forms.GroupBox groupBox8;
        private System.Windows.Forms.ToolStripLabel proxyEnabledIcon;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator11;
        private System.Windows.Forms.ToolStripLabel proxyDisabledIcon;
        private System.Windows.Forms.ToolStripLabel ClientSimDisabledIcon;
        private System.Windows.Forms.ToolStripLabel ClientSimEnabledIcon;
        private System.Windows.Forms.ToolStripLabel ServerSimEnabledIcon;
        private System.Windows.Forms.ToolStripLabel ServerSimDisabledIcon;
        private System.Windows.Forms.TabControl tabControl1;
        private System.Windows.Forms.TabPage Config;
        private System.Windows.Forms.TabPage ClientMsg;
        private System.Windows.Forms.TabPage ServerMsg;
        private System.Windows.Forms.SplitContainer splitContainer2;
        private System.Windows.Forms.GroupBox groupBox2;
        private System.Windows.Forms.RichTextBox ProxyClientRxMsg;
        private System.Windows.Forms.GroupBox groupBox9;
        private System.Windows.Forms.RichTextBox ProxyClientTxMsg;
        private System.Windows.Forms.SplitContainer splitContainer3;
        private System.Windows.Forms.GroupBox groupBox10;
        private System.Windows.Forms.RichTextBox ProxyServerTxMsg;
        private System.Windows.Forms.GroupBox groupBox11;
        private System.Windows.Forms.RichTextBox ProxyServerRxMsg;
        private System.Windows.Forms.ToolStripLabel toolStripProxyNext;
        private System.Windows.Forms.ToolStripLabel toolStripProxyPrev;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator6;
        private System.Windows.Forms.CheckBox compressionEnabled;
    }
}

