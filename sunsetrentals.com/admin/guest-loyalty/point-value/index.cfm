<cfset page.title ="Guest Loyalty Point Value">
<cfset module = 'Guest Loyalty Point Value'>
<cfinclude template="/admin/components/header.cfm">  

 

  <cfquery name="getinfo" dataSource="#application.dsn#">
    select * from guest_loyalty_point_value where id = 1
  </cfquery>


<cfoutput>

  <cfif isdefined('url.success') and isdefined('url.id')>
    <div class="alert alert-success">
      <button class="close" data-dismiss="alert">×</button>
      <strong>Update successful!</strong> 
    </div>
  </cfif>
  
  <div class="widget-box">
    <div class="widget-title">
      <span class="icon">
        <i class="icon-th"></i>
      </span>
      <h5>Edit Form</h5>
    </div>
    <div class="widget-content nopadding">
  
      <form action="submit.cfm" method="post" class="form-horizontal" enctype="multipart/form-data">
         
         <div class="control-group">         	
         	<div class="controls">
         		<p>This is the number of points a guest will earn for every number of nights booked.</p>
         	</div>
			</div>
			
         <div class="control-group">
            <label class="control-label">Point Value</label>
            <div class="controls">
               <input maxlength="255" name="PointValue" type="text" <cfif parameterexists(id)>value="#trim(numberformat(getinfo.PointValue,'___.__'))#"</cfif> style="width:100px" />
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

