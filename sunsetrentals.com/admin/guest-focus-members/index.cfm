<cfset page.title ="Guest Focus Users">

<cfquery name="getinfo" dataSource="#application.dsn#">
  select * from guest_focus_users order by createdat desc
</cfquery>

<cfinclude template="/admin/components/header.cfm">

<cfif isdefined('url.success')>
  <div class="alert alert-success">
    <button class="close" data-dismiss="alert">×</button>
    <strong>Record deleted!</strong>
  </div>
</cfif>

<p>
  <a href="form.cfm" class="btn btn-success"><i class="icon-plus icon-white"></i> Add New</a>
  <cfif getinfo.recordcount gt 0>
    <a href="export.cfm" class="btn btn-primary"><i class="icon-file icon-white"></i> Download Users (XLS)</a>
  </cfif>
</p>

<cfif getinfo.recordcount gt 0>
<div class="widget-box">
  <div class="widget-content nopadding">
    <table class="table table-bordered table-striped">
    <tr>
      <th>No.</th>
      <th>Name</th>
      <th>Email</th>         
      <th></th>
      <th></th>  
	   <cfif settings.hasGuestLoyalty eq 'yes'> 
	  		<th></th>  
	  	</cfif>  
    </tr>      
    <cfoutput query="getinfo">
      <tr>
        <td>#currentrow#.</td>
        <td>#firstname# #lastname#</td> 
        <td>#email#</td>                    
        <td width="50"><a href="form.cfm?id=#id#" class="btn btn-mini btn-primary"><i class="icon-pencil icon-white"></i> Edit</a></td>
        <td width="65"><a href="submit.cfm?id=#id#&delete"  data-confirm="Are you sure you want to delete this user?" class="btn btn-mini btn-danger"><i class="icon-remove icon-white"></i> Delete</a></td>    
		  <cfif settings.hasGuestLoyalty eq 'yes'>
	     		<td width="100"><a href="view-points.cfm?id=#id#&email=#email#" class="btn btn-mini btn-warning"><i class="icon-zoom-in icon-white"></i> View Points</a></td>    
	     </cfif>      
	   </tr>
    </cfoutput>
    </table>
  </div>
</div>
</cfif>

<cfinclude template="/admin/components/footer.cfm">