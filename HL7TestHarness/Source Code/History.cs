/* Module Header

  $Header:   L:/pvcsrep65/HL7TestHarness/archives/Source Code/History.cs-arc   1.17   19 Jul 2007 15:44:58   mwicks  $

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

  $Log:   L:/pvcsrep65/HL7TestHarness/archives/Source Code/History.cs-arc  $
 *
 *   Rev 1.17   19 Jul 2007 15:44:58   mwicks
 *Updated 
 *change tcp handling
 *removed thread sleeps
 *added attribute to disable client sim by message.
 *
 *   Rev 1.16   18 Jan 2007 14:20:16   mwicks
 *updated reporting and workflow schemas.
  Revision 1.1.1.1  2006/11/24 18:16:41  deltaware
  Init check in of HL7 Test Harness, version 2.0.3.9. For releases before this version please contact deltaware systems.

 *
 *   Rev 1.15   11 Sep 2006 16:10:24   mwicks
 *updated tcp monitoring to monitor the dns HostName instead of the localhost name.
 *
 *   Rev 1.14   31 Aug 2006 11:48:44   mwicks
 *updated to remove memory leaks
 *
 *   Rev 1.13   15 Aug 2006 16:16:56   mwicks
 *Updated to load xmlfile using streams.
 *updated to include parameters in construction transforms
 *updated workflows to allow paramlists.
 *
 *   Rev 1.12   03 Aug 2006 15:04:16   mwicks
 *Changed xml loading processes to always load from a stream.
 *xmldoc.loadxml(string) 
 *changed to 
 *xsldoc.load(new StringStream(string))
 *
 *
 *   Rev 1.11   28 Jun 2006 16:24:22   mwicks
 *removed "All Rights Reserved." from all files.
 *
 *   Rev 1.10   26 Jun 2006 13:29:24   mwicks
 *added Lic
 *
 *   Rev 1.9   26 Jun 2006 13:18:24   mwicks
 *Updated License.
 *
 *   Rev 1.8   23 Jun 2006 09:11:46   mwicks
 *updated comments
 *
 *   Rev 1.7   24 May 2006 10:33:40   mwicks
 *updated to allow system to be used as a true proxy
 *
 *   Rev 1.6   27 Apr 2006 14:40:14   mwicks
 *Added Server user and password fields
 *
 *   Rev 1.5   30 Mar 2006 11:30:22   mwicks
 *Updated Log file to fix TxMessage bug
 *
 *   Rev 1.4   28 Mar 2006 15:57:38   mwicks
 *Update for error handling
 *
 *   Rev 1.3   22 Mar 2006 11:29:52   mwicks
 *Updated Http get reqest in message proxy and server to parse request correctly.
 *
 *   Rev 1.2   21 Mar 2006 13:24:00   mwicks
 *Multi message update
 *
 *   Rev 1.1   17 Mar 2006 15:46:28   mwicks
 *Updated $Header
*/
using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Xml;
using System.Xml.XPath;

namespace HL7TestHarness
{
    class History
    {
        public enum historyEvent { clientRequest, clientResponse, serverRequest, serverResponse };
        private String historyFilename;
        public XmlDocument historyDocument;
        private XPathNavigator navigator;
        
        /// <summary>
        /// Constructor
        /// Creates a history file on disk
        /// </summary>
        /// <param name="filename"></param>
        public History(String filename)
        {
            XmlWriter historyDocumentWriter;

            historyFilename = filename;

            historyDocument = new XmlDocument();
            navigator = historyDocument.CreateNavigator();
            historyDocumentWriter = navigator.PrependChild();

            historyDocumentWriter.WriteStartElement("historyData");
            historyDocumentWriter.WriteEndElement();
            historyDocumentWriter.Close();
            historyDocumentWriter = null;

            historyDocument.Save(historyFilename);
        }

        ~History()
        {
            historyFilename = "";
            historyDocument = null;
            navigator = null;
        }
        /// <summary>
        /// Creates an entry in the history file that is on disk.
        /// </summary>
        /// <param name="document">data to be stored in history file</param>
        /// <param name="eventType">historyEvent type 
        /// clientRequest|serverRequest|serverResponse|clientResponse</param>
        /// <param name="Address">address message is going to or coming from</param>
        /// <param name="threadID">exicution thread id (identifier)</param>
        public void createEntry(XmlDocument document, historyEvent eventType, String Address ,String threadID)
        {
            XmlWriter historyDocumentWriter;
            XPathNodeIterator interator;
            switch (eventType)
            {
                case historyEvent.clientRequest:
                    interator = navigator.Select("historyData");
                    interator.MoveNext();
                    historyDocumentWriter = interator.Current.AppendChild();
                    historyDocumentWriter.WriteStartElement("request");
                    historyDocumentWriter.WriteAttributeString("thread", threadID);
                    historyDocumentWriter.WriteStartElement("client");
                    historyDocumentWriter.WriteAttributeString("timeStamp", System.DateTime.Now.ToString());
                    historyDocumentWriter.WriteAttributeString("address", Address);
                    historyDocumentWriter.WriteNode(document.CreateNavigator(), false);
                    historyDocumentWriter.WriteEndElement();
                    historyDocumentWriter.WriteEndElement();
                    historyDocumentWriter.Close();
                    historyDocument.Save(historyFilename);
                    break;
                case historyEvent.serverRequest:
                    interator = navigator.Select("historyData/request[@thread=\"" + threadID + "\"][position()=last()]");
                    interator.MoveNext();
                    historyDocumentWriter = interator.Current.AppendChild();
                    historyDocumentWriter.WriteStartElement("server");
                    historyDocumentWriter.WriteAttributeString("timeStamp", System.DateTime.Now.ToString());
                    historyDocumentWriter.WriteAttributeString("address", Address);
                    historyDocumentWriter.WriteNode(document.CreateNavigator(), false);
                    historyDocumentWriter.WriteEndElement();
                    historyDocumentWriter.Close();
                    historyDocument.Save(historyFilename);
                    break;
                case historyEvent.serverResponse:
                    interator = navigator.Select("historyData");
                    interator.MoveNext();
                    historyDocumentWriter = interator.Current.AppendChild();
                    historyDocumentWriter.WriteStartElement("response");
                    historyDocumentWriter.WriteAttributeString("thread", threadID);
                    historyDocumentWriter.WriteStartElement("server");
                    historyDocumentWriter.WriteAttributeString("timeStamp", System.DateTime.Now.ToString());
                    historyDocumentWriter.WriteAttributeString("address", Address);
                    historyDocumentWriter.WriteNode(document.CreateNavigator(), false);
                    historyDocumentWriter.WriteEndElement();
                    historyDocumentWriter.WriteEndElement();
                    historyDocumentWriter.Close();
                    historyDocument.Save(historyFilename);
                    break;
                case historyEvent.clientResponse:
                    interator = navigator.Select("historyData/response[@thread=\"" + threadID + "\"][position()=last()]");
                    interator.MoveNext();
                    historyDocumentWriter = interator.Current.AppendChild();
                    historyDocumentWriter.WriteStartElement("client");
                    historyDocumentWriter.WriteAttributeString("timeStamp", System.DateTime.Now.ToString());
                    historyDocumentWriter.WriteAttributeString("address", Address);
                    historyDocumentWriter.WriteNode(document.CreateNavigator(), false);
                    historyDocumentWriter.WriteEndElement();
                    historyDocumentWriter.Close();
                    historyDocument.Save(historyFilename);
                    break;
                default:
                    break;
            }
            historyDocumentWriter = null;
            interator = null;
        }

    }
}
