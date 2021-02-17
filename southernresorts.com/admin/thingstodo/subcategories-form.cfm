<cfset page.title ="Things To Do Subcategories">
<cfset module = 'thing to do subcategory'>
<cfinclude template="/admin/components/header.cfm">

<cfif isdefined('url.id')>
  <cfquery name="getinfo" dataSource="#application.dsn#">
  SELECT * 
  FROM cms_thingstodo_subcategories 
  WHERE id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
  </cfquery>
</cfif>

<cfquery name="getCategories" dataSource="#application.dsn#">
SELECT * 
FROM cms_thingstodo_categories
ORDER BY title
</cfquery>

<cfoutput>

  <cfif isdefined('url.success') and isdefined('url.id')>
    <div class="alert alert-success">
      <button class="close" data-dismiss="alert">×</button>
      <strong>Update successful!</strong> Continue editing this #module# or <a href="categories-index.cfm">go back.</a>
    </div>
  <cfelseif isdefined('url.success')>
    <div class="alert alert-success">
      <button class="close" data-dismiss="alert">×</button>
      <strong>Success!</strong> Add another #module# or <a href="categories-index.cfm">go back.</a>
    </div>
  </cfif>
  
<p><a href="/admin/thingstodo/categories-index.cfm" class="btn btn-info"><i class="icon-chevron-left icon-white"></i> Back to Categories</a></p>

  <div class="widget-box">
    <div class="widget-title">
      <span class="icon">
        <i class="icon-th"></i>
      </span>
      <h5>Add / Edit Form</h5>
    </div>
    <div class="widget-content nopadding">

      <form action="subcategories-submit.cfm" method="post" class="form-horizontal validate" enctype="multipart/form-data" id="frmSubCategory">

            <div class="control-group">
					<label class="control-label">Category</label>
					<div class="controls">
              <select name="catID" style="width:200px" class="required">
               <option value="0">- Select One -</option>             
               <cfloop query="getCategories">
                  <option value="#id#" <cfif (parameterexists(url.id) and getinfo.categoryID eq getCategories.id) OR (IsDefined('url.catid') AND url.catid EQ getCategories.id)>selected="selected"</cfif>>#title#</option>
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
					<label class="control-label">Slug</label>
					<div class="controls">
						<input type="text" name="slug" class="required" <cfif parameterexists(id)>value="#getinfo.slug#"</cfif>>
					</div>
				</div>
				
				<div class="control-group">
					<label class="control-label">Short Description</label>
					<div class="controls">
						<textarea name="description"><cfif parameterexists(id)>#getinfo.description#</cfif></textarea>
					</div>
				</div>
				
				 <div class="control-group">
					<label class="control-label">Image</label>
			    <div class="controls">
			      <div class="uploader" id="uniform-undefined">
			        <input type="file" size="19" name="photo" style="opacity:0;">
			        <span class="filename">No file selected</span>
			        <span class="action">Choose File</span>
			      </div>	
			      <span class="help-block">(Image must be resized to 400px by 300px before uploaded; max file size is 200kb.)</span>			
            <cfif parameterexists(id) and len(getinfo.photo)>
              <br /><br />Image Preview<br /><img src="/images/thingstodo/#getinfo.photo#" width="200">
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
    $("#frmSubCategory").validate();
  });
</script>