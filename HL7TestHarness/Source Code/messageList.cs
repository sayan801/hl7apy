/* Module Header

  $Header:   L:/pvcsrep65/HL7TestHarness/archives/Source Code/messageList.cs-arc   1.6   16 Mar 2007 15:46:02   mwicks  $

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

  $Log:   L:/pvcsrep65/HL7TestHarness/archives/Source Code/messageList.cs-arc  $
 *
 *   Rev 1.6   16 Mar 2007 15:46:02   mwicks
 *updated for the following:
 *1. msg proxy and client sim will replace localhost address names with machine name.
 *2. msg proxy outputs timing and number of messages sent.
 *3. commandline has auto control file.
 *4. GUI msg proxy now shows msgs from client and server systems.
 *5. GUI enable/disable redone to be more clear.
 *6. Results data grid columns re-sizeable
 *7. commandline will now handle all development options that GUI uses.
 *
 *   Rev 1.5   18 Jan 2007 14:20:24   mwicks
 *updated reporting and workflow schemas.
  Revision 1.1.1.1  2006/11/24 18:16:43  deltaware
  Init check in of HL7 Test Harness, version 2.0.3.9. For releases before this version please contact deltaware systems.

 *
 *   Rev 1.4   06 Oct 2006 08:13:36   mwicks
 *updated to fix a bug in the process message groups, optional messages and non-seq messages.
 *
 *   Rev 1.3   11 Sep 2006 16:10:28   mwicks
 *updated tcp monitoring to monitor the dns HostName instead of the localhost name.
 *
 *   Rev 1.2   31 Aug 2006 11:48:46   mwicks
 *updated to remove memory leaks
 *
 *   Rev 1.1   29 Aug 2006 14:46:38   mwicks
 *Updated to fix some memory issues.
 *
 *   Rev 1.0   02 Aug 2006 15:59:36   mwicks
 *Initial revision.
*/
using System;
using System.Collections.Generic;
using System.Text;


namespace HL7TestHarness
{
    class messageList
    {
        private class msgItem
        {
            public String xpath;
            public String group;
            public String msgName;
            public Boolean processed;
            public Boolean optional;
            public Boolean nonsequential;
            public Boolean repeatable;

            public msgItem(String Xpath, String Group, String MsgName, Boolean Optional, Boolean NonSequential, Boolean Repeatable)
            {
                xpath = Xpath;
                group = Group;
                msgName = MsgName;
                processed = false;
                optional = Optional;
                nonsequential = NonSequential;
                repeatable = Repeatable;
            }
            ~msgItem()
            {
                xpath = null;
                group = null;
                msgName = null;
            }
        }

        private List<msgItem> msgList = new List<msgItem>();
        private String searchGroup;
        private String searchMsgName;


        ~messageList()
        {
            if(msgList != null)
                msgList.Clear();
            msgList = null;
            searchGroup = null;
            searchMsgName = null;
        }

        public void add(String xpath, String group, String messageName, Boolean optional, Boolean nonsequential, Boolean repeatable)
        {
            msgList.Add(new msgItem(xpath, group, messageName, optional, nonsequential, repeatable));
        }

        public void clear()
        {
            msgList.Clear();
        }
        public int count()
        {
            return msgList.Count;
        }

        public int getIndex(String messageName)
        {
            // clear the group and set the message name.
            searchGroup = "";
            searchMsgName = messageName;

            // find the record as per search rules.
            return msgList.FindIndex(searchMessageName);
        }

        private bool searchMessageName(msgItem item)
        {
            //get rules
            // 1. find first un-processed message (or repeatable message)
            // 2. if nonsequential then check msgName
            // 3. if optional then check msgName
            // 4. if part of a group, check msgName
            // 5. if msgName does not match move to next un-processed
            //    message and repeat 
            // (if message is not found first non group memeber will be returned)
            if (item.processed == false | item.repeatable == true)
            {
                if (item.nonsequential & item.msgName != searchMsgName)
                {
                    return false;
                }
                if (item.optional & item.msgName != searchMsgName)
                {
                    return false;
                }
                if (item.group != "")
                {
                    if (searchGroup == "")
                        searchGroup = item.group;

                    // if we are nolonger in the search group return the next message.
                    if (item.group == searchGroup)
                    {
                        if (item.msgName != searchMsgName)
                        { return false; }
                    }
                }
                return true;
            }
            return false;
        }


        public String getXpath(int Index)
        {
            return (msgList[Index].xpath);
        }

        public void processed(int Index)
        {
            msgList[Index].processed = true;

            // need to make sure no old messages are left
            // in the que to be picked up in the wrong order.
            String groupName = msgList[Index].group;
            while (Index > 0)
            {
                Index--;

                if (msgList[Index].processed == false
                     &
                    msgList[Index].nonsequential == false
                     &
                    msgList[Index].group != groupName)
                {
                    msgList[Index].processed = true;
                }
            }
        }

        public void resetProcess()
        {
            for (int index = 0; index < msgList.Count; index++)
            {
                msgList[index].processed = false;
            }
        }
    }
}
