<cfset page.title ="Guest Loyalty Point Levels">

<cfquery name="getinfo" dataSource="#application.dsn#">
  select * from guest_loyalty_point_levels order by points
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
</p>

<p>
	Use this module to list out all the rewards a user is eligible for with X number of points.
</p>

<cfif getinfo.recordcount gt 0>
<div class="widget-box">
  <div class="widget-content nopadding">
    <table class="table table-bordered table-striped">
    <tr>
      <th>No.</th>
      <th>Title</th>
      <th>Points</th>         
      <th></th>
      <th></th>  
    </tr>      
    <cfoutput query="getinfo">
      <tr>
        <td>#currentrow#.</td>
        <td>#title#</td> 
        <td>#points#</td>                    
        <td width="50"><a href="form.cfm?id=#id#" class="btn btn-mini btn-primary"><i class="icon-pencil icon-white"></i> Edit</a></td>
        <td width="65"><a href="submit.cfm?id=#id#&delete"  data-confirm="Are you sure you want to delete this point level?" class="btn btn-mini btn-danger"><i class="icon-remove icon-white"></i> Delete</a></td>      
      </tr>
    </cfoutput>
    </table>
  </div>
</div>
</cfif>

<cfinclude template="/admin/components/footer.cfm">