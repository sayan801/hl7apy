/* Module Header

  $Header:   L:/pvcsrep65/HL7TestHarness/archives/Source Code/console.cs-arc   1.13   10 Apr 2007 15:15:24   mwicks  $

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

  $Log:   L:/pvcsrep65/HL7TestHarness/archives/Source Code/console.cs-arc  $
 *
 *   Rev 1.13   10 Apr 2007 15:15:24   mwicks
 *Updated to fix the load of the test data file from the config file.
 *
 *   Rev 1.12   26 Mar 2007 13:29:50   mwicks
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
 *   Rev 1.11   16 Mar 2007 15:46:00   mwicks
 *updated for the following:
 *1. msg proxy and client sim will replace localhost address names with machine name.
 *2. msg proxy outputs timing and number of messages sent.
 *3. commandline has auto control file.
 *4. GUI msg proxy now shows msgs from client and server systems.
 *5. GUI enable/disable redone to be more clear.
 *6. Results data grid columns re-sizeable
 *7. commandline will now handle all development options that GUI uses.
 *
 *   Rev 1.10   18 Jan 2007 14:20:16   mwicks
 *updated reporting and workflow schemas.
  Revision 1.1.1.1  2006/11/24 18:16:41  deltaware
  Init check in of HL7 Test Harness, version 2.0.3.9. For releases before this version please contact deltaware systems.

 *
 *   Rev 1.9   11 Sep 2006 16:10:24   mwicks
 *updated tcp monitoring to monitor the dns HostName instead of the localhost name.
 *
 *   Rev 1.8   29 Jun 2006 10:48:16   mwicks
 *updated status messages for console
 *
 *   Rev 1.7   29 Jun 2006 10:11:14   mwicks
 *updated console to exit after running
 *
 *   Rev 1.6   28 Jun 2006 16:25:50   mwicks
 *Added GPL

 */

using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Threading;
using System.IO;


namespace HL7TestHarness
{
    public class TestHarnessConsole
    {
        private TestHarness TestHarnessEngine;
        private String logfilename;
        private String logTransform;
        private String configFile;
        private String workflow;
        private String workingDirectory;
        private String testDataFile;
        private String AutoControlFile;
        private int BurstMode = 0;
        private bool stageClient = false;
        private bool stageServer = false;
        private bool IsFinished = true;
        private bool consoleInput = true;

        public TestHarnessConsole(string[] args)
        {
            String[] arg;
            bool ProcessCancelled = false;

            try
            {

                configFile = "";
                workflow = "";
                logfilename = "";
                logTransform = "";
                testDataFile = "";

                Console.WriteLine("");
                Console.WriteLine("HL7 Test Harness v" + System.Windows.Forms.Application.ProductVersion.ToString());
                Console.WriteLine("Copyright (C) 2006 DeltaWare Systems Inc.");
                Console.WriteLine("");
                Console.WriteLine("This software comes with ABSOLUTELY NO WARRANTY. This is free software, and you are welcome to redistribute it under certain conditions; for details of conditions and warranty info see license.txt\n\n");

                for (int index = 0; index < args.Length; index++)
                {
                    arg = args[index].Split(new Char[] { ':' }, 2);

                    // get the command line arguments by name.
                    //Console.WriteLine(arg[0] + " - " + arg[1]);
                    switch (arg[0])
                    {
                        case "/config":
                            configFile = arg[1];
                            if (configFile.IndexOf(":\\") <= 0)
                            { configFile = Directory.GetCurrentDirectory() + "\\" + configFile; }
                            break;
                        case "/workflow":
                            workflow = arg[1];
                            if (workflow.IndexOf(":\\") <= 0)
                            { workflow = Directory.GetCurrentDirectory() + "\\" + workflow; }
                            break;
                        case "/out":
                            logfilename = arg[1];
                            if (logfilename.IndexOf(":\\") <= 0)
                            { logfilename = Directory.GetCurrentDirectory() + "\\" + logfilename; }
                            break;
                        case "/transform":
                            logTransform = arg[1];
                            if (logTransform.IndexOf(":\\") <= 0)
                            { logTransform = Directory.GetCurrentDirectory() + "\\" + logTransform; }
                            break;
                        case "/testdata":
                            testDataFile = arg[1];
                            if (testDataFile.IndexOf(":\\") <= 0)
                            { testDataFile = Directory.GetCurrentDirectory() + "\\" + testDataFile; }
                            break;
                        case "/stageClient":
                            stageClient = true;
                            break;
                        case "/stageServer":
                            stageServer = true;
                            break;
                        case "/noConsoleInput":
                            consoleInput = false;
                            break;
                        case "/autoControl":
                            AutoControlFile = arg[1];
                            if (AutoControlFile.IndexOf(":\\") <= 0)
                            { AutoControlFile = Directory.GetCurrentDirectory() + "\\" + AutoControlFile; }
                            break;
                        case "/burstMode":
                            try
                            {
                                BurstMode = int.Parse(arg[1]);
                            }
                            catch
                            {
                                BurstMode = 0;
                            }
                            break;
                        default:
                            break;
                    }
                }

                //min number of command line arg are the configfiel and logfile
                if (configFile.Length > 0 & logfilename.Length > 0)
                {
                    Console.WriteLine("Loading configuration File...");
                    TestHarnessEngine = new TestHarness(configFile,
                                                        outputProxyMsg,
                                                        outputClientSimMsg,
                                                        outputServerSimMsg,
                                                        ProcessXML,
                                                        stop);

                    TestHarnessEngine.burstMode = BurstMode;
                    if (workflow.Length <= 0)
                    {
                        Console.WriteLine("Extacting Workflow file directory from configuration File...");
                        workflow = TestHarnessEngine.UIConfig.WorkFlowFileName;
                    }
                    else
                    {
                        Console.WriteLine("Extacting Workflow directory from command line workflow argument...");
                    }

                    workingDirectory = workflow.Substring(0, workflow.LastIndexOf("\\"));


                    Console.WriteLine("Loading WorkFlow file...");
                    if (TestHarnessEngine.UIConfig.testData.datafile == "")
                    {
                        TestHarnessEngine.LoadWorkFlowFile(workflow, true);
                    }
                    else
                    {
                        TestHarnessEngine.LoadWorkFlowFile(workflow, false);
                        Console.WriteLine("Loading TestData file from configuration file...");
                        if (TestHarnessEngine.UIConfig.testData.datafile.LastIndexOf(":\\") <= 0)
                            TestHarnessEngine.UIConfig.testData.datafile = workingDirectory + TestHarnessEngine.UIConfig.testData.datafile;

                        TestHarnessEngine.LoadDataFile(TestHarnessEngine.UIConfig.testData.datafile);
                    }
                    Console.WriteLine("Moving to working Directory...");
                    Directory.SetCurrentDirectory(workingDirectory);
                    Console.WriteLine("Compiling TestData...");
                    TestHarnessEngine.dataStager.reStageData(false, false);


                    outputConfig();

                    do
                    {
                        if (AutoControlFile != null)
                        {
                            Console.Write("Waiting for Control File .");

                            // if control file is being used wait until it is present before starting.
                            while (File.Exists(AutoControlFile) == false & ProcessCancelled == false)
                            {
                                Console.Write(".");
                                Thread.Sleep(1000);
                                if (consoleInput)
                                {
                                    if (Console.KeyAvailable)
                                    {
                                        ProcessCancelled = true;
                                    }
                                }

                            }
                        }
                        Console.WriteLine("");
                        if (ProcessCancelled == false)
                        {
                            if (consoleInput)
                                Console.WriteLine("Starting TestHarness Threads (Press Any Key To Stop)...\n\n");
                            else
                                Console.WriteLine("Starting TestHarness Threads (Console Input Disabled)...\n\n");

                            if (AutoControlFile != null)
                                Console.WriteLine("  (control file: " + AutoControlFile + ")\n\n");

                            TestHarnessEngine.GlobalStart();
                            IsFinished = false;
                            while (TestHarnessEngine.IsFinished == false & IsFinished == false)
                            {
                                if (consoleInput)
                                {
                                    if (Console.KeyAvailable)
                                    {
                                        ProcessCancelled = true;
                                        Console.WriteLine("Stopping TestHarness (Key Pressed)...\n\n");
                                        TestHarnessEngine.GlobalStop();
                                        Thread.Sleep(3000);
                                        stop();
                                    }
                                }
                                if (AutoControlFile != null)
                                {
                                    // if control file is being used check if it has been removed, removal causes stop.
                                    if (File.Exists(AutoControlFile) == false)
                                    {
                                        Console.WriteLine("Stopping TestHarness (Control File Removed)...\n\n");
                                        TestHarnessEngine.GlobalStop();
                                        Thread.Sleep(3000);
                                        stop();
                                    }
                                }
                            }
                        }
                        // if we are configured to do workflow looping then rerun the test.
                    } while (TestHarnessEngine.UIConfig.MessageProxyConfig.workflowLoop & ProcessCancelled == false);
                }
                else if (testDataFile.Length > 0 & logfilename.Length > 0)
                {
                    Console.WriteLine("Loading Data file...");
                    DataStage dataStager = new DataStage();
                    dataStager.loadDataFile(testDataFile);
                    Console.WriteLine("Creating Staged Data...");
                    dataStager.reStageData(stageClient, stageServer);
                    Console.WriteLine("Saving Staged Data to File...");
                    dataStager.StagedData.Save(logfilename);
                    Console.Write("Finished.\n");
                }
                else
                {
                    Help();
                    Console.WriteLine("\n\nERROR: Wrong number of arguments");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("EXCEPTION:");
                Console.WriteLine(ex.Message);
            }
        }

        private void outputClientSimMsg(String data)
        {
            Console.WriteLine("Client Simulator : " + data);
        }
        private void outputServerSimMsg(String data)
        {
            Console.WriteLine("Server Simulator : " + data);
        }
        private void outputProxyMsg(String data)
        {
            Console.WriteLine("Message Proxy    : " + data);
        }
        private void stop()
        {
            try
            {
                Console.Write("Creating Logfiles");
                // the log tread takes a bit of time to finish up, 
                // currently there is no way to know if all log threads 
                // have finished executing so we just wait a few seconds 
                // to give it lots of time to finish.
                for (int i = 5; i > 0; i--)
                {
                    Console.Write(".");
                    Thread.Sleep(1000);
                }
                if (logTransform != "")
                {
                    FileStream file = new FileStream(logfilename + ".transformed", FileMode.Create, FileAccess.Write);
                    StreamWriter sw = new StreamWriter(file);
                    sw.Write(TestHarnessEngine.systemLog.getHtmlReportLog(logTransform));
                    sw.Close();
                    file.Close();
                }
                TestHarnessEngine.systemLog.logFile.Save(logfilename);
                Console.WriteLine(".");

            }
            catch (Exception ex)
            {
                Console.WriteLine("Exception: " + ex.Message);
            }

            IsFinished = true;
            Console.WriteLine("Finished.\n");
            
        }
        private void ProcessXML(XmlDocument xdoc)
        {
            //Console.WriteLine("xml ouput");
        }
        private void Help()
        {
            String  usage = "";
            usage = usage + "\nUsage:";
            usage = usage + "\n(Running workflows)";
            usage = usage + "\n HL7TestHarnessConsole /config:configFile.xml ";
            usage = usage + "\n                       /out:outputFile.ext ";
            usage = usage + "\n                       [/workflow:workflowFile.xml] ";
            usage = usage + "\n                       [/transform:outputTransformFile.xsl]";
            usage = usage + "\n                       [/noConsoleInput]";
            usage = usage + "\n                       [/autoControl:controlFileName]";
            usage = usage + "\nParameters:";
            usage = usage + "\n/config         system setup config file.";
            usage = usage + "\n/out            test results output file name. Output will be in xml format.";
            usage = usage + "\n/workflow       (optional) when present over-rides the workflow document ";
            usage = usage + "\n                defined in the config file.";
            usage = usage + "\n/transform      (optional) file name of a style sheet (xsl) that is applied to ";
            usage = usage + "\n                the results of the test. resulting data is stored in a file";
            usage = usage + "\n                named outputFile.ext.transform";
            usage = usage + "\n/noConsoleInput (optional) if present the applicaiton will not look for key ";
            usage = usage + "\n                presses from the console to allow you to stop the application ";
            usage = usage + "\n                from running ";            
            usage = usage + "\n/autoControl    (optional) filname of a control file used to start and stop the";
            usage = usage + "\n                application. System will start when file is present and stop";
            usage = usage + "\n                when file is removed.";
            usage = usage + "\n/burstMode      (optional) int value indicating number of messages to send in";
            usage = usage + "\n                burst of communications. Note: Messages are pre-created so ";
            usage = usage + "\n                values can not be retrived from other response messages.";
            usage = usage + "\n";
            usage = usage + "\n(Test Data Stager)";
            usage = usage + "\n HL7TestHarnessConsole /testdata:data.xml ";
            usage = usage + "\n                       /out:output.xml ";
            usage = usage + "\n                       [/stageClient] ";
            usage = usage + "\n                       [/stageServer]";
            usage = usage + "\nParameters:";
            usage = usage + "\n/testdata       Test Data file to be Stages.";
            usage = usage + "\n/out            test results output file name.";
            usage = usage + "\n/stageClient    (optional)If present stage the Client side data.";
            usage = usage + "\n/stageServer    (optional)If present stage the Server side data.";
            usage = usage + "\n";

            Console.WriteLine(usage);
        }

        private void outputConfig()
        {
            Console.WriteLine("\n---- Configuration ----");
            Console.WriteLine("Configuration Files");
            Console.WriteLine("  Working Directory: " + workingDirectory);
            Console.WriteLine("  Config File: " + configFile);
            Console.WriteLine("  WorkFlow File: " + workflow);
            Console.WriteLine("  Log File: " + logfilename);
            Console.WriteLine("  Log Xsl File: " + logTransform);
            Console.WriteLine("Simulators");
            Console.WriteLine("  ClientSimulator Enable:" + TestHarnessEngine.UIConfig.ClientSimulatorConfig.enabled);
            Console.WriteLine("  ServerSimulator Enable:" + TestHarnessEngine.UIConfig.ServerSimulatorConfig.enabled);
            Console.WriteLine("  MessageProxy Enable:" + TestHarnessEngine.UIConfig.MessageProxyConfig.enabled);
            Console.WriteLine("Options");
            Console.WriteLine("  WorkFlow Loop Enable:" + TestHarnessEngine.UIConfig.MessageProxyConfig.workflowLoop);
            Console.WriteLine("  Message Loop Enable:" + TestHarnessEngine.UIConfig.MessageProxyConfig.msgLoop);
            Console.WriteLine("  Client Validation Enable:" + TestHarnessEngine.UIConfig.MessageProxyConfig.clientValidation);
            Console.WriteLine("  Server Validation Enable:" + TestHarnessEngine.UIConfig.MessageProxyConfig.serverValidation);
            Console.WriteLine("  Message Translation Enable:" + TestHarnessEngine.UIConfig.MessageProxyConfig.msgConstructor);
            Console.WriteLine("  Burst Mode:" + TestHarnessEngine.burstMode.ToString());
            Console.WriteLine("-----------------------\n");
        }
    }
}
