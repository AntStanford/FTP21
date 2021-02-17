<cfset page.title ="Things To Do">
<cfset module = 'thing to do'>
<cfinclude template="/admin/components/header.cfm">  
  
<cfif isdefined('url.id')>
  <cfquery name="getinfo" dataSource="#application.dsn#">
    select * from cms_thingstodo where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
  </cfquery>
	  
   <cfquery name="getnodeid" dataSource="#application.dsn#">
	   select nodeid from cms_destinations 
	   where nodeid IN (#Replace(getinfo.destination_id,"-","","ALL")#)
	   
   </cfquery>
</cfif>

<cfquery name="getCategories" dataSource="#dsn#">
   select id,title from cms_thingstodo_categories order by title
</cfquery>
<cfquery name="getDestinations" dataSource="#dsn#">
   select * from track_nodes  where typeId = 3
	order by field(name,'30A') desc, name asc
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
              <select id="catID" name="catID" style="width:200px" class="required">
               <option value="0">- Select One -</option>             
               <cfloop query="getCategories">
                  <option value="#id#" <cfif parameterexists(url.id) and getinfo.catID eq getCategories.id>selected="selected"</cfif>>#title#</option>
               </cfloop>
              </select>
            </div>
          </div>
          
          <script type="application/javascript" language="javascript">
            function updateCheckboxes(categoryid){
                $.get("ajax_subcategories.cfm?categoryid="+categoryid+"&id="+<cfif parameterexists(id)>#url.id#<cfelse>0</cfif>, function(data, status){
                   $("##subcatIDs").html(data);
                   $("##subcatIDs").trigger('change');
                });
            }
          
              $(document).ready(function(){
                 $("##catID").change(function(){
                    categoryid = $(this).find("option:selected").val();
                    updateCheckboxes(categoryid);
                 });
                  <cfif parameterexists(url.id)>
                    updateCheckboxes(#getinfo.catID#);
                  </cfif>
              });
          </script>
          
        <div class="control-group">
            <label class="control-label">Sub-Categories</label>
            <div class="controls" id="subcatIDs">
            </div>
          </div>

        <div class="control-group">
          <label class="control-label">Destinations</label>
          <div class="controls">

            <cfloop query="getDestinations">
              <label for="destination#getDestinations.id#">
                <input type="checkbox" value="-#getDestinations.id#-" id="destination#getDestinations.id#" name="destination_id"
                  <cfif parameterexists(url.id) and Find(getDestinations.id,valuelist(getnodeid.nodeid))>checked="checked"</cfif>>
                #name#
              </label>
            </cfloop>

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
          <label class="control-label">Latitude</label>
          <div class="controls">
            <input type="text" name="latitude" <cfif parameterexists(id)>value="#getinfo.latitude#"</cfif>>
          </div>
        </div>
        
        
        <div class="control-group">
          <label class="control-label">Longitude</label>
          <div class="controls">
            <input type="text" name="longitude" <cfif parameterexists(id)>value="#getinfo.longitude#"</cfif>>
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