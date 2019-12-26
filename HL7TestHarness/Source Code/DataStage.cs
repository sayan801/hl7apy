/* Module Header

  $Header:   L:/pvcsrep65/HL7TestHarness/archives/Source Code/DataStage.cs-arc   1.18   16 Mar 2007 15:46:00   mwicks  $

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

  $Log:   L:/pvcsrep65/HL7TestHarness/archives/Source Code/DataStage.cs-arc  $
 *
 *   Rev 1.18   16 Mar 2007 15:46:00   mwicks
 *updated for the following:
 *1. msg proxy and client sim will replace localhost address names with machine name.
 *2. msg proxy outputs timing and number of messages sent.
 *3. commandline has auto control file.
 *4. GUI msg proxy now shows msgs from client and server systems.
 *5. GUI enable/disable redone to be more clear.
 *6. Results data grid columns re-sizeable
 *7. commandline will now handle all development options that GUI uses.
 *
 *   Rev 1.17   18 Jan 2007 14:20:16   mwicks
 *updated reporting and workflow schemas.
  Revision 1.1.1.1  2006/11/24 18:16:41  deltaware
  Init check in of HL7 Test Harness, version 2.0.3.9. For releases before this version please contact deltaware systems.

 *
 *   Rev 1.16   21 Sep 2006 09:46:18   mwicks
 *updated to check the last write time of the test data file and warn the user if it has changed.
 *
 *   Rev 1.15   11 Sep 2006 16:10:24   mwicks
 *updated tcp monitoring to monitor the dns HostName instead of the localhost name.
 *
 *   Rev 1.14   31 Aug 2006 21:04:38   mwicks
 *reduced memory usage
 *
 *   Rev 1.12   31 Aug 2006 11:48:44   mwicks
 *updated to remove memory leaks
 *
 *   Rev 1.11   29 Aug 2006 14:46:36   mwicks
 *Updated to fix some memory issues.
 *
 *   Rev 1.10   03 Aug 2006 15:04:16   mwicks
 *Changed xml loading processes to always load from a stream.
 *xmldoc.loadxml(string) 
 *changed to 
 *xsldoc.load(new StringStream(string))
 *
 *
 *   Rev 1.9   28 Jun 2006 16:24:22   mwicks
 *removed "All Rights Reserved." from all files.
 *
 *   Rev 1.8   26 Jun 2006 13:29:24   mwicks
 *added Lic
 *
 *   Rev 1.7   26 Jun 2006 13:18:24   mwicks
 *Updated License.
 *
 *   Rev 1.6   23 Jun 2006 09:11:46   mwicks
 *updated comments
 *
 *   Rev 1.5   21 Jun 2006 15:01:30   mwicks
 *added new schema checking for workflow documents and test data.
 *
 *   Rev 1.4   20 Jun 2006 10:37:42   mwicks
 *updated to include error reporting on the UI
 *
 *   Rev 1.3   26 May 2006 15:19:26   mwicks
 *update file headers to include PVCS tags
 *updated config file to use bool instead of strings.

 */
using System;
using System.IO;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Xml.XPath;
using System.Xml.Xsl;



namespace HL7TestHarness
{
    class DataStage
    {
        public String errorMessage = "";

        // OrgData holds the Org Untouched Data.
        public XmlDocument OrgData;
        // StagedData holds the Org Data with updated data elements
        public XmlDocument StagedData;
        // DBStagedData holds a subset of the Org Data a DB would need to import.
        public XmlDocument DBStagedData;

        public DateTime LastWriteTimeUtc;
        public String TestDataFileName;

        private XmlDocument OIDListData;
        private Boolean status;
        private String CreateStagedData_xsl = Directory.GetCurrentDirectory() + "\\xsl\\CreateStagedData.xsl";
        private String DBStagedDataList_xsl = Directory.GetCurrentDirectory() + "\\xsl\\DBStagedDataList.xsl";
        private String LoadOIDList_xsl = Directory.GetCurrentDirectory() + "\\xsl\\LoadOIDList.xsl";

        private String testDataSchemaFile = Directory.GetCurrentDirectory() + "\\xsd\\testdata.xsd";

        public DataStage()
        {
            DBStagedData = new XmlDocument();
            StagedData = new XmlDocument();
            OrgData = new XmlDocument();
            OIDListData = new XmlDocument();
            status = false;
        }

        ~DataStage()
        {
            DBStagedData = null;
            StagedData = null;
            OrgData = null;
            OIDListData = null;
            errorMessage = "";
            CreateStagedData_xsl = "";
            DBStagedDataList_xsl = "";
            LoadOIDList_xsl = "";
            testDataSchemaFile = "";
        }

        public Boolean Status()
        {
            return status;
        }

        /// <summary>
        /// Load the Test Data file and validate that it matches the 
        /// testdata.sxd schema.
        /// </summary>
        /// <param name="filename"></param>
        /// <returns>
        /// true = file successfully loaded
        /// false = file failed to load (DataStage.errorMessage contains exception message)
        /// </returns>
        public Boolean loadDataFile(String filename)
        {
            XmlDocument validateLoad = new XmlDocument(); 
            try
            {
                // validate that the data file is the correct format.
                validateLoad.Load(filename);
                validateLoad.Schemas.Add(null, testDataSchemaFile);
                validateLoad.Validate(null);

                if (OrgData != null)
                    OrgData = null;
                OrgData = new XmlDocument();
                OrgData.Load(filename);

                if (OIDListData != null)
                    OIDListData = null;
                OIDListData = new XmlDocument();
                OIDListData.Load(filename);
                LoadServerOIDs(filename);
                status = true;
                TestDataFileName = filename;
                FileInfo testFileInfo = new FileInfo(filename);
                LastWriteTimeUtc = testFileInfo.LastWriteTimeUtc;

            }
            catch (Exception ex)
            {
                status = false;
                errorMessage = ex.Message;
            }
            finally
            {
                validateLoad.Schemas = null;
                validateLoad = null;
            }

            return status;
        }

        /// <summary>
        /// re-Stage the Test data. 
        /// This will re run the CreateStagedData_xsl transfrom against
        /// the Test data file and update things like 
        /// date of birth fields, OIDs, etc.
        /// </summary>
        /// <param name="ClientStaged">stage the client data</param>
        /// <param name="ServerStaged">stage the server data</param>
        /// <returns>
        /// true = data staging successfully
        /// false = data staging failed (DataStage.errorMessage contains exception message)
        /// </returns>
        public Boolean reStageData(Boolean ClientStaged, Boolean ServerStaged)
        {

            Boolean status  = true;
            try
            {
                if (StagedData != null)
                    StagedData = null;
                StagedData = new XmlDocument();
                if (DBStagedData != null)
                    DBStagedData = null;
                DBStagedData = new XmlDocument();


                TransformTestData(OrgData, StagedData, CreateStagedData_xsl, ClientStaged, ServerStaged);
                TransformTestData(StagedData, DBStagedData, DBStagedDataList_xsl, ClientStaged, ServerStaged);
            }
            catch (Exception ex)
            {
                status = false;
                errorMessage = ex.Message;
            }

            return status;
        }

        /// <summary>
        /// Loads a Server set of OIDs
        /// </summary>
        /// <param name="filename"></param>
        /// <returns>true|false</returns>
        public Boolean LoadServerOIDs(String filename)
        {
            return LoadOIDs(filename, "server");
        }

        /// <summary>
        /// Loads a Client set of OIDs
        /// </summary>
        /// <param name="filename"></param>
        /// <returns>true|false</returns>
        public Boolean LoadClientOIDs(String filename)
        {
            return LoadOIDs(filename, "client");
        }

        /// <summary>
        /// Loads a set of OIDs into the Test Data file.
        /// uses the LoadOIDList_xsl transform to preform the load.
        /// </summary>
        /// <param name="filename"></param>
        /// <param name="System">client|server</param>
        /// <returns>true|false</returns>
        private Boolean LoadOIDs(string filename, string System)
        {
            Boolean status = false;

            if (filename != null)
            {
                XmlDocument OIDList = new XmlDocument();
                XsltArgumentList arg = new XsltArgumentList();

                OIDList.Load(filename);
                arg.AddParam("OtherSystemOIDs", "", OIDListData);
                arg.AddParam("System", "", System);
                try
                {
                    StringReader sr = new StringReader(Transform(OIDList, LoadOIDList_xsl, arg));

                    if (OIDListData != null)
                        OIDListData = null;
                    OIDListData = new XmlDocument();

                    OIDListData.Load(sr);
                    sr.Close();
                    sr = null;

                    status = true;
                }
                catch (Exception ex)
                {
                    errorMessage = ex.Message;
                    status = false;
                    OIDListData.LoadXml(OrgData.OuterXml);
                }
                finally
                {
                    if (OIDList != null)
                        OIDList = null;
                    if (arg != null)
                        arg = null;
                }
            }
            else
            {
                errorMessage = "Filename or System Type Invalid";
                status = false;
            }
            return status;
        }

        /// <summary>
        /// Applies a transfrom file to the input xmldoc and loads 
        /// the resutls into the output xmldoc
        /// </summary>
        /// <param name="Input"></param>
        /// <param name="Output"></param>
        /// <param name="xslFileName">xsl file name</param>
        /// <param name="ClientStaged">sets the StageClientData paramter to true|false</param>
        /// <param name="ServerStaged">sets the StageServerData paramter to true|false</param>
        private void TransformTestData(XmlDocument Input, XmlDocument Output, String xslFileName, Boolean ClientStaged, Boolean ServerStaged)
        {
            XsltArgumentList arg = new XsltArgumentList();
            DateTime d = DateTime.Now;
            try
            {

            arg.AddParam("DateTime", "", d.ToString("yyyy-MM-ddTHH:mm:ssZ"));

            if(ClientStaged == true)
                arg.AddParam("StageClientData", "", "true");
            else
                arg.AddParam("StageClientData", "", "false");

            if (ServerStaged == true)
                arg.AddParam("StageServerData", "", "true");
            else
                arg.AddParam("StageServerData", "", "false");

            // OIDListData is passed in so that the xsl can look up OID values
            arg.AddParam("OIDDataXml", "", OIDListData);
            StringReader sr = new StringReader(Transform(Input, xslFileName, arg));
                Output.Load(sr);
                sr.Close();
                sr = null;

            }
            finally
            {
                if (arg != null)
                    arg.Clear();
                arg = null;
            }
        }

        private String Transform(XmlDocument Input, String xslFileName, XsltArgumentList arg)
        {
            //XslTransform transformer;
            String result = "";
            XslCompiledTransform transformer = new XslCompiledTransform(false);;
            XsltSettings settings = new XsltSettings(true, true);

            //XslTransform transformer;
            //XmlDocument outputDoc;
            // Create the XsltSettings object with script enabled.

            StringBuilder sbuilder = new StringBuilder();
            TextWriter writer = new StringWriter(sbuilder);

            try
            {
                transformer.Load(xslFileName, settings, new XmlUrlResolver());
                //transformer.Load(xslFileName, new XmlUrlResolver());
                // Execute the transform.


                transformer.Transform(Input, arg, writer);
                //transformer.Transform(Input, null, writer);

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

                if(writer != null)
                    writer.Close();

                transformer = null;
                settings = null;
                result = sbuilder.ToString();
                sbuilder = null;
                writer = null;
            }
            return (result);
        }

    }
}
