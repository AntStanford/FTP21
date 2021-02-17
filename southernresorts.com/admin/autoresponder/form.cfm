<cfif isdefined('url.id')>
  <cfquery name="getinfo" dataSource="#application.dsn#">
    select * from cms_autoresponder where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
  </cfquery>
</cfif>

<cfset page.title ="Autoresponder">
<cfinclude template="/admin/components/header.cfm">

<cfoutput>

<cfif isdefined('url.success') and isdefined('url.id')>
  <div class="alert alert-success">
    <button class="close" data-dismiss="alert">×</button>
    <strong>Update successful!</strong> Continue editing this Autoresponder or <a href="index.cfm">go back.</a>
  </div>
<cfelseif isdefined('url.success')>
  <div class="alert alert-success">
    <button class="close" data-dismiss="alert">×</button>
    <strong>Success!</strong> Add another Autoresponder or <a href="index.cfm">go back.</a>
  </div>
</cfif>

<div class="widget-box">
  <div class="widget-title">
    <span class="icon">
      <i class="icon-th"></i>
    </span>
    <h5>Add / Edit Form</h5>
  </div>
  <div class="widget-content nopadding">    
    
      <form method="post" action="submit.cfm" class="form-horizontal" enctype="multipart/form-data">
    
      <div class="control-group">
				<label class="control-label">Subject</label>
				<div class="controls">
          <input class="sluggable" maxlength="255" name="subject" type="text" <cfif parameterexists(id)>value="#getinfo.subject#"</cfif> />
        </div>
			</div>	
			

      <div class="control-group">
        <label class="control-label">Message</label>
        <div class="controls">
          <textarea id="live-editor" name="body" rows="4" cols="30">
             <cfif parameterexists(id)>#getinfo.body#</cfif>
          </textarea>
        </div>
      </div>
		 
      <div class="control-group">
        <label class="control-label">Active</label>
        <div class="controls">
          <select name="active">
            <option value="No" <cfif parameterexists(id) and getinfo.active is "0">SELECTED</cfif>>No</option>
            <option value="Yes" <cfif parameterexists(id) and getinfo.active is "1">SELECTED</cfif>>Yes</option>
          </select>
        </div>
      </div>
		 
 
		  <div class="form-actions">       
          <input type="submit" value="Submit" id="btnSave" class="btn btn-primary" />
          <cfif parameterexists(id)><input type="hidden" name="id" value="#url.id#"></cfif>
        </div>
			
    </form>
  
  </div>
  
</div>

</cfoutput>

<cfinclude template="/admin/components/footer.cfm">

