<cfset page.title ="Home Page Announcements">

<cfquery name="getinfo" dataSource="#application.dsn#">
  select * from cms_homepage_announcements order by createdAt desc
</cfquery>

<cfinclude template="/admin/components/header.cfm">  

<cfif isdefined('url.success')>
  <div class="alert alert-success">
    <button class="close" data-dismiss="alert">×</button>
    <strong>Review approved</strong>
  </div>
</cfif>

<cfif isdefined('url.delete')>
  <div class="alert alert-success">
    <button class="close" data-dismiss="alert">×</button>
    <strong>Review deleted</strong>
  </div>
</cfif>

<p><a href="form.cfm" class="btn btn-success"><i class="icon-plus icon-white"></i> Add New</a></p>

<div class="widget-box">
  <div class="widget-title">
    <span class="icon">
      <i class="icon-th"></i>
    </span>  
  	<h5><cfoutput>#page.title#</cfoutput></h5>
  </div>
  <div class="widget-content nopadding">
    <table class="table table-bordered table-striped">
    <tr>
      <th>No.</th>
      <th>Title</th>         
      <th>Start Date</th> 
	  <th>End Date</th> 
	  <th>Active</th> 
      <th></th>
      <th></th>
    </tr>        
    <cfoutput query="getinfo">
      <tr>
        <td width="45">#currentrow#.</td>
        <td>#title#</td> 
        <td width="80">#dateformat(start_date,'mm/dd/yyyy')#</td>           
		<td width="80">#dateformat(end_date,'mm/dd/yyyy')#</td> 
      <td width="80">#active#</td> 
        <td width="50"><a href="form.cfm?id=#id#" class="btn btn-mini btn-primary"><i class="icon-pencil icon-white"></i> Edit</a></td>
        <td width="65"><a href="submit.cfm?id=#id#&delete"  data-confirm="Are you sure you want to delete this entry?" class="btn btn-mini btn-danger"><i class="icon-remove icon-white"></i> Delete</a></td>           
      </tr>
     
    </cfoutput>
    </table>
  </div>
</div>

<cfinclude template="/admin/components/footer.cfm">