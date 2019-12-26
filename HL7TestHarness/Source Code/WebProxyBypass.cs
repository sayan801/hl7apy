/* Module Header

  $Header:   L:/pvcsrep65/HL7TestHarness/archives/Source Code/WebProxyBypass.cs-arc   1.10   18 Jan 2007 14:20:26   mwicks  $

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

  $Log:   L:/pvcsrep65/HL7TestHarness/archives/Source Code/WebProxyBypass.cs-arc  $
 *
 *   Rev 1.10   18 Jan 2007 14:20:26   mwicks
 *updated reporting and workflow schemas.
  Revision 1.1.1.1  2006/11/24 18:16:49  deltaware
  Init check in of HL7 Test Harness, version 2.0.3.9. For releases before this version please contact deltaware systems.

 *
 *   Rev 1.9   11 Sep 2006 16:10:32   mwicks
 *updated tcp monitoring to monitor the dns HostName instead of the localhost name.
 *
 *   Rev 1.8   31 Aug 2006 11:48:48   mwicks
 *updated to remove memory leaks
 *
 *   Rev 1.7   28 Jun 2006 16:24:40   mwicks
 *removed "All Rights Reserved." from all files.
 *
 *   Rev 1.6   26 Jun 2006 13:29:28   mwicks
 *added Lic
 *
 *   Rev 1.5   26 Jun 2006 13:18:26   mwicks
 *Updated License.
 *
 *   Rev 1.4   24 May 2006 10:33:40   mwicks
 *updated to allow system to be used as a true proxy
 *
 *   Rev 1.3   27 Apr 2006 14:40:16   mwicks
 *Added Server user and password fields
 *
 *   Rev 1.2   21 Mar 2006 13:24:02   mwicks
 *Multi message update
 *
 *   Rev 1.1   17 Mar 2006 15:46:24   mwicks
 *Updated $Header
*/

using System;
using System.Collections;
using System.Runtime.Serialization;
using System.Text.RegularExpressions;

 namespace System.Net 
//namespace HL7TestHarness
{
	[Serializable]
	public class WebProxyBypass : IWebProxy, ISerializable
	{		
		private Uri address;
		private bool bypassOnLocal;
		private ArrayList bypassList;
		private ICredentials credentials;

        ~WebProxyBypass()
        {
            address = null;
            if(bypassList != null)
                bypassList.Clear();
            bypassList = null;
            credentials = null;
        }
		// Constructors

		public WebProxyBypass () 
			: this ((Uri) null, false, null, null) {}
		
		public WebProxyBypass (string address) 
			: this (ToUri (address), false, null, null) {}
		
		public WebProxyBypass (Uri address) 
			: this (address, false, null, null) {}
		
		public WebProxyBypass (string address, bool bypassOnLocal) 
			: this (ToUri (address), bypassOnLocal, null, null) {}
		
		public WebProxyBypass (string host, int port)
			: this (new Uri ("http://" + host + ":" + port)) {}
		
		public WebProxyBypass (Uri address, bool bypassOnLocal)
			: this (address, bypassOnLocal, null, null) {}

		public WebProxyBypass (string address, bool bypassOnLocal, string [] bypassList)
			: this (ToUri (address), bypassOnLocal, bypassList, null) {}

		public WebProxyBypass (Uri address, bool bypassOnLocal, string [] bypassList)
			: this (address, bypassOnLocal, bypassList, null) {}
		
		public WebProxyBypass (string address, bool bypassOnLocal,
				 string[] bypassList, ICredentials credentials)
			: this (ToUri (address), bypassOnLocal, bypassList, null) {}

		public WebProxyBypass (Uri address, bool bypassOnLocal, 
				 string[] bypassList, ICredentials credentials)
		{
			this.address = address;
			this.bypassOnLocal = bypassOnLocal;
			if (bypassList == null)
				bypassList = new string [] {};
			this.bypassList = new ArrayList (bypassList);
			this.credentials = credentials;
			CheckBypassList ();
		}
		
        protected WebProxyBypass(SerializationInfo serializationInfo, StreamingContext streamingContext) 
		{
			throw new NotImplementedException ();
		}
		
		// Properties
		
		public Uri Address {
			get { return address; }
			set { address = value; }
		}
		
		public ArrayList BypassArrayList {
			get { 
				return bypassList;
			}
		}
		
		public string [] BypassList {
			get { return (string []) bypassList.ToArray (typeof (string)); }
			set { 
				if (value == null)
					throw new ArgumentNullException ();
				bypassList = new ArrayList (value); 
				CheckBypassList ();
			}
		}
		
		public bool BypassProxyOnLocal {
			get { return bypassOnLocal; }
			set { bypassOnLocal = value; }
		}
		
		public ICredentials Credentials {
			get { return credentials; }
			set { credentials = value; }
		}
		
		// Methods
		
		public static WebProxy GetDefaultProxy ()
		{
			// we should probably read in these settings
			// from the global application configuration file
			
			throw new NotImplementedException ();
		}
		
		public Uri GetProxy (Uri destination)
		{
			if (IsBypassed (destination))
				return destination;
				
			return address;
		}
		
		public bool IsBypassed (Uri host)
		{
			if (address == null)
				return true;
			
			if (host.IsLoopback)
				return true;
				
			if (bypassOnLocal && host.Host.IndexOf ('.') == -1)
				return true;
				
			try {				
				string hostStr = host.Scheme + "://" + host.Authority;				
				int i = 0;
				for (; i < bypassList.Count; i++) {
					Regex regex = new Regex ((string) bypassList [i], 
						// TODO: RegexOptions.Compiled |  // not implemented yet by Regex
						RegexOptions.IgnoreCase |
						RegexOptions.Singleline);

					if (regex.IsMatch (hostStr))
						break;
				}

                if (i == bypassList.Count)
					//return false;
                    return true;

				// continue checking correctness of regular expressions..
				// will throw expression when an invalid one is found
				for (; i < bypassList.Count; i++)
					new Regex ((string) bypassList [i]);

				//return true;
                return false;
            }
            catch (ArgumentException)
            {
				return false;
			}
		}

		void ISerializable.GetObjectData (SerializationInfo serializationInfo,
		                                  StreamingContext streamingContext)
		{
			throw new NotImplementedException ();
		}
		
		// Private Methods
		
		// this compiles the regular expressions, and will throw
		// an exception when an invalid one is found.
		private void CheckBypassList ()
		{			
			for (int i = 0; i < bypassList.Count; i++)
				new Regex ((string) bypassList [i]);
		}
		
		private static Uri ToUri (string address)
		{
			if (address == null)
				return null;
				
			if (address.IndexOf (':') == -1) 
				address = "http://" + address;
			
			return new Uri (address);
		}
	}
}