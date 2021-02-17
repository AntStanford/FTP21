<cfif isdefined('url.id')>
  
  <cfquery name="getinfo" dataSource="#application.dsn#">
    select * from ads where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
  </cfquery>

</cfif>


<cfquery name="GetPages" dataSource="#application.dsn#">
  select * from cms_pages where parentID = 0 and showInAdmin = 'Yes' and slug <> 'page-not-found' and slug <> 'error' order by name
</cfquery>


<cfset page.title ="Ads">
<cfinclude template="/admin/components/header.cfm">


<cfoutput>

<cfif isdefined('url.success') and isdefined('url.id')>
  <div class="alert alert-success">
    <button class="close" data-dismiss="alert">×</button>
    <strong>Update successful!</strong> Continue editing this ad or <a href="index.cfm">go back.</a>
  </div>
<cfelseif isdefined('url.success')>
  <div class="alert alert-success">
    <button class="close" data-dismiss="alert">×</button>
    <strong>Success!</strong> Add another ad or <a href="index.cfm">go back.</a>
  </div>
<cfelseif isdefined('url.deletephoto')>
  <div class="alert alert-success">
    <button class="close" data-dismiss="alert">×</button>
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
				<label class="control-label">Show On Page</label>
				<div class="controls">
           <select name="ShowOnPage" style="width:800px;">
				<option value="" SELECTED>-- Select A Page --</option>
				<cfloop query="GetPages">
				<option value="#slug#" <cfif isdefined('url.id') and  slug is "#getinfo.showonpage#">selected</cfif>>#name# - /#slug#</option>
				</cfloop>
			</select>
        </div>
			</div>	
    
      <div class="control-group">
				<label class="control-label">Name</label>
				<div class="controls">
          <input class="sluggable" maxlength="255" name="name" type="text" <cfif parameterexists(id)>value="#getinfo.name#"</cfif> />
        </div>
			</div>	
			
	 <div class="control-group">
            <label class="control-label">Link</label>
            <div class="controls">
               <input maxlength="255" name="Link" type="text" <cfif parameterexists(id)>value="#getinfo.Link#"</cfif> /> Ex: http://www.domain.com
            </div>
         </div>
		 
		 <div class="control-group">
            <label class="control-label">Coupon Code</label>
            <div class="controls">
               <input maxlength="255" name="CouponCode" type="text" <cfif parameterexists(id)>value="#getinfo.CouponCode#"</cfif> /> 
            </div>
         </div>
	        
         
         <div class="control-group">
            <label class="control-label">Start Date</label>
            <div class="controls">
               <input type="text" class="datepicker" name="time_start" <cfif parameterexists(id)>value="#dateformat(getinfo.time_start,'mm/dd/yyyy')#"</cfif>>            
            </div>
         </div>
         
         <div class="control-group">
            <label class="control-label">End Date</label>
            <div class="controls">
               <input type="text" class="datepicker" name="time_end" <cfif parameterexists(id)>value="#dateformat(getinfo.time_end,'mm/dd/yyyy')#"</cfif>>            
            </div>
         </div>
             
               
    
      <div class="control-group">
				<label class="control-label">Details</label>
				<div class="controls">

          <textarea id="txtContent" name="details" rows="4" cols="30">
             <cfif parameterexists(id)>#getinfo.details#</cfif>
          </textarea>
          
          
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
            <img src="/images/ads/#getinfo.photo#">
            <br /><br /><a href="submit.cfm?id=#id#&deletephoto" class="btn btn-danger" data-confirm="Are you sure you want to delete this photo?"><i class="icon-remove icon-white"></i> Delete</a> 
          </li>
          
          </ul>
          
          </div>
          </div>
      </cfif>
      
      
			
		  <div class="form-actions">       
          <input type="submit" value="Submit" id="btnSave" class="btn btn-primary" />
          <cfif parameterexists(id)><input type="hidden" name="id" value="#url.id#"></cfif>
        </div>
			
    </form>
  
  </div>
  
</div>

</cfoutput>

<cfinclude template="/admin/components/footer.cfm">

