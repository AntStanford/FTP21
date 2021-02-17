<cfset page.title ="Meta Viewer for Long Term Rentals">

<cfinclude template="/admin/components/header.cfm">

<cfif isdefined('url.success')>
  <div class="alert alert-success">
    <button class="close" data-dismiss="alert">x</button>
    <strong>Record updated!</strong>
  </div>
  
  <!--- Determines which Submit button was clicked. Defaults to Submit All. Allows for the saving of individual records only. --->
  <cfset variables.submitStart = 1>
  <cfset variables.submitEnd = form.allCount>
	<cfloop index="i" list="#form.FIELDNAMES#"> 
  	<cfif FindNoCase('submit',i) AND ReplaceNoCase(i,'submit_','') GT 0>
      <cfset variables.submitStart = ReplaceNoCase(i,'submit_','')>
      <cfset variables.submitEnd = ReplaceNoCase(i,'submit_','')>
    </cfif>
  </cfloop>
  
  <!--- Loops through all needed records and updates their data. --->
  <cfloop index="i" from="#variables.submitStart#" to="#variables.submitEnd#">
    <cfquery datasource="#application.dsn#">
      update cms_longterm_rentals set 
      h1 = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form['h1_#i#']#">,
      metatitle = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form['metatitle_#i#']#">,
      metadescription = <cfqueryparam CFSQLType="CF_SQL_LONGVARCHAR" value="#form['metadescription_#i#']#">
      where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#form['id_#i#']#">
    </cfquery> 
  </cfloop>
</cfif>

<cfquery name="getinfo" dataSource="#application.dsn#">
  select * from cms_longterm_rentals order by name
</cfquery>

<cfif getinfo.recordcount gt 0>
  <form action="view.cfm?success" method="post" class="form-horizontal">
    <input type="submit" name="submit_0" value="Submit All" class="btn btn-primary btn-danger">
    <input type="hidden" name="allCount" value="<cfoutput>#getinfo.RecordCount#</cfoutput>">
    <div class="widget-box">
      <div class="widget-content nopadding">
        <table class="table table-bordered table-striped">
        <tr>
          <th>No.</th>
          <th>Category</th>    
          <th>Title</th>
          <th>Description</th>
          <th>H1</th>
          <th></th> 
        </tr>        
        <cfoutput query="getinfo">
          <tr>
            <td width="45">#currentrow#.</td>              
            <td><a href="/long-term-rental/#slug#" target="_blank">#name#</a></td>            
            <td><textarea cols="15" rows="8" name="metatitle_#getinfo.CurrentRow#" class="mceNoEditor">#metatitle#</textarea></td>
            <td><textarea cols="15" rows="8" name="metadescription_#getinfo.CurrentRow#" class="mceNoEditor">#metadescription#</textarea></td>
            <td><textarea cols="15" rows="8" name="h1_#getinfo.CurrentRow#" class="mceNoEditor">#h1#</textarea></td>
            <td width="50"><input type="submit" name="submit_#getinfo.CurrentRow#" value="Submit" class="btn btn-primary btn-danger"></td>
          </tr>
          <input type="hidden" name="id_#getinfo.CurrentRow#" value="#id#">
        </cfoutput>
        </table>
      </div>
    </div>
  </form>
</cfif>

<cfinclude template="/admin/components/footer.cfm">