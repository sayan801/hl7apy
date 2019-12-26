/* Module Header

  $Header:   L:/pvcsrep65/HL7TestHarness/archives/Source Code/Simulator.cs-arc   1.18   24 Jul 2007 15:17:52   mwicks  $

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

  $Log:   L:/pvcsrep65/HL7TestHarness/archives/Source Code/Simulator.cs-arc  $
 *
 *   Rev 1.18   24 Jul 2007 15:17:52   mwicks
 *updated to include http compression options
 *
 *   Rev 1.17   19 Jul 2007 15:45:00   mwicks
 *Updated 
 *change tcp handling
 *removed thread sleeps
 *added attribute to disable client sim by message.
 *
 *   Rev 1.16   26 Mar 2007 13:29:54   mwicks
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
 *   Rev 1.15   18 Jan 2007 14:20:24   mwicks
 *updated reporting and workflow schemas.
  Revision 1.1.1.1  2006/11/24 18:16:45  deltaware
  Init check in of HL7 Test Harness, version 2.0.3.9. For releases before this version please contact deltaware systems.

 *
 *   Rev 1.14   28 Sep 2006 15:23:00   mwicks
 *updated to allow for validations to be dependent on message name.
 *
 *   Rev 1.13   11 Sep 2006 16:10:30   mwicks
 *updated tcp monitoring to monitor the dns HostName instead of the localhost name.
 *
 *   Rev 1.12   06 Sep 2006 10:40:18   mwicks
 *updated to allow soap wrappers to be used.
 *
 *   Rev 1.11   05 Sep 2006 13:18:00   mwicks
 *Updated to reduce memory usage
 *
 *   Rev 1.10   31 Aug 2006 11:48:46   mwicks
 *updated to remove memory leaks
 *
 *   Rev 1.9   28 Jun 2006 16:24:30   mwicks
 *removed "All Rights Reserved." from all files.
 *
 *   Rev 1.8   26 Jun 2006 13:29:26   mwicks
 *added Lic
 *
 *   Rev 1.7   26 Jun 2006 13:18:26   mwicks
 *Updated License.
 *
 *   Rev 1.6   23 Jun 2006 09:11:48   mwicks
 *updated comments
 *
 *   Rev 1.5   26 May 2006 15:19:24   mwicks
 *update file headers to include PVCS tags
 *updated config file to use bool instead of strings.

 */

using System;
using System.IO;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using System.Collections.Specialized;
using System.ComponentModel;
using System.Xml;
using System.Xml.Xsl;

namespace HL7TestHarness
{
    public enum testResultStatus { pass, fail, NA, processing, done, exception, noUpdate };
    /// <summary>
    /// testResults object
    /// used to send data between Simulators and the Test logging system.
    /// </summary>
    public class testResults : EventArgs
    {
        public String xpath;
        public String status;
        public String details;
        public String element;
        public String timeStamp;



        public testResults(String path, String testStatus, String elementName, String testDetails)
        {
            this.xpath = path;
            this.status = testStatus;
            this.details = testDetails;
            this.element = elementName;
            this.timeStamp = System.DateTime.Now.ToString();

        }
    }

    /// <summary>
    /// delegate functions used by the simulator relay processing data back
    /// to the calling object.
    /// </summary>
    public delegate void onProgressEventHandler(String status);
    public delegate void onCompleteEventHandler();
    public delegate void onTestProgressEventHandler(testResults e);

    public class MsgTimer
    {
        private Int64 total = 0;
        private Int64 total_time = 0;
        private Int64 start_time;
        private Int64 end_time;
        private Int64 Last_time = 0;

        public void start()
        {
            start_time = System.Environment.TickCount;
        }
        public void stop()
        {
            end_time = System.Environment.TickCount;

            Last_time = end_time - start_time;
            total_time += Last_time;
            total++;
        }
        public String Average()
        {
            Int64 avg = 0;
            if (total > 0)
                avg = total_time / total;
            return avg.ToString();
        }
        public String Count()
        {
            return total.ToString();
        }
        public Int64 count()
        {
            return total;
        }
        public String Total()
        {
            return total_time.ToString();
        }
        public String Last()
        {
            return Last_time.ToString();
        }

    }

    public abstract class Simulator
    {

        protected String pass = "PASS";
        protected String fail = "FAIL";
        protected String na = "N/A";
        protected String processing = "";
        protected String done = "DONE";
        protected String exception = "EXCEPTION";

        public bool compressionEnabled = true; //false;

        public AsyncOperation asyncOp;

        public event onProgressEventHandler OnProgressChange;
        public event onCompleteEventHandler OnComplete;
        public event onTestProgressEventHandler onTestProgress;

        private SendOrPostCallback onProgressChangeDelegate;
        private SendOrPostCallback onCompleteDelegate;
        private SendOrPostCallback onTestProgressDelegate;

        public Simulator()
        {
            onProgressChangeDelegate = new SendOrPostCallback(ProgressChange);
            onCompleteDelegate = new SendOrPostCallback(Complete);
            onTestProgressDelegate = new SendOrPostCallback(TestProgress);
        }

        protected void setAsyncOperation(AsyncOperation Op)
        {
            asyncOp = Op;
        }

        private void ProgressChange(object state)
        {
            OnProgressChange(state as String);
        }

        private void Complete(object state)
        {
            OnComplete();
        }

        private void TestProgress(object state)
        {
            testResults e = state as testResults;
            onTestProgress(e);
        }

        /// <summary>
        /// Method used by desendent to send process status updated to 
        /// the delegate.
        /// </summary>
        protected void reportProgressChange(String status)
        {
            if ((onProgressChangeDelegate != null) & (asyncOp != null))
            {

                asyncOp.Post(this.onProgressChangeDelegate, "[" + System.Environment.TickCount.ToString() + "]" + status);
                Thread.Sleep(0);
            }
        }

        /// <summary>
        /// Method used by desendent to report the process has completed.
        /// </summary>
        protected void reportComplete()
        {
            if ((onCompleteDelegate != null) & (asyncOp != null))
            {
                asyncOp.Post(this.onCompleteDelegate, null);
                Thread.Sleep(0);
            }
        }

        /// <summary>
        /// Method used by desendent to send test results to 
        /// the delegate fuction designated to hand test result messages.
        /// </summary>
        protected void reportTestProgress(String path, testResultStatus testStatus, String elementName, String testDetails)
        {
            if ((onTestProgressDelegate != null) & (asyncOp != null))
            {
                String status;
                switch (testStatus)
                {
                    case testResultStatus.pass:
                        status = pass;
                        break;
                    case testResultStatus.fail:
                        status = fail;
                        break;
                    case testResultStatus.NA:
                        status = na;
                        break;
                    case testResultStatus.exception:
                        status = exception;
                        break;
                    case testResultStatus.processing:
                        status = processing;
                        break;
                    case testResultStatus.done:
                        status = done;
                        break;
                    default:
                        status = "";
                        break;
                }

                testResults result = new testResults(path, status, elementName, testDetails);
                asyncOp.Post(this.onTestProgressDelegate, result);
                Thread.Sleep(0);
            }
        }

    }
}
