
<cfset variables.excelFile = "#expandPath('/')#SortingOutResortsAndCommunities.xlsx">
<cfset qryExcel = "">


<cftry>
  <cfspreadsheet action="read" src="#variables.excelFile#" query="qryExcel" headerrow="1" excludeHeaderRow="true" sheetname="ImportSheetForNodeType4">
  <cfcatch type="any">
    <cfdump var="#cfcatch#" abort="true">
  </cfcatch>
</cftry>
      
<cfoutput>
   <cfquery name="qryInsert" dataSource="#settings.dsn#">
   DELETE FROM cms_resorts
   </cfquery> 
<cfloop query="qryExcel"> 
<!--- 	<cfset variables.blogPost = qryExcel.blog>
	<cfset variables.blogPost = ReplaceNoCase(variables.blogPost,'&lt;','<','All')>
	<cfset variables.blogPost = ReplaceNoCase(variables.blogPost,'&gt;','>','All')>
	<cfset variables.blogPost = ReplaceNoCase(variables.blogPost,'&quot;','"','All')>
	<cfset variables.blogPost = ReplaceNoCase(variables.blogPost,'<div','<p','All')>
	<cfset variables.blogPost = ReplaceNoCase(variables.blogPost,'</div>','</p>','All')> --->

  <cfquery name="qryInsert" dataSource="#settings.dsn#">
  INSERT INTO cms_resorts (PropertyID, 
                          FullDescription)
  VALUES (<cfqueryparam value="#qryExcel.NODEID#" cfsqltype="cf_sql_integer">,
          <cfqueryparam value="#qryExcel.CONTENT#" cfsqltype="cf_sql_varchar">)
  </cfquery>

</cfloop>
</cfoutput>


Imported
<cfabort>






<cfif StructKeyExists(form,'excelFile')>
	<!--- Verifies the needed data was entered in the form. --->
	<cfif len(trim(form.excelFile)) EQ 0>
  	<cfset variables.errors[arraylen(variables.errors)+1] = "You must select the Excel file to upload.">
  </cfif>
	<cfif len(trim(form.worksheet)) EQ 0>
  	<cfset variables.errors[arraylen(variables.errors)+1] = "You must enter the name of the worksheet in the Excel file.">
  </cfif>

	<!--- If no errors so far, try to import and read the Excel file. --->
	<cfif arrayLen(variables.errors) EQ 0>
		<!--- Ensures the Temp Folder exists --->
    <cfset variables.temp_excel_path="#expandPath('/admin/pages/')#\temp_files"> <!--- Looks like permission restrictions to e:\inetpub\wwwroot\domains\#cgi.http_host#\temp_files --->
    <cfif NOT DirectoryExists(variables.temp_excel_path)>
      <cfdirectory action="create" directory="#variables.temp_excel_path#">
    </cfif>
    <!--- Uploads Excel File to read and parse --->
    <cffile action="upload" destination="#variables.temp_excel_path#" filefield="excelFile" result="upload" nameconflict="makeunique">
    <!--- Reads Excel file into memory --->
    <cfset variables.xlsFile = "#variables.temp_excel_path#\#upload.serverFile#">
    <cfif right(upload.serverFile,5) EQ ".xlsx">
    <cfelse>
    	<cfset variables.errors[arraylen(variables.errors)+1] = "You must upload a valid Excel file with a .xlsx extension.">
    </cfif>
    <cftry>
			<!--- Deletes the temp file --->
      <cffile action="delete" file="#variables.xlsFile#">
    	<cfcatch type="any"></cfcatch>
    </cftry>
  </cfif>

	<cfif arrayLen(variables.errors) EQ 0>
  	<!--- If no errors, moves to the next Step. --->
    <cfset variables.importStep = 2>
  </cfif>
<cfelseif StructKeyExists(form,'pageTitle')>
	<!--- Gets the id for the parent page "Imported" --->
  <cfquery name="getImportedPage" dataSource="#dsn#">
  select id
  from cms_pages
  where name = 'Imported'
  </cfquery>
  <cfif getImportedPage.RecordCount GT 0>
  	<cfset variables.parentID = getImportedPage.id>
  <cfelse>
		<!--- Creates top-level page "Imported" if it doesn't exist --->
  	<cfquery name="createImportedPage" dataSource="#dsn#">
    insert into cms_pages (name, 
                           slug, 
                           body, 
                           layout, 
                           ShowinNavigation, 
                           ShowInAdmin, 
                           triggerOnly, 
                           ignoreParentSlug, 
                           bodyClass, 
                           popularSearch, 
                           showInFooter, 
                           isCustomSearchPage, 
                           customSearchJSON)
    values ('Imported',
            'imported',
            '<p>This is the parent container for all imported pages and their meta data. Should be deleted once the site is navigation is set up.</p>',
            'Default.cfm',
            'No',
            'Yes',
            'No',
            'No',
            'imported',
            'No',
            'No',
            'No',
            '{"DISPLAYCOUNT2":"","METATITLE":"","H1":"","IGNOREPARENTSLUG":false,"EXTERNALLINK":"","RENTALRATEMAX":0,"METADESCRIPTION":"","STRCHECKIN":"","POPULARSEARCHPHOTO":"","NAME":"Imported","STRCHECKOUT":"","LAYOUT":"Default.cfm","RENTALRATEMIN":0,"CANONICALLINK":"","BEDROOMS":0,"PARENTID":0,"DISPLAYCOUNT3":"","POPULARSEARCH":false,"FIELDNAMES":"PARENTID,SHOWINNAVIGATION,SHOWINFOOTER,TRIGGERONLY,NAME,SLUG,IGNOREPARENTSLUG,EXTERNALLINK,LAYOUT,BODY,CANONICALLINK,H1,METATITLE,DISPLAYCOUNT3,METADESCRIPTION,DISPLAYCOUNT2,POPULARSEARCH,POPULARSEARCHPHOTO,STRCHECKIN,STRCHECKOUT,BEDROOMS,SLEEPS,RENTALRATEMIN,RENTALRATEMAX","SLEEPS":0,"BODY":"<p>This is the parent container for all imported pages and their meta data. Should be deleted once the site is navigation is set up.</p>","SLUG":"imported","SHOWINNAVIGATION":false,"SHOWINFOOTER":false,"TRIGGERONLY":false}')
    </cfquery>
    <cfquery name="findImportedPageID" dataSource="#dsn#">
    select id
    from cms_pages
    where name = 'Imported'
    </cfquery>
    <cfset variables.parentID = findImportedPageID.id>
  </cfif>

	<!--- Verifies that the Title has been populated for all importing records. --->
	<cfloop query="Session.qryExcel">
    <cfif Session.qryExcel[form.pageImport][Session.qryExcel.CurrentRow] EQ "Y" AND len(trim(Session.qryExcel[form.pageTitle][Session.qryExcel.CurrentRow])) EQ 0>
				<cfset variables.errors[1] = "You are trying to import a page without a Title. Please ensure that the Title has been entered for all pages.">
    </cfif>
  </cfloop>

	<!--- If no errors, insert all of the desired pages into the database. --->
	<cfif arrayLen(variables.errors) EQ 0>
		<!--- Creates Pages that are designated as to be imported --->
    <cfloop query="Session.qryExcel">
      <cfif Session.qryExcel[form.pageImport][Session.qryExcel.CurrentRow] EQ "Y">
		<cfquery name="exists" datasource="#dsn#">
			select id from cms_pages
			where slug = <cfif len(trim(Session.qryExcel[form.pageSlug][Session.qryExcel.CurrentRow])) GT 0>
                  <cfqueryparam value="#ReplaceNoCase(Session.qryExcel[form.pageSlug][Session.qryExcel.CurrentRow],'https://www.jordanre.com/','')#" cfsqltype="cf_sql_varchar">
                <cfelse>
                  <cfqueryparam value="#ReplaceNoCase(Session.qryExcel[form.pageTitle][Session.qryExcel.CurrentRow],' ','-','All')#" cfsqltype="cf_sql_varchar">
                </cfif>
		</cfquery>
		  
		<cfif exists.recordcount>
			<cfquery name="updatePage" dataSource="#dsn#">
				update cms_pages
				set
				name = <cfif len(trim(Session.qryExcel[form.pageH1][Session.qryExcel.CurrentRow])) GT 0>
					  <cfqueryparam value="#left(Session.qryExcel[form.pageH1][Session.qryExcel.CurrentRow],255)#" cfsqltype="cf_sql_varchar">
					<cfelse>
					  <cfqueryparam value="#left(Session.qryExcel[form.pageTitle][Session.qryExcel.CurrentRow],255)#" cfsqltype="cf_sql_varchar">
						  </cfif>,
				h1 = <cfqueryparam value="#left(Session.qryExcel[form.pageH1][Session.qryExcel.CurrentRow],255)#" cfsqltype="cf_sql_varchar">,
				metatitle = <cfqueryparam value="#left(Session.qryExcel[form.pageTitle][Session.qryExcel.CurrentRow],255)#" cfsqltype="cf_sql_varchar">,
				metadescription = <cfqueryparam value="#Session.qryExcel[form.pageMetaDescription][Session.qryExcel.CurrentRow]#" cfsqltype="cf_sql_varchar">, 
				
				showInNavigation = <cfif Session.qryExcel[form.showinNavigation][Session.qryExcel.CurrentRow] EQ 'Y'>'Yes'<cfelse>'No'</cfif>
				
				where id = #exists.id#
			</cfquery>
			
		<cfelse>
			<cfquery name="createPage" dataSource="#dsn#">
			insert into cms_pages (parentID, name, slug, h1, metaTitle, metaDescription, layout, ShowinNavigation, ShowInAdmin, triggerOnly, ignoreParentSlug, popularSearch, showInFooter, isCustomSearchPage)
			values (<cfqueryparam value="#variables.parentID#" cfsqltype="cf_sql_integer">, 
					<cfif len(trim(Session.qryExcel[form.pageH1][Session.qryExcel.CurrentRow])) GT 0>
					  <cfqueryparam value="#left(Session.qryExcel[form.pageH1][Session.qryExcel.CurrentRow],255)#" cfsqltype="cf_sql_varchar">
					<cfelse>
					  <cfqueryparam value="#left(Session.qryExcel[form.pageTitle][Session.qryExcel.CurrentRow],255)#" cfsqltype="cf_sql_varchar">
					</cfif>,
					<cfif len(trim(Session.qryExcel[form.pageSlug][Session.qryExcel.CurrentRow])) GT 0>
					  <cfqueryparam value="#left(ReplaceNoCase(Session.qryExcel[form.pageSlug][Session.qryExcel.CurrentRow],'https://www.jordanre.com/',''),255)#" cfsqltype="cf_sql_varchar">
					<cfelse>
					  <cfqueryparam value="#left(ReplaceNoCase(Session.qryExcel[form.pageTitle][Session.qryExcel.CurrentRow],' ','-','All'),255)#" cfsqltype="cf_sql_varchar">
					</cfif>,
					<cfqueryparam value="#left(Session.qryExcel[form.pageH1][Session.qryExcel.CurrentRow],255)#" cfsqltype="cf_sql_varchar">, 
					<cfqueryparam value="#left(Session.qryExcel[form.pageTitle][Session.qryExcel.CurrentRow],255)#" cfsqltype="cf_sql_varchar">, 
					<cfqueryparam value="#Session.qryExcel[form.pageMetaDescription][Session.qryExcel.CurrentRow]#" cfsqltype="cf_sql_varchar">, 
					'full.cfm', 
					<cfif Session.qryExcel[form.showinNavigation][Session.qryExcel.CurrentRow] EQ 'Y'>'Yes'<cfelse>'No'</cfif>, 
					'Yes', 
					'No', 
					'Yes', 
					'No', 
					'No', 
					'No')
			</cfquery>
					
		</cfif>
      </cfif>
    </cfloop>
    <cfset variables.importStep = 3>
    <div class="alert alert-success">
      <button class="close" data-dismiss="alert">x</button>
      <strong>Import Successful!</strong> <a href="index.cfm">go back.</a>
    </div>
  <cfelse>
  	<cfset StructDelete(Session,'qryExcel')>
  </cfif>
</cfif>

<cfif arrayLen(variables.errors) GT 0>
	<cfoutput>
		<div class="alert alert-danger">
			<button class="close" data-dismiss="alert">x</button>
			<cfloop index="i" from="1" to="#arrayLen(variables.errors)#">
				<cfif i GT 1><br /></cfif><strong>#variables.errors[i]#</strong>
			</cfloop>
		</div>
	</cfoutput>
</cfif>

<cfif variables.importStep EQ 1>
  <div class="widget-box">
    <div class="widget-title">
      <span class="icon">
        <i class="icon-th"></i>
      </span>
      <h5><cfoutput>#page.title#</cfoutput></h5>
    </div>
    <div class="widget-content nopadding">
      <div class="table-wrap">
        <form action="import1.cfm" method="post" enctype="multipart/form-data" class="form-horizontal" >
  
          <div class="control-group">
            <label class="control-label">Excel File</label>
            <div class="controls">
              <input class="sluggable" maxlength="255" name="excelFile" type="file">
            </div>
          </div>
        
          <div class="control-group">
            <label class="control-label">Worksheet Name</label>
            <div class="controls">
              <input class="sluggable" style="width:300px" maxlength="255" name="worksheet" type="text" value="Sheet1">
            </div>
          </div>
          
          <div class="form-actions">
            <input type="submit" value="Submit" id="btnSave" class="btn btn-primary" />
          </div>
        </form>
      </div>
    </div>
  </div>
<cfelseif variables.importStep EQ 2>
  <div class="alert alert-info">
    <button type="button" class="close" data-dismiss="alert">&times;</button>
    <strong>Verify the correct Columns have been identified.</strong>
  </div>
        
  <div class="widget-box">
    <div class="widget-title">
      <span class="icon">
        <i class="icon-th"></i>
      </span>
      <h5><cfoutput>#page.title#</cfoutput></h5>
    </div>
    <div class="widget-content nopadding">
      <div class="table-wrap">
        <form action="import1.cfm" method="post" enctype="multipart/form-data" class="form-horizontal" >
          <cfoutput>
          <div class="control-group">
            <label class="control-label">Title</label>
            <div class="controls">
              <select name="pageTitle" style="width:300px">
                <cfloop list="#Session.qryExcel.ColumnList#" index="i">
                  <option value="#i#" <cfif FindNoCase('title',i)>selected="selected"</cfif>>#i#</option>
                </cfloop>
              </select>
            </div>
          </div>
        
          <div class="control-group">
            <label class="control-label">Meta Description</label>
            <div class="controls">
              <select name="pageMetaDescription" style="width:300px">
                <cfloop list="#Session.qryExcel.ColumnList#" index="i">
                  <option value="#i#" <cfif FindNoCase('meta',i) AND FindNoCase('desc',i)>selected="selected"</cfif>>#i#</option>
                </cfloop>
              </select>
            </div>
          </div>

          <div class="control-group">
            <label class="control-label">H1</label>
            <div class="controls">
              <select name="pageH1" style="width:300px">
                <cfloop list="#Session.qryExcel.ColumnList#" index="i">
                  <option value="#i#" <cfif FindNoCase('h1',i)>selected="selected"</cfif>>#i#</option>
                </cfloop>
              </select>
            </div>
          </div>

          <div class="control-group">
            <label class="control-label">Slug</label>
            <div class="controls">
              <select name="pageSlug" style="width:300px">
                <cfloop list="#Session.qryExcel.ColumnList#" index="i">
                  <option value="#i#" <cfif FindNoCase('slug',i)>selected="selected"</cfif>>#i#</option>
                </cfloop>
              </select>
            </div>
          </div>

          <div class="control-group">
            <label class="control-label">Import</label>
            <div class="controls">
              <select name="pageImport" style="width:300px">
                <cfloop list="#Session.qryExcel.ColumnList#" index="i">
                  <option value="#i#" <cfif FindNoCase('import',i)>selected="selected"</cfif>>#i#</option>
                </cfloop>
              </select>
            </div>
          </div>
						
		<div class="control-group">
            <label class="control-label">Show In Navigation</label>
            <div class="controls">
              <select name="showInNavigation" style="width:300px">
                <cfloop list="#Session.qryExcel.ColumnList#" index="i">
                  <option value="#i#" <cfif FindNoCase('navigation',i)>selected="selected"</cfif>>#i#</option>
                </cfloop>
              </select>
            </div>
          </div>
          </cfoutput>
          
          <div class="form-actions">
            <input type="submit" value="Submit" id="btnSave" class="btn btn-primary" />
          </div>
        </form>
      </div>
    </div>
  </div>
<cfelseif variables.importStep EQ 3>
  <div class="widget-box">
    <div class="widget-title">
      <span class="icon">
        <i class="icon-th"></i>
      </span>
      <h5><cfoutput>#page.title#</cfoutput></h5>
    </div>
    <div class="widget-content nopadding">
      <div class="table-wrap">
        <table class="table table-bordered table-striped">
					<tr><td><strong>The following pages were added or updated under the parent page "Imported".</strong></td></tr>
					<cfoutput query="Session.qryExcel">
            <cfif Session.qryExcel[form.pageImport][Session.qryExcel.CurrentRow] EQ "Y">
              <tr><td>#Session.qryExcel[form.pageTitle][Session.qryExcel.CurrentRow]#</td></tr>
            </cfif>
          </cfoutput>
        </table>      
      </div>
    </div>
  </div>
  <cfset StructDelete(Session,'qryExcel')>
</cfif>

<cfinclude template="/admin/components/footer.cfm">