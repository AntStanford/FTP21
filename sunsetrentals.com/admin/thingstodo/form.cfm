<cfset page.title ="Things To Do">
<cfset module = 'thing to do'>
<cfinclude template="/admin/components/header.cfm">

<cfif isdefined('url.id')>
  <cfquery name="getinfo" dataSource="#application.dsn#">
    select * from cms_thingstodo where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
  </cfquery>
</cfif>

<cfquery name="getCategories" dataSource="#dsn#">
   select id,title from cms_thingstodo_categories order by title
</cfquery>

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
      <h5>Add / Edit Form</h5>
    </div>
    <div class="widget-content nopadding">

      <form action="submit.cfm" method="post" class="form-horizontal validate" enctype="multipart/form-data" id="frmTtd">

        <div class="control-group">
            <label class="control-label">Category</label>
            <div class="controls">
              <select name="catID" style="width:200px" class="required">
               <option value="0">- Select One -</option>
               <cfloop query="getCategories">
                  <option value="#id#" <cfif parameterexists(url.id) and getinfo.catID eq getCategories.id>selected="selected"</cfif>>#title#</option>
               </cfloop>
              </select>
            </div>
          </div>

        <div class="control-group">
					<label class="control-label">Title</label>
					<div class="controls">
						<input type="text" name="title" class="required" <cfif parameterexists(id)>value="#getinfo.title#"</cfif>>
					</div>
				</div>

				<div class="control-group">
					<label class="control-label">Website</label>
					<div class="controls">
						<input type="text" name="website" <cfif parameterexists(id)>value="#getinfo.website#"</cfif>>
					</div>
				</div>


        <div class="control-group">
					<label class="control-label">Description</label>
					<div class="controls">
						<textarea name="description" style="height:100px"><cfif parameterexists(id)>#getinfo.description#</cfif></textarea>
					</div>
				</div>
        <div class="control-group">
					<label class="control-label">Photo</label>
			    <div class="controls">
			      <div class="uploader" id="uniform-undefined">
			        <input type="file" size="19" name="photo" style="opacity:0;">
			        <span class="filename">No file selected</span>
			        <span class="action">Choose File</span>
			      </div>
			      <span class="help-block">(Image must be resized to 400px by 300px before uploaded; max file size is 200kb.)</span>
            <cfif parameterexists(id) and len(getinfo.photo)>
              <a href="/images/thingstodo/#getinfo.photo#" target="_blank" class="btn btn-mini"><i class="icon-eye-open"></i> View Image</a>
            </cfif>
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

<style type="text/css">label.error{color:red !important;}</style>

<script>
  $(document).ready(function(){
    $("#frmTtd").validate();
  });
</script>