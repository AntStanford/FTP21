<cfset page.title ="Home Page Announcements">

<cfif isdefined('url.id')>

  <cfquery name="getinfo" dataSource="#application.dsn#">
    select * from cms_homepage_announcements where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
  </cfquery>

</cfif>

<cfinclude template="/admin/components/header.cfm">

<cfoutput>
<cfif isdefined('url.success') and isdefined('url.id')>
  <div class="alert alert-success">
    <button class="close" data-dismiss="alert">&times;</button>
    <strong>Update successful!</strong> Continue editing this event or <a href="index.cfm">go back.</a>
  </div>
<cfelseif isdefined('url.success')>
  <div class="alert alert-success">
    <button class="close" data-dismiss="alert">&times;</button>
    <strong>Success!</strong> Add another event or <a href="index.cfm">go back.</a>
  </div>
<cfelseif isdefined('url.deletephoto')>
  <div class="alert alert-success">
    <button class="close" data-dismiss="alert">&times;</button>
    <strong>Success!</strong> The photo was deleted.
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
				<label class="control-label">Title</label>
				<div class="controls">
          <input class="sluggable" maxlength="255" name="title" type="text" <cfif parameterexists(id)>value="#getinfo.title#"</cfif> />
        </div>
			</div>

      <div class="control-group">
        <label class="control-label">Start Date</label>
        <div class="controls">
          <input class="datepicker" maxlength="255" name="start_date" readonly type="text" <cfif parameterexists(id)>value="#DateFormat(getinfo.start_date,'mm/dd/yyyy')#"</cfif> />
          <span class="help-block">(Format: mm/dd/yyyy)</span>
        </div>
      </div>

      <div class="control-group">
        <label class="control-label">End Date</label>
        <div class="controls">
          <input class="datepicker" maxlength="255" name="end_date" readonly type="text" <cfif parameterexists(id)>value="#DateFormat(getinfo.end_date,'mm/dd/yyyy')#"</cfif> />
          <span class="help-block">(Format: mm/dd/yyyy)</span>
        </div>
      </div>

      <div class="control-group">
        <label class="control-label">Link</label>
        <div class="controls">
          <input maxlength="255" name="Link" type="text" <cfif parameterexists(id)>value="#getinfo.Link#"</cfif> /> <br>Ex: http://www.mydomain.com
        </div>
      </div>

      <div class="control-group">
        <label class="control-label">Active</label>
        <div class="controls">
          <select name="active">
            <option value="Yes" <cfif parameterexists(id) and getinfo.active is "Yes">SELECTED</cfif>>Yes</option>
            <option value="No" <cfif parameterexists(id) and getinfo.active is "No">SELECTED</cfif>>No</option>
          </select>
        </div>
      </div>

      <div class="control-group">
        <label class="control-label">Announcement Type</label>
        <div class="controls">
          <select name="type" style="width: 200px;">
    				<option value="Regular" <cfif parameterexists(id) and getinfo.type is "Regular">SELECTED</cfif>>Regular</option>
    				<option value="Emergency" <cfif parameterexists(id) and getinfo.type is "Emergency">SELECTED</cfif>>Emergency</option>
            <option value="Special" <cfif parameterexists(id) and getinfo.type is "Special">SELECTED</cfif>>Special</option>
    			</select>
        </div>
      </div>

      <div class="control-group">
				<label class="control-label">Description</label>
				<div class="controls">
          <textarea id="live-editor" name="Description" rows="4" cols="30">
            <cfif parameterexists(id)>#getinfo.Description#</cfif>
          </textarea>
        </div>
			</div>

<!---
      <div class="control-group">
        <label class="control-label">Image Upload</label>
        <div class="controls">
          <input type="file" name="photo" />
          <span class="help-block">Image must be resized to XXXpx wide (max) before uploaded.</span>
        </div>
      </div>

			<cfif parameterexists(id) and len(getinfo.photo)>
        <div class="widget-box">
          <div class="widget-title">
            <span class="icon">
              <i class="icon-picture"></i>
            </span>
            <h5>Photo</h5>
          </div>
          <div class="widget-content">
            <ul class="thumbnails">
              <li class="span2">
                <img src="/images/homepage-announcements/#getinfo.photo#">
                <br /><br /><a href="submit.cfm?id=#id#&deletephoto" class="btn btn-danger" data-confirm="Are you sure you want to delete this photo?"><i class="icon-remove icon-white"></i> Delete</a>
              </li>
            </ul>
          </div>
        </div>
      </cfif>
--->

		  <div class="form-actions">
        <input type="submit" value="Submit" id="btnSave" class="btn btn-primary" />
        <cfif parameterexists(id)><input type="hidden" name="id" value="#url.id#"></cfif>
      </div>
    </form>
  </div>
</div>
</cfoutput>

<cfinclude template="/admin/components/footer.cfm">