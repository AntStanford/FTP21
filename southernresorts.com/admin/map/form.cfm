<cfset page.title ="Map Pointers">
<cfset module = 'map pointer'>
<cfinclude template="/admin/components/header.cfm">  
  
<cfif isdefined('url.id')>
  <cfquery name="getinfo" dataSource="#application.dsn#">
    select * from cms_map where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
  </cfquery>
</cfif>

<cfquery name="getCategories" dataSource="#dsn#">
   select * from cms_map_categories order by title
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
  
      <form action="submit.cfm" method="post" class="form-horizontal" enctype="multipart/form-data">
        
        <div class="control-group">
					<label class="control-label">Category</label>
					<div class="controls">
						<select name="catID" style="width:200px">
						   <option value=" ">- Choose One -</option>
						   <cfloop query="getCategories">
						      <option value="#id#" <cfif isdefined('url.id') and getinfo.catID eq getCategories.id>selected="selected"</cfif>>#title#</option>
						   </cfloop>
						</select>
					</div>
        </div>
        
        <div class="control-group">
					<label class="control-label">Title</label>
					<div class="controls">
						<input type="text" name="title" <cfif parameterexists(id)>value="#getinfo.title#"</cfif>>
					</div>
        </div>
        
        <div class="control-group">
					<label class="control-label">Description</label>
					<div class="controls">
						<textarea name="description" id="txtContent" style="height:100px"><cfif parameterexists(id)>#getinfo.description#</cfif></textarea>
						
						<script language="javascript" type="text/javascript">
                        var oEdit1 = new InnovaEditor("oEdit1");
            
                        /*Apply stylesheet for the editing content*/
                        oEdit1.css = "/admin/live-editor/styles/simple.css";
                        
                        oEdit1.fileBrowser = "/admin/live-editor/assetmanager/asset.php";
            
                        /*Render the editor*/
                        oEdit1.REPLACE("txtContent");
                    </script>
                    
					</div>
				</div>

        <div class="control-group">
          <label class="control-label">Website</label>
          <div class="controls">
            <input type="text" name="website" <cfif parameterexists(id)>value="#getinfo.website#"</cfif>>
          </div>
        </div>

        <div class="control-group">
          <label class="control-label">Latitude</label>
          <div class="controls">
            <input type="text" name="latitude" style="width:200px" <cfif parameterexists(id)>value="#getinfo.latitude#"</cfif>>
          </div>
        </div>

        <div class="control-group">
          <label class="control-label">Longitude</label>
          <div class="controls">
            <input type="text" name="longitude" style="width:200px" <cfif parameterexists(id)>value="#getinfo.longitude#"</cfif>>
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