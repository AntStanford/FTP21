<cfif isdefined('url.id')>
  <cfquery name="getinfo" dataSource="#application.dsn#">
    select * from notfound where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
  </cfquery>
</cfif>

<cfset page.title ="Not Found Frequency">
<cfset module = 'Not Found Frequency'>
<cfinclude template="/admin/components/header.cfm">

<cfoutput>

  <cfif isdefined('url.success') and isdefined('url.id')>
    <div class="alert alert-success">
      <button class="close" data-dismiss="alert">×</button>
      <strong>Update successful!</strong> Continue editing this #module# or <a href="index.cfm">go back.</a>
    </div>
  <cfelseif isdefined('url.success')>
    <div class="alert alert-success">
      <button class="close" data-dismiss="alert">×</button>
      <strong>Success!</strong> Add another #module# or <a href="index.cfm">go back.</a>
    </div>
  </cfif>

  <div class="widget-box">
    <div class="widget-title">
      <span class="icon">
        <i class="icon-th"></i>
      </span>
      <h5>Notes</h5>
    </div>
    <div class="widget-content nopadding">

      <form action="notfound-frequency-submit.cfm" method="post" class="form-horizontal">


        <div class="control-group">
					<label class="control-label">Notes</label>
					<div class="controls">

            <textarea name="notes" rows="4" cols="30" id="txtContent">
               <cfif parameterexists(id)>#getinfo.notes#</cfif>
            </textarea>

					</div>
				</div>
				<div class="form-actions">
					<input type="submit" value="Submit" class="btn btn-primary">
          <cfif parameterexists(id)><input type="hidden" name="id" value="#url.id#"></cfif>
				</div>
      </form>

    </div>
  </div>

</cfoutput>

<cfinclude template="/admin/components/footer.cfm">